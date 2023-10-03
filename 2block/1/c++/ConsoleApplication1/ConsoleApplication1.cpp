#include <iostream>

using std::ifstream;
using std::ofstream;
using std::cout;
using std::cin;

int main()
{
    setlocale(0, "");
    int count, intersection;
    bool isIncorrect;
    intersection = 0;

    do
    {
        isIncorrect = false;
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
            cout << "Error";
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

    //algoritm
    for (int i = 0; i < count; i++)
    {
        for (int j = 0; j < count; j++)
        {
            if (i = j || (arrOfInf[j][0] > arrOfInf[i][1]) || (arrOfInf[j][1] < arrOfInf[i][0]))
            {
                
            }
            else
            {
                cout << "+";
                intersection++;
            }
                
        }
        cout << "______\n" << intersection << "\n______\n";
        intersection = 0;
    }

    //output the array
    for (int i = 0; i < count; i++)
    {
        cout << arrOfInf[i][0] << "-----";
        cout << arrOfInf[i][1];
        cout << '\n';
    }
}