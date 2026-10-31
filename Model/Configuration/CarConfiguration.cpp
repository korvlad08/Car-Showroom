#include "CarConfiguration.h"
#include "../../Exceptions/showroomexception.h"

#include <algorithm>
#include <numeric>
#include <sstream>

CarConfiguration::CarConfiguration(const Car& car)
    : car(car)
{
    car.validate();
}

const Car& CarConfiguration::getCar() const noexcept
{
    return car;
}

std::shared_ptr<TrimLevel> CarConfiguration::getTrim() const noexcept
{
    return trim;
}

std::shared_ptr<ColorOption> CarConfiguration::getColor() const noexcept
{
    return color;
}

const std::vector<std::shared_ptr<AddOn>>& CarConfiguration::getAddOns() const noexcept
{
    return addOns;
}

void CarConfiguration::setTrim(std::shared_ptr<TrimLevel> trim)
{
    if(!trim)
    {
        throw ValidationException("Trim", "Trim is not selected");
    }
    this->trim=trim;
}

void CarConfiguration::setColor(std::shared_ptr<ColorOption> color)
{
    if(!color)
    {
        throw ValidationException("Color", "Color is not selected");
    }

    this->color=color;
}

void CarConfiguration::toggleAddOn(const std::shared_ptr<AddOn>& addOn)
{
    if(!addOn)
    {
        throw ValidationException("Option", "Option is not selected");
    }

    auto it = std::find(addOns.begin(), addOns.end(), addOn);

    if(it!=addOns.end())
    {
        addOns.erase(it);
    }
    else
    {
        addOns.push_back(addOn);
    }
}

bool CarConfiguration::hasAddOn(const std::shared_ptr<AddOn>& addOn) const
{
    if(!addOn)
    {
        throw ValidationException("Option", "Option is not selected");
    }

    return std::find(addOns.begin(), addOns.end(), addOn) != addOns.end();
}

int CarConfiguration::totalPrice() const
{
    int total = car.getPrice();

    if(trim)
    {
        total+=trim->getPrice();
    }
    if(color)
    {
        total+=color->getPrice();
    }

    return std::accumulate(addOns.begin(), addOns.end(), total,
        [](int sum, const std::shared_ptr<AddOn>& a) { return sum + a->getPrice(); });
}

int CarConfiguration::surcharge() const
{
    return totalPrice() - car.getPrice();
}

std::string CarConfiguration::summary() const
{
    std::ostringstream out;

    out<<car.getFullName()<<" ("<<car.getYear()<<")\n";

    out<<"Trim: "<<(trim ? trim->getDescription() : "not selected")<<"\n";
    out<<"Color: "<<(color ? color->getDescription() : "not selected")<<"\n";

    out<<"Add-ons: ";
    if(addOns.empty())
    {
        out<<"none";
    }
    for(const auto& a : addOns)
    {
        out<<"\n - "<<a->getDescription();
    }
    out<<"\nTotal price: "<<totalPrice()<<" $";

    return out.str();
}

Car CarConfiguration::result() const
{
    if(!trim)
    {
        throw ValidationException("Trim", "Trim is not selected");
    }
    if(!color)
    {
        throw ValidationException("Color", "Color is not selected");
    }

    Car configured = car;
    configured.setConfiguration(trim->getName(), color->getName(), surcharge());
    return configured;
}
