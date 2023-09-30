#include <iostream>

int main() {
    setlocale(0, "");
    const int MIN = 0;
    const int MAX = 200;
    int firstSide = 0;
    int secondSide = 0;
    int thirdSide = 0;
    bool isIncorrect = false;
    bool isTriangleNotExist = false;
    std::cout << "Программа определяет: является ли треугольник с данными сторонами равнобедренным.\n";
    std::cout << "Длинна стороны - целое, положительное число.\n";
    do {
        do {
            std::cout << "Введите первую сторону треугольника.\n";
            std::cin >> firstSide;
            if (std::cin.get() != '\n') {
                std::cout << "Некорректные данные.\n";
                std::cin.clear();
                while (std::cin.get() != '\n');
                isIncorrect = true;
            }
            else {
                if (firstSide > MIN && firstSide < MAX) {
                    isIncorrect = false;
                }
                else {
                    std::cout << "Сторона треугольника должна быть больше " << MIN << " и меньше " << MAX << ".\n";
                    isIncorrect = true;
                }
            }
            
        } while (isIncorrect);
        do {
            std::cout << "Введите вторую сторону треугольника.\n";
            std::cin >> secondSide;
            if (std::cin.get() != '\n') {
                std::cout << "Некорректные данные.\n";
                std::cin.clear();
                while (std::cin.get() != '\n');
                isIncorrect = true;
            }
            else {
                if (secondSide > MIN && secondSide < MAX) {
                    isIncorrect = false;
                }
                else {
                    std::cout << "Сторона треугольника должна быть больше " << MIN << " и меньше " << MAX << ".\n";
                    isIncorrect = true;
                }
            }
            
        } while (isIncorrect);
        do {
            std::cout << "Введите третью сторону треугольника.\n";
            std::cin >> thirdSide;
            if (std::cin.get() != '\n') {
                std::cout << "Некорректные данные.\n";
                std::cin.clear();
                while (std::cin.get() != '\n');
                isIncorrect = true;
            }
            else {
                if (thirdSide > MIN && thirdSide < MAX) {
                    isIncorrect = false;
                }
                else {
                    std::cout << "Сторона треугольника должна быть больше " << MIN << " и меньше " << MAX << ".\n";
                    isIncorrect = true;
                }
            }
            
        } while (isIncorrect);
        
        if ((firstSide + secondSide > thirdSide) && (secondSide + thirdSide > firstSide) && (thirdSide + secondSide > firstSide)) {
            isTriangleNotExist = false;
        }
        else {
            std::cout << "Треугольника с такими сторонами не существует.\n";
            isTriangleNotExist = true;
        }
    } while (isTriangleNotExist);
    if ((firstSide == secondSide) || (secondSide == thirdSide) || (thirdSide == firstSide)) {
        std::cout << "Треугольник равнобедренный.";
    }
    else {
        std::cout << "Треугольник произвольный";
    }
    return 0;
}