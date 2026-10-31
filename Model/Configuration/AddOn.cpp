#include "AddOn.h"
#include "../../Exceptions/showroomexception.h"

AddOn::AddOn(std::string name, int price, std::string category) : CarOption(name, price), category(category)
{
    if(category.empty())
    {
        throw ValidationException("Category", "Category is empty");
    }
}

std::string AddOn::getCategory() const noexcept
{
    return category;
}

std::string AddOn::getDescription() const noexcept
{
    return category + ": " + name;
}

