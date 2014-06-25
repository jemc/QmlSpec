
import QtQuick 2.1


Item {
  id: root
  
  property var name: ""
  
  property var testComponents
  
  property var testRunner: TestRunnerConsole { }
  
  
  signal finished()
  
  function run() {
    try {
      testRunner.suiteBegin({ name: root.name })
      
      for(var i in testComponents) {
        var testComponent = testComponents[i]
        var testCaseParent = root
        
        var createTestCase
        createTestCase = function() {
          if (testComponent.status == Component.Ready) {
            return testComponent.createObject(testCaseParent, {})
          } 
          else if (testComponent.status == Component.Loading) {
            testComponent.statusChanged.connect(createTestCase)
          } 
          else if (testComponent.status == Component.Error) {
            console.log("Error loading testComponent:",
                        testComponent.errorString())
          }
        }
        
        var testCase = createTestCase()
        testCase.testRunner = testRunner
        testCase._run()
      }
      
      testRunner.suiteEnd({ name: root.name })
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
