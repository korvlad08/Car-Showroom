#include "ShellSort.h"

int compare(const Car& a, const Car& b, SortField field)
{
    switch (field) {
    case SortField::Price:
        if(a.getPrice()<b.getPrice())
        {
            return -1;
        }
        else if(a.getPrice()==b.getPrice())
        {
            return 0;
        }
        else
        {
            return 1;
        }

    case SortField::Year:
        if(a.getYear()<b.getYear())
        {
            return -1;
        }
        else if(a.getYear()==b.getYear())
        {
            return 0;
        }
        else
        {
            return 1;
        }

    case SortField::Mileage:
        if(a.getMileage()<b.getMileage())
        {
            return -1;
        }
        else if(a.getMileage()==b.getMileage())
        {
            return 0;
        }
        else
        {
            return 1;
        }

    default:
        return 0;
    }
}

void ShellSort(std::vector<Car>& cars, SortField field, bool asc)
{
    int n = static_cast<int>(cars.size());

    for (int gap = n/2; gap > 0; gap/=2)
    {
        for (int i = gap; i < n; i++)
        {
            Car temp=cars[i];
            int j;

            for (j=i;j>=gap; j-=gap)
            {
                int c = compare(cars[j - gap], temp, field);
                if (!asc)
                {
                    c=-c;
                }

                if(c<=0)
                {
                    break;
                }

                cars[j]=cars[j-gap];
            }

            cars[j]=temp;
        }
    }
}