#ifndef SHELLSORT_H
#define SHELLSORT_H

#include "../Model/Car.h"
#include "../Model/Enums.h"

#include<vector>

int compare(const Car& a, const Car& b, SortField field);

void ShellSort(std::vector<Car>& cars, SortField field, bool asc);

#endif // SHELLSORT_H
