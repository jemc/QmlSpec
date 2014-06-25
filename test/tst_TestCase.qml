
import QtQuick 2.1
import QmlSpec 1.0

///
// from Qt5 Documentation for TestCase,
// from "Introduction to QML test cases"
TestCase {
  id: test
  name: "MathTests"
  
  function test_math() {
    compare(2 + 2, 4, "2 + 2 = 4")
  }
  
  function test_fail() {
    compare(2 + 2, 5, "2 + 2 = 5")
  }
}
