#ifndef CARFILEMANAGER_H
#define CARFILEMANAGER_H

#include "Car.h"
#include "Showroom.h"
#include <vector>

class CarFileManager
{
private:
    char delimiter;

    Car parseLine(std::string line, int lineNum);
    std::string toLine(Car car);

public:
    std::vector<Car> load(std::string path);
    void save(std::string path, std::vector Car);
};

#endif // CARFILEMANAGER_H
