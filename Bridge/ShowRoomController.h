#ifndef SHOWROOMCONTROLLER_H
#define SHOWROOMCONTROLLER_H

#include <QObject>
#include <QString>
#include <QUrl>
#include <QVariantMap>
#include <exception>

#include "CarListModel.h"
#include "../Model/Showroom.h"
#include "../Model/CarFileManager.h"
#include "../Model/search.h"

// Connects QML with the model: QML calls Q_INVOKABLE methods,
// the controller calls Showroom / CarFileManager and updates CarListModel.
class ShowroomController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(CarListModel* model READ model CONSTANT)
    Q_PROPERTY(int totalCount READ totalCount NOTIFY totalCountChanged)
    Q_PROPERTY(QString currentFile READ currentFile NOTIFY currentFileChanged)
    Q_PROPERTY(int sortField READ sortField NOTIFY sortChanged)
    Q_PROPERTY(bool sortAscending READ sortAscending NOTIFY sortChanged)
    Q_PROPERTY(bool searchActive READ searchActive NOTIFY searchChanged)

public:
    explicit ShowroomController(QObject* parent = nullptr);

    CarListModel* model() const;
    int totalCount() const;
    QString currentFile() const;
    int sortField() const;          // -1 = not sorted, 0 = year, 1 = price, 2 = mileage
    bool sortAscending() const;
    bool searchActive() const;

    Q_INVOKABLE void loadFromFile(const QUrl& url);
    Q_INVOKABLE void loadFromPath(const QString& path);
    Q_INVOKABLE void saveToFile(const QUrl& url);

    Q_INVOKABLE void removeCar(int id);

    // Form data (all values as text): brand, model, year, price, mileage,
    // condition ("New"/"Used"), engine, consumption, trim, color.
    Q_INVOKABLE int addCar(const QVariantMap& data);            // new id, or -1 on error
    Q_INVOKABLE bool editCar(int id, const QVariantMap& data);  // true on success
    Q_INVOKABLE QVariantMap carForForm(int id);                 // base data of a car for the edit form

    // Used by ConfiguratorController (C++ only, not called from QML)
    Car carById(int id) const;                       // throws CarNotFoundException
    bool replaceCar(int id, const Car& car);         // true on success, errors go to errorOccurred

    // condition: 0 = all, 1 = new, 2 = used; price 0 = no limit
    Q_INVOKABLE void search(const QString& text, int minPrice, int maxPrice, int condition);
    Q_INVOKABLE void resetSearch();

    // field: 0 = year, 1 = price, 2 = mileage
    Q_INVOKABLE void sortBy(int field, bool ascending);

signals:
    void errorOccurred(const QString& message);
    void totalCountChanged();
    void currentFileChanged();
    void sortChanged();
    void searchChanged();

private:
    void refresh();
    void resort();
    void reportError(const std::exception& e);
    Car carFromForm(const QVariantMap& data, int optionsPrice) const;
    static bool toSortField(int field, SortField& result);

    Showroom showroom;
    CarFileManager fileManager;
    CarListModel* listModel;

    Search lastSearch;
    bool isSearchActive = false;

    QString filePath;
    int currentSortField = -1;
    bool currentSortAsc = true;
};

#endif // SHOWROOMCONTROLLER_H
