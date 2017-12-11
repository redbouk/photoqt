#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <iostream>

#include "settings/colour.h"
#include "settings/fileformats.h"
#include "settings/settings.h"

#include "imageprovider/imageproviderempty.h"
#include "imageprovider/imageproviderfull.h"
#include "imageprovider/imageproviderhistogram.h"
#include "imageprovider/imageprovidericon.h"
#include "imageprovider/imageproviderthumbnail.h"

class MainWindow : public QObject {

    Q_OBJECT

public:
    MainWindow(QQmlApplicationEngine *engine, QObject *parent = 0);

private:
    QQmlApplicationEngine *engine;

};



#endif // MAINWINDOW_H
