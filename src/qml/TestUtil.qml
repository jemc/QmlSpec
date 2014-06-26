pragma Singleton

import QtQuick 2.1


Item {
  function isQtObject(obj) {
    if (obj !== Object.prototype.constructor(obj))      return false
    if (typeof obj['objectNameChanged'] !== 'function') return false
    return true
  }
  
  function inspect(obj) {
    var type = typeof obj
    
    if(obj  === null)       return 'null'
    if(obj  === undefined)  return 'undefined'
    if(type === 'boolean')  return JSON.stringify(obj)
    if(type === 'number')   return JSON.stringify(obj)
    if(type === 'string')   return JSON.stringify(obj)
    if(type === 'function') return String(obj)
    if(isQtObject(obj))     return String(obj)
    if(type === 'object')   return JSON.stringify(obj)
    return "TestReporter#inspect needs a handler for type '%1'".arg(type)
  }
  
  function compare(a, b) {
    if(!(typeof a === typeof b)) return false
    var type = typeof a
    
    if(a === null)          return (a === b)
    if(a === undefined)     return (a === b)
    if(type === 'boolean')  return (a === b)
    if(type === 'number')   return (a === b)
    if(type === 'string')   return (a === b)
    if(type === 'function') return (a === b)
    if(isQtObject(a))       return (a === b)
    
    var aKeys = []
    var bKeys = []
    for(var key in a) aKeys.push(key)
    for(var key in b) bKeys.push(key)
    
    if(!(aKeys.length === bKeys.length)) return false
    
    for(var key in aKeys)
      if(!compare(a[key], b[key])) return false
      
    return true
  }
  
  function getStack(skipLevels) {
    skipLevels = skipLevels || 0
    skipLevels += 1
    try      { _getStack.missingMethod() }
    catch(e) { return e.stack.split("\n").slice(skipLevels).join("\n") }
  }
  
}
