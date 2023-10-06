#include <iostream>
using std::cout;
using std::cin;

//Дано натуральное число n.Найти все меньшие n числа Мерсена.
//(Простое число называется числом Мерсена, если оно может быть представлено в виде 2р – 1, где р – тоже простое число.
bool isNumSimple(int numb)
{
	float numbSqrt;
	numbSqrt = sqrt(numb) + 1;
	if (numb < 4)
	{
		return true;
	}
	else
		for (int i = 2; i < numbSqrt; i++)
		{
			if (numb % i == 0)
				return false;
			else
				return true;
		}
}

int countSimp(int numb)
{
	int count;
	count = 0;
	for (int i = 1; i < numb; i++)
		if (isNumSimple(i))
			count++;
	return count;
}

int* fillSimpArr(int numb)
{
	int* arrSimpNumb = new int[countSimp(numb)];
	int j;
	j = 0;
	for (int i = 1; i < numb; i++)
		if (isNumSimple(i))
		{
			arrSimpNumb[j] = i;
			cout << i << ' ';
			j++;
		}
	return arrSimpNumb;
}

int main()
{
	int numCount;
	cin >> numCount;
	fillSimpArr(numCount);

	/*cout << isNumSimple(13);
	cout << isNumSimple(20);
	cout << isNumSimple(1);
	cout << isNumSimple(2);
	cout << isNumSimple(3);
	cout << isNumSimple(4);
	cout << isNumSimple(5);
	cout << isNumSimple(6);*/
}