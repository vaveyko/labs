#include <iostream>
#include <fstream>
#include <string>

using std::string;
using std::cin;
using std::cout;
using std::endl;
using std::ifstream;
using std::ofstream;

const int MIN_ELEM = -2147483647;
const int MAX_ELEM = 2147483647;

const string ERRORS[] = {"Successfull",
                          "Data is not correct, or number is too large\n",
                          "Enter the number within the borders\n",
                          "This is not a .txt file\n",
                          "This file is not exist\n",
                          "Data in file is not correct, or number is too large\n",
                          "There is only one number in file should be (without whitespace)\n"};

void printInf()
{
    cout << "Program converts decimal to hexadecimal\n";
}

int getLenOfNum(int num)
{
    int len = 1;
    while (num > 9) {
        len++;
        num /= 10;
    }
    return len;
}

void fillWithZero(char *arr, int size) {
    int i;
    for (i = 0; i < size; i++) {
        arr[i] = '0';
    }
}

char *intToHexArr(int num, int size, bool isNumNegative)
{
    const char HEX_ELEM[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8',
                              '9', 'A', 'B', 'C', 'D', 'E', 'F', '-' };
    if (isNumNegative)
        num = -num;
    int index = 0;
    char *hexNumArr = new char[size];
    fillWithZero(hexNumArr, size);
    if (num > 15) 
    {
        while (num > 1) 
        {
            hexNumArr[index++] = HEX_ELEM[num % 16];
            num /= 16;
        }
    }
    else
    {
        hexNumArr[index] = HEX_ELEM[num];
        index++;
    }
    if (isNumNegative)
        hexNumArr[index] = HEX_ELEM[16];
    return hexNumArr;
}

char *reversArr(char *arr, int size) {
    char *reversedArr = new char[size];
    int index = 0;
    int i = size - 1;
    while (index < size) {
        reversedArr[index++] = arr[i--];
    }
    return reversedArr;
}

int inputNum(int &number, const int MIN, const int MAX)
{
    int err = 0;
    bool isIncorrect = false;
    cin >> number;
    if (cin.fail())
    {
        err = 1;
        cin.clear();
        while (cin.get() != '\n');
        isIncorrect = true;            
    }
    if (!isIncorrect && cin.get() != '\n')
    {
        err = 1;
        while (cin.get() != '\n');
        isIncorrect = true;
    }
    if (!isIncorrect && (number > MAX || number < MIN))
    {
        err = 2;
        isIncorrect = true;
    }
    return err;
}

int userChoice()
{
    int choice;
    cout << "Choose a way of input/output of data\n"
        << "1 -- Console\n"
        << "2 -- File\n";
    int err = inputNum(choice, 1, 2);
    while (err != 0)
    {
        cout << ERRORS[err];
        cout << "Please, enter again\n";
        err = inputNum(choice, 1, 2);
    }
    return choice;
}

void inputFromConsole(int& num)
{
    cout << "Enter the number from " << MIN_ELEM << " to " << MAX_ELEM << "\n";
    int err = inputNum(num, MIN_ELEM, MAX_ELEM);
    while (err != 0)
    {
        cout << ERRORS[err];
        cout << "Please, enter again\n";
        err = inputNum(num, MIN_ELEM, MAX_ELEM);
    }
}

int readFile(int& num, string fileName)
{
    int err = 0;
    bool isCorrect = true;
    ifstream file(fileName);
    file >> num;
    if (file.fail())
    {
        err = 5;
        file.clear();
        while (!file.eof())
            file.get();
        isCorrect = false;
    }
    if (file.eof()) {
        err = 0;
        isCorrect = false;
    }
    if (isCorrect && (file.get() != '\n'))
    {
        err = 6;
        while (!file.eof())
            file.get();
        isCorrect = false;
    }
    if (isCorrect && (num < MIN_ELEM || num > MAX_ELEM)){
        err = 2;
    }
    file.close();
    return err;
}

int isFileExist(string nameOfFile)
{
    int err = 0;
    ifstream file(nameOfFile);
    if (!file.is_open())
        err = 4;

    file.close();
    return err;
}

int thisIsTxtFile(string &fileName)
{
    int err = 0;
    if (fileName.length() > 4)
    {
        string lastFourChar = fileName.substr(fileName.length() - 4);
        if (lastFourChar != ".txt")
            err = 3;
    }
    else
        err = 3;
    return err;
}

string getFileName()
{
    bool isIncorrect;
    string name;
    int errExist = 0;
    int errTxt = 0;
    do
    {   
        cin >> name;
        errExist = isFileExist(name);
        errTxt = thisIsTxtFile(name);

        isIncorrect = false;
        if (errTxt != 0)
        {
            cout << ERRORS[errTxt];
            isIncorrect = true;
        }
        else if (errExist != 0)
        {
            cout << ERRORS[errExist];
            isIncorrect = true;
        }
        while (cin.get() != '\n');
    } while (isIncorrect);
    return name;
}

void inputFromFile(int& num)
{
    cout << "Enter full path to file\n";
    string fileName = getFileName();
    int err = readFile(num, fileName);
    while (err != 0)
    {
        cout << ERRORS[err];
        cout << "Please, enter full path again\n";
        fileName = getFileName();
        err = readFile(num, fileName);
    }
    cout << "Reading is successfull\n";
}

int inputInf()
{
    int num;
    int choice = userChoice();
    if (choice == 1)
        inputFromConsole(num);
    else
        inputFromFile(num);
    return num;
}

char *getArrOfHexDigit(int num, int &size)
{
    bool isNumNegative = num < 0;
    size = getLenOfNum(num);
    char *arr = intToHexArr(num, size, isNumNegative);
    return reversArr(arr, size);
}

void outputInConsole(int num, char* arr, int size)
{
    int index = 0;
    int i;
    cout << "Decimal number:\n";
    cout << num << endl;
    cout << "Hexadecimal number:\n";
    if (size > 1)
    {
        while (arr[index] == '0')
            index++;
        for (i = index; i < size; i++)
            cout << arr[i];
    }
    else
        cout << arr[index];
}

void outputInFile(int num, char* arr, int size)
{
    int index = 0;
    int i;
    cout << "Enter full path to file\n";
    string fileName = getFileName();
    ofstream file(fileName);
    file << "Decimal number:\n";
    file << num << endl;
    file << "Hexadecimal number:\n";
    if (size > 1)
    {
        while (arr[index] == '0')
            index++;
        for (i = index; i < size; i++)
            file<< arr[i];
    }
    else
        file << arr[index];
    cout << "Writing is successfull\n";
    file.close();
}

void outputInf(int num, char* arrOfDigit, int size)
{
    int choice = userChoice();
    if (choice == 1)
        outputInConsole(num, arrOfDigit, size);
    else
        outputInFile(num, arrOfDigit, size);
}


int main()
{
    int num, size;
    
    printInf();
    num = inputInf();
    char *arrOfDigit = getArrOfHexDigit(num, size);
    outputInf(num, arrOfDigit, size);

    return 0;
}