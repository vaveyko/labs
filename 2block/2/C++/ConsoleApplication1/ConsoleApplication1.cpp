#include <iostream>
using std::cout;
using std::cin;

//Дано натуральное число n.Найти все меньшие n числа Мерсена.
//(Простое число называется числом Мерсена,
//если оно может быть представлено в виде 2р – 1, где р – тоже простое число.

void printArr(int* arrNumb, int numElem)
{
	for (int i = 0; i < numElem; i++)
		cout << arrNumb[i] << "  ";
}

//TODO add array of simple numbers in this function
void arrMersen(int highBorder)
{
	int mersenNum;
	mersenNum = 0;
	for (int i = 0; mersenNum < highBorder; i++)
	{
		mersenNum = pow(2, i) - 1;
		cout << "Mersen(" << "";
	}
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

int countSimp(int numb)
{
	int count;
	count = 0;
	++numb;
	for (int i = 1; i < numb; i++)
		if (isNumSimple(i))
			count++;
	return count;
}

int* fillSimpArr(int numb)
{
	int count;
	int* arrSimpNumb = new int[countSimp(numb)];
	count = 0;
	++numb;
	for (int i = 1; i < numb; i++)
		if (isNumSimple(i))
		{
			arrSimpNumb[count++] = i;
			cout << i << ' ';
		}
	return arrSimpNumb;
}

int main()
{

	int numbElem;
	int* arrOfSimp = new int;
	arrOfSimp = fillSimpArr(31);
	printArr(arrOfSimp, countSimp(31));


	/*cout << isNumSimple(20);
	cout << isNumSimple(1);
	cout << isNumSimple(2);
	cout << isNumSimple(3);
	cout << isNumSimple(4);
	cout << isNumSimple(5);
	cout << isNumSimple(6);*/
}