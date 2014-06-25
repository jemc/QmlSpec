
#include <QQmlExtensionPlugin>
#include <qqml.h>

#include "qtest.h"
#include "qtest_attached.h"


namespace QmlSpec {
  class Plugin : public QQmlExtensionPlugin
  {
      Q_OBJECT
      Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
      
  public:
      void registerTypes(const char *uri)
      {
          qmlRegisterType<QTest>(uri, 1, 0, "QTest");
          qmlRegisterType<QTestAttached>();
      };
  };
};
