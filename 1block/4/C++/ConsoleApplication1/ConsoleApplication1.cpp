#include <iostream>
using namespace std;

int main()
{
    setlocale(0, "");
    const int MINVALUE = 1;
    const int MAXVALUE = 100;
    int lenOfArr = 0;
    int answer = 0;
    bool isIncorrect = false;
    cout << "Программа вычисляет сумму элементов стоящих на нечетных местах в данном массиве\n";
    do 
    {
        cout << "Введите количество элементов в массиве\n";
        cin >> lenOfArr;
        isIncorrect = cin.fail();
        if (isIncorrect)
        {
            cout << "Неверные входные данные\n";
            cin.clear();
            while (cin.get() != '\n');
        }
        else
        {
            isIncorrect = lenOfArr < MINVALUE || lenOfArr > MAXVALUE;
            if (isIncorrect)
            {  
                cout << "Количество элементов в массиве должно быть больше " << MINVALUE << " и меньше " << MAXVALUE << "\n";
            }
        }
    } while (isIncorrect);
    // initialization and filling the array
    int *arr = new int[lenOfArr];
    for (int i = 0; i < lenOfArr; i++) 
    {
        do 
        {
            cout << "Введите " << (i + 1) << " элемент\n";
            cin >> arr[i];
            isIncorrect = cin.fail();
            if (isIncorrect)
            {
                cout << "Неверные входные данные\n";
                cin.clear();
                while (cin.get() != '\n');
            }
        } while (isIncorrect);
    }
    cout << ("Элементы на нечетых местах");
    for (int i = 0; i < lenOfArr; i+=2) 
    {
        answer += arr[i];
        cout << ", " << arr[i];
    }
    delete[] arr;
    cout << "\nСумма равна -- " << answer;
    return 0;
}