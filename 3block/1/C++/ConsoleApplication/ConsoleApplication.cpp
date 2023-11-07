#include <iostream>
#include <fstream>
#include <string>

using namespace std;

enum ErrorsCode
{
    SUCCESS,
    INCORRECT_DATA,
    EMPTY_LINE,
    NOT_TXT,
    FILE_NOT_EXIST,
    A_LOT_OF_DATA_FILE,
};

const string ERRORS[] = { "Successfull",
                          "Data is not correct, or number is too large\n",
                          "Line is empty, please be careful\n",
                          "This is not a .txt file\n",
                          "This file is not exist\n",
                          "There is only one line in file should be\n" };

void printInf()
{
    cout << "Program selects a substring consisting of digits corresponding "
         << "to an integer \n(starts with a '+' or '-' "
         << "and there are no letters and dots inside the substring\n";
}

string getNumFromLine(string line)
{
    string numb;
    int i, size;
    bool isNumbNotExist;
    isNumbNotExist = true;
    size = line.length();
    i = 0;
    numb = "not exist";

    while (i < size)
    {
        if (isNumbNotExist && (line[i] == '+' || line[i] == '-'))
        {
            numb = line[i];
            i++;
            while (i < size && isdigit(line[i]))
                numb += line[i++];
            isNumbNotExist = numb.length() == 1;
            if (isNumbNotExist)
                numb = "not exist";
        }
        else
            ++i;
    }

    return numb;
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
        err = choiceStr.length() > 0 ? INCORRECT_DATA : EMPTY_LINE;
    return err;
}

int userChoice()
{
    int choice;
    cout << "Choose a way of input/output of data\n"
        << "1 -- Console\n"
        << "2 -- File\n";
    int err;
    do
    {
        err = inpChoice(choice);
        if (err > 0)
            cout << ERRORS[err] << "Please, enter again\n";
    } while (err > 0);
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
    int err;
    do
    {
        err = inpValidLine(line);
        if (err > 0)
            cout << ERRORS[err] << "Please, enter again\n";
    } while (err > 0);
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
    int err;
    ifstream file(nameOfFile);
    err = file.is_open() ? SUCCESS : FILE_NOT_EXIST;
    file.close();
    return err;
}

string getLastFourChar(string line)
{
    string lastFourChar;
    int start, i, size;
    size = line.length();
    start = size - 4;
    for (i = start; i < size; i++)
        lastFourChar += line[i];
    return lastFourChar;
}

int thisIsTxtFile(string& fileName)
{
    int err = SUCCESS;
    string lastFourChar;
    if (fileName.length() > 4)
    {
        lastFourChar = getLastFourChar(fileName);
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
    int errExist, errTxt;
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
    string fileName;
    int err;
    do
    {
        fileName = getFileName();
        err = readFile(line, fileName);
        if (err > 0)
            cout << ERRORS[err] << "Please, enter full path again\n";
    } while (err > 0);
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

void outputInFile(string line, string num)
{
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