
#ifndef QMLSPEC_QTEST_ATTACHED_H
#define QMLSPEC_QTEST_ATTACHED_H

#include <QtQml>
#include <QQuickWindow>
#include <QQuickItem>
#include <QImage>


namespace QmlSpec {
    class QTestAttached : public QObject
    {
        Q_OBJECT
        
    public:
        QTestAttached(QObject* attachee) { Q_UNUSED(attachee); };
        
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
            } while(timer.elapsed() < ms);
        }
        
        bool qWaitForWindowExposed(QQuickItem *item, int timeout = 5000) {
            QQuickWindow* window = item->window();
            if(!window) {
                qWarning() << "qWaitForWindowExposed: Item has no window.";
                return false;
            }
            
            QElapsedTimer timer;
            timer.start();
            while(timer.elapsed() < timeout && !window->isExposed()) {
                QCoreApplication::processEvents(QEventLoop::AllEvents, timeout);
                QCoreApplication::sendPostedEvents(0, QEvent::DeferredDelete);
                qSleep(10);
            }
            return window->isExposed();
        }
        
        QVariant grabImage(QQuickItem *item) {
            if (!item) {
                qWarning() << "Call to grabImage() with undefined target item.";
                return QVariant(); // undefined
            }
            
            QQuickWindow *window = item->window();
            if(!window) {
                qWarning() << "Call to grabImage() before window is available.";
                return QVariant(); // undefined
            }
            
            QImage image = window->grabWindow();
            
            QRectF bounds = QRectF(item->x(), item->y(), item->width(), item->height());
            bounds = bounds.intersected(QRectF(0, 0, image.width(), image.height()));
            return QVariant(image.copy(bounds.toAlignedRect()));
        }
        
        QVariant grabImagePixel(QVariant image, int x, int y) {
            QImage qImage = image.value<QImage>();
            
            QRgb pixel = qImage.pixel(x, y);
            
            QVariantList rgba;
            rgba.append(qAlpha(pixel));
            rgba.append(qRed(pixel));
            rgba.append(qGreen(pixel));
            rgba.append(qBlue(pixel));
            
            return QVariant(rgba);
        }
    };
}


#endif
