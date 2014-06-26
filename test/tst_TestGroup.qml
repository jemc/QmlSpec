
import QtQuick 2.1
import QmlSpec 1.0


Item {
  
  // Tests for call order of the init and cleanup functions
  // These are the QtTest-compatible versions of the before and after functions
  TestGroup {
    name: "TestGroup#init/#cleanup"
    
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
      testRan += 1
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
    
    function test_init_cleanup_functions_1() { do_test(1) }
    function test_init_cleanup_functions_2() { do_test(2) }
    function test_init_cleanup_functions_3() { do_test(3) }
  }
  
  // Tests for call order of the before and after functions
  // These are the preferred alternative to the init and cleanup functions
  TestGroup {
    name: "TestGroup#before/#after"
    
    property var beforeAllRan: 0
    property var beforeRan: 0
    property var testRan: 0
    property var afterRan: 0
    property var afterAllRan: 0
    
    function beforeAll() {
      beforeAllRan += 1
      compare(beforeAllRan,      1, "beforeAll() should run once")
      compare(beforeRan,         0, "before() should not run yet")
      compare(testRan,           0, "test should not run yet")
      compare(afterRan,          0, "after() should not run yet")
      compare(afterAllRan,       0, "afterAll() should not run yet")
    }
    
    function before() {
      beforeRan += 1
      compare(beforeAllRan,      1, "beforeAll() should run once")
      compare(beforeRan, testRan+1, "before() should before the test")
      compare(afterRan,    testRan, "after() should run once per test")
      compare(afterAllRan,       0, "afterAll() should not run yet")
    }
    
    function do_test(count) {
      testRan += 1
      compare(beforeAllRan,      1, "beforeAll() should run once")
      compare(beforeRan,     count, "before() should run once per test")
      compare(testRan,       count)
      compare(afterRan,    count-1, "after() should run once per test")
      compare(afterAllRan,       0, "afterAll() should not run yet")
    }
    
    function after() {
      afterRan += 1
      compare(beforeAllRan,      1, "beforeAll() should run once")
      compare(beforeRan,   testRan, "before() should run before the test")
      compare(afterRan,    testRan, "after() should run once per test")
      compare(afterAllRan,       0, "afterAll() should not run yet")
    }
    
    function afterAll() {
      afterAllRan += 1
      compare(beforeAllRan,      1, "beforeAll() should run once")
      compare(beforeRan,   testRan, "before() should run once per test")
      compare(afterRan,    testRan, "after() should run once per test")
      compare(afterAllRan,       1, "afterAll() should run once")
    }
    
    Component.onCompleted: {
      compare(afterAllRan, 1, "afterAll() should run once")
    }
    
    function test_before_after_functions_1() { do_test(1) }
    function test_before_after_functions_2() { do_test(2) }
    function test_before_after_functions_3() { do_test(3) }
  }
  
}
