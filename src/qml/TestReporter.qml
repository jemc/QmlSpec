
import QtQuick 2.1


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
  
  function inspect(obj) {
    var type = typeof obj
    
    if     (type === 'boolean')   return JSON.stringify(obj)
    else if(type === 'undefined') return 'undefined'
    else if(type === 'number')    return JSON.stringify(obj)
    else if(type === 'string')    return JSON.stringify(obj)
    else if(type === 'object')    return JSON.stringify(obj)
    else return "TestReporter#inspect needs a handler for type '%1'".arg(type)
  }
  
}
