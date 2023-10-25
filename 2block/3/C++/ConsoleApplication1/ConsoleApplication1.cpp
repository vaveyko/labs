#include <iostream>
#include <fstream>
#include <string>

using std::string;
using std::cin;
using std::cout;
using std::ifstream;
using std::ofstream;

const int MAX_SIZE = 100;
const int MIN_SIZE = 2;
const int MIN_ELEM = -2000000000;
const int MAX_ELEM = 2000000000;

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
			cout << "Please, enter again\n";
		}
		if (!isIncorrect && cin.get() != '\n')
		{
			cin.clear();
			cout << "Data is not correct, or number is too large\n";
			while (cin.get() != '\n');
			isIncorrect = true;
			cout << "Please, enter again\n";
		}
		if (!isIncorrect && (number > MAX || number < MIN))
		{
			cout << "Error, number should be from " << MIN << " to " << MAX << '\n';
			isIncorrect = true;
			cout << "Please, enter again\n";
		}
	} while (isIncorrect);
	return number;
}

int **enterArr(int size)
{
	int **arr = new int*[size];
	int i, j;
	for (i = 0; i < size; i++)
	{
		arr[i] = new int[size];
	}
	for (i = 0; i < size; i++)
	{
		for (j = 0; j < size; j++)
		{
			cout << "Enter a" <<  i+1 << j+1 << " element\n";
			arr[i][j] = inputNum(MIN_ELEM, MAX_ELEM);
		}
	}
	return arr;
}

void printArr(int **arr, int size)
{
	int i, j;
	for (i = 0; i < size; i++)
	{
		for (j = 0; j < size; j++)
		{
			cout << arr[i][j] << " ";
		}
		cout << '\n';
	}
}

void sortArr(int *arr, int size)
{
	bool isNotSorted;
	int i, j, buffer;
	buffer = 0;
	isNotSorted = true;
	while (isNotSorted)
	{
		isNotSorted = false;
		for (i = 1; i < size; i++)
		{
			for (j = i; j < size; j++)
			{
				if (arr[j - 1] < arr[j])
				{
					isNotSorted = true;
					buffer = arr[j];
					arr[j] = arr[j - 1];
					arr[j - 1] = buffer;
				}
			}
		}
	}
}

int** copyArr(int** mainArr, int size)
{
	int i, j;
	int** copiedArr = new int* [size];
	for (i = 0; i < size; i++)
	{
		copiedArr[i] = new int[size];
	}
	for (i = 0; i < size; i++)
	{
		for (j = 0; j < size; j++)
		{
			copiedArr[i][j] = mainArr[i][j];
		}
	}
	return copiedArr;
}

int **sortEvenRow(int **arrOfNum, int size)
{
	int i;
	int **arr = copyArr(arrOfNum, size);
	for (i = 1; i < size; i += 2)
	{
		sortArr(arr[i], size);
	}
	return arr;
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

int readSizeFromFile(ifstream &file)
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
	if (isCorrect && (size < MIN_SIZE) || (size > MAX_SIZE))
	{
		size = 0;
		cout << "Size of array should be from " << MIN_SIZE << " to " << MAX_SIZE;
	}
	return size;
}

void chekAnyException(int &size, bool isCorrect, ifstream &file, bool isElemIncorrect)
{
	if (isElemIncorrect)
	{
		size = 0;
		cout << "One of the element is incorrect or out of range [ " << MIN_ELEM << ", " << MAX_ELEM << " ]";
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

int **readFile(int &size, string name)
{
	int i, j;
	bool isCorrect, isElemIncorrect;
	ifstream file(name);
	size = readSizeFromFile(file);
	isCorrect = size > 1;
	isElemIncorrect = false;

	int **arr = new int*[size];
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
				cout << arr[i][j] << std::endl;
				if (file.fail())
					isElemIncorrect = true;
				else if (arr[i][j] < MIN_ELEM || arr[i][j] > MAX_ELEM)
					isElemIncorrect = true;
			}
		}
	}
	chekAnyException(size, isCorrect, file, isElemIncorrect);

	file.close();
	return arr;
}

void writeFile(int **defaultArr, int **sortedArr, int size, string name)
{
	int i, j;
	ofstream file(name);
	file << "Default array\n";
	for (i = 0; i < size; i++)
	{
		for (j = 0; j < size; j++)
		{
			file << defaultArr[i][j] << " ";
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

int userChoice()
{
	int choice;
	cout << "Choose a way of input/output of data\n"
		 << "1 -- Console\n"
		 << "2 -- File\n";
	choice = inputNum(1, 2);
	return choice;
}

int **inputFromConsole(int &size)
{
	cout << "Enter size of array, please\n";
	size = inputNum(MIN_SIZE, MAX_SIZE);
	int** arr = new int* [size];
	for (int i = 0; i < size; i++)
	{
		arr[i] = new int[size];
	}
	cout << "Now enter the elements\n";
	arr = enterArr(size);
	return arr;
}

int **inputFromFile(int &size)
{
	bool isIncorrect;
	int **arr = new int*;
	string name;
	do
	{
		isIncorrect = false;
		cout << "Enter full path to file\n";
		cin >> name;
		if (isFileOk(name))
		{
			arr = readFile(size, name);
		}
		else
		{
			isIncorrect = true;
		}
	} while (isIncorrect);
	return arr;
}

int **inputInf(int &size)
{
	int **arr = new int*;
	int choiceInp = userChoice();
	if (choiceInp == 1)
		arr = inputFromConsole(size);
	else
		arr = inputFromFile(size);
	return arr;
}

void outputInConsole(int **defaultArr, int **sortedArr, int size)
{
	cout << "Default array\n";
	printArr(defaultArr, size);
	cout << "Sorted array\n";
	printArr(sortedArr, size);
}

void outputInFile(int** defaultArr, int** sortedArr, int size)
{
	bool isIncorrect;
	string name;
	do
	{
		isIncorrect = false;
		cout << "Enter full path to file\n";
		cin >> name;
		if (isFileOk(name))
		{
			writeFile(defaultArr, sortedArr, size, name);
		}
		else
		{
			isIncorrect = true;
		}
	} while (isIncorrect);
}

void outputInf(int **defaultArr, int **sortedArr, int size)
{
	if (size > 1)
	{
		int choiceOut = userChoice();
		if (choiceOut == 1)
		{
			outputInConsole(defaultArr, sortedArr, size);
		}
		else
		{
			outputInFile(defaultArr, sortedArr, size);
		}
	}
}

int main()
{
	int **arrOfNum;
	int **sortedArr;
	int size;

	printInf();
	arrOfNum = inputInf(size);
	sortedArr = sortEvenRow(arrOfNum, size);
	outputInf(arrOfNum, sortedArr, size);
	
    return 0;
}