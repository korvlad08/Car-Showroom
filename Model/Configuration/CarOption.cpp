#include "CarOption.h"
#include "../../Exceptions/showroomexception.h"

CarOption::CarOption(std::string name, int price) : name(name), price(price)
{
    if(name.empty())
    {
        throw ValidationException("Name", "Name must not be empty");
    }

    // 0 is allowed: a base trim or a standard color can be free
    if(price<0)
    {
        throw ValidationException("Price", "Price must not be negative");
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