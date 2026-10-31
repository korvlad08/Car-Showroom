#include "TrimLevel.h"

TrimLevel::TrimLevel(const std::string& name, int price, const std::vector<std::string>& features)
    : CarOption(name, price), features(features){}

const std::vector<std::string>& TrimLevel::getFeatures() const noexcept
{
    return features;
}

std::string TrimLevel::getDescription() const
{
    if(features.empty())
    {
        return name;
    }

    std::string result = name + ": ";
    for(size_t i = 0; i<features.size(); i++)
    {
        if(i>0)
        {
            result+=", ";
        }

        result += features[i];
    }

    return result;
}