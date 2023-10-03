#include <iostream>

using std::cout;
using std::cin;

int main()
{
    setlocale(0, "");
    int countElem, indexOfNeededElem;
    int maxValue, minValue;
    float absDistanse, minAbsDistanse, average, sum;
    bool isIncorrect;
    maxValue = INT_MAX;
    minValue = INT_MIN;
    sum = 0;
    countElem = 0;
    indexOfNeededElem = 0;
    average = 0;
    absDistanse = 0;

    cout << "Программа принимает числовую последовательность и"
         << "выводит элемент наиболее \nблизкий по своему значению "
         << "к среднему арифметическому последовательности\n";

    do
    {
        isIncorrect = false;
        cout << "Введите количество элементов\n";
        cin >> countElem;
        if (cin.fail() || countElem < 1)
        {
            cin.clear();
            while (cin.get() != '\n');
            cout << "Неверные входные данные\n";
            isIncorrect = true;
        }
        if (!isIncorrect && cin.get() != '\n')
        {
            while (cin.get() != '\n');
            isIncorrect = true;
        }
    } while (isIncorrect);
    maxValue = (maxValue / countElem) - 1;
    minValue = -maxValue;

    //creating array for information
    int* arrOfInf = new int[countElem];

    //filling the array
    for (int i = 0; i < countElem; i++)
    {
        cout << "введите " << i + 1 << " элемент последовательности\n";
        do
        {
            isIncorrect = false;
            cin >> arrOfInf[i];
            if (cin.fail())
            {
                isIncorrect = true;
                cout << "Неверные входные данные\n";
                cin.clear();
                while (cin.get() != '\n');
            }
            if (!isIncorrect && cin.get() != '\n')
            {
                isIncorrect = true;
                cout << "Неверные входные данные\n";
                cin.clear();
                while (cin.get() != '\n');
            }
            else if (arrOfInf[i] > maxValue or arrOfInf[i] < -maxValue)
            {
                isIncorrect = true;
                cout << "Из-за количества элементов они должны находиться"
                    << " в промежутке от " << maxValue << " до " << maxValue << '\n';
            }
        } while (isIncorrect);
    }

    //algorithm
    for (int i = 0; i < countElem; i++)
    {
        sum += arrOfInf[i];
    }
    average = sum / countElem;
    minAbsDistanse = average;
    for (int i = 0; i < countElem; i++)
    {
        absDistanse = abs(average - arrOfInf[i]);
        if (absDistanse < minAbsDistanse)
        {
            minAbsDistanse = absDistanse;
            indexOfNeededElem = i;
        }
    }

    cout << "Среднее арифметическое -- " << average
         << "\nБлижайший элемент -- " << arrOfInf[indexOfNeededElem];
    delete[] arrOfInf;
}