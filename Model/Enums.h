#ifndef ENUMS_H
#define ENUMS_H

#include <string>
#include "../exceptions/showroomexception.h"

enum class Condition {Used, New, Unknowm};

enum class SortField { Year, Price, Mileage};

inline std::string conditionToString(Condition c)
{
    switch (c) {
    case Condition::New:
        return "New";
        break;
    case Condition::Used:
        return "Used";
        break;
    default:
        return "Unknown";
        break;
    }
}

inline Condition conditionFromString(std::string c, int line = 0)
{
    if (c == "New")
    {
        return Condition::New;
    }
    if (c == "Used")
    {
        return Condition::Used;
    }

    throw InvalidFormatException(line, "Unknown state: " + c);
}

#endif // ENUMS_H
