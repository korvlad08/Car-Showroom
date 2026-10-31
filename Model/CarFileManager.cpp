#include "CarFileManager.h"
#include "Car.h"
#include "../Exceptions/showroomexception.h"

#include <fstream>
#include <sstream>
#include <vector>
#include <string>

namespace {

constexpr int FIELD_COUNT = 6;   // кількість полів у рядку файлу (f[0]..f[6])

std::vector<std::string> split(const std::string& s, char delim)
{
    std::vector<std::string> parts;
    std::stringstream ss(s);
    std::string item;

    while (std::getline(ss, item, delim))
    {
        parts.push_back(item);
    }

    return parts;
}

int toInt(const std::string& s, int lineNum, const std::string& fieldName)
{
    try {
        size_t pos = 0;
        int value = std::stoi(s, &pos);

        if (pos != s.size())
        {
            throw std::invalid_argument("extra chars");
        }

        return value;
    } catch (const std::exception&)
    {
        throw InvalidFormatException(lineNum, "Поле \"" + fieldName + "\" не є числом: \"" + s + "\"");
    }
}

}

CarFileManager::CarFileManager()
{
    delimiter=';';
}

Car CarFileManager::parseLine(const std::string& line, int lineNum) const
{
    std::vector<std::string> f = split(line, delimiter);
    if(f.size() != FIELD_COUNT)
    {
        throw InvalidFormatException(lineNum, "Waiting " + std::to_string(FIELD_COUNT) + " lines, found " + std::to_string(f.size()));
    }

    int year = toInt(f[2],lineNum,"year");
    int price = toInt(f[3], lineNum, "price");
    int mileage = toInt(f[4],lineNum, "mileage");

    Condition cond;
    if(f[5]=="New")
    {
        cond=Condition::New;
    }
    else if(f[5]=="Used")
    {
        cond=Condition::Used;
    }
    else
    {
        throw InvalidFormatException(lineNum,"Unknow condition: "+f[5]);
    }

    Car result(f[0],f[1],year,price,mileage,cond);

    return result;
}

std::string CarFileManager::toLine(const Car& car) const
{
    std::string str;
    str=car.getBrand()+delimiter+car.getModel()+delimiter+std::to_string(car.getYear())+
        delimiter+std::to_string(car.getPrice())+delimiter+std::to_string(car.getMileage())+
        delimiter+(car.getCondition() == Condition::New ? "New" : "Used");

    return str;
}

std::vector<Car> CarFileManager::load(const std::string& path) const
{
    std::ifstream in(path);
    if(!in.is_open())
    {
        throw FileOpenException(path);
    }

    std::string line;
    std::vector<Car> cars;
    int lineNum = 0;

    while(std::getline(in,line))
    {
        ++lineNum;
        if(!line.empty() && line.back() == '\r')
        {
            line.pop_back();
        }
        if(line.empty() || line[0] == '#')
        {
            continue;
        }

        cars.push_back(parseLine(line,lineNum));
    }

    return cars;
}

void CarFileManager::save(const std::string& path, const std::vector<Car>& cars) const
{
    std::ofstream file(path);
    if(!file.is_open())
    {
        throw FileOpenException(path);
    }

    for (const Car& car : cars)
    {
        file<<toLine(car)<<'\n';
    }
}