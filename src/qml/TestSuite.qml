
import QtQuick 2.1

import QmlSpec 1.0


Item {
  id: root
  
  property var name: String(root)
  
  property var testFiles: []
  property var testComponents: []
  
  property var testReporter: TestReporterConsole { }
  property var testRunner: TestRunner { }
  
  
  Loader {
    id: testLoader
    active: false
    
    function load(component) {
      TestGroupRegistry.clear()
      sourceComponent = component
      active = true
    }
    
    function run() {
      var testGroups = TestGroupRegistry.testGroups.slice(0)
      TestGroupRegistry.clear()
      
      for(var j = testGroups.length - 1; j >= 0; j--) {
        var testGroup = testGroups[j]
        testRunner.reporter = testReporter
        testRunner.tests = testGroup
        testRunner.run()
      }
      
      active = false
    }
    
    onStatusChanged: if(status === Loader.Ready) run()
  }
  
  signal finished()
  
  function _runNow() {
    // Gather testComponents and testFiles into allTestComponents
    var allTestComponents = testComponents.slice(0)
    for(var i in testFiles)
      allTestComponents.push(Qt.createComponent(testFiles[i]))
    
    try {
      testReporter.suiteBegin({ name: root.name })
      
      for(var i in allTestComponents) {
        var testComponent = allTestComponents[i]
        testLoader.load(testComponent)
        while(testLoader.active) QTest.qWait(10)
      }
      
      testReporter.suiteEnd({ name: root.name })
    }
    catch(exc) {
      console.error("ERROR in TestSuite#run: %1\n%2".arg(exc).arg(exc.stack))
      quit()
    }
    
    finished()
  }
  
  // Use decouplers to break the stack chain and make the calls nonblocking
  function quit() { quitSignal.trigger() }
  function run()  { runSignal.trigger() }
  SignalDecoupler { id: runSignal;   onTriggered: _runNow() }
  SignalDecoupler { id: quitSignal;  onTriggered: Qt.quit() }
}
