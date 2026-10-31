#ifndef CAR_H
#define CAR_H

#include <string>

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

    std::string engine;
    double consumption = 0.0;

    std::string trim;
    std::string color;
    int optionsPrice = 0;

    int id;

    static int currentYear();
public:
    Car();
    explicit Car(const std::string brand, const std::string model, int year, int price, int mileage,
                 Condition condition, const std::string& engine = "", double consumption = 0.0);

    const std::string getBrand() const noexcept;
    const std::string getModel() const noexcept;
    int getYear() const noexcept;
    int getPrice() const noexcept;
    int getMileage() const noexcept;
    Condition getCondition() const noexcept;

    const std::string& getEngine() const noexcept;
    double getConsumption() const noexcept;

    const std::string& getTrim() const noexcept;
    const std::string& getColor() const noexcept;
    int getOptionsPrice() const noexcept;
    int getTotalPrice() const noexcept;

    int getId() const noexcept;

    std::string getFullName() const;

    bool isConfigured() const noexcept;

    void setBrand(std::string brand);
    void setModel(std::string model);
    void setYear(int year);
    void setPrice(int price);
    void setMileage(int mileage);
    void setCondition(Condition condition);
    void setEngine(const std::string& engine);
    void setConsumption(double consumption);

    void setConfiguration(const std::string& trim, const std::string& color, int optionsPrice);

    void setId(int id);

    void clearConfiguration();
    void validate() const;
};

#endif // CAR_H