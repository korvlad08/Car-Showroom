#include "ColorOption.h"
#include "../../Exceptions/showroomexception.h"

ColorOption::ColorOption(const std::string& name, const int& price, const std::string& colorHEX, const bool& metalic)
    : CarOption(name, price), colorHEX(colorHEX),metalic(metalic)
{
    if(colorHEX.empty())
    {
        throw ValidationException("Color", "Color is empty");
    }
}

std::string ColorOption::getColorHEX() const noexcept
{
    return colorHEX;
}

bool ColorOption::getMetalic()const noexcept
{
    return metalic;
}

std::string ColorOption::getDescription() const
{
    return metalic ? name + " (metallic)" : name;
}
