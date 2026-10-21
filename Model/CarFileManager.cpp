#include "CarFileManager.h"
#include "../Exceptions/showroomexception.h"

#include <fstream>

CarFileManager::CarFileManager()
{
    delimiter=';';
}

Car CarFileManager::parseLine(std::string line, int lineNum)
{
    std::vector<std::string> f = split(line);
    if(f.size() != FIELD_COUNT)
    {
        throw InvalidFormatException(lineNum, "waiting" + std::to_string(FIELD_COUNT) + "lines, found" + std::to_string(f.size()));
    }

    int year = toInt(f[2],lineNum,"year");
    int mileage = toInt(f[4], lineNum, "mileage");
    int price = toInt(f[6],lineNum, "price");

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

std::string CarFileManager::toLine(Car car)
{
    std::string str;
    str=car.getBrand()+delimiter+car.getModel()+delimiter+std::to_string(car.getYear())+
        delimiter+std::to_string(car.getPrice())+delimiter+std::to_string(car.getMileage())+
        delimiter+(car.getCondition() == Condition::New ? "New" : "Used");

    return str;
}

std::vector<Car> load(std::string path)
{
    std::ifstream in("cars.dat");
    if(!in.is_open())
    {
        throw FileOpenException(path);
    }

    std::string line;
    while(std::getLine(in,line))
    {

    }
}