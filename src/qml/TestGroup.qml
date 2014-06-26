
import QtQuick 2.1

import QmlSpec 1.0


Item {
  id: root
  
  property var name: ""
  
  function compare(actual, expected, message) {
    message = message || ""
    
    if(!TestUtil.compare(actual, expected)) throw({
      testResult: 'failure',
      actual: actual,
      expected: expected,
      message: message,
      stack: TestUtil.getStack()
    })
  }
  
  function verify(condition, message) {
    message = message || ""
    
    if(!condition) throw({
      testResult: 'failure',
      actual: condition,
      expected: true,
      message: message,
      stack: TestUtil.getStack()
    })
  }
  
  function fail(message) {
    message = message || ""
    
    throw({
      testResult: 'failure',
      actual: undefined,
      expected: undefined,
      message: message,
      stack: TestUtil.getStack()
    })
  }
  
  function skip(message) {
    message = message || ""
    
    throw({
      testResult: 'skip',
      message: message,
      stack: TestUtil.getStack()
    })
  }
  
  function wait(ms)  { QTest.qWait(ms) }
  function sleep(ms) { QTest.qSleep(ms) }
  
  // Register with the TestGroupRegistry
  Component.onCompleted: TestGroupRegistry.register(root)
}
