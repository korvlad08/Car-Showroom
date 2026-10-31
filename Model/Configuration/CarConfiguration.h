#ifndef _CARCONFIGURATION_H
#define _CARCONFIGURATION_H

#include <memory>
#include <vector>
#include <string>

#include "AddOn.h"
#include "ColorOption.h"
#include "TrimLevel.h"

#include "../Car.h"

class CarConfiguration
{
private:
    Car car;
    std::shared_ptr<TrimLevel> trim;
    std::shared_ptr<ColorOption> color;
    std::vector<std::shared_ptr<AddOn>> addOn;
public:
    explicit CarConfiguration(const Car& car);

    const Car& getCar();

    void setTrim(std::shared_ptr<TrimLevel> trim);
    void setColor(std::shared_ptr<ColorOption> color);
    void toggleAddOn(const std::shared_ptr<AddOn>& addOn);

    const bool hasAddOn(const std::shared_ptr<AddOn>& addOn);
    const int totalPrice() const;
    const std::string summary() const;
};

#endif // _CARCONFIGURATION_H
