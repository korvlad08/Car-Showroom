#include "ConfiguratorController.h"
#include "ShowroomController.h"
#include "../Exceptions/showroomexception.h"

#include <QDebug>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStringList>

namespace {

template <typename T>
int indexByName(const std::vector<std::shared_ptr<T>>& list, const std::string& name)
{
    for (size_t i = 0; i < list.size(); ++i)
    {
        if (list[i]->getName() == name)
        {
            return static_cast<int>(i);
        }
    }
    return -1;
}

}

ConfiguratorController::ConfiguratorController(ShowroomController* showroom,
                                               const QString& catalogPath,
                                               QObject* parent)
    : QObject(parent), showroomController(showroom)
{
    try
    {
        loadCatalog(catalogPath);
    }
    catch (const std::exception& e)
    {
        // Shown later, when the user opens the configurator
        catalogError = QString::fromUtf8(e.what());
        qWarning() << "Options catalog:" << catalogError;
    }
}

// Polymorphism: the same call works for TrimLevel, ColorOption and AddOn
QVariantMap ConfiguratorController::describe(const CarOption& option)
{
    QVariantMap map;
    map["name"] = QString::fromStdString(option.getName());
    map["price"] = option.getPrice();
    map["description"] = QString::fromStdString(option.getDescription());
    return map;
}

void ConfiguratorController::loadCatalog(const QString& path)
{
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly))
    {
        throw FileOpenException(path.toStdString());
    }

    QJsonParseError parseError;
    const QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), &parseError);
    if (parseError.error != QJsonParseError::NoError || !doc.isObject())
    {
        throw InvalidFormatException(0, "Options catalog: " + parseError.errorString().toStdString());
    }
    const QJsonObject root = doc.object();

    for (const QJsonValue& value : root["trims"].toArray())
    {
        const QJsonObject o = value.toObject();
        std::vector<std::string> features;
        QStringList featureList;
        for (const QJsonValue& f : o["features"].toArray())
        {
            features.push_back(f.toString().toStdString());
            featureList << f.toString();
        }

        auto trim = std::make_shared<TrimLevel>(o["name"].toString().toStdString(), o["price"].toInt(), features);
        QVariantMap map = describe(*trim);
        map["features"] = featureList.join(", ");
        trimCatalog.push_back(trim);
        trimList.append(map);
    }

    for (const QJsonValue& value : root["colors"].toArray())
    {
        const QJsonObject o = value.toObject();
        auto color = std::make_shared<ColorOption>(o["name"].toString().toStdString(), o["price"].toInt(),
                                                   o["hex"].toString().toStdString(), o["metallic"].toBool());
        QVariantMap map = describe(*color);
        map["hex"] = QString::fromStdString(color->getColorHEX());
        map["metallic"] = color->getMetalic();
        colorCatalog.push_back(color);
        colorList.append(map);
    }

    for (const QJsonValue& value : root["addOns"].toArray())
    {
        const QJsonObject o = value.toObject();
        auto addOn = std::make_shared<AddOn>(o["name"].toString().toStdString(), o["price"].toInt(),
                                             o["category"].toString().toStdString());
        QVariantMap map = describe(*addOn);
        map["category"] = QString::fromStdString(addOn->getCategory());
        addOnCatalog.push_back(addOn);
        addOnList.append(map);
    }

    if (trimCatalog.empty() || colorCatalog.empty())
    {
        throw InvalidFormatException(0, "Options catalog must contain at least one trim and one color");
    }
}

QVariantList ConfiguratorController::trims() const { return trimList; }
QVariantList ConfiguratorController::colors() const { return colorList; }
QVariantList ConfiguratorController::addOns() const { return addOnList; }

QString ConfiguratorController::carName() const
{
    return config ? QString::fromStdString(config->getCar().getFullName()) : QString();
}

QString ConfiguratorController::carEngine() const
{
    return config ? QString::fromStdString(config->getCar().getEngine()) : QString();
}

int ConfiguratorController::basePrice() const
{
    return config ? config->getCar().getPrice() : 0;
}

int ConfiguratorController::trimIndex() const { return currentTrim; }
int ConfiguratorController::colorIndex() const { return currentColor; }

QVariantList ConfiguratorController::addOnStates() const
{
    QVariantList states;
    for (const auto& addOn : addOnCatalog)
    {
        states.append(config ? config->hasAddOn(addOn) : false);
    }
    return states;
}

int ConfiguratorController::totalPrice() const
{
    return config ? config->totalPrice() : 0;
}

bool ConfiguratorController::open(int id)
{
    try
    {
        if (trimCatalog.empty() || colorCatalog.empty())
        {
            throw ShowroomException(catalogError.toStdString());
        }

        const Car car = showroomController->carById(id);
        auto newConfig = std::make_unique<CarConfiguration>(car);

        // An already configured car opens with its trim and color selected
        int trim = indexByName(trimCatalog, car.getTrim());
        int color = indexByName(colorCatalog, car.getColor());
        if (trim < 0) trim = 0;
        if (color < 0) color = 0;

        newConfig->setTrim(trimCatalog[trim]);
        newConfig->setColor(colorCatalog[color]);

        config = std::move(newConfig);
        carId = id;
        currentTrim = trim;
        currentColor = color;
        emit configurationChanged();
        return true;
    }
    catch (const std::exception& e)
    {
        reportError(e);
        return false;
    }
}

void ConfiguratorController::selectTrim(int index)
{
    if (!config || index < 0 || index >= static_cast<int>(trimCatalog.size()))
        return;

    config->setTrim(trimCatalog[index]);
    currentTrim = index;
    emit configurationChanged();
}

void ConfiguratorController::selectColor(int index)
{
    if (!config || index < 0 || index >= static_cast<int>(colorCatalog.size()))
        return;

    config->setColor(colorCatalog[index]);
    currentColor = index;
    emit configurationChanged();
}

void ConfiguratorController::toggleAddOn(int index)
{
    if (!config || index < 0 || index >= static_cast<int>(addOnCatalog.size()))
        return;

    config->toggleAddOn(addOnCatalog[index]);
    emit configurationChanged();
}

void ConfiguratorController::reset()
{
    if (!config)
        return;

    auto newConfig = std::make_unique<CarConfiguration>(config->getCar());
    newConfig->setTrim(trimCatalog[0]);
    newConfig->setColor(colorCatalog[currentColor]);
    config = std::move(newConfig);
    currentTrim = 0;
    emit configurationChanged();
}

bool ConfiguratorController::apply()
{
    try
    {
        if (!config)
        {
            throw ShowroomException("No car is being configured");
        }

        const Car configured = config->result();
        if (!showroomController->replaceCar(carId, configured))
        {
            return false;   // the error is already shown by ShowroomController
        }

        emit applied(carId);
        return true;
    }
    catch (const std::exception& e)
    {
        reportError(e);
        return false;
    }
}

QString ConfiguratorController::colorHex(const QString& colorName) const
{
    const int index = indexByName(colorCatalog, colorName.toStdString());
    return index >= 0 ? QString::fromStdString(colorCatalog[index]->getColorHEX()) : QString();
}

void ConfiguratorController::reportError(const std::exception& e)
{
    const QString message = QString::fromUtf8(e.what());
    qWarning() << message;
    emit errorOccurred(message);
}
