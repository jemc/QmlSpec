
import QtQuick 2.1

import QmlSpec 1.0


Item {
  property alias target:                   priv.target
  property alias signalName:               priv.signalName
  
  readonly property alias valid:           priv.valid
  readonly property alias count:           priv.count
  readonly property alias signalArguments: priv.signalArguments
  
  function clear() { return priv.clear() }
  function wait()  { return priv.wait() }
  
  onTargetChanged:     priv.updateConnection()
  onSignalNameChanged: priv.updateConnection()
  
  ///
  // Private API
  
  Item {
    id: priv
    
    property var target
    property string signalName
    
    property bool valid: false
    property int count: 0
    property var signalArguments: []
    
    property var signal
    property var expectedCount: 0
    
    function clear() {
      count = 0
      priv.expectedCount = 0
      signalArguments = []
    }
    
    function wait(timeout) {
      timeout = timeout || 5000
      
      priv.expectedCount += 1
      var elapsedTime = 0
      var timeInterval = 15 // Round timeInterval to nearest factor of timeout
      timeInterval = timeout / (1.0 * (timeout / timeInterval))
      
      // Sleep in intervals until the expectedCount is fulfilled
      while(count < priv.expectedCount) {
        QTest.qWait(timeInterval)
        elapsedTime += timeInterval
        
        // Throw a test failure when elpasedTime surpasses timeout
        if(elapsedTime >= timeout) throw({
          testResult: 'failure',
          stack: TestUtil.getStack(),
          message: "SignalSpy timed out at %1ms waiting for %2 to emit '%3'"
                     .arg(elapsedTime).arg(target).arg(signalName),
        })
      }
    }
    
    function updateConnection() {
      valid = false
      
      // Remove the old signal connection
      if(signal)
        signal.disconnect(listener)
      
      // Connect to new signal
      signal = target && target[signalName]
      if(signal && typeof signal.connect === 'function') {
        signal.connect(listener)
        valid = true
      }
      else {
        signal = undefined
      }
    }
    
    function listener() {
      signalArguments.push(Array.prototype.slice.call(arguments))
      count += 1
    }
  }
}
