
import QtQuick 2.1

import QmlSpec 1.0


Item {
  id: root
  
  signal suiteBegin(variant suite)
  signal suiteEnd(variant suite)
  
  signal groupBegin(variant group)
  signal groupEnd(variant group)
  
  signal testBegin(variant test)
  signal testSuccess(variant test)
  signal testFailure(variant test)
  signal testErrored(variant test)
  signal testSkipped(variant test)
  
  function inspect(obj) { return TestUtil.inspect(obj) }
}
