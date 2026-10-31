#include "Showroom.h"
#include "../Exceptions/showroomexception.h"
#include <algorithm>
#include <iterator>

Showroom::Showroom()
{
    nextId=1;
}

const std::vector<Car>& Showroom::getAll() const noexcept
{
    return cars;
}

int Showroom::addCar(Car car)
{
    car.setId(nextId++);
    cars.push_back(car);
    return car.getId();
}

void Showroom::removeCar(int id)
{
    auto it=std::remove_if(cars.begin(),cars.end(),[id](const Car& c)
    {
        return c.getId() == id;
    });

    if(it == cars.end())
    {
        throw CarNotFoundException(id);
    }

    cars.erase(it,cars.end());
}

const Car& Showroom::findById(int id) const
{
    auto it = std::find_if(cars.begin(), cars.end(), [id](const Car& c)
    {
        return c.getId()==id;
    });

    if (it==cars.end())
    {
        throw CarNotFoundException(id);
    }

    return *it;
}

void Showroom::updateCar(int id, const Car& newData)
{
    auto it = std::find_if(cars.begin(), cars.end(), [id](const Car& c)
    {
        return c.getId()==id;
    });

    if (it==cars.end())
    {
        throw CarNotFoundException(id);
    }

    Car update=newData;
    update.setId(id);
    *it=update;
}

std::vector<Car> Showroom::search(const Search& criteria) const
{
    std::vector<Car> result;
    std::copy_if(cars.begin(), cars.end(), std::back_inserter(result), [&criteria](const Car& c)
    {
        return criteria.matches(c);
    });

    return result;
}

void Showroom::sort(SortField field, bool asc)
{
    ShellSort(cars,field,asc);
}

