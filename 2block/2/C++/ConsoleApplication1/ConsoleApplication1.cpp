#include <iostream>
using std::cout;
using std::cin;


const unsigned int MAX_VALUE = 3000000000;
const int MIN_VALUE = 1;

void printInf()
{
	cout << "Программа вычисляет все числа Марсена меньше n, где n [" << MIN_VALUE << ", " << MAX_VALUE << "]\n";
	cout << "Число Мерсена -- простое число, которое можно представить в виде 2^р – 1, где р – тоже простое число.\n";
}

unsigned int inputNum()
{
	unsigned int number;
	bool isIncorrect;
	do
	{
		isIncorrect = false;
		cin >> number;
		if (cin.fail())
		{
			cin.clear();
			cout << "Ошибка, введите только число\n";
			while (cin.get() != '\n');
			isIncorrect = true;
		}
		if (!isIncorrect && cin.get() != '\n')
		{
			cin.clear();
			cout << "Ошибка, введите только число\n";
			while (cin.get() != '\n');
			isIncorrect = true;
		}
		if (!isIncorrect && (number > MAX_VALUE || number < MIN_VALUE))
		{
			cout << "Ошибка, число должно быть больше " << MIN_VALUE << " и меньше " << MAX_VALUE << '\n';
			isIncorrect = true;
		}
	} while (isIncorrect);
	return number;
}

bool isNumSimple(int numb)
{
	float numbSqrt;
	bool isNumSimp;
	isNumSimp = false;
	numbSqrt = sqrt(numb) + 1;
	if (numb < 4)
	{
		isNumSimp = true;
	}
	else
		for (int i = 2; i < numbSqrt; i++)
		{
			if (numb % i == 0)
				return false;
		}
	return true;
}

void printMersNum(unsigned int highBorder)
{
	bool isBordIncros;
	int mersenNum, i;
	mersenNum = 1;
	i = 2;
	isBordIncros = true;
	while (isBordIncros)
	{
		mersenNum = mersenNum * 2 +1;
		isBordIncros = mersenNum < highBorder;
		if (isBordIncros && isNumSimple(i) && (isNumSimple(mersenNum)))
			cout << "Mersen(" << i << ") -- " << mersenNum << '\n';
		i++;
	} 
}

int main()
{
	setlocale(0, "");
	printInf();
	printMersNum(inputNum());
	return 0;
}