#-------------------------------------------------
#
# Project created by QtCreator 2018-10-02T19:50:20
#
#-------------------------------------------------

QT       -= core gui

TARGET = bicycle_process
TEMPLATE = lib

DEFINES += BI_PROCESS_LIBRARY
DEFINES += QT_DEPRECATED_WARNINGS

BICYCLE_DIR = ./Bicycle

INCLUDEPATH+= $${BICYCLE_DIR}

HEADERS += \
    bicycle_process.h \
    $${BICYCLE_DIR}/Win/Process/Process.h \
    $${BICYCLE_DIR}/Win/Process/Pipe.h \
    $${BICYCLE_DIR}/Algorithm/Mismatch.h \
    $${BICYCLE_DIR}/Win/Experimental/Thread.h \
    $${BICYCLE_DIR}/Win/Synchronization/AtomicCounter.h \
    $${BICYCLE_DIR}/Win/Experimental/Encoding.h

SOURCES += \
    bicycle_process.cpp \
    $${BICYCLE_DIR}/Win/Common/Global.cpp \
    $${BICYCLE_DIR}/Win/Common/Exception.cpp \
    $${BICYCLE_DIR}/Win/Common/Event.cpp \
    $${BICYCLE_DIR}/Win/Process/Pipe.cpp \
    $${BICYCLE_DIR}/Win/Process/Process.cpp \
    $${BICYCLE_DIR}/Win/Process/Environment.cpp \
    $${BICYCLE_DIR}/Win/Experimental/Thread.cpp \
    $${BICYCLE_DIR}/Win/Synchronization/AtomicCounter.cpp \
    $${BICYCLE_DIR}/Win/Experimental/Encoding.cpp

LIBS += User32.lib
