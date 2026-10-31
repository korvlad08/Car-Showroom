#include "CarConfiguration.h"
#include "../../Exceptions/showroomexception.h"

#include <algorithm>
#include <sstream>

CarConfiguration::CarConfiguration(const Car& car)
    : car(car)
{
    car.validate();
}

const Car& CarConfiguration::getCar()
{
    return car;
}

void CarConfiguration::setTrim(std::shared_ptr<TrimLevel> trim)
{
    if(!trim)
    {
        throw ValidationException("Trim", "Trim not found");
    }
    this->trim=trim;
}

void CarConfiguration::setColor(std::shared_ptr<ColorOption> color)
{
    if(!color)
    {
        throw ValidationException("Color", "Color not found");
    }

    this->color=color;
}

void CarConfiguration::toggleAddOn(const std::shared_ptr<AddOn>& addOn)
{
    if(!addOn)
    {
        throw ValidationException("Option", "Option didnt chose");
    }

    auto it = std::find(this->addOn.begin(),this->addOn.end(), addOn);

    if(it!=this->addOn.end())
    {
        this->addOn.erase(it);
    }
    else
    {
        this->addOn.push_back(addOn);
    }
}

const bool CarConfiguration::hasAddOn(const std::shared_ptr<AddOn>& addOn)
{
    if(!addOn)
    {
        throw ValidationException("Option", "Option didnt chose");
    }

    auto it = std::find(this->addOn.begin(),this->addOn.end(), addOn);

    return it!=this->addOn.end();
}

const int CarConfiguration::totalPrice() const
{
    int total= car.getPrice();

    if(trim)
    {
        total+=trim->getPrice();
    }
    if(color)
    {
        total+=color->getPrice();
    }
    for(const auto& a : addOn)
    {
        total+=a->getPrice();
    }
    return total;
}

const std::string CarConfiguration::summary() const
{
    std::ostringstream out;

    out<<car.getFullName()<<" ("<<car.getYear()<<"\n";

    out<<"Configuration: ";
    if (trim)
    {
        out<<trim->getDescription();
    }
    else
    {
        out<<"not selected";
    }
    out<<"\n";

    out<<"Color: ";
    if(color)
    {
        out<<color->getDescription();
    }
    else
    {
        out<<"not selected";
    }
    out<<"\n";

    out<<"Addons: ";
    if(addOn.empty())
    {
        out<<"none";
    }

    for(const auto& a : addOn)
    {
        out<<"\n -"<< a->getDescription();
    }
    out<<"\nTotal price: "<<totalPrice()<<" $";

    return out.str();
}
