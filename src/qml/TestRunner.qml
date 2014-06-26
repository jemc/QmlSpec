
import QtQuick 2.1

import QmlSpec 1.0


Item {
  id: root
  
  property var reporter // The current TestReporter object
  property var tests    // The current TestGroup object
  
  function run() {
    reporter.groupBegin({ name: tests.name })
    
    var result = true
    
    var noData = function() { return [undefined] }
    var beforeAll = _detectRootFunction('beforeAll', 'initTestCase')
    var afterAll  = _detectRootFunction('afterAll',  'cleanupTestCase')
    
    if(beforeAll) _runTest(beforeAll, tests[beforeAll], noData, true)
    
    for(var propName in tests) {
      if(propName.slice(0, 5) === "test_"
      && propName.slice(propName.length-5, propName.length) !== "_data"
      && 'function' === typeof tests[propName]) {
        var testDataFunction = // Get relevant data function or make one with...
          tests[_detectRootFunction(propName+'_data', 'init_data')]
          || function() { return [undefined] } // one run of data: undefined
        
        result = _runTest(propName, tests[propName], testDataFunction) && result
      }
    }
    
    if(afterAll) _runTest(afterAll, tests[afterAll], noData, true)
    
    reporter.groupEnd({ name: tests.name })
    return result
  }
  
  ///
  // Private API
  
  function _runTest(testName, testFunction, testDataFunction, dontSurround) {
    reporter.testBegin({ name: testName })
    
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
        
        if     (info.testResult === 'failure') reporter.testFailure(info)
        else if(info.testResult === 'skip')    reporter.testSkipped(info)
        else                                   reporter.testErrored(info)
        return false
      }
      
      if(!dontReportSuccess) {
        reporter.testSuccess({
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
        if(before && !dontSurround) tests[before]()
        returnValue = testFunction(dataRow)
        if(after  && !dontSurround) tests[after]()
      })
    }
    
    return true
  }
  
  // Return the first object in the passed arguments that
  // is a string that references a function on the tests object.
  // If no function was found, return undefined.
  function _detectRootFunction() {
    var args = Array.prototype.slice.apply(arguments)
    for(var i in args)
      if(('string' === typeof args[i])
      && ('function' === typeof tests[args[i]]))
        return args[i]
  }
}
