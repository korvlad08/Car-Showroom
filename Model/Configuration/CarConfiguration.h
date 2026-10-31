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
    std::vector<std::shared_ptr<AddOn>> addOns;
public:
    explicit CarConfiguration(const Car& car);

    const Car& getCar() const noexcept;
    std::shared_ptr<TrimLevel> getTrim() const noexcept;
    std::shared_ptr<ColorOption> getColor() const noexcept;
    const std::vector<std::shared_ptr<AddOn>>& getAddOns() const noexcept;

    void setTrim(std::shared_ptr<TrimLevel> trim);
    void setColor(std::shared_ptr<ColorOption> color);
    void toggleAddOn(const std::shared_ptr<AddOn>& addOn);

    bool hasAddOn(const std::shared_ptr<AddOn>& addOn) const;
    int totalPrice() const;     // base price + trim + color + add-ons
    int surcharge() const;      // totalPrice() without the base price
    std::string summary() const;

    Car result() const;         // copy of the car with trim, color and surcharge applied
};

#endif // _CARCONFIGURATION_H
