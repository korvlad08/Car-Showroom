#ifndef CAR_H
#define CAR_H

#include <string.h>
#include "Enums.h"

class Car
{
private:
    std::string brand;
    std::string model;
    int year;
    int price;
    int mileage;
    Condition condition;

    static int currentYear();
public:
    explicit Car();
    explicit Car(const std::string brand, const std::string model, int year, int price, int mileage, Condition condition);

    const std::string getBrand() const noexcept;
    const std::string getModel() const noexcept;
    int getYear() const noexcept;
    int getPrice() const noexcept;
    int getMileage() const noexcept;
    Condition getCondition() const noexcept;

    std::string getFullName() const;

    void setBrand(std::string brand);
    void setModel(std::string model);
    void setYear(int year);
    void setPrice(int price);
    void setMileage(int mileage);
    void setCondition(Condition condition);

    void validate() const;
};

#endif // CAR_H