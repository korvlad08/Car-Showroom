#ifndef CARFILEMANAGER_H
#define CARFILEMANAGER_H

#include "Car.h"
#include "Showroom.h"
#include <vector>

class CarFileManager
{
private:
    char delimiter;

    Car parseLine(const std::string& line, int lineNum) const;
    std::string toLine(const Car& car) const;

public:
    CarFileManager();
    std::vector<Car> load(const std::string& path)const;
    void save(const std::string& path, const std::vector<Car>& cars) const;
};

#endif // CARFILEMANAGER_H
