#include <iostream>
using namespace std;

int main()
{
    setlocale(0, "");
    bool isIncorrect = false;
    int countNum = 0;
    unsigned long long multipliedNum = 2;
    const int MINVALUE = 2;
    const int MAXVALUE = 15;
    cout << "Эта программа считает произведение 2*4*6*...*2n для заданного n\n";
    cout << "Число n должно быть от " << MINVALUE << " и до " << MAXVALUE << "\n";
    do
    {
        isIncorrect = false;
        cout << "Введите n\n";
        cin >> countNum;
        if (cin.fail())
        {
            cout << "Не корректные данные.\n";
            cin.clear();
            while (cin.get() != '\n');
            isIncorrect = true;
        }
        if (!isIncorrect && ((countNum < MINVALUE) || (countNum > MAXVALUE)))
        {
            cout << "Число n должно находиться в промежутке (" << MINVALUE << ", " <<
                MAXVALUE << ")\n";
            isIncorrect = true;
        }
    } while (isIncorrect);
    cout << multipliedNum;
    for (int i = MINVALUE; i < countNum + 1; i++)
    {
        cout << " * " << 2 * i;
        multipliedNum *= 2 * i;
    }
    cout << " = " << multipliedNum;
    return 0;
}
