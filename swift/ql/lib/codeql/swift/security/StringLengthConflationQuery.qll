/**
 * Provides a taint-tracking configuration for reasoning about string length
 * conflation vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.StringLengthConflationExtensions

/**
 * A configuration for tracking string lengths originating from a source that
 * is a `String` or an `NSString` object, to a sink of a different kind that
 * expects an incompatible measure of length.
 */
module StringLengthConflationConfig implements DataFlow::StateConfigSig {
  class FlowState = StringType;

  predicate isSource(DataFlow::Node node, FlowState flowstate) {
    flowstate = node.(StringLengthConflationSource).getStringType()
  }

  predicate isSink(DataFlow::Node node, FlowState flowstate) {
    // Permit any *incorrect* flowstate, as those are the results the query
    // should report.
    exists(FlowState correctFlowState |
      correctFlowState = node.(StringLengthConflationSink).getCorrectStringType() and
      flowstate.getEquivClass() != correctFlowState.getEquivClass()
    )
  }

  predicate isBarrier(DataFlow::Node sanitizer) {
    sanitizer instanceof StringLengthConflationSanitizer
  }

  predicate isBarrier(DataFlow::Node sanitizer, FlowState flowstate) { none() }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(StringLengthConflationAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState flowstateFrom, DataFlow::Node nodeTo, FlowState flowStateTo
  ) {
    none()
  }
}

/**
 * Detect taint flow of string lengths originating from a source that is
 * a `String` or an `NSString` object, to a sink of a different kind that
 * expects an incompatible measure of length.
 */
module StringLengthConflationFlow = TaintTracking::GlobalWithState<StringLengthConflationConfig>;
