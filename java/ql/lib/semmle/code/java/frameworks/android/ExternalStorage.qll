/** Provides definitions for working with uses of Android external storage */

import java
private import semmle.code.java.security.FileReadWrite
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

private class ExternalStorageDirSourceModel extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "android.content;Context;true;getExternalFilesDir;(String);;ReturnValue;android-external-storage-dir",
        "android.content;Context;true;getExternalFilesDirs;(String);;ReturnValue;android-external-storage-dir",
        "android.content;Context;true;getExternalCacheDir;();;ReturnValue;android-external-storage-dir",
        "android.content;Context;true;getExternalCacheDirs;();;ReturnValue;android-external-storage-dir",
        "android.os;Environment;false;getExternalStorageDirectory;();;ReturnValue;android-external-storage-dir",
        "android.os;Environment;false;getExternalStoragePublicDirectory;(String);;ReturnValue;android-external-storage-dir",
      ]
  }
}

private predicate externalStorageFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
  DataFlow::localFlowStep(node1, node2)
  or
  exists(ConstructorCall c | c.getConstructedType() instanceof TypeFile |
    node1.asExpr() = c.getArgument(0) and
    node2.asExpr() = c
  )
  or
  node2.asExpr().(ArrayAccess).getArray() = node1.asExpr()
  or
  node2.asExpr().(FieldRead).getField().getInitializer() = node1.asExpr()
}

private predicate externalStorageFlow(DataFlow::Node node1, DataFlow::Node node2) {
  externalStorageFlowStep*(node1, node2)
}

/**
 * Holds if `n` is a node that reads the contents of an external file in Android.
 * This is controlable by third-party applications, so is treated as a remote flow source.
 */
predicate androidExternalStorageSource(DataFlow::Node n) {
  exists(DataFlow::Node externalDir, DirectFileReadExpr read |
    sourceNode(externalDir, "android-external-storage-dir") and
    n.asExpr() = read and
    externalStorageFlow(externalDir, DataFlow::exprNode(read.getFileExpr()))
  )
}
