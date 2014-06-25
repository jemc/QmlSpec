pragma Singleton

import QtQuick 2.1


Item {
  property var testGroups: []
  
  function register(testGroup) { testGroups.push(testGroup) }
  function clear()             { testGroups.length = 0 }
}
