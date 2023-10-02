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

string** getLineOfFile(int numbOfLine, int numbOfElem, ifstream file) {
    string** arrOfInf = new string*[numbOfLine];
    string line;
    for (int i = 0; i < numbOfLine; i++)
    {
        string* arrOfInf = new string[numbOfElem];
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
            while (getline(file, line, ' '))
            {
                cout << line << "\n";
            }
        }
        else
        {
            cout << 0;
        }
    }
}