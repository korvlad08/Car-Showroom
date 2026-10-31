#ifndef SHOWROOM_H
#define SHOWROOM_H

#include "Car.h"
#include "Search.h"
#include "../Shell Sort/ShellSort.h"
#include <vector>

class Showroom
{
private:
    std::vector<Car> cars;
    int nextId;

public:
    Showroom();
    const std::vector<Car>& getAll() const noexcept;

    int addCar(Car car);
    void removeCar(int id);
    void replaceAll(const std::vector<Car>& newCars);
    size_t count() const noexcept;

    const Car& findById(int id) const;
    void updateCar(int id,const Car& newData);

    std::vector<Car> search(const Search& criteria) const;
    void sort(SortField field, bool asc=true);
};

#endif // SHOWROOM_H
