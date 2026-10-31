#include "CarListModel.h"

CarListModel::CarListModel(QObject *parent) : QAbstractListModel(parent)
{}

int CarListModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
    {
        return 0;
    }

    return static_cast<int>(cars.size());
}

QVariant CarListModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= rowCount())
    {
        return {};
    }

    const Car& car = cars[index.row()];

    switch (role)
    {
    case IdRole:
    {
        return car.getId();
    }
    case BrandRole:
    {
        return QString::fromStdString(car.getBrand());
    }
    case ModelNameRole:
    {
        return QString::fromStdString(car.getModel());
    }
    case FullNameRole:
    {
        return QString::fromStdString(car.getFullName());
    }
    case YearRole:
    {
         return car.getYear();
    }
    case MileageRole:
    {
        return car.getMileage();
    }
    case ConditionRole:
    {
        return car.getCondition() == Condition::New ? QStringLiteral("New") : QStringLiteral("Used");
    }
    case PriceRole:
    {
        return car.getTotalPrice();
    }
    case EngineRole:
    {
        return QString::fromStdString(car.getEngine());
    }
    case ConsumptionRole:
    {
        return car.getConsumption();
    }
    case TrimRole:
    {
        return QString::fromStdString(car.getTrim());
    }
    case ColorRole:
    {
        return QString::fromStdString(car.getColor());
    }
    default:
    {
        return {};
    }
    }
}

QHash<int, QByteArray> CarListModel::roleNames() const
{
    return
    {
        { IdRole, "carId" },
        { BrandRole, "brand" },
        { ModelNameRole, "modelName" },
        { FullNameRole, "name" },
        { YearRole, "year" },
        { PriceRole, "price" },
        { MileageRole, "mileage" },
        { ConditionRole, "condition" },
        { EngineRole, "engine" },
        { ConsumptionRole, "consumption" },
        { TrimRole, "trim" },
        { ColorRole, "carColor" }
    };
}

void CarListModel::setCars(const std::vector<Car>& cars)
{
    beginResetModel();
    this->cars = cars;
    endResetModel();
    emit countChanged();
}

int CarListModel::count() const
{
    return static_cast<int>(cars.size());
}

QVariantMap CarListModel::get(int row) const
{
    QVariantMap map;
    if (row < 0 || row >= count())
    {
        return map;
    }

    const QHash<int, QByteArray> names = roleNames();
    const QModelIndex idx = index(row);

    for (auto it = names.cbegin(); it != names.cend(); ++it)
    {
        map[QString::fromUtf8(it.value())] = data(idx, it.key());
    }
    return map;
}