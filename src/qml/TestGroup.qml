
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
    var beforeAll = _detectRootFunction('beforeAll', 'initTestCase')
    var afterAll  = _detectRootFunction('afterAll',  'cleanupTestCase')
    
    if(beforeAll) _runTest(beforeAll, root[beforeAll], noData, true)
    
    for(var propName in root) {
      if(propName.slice(0, 5) === "test_"
      && propName.slice(propName.length-5, propName.length) !== "_data"
      && 'function' === typeof root[propName]) {
        var testDataFunction = // Get relevant data function or make one with...
          root[_detectRootFunction(propName+'_data', 'init_data')]
          || function() { return [undefined] } // one run of data: undefined
        
        result = _runTest(propName, root[propName], testDataFunction) && result
      }
    }
    
    if(afterAll) _runTest(afterAll, root[afterAll], noData, true)
    
    testReporter.groupEnd({ name: root.name })
    return result
  }
  
  function _runTest(testName, testFunction, testDataFunction, dontSurround) {
    testReporter.testBegin({ name: testName })
    
    var allDataRows
    var dataRow
    var returnValue
    
    var runProtected = function(callable, dontReportSuccess) {
      try { callable() }
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
      
      if(!dontReportSuccess) {
        testReporter.testSuccess({
          name:        testName,
          dataRow:     dataRow,
          returnValue: returnValue
        })
      }
    }
    
    runProtected(function() { allDataRows = testDataFunction() }, true)
    
    for(var i in allDataRows) {
      dataRow = allDataRows[i]
      
      var before = _detectRootFunction('before', 'init')
      var after  = _detectRootFunction('after',  'cleanup')
      
      runProtected(function() {
        if(before && !dontSurround) root[before]()
        returnValue = testFunction(dataRow)
        if(after  && !dontSurround) root[after]()
      })
    }
    
    return true
  }
  
  function _getStack(skipLevels) {
    skipLevels = skipLevels || 1
    try      { _getStack.missingMethod() }
    catch(e) { return e.stack.split("\n").slice(skipLevels).join("\n") }
  }
  
  // Return the first object in the passed arguments that
  // is a string that references a function on the root object.
  // If no function was found, return undefined.
  function _detectRootFunction() {
    var args = Array.prototype.slice.apply(arguments)
    for(var i in args)
      if(('string' === typeof args[i])
      && ('function' === typeof root[args[i]]))
        return args[i]
  }
}
