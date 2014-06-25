
import QtQuick 2.1


TestReporter {
  id: root
  
  property int totalPassed:  0
  property int totalFailed:  0
  property int totalErrored: 0
  property int totalSkipped: 0
  
  onSuiteBegin: {
    console.log("********* Start testing of %1 *********".arg(suite.name))
  }
  
  onSuiteEnd: {
    console.log(
      "Totals: %1 passed, %2 failed, %3 errored, %4 skipped"
        .arg(totalPassed).arg(totalFailed).arg(totalErrored).arg(totalSkipped)
    )
    console.log("********* Finished testing of %1 *********\n".arg(suite.name))
  }
  
  
  property var currentGroupName: ""
  
  onGroupBegin: currentGroupName = group.name
  onGroupEnd:   currentGroupName = ""
  
  
  onTestSuccess: {
    totalPassed += 1
    var rowText = test.dataRow === undefined ? "" : inspect(test.dataRow)
    console.log(
      "PASS   : %1::%2(%3)".arg(currentGroupName).arg(test.name)
                           .arg(rowText)
    )
  }
  
  onTestFailure: {
    totalFailed += 1
    var rowText = test.dataRow === undefined ? "" : inspect(test.dataRow)
    console.log(
      "FAIL!  : %1::%2(%3) %4".arg(currentGroupName).arg(test.name)
                              .arg(rowText).arg(test.message) +"\n"+
      "   Actual   : %1".arg(inspect(test.actual))            +"\n"+
      "   Expected : %1".arg(inspect(test.expected))          +"\n"+
      "   Stack    : " + test.stack.split("\n").join(
    "\n            : "
      )
    )
  }
  
  onTestErrored: {
    totalErrored += 1
    var rowText = test.dataRow === undefined ? "" : inspect(test.dataRow)
    console.log(
      "ERROR! : %1::%2(%3)".arg(currentGroupName).arg(test.name)
                           .arg(rowText)            +"\n"+
      "   Message  : %1".arg(inspect(test.message)) +"\n"+
      "   Stack    : " + test.stack.split("\n").join(
    "\n            : "
      )
    )
  }
  
  onTestSkipped: {
    totalSkipped += 1
    var rowText = test.dataRow === undefined ? "" : inspect(test.dataRow)
    console.log(
      "SKIP   : %1::%2(%3) %4".arg(currentGroupName).arg(test.name)
                              .arg(rowText).arg(test.message) +"\n"+
      "   Location : " + test.stack.split("\n")[1]
    )
  }
}
