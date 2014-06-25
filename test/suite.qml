
import QtQuick 2.1
import QmlSpec 1.0


TestSuite {
  name: "Main Suite"
  
  testFiles: [
    Qt.resolvedUrl("tst_TestCase.qml")
  ]
  
  Component.onCompleted: run()
  onFinished: quit()
}
