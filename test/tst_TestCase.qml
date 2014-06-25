
import QtQuick 2.1
import QmlSpec 1.0


Item {
  
  // Derived from Qt5 documentation for TestCase
  // from "Introduction to QML test cases"
  TestCase {
    name: "MathTests"
    
    function test_math() {
      compare(2 + 2, 4, "2 + 2 = 4")
    }
    
    function test_fail() {
      compare(2 + 2, 5, "2 + 2 = 5 should fail")
    }
  }
  
  // Derived from Qt5 documentation for TestCase
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
  
  // Tests for call order of the init and cleanup functions
  TestCase {
    name: "InitCleanupTests"
    
    property var initTestCaseRan: 0
    property var initRan: 0
    property var testRan: 0
    property var cleanupRan: 0
    property var cleanupTestCaseRan: 0
    
    function initTestCase() {
      initTestCaseRan += 1
      compare(initTestCaseRan,    1, "initTestCase() should run once")
      compare(initRan,            0, "init() should not run yet")
      compare(testRan,            0, "test should not run yet")
      compare(cleanupRan,         0, "cleanup() should not run yet")
      compare(cleanupTestCaseRan, 0, "cleanupTestCase() should not run yet")
    }
    
    function init() {
      initRan += 1
      compare(initTestCaseRan,    1, "initTestCase() should run once")
      compare(initRan,    testRan+1, "init() should before the test")
      compare(cleanupRan,   testRan, "cleanup() should run once per test")
      compare(cleanupTestCaseRan, 0, "cleanupTestCase() should not run yet")
    }
    
    function do_test(count) {
      testRan += 1; 
      compare(initTestCaseRan,    1, "initTestCase() should run once")
      compare(initRan,        count, "init() should run once per test")
      compare(testRan,        count)
      compare(cleanupRan,   count-1, "cleanup() should run once per test")
      compare(cleanupTestCaseRan, 0, "cleanupTestCase() should not run yet")
    }
    
    function cleanup() {
      cleanupRan += 1
      compare(initTestCaseRan,    1, "initTestCase() should run once")
      compare(initRan,      testRan, "init() should run before the test")
      compare(cleanupRan,   testRan, "cleanup() should run once per test")
      compare(cleanupTestCaseRan, 0, "cleanupTestCase() should not run yet")
    }
    
    function cleanupTestCase() {
      cleanupTestCaseRan += 1
      compare(initTestCaseRan,    1, "initTestCase() should run once")
      compare(initRan,      testRan, "init() should run once per test")
      compare(cleanupRan,   testRan, "cleanup() should run once per test")
      compare(cleanupTestCaseRan, 1, "cleanupTestCase() should run once")
    }
    
    Component.onCompleted: {
      compare(cleanupTestCaseRan, 1, "cleanupTestCase() should run once")
    }
    
    function test_init_functions_1() { do_test(1) }
    function test_init_functions_2() { do_test(2) }
    function test_init_functions_3() { do_test(3) }
  }
  
  // Miscellaneous TestCase API capabilities not covered in other examples
  TestCase {
    name: "MiscTests"
    
    function test_verify() {
      verify(true, "should pass")
    }
    
    function test_verify_fail() {
      verify(false, "should fail")
    }
    
    function test_fail() {
      fail("should fail")
    }
    
    function test_skip() {
      skip("should skip")
    }
  }
  
}
