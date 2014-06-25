
#ifndef QMLSPEC_QTEST_ATTACHED_H
#define QMLSPEC_QTEST_ATTACHED_H

#include <QtQml>
#include <QTest>


class QmlSpec_QTestAttached : public QObject
{
    Q_OBJECT
    
public:
    
    QmlSpec_QTestAttached(QObject* attached)
    { m_attached = attached; };
    
private:
    
    QObject* m_attached = NULL;
    
public slots:
    
    void qWait(int ms)  { QTest::qWait(ms); }
    void qSleep(int ms) { QTest::qSleep(ms); }
};


#endif
