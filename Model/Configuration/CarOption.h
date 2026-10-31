#ifndef CAROPTION_H
#define CAROPTION_H

#include <string>

class CarOption
{
protected:
    std::string name;
    int price;
public:
    CarOption(std::string name, int price);
    virtual ~CarOption() = default;

    std::string getName()const noexcept;
    int getPrice()const noexcept;

    virtual std::string getDescription() const = 0;
};

#endif // CAROPTION_H
