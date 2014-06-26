
import QtQuick 2.1
import QmlSpec 1.0


Item {
  
  TestCase {
    name: "SignalSpy#wait"
    
    Timer {
      id: timer
      interval: 30
      
      property var count: 0
      signal foo(int a, int b, int c)
      onTriggered: { foo(count+1, count+2, count+3); count += 3 }
    }
    
    SignalSpy {
      id: spy
      target: timer
      signalName: 'foo'
    }
    
    function test_wait(data) {
      spy.clear()
      timer.start(); spy.wait()
      compare(spy.signalArguments, [[1,2,3]])
      timer.start(); spy.wait()
      compare(spy.signalArguments, [[1,2,3],[4,5,6]])
    }
  }
  
}
