#ifndef ADDON_H
#define ADDON_H

#include "CarOption.h"

class AddOn : public CarOption
{
private:
    std::string category;
public:
    AddOn(std::string name, int price, std::string category);

    std::string getCategory() const noexcept;

    std::string getDescription() const noexcept override;
};

#endif // ADDON_H
