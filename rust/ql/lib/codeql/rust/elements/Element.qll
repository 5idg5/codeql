/**
 * This module provides a hand-modifiable wrapper around the generated class `Element`.
 */

private import codeql.rust.generated.Element

class Element extends Generated::Element {
  predicate isUnknown() { none() } // compatibility with test generation, to be fixed
}
