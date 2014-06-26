
import QtQuick 2.1

import QmlSpec 1.0


Item {
  id: root
  
  property var name: String(root)
  
  property var testFiles: []
  property var testComponents: []
  
  property var testReporter: TestReporterConsole { }
  property var testRunner: TestRunner { }
  
  
  signal finished()
  
  function run() {
    // Gather testComponents and testFiles into allTestComponents
    var allTestComponents = testComponents.slice(0)
    for(var i in testFiles)
      allTestComponents.push(Qt.createComponent(testFiles[i]))
    
    try {
      testReporter.suiteBegin({ name: root.name })
      
      for(var i in allTestComponents) {
        var testComponent = allTestComponents[i]
        var testObjectParent = root
        
        // Fill these with anonymous functions that can be connected to signals
        var createTestObjects
        var runTestObjects
        
        // Call runTestObjects() as soon as the Component is ready
        createTestObjects = function() {
          if (testComponent.status == Component.Ready) {
            runTestObjects()
          } 
          else if (testComponent.status == Component.Loading) {
            testComponent.statusChanged.connect(createTestObjects)
          } 
          else if (testComponent.status == Component.Error) {
            console.log("Error loading testComponent:",
                        testComponent.errorString())
          }
        }
        
        // Create the instance from the Component and run tests
        runTestObjects = function() {
          TestGroupRegistry.clear()
          var toplevel = testComponent.createObject(testObjectParent, {})
          var testGroups = TestGroupRegistry.testGroups.slice(0)
          TestGroupRegistry.clear()
          
          for(var j = testGroups.length - 1; j >= 0; j--) {
            var testGroup = testGroups[j]
            testRunner.reporter = testReporter
            testRunner.tests = testGroup
            testRunner.run()
          }
        }
        
        createTestObjects()
      }
      
      testReporter.suiteEnd({ name: root.name })
    }
    catch(exc) {
      console.error("ERROR in TestSuite#run: %1\n%2".arg(exc).arg(exc.stack))
      quit()
    }
    
    finished()
  }
  
  function quit() {
    quitTimer.start()
  }
  
  // This is an ugly hack, here because
  // Qt.quit() does not work if called too soon after creation.
  // This timer will keep trying to quit every millisecond...
  Timer {
    id: quitTimer
    interval: 1
    repeat: true
    onTriggered: Qt.quit()
  }
}
