#include "CarOption.h"
#include "../../Exceptions/showroomexception.h"

CarOption::CarOption(std::string name, int price) : name(name), price(price)
{
    if(name.empty())
    {
        throw ValidationException("Name", "Name must be not empty");
    }

    if(price<=0)
    {
        throw ValidationException("Price","Price must be greater then 0");
    }
}

std::string CarOption::getName() const noexcept
{
    return name;
}

int CarOption::getPrice() const noexcept
{
    return price;
}