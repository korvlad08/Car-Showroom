#ifndef CARLISTMODEL_H
#define CARLISTMODEL_H

#include <vector>
#include<QAbstractListModel>
#include "../Model/Car.h"

class CarListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
private:
    std::vector<Car> cars;
public:
    enum Roles
    {
        IdRole = Qt::UserRole + 1,
        BrandRole,
        ModelNameRole,
        FullNameRole,
        YearRole,
        PriceRole,
        MileageRole,
        ConditionRole,
        EngineRole,
        ConsumptionRole,
        TrimRole,
        ColorRole
    };
    explicit CarListModel(QObject* parent=nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    void setCars(const std::vector<Car>& cars);
    int count() const;
    Q_INVOKABLE QVariantMap get(int row) const;
signals:
    void countChanged();
};

#endif // CARLISTMODEL_H
