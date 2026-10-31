#include "ShowroomController.h"
#include "../Exceptions/showroomexception.h"

#include <QDebug>
#include <QFile>
#include <optional>
#include <string>

namespace {

QString formValue(const QVariantMap& data, const char* key)
{
    return data.value(QString::fromLatin1(key)).toString().trimmed();
}

// Text fields are saved to a ';'-separated file, so these characters are not allowed
std::string textField(const QVariantMap& data, const char* key, const std::string& name)
{
    const QString value = formValue(data, key);
    if (value.contains(QLatin1Char(';')) || value.contains(QLatin1Char('|')))
    {
        throw ValidationException(name, name + " must not contain ';' or '|'");
    }
    return value.toStdString();
}

int intField(const QVariantMap& data, const char* key, const std::string& name, bool required)
{
    const QString value = formValue(data, key);
    if (value.isEmpty())
    {
        if (required)
        {
            throw ValidationException(name, name + " must not be empty");
        }
        return 0;
    }

    bool ok = false;
    const int result = value.toInt(&ok);
    if (!ok)
    {
        throw ValidationException(name, name + " must be a whole number");
    }
    return result;
}

double doubleField(const QVariantMap& data, const char* key, const std::string& name)
{
    QString value = formValue(data, key);
    if (value.isEmpty())
    {
        return 0.0;
    }

    value.replace(QLatin1Char(','), QLatin1Char('.'));
    bool ok = false;
    const double result = value.toDouble(&ok);
    if (!ok)
    {
        throw ValidationException(name, name + " must be a number");
    }
    return result;
}

}

ShowroomController::ShowroomController(QObject* parent)
    : QObject(parent), listModel(new CarListModel(this))
{
}

CarListModel* ShowroomController::model() const
{
    return listModel;
}

int ShowroomController::totalCount() const
{
    return static_cast<int>(showroom.count());
}

QString ShowroomController::currentFile() const
{
    return filePath;
}

int ShowroomController::sortField() const
{
    return currentSortField;
}

bool ShowroomController::sortAscending() const
{
    return currentSortAsc;
}

bool ShowroomController::searchActive() const
{
    return isSearchActive;
}

void ShowroomController::loadFromFile(const QUrl& url)
{
    loadFromPath(url.toLocalFile());
}

void ShowroomController::loadFromPath(const QString& path)
{
    try
    {
        // Load first: if the file is broken, the current data stays untouched
        std::vector<Car> loaded = fileManager.load(QFile::encodeName(path).toStdString());
        showroom.replaceAll(loaded);

        filePath = path;
        isSearchActive = false;
        currentSortField = -1;

        emit currentFileChanged();
        emit searchChanged();
        emit sortChanged();
        refresh();
    }
    catch (const std::exception& e)
    {
        reportError(e);
    }
}

void ShowroomController::saveToFile(const QUrl& url)
{
    const QString path = url.toLocalFile();
    try
    {
        // Always saves all cars, not only the ones shown by the search
        fileManager.save(QFile::encodeName(path).toStdString(), showroom.getAll());
        filePath = path;
        emit currentFileChanged();
    }
    catch (const std::exception& e)
    {
        reportError(e);
    }
}

void ShowroomController::removeCar(int id)
{
    try
    {
        showroom.removeCar(id);
        refresh();
    }
    catch (const std::exception& e)
    {
        reportError(e);
    }
}

int ShowroomController::addCar(const QVariantMap& data)
{
    try
    {
        const int id = showroom.addCar(carFromForm(data, 0));
        resort();
        refresh();
        return id;
    }
    catch (const std::exception& e)
    {
        reportError(e);
        return -1;
    }
}

bool ShowroomController::editCar(int id, const QVariantMap& data)
{
    try
    {
        // The surcharge comes from the configurator, the form does not change it
        const int optionsPrice = showroom.findById(id).getOptionsPrice();
        showroom.updateCar(id, carFromForm(data, optionsPrice));
        resort();
        refresh();
        return true;
    }
    catch (const std::exception& e)
    {
        reportError(e);
        return false;
    }
}

QVariantMap ShowroomController::carForForm(int id)
{
    QVariantMap result;
    try
    {
        const Car& car = showroom.findById(id);
        result["carId"] = car.getId();
        result["brand"] = QString::fromStdString(car.getBrand());
        result["model"] = QString::fromStdString(car.getModel());
        result["year"] = car.getYear();
        result["price"] = car.getPrice();             // base price, without the configuration surcharge
        result["mileage"] = car.getMileage();
        result["condition"] = car.getCondition() == Condition::New ? QStringLiteral("New") : QStringLiteral("Used");
        result["engine"] = QString::fromStdString(car.getEngine());
        result["consumption"] = car.getConsumption();
        result["trim"] = QString::fromStdString(car.getTrim());
        result["color"] = QString::fromStdString(car.getColor());
    }
    catch (const std::exception& e)
    {
        reportError(e);
    }
    return result;
}

Car ShowroomController::carById(int id) const
{
    return showroom.findById(id);
}

bool ShowroomController::replaceCar(int id, const Car& car)
{
    try
    {
        showroom.updateCar(id, car);
        resort();
        refresh();
        return true;
    }
    catch (const std::exception& e)
    {
        reportError(e);
        return false;
    }
}

// Builds a Car from the form; Car itself validates the values and throws ValidationException
Car ShowroomController::carFromForm(const QVariantMap& data, int optionsPrice) const
{
    const std::string brand = textField(data, "brand", "Brand");
    const std::string model = textField(data, "model", "Model");
    const int year = intField(data, "year", "Year", true);
    const int price = intField(data, "price", "Price", true);
    const int mileage = intField(data, "mileage", "Mileage", false);
    const Condition condition = formValue(data, "condition") == QLatin1String("New") ? Condition::New : Condition::Used;
    const std::string engine = textField(data, "engine", "Engine");
    const double consumption = doubleField(data, "consumption", "Consumption");

    Car car(brand, model, year, price, mileage, condition, engine, consumption);

    const std::string trim = textField(data, "trim", "Trim");
    const std::string color = textField(data, "color", "Color");
    if (!trim.empty() || !color.empty())
    {
        car.setConfiguration(trim, color, optionsPrice);
    }
    return car;
}

void ShowroomController::search(const QString& text, int minPrice, int maxPrice, int condition)
{
    std::optional<Condition> cond;
    if (condition == 1)
    {
        cond = Condition::New;
    }
    else if (condition == 2)
    {
        cond = Condition::Used;
    }

    try
    {
        // Search constructor validates prices and throws ValidationException
        lastSearch = Search(text.trimmed().toStdString(), minPrice, maxPrice, cond);
        isSearchActive = true;
        emit searchChanged();
        refresh();
    }
    catch (const std::exception& e)
    {
        reportError(e);
    }
}

void ShowroomController::resetSearch()
{
    isSearchActive = false;
    emit searchChanged();
    refresh();
}

bool ShowroomController::toSortField(int field, SortField& result)
{
    switch (field)
    {
    case 0: result = SortField::Year;    return true;
    case 1: result = SortField::Price;   return true;
    case 2: result = SortField::Mileage; return true;
    default: return false;
    }
}

void ShowroomController::sortBy(int field, bool ascending)
{
    SortField sf;
    if (!toSortField(field, sf))
    {
        emit errorOccurred(QStringLiteral("Unknown sort field: %1").arg(field));
        return;
    }

    showroom.sort(sf, ascending);
    currentSortField = field;
    currentSortAsc = ascending;
    emit sortChanged();
    refresh();
}

// After adding or editing a car the table stays sorted the same way
void ShowroomController::resort()
{
    SortField sf;
    if (currentSortField >= 0 && toSortField(currentSortField, sf))
    {
        showroom.sort(sf, currentSortAsc);
    }
}

// Shows either all cars or the search result (search keeps the sorted order)
void ShowroomController::refresh()
{
    if (isSearchActive)
    {
        listModel->setCars(showroom.search(lastSearch));
    }
    else
    {
        listModel->setCars(showroom.getAll());
    }
    emit totalCountChanged();
}

void ShowroomController::reportError(const std::exception& e)
{
    const QString message = QString::fromUtf8(e.what());
    qWarning() << message;
    emit errorOccurred(message);
}
