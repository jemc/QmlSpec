
#include <QtQml>

#include "qtest.h"
#include "qtest_attached.h"


QObject* QmlSpec::QTest::qmlAttachedProperties(QObject* object)
{
    return new QmlSpec::QTestAttached(object);
}
