#ifndef TRIMLEVEL_H
#define TRIMLEVEL_H

#include "CarOption.h"
#include <vector>

class TrimLevel : public CarOption
{
private:
    std::vector<std::string> features;
public:
    TrimLevel(const std::string& name, int price, const std::vector<std::string>& features);

    const std::vector<std::string>& getFeatures() const noexcept;

    std::string getDescription() const override;
};

#endif // TRIMLEVEL_H
