
import QtQuick 2.1
import QmlSpec 1.0


TestSuite {
  name: "Main Suite"
  
  testComponents: [
    Qt.createComponent("./tst_TestCase.qml")
  ]
  
  Component.onCompleted: run()
  onFinished: quit()
}
