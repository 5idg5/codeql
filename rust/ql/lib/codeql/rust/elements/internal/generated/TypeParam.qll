// generated by codegen, do not edit
/**
 * This module provides the generated definition of `TypeParam`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.Attr
import codeql.rust.elements.internal.GenericParamImpl::Impl as GenericParamImpl
import codeql.rust.elements.Name
import codeql.rust.elements.TypeBoundList
import codeql.rust.elements.TypeRef

/**
 * INTERNAL: This module contains the fully generated definition of `TypeParam` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::TypeParam` class directly.
   * Use the subclass `TypeParam`, where the following predicates are available.
   */
  class TypeParam extends Synth::TTypeParam, GenericParamImpl::GenericParam {
    override string getAPrimaryQlClass() { result = "TypeParam" }

    /**
     * Gets the `index`th attr of this type parameter (0-based).
     */
    Attr getAttr(int index) {
      result =
        Synth::convertAttrFromRaw(Synth::convertTypeParamToRaw(this).(Raw::TypeParam).getAttr(index))
    }

    /**
     * Gets any of the attrs of this type parameter.
     */
    final Attr getAnAttr() { result = this.getAttr(_) }

    /**
     * Gets the number of attrs of this type parameter.
     */
    final int getNumberOfAttrs() { result = count(int i | exists(this.getAttr(i))) }

    /**
     * Gets the default type of this type parameter, if it exists.
     */
    TypeRef getDefaultType() {
      result =
        Synth::convertTypeRefFromRaw(Synth::convertTypeParamToRaw(this)
              .(Raw::TypeParam)
              .getDefaultType())
    }

    /**
     * Holds if `getDefaultType()` exists.
     */
    final predicate hasDefaultType() { exists(this.getDefaultType()) }

    /**
     * Gets the name of this type parameter, if it exists.
     */
    Name getName() {
      result =
        Synth::convertNameFromRaw(Synth::convertTypeParamToRaw(this).(Raw::TypeParam).getName())
    }

    /**
     * Holds if `getName()` exists.
     */
    final predicate hasName() { exists(this.getName()) }

    /**
     * Gets the type bound list of this type parameter, if it exists.
     */
    TypeBoundList getTypeBoundList() {
      result =
        Synth::convertTypeBoundListFromRaw(Synth::convertTypeParamToRaw(this)
              .(Raw::TypeParam)
              .getTypeBoundList())
    }

    /**
     * Holds if `getTypeBoundList()` exists.
     */
    final predicate hasTypeBoundList() { exists(this.getTypeBoundList()) }
  }
}
