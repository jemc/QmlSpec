
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
  
  Component.onCompleted: TestCaseRegistry.register(root)
  
  property var testRunner
  
  function _run() {
    testRunner.groupBegin({ name: root.name })
    
    var result = true
    
    for(var propName in root)
      if(propName.slice(0, 5) == "test_"
      && typeof root[propName] == 'function')
        result = _runTest(propName, root[propName]) && result
    
    testRunner.groupEnd({ name: root.name })
    return result
  }
  
  function _runTest(testName, testFunction) {
    testRunner.testBegin({ name: testName })
    
    try { testFunction() }
    catch(exc) {
      exc.name = testName
      if     (exc.testResult === 'failure') testRunner.testFailure(exc)
      else if(exc.testResult === 'pending') testRunner.testPending(exc)
      else                                  testRunner.testError(exc)
      return false
    }
    
    testRunner.testSuccess({ name: testName })
    return true
  }
  
  function _getStack(skipLevels) {
    skipLevels = skipLevels || 1
    try      { _getStack.missingMethod() }
    catch(e) { return e.stack.split("\n").slice(skipLevels).join("\n") }
  }
}
