#include <iostream>
#include <string>
#include <fstream>

using namespace std;

enum ErrorsCode
{
    SUCCESS,
    INCORRECT_DATA,
    EMPTY_LINE,
    NOT_TXT,
    FILE_NOT_EXIST,
    INCORRECT_DATA_FILE,
    A_LOT_OF_DATA_FILE,
    OUT_OF_BORDER_SIZE,
    OUT_OF_BORDER_NUMB,
};

const int MIN_NUMB = -2000000000,
          MAX_NUMB = 2000000000,
          MIN_SIZE = 2,
          MAX_SIZE = 100;
const string ERRORS[] = { "Successfull",
                          "Data is not correct, or number is too large\n",
                          "Line is empty, please be careful\n",
                          "This is not a .txt file\n",
                          "This file is not exist\n",
                          "Data in file is not correct\n",
                          "There are only elements of array should be in file\n",
                          "Out of border size [2, 100]\n",
                          "Out of border [-2000000000, 2000000000]\n" };

void printInf()
{
    cout << "The program implements sorting by natural merging";
}

int* mergeWithPointers(int* arr, int sizeArr, int* pointersArr, int sizePointer)
{
    int start1, stop1, start2, stop2, i, j, counter, pointerInd;
    int* mergedArr = new int[sizeArr];
    i = 0;
    counter = sizePointer - sizePointer % 4;
    pointerInd = 0;
    do
    {
        start1 = pointersArr[pointerInd++];
        stop1 = pointersArr[pointerInd++];
        start2 = pointersArr[pointerInd++];
        stop2 = pointersArr[pointerInd++];
        while (start1 < stop1 && start2 < stop2)
        {
            if (arr[start1] > arr[start2])
                mergedArr[i++] = arr[start2++];
            else
                mergedArr[i++] = arr[start1++];
        }
        while (start1 < stop1)
        {
            mergedArr[i++] = arr[start1++];
        }
        while (start2 < stop2)
        {
            mergedArr[i++] = arr[start2++];
        }
    } while (pointerInd < counter && pointersArr[pointerInd] > 0);
    if (i < sizeArr)
    {
        for (j = pointersArr[pointerInd++]; j < pointersArr[pointerInd]; j++)
        {
            mergedArr[i++] = arr[j];
        }
    }
    return mergedArr;
}

void freeMemory(int* arr)
{
    delete[] arr;
}

void fillWithZero(int* arr, int size) {
    for (int i = 0; i < size; i++)
        arr[i] = 0;
}

int* mergeSort(int* arr, int size) {
    int i, pointInd, sizePointers;
    sizePointers = 2 * size;
    int* pointersArr = new int[sizePointers];
    do {
        fillWithZero(pointersArr, sizePointers);
        pointInd = 0;
        pointersArr[pointInd++] = 0;
        for (i = 1; i < size; i++) {
            if (arr[i] < arr[i - 1]) {
                pointersArr[pointInd++] = i;
                pointersArr[pointInd++] = i;
            }
        }
        pointersArr[pointInd] = i;

        arr = mergeWithPointers(arr, size, pointersArr, sizePointers);
    } while (pointersArr[1] != size);
    freeMemory(pointersArr);
    return arr;
}

ErrorsCode inpChoice(int& choice)
{
    ErrorsCode err;
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
    ErrorsCode err;
    do
    {
        err = inpChoice(choice);
        if (err != SUCCESS)
            cout << ERRORS[err] << "Please, enter again\n";
    } while (err != SUCCESS);
    return choice;
}

ErrorsCode inpValidSize(int& size)
{
    ErrorsCode err;
    err = SUCCESS;
    bool isCorrect = true;
    cin >> size;
    if (cin.fail())
    {
        cin.clear();
        while (cin.get() != '\n');
        err = INCORRECT_DATA;
    }
    if (err == SUCCESS && cin.get() != '\n')
    {
        while (cin.get() != '\n');
        err = INCORRECT_DATA;
    }
    if (err == SUCCESS && ((size > MAX_SIZE) || (size < MIN_SIZE)))
        err = OUT_OF_BORDER_SIZE;
    return err;
}

ErrorsCode inpValidArr(int* arr, int size)
{
    ErrorsCode err;
    int i;
    i = 0;
    err = SUCCESS;
    while (i < size && err == SUCCESS)
    {
        cin >> arr[i];
        if (cin.fail())
        {
            cin.clear();
            while (cin.get() != '\n');
            err = INCORRECT_DATA;
        }
        if (err == SUCCESS && cin.get() != '\n')
        {
            while (cin.get() != '\n');
            err = INCORRECT_DATA;
        }
        if (err == SUCCESS && ((arr[i] > MAX_NUMB) || (arr[i] < MIN_NUMB)))
            err = OUT_OF_BORDER_NUMB;
        i++;
    }
    return err;
}

int* inputFromConsole(int& size)
{
    cout << "Enter the size[2, 100] and then the \n" 
         << "elements[-2000000000, 2000000000] through the Enter\n";
    ErrorsCode err;
    do
    {
        err = inpValidSize(size);
        if (err != SUCCESS)
            cout << ERRORS[err] << "Please, enter again size\n";
    } while (err != SUCCESS);
    int* defaultArr = new int[size];
    cout << "Enter the " << size << " elements\n";
    do
    {
        err = inpValidArr(defaultArr, size);
        if (err != SUCCESS)
            cout << ERRORS[err] << "Enter the " << size << " elements\n";
    } while (err != SUCCESS);
    return defaultArr;
}

ErrorsCode readSizeFromFile(int& size, ifstream& file)
{
    ErrorsCode err;
    err = SUCCESS;
    file >> size;
    if (file.fail())
    {
        file.clear();
        err = INCORRECT_DATA_FILE;
    }
    if (err == SUCCESS && ((size > MAX_SIZE) || (size < MIN_SIZE)))
        err = OUT_OF_BORDER_NUMB;
    return err;
}

ErrorsCode readArrFromFile(int* arr, int size, ifstream& file)
{
    ErrorsCode err;
    err = SUCCESS;
    int i;
    i = 0;
    while (i < size && err == SUCCESS)
    {
        file >> arr[i];
        if (file.fail())
        {
            file.clear();
            err = INCORRECT_DATA_FILE;
        }
        if (err == SUCCESS && ((arr[i] > MAX_NUMB) || (arr[i] < MIN_NUMB)))
            err = OUT_OF_BORDER_NUMB;
        i++;
        if (i == size && !file.eof())
            err = A_LOT_OF_DATA_FILE;
    }
    return err;
}

ErrorsCode isFileExist(string nameOfFile)
{
    ErrorsCode err;
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

ErrorsCode thisIsTxtFile(string& fileName)
{
    ErrorsCode err = SUCCESS;
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

int* inputFromFile(int& size)
{
    string fileName;
    int* defaultArr = new int;
    ErrorsCode err;
    do
    {
        fileName = getFileName();
        ifstream file = ifstream(fileName);
        err = readSizeFromFile(size, file);
        if (err == SUCCESS)
        {
            defaultArr = new int[size];
            err = readArrFromFile(defaultArr, size, file);
        }
        if (err != SUCCESS)
            cout << ERRORS[err];
        file.close();
    } while (err != SUCCESS);
    cout << "Reading is successfull\n";
    return defaultArr;
}

int* inputInf(int& size)
{
    int* defaultArr;
    int choice = userChoice();
    if (choice == 1)
        defaultArr = inputFromConsole(size);
    else
        defaultArr = inputFromFile(size);
    return defaultArr;
}

void outputInConsole(int* defaultArr, int* sortedArr, int size)
{
    int i;
    cout << "Default array\n";
    for (i = 0; i < size; i++)
        cout << defaultArr[i] << " ";
    cout << "\nSorted array\n";
    for (i = 0; i < size; i++)
        cout << sortedArr[i] << " ";
}

void outputInFile(int* defaultArr, int* sortedArr, int size)
{
    string fileName = getFileName();
    ofstream file(fileName);

    int i;
    file << "Default array\n";
    for (i = 0; i < size; i++)
        file << defaultArr[i] << " ";
    file << "\nSorted array\n";
    for (i = 0; i < size; i++)
        file << sortedArr[i] << " ";

    cout << "Writing is successfull\n";
    file.close();
}

void outputInf(int* defaultArr, int* sortedArr, int size)
{
    int choice = userChoice();
    if (choice == 1)
        outputInConsole(defaultArr, sortedArr, size);
    else
        outputInFile(defaultArr, sortedArr, size);
    freeMemory(defaultArr);
    freeMemory(sortedArr);
}

int* copyArr(int* arr, int size) {
    int* copyedArr = new int[size];
    int i;
    for (i = 0; i < size; i++) {
        copyedArr[i] = arr[i];
    }
    return copyedArr;
}


int main()
{
    int size;
    int* defaultArr;
    int* sortedArr;

    inputInf;
    defaultArr = inputInf(size);
    sortedArr = copyArr(defaultArr, size);
    sortedArr = mergeSort(sortedArr, size);
    outputInf(defaultArr, sortedArr, size);

    return 0;
}
