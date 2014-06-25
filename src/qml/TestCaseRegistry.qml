pragma Singleton

import QtQuick 2.1


Item {
  property var testCases: []
  
  function register(testCase) { testCases.push(testCase) }
  function clear()            { testCases.length = 0 }
}
