
import QtQuick 2.1
import QmlSpec 1.0


Item {
  property var subject: TestUtil
  
  TestCase {
    name: "TestUtil.isQtObject"
    
    property var qtObj1: QtObject { }
    property var qtObj2: QtObject { }
    
    function test_QtObjects() {
      verify(subject.isQtObject(qtObj1))
      verify(subject.isQtObject(qtObj2))
    }
    
    function test_non_QtObjects() {
      verify(!subject.isQtObject([]))
      verify(!subject.isQtObject({}))
    }
  }
  
  TestCase {
    name: "TestUtil.compare"
    
    function test_booleans() {
      verify(subject.compare(true,true))
      verify(subject.compare(false,false))
      
      verify(!subject.compare(true,false))
    }
    
    function test_nullish() {
      verify(subject.compare(undefined,undefined))
      verify(subject.compare(null,null))
      
      verify(!subject.compare(null,undefined))
      verify(!subject.compare(null,false))
      verify(!subject.compare(undefined,false))
    }
    
    function test_numbers() {
      verify(subject.compare(99,99))
      
      verify(!subject.compare(99,0))
    }
    
    function test_strings() {
      verify(subject.compare("foo","foo"))
      
      verify(!subject.compare("foo","bar"))
      verify(!subject.compare("foo","foobar"))
    }
    
    function test_arrays() {
      verify(subject.compare(  [0],     [0]    ))
      verify(subject.compare(  [0,99],  [0,99] ))
      
      verify(!subject.compare( [0],      0     ))
      verify(!subject.compare(  0,      [0]    ))
      verify(!subject.compare( [0],     [0,99] ))
      verify(!subject.compare( [0,99],  [0]    ))
      verify(!subject.compare( [0,99],  [99,0] ))
      
      var argObj = (function() { return arguments })(1,2,3)
      verify(subject.compare(  [1,2,3], argObj  ))
      verify(subject.compare(  argObj,  [1,2,3] ))
      
      verify(!subject.compare( [1,2,0], argObj  ))
      verify(!subject.compare( argObj,  [0,1,2] ))
    }
    
    function test_objects() {
      verify(subject.compare(  { },             { }             ))
      verify(subject.compare(  {foo:0, bar:99}, {foo:0, bar:99} ))
      verify(subject.compare(  {foo:0, bar:99}, {bar:99, foo:0} ))
      
      verify(!subject.compare( {foo:0, bar:99}, {foo:0}         ))
      verify(!subject.compare( {foo:0},         {foo:0, bar:99} ))
    }
    
    property var qtObj1: QtObject { }
    property var qtObj2: QtObject { }
    
    function test_QtObjects() {
      verify(subject.compare(qtObj1, qtObj1))
      verify(subject.compare(qtObj2, qtObj2))
      verify(!subject.compare(qtObj1, qtObj2))
    }
  }
}
