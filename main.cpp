#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStyleHints>

#include "Bridge/ShowroomController.h"
#include "Bridge/ConfiguratorController.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QGuiApplication::styleHints()->setColorScheme(Qt::ColorScheme::Light);

    // Created before the engine, so they live longer than the QML that uses them
    ShowroomController controller;
    // options.json is built into the program (RESOURCES in CMakeLists.txt)
    ConfiguratorController configurator(&controller, ":/qt/qml/CarShowroom/options.json");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("showroom", &controller);
    engine.rootContext()->setContextProperty("configurator", &configurator);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("CarShowroom", "Main");

    // Loaded after QML, so a load error is shown in the error dialog
    controller.loadFromPath("D:/Unik/2 course/1 sem/OOP/CarShowroom/test_save.dat");

    return QGuiApplication::exec();
}
