#ifndef COLOROPTION_H
#define COLOROPTION_H

#include "CarOption.h"

class ColorOption : public CarOption
{
private:
    std::string colorHEX;
    bool metalic;
public:
    ColorOption(const std::string& name, const int& price, const std::string& colorHEX, const bool& metalic);

    std::string getColorHEX() const noexcept;
    bool getMetalic() const noexcept;

    std::string getDescription() const override;
};

#endif // COLOROPTION_H
