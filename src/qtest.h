
#ifndef QMLSPEC_QTEST_H
#define QMLSPEC_QTEST_H

#include <QtQml>


class QmlSpec_QTest : public QObject
{
    Q_OBJECT
    
public:
    
    static QObject* qmlAttachedProperties(QObject* object);
};


QML_DECLARE_TYPEINFO(QmlSpec_QTest, QML_HAS_ATTACHED_PROPERTIES)

#endif
