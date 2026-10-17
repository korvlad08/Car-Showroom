#ifndef SEARCH_H
#define SEARCH_H

#include "car.h"
#include "Enums.h"
#include <optional>

class Search
{
private:
    std::string searchText;
    int minPrice;
    int maxPrice;
    std::optional<Condition> condition;

public:
    explicit Search();
    explicit Search(std::string searchText, int minPrice, int maxPrice, std::optional<Condtition> condition);

    std::string getSearchText() const noexcept;
    int getMinPrice() const noexcept;
    int getMaxPrice() const noexcept;
    std::optional<Condition> getCondition() const noexcept;

    void setSearchText(std::string searchText);
    void setMinPrice(int minPrice);
    void setMaxPrice(int maxPrice);
    void setCondition(std::optional<Condition> condition);

    bool matches(const Car& car) const;
};

std::string toLower(std::string s);

#endif // SEARCH_H
