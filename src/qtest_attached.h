
#ifndef QMLSPEC_QTEST_ATTACHED_H
#define QMLSPEC_QTEST_ATTACHED_H

#include <QtQml>


namespace QmlSpec {
    class QTestAttached : public QObject
    {
        Q_OBJECT
        
    public:
        
        QTestAttached(QObject* attached)
        { m_attached = attached; };
        
    private:
        
        QObject* m_attached = NULL;
        
    public slots:
        
        void qSleep(int ms) {
            QThread::msleep(ms);
        }
        
        void qWait(int ms) {
            QElapsedTimer timer;
            timer.start();
            do {
                QCoreApplication::processEvents(QEventLoop::AllEvents, ms);
                QCoreApplication::sendPostedEvents(0, QEvent::DeferredDelete);
                qSleep(10);
            } while (timer.elapsed() < ms);
        }
    };
}


#endif
