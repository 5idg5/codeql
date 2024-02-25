/**
 * Provides classes modeling security-relevant aspects of the `twisted` PyPI package.
 * See https://twistedmatrix.com/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
import experimental.semmle.python.Concepts

/**
 * Provides models for the `twisted` PyPI package.
 * See https://twistedmatrix.com/.
 */
private module Twisted {
  /**
   * The `newConnection` and `existingConnection` functions of `twisted.conch.endpoints.SSHCommandClientEndpoint` class execute command on ssh target server
   */
  class ParamikoExecCommand extends SecondaryCommandInjection {
    ParamikoExecCommand() {
      this =
        API::moduleImport("twisted")
            .getMember("conch")
            .getMember("endpoints")
            .getMember("SSHCommandClientEndpoint")
            .getMember(["newConnection", "existingConnection"])
            .getACall()
            .getParameter(1, "command")
            .asSink()
    }
  }
}
