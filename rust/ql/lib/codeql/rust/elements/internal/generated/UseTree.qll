// generated by codegen, do not edit
/**
 * This module provides the generated definition of `UseTree`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
import codeql.rust.elements.Path
import codeql.rust.elements.Rename
import codeql.rust.elements.UseTreeList

/**
 * INTERNAL: This module contains the fully generated definition of `UseTree` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::UseTree` class directly.
   * Use the subclass `UseTree`, where the following predicates are available.
   */
  class UseTree extends Synth::TUseTree, AstNodeImpl::AstNode {
    override string getAPrimaryQlClass() { result = "UseTree" }

    /**
     * Gets the path of this use tree, if it exists.
     */
    Path getPath() {
      result = Synth::convertPathFromRaw(Synth::convertUseTreeToRaw(this).(Raw::UseTree).getPath())
    }

    /**
     * Holds if `getPath()` exists.
     */
    final predicate hasPath() { exists(this.getPath()) }

    /**
     * Gets the rename of this use tree, if it exists.
     */
    Rename getRename() {
      result =
        Synth::convertRenameFromRaw(Synth::convertUseTreeToRaw(this).(Raw::UseTree).getRename())
    }

    /**
     * Holds if `getRename()` exists.
     */
    final predicate hasRename() { exists(this.getRename()) }

    /**
     * Gets the use tree list of this use tree, if it exists.
     */
    UseTreeList getUseTreeList() {
      result =
        Synth::convertUseTreeListFromRaw(Synth::convertUseTreeToRaw(this)
              .(Raw::UseTree)
              .getUseTreeList())
    }

    /**
     * Holds if `getUseTreeList()` exists.
     */
    final predicate hasUseTreeList() { exists(this.getUseTreeList()) }
  }
}
