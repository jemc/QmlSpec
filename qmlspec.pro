
TEMPLATE = lib

CONFIG += plugin
QT += qml quick

uri = QmlSpec

DESTDIR  = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
SRCDIR   = $$PWD/src

qmldir.files = $$PWD/qmldir
qmldir.path  = $$DESTDIR

# Copy the qmldir and qml implementation directory
copyqml.commands = $(COPY_DIR) $$SRCDIR/qml $$DESTDIR/ && \
                   $$QMAKE_COPY $$SRCDIR/qmldir $$DESTDIR/
first.depends = $(first) copyqml
export(first.depends)
export(copyqml.commands)
QMAKE_EXTRA_TARGETS += first copyqml
