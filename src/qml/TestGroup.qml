
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
  
  function verify(condition, message) {
    message = message || ""
    
    if(!condition) throw({
      testResult: 'failure',
      actual: condition,
      expected: true,
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
    
    for(var propName in root) {
      if(propName.slice(0, 5) === "test_"
      && propName.slice(propName.length-5, propName.length) !== "_data"
      && 'function' === typeof root[propName]) {
        var testDataFunction
        if('function' === typeof root['init_data'])
          testDataFunction   =   root['init_data']
        if('function' === typeof root[propName+'_data'])
          testDataFunction   =   root[propName+'_data']
        
        result = _runTest(propName, root[propName], testDataFunction) && result
      }
    }
    
    testReporter.groupEnd({ name: root.name })
    return result
  }
  
  function _runTest(testName, testFunction, testDataFunction) {
    testReporter.testBegin({ name: testName })
    
    var dataRow
    var returnValue
    
    try {
      var dataRows = [undefined] // Run a single test with data: undefined
      if('function' === typeof testDataFunction) dataRows = testDataFunction()
      
      for(var i in dataRows) {
        dataRow = dataRows[i]
        returnValue = testFunction(dataRow)
      }
    }
    catch(exc) {
      var info = {}
      var infoKeys = Object.getOwnPropertyNames(exc)
      for(var i in infoKeys) info[infoKeys[i]] = exc[infoKeys[i]]
      info.name    = testName
      info.dataRow = dataRow
      
      if     (info.testResult === 'failure') testReporter.testFailure(info)
      else if(info.testResult === 'pending') testReporter.testPending(info)
      else                                   testReporter.testError(info)
      return false
    }
    
    testReporter.testSuccess({
      name:        testName,
      dataRow:     dataRow,
      returnValue: returnValue
    })
    return true
  }
  
  function _getStack(skipLevels) {
    skipLevels = skipLevels || 1
    try      { _getStack.missingMethod() }
    catch(e) { return e.stack.split("\n").slice(skipLevels).join("\n") }
  }
}
