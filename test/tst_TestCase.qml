
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
  
  // from "Data-driven tests"
  TestCase {
    name: "DataTests"
    
    function init_data() {
      return [
        { tag:"init_data_1", a:1, b:2, answer: 3 },
        { tag:"init_data_2", a:2, b:4, answer: 6 },
      ];
    }
    
    function test_table_data() {
      return [
        { tag: "2 + 2 = 4", a: 2, b: 2, answer: 4 },
        { tag: "2 + 6 = 8", a: 2, b: 6, answer: 8 },
      ]
    }
    
    function test_table(data) {
      //data comes from test_table_data
      compare(data.a + data.b, data.answer)
    }
    
    function test__default_table(data) {
      //data comes from init_data
      compare(data.a + data.b, data.answer)
    }
  }
  
  // Miscellaneous TestCase API capabilities not covered in examples
  TestCase {
    name: "MiscTests"
    
    function test_verify() {
      verify(true, "should pass")
    }
    
    function test_verify_fail() {
      verify(false, "should fail")
    }
  }
  
}
