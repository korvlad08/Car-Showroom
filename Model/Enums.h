#ifndef ENUMS_H
#define ENUMS_H

#include <string>
#include "../exceptions/InvalidFormatException.h"

enum class Condition {Used, New};

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
    switch (c) {
    case "New":
        return Condition::New;
        break;
    case "Used":
        return Condition::Used;
        break;
    default:
        throw InvalidFormatException(line, "Невідомий стан авто: " + s +"\n");
        break;
    }
}

#endif // ENUMS_H
