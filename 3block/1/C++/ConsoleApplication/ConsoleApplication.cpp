#include <iostream>
#include <fstream>
#include <string>

using namespace std;

const int SUCCESS = 0;
const int INCORRECT_DATA = 1;
const int EMPTY_LINE = 2;
const int NOT_TXT = 3;
const int FILE_NOT_EXIST = 4;
const int INCORRECT_DATA_FILE = 5;
const int A_LOT_OF_DATA_FILE = 6;
const int FILE_NOT_AVAILABLE = 7;
const string DIGITS[10] = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};

const string ERRORS[] = { "Successfull",
                          "Data is not correct, or number is too large\n",
                          "Line is empty, please be careful\n",
                          "This is not a .txt file\n",
                          "This file is not exist\n",
                          "Data in file is not correct, or number is too large\n",
                          "There is only one line in file should be\n" };

void printInf()
{
    cout << "Program selects a substring consisting of digits corresponding "
         << "to an integer \n(starts with a '+' or '-' "
         << " and there are no letters and dots inside the substring\n";
}

string getNumFromLine(string line)
{
    string num;
    int size, i;
    bool isNumNotExist, isNotEnd;
    isNumNotExist = true;
    isNotEnd = true;
    num = "not exist";
    for (i = 0; i < line.length(); i++)
    {
        if (!isNumNotExist && isNotEnd)
        {
            if (isdigit(line[i]))
                num += line[i];
            else
                isNotEnd = false;
        }
        if (isNumNotExist && (line[i] == '-' || line[i] == '+'))
        {
            num = line[i];
            isNumNotExist = false;
        }
    }
    return num;
}

int inpChoice(int& choice)
{
    int err;
    string choiceStr;
    err = SUCCESS;
    getline(cin, choiceStr);
    if (choiceStr == "1" || choiceStr == "2")
        choice = stoi(choiceStr);
    else
        err = INCORRECT_DATA;
    return err;
}

int userChoice()
{
    int choice;
    cout << "Choose a way of input/output of data\n"
        << "1 -- Console\n"
        << "2 -- File\n";
    int err = inpChoice(choice);
    while (err != 0)
    {
        cout << ERRORS[err];
        cout << "Please, enter again\n";
        err = inpChoice(choice);
    }
    return choice;
}

int inpValidLine(string& line)
{
    int err;
    err = SUCCESS;
    getline(cin, line);
    if (line.length() == 0)
        err = EMPTY_LINE;
    return err;
}

void inputFromConsole(string& line)
{
    cout << "Enter the line\n";
    int err = inpValidLine(line);
    while (err != 0)
    {
        cout << ERRORS[err];
        cout << "Please, enter again\n";
        err = inpValidLine(line);
    }
}

int readFile(string &line, string fileName)
{
    int err = SUCCESS;
    bool isCorrect = true;
    ifstream file(fileName);
    getline(file, line);
    if (!file.eof())
        err = A_LOT_OF_DATA_FILE;
    if (line.length() == 0)
        err = EMPTY_LINE;
    file.close();
    return err;
}

int isFileExist(string nameOfFile)
{
    int err = SUCCESS;
    ifstream file(nameOfFile);
    if (!file.is_open())
        err = FILE_NOT_EXIST;

    file.close();
    return err;
}

int thisIsTxtFile(string& fileName)
{
    int err = SUCCESS;
    if (fileName.length() > 4)
    {
        string lastFourChar = fileName.substr(fileName.length() - 4);
        if (lastFourChar != ".txt")
            err = NOT_TXT;
    }
    else
        err = NOT_TXT;
    return err;
}

string getFileName()
{
    bool isIncorrect;
    string name;
    int errExist = 0;
    int errTxt = 0;
    cout << "Enter full path to file\n";
    do
    {
        getline(cin, name);
        errExist = isFileExist(name);
        errTxt = thisIsTxtFile(name);

        isIncorrect = false;
        if (errTxt > 0)
        {
            cout << ERRORS[errTxt];
            isIncorrect = true;
        }
        else if (errExist > 0)
        {
            cout << ERRORS[errExist];
            isIncorrect = true;
        }
    } while (isIncorrect);
    return name;
}

void inputFromFile(string &line)
{
    string fileName = getFileName();
    int err = readFile(line, fileName);
    while (err != 0)
    {
        cout << ERRORS[err];
        fileName = getFileName();
        err = readFile(line, fileName);
    }
    cout << "Reading is successfull\n";
}

string inputInf()
{
    string line;
    int choice = userChoice();
    if (choice == 1)
        inputFromConsole(line);
    else
        inputFromFile(line);
    return line;
}

void outputInConsole(string line, string num)
{
    cout << "Default line\n" << line << endl;
    cout << "Substring\n" << num << endl;
}

void outputInFile(string line, string num)           //TODO in delphi add error about empty line
{
    int index = 0;
    int i;
    string fileName = getFileName();
    ofstream file(fileName);
    file << "Default line\n" << line << endl;
    file << "Substring\n" << num << endl;
    cout << "Writing is successfull\n";
    file.close();
}

void outputInf(string line, string num)
{
    int choice = userChoice();
    if (choice == 1)
        outputInConsole(line, num);
    else
        outputInFile(line, num);
}


int main()
{
    string num, line;

    printInf();
    line = inputInf();
    num = getNumFromLine(line);
    outputInf(line, num);

    return 0;
}