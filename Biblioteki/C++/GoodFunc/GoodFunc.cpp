#include <iostream>
#include <fstream>
#include <string>

using std::string;
using std::cout;
using std::cin;
using std::ifstream;
using std::ofstream;

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