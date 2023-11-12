#include <iostream>
#include <string>
#include <fstream>
#include <set>

using namespace std;

enum ErrorsCode
{
    SUCCESS,
    INCORRECT_DATA,
    EMPTY_LINE,
    NOT_TXT,
    FILE_NOT_EXIST,
    A_LOT_OF_DATA_FILE,
    OUT_OF_BORDER,
    INCORRECT_BORDERS
};

const int MIN_NUMB = 0,
          MAX_NUMB = 255;
const string ERRORS[] = { "Successfull",
                          "Data is not correct, or number is too large\n",
                          "Line is empty, please be careful\n",
                          "This is not a .txt file\n",
                          "This file is not exist\n",
                          "There is only one line in file should be\n",
                          "Out of border [0, 255]\n",
                          "Incorrect borders\n"};

void printInf()
{
    cout << "Program forms two sets, the first of which contains all simple"
        << "\nnumbers from this set, and the second contains others"
        << "\nBorders and numbers should be in the interval [0, 255]\n";
}

bool isNumbSimple(int numb)
{
    bool isSimple;
    isSimple = true;
    int rightBord;
    rightBord = trunc(sqrt(numb)) + 1;
    if (numb > 3)
        for (int i = 2; i < rightBord && isSimple; i++)
            if (numb % i == 0)
                isSimple = false;
    return isSimple;
}

static set<int> getSetOfSimple(set<int> defaultSet)
{
    set<int> simpleSet;
    for (int numb : defaultSet)
        if (isNumbSimple(numb))
            simpleSet.insert(numb);
    return simpleSet;
}

static set<int> getSetOfComposit(set<int> defaultSet, set<int> simpleSet)
{
    set<int> compositSet;
    for (int numb : defaultSet)
        if (!simpleSet.count(numb))
            compositSet.insert(numb);
    return compositSet;
}

void freeArr(int* arr)
{
    delete[] arr;
}

static set<int> createSetWithBorders(int* borders)
{
    set<int> numbSet;
    borders[1]++;
    int i;
    for (i = borders[0]; i < borders[1]; i++)
        numbSet.insert(i);
    freeArr(borders);
    return numbSet;
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
        if (err != SUCCESS)
            cout << ERRORS[err] << "Please, enter again\n";
    } while (err != SUCCESS);
    return choice;
}

int inpValidBorder(int& numb)
{
    int err;
    bool isCorrect;
    err = SUCCESS;
    isCorrect = true;
    cin >> numb;
    if (cin.fail())
    {
        cin.clear();
        while(cin.get() != '\n');
        err = INCORRECT_DATA;
        isCorrect = false;
    }
    if (isCorrect && cin.get() != '\n')
    {
        while(cin.get() != '\n');
        err = INCORRECT_DATA;
        isCorrect = false;
    }
    if (isCorrect && (numb > MAX_NUMB) || (numb < MIN_NUMB))
        err = OUT_OF_BORDER;
    return err;
}

int inpValidBorders(int* borders)
{
    int err;
    err = inpValidBorder(borders[0]);
    if (err == SUCCESS)
    {
        err = inpValidBorder(borders[1]);
        if (err == SUCCESS && borders[0] > borders[1])
            err = INCORRECT_BORDERS;
    }
    return err;
}

int* inputFromConsole()
{
    cout << "Enter the borders through the Enter\n";
    int err;
    int* borders = new int[2];
    do
    {
        err = inpValidBorders(borders);
        if (err != SUCCESS)
            cout << ERRORS[err] << "Please, enter again\n";
    } while (err != SUCCESS);
    return borders;
}

int readOneFromFile(int& numb, ifstream& file)
{
    int err;
    bool isCorrect;
    isCorrect = true;
    err = SUCCESS;
    file >> numb;
    if (file.fail())
    {
        file.clear();
        err = INCORRECT_DATA;
        isCorrect = false;
    }
    if (isCorrect && (numb > MAX_NUMB) || (numb < MIN_NUMB))
        err = OUT_OF_BORDER;
    return err;
}

int readFile(int* borders, string fileName)
{
    int err = SUCCESS;
    bool isCorrect = true;
    ifstream file(fileName);
    err = readOneFromFile(borders[0], file);
    if (err == SUCCESS)
    {
        err = readOneFromFile(borders[1], file);
        if (err == SUCCESS)
        {
            if (borders[0] > borders[1])
                err = INCORRECT_BORDERS;
            if (!file.eof())
                err = A_LOT_OF_DATA_FILE;
        }
    }
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

int* inputFromFile()
{
    string fileName;
    int err;
    int* borders = new int[2];
    do
    {
        fileName = getFileName();
        err = readFile(borders, fileName);
        if (err != SUCCESS)
            cout << ERRORS[err] << "Please, enter full path again\n";
    } while (err != SUCCESS);
    cout << "Reading is successfull\n";
    return borders;
}

int* inputInf()
{
    int* borders;
    int choice = userChoice();
    if (choice == 1)
        borders = inputFromConsole();
    else
        borders = inputFromFile();
    return borders;
}

void outputInConsole(set<int> defaultSet, set<int> setSimple, set<int> setComposit)
{
    cout << "Default set\n{ ";
    for (int i : defaultSet)
        cout << i << " ";
    cout << "}\nSet with simple numbers\n{ ";
    for (int i : setSimple)
        cout << i << " ";
    cout << "}\nSet with composite numbers\n{ ";
    for (int i : setComposit)
        cout << i << " ";
    cout << "}";
}

void outputInFile(set<int> defaultSet, set<int> setSimple, set<int> setComposit)
{
    string fileName = getFileName();
    ofstream file(fileName);
    
    file << "Default set" << endl << "{ ";
    for (int i : defaultSet)
        file << i << " ";
    file << "}" << endl << "Set with simple numbers" << endl << "{ ";
    for (int i : setSimple)
        file << i << " ";
    file << "}" << endl << "Set with composite numbers" << endl << "{ ";
    for (int i : setComposit)
        file << i << " ";
    file << "}";

    cout << "Writing is successfull\n";
    file.close();
}

void outputInf(set<int> defaultSet, set<int> setSimple, set<int> setComposit)
{
    int choice = userChoice();
    if (choice == 1)
        outputInConsole(defaultSet, setSimple, setComposit);
    else
        outputInFile(defaultSet, setSimple, setComposit);
}


int main()
{
    int* borders;
    set<int> defaultSet, setWithSimple, setWithComposit;

    printInf();
    borders = inputInf();
    defaultSet = createSetWithBorders(borders);
    setWithSimple = getSetOfSimple(defaultSet);
    setWithComposit = getSetOfComposit(defaultSet, setWithSimple);
    outputInf(defaultSet, setWithSimple, setWithComposit);

}
