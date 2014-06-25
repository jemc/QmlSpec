
import QtQuick 2.1
import QmlSpec 1.0

// All TestCases within are derived from Qt5 Documentation for TestCase
// to prove compatibilty with public API of QtTest's TestCase
Item {
  
  // from "Introduction to QML test cases"
  TestCase {
    name: "MathTests"
    
    function test_math() {
      compare(2 + 2, 4, "2 + 2 = 4")
    }
    
    function test_fail() {
      compare(2 + 2, 5, "2 + 2 = 5")
    }
  }
  
}
