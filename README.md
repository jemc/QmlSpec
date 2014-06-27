# QmlSpec

QmlSpec is a replacement for QML's bundled-in unit testing module QtTest.

## Motivation

The author has found QtTest to be rather frustrating when trying to add
alternative reporting or functionality for use cases not foreseen by the 
authors of QtTest.  Much of the code is written in C++, which is harder
to extend from QML-space, and the interface seems to be closely based on
Qt's C++ testing module rather than being redesigned based on the unique
strengths and weaknesses of QML.  Also, Being a part of the Qt framework
it is high in project inertia (for better or for worse), and this makes it
difficult to petition for new functionality or accomodations for new
functionality.

QmlSpec aims to be a drop-in replacement for QtTest, with new features
added and support for extension by other modules or applications.
New users should be able to install the QmlSpec plugin, replace
`import QtTest 1.0` with `import QmlSpec 1.0`, add a `suite.qml`
indexing file to their test suite directory (see examples), and
run their test suit with `qmlscene test/suite.qml` instead of
`qmltestrunner test`.  The user can choose to keep only using the
QtTest-compatible features, or begin using the new features introduced
by `QmlSpec`.  Furthermore, the user can now run their test suite in other
ways, such as in their live application with a graphical reporter.
The user can even write a custom reporter to suite their project's
unique needs.

## Design Goals

* Complete compatibility with QML's QtTest API (TestCase, SignalSpy)
* Implement almost entirely in QML, with the absolute minimum in C++
* Graphical TestReporter that can be run in an application
* Support for user-written TestReporters
* Extensibility accomodations for unforseen use cases

## Contributing

QmlSpec aims to be a community-centered project, and welcomes
issue reports, feature requests, and pull requests from other users.
