
import QtQuick 2.1
import QmlSpec 1.0

import QtQuick.Window 2.1


Item {
  
  TestCase {
    name: "TestGroup visual"
    
    Rectangle {
      id: rectangle
      width:  100
      height: 100
      color: Qt.rgba(red/255.0, green/255.0, blue/255.0, alpha/255.0)
      
      property var alpha: 255
      property var red:   100
      property var green: 150
      property var blue:  200
    }
    
    function test_grabImage() {
      QTest.qWaitForWindowExposed(rectangle) // TODO: remove and use windowShown
      
      var image = grabImage(rectangle)
      compare(image.alpha(50,50), rectangle.alpha)
      compare(image.red  (50,50), rectangle.red)
      compare(image.green(50,50), rectangle.green)
      compare(image.blue (50,50), rectangle.blue)
      compare(image.pixel(50,50), rectangle.color)
    }
  }
  
}
