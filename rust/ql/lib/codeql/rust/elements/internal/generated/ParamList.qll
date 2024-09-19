// generated by codegen, do not edit
/**
 * This module provides the generated definition of `ParamList`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
import codeql.rust.elements.Param
import codeql.rust.elements.SelfParam

/**
 * INTERNAL: This module contains the fully generated definition of `ParamList` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::ParamList` class directly.
   * Use the subclass `ParamList`, where the following predicates are available.
   */
  class ParamList extends Synth::TParamList, AstNodeImpl::AstNode {
    override string getAPrimaryQlClass() { result = "ParamList" }

    /**
     * Gets the `index`th parameter of this parameter list (0-based).
     */
    Param getParam(int index) {
      result =
        Synth::convertParamFromRaw(Synth::convertParamListToRaw(this)
              .(Raw::ParamList)
              .getParam(index))
    }

    /**
     * Gets any of the parameters of this parameter list.
     */
    final Param getAParam() { result = this.getParam(_) }

    /**
     * Gets the number of parameters of this parameter list.
     */
    final int getNumberOfParams() { result = count(int i | exists(this.getParam(i))) }

    /**
     * Gets the self parameter of this parameter list, if it exists.
     */
    SelfParam getSelfParam() {
      result =
        Synth::convertSelfParamFromRaw(Synth::convertParamListToRaw(this)
              .(Raw::ParamList)
              .getSelfParam())
    }

    /**
     * Holds if `getSelfParam()` exists.
     */
    final predicate hasSelfParam() { exists(this.getSelfParam()) }
  }
}
