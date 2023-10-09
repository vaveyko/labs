#include <iostream>
#include <fstream>
#include <string>

using std::string;
using std::cout;
using std::cin;
using std::ifstream;
using std::ofstream;


// FILES

bool isFileCanBeOpened(string nameOfFile)
{
    ifstream file(nameOfFile);
    if (file.is_open())
    {
        file.close();
        return true;
    }
    else
    {
        file.close();
        return false;
    }
}

bool thisIsTxtFile(string fileName)
{
    string lastFourChar = fileName.substr(fileName.length() - 4);
    return ((lastFourChar == ".txt") ? true : false);
}

string** getLineOfFile(int numbOfLine, int numbOfElem, ifstream& file)
{
    string line;

    //creating array for information
    string** arrOfInf = new string*[numbOfLine];
    for (int i = 0; i < numbOfLine; i++)
    {
        arrOfInf[i] = new string[numbOfElem];
    }

    //reading from a file
    for (int i = 0; i < numbOfElem; i++)
    {
        for (int j = 0; j < numbOfLine; j++)
        {
            (file >> line) ? arrOfInf[i][j] = line : arrOfInf[i][j] = "ERR";
            cout << arrOfInf[i][j];
        }
        cout << '\n';
    }
    return arrOfInf;
}


// ARRAYS

void printArr(int* arrNumb, int numElem)
{
    for (int i = 0; i < numElem; i++)
        cout << arrNumb[i] << "  ";
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
        }
    return arrSimpNumb;
}





int main()
{
    string nameOfFile;
    cout << "Hello World!\n";
    while (true)
    {
        cin >> nameOfFile;
        if (thisIsTxtFile(nameOfFile) and isFileCanBeOpened(nameOfFile))
        {
            cout << 1 <<"\n";
            ifstream file(nameOfFile);
            string line;
            getLineOfFile(3, 3, file);
        }
        else
        {
            cout << 0;
        }
    }
}