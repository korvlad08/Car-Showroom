#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QStyleHints>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QGuiApplication::styleHints()->setColorScheme(Qt::ColorScheme::Light);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("CarShowroom", "Main");

    return QGuiApplication::exec();
}
