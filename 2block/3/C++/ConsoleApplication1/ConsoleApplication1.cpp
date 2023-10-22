#include <iostream>
#include <fstream>
#include <string>

using std::string;
using std::cin;
using std::cout;
using std::ifstream;
using std::ofstream;

void printInf()
{
	cout << "Program sort even rows of square matrix from larger to smaller\n";
}

int inputNum(const int MIN, const int MAX)
{
	int number;
	bool isIncorrect;
	do
	{
		isIncorrect = false;
		cin >> number;
		if (cin.fail())
		{
			cin.clear();
			cout << "Data is not correct, or number is too large\n";
			while (cin.get() != '\n');
			isIncorrect = true;
		}
		if (!isIncorrect && cin.get() != '\n')
		{
			cin.clear();
			cout << "Data is not correct, or number is too large\n";
			while (cin.get() != '\n');
			isIncorrect = true;
		}
		if (!isIncorrect && (number > MAX || number < MIN))
		{
			cout << "Error, number should be from " << MIN << " to " << MAX << '\n';
			isIncorrect = true;
		}
	} while (isIncorrect);
	return number;
}

int** enterArr(int row, int col, const int MIN, const int MAX)
{
	int** arr = new int*[row];
	int i, j;
	for (i = 0; i < row; i++)
	{
		arr[i] = new int[col];
	}
	for (i = 0; i < row; i++)
	{
		for (j = 0; j < col; j++)
		{
			arr[i][j] = inputNum(MIN, MAX);
		}
	}
	return arr;
}

void printArr(int** arr, int row, int col)
{
	int i, j;
	for (i = 0; i < row; i++)
	{
		for (j = 0; j < col; j++)
		{
			cout << arr[i][j] << " ";
		}
		cout << '\n';
	}
}

void sortArr(int* arr, int size)
{
	bool isNotSorted;
	int i, buffer;
	buffer = 0;
	isNotSorted = true;
	while (isNotSorted)
	{
		isNotSorted = false;
		for (i = 1; i < size; i++)
		{
			if (arr[i - 1] < arr[i])
			{
				isNotSorted = true;
				buffer = arr[i];
				arr[i] = arr[i - 1];
				arr[i - 1] = buffer;
			}
		}
	}
}

void sortEvenRow(int** arr, int row, int col)
{
	int i;
	for (i = 1; i < row; i += 2)
	{
		sortArr(arr[i], col);
	}
}

int** copyArr(int** mainArr, int row, int col)
{
	int i, j;
	int** copiedArr = new int*[row];
	for (i = 0; i < row; i++)
	{
		copiedArr[i] = new int[col];
	}
	for (i = 0; i < row; i++)
	{
		for (j = 0; j < col; j++)
		{
			copiedArr[i][j] = mainArr[i][j];
		}
	}
	return copiedArr;
}

bool thisIsTxtFile(string fileName)
{
	string lastFourChar = fileName.substr(fileName.length() - 4);
	if (lastFourChar == ".txt")
	{
		return true;
	}
	else
	{
		cout << "it is not a .txt file\n";
		return false;
	}
}

bool isFileExist(string nameOfFile)
{
	ifstream file(nameOfFile);
	if (file.is_open())
	{
		file.close();
		return true;
	}
	else
	{
		cout << "this file is not exist\n";
		file.close();
		return false;
	}
}

int readSize(ifstream& file, const int MIN, const int MAX)
{
	int size;
	char next;
	bool isCorrect = true;
	file >> size;
	if (file.fail())
	{
		cout << "size is incorrect";
		file.clear();
		isCorrect = false;
		size = 0;
	}
	next = file.get();
	if (isCorrect && ((next != ' ') && (next != '\n')))
	{
		size = 0;
		isCorrect = false;
		cout << "size is incorrect, remove other simbols or whitespase";
		file.clear();
	}
	if (isCorrect && (size < MIN) || (size > MAX))
	{
		size = 0;
		cout << "Size of array should be from " << MIN << " to " << MAX;
	}
	return size;
}

void chekEnyException(int& size, bool isCorrect, ifstream& file, bool isElemIncorrect, const int MIN, const int MAX)
{
	if (isElemIncorrect)
	{
		size = 0;
		cout << "One of the element is incorrect or out of range [ " << MIN << ", " << MAX << " ]";
	}
	else if (file.eof() && isCorrect)
		cout << "Reading is successfull\n";
	else if (isCorrect)
	{
		size = 0;
		cout << "Count of element is too a lot\n";
	}
	else
	{
		size = 0;
		cout << "Count of element is not enough\n";
	}
}

int** readFile(int& size, string name, const int MIN_SIZE, const int MAX_SIZE, const int MIN_ELEM, const int MAX_ELEM)
{
	int i, j;
	bool isCorrect, isElemIncorrect;
	ifstream file(name);
	size = readSize(file, MIN_SIZE, MAX_SIZE);
	isCorrect = size > 1;
	isElemIncorrect = false;

	int** arr = new int*[size];
	for (i = 0; i < size; i++)
	{
		arr[i] = new int[size];
	}
	for (i = 0; i < size; i++)
	{
		for (j = 0; j < size; j++)
		{
			if (file.eof())
				isCorrect = false;
			else
			{
				file >> arr[i][j];
				if (file.fail())
					isElemIncorrect = true;
				else if (arr[i][j] < MIN_ELEM || arr[i][j] > MAX_ELEM)
					isElemIncorrect = true;
			}
		}
	}
	chekEnyException(size, isCorrect, file, isElemIncorrect, MIN_ELEM, MAX_ELEM);

	file.close();
		return arr;
}

void writeFile(int** defoltArr, int** sortedArr, int size, string name)
{
	int i, j;
	ofstream file(name);
	file << "Defolt array\n";
	for (i = 0; i < size; i++)
	{
		for (j = 0; j < size; j++)
		{
			file << defoltArr[i][j] << " ";
		}
		file << '\n';
	}
	file << "Sorted array\n";
	for (i = 0; i < size; i++)
	{
		for (j = 0; j < size; j++)
		{
			file << sortedArr[i][j] << " ";
		}
		file << '\n';
	}
	file.close();
	cout << "Writing is successfull";
}

bool isFileOk(string name)
{
	return isFileExist(name) && thisIsTxtFile(name);
}

int buttonInf()
{
	int button;
	cout << "Choose a way of input/output of data\n"
		<< "1 -- Console\n"
		<< "2 -- File\n";
	button = inputNum(1, 2);
	return button;
}

int** inputInf(int button, int& size, string& name)
{
	const int MAX_SIZE = 100;
	const int MIN_SIZE = 2; 
	const int MIN_ELEM = -2000000000;
	const int MAX_ELEM = 2000000000;

	int** arr = new int*;;
	bool isIncorrect;
	if (button == 1)
	{
		cout << "Enter size of array, please\n";
		size = inputNum(MIN_SIZE, MAX_SIZE);
		cout << "Now enter the elements\n";
		arr = enterArr(size, size, MIN_ELEM, MAX_ELEM);
	}
	else
	{	
		do
		{
			isIncorrect = false;
			cout << "Enter full path to file\n";
			cin >> name;
			if (isFileOk(name))
			{
				arr = readFile(size, name, MIN_SIZE, MAX_SIZE, MIN_ELEM, MAX_ELEM);
			}
			else
			{
				isIncorrect = true;
			}
		} while (isIncorrect);
	}
	return arr;
}

void outputInf(int** defoltArr, int** sortedArr, int size, int butt, string name)
{
	if (butt == 1)
	{
		cout << "Defolt array\n";
		printArr(defoltArr, size, size);
		cout << "Sorted array\n";
		printArr(sortedArr, size, size);
	}
	else
	{
		if (size > 1)
		{
			writeFile(defoltArr, sortedArr, size, name);
		}
	}
}

int main()
{
	setlocale(0, "");
	int** arrOfNum;
	int** sortedArr;
	int button, size;
	string fileName;

	printInf();
	button = buttonInf();
	arrOfNum = inputInf(button, size, fileName);
	sortedArr = copyArr(arrOfNum, size, size);
	sortEvenRow(sortedArr, size, size);
	outputInf(arrOfNum, sortedArr, size, button, fileName);
	
    return 0;
}