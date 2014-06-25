
import QtQuick 2.1


TestRunner {
  id: root
  
  property var currentGroupName: ""
  
  onGroupBegin: currentGroupName = group.name
  onGroupEnd:   currentGroupName = ""
  
  
  onTestSuccess: {
    console.log("PASS   : %1::%2()".arg(currentGroupName).arg(test.name))
  }
  
  onTestFailure: {
    console.log(
      "FAIL!  : %1::%2() %3".arg(currentGroupName).arg(test.name)
                            .arg(test.message)       +"\n"+
      "   Expected : %1".arg(inspect(test.expected)) +"\n"+
      "   Actual   : %1".arg(inspect(test.actual))   +"\n"+
      "   Stack    : " + test.stack.split("\n").join(
    "\n            : "
      )
    )
  }
}
