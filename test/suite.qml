
import QtQuick 2.1
import QmlSpec 1.0


TestSuite {
  name: "Main Suite"
  
  testFiles: [
    Qt.resolvedUrl("tst_TestUtil.qml"),
    Qt.resolvedUrl("tst_TestGroup.qml"),
    Qt.resolvedUrl("tst_SignalSpy.qml"),
  ]
  
  Component.onCompleted: { failSuite.run(); run() }
  onFinished: quit()
  
  TestSuite {
    id: failSuite
    name: "FAIL Suite"
    
    testFiles: [
      Qt.resolvedUrl("tst_TestCase.qml"),
    ]
  }
}
