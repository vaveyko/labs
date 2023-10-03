#include <iostream>

using std::ifstream;
using std::ofstream;
using std::cout;
using std::cin;

int main()
{
    setlocale(0, "");
    int count, intersection, indexOfSection, maxIntersection;
    bool isIncorrect;
    maxIntersection = 0;
    indexOfSection = 0;
    intersection = 0;

    cout << "Программа принимает координаты отрезков на числовой прямой и "
         << "выводит отрезок с наибольшим количеством пересечений\n";

    do
    {
        isIncorrect = false;
        cout << "Введите количество отрезков\n";
        cin >> count;
        if (cin.fail() || count <= 0)
        {
            cin.clear();
            while (cin.get() != '\n');
            cout << "Error\n";
            isIncorrect = true;
        }
        if (!isIncorrect && cin.get() != '\n')
        {
            cout << "Error\n";
            while (cin.get() != '\n');
            isIncorrect = true;
        }
    } while (isIncorrect);

    //creating array for information
    int** arrOfInf = new int* [count];
    for (int i = 0; i < count; i++)
    {
        arrOfInf[i] = new int[2];
    }

    //filling the array
    for (int i = 0; i < count; i++)
    {
        cout << "введите две координаты границ " << i+1 << "-го отрезка x1 и x2 через пробел или Enter\n";
        do
        {
            isIncorrect = false;
            cin >> arrOfInf[i][0];
            cin >> arrOfInf[i][1];
            if (cin.fail())
            {
                isIncorrect = true;
                cout << "Error\n";
                cin.clear();
                while (cin.get() != '\n');
            }
            if (!isIncorrect && cin.get() != '\n')
            {
                isIncorrect = true;
                cout << "Error\n";
                cin.clear();
                while (cin.get() != '\n');
            }
        } while (isIncorrect);
    }

    //algorithm
    for (int i = 0; i < count; i++)
    {
        intersection = 0;
        for (int j = 0; j < count; j++)
        {
            if (i == j || (arrOfInf[j][0] > arrOfInf[i][1]) || (arrOfInf[j][1] < arrOfInf[i][0]))
            {
                
            }
            else
            {
                intersection++;
            }
                
        }
        if (intersection > maxIntersection)
        {
            maxIntersection = intersection;
            indexOfSection = i;
        }
    }

    //output
    cout << "Наибольшее количество пересечений имеет " << indexOfSection + 1 <<
        "-ый отрезок -- " << maxIntersection << "\n";
    cout << "Координаты  отрезка " << arrOfInf[indexOfSection][0] << ", "
         << arrOfInf[indexOfSection][1];
}