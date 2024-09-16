// generated by codegen, do not edit
/**
 * This module provides the generated definition of `MatchArmList`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
import codeql.rust.elements.Attr
import codeql.rust.elements.MatchArm

/**
 * INTERNAL: This module contains the fully generated definition of `MatchArmList` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::MatchArmList` class directly.
   * Use the subclass `MatchArmList`, where the following predicates are available.
   */
  class MatchArmList extends Synth::TMatchArmList, AstNodeImpl::AstNode {
    override string getAPrimaryQlClass() { result = "MatchArmList" }

    /**
     * Gets the `index`th arm of this match arm list (0-based).
     */
    MatchArm getArm(int index) {
      result =
        Synth::convertMatchArmFromRaw(Synth::convertMatchArmListToRaw(this)
              .(Raw::MatchArmList)
              .getArm(index))
    }

    /**
     * Gets any of the arms of this match arm list.
     */
    final MatchArm getAnArm() { result = this.getArm(_) }

    /**
     * Gets the number of arms of this match arm list.
     */
    final int getNumberOfArms() { result = count(int i | exists(this.getArm(i))) }

    /**
     * Gets the `index`th attr of this match arm list (0-based).
     */
    Attr getAttr(int index) {
      result =
        Synth::convertAttrFromRaw(Synth::convertMatchArmListToRaw(this)
              .(Raw::MatchArmList)
              .getAttr(index))
    }

    /**
     * Gets any of the attrs of this match arm list.
     */
    final Attr getAnAttr() { result = this.getAttr(_) }

    /**
     * Gets the number of attrs of this match arm list.
     */
    final int getNumberOfAttrs() { result = count(int i | exists(this.getAttr(i))) }
  }
}
