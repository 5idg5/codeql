// generated by codegen, do not edit
/**
 * This module provides the generated definition of `TupleField`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
import codeql.rust.elements.Attr
import codeql.rust.elements.TypeRef
import codeql.rust.elements.Visibility

/**
 * INTERNAL: This module contains the fully generated definition of `TupleField` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::TupleField` class directly.
   * Use the subclass `TupleField`, where the following predicates are available.
   */
  class TupleField extends Synth::TTupleField, AstNodeImpl::AstNode {
    override string getAPrimaryQlClass() { result = "TupleField" }

    /**
     * Gets the `index`th attr of this tuple field (0-based).
     */
    Attr getAttr(int index) {
      result =
        Synth::convertAttrFromRaw(Synth::convertTupleFieldToRaw(this)
              .(Raw::TupleField)
              .getAttr(index))
    }

    /**
     * Gets any of the attrs of this tuple field.
     */
    final Attr getAnAttr() { result = this.getAttr(_) }

    /**
     * Gets the number of attrs of this tuple field.
     */
    final int getNumberOfAttrs() { result = count(int i | exists(this.getAttr(i))) }

    /**
     * Gets the ty of this tuple field, if it exists.
     */
    TypeRef getTy() {
      result =
        Synth::convertTypeRefFromRaw(Synth::convertTupleFieldToRaw(this).(Raw::TupleField).getTy())
    }

    /**
     * Holds if `getTy()` exists.
     */
    final predicate hasTy() { exists(this.getTy()) }

    /**
     * Gets the visibility of this tuple field, if it exists.
     */
    Visibility getVisibility() {
      result =
        Synth::convertVisibilityFromRaw(Synth::convertTupleFieldToRaw(this)
              .(Raw::TupleField)
              .getVisibility())
    }

    /**
     * Holds if `getVisibility()` exists.
     */
    final predicate hasVisibility() { exists(this.getVisibility()) }
  }
}
