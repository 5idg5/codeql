// generated by codegen, do not edit
/**
 * This module provides the generated definition of `SourceFile`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
import codeql.rust.elements.Attr
import codeql.rust.elements.Item

/**
 * INTERNAL: This module contains the fully generated definition of `SourceFile` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::SourceFile` class directly.
   * Use the subclass `SourceFile`, where the following predicates are available.
   */
  class SourceFile extends Synth::TSourceFile, AstNodeImpl::AstNode {
    override string getAPrimaryQlClass() { result = "SourceFile" }

    /**
     * Gets the `index`th attr of this source file (0-based).
     */
    Attr getAttr(int index) {
      result =
        Synth::convertAttrFromRaw(Synth::convertSourceFileToRaw(this)
              .(Raw::SourceFile)
              .getAttr(index))
    }

    /**
     * Gets any of the attrs of this source file.
     */
    final Attr getAnAttr() { result = this.getAttr(_) }

    /**
     * Gets the number of attrs of this source file.
     */
    final int getNumberOfAttrs() { result = count(int i | exists(this.getAttr(i))) }

    /**
     * Gets the `index`th item of this source file (0-based).
     */
    Item getItem(int index) {
      result =
        Synth::convertItemFromRaw(Synth::convertSourceFileToRaw(this)
              .(Raw::SourceFile)
              .getItem(index))
    }

    /**
     * Gets any of the items of this source file.
     */
    final Item getAnItem() { result = this.getItem(_) }

    /**
     * Gets the number of items of this source file.
     */
    final int getNumberOfItems() { result = count(int i | exists(this.getItem(i))) }
  }
}
