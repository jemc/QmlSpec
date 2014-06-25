
TEMPLATE = lib

CONFIG += plugin
QT += qml quick testlib

TARGET = $$qtLibraryTarget(QmlSpec)
uri = QmlSpec

DESTDIR  = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
SRCDIR   = $$PWD/src
BUILDDIR = $$PWD/build

android {
  VENDORDIR = $$PWD/vendor/prefix/$(TOOLCHAIN_NAME)
  BUILDDIR  = $$PWD/build/$(TOOLCHAIN_NAME)
  QMAKE_LIBDIR += $$VENDORDIR/lib
  QMAKE_INCDIR += $$VENDORDIR/include
}

HEADERS += $$SRCDIR/QmlSpec.h        \
           $$SRCDIR/qtest.h          \
           $$SRCDIR/qtest_attached.h

SOURCES += $$SRCDIR/qtest.cpp

OBJECTS_DIR = $$BUILDDIR/.obj
MOC_DIR     = $$BUILDDIR/.moc
RCC_DIR     = $$BUILDDIR/.rcc
UI_DIR      = $$BUILDDIR/.ui

qmldir.files = $$PWD/qmldir
qmldir.path  = $$DESTDIR

# Copy the qmldir and qml implementation directory
copyqml.commands = $(COPY_DIR) $$SRCDIR/qml $$DESTDIR/ && \
                   $$QMAKE_COPY $$SRCDIR/qmldir $$DESTDIR/
first.depends = $(first) copyqml
export(first.depends)
export(copyqml.commands)
QMAKE_EXTRA_TARGETS += first copyqml
