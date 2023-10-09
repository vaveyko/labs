#include <iostream>
using std::cout;
using std::cin;

//Дано натуральное число n.Найти все меньшие n числа Мерсена.
//(Простое число называется числом Мерсена,
//если оно может быть представлено в виде 2р – 1, где р – тоже простое число.

const unsigned int MAX_VALUE = 3000000000;

unsigned int parseInt()
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
			cout << "Error\n";
			while (cin.get() != '\n');
			isIncorrect = true;
		}
		if (!isIncorrect && cin.get() != '\n')
		{
			cin.clear();
			cout << "Error, enter only a number\n";
			while (cin.get() != '\n');
			isIncorrect = true;
		}
		if (!isIncorrect && number > MAX_VALUE)
		{
			cout << "Error, number must be smaller then " << MAX_VALUE << '\n';
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

void mersenNum(unsigned int highBorder)
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
	unsigned int highBorder;
	highBorder = parseInt();
	mersenNum(highBorder);
	return 0;
}