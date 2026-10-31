#include "search.h"
#include <algorithm>
#include <cctype>

Search::Search()
{
    searchText="";
    minPrice=0;
    maxPrice=0;
    condition=std::nullopt;
}

Search::Search(std::string searchText, int minPrice, int maxPrice, std::optional<Condition> condition)
{
    this->searchText=searchText;
    this->minPrice=minPrice;
    this->maxPrice=maxPrice;
    this->condition=condition;
}

std::string Search::getSearchText() const noexcept
{
    return searchText;
}

int Search::getMinPrice() const noexcept
{
    return minPrice;
}

int Search::getMaxPrice() const noexcept
{
    return maxPrice;
}

std::optional<Condition> Search::getCondition() const noexcept
{
    return condition;
}

void Search::setSearchText(std::string searchText)
{
    if(searchText.empty())
    {
        throw ValidationException("Search text", "Search text cannot be empty");
    }
    this->searchText=searchText;
}

void Search::setMinPrice(int minPrice)
{
    if(minPrice>0)
    {
        throw ValidationException("Price","Price must be greater than 0");
    }
    this->minPrice=minPrice;
}

void Search::setMaxPrice(int maxPrice)
{
    if(maxPrice>0)
    {
        throw ValidationException("Price","Price must be greater than 0");
    }
    this->maxPrice=maxPrice;
}

void Search::setCondition(std::optional<Condition> condition)
{
    this->condition=condition;
}

std::string toLower(std::string s)
{
    std::transform(s.begin(), s.end(), s.begin(),[](unsigned char c)
        {
            return std::tolower(c);
        });

    return s;
}

bool Search::matches(const Car& car) const
{
    if(!searchText.empty() && toLower(car.getFullName()).find(toLower(searchText)) == std::string::npos)
    {
        return false;
    }

    int price = car.getTotalPrice();
    if(minPrice>0 && price<minPrice)
    {
        return false;
    }
    if(maxPrice>0 && price>maxPrice)
    {
        return false;
    }

    if(condition.has_value() && car.getCondition() != *condition)
    {
        return false;
    }

    return true;
}
