
import QtQuick 2.1
import QmlSpec 1.0


TestSuite {
  id: mainSuite
  name: "Main Suite"
  
  testFiles: [
    Qt.resolvedUrl("tst_TestUtil.qml"),
    Qt.resolvedUrl("tst_TestGroup.qml"),
    Qt.resolvedUrl("tst_TestGroup_visual.qml"),
    Qt.resolvedUrl("tst_SignalSpy.qml"),
  ]
  
  onFinished: quit()
  
  TestSuite {
    id: failSuite
    name: "FAIL Suite"
    
    testFiles: [
      Qt.resolvedUrl("tst_TestCase.qml"),
    ]
    
    Component.onCompleted: run()
    onFinished: mainSuite.run()
  }
}
