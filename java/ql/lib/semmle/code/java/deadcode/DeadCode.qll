import java
import semmle.code.java.deadcode.DeadEnumConstant
import semmle.code.java.deadcode.DeadCodeCustomizations
import semmle.code.java.deadcode.DeadField
import semmle.code.java.deadcode.EntryPoints

/**
 * Holds if the given callable has any liveness causes.
 */
predicate isLive(Callable c) {
  exists(EntryPoint e | c = e.getALiveCallable())
  or
  exists(Callable live | isLive(live) | live = possibleLivenessCause(c))
}

/**
 * Compute a list of callables such that the liveness of any result
 * would imply the liveness of `c`.
 */
Callable possibleLivenessCause(Callable c, string reason) {
  c.(Method).overridesOrInstantiates(result) and
  reason = "is overridden or instantiated by"
  or
  result.calls(c) and reason = "calls"
  or
  result.callsConstructor(c) and reason = "calls constructor"
  or
  exists(ClassInstanceExpr e | e.getEnclosingCallable() = result |
    e.getConstructor() = c and reason = "constructs"
  )
  or
  c = result.getSourceDeclaration() and c != result and reason = "instantiates"
  or
  c.hasName("<clinit>") and
  reason = "class initialization" and
  exists(RefType clintedType | c = clintedType.getAnAncestor().getACallable() |
    result.getDeclaringType() = clintedType or
    result.getAnAccessedField().getDeclaringType() = clintedType
  )
  or
  c.hasName("<obinit>") and
  reason = "object initialization" and
  result = c.getDeclaringType().getAConstructor()
}

Callable possibleLivenessCause(Callable c) { result = possibleLivenessCause(c, _) }

/**
 * A dead root is not live, and has no liveness causes.
 *
 * Dead roots are reported for dead classes and dead methods to help verify that classes and
 * methods with dependencies are actually dead. A dead class or method may have no dead roots, if
 * it is involved in a dead code cycle.
 */
class DeadRoot extends Callable {
  DeadRoot() {
    not isLive(this) and
    // Not a dead root if there exists at least one liveness cause that is not this method.
    not exists(Callable c | c = possibleLivenessCause(this) and c != this)
  }
}

/**
 * For a dead callable, we identify all the possible dead roots.
 *
 * For dead callables which are either part of dead code cycles, or are only depended upon by
 * callables in dead cycles, there will be no dead roots.
 */
DeadRoot getADeadRoot(Callable c) {
  not isLive(c) and
  (
    result = c or
    result = getADeadRoot(possibleLivenessCause(c))
  )
}

/**
 * A constructor that is only declared to override the public accessibility of
 * the default constructor generated by the compiler.
 */
class SuppressedConstructor extends Constructor {
  SuppressedConstructor() {
    // Must be private or protected to suppress it.
    (
      this.isPrivate()
      or
      // A protected, suppressed constructor only makes sense in a non-abstract class.
      this.isProtected() and not this.getDeclaringType().isAbstract()
    ) and
    // Must be no-arg in order to replace the compiler generated default constructor.
    this.getNumberOfParameters() = 0 and
    // Not the compiler-generated constructor itself.
    not this.isDefaultConstructor() and
    // Verify that there is only one statement, which is the `super()` call. This exists
    // even for empty constructors.
    this.getBody().getNumStmt() = 1 and
    this.getBody().getAStmt().(SuperConstructorInvocationStmt).getNumArgument() = 0 and
    // A constructor that is called is not acting to suppress the default constructor. We permit
    // calls from suppressed and default constructors - in both cases, they can only come from
    // sub-class constructors.
    not exists(Call c |
      c.getCallee().getSourceDeclaration() = this and
      not c.getCaller() instanceof SuppressedConstructor and
      not c.getCaller().(Constructor).isDefaultConstructor()
    ) and
    // If other constructors are declared, then no compiler-generated constructor is added, so
    // this constructor is not acting to suppress the default compiler-generated constructor.
    not exists(Constructor other |
      other = this.getDeclaringType().getAConstructor() and other != this
    )
  }
}

/**
 * A namespace class is one that is used purely as a container for static classes, methods and fields.
 */
class NamespaceClass extends RefType {
  NamespaceClass() {
    this.fromSource() and
    // All members, apart from the default constructor and, if present, a "suppressed" constructor
    // must be static. There must be at least one member apart from the permitted constructors.
    forex(Member m |
      m.getDeclaringType() = this and
      not m.(Constructor).isDefaultConstructor() and
      not m instanceof SuppressedConstructor
    |
      m.isStatic()
    ) and
    // Must only extend other namespace classes, or `Object`.
    forall(RefType r | r = this.getASupertype() |
      r instanceof TypeObject or r instanceof NamespaceClass
    )
  }
}

/**
 * A `ClassOrInterface` type that is from source.
 *
 * This represents the set of classes and interfaces for which we will determine liveness. Each
 * `SourceClassOrInterfacce` will either be a `LiveClass` or `DeadClass`.
 */
library class SourceClassOrInterface extends ClassOrInterface {
  SourceClassOrInterface() { this.fromSource() }
}

/**
 * A source class or interface is live if it fulfills one of the following criteria:
 *
 *  - It, or a sub-class, contains a live callable.
 *  - It contains a live field.
 *  - It is a namespace class and it contains a live nested class.
 *  - It is a whitelisted class.
 *  - It is an annotation class - these are assumed to be always live.
 *  - It is an anonymous class - these classes are dead if and only if the outer method is dead.
 */
class LiveClass extends SourceClassOrInterface {
  LiveClass() {
    exists(Callable c | c.getDeclaringType().getAnAncestor().getSourceDeclaration() = this |
      isLive(c)
    )
    or
    exists(LiveField f | f.getDeclaringType() = this |
      // A `serialVersionUID` field is considered to be a live field, but is
      // not be enough to be make this class live.
      not f instanceof SerialVersionUidField
    )
    or
    // If this is a namespace class, it is live if there is at least one live nested class.
    // The definition of `NamespaceClass` is such, that the nested classes must all be static.
    // Static methods are handled above.
    this instanceof NamespaceClass and
    exists(NestedType r | r.getEnclosingType() = this | r instanceof LiveClass)
    or
    // An annotation on the class is reflectively accessed.
    exists(ReflectiveAnnotationAccess reflectiveAnnotationAccess |
      this = reflectiveAnnotationAccess.getInferredClassType() and
      isLive(reflectiveAnnotationAccess.getEnclosingCallable())
    )
    or
    this instanceof AnonymousClass
    or
    this instanceof WhitelistedLiveClass
    or
    this instanceof AnnotationType
  }
}

/**
 * A class is dead if it is from source, and contains no live callables and no live fields. Nested
 * classes make the outer class live if and only if the outer class is considered to be present for
 * namespace purposes only, and the nested class is static.
 *
 * Nested instance classes require no special handling. If the nested instance class accesses fields
 * or methods on the outer class, then these will already be marked as live fields and methods. If
 * it accesses no methods or fields from the outer, then the nested class can be made static, and
 * moved into another file.
 */
class DeadClass extends SourceClassOrInterface {
  DeadClass() { not this instanceof LiveClass }

  /**
   * Identify all the "dead" roots of this dead class.
   */
  DeadRoot getADeadRoot() { result = getADeadRoot(this.getACallable()) }

  /**
   * Holds if this dead class is only used within the class itself.
   */
  predicate isUnusedOutsideClass() {
    // Accessed externally if any callable in the class has a possible liveness cause outside the
    // class. Only one step is required.
    not exists(Callable c |
      c = possibleLivenessCause(this.getACallable()) and
      not c = this.getACallable()
    )
  }
}

/**
 * A class which is dead, but should be considered as live.
 *
 * This should be used for cases where the class is dead, but should not be removed - for example,
 * because it may be useful in the future. If a class is marked as dead when it is live, the
 * callable or field that makes the class live should be marked as an entry point by either
 * extending `CallableEntryPoint` or `ReflectivelyReadField`, instead of whitelisting the class.
 */
abstract class WhitelistedLiveClass extends RefType { }

/**
 * A method is dead if it is from source, has no liveness causes, is not a compiler generated
 * method and is not a dead method with a purpose, such as a constructor designed to suppress the
 * default constructor.
 */
class DeadMethod extends Callable {
  DeadMethod() {
    this.fromSource() and
    not isLive(this) and
    not this.(Constructor).isDefaultConstructor() and
    // Ignore `SuppressedConstructor`s in `NamespaceClass`es. There is no reason to use a suppressed
    // constructor in other cases.
    not (
      this instanceof SuppressedConstructor and this.getDeclaringType() instanceof NamespaceClass
    ) and
    not (
      this.(Method).isAbstract() and
      exists(Method m | m.overridesOrInstantiates+(this) | isLive(m))
    ) and
    // A getter or setter associated with a live JPA field.
    //
    // These getters and setters are often generated in an ad-hoc way by the developer, which leads to
    // methods that are theoretically dead, but uninteresting. We therefore ignore them, so long as
    // they are "simple".
    not exists(JpaReadField readField | this.getDeclaringType() = readField.getDeclaringType() |
      this.(GetterMethod).getField() = readField or
      this.(SetterMethod).getField() = readField
    )
  }

  /**
   * Holds if this dead method is already within the scope of a dead class.
   */
  predicate isInDeadScope() {
    // We do not need to consider whitelisting because whitelisted classes should not have dead
    // methods reported.
    this.getDeclaringType() instanceof DeadClass
  }

  /**
   * Identify all the "dead" roots of this dead callable.
   */
  DeadRoot getADeadRoot() { result = getADeadRoot(this) }
}

class RootdefCallable extends Callable {
  RootdefCallable() {
    this.fromSource() and
    not this.(Method).overridesOrInstantiates(_)
  }

  Parameter unusedParameter() {
    exists(int i | result = this.getParameter(i) |
      not exists(result.getAnAccess()) and
      not overrideAccess(this, i)
    )
  }

  predicate whitelisted() {
    // Main methods must have a `String[]` argument.
    this instanceof MainMethod
    or
    // Premain methods must have certain arguments.
    this instanceof PreMainMethod
    or
    // Abstract, native and interface methods obviously won't access their own
    // parameters, so don't flag unless we can see an overriding method with
    // a body that also doesn't.
    not hasUsefulBody(this) and
    not exists(Method m | hasUsefulBody(m) | m.overridesOrInstantiates+(this))
    or
    // Methods that are the target of a member reference need to implement
    // the exact signature of the resulting functional interface.
    exists(MemberRefExpr mre | mre.getReferencedCallable() = this)
    or
    this.getAnAnnotation() instanceof OverrideAnnotation
    or
    this.hasModifier("override")
    or
    // Exclude generated callables, such as `...$default` ones extracted from Kotlin code.
    this.isCompilerGenerated()
    or
    // Exclude Kotlin serialization constructors.
    this.(Constructor)
        .getParameterType(this.getNumberOfParameters() - 1)
        .(RefType)
        .hasQualifiedName("kotlinx.serialization.internal", "SerializationConstructorMarker")
  }
}

pragma[nomagic]
private predicate overrideAccess(Callable c, int i) {
  exists(Method m | m.overridesOrInstantiates+(c) | exists(m.getParameter(i).getAnAccess()))
}

/**
 * A predicate to find non-trivial method implementations.
 * (A trivial implementation is either abstract, or it just
 * throws `UnsupportedOperationException` or similar.)
 */
predicate hasUsefulBody(Callable c) {
  exists(c.getBody()) and
  not c.getBody().getAChild() instanceof ThrowStmt
}
