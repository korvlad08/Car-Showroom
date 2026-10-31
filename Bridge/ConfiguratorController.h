#ifndef CONFIGURATORCONTROLLER_H
#define CONFIGURATORCONTROLLER_H

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QVariantMap>
#include <memory>
#include <vector>

#include "../Model/Configuration/CarConfiguration.h"

class ShowroomController;

// Connects the configurator screen (CarConfiguration.qml) with CarConfiguration.
// The option catalog (trims, colors, add-ons) is read from options.json.
class ConfiguratorController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList trims READ trims CONSTANT)
    Q_PROPERTY(QVariantList colors READ colors CONSTANT)
    Q_PROPERTY(QVariantList addOns READ addOns CONSTANT)

    Q_PROPERTY(QString carName READ carName NOTIFY configurationChanged)
    Q_PROPERTY(QString carEngine READ carEngine NOTIFY configurationChanged)
    Q_PROPERTY(int basePrice READ basePrice NOTIFY configurationChanged)
    Q_PROPERTY(int trimIndex READ trimIndex NOTIFY configurationChanged)
    Q_PROPERTY(int colorIndex READ colorIndex NOTIFY configurationChanged)
    Q_PROPERTY(QVariantList addOnStates READ addOnStates NOTIFY configurationChanged)
    Q_PROPERTY(int totalPrice READ totalPrice NOTIFY configurationChanged)

public:
    explicit ConfiguratorController(ShowroomController* showroom,
                                    const QString& catalogPath,
                                    QObject* parent = nullptr);

    QVariantList trims() const;
    QVariantList colors() const;
    QVariantList addOns() const;

    QString carName() const;
    QString carEngine() const;
    int basePrice() const;
    int trimIndex() const;
    int colorIndex() const;
    QVariantList addOnStates() const;    // true/false for every add-on of the catalog
    int totalPrice() const;

    Q_INVOKABLE bool open(int carId);    // starts configuring a car from the showroom
    Q_INVOKABLE void selectTrim(int index);
    Q_INVOKABLE void selectColor(int index);
    Q_INVOKABLE void toggleAddOn(int index);
    Q_INVOKABLE void reset();            // base trim, no add-ons
    Q_INVOKABLE bool apply();            // writes trim, color and surcharge into the car

    Q_INVOKABLE QString colorHex(const QString& colorName) const;

signals:
    void configurationChanged();
    void errorOccurred(const QString& message);
    void applied(int carId);

private:
    void loadCatalog(const QString& path);
    static QVariantMap describe(const CarOption& option);   // uses the virtual getDescription()
    void reportError(const std::exception& e);

    ShowroomController* showroomController;

    std::vector<std::shared_ptr<TrimLevel>> trimCatalog;
    std::vector<std::shared_ptr<ColorOption>> colorCatalog;
    std::vector<std::shared_ptr<AddOn>> addOnCatalog;
    QVariantList trimList;
    QVariantList colorList;
    QVariantList addOnList;
    QString catalogError;

    std::unique_ptr<CarConfiguration> config;
    int carId = -1;
    int currentTrim = -1;
    int currentColor = -1;
};

#endif // CONFIGURATORCONTROLLER_H
