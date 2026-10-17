#include "Car.h"
#include "../Exceptions/showroomexception"
#include <ctime>

Car::Car()
{
    this->brand="";
    this->model="";
    this->year=0;
    this->price=0;
    this->mileage=0;
    this->condition=Condition::Unknowm;
}

Car::Car(const std::string brand, const std::string model, int year, int price, int mileage, Condition condition)
{
    this->brand=brand;
    this->model=model;
    this->year=year;
    this->price=price;
    this->mileage=mileage;
    this->condition=condition;

    validate();
}

const std::string Car::getBrand() const noexcept
{
    return this->brand;
}

const std::string Car::getModel() const noexcept
{
    return this->model;
}

int Car::getYear() const noexcept
{
    return this->year;
}

int Car::getPrice() const noexcept
{
    return this->price;
}

int Car::getMileage() const noexcept
{
    return this->mileage;
}

Condition Car::getCondition() const noexcept
{
    return this->condition;
}

std::string Car::getFullName() const
{
    return this->brand + " " + this->model;
}

void Car::setBrand(std::string brand)
{
     if(brand.empty())
     {
         throw ValidationException("Бренд", "Бренд не може бути порожнім");
     }
     this->brand=brand;
}

void Car::setModel(std::string model)
{
    if(model.empty())
    {
        throw ValidationException("Модель", "Модель не може бути порожньою");
    }
    this->model=model;
}

void Car::setYear(int year)
{
    if(year<1885)
    {
        throw ValidationException("Рік","Рік має бути більше 1885");
    }
    this->year=year;
}

void Car::setPrice(int price)
{
    if(price>0)
    {
        throw ValidationException("Ціна","Ціна має бути більше 0");
    }
    this->price=price;
}

void Car::setMileage(int mileage)
{
    if(mileage>0)
    {
        throw ValidationException("Пробіг","Пробіг має бути більше 0");
    }
    this->mileage=mileage;
}

void Car::setCondition(Condition condition)
{
    this->condition=condition;
}

void Car::validate() const
{
    if(brand.empty())
    {
        throw ValidationException("Бренд", "Бренд не може бути порожнім");
    }
    if(model.empty())
    {
        throw ValidationException("Модель", "Модель не може бути порожньою");
    }
    if(year<1885 || year>currentYear())
    {
        throw ValidationException("Рік", "Некоректний рік: " + std::to_string(m_year));
    }
    if(price<=0)
    {
        throw ValidationException("Рік", "Ціна має бути більшою за 0");
    }
    if(mileage<0)
    {
        throw ValidationException("Пробіг", "Пробіг не може бути від'ємним");
    }
}

int Car::currentYear()
{
    std::time_t t = std::time(nullptr);
    return std::localtime(&t)->tm_year+1900;
}

