QT += qml quick quickcontrols2

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += \
    app.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

OTHER_FILES += qml/*.qml \
	qml/Components/*.qml
