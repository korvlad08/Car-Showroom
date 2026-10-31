#include "CarFileManager.h"
#include "Car.h"
#include "../Exceptions/showroomexception.h"

#include <fstream>
#include <iomanip>
#include <locale>
#include <sstream>
#include <vector>
#include <string>

namespace {

constexpr size_t OLD_FIELDS  = 6;
constexpr size_t BASE_FIELDS = 8;
constexpr size_t FULL_FIELDS = 11;

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
        throw InvalidFormatException(lineNum, "Field \"" + fieldName + "\" is not a number: \"" + s + "\"");
    }
}

// Читає дробове число з крапкою (7.8) незалежно від мови системи
double toDouble(const std::string& s, int lineNum, const std::string& fieldName)
{
    std::istringstream in(s);
    in.imbue(std::locale::classic());
    double value = 0;
    if (!(in >> value) || !in.eof())
    {
        throw InvalidFormatException(lineNum, "Field \"" + fieldName + "\" is not a number: \"" + s + "\"");
    }
    return value;
}

}

CarFileManager::CarFileManager()
{
    delimiter=';';
}

Car CarFileManager::parseLine(const std::string& line, int lineNum) const
{
    std::vector<std::string> f = split(line, delimiter);
    if(f.size() != OLD_FIELDS && f.size() != BASE_FIELDS && f.size() != FULL_FIELDS)
    {
        throw InvalidFormatException(lineNum, "Expected " + std::to_string(OLD_FIELDS) + ", " +
                                                  std::to_string(BASE_FIELDS) + " or " +
                                                  std::to_string(FULL_FIELDS) + " fields, found " +
                                                  std::to_string(f.size()));
    }

    int year = toInt(f[2], lineNum, "year");
    int price = toInt(f[3], lineNum, "price");
    int mileage = toInt(f[4], lineNum, "mileage");

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
        throw InvalidFormatException(lineNum, "Unknown condition: " + f[5]);
    }

    std::string engine = "";
    double consumption = 0.0;
    if (f.size() >= BASE_FIELDS)
    {
        engine = f[6];
        consumption = toDouble(f[7], lineNum, "consumption");
    }

    int optionsPrice = 0;
    if (f.size() == FULL_FIELDS)
    {
        optionsPrice = toInt(f[10], lineNum, "surcharge");
    }

    try
    {
        Car result(f[0], f[1], year, price, mileage, cond, engine, consumption);

        if (f.size() == FULL_FIELDS)
        {
            result.setConfiguration(f[8], f[9], optionsPrice);
        }

        return result;
    }
    catch (const ValidationException& e)
    {
        throw InvalidFormatException(lineNum, e.what());
    }
}

std::string CarFileManager::toLine(const Car& car) const
{
    std::ostringstream cons;
    cons.imbue(std::locale::classic());
    cons << std::fixed << std::setprecision(1) << car.getConsumption();

    std::string str;
    str=car.getBrand()+delimiter+car.getModel()+delimiter+std::to_string(car.getYear())+
          delimiter+std::to_string(car.getPrice())+delimiter+std::to_string(car.getMileage())+
          delimiter+(car.getCondition() == Condition::New ? "New" : "Used")+
          delimiter+car.getEngine()+delimiter+cons.str();

    if (car.isConfigured())
    {
        str += delimiter + car.getTrim() + delimiter + car.getColor() +
               delimiter + std::to_string(car.getOptionsPrice());
    }

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