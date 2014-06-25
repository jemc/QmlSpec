
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
  
  function fail(message) {
    message = message || ""
    
    throw({
      testResult: 'failure',
      actual: undefined,
      expected: undefined,
      message: message,
      stack: _getStack()
    })
  }
  
  function skip(message) {
    message = message || ""
    
    throw({
      testResult: 'skip',
      message: message,
      stack: _getStack()
    })
  }
  
  function wait(ms)  { QTest.qWait(ms) }
  function sleep(ms) { QTest.qSleep(ms) }
  
  ///
  // Private API
  
  Component.onCompleted: TestGroupRegistry.register(root)
  
  property var testReporter
  
  function _run() {
    testReporter.groupBegin({ name: root.name })
    
    var result = true
    
    var noData = function() { return [undefined] }
    var beforeAll = _detectFunction(root['beforeAll'], root['initTestCase'])
    var afterAll  = _detectFunction(root['afterAll'],  root['cleanupTestCase'])
    
    _runTest("beforeAll", beforeAll, noData, true)
    
    for(var propName in root) {
      if(propName.slice(0, 5) === "test_"
      && propName.slice(propName.length-5, propName.length) !== "_data"
      && 'function' === typeof root[propName]) {
        var testDataFunction = _detectFunction(
          root[propName+'_data'],
          root['init_data'],
          function() { return [undefined] }
        )
        result = _runTest(propName, root[propName], testDataFunction) && result
      }
    }
    
    _runTest("afterAll", afterAll, noData, true)
    
    testReporter.groupEnd({ name: root.name })
    return result
  }
  
  function _runTest(testName, testFunction, testDataFunction, dontSurround) {
    testReporter.testBegin({ name: testName })
    
    var dataRow
    var returnValue
    
    try {
      var dataRows = testDataFunction()
      
      for(var i in dataRows) {
        dataRow = dataRows[i]
        
        var before = _detectFunction(root['before'], root['init'])
        var after  = _detectFunction(root['after'],  root['cleanup'])
        
        if(!dontSurround) before()
        returnValue = testFunction(dataRow)
        if(!dontSurround) after()
      }
    }
    catch(exc) {
      var info = {}
      var infoKeys = Object.getOwnPropertyNames(exc)
      for(var i in infoKeys) info[infoKeys[i]] = exc[infoKeys[i]]
      info.name    = testName
      info.dataRow = dataRow
      
      if     (info.testResult === 'failure') testReporter.testFailure(info)
      else if(info.testResult === 'skip')    testReporter.testSkipped(info)
      else                                   testReporter.testErrored(info)
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
  
  // Return the first object in the passed arguments that is a function.
  // If no function was found, return a new empty function.
  function _detectFunction() {
    var args = Array.prototype.slice.apply(arguments)
    for(var i in args)
      if('function' === typeof args[i])
        return args[i]
    
    return function() { }
  }
}
