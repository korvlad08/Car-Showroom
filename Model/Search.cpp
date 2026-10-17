#include "search.h"

Search::Search()
{
    searchText="";
    minPrice=0;
    maxPrice=0;
    condition=std::nullopt;
}

Search::Search(std::string searchText, int minPrice, int maxPrice, std::optional<Condtition> condition)
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
    return minPrice();
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
    if(brand.empty())
    {
        throw ValidationException("Пошуковий текст", "Текс пошуку не може бути порожнім");
    }
    this->searchText=searchText;
}

void Search::setMinPrice(int minPrice)
{
    if(minPrice>0)
    {
        throw ValidationException("Ціна","Ціна має бути більше 0");
    }
    this->minPrice=minPrice;
}

void Search::setMaxPrice(int maxPrice)
{
    if(maxPrice>0)
    {
        throw ValidationException("Ціна","Ціна має бути більше 0");
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
    if(!(this->searchText == car.getFullName()))
    {
        return false;
    }

    if(!searchText.empty() && toLower(car.getFullName()).find(toLower(searchText)) == std::string::npos)
    {
        return false;
    }

    if(!(car.getCondition() == this->condition()))
    {
        return false;
    }

    return true;
}
