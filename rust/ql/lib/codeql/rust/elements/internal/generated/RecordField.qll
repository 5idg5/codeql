// generated by codegen, do not edit
/**
 * This module provides the generated definition of `RecordField`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
import codeql.rust.elements.Attr
import codeql.rust.elements.Name
import codeql.rust.elements.TypeRef
import codeql.rust.elements.Visibility

/**
 * INTERNAL: This module contains the fully generated definition of `RecordField` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::RecordField` class directly.
   * Use the subclass `RecordField`, where the following predicates are available.
   */
  class RecordField extends Synth::TRecordField, AstNodeImpl::AstNode {
    override string getAPrimaryQlClass() { result = "RecordField" }

    /**
     * Gets the `index`th attr of this record field (0-based).
     */
    Attr getAttr(int index) {
      result =
        Synth::convertAttrFromRaw(Synth::convertRecordFieldToRaw(this)
              .(Raw::RecordField)
              .getAttr(index))
    }

    /**
     * Gets any of the attrs of this record field.
     */
    final Attr getAnAttr() { result = this.getAttr(_) }

    /**
     * Gets the number of attrs of this record field.
     */
    final int getNumberOfAttrs() { result = count(int i | exists(this.getAttr(i))) }

    /**
     * Gets the name of this record field, if it exists.
     */
    Name getName() {
      result =
        Synth::convertNameFromRaw(Synth::convertRecordFieldToRaw(this).(Raw::RecordField).getName())
    }

    /**
     * Holds if `getName()` exists.
     */
    final predicate hasName() { exists(this.getName()) }

    /**
     * Gets the ty of this record field, if it exists.
     */
    TypeRef getTy() {
      result =
        Synth::convertTypeRefFromRaw(Synth::convertRecordFieldToRaw(this).(Raw::RecordField).getTy())
    }

    /**
     * Holds if `getTy()` exists.
     */
    final predicate hasTy() { exists(this.getTy()) }

    /**
     * Gets the visibility of this record field, if it exists.
     */
    Visibility getVisibility() {
      result =
        Synth::convertVisibilityFromRaw(Synth::convertRecordFieldToRaw(this)
              .(Raw::RecordField)
              .getVisibility())
    }

    /**
     * Holds if `getVisibility()` exists.
     */
    final predicate hasVisibility() { exists(this.getVisibility()) }
  }
}
