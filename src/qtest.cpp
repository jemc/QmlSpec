
#include <QtQml>

#include "qtest.h"
#include "qtest_attached.h"


QObject* QmlSpec_QTest::qmlAttachedProperties(QObject* object)
{
    return new QmlSpec_QTestAttached(object);
}
