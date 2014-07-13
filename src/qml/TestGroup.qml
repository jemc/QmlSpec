
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
  
  function grabImage(item) {
    return new (function(qImage) {
      this._grab = function(x, y) { return QTest.grabImagePixel(qImage, x, y) }
      
      this.alpha = function(x, y) { return this._grab(x, y)[0] }
      this.red   = function(x, y) { return this._grab(x, y)[1] }
      this.green = function(x, y) { return this._grab(x, y)[2] }
      this.blue  = function(x, y) { return this._grab(x, y)[3] }
      
      this.pixel = function(x, y) { var pix = this._grab(x, y)
        return Qt.rgba(pix[1]/255.0, pix[2]/255.0, pix[3]/255.0, pix[0]/255.0)
      }
    })(QTest.grabImage(item))
  }
  
  // Register with the TestGroupRegistry
  Component.onCompleted: TestGroupRegistry.register(root)
}
