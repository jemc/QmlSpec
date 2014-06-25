
import QtQuick 2.1

import QmlSpec 1.0


Item {
  id: root
  
  property var name: ""
  
  function compare(actual, expected, message) {
    message = message || ""
    
    if(expected !== actual) throw({
      testResult: 'failure',
      actual: actual,
      expected: expected,
      message: message,
      stack: _getStack()
    })
  }
  
  ///
  // Private API
  
  Component.onCompleted: TestGroupRegistry.register(root)
  
  property var testReporter
  
  function _run() {
    testReporter.groupBegin({ name: root.name })
    
    var result = true
    
    for(var propName in root)
      if(propName.slice(0, 5) == "test_"
      && typeof root[propName] == 'function')
        result = _runTest(propName, root[propName]) && result
    
    testReporter.groupEnd({ name: root.name })
    return result
  }
  
  function _runTest(testName, testFunction) {
    testReporter.testBegin({ name: testName })
    
    try { testFunction() }
    catch(exc) {
      var info = {}
      var infoKeys = Object.getOwnPropertyNames(exc)
      for(var i in infoKeys) info[infoKeys[i]] = exc[infoKeys[i]]
      info.name = testName
      
      if     (info.testResult === 'failure') testReporter.testFailure(info)
      else if(info.testResult === 'pending') testReporter.testPending(info)
      else                                   testReporter.testError(info)
      return false
    }
    
    testReporter.testSuccess({ name: testName })
    return true
  }
  
  function _getStack(skipLevels) {
    skipLevels = skipLevels || 1
    try      { _getStack.missingMethod() }
    catch(e) { return e.stack.split("\n").slice(skipLevels).join("\n") }
  }
}
