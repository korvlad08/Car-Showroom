#include "Car.h"
#include "Enums.h"
#include "../Exceptions/showroomexception.h"
#include <ctime>

Car::Car()
{
    this->brand="";
    this->model="";
    this->year=0;
    this->price=0;
    this->mileage=0;
    this->condition=Condition::Unknowm;
    this->engine="";
    this->consumption=0.0;
    this->id=0;
}

Car::Car(const std::string brand, const std::string model, int year, int price, int mileage,Condition condition, const std::string& engine, double consumption)
{
    this->brand=brand;
    this->model=model;
    this->year=year;
    this->price=price;
    this->mileage=mileage;
    this->condition=condition;
    this->engine=engine;
    this->consumption=consumption;
    this->id=0;

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

const std::string& Car::getEngine() const noexcept
{
    return engine;
}

double Car::getConsumption() const noexcept
{
    return consumption;
}

const std::string& Car::getTrim() const noexcept
{
    return trim;
}

const std::string& Car::getColor() const noexcept
{
    return color;
}

int Car::getOptionsPrice() const noexcept
{
    return optionsPrice;
}

int Car::getId() const noexcept
{
    return id;
}

int Car::getTotalPrice() const noexcept
{
    return price + optionsPrice;
}

bool Car::isConfigured() const noexcept
{
    return !trim.empty();
}

std::string Car::getFullName() const
{
    return this->brand + " " + this->model;
}

void Car::setBrand(std::string brand)
{
    if(brand.empty())
    {
        throw ValidationException("Brand", "Brand must not be empty");
    }
    this->brand=brand;
}

void Car::setModel(std::string model)
{
    if(model.empty())
    {
        throw ValidationException("Model", "Model must not be empty");
    }
    this->model=model;
}

void Car::setYear(int year)
{
    if(year<1885 || year>currentYear())
    {
        throw ValidationException("Year", "Year must be between 1885 and " + std::to_string(currentYear()));
    }
    this->year=year;
}

void Car::setPrice(int price)
{
    if(price<=0)
    {
        throw ValidationException("Price", "Price must be greater than 0");
    }
    this->price=price;
}

void Car::setMileage(int mileage)
{
    if(mileage<0)
    {
        throw ValidationException("Mileage", "Mileage must not be negative");
    }
    this->mileage=mileage;
}

void Car::setCondition(Condition condition)
{
    this->condition=condition;
}

void Car::setEngine(const std::string& engine)
{
    this->engine=engine;
}

void Car::setConsumption(double consumption)
{
    if(consumption<0 || consumption>50)
    {
        throw ValidationException("Consumption", "Consumption must be between 0 and 50 l/100 km");
    }
    this->consumption=consumption;
}

void Car::setConfiguration(const std::string& trim, const std::string& color, int optionsPrice)
{
    if (trim.empty())
    {
        throw ValidationException("Trim", "Trim is not selected");
    }
    if (color.empty())
    {
        throw ValidationException("Color", "Color is not selected");
    }
    if (optionsPrice < 0)
    {
        throw ValidationException("Surcharge", "Surcharge must not be negative");
    }

    this->trim = trim;
    this->color = color;
    this->optionsPrice = optionsPrice;
}

void Car::clearConfiguration()
{
    trim.clear();
    color.clear();
    optionsPrice = 0;
}

void Car::setId(int id)
{
    this->id=id;
}

void Car::validate() const
{
    if(brand.empty())
    {
        throw ValidationException("Brand", "Brand must not be empty");
    }
    if(model.empty())
    {
        throw ValidationException("Model", "Model must not be empty");
    }
    if(year<1885 || year>currentYear())
    {
        throw ValidationException("Year", "Incorrect year: " + std::to_string(year));
    }
    if(price<=0)
    {
        throw ValidationException("Price", "Price must be greater than 0");
    }
    if(mileage<0)
    {
        throw ValidationException("Mileage", "Mileage must not be negative");
    }
    if(consumption<0 || consumption>50)
    {
        throw ValidationException("Consumption", "Consumption must be between 0 and 50 l/100 km");
    }
}

int Car::currentYear()
{
    std::time_t t = std::time(nullptr);
    return std::localtime(&t)->tm_year+1900;
}