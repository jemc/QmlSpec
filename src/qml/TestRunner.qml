
import QtQuick 2.1


Item {
  id: root
  
  signal groupBegin(variant group)
  signal groupEnd(variant group)
  
  property var currentGroupName: ""
  
  onGroupBegin: currentGroupName = group.name
  onGroupEnd:   currentGroupName = ""
  
  signal testBegin(variant test)
  signal testSuccess(variant test)
  signal testFailure(variant test)
  // signal testError(variant test)
  // signal testPending(variant test)
  
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
  
  function inspect(obj) {
    var type = typeof obj
    
    if(type == 'number') return JSON.stringify(obj)
    else return "TestRunner#inspect has no handler for type '%1' yet".arg(type)
    return JSON.stringify(obj)
  }
  
}
