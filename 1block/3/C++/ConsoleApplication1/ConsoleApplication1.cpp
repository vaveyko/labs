#include <iostream>
using std::cout;
using std::cin;

int main() 
{
    setlocale(0, "");
    const int MINVALUE = 1;
    const int MAXVALUE = 1000000;
    bool isIncorrect = false;
    int num = 0;
    int lenOfNum = 0;
    cout << "Программа считает количество цифр в натуральном числе n\n";
    do
    {
        cout << "Введите натуральное число\n";
        cin >> num;
        isIncorrect = cin.fail();
        if (isIncorrect)
        {
            cout << "Не корректные данные\n";
            cin.clear();
            while (cin.get() != '\n');
        }
        else if (num < MINVALUE || num > MAXVALUE)
        {
            cout << "Число должно быть в промежутке от " << MINVALUE << " до " << MAXVALUE << "\n";
            isIncorrect = true;
            
        }
        
    } while (isIncorrect);
    while (num > 0)
    {
        num /= 10;
        lenOfNum++;
    }
    cout << "Длинна этого числа -- " << lenOfNum << "\n";
    return 0;
}