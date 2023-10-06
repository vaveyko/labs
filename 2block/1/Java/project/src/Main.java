import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        final int MAXCOUNT = 1000;
        int countElem, indexOfNeededElem;
        int maxValue, minValue;
        float absDistanse, minAbsDistanse, average, sum;
        boolean isIncorrect;
        maxValue = 2000000000;
        minValue = -2000000000;
        sum = 0;
        countElem = 0;
        indexOfNeededElem = 0;
        average = 0;
        absDistanse = 0;

        System.out.print("Программа принимает числовую последовательность и"
                         + "выводит элемент наиболее \nблизкий по своему значению "
                         + "к среднему арифметическому последовательности\n");
        do {
            isIncorrect = false;
            System.out.print("Введите количество элементов\n");
            try {
                countElem = Integer.parseInt(input.nextLine());
            } catch (NumberFormatException e) {
                isIncorrect = true;
                System.err.print("Неверные входные данные\n");
            }
            if (!isIncorrect && (countElem < 1 || countElem >MAXCOUNT)) {
                isIncorrect = true;
                System.err.print("Количество элементов должно быть больше 0 и меньше " + MAXCOUNT + "\n");
            }
        } while (isIncorrect);
        maxValue = (maxValue / countElem) - 1;
        minValue = -maxValue;

        //creating array for information
        int[] arrOfInf = new int[countElem];

        //filling the array
        for (int i = 0; i < countElem; i++) {
            System.out.print("Введите " + (i + 1) + " элемент последовательности\n");
            do {
                isIncorrect = false;
                try {
                    arrOfInf[i] = Integer.parseInt(input.nextLine());
                } catch (NumberFormatException e) {
                    isIncorrect = true;
                    System.err.print("Неверные входные данные\n");
                }
                if (!isIncorrect && (arrOfInf[i] > maxValue || arrOfInf[i] < minValue)) {
                    isIncorrect = true;
                    System.err.print("Из-за количества элементов они должны находиться"
                                     + " в промежутке от " + minValue + " до " + maxValue + '\n');
                }
            } while (isIncorrect);
        }
        input.close();

        //algorithm
        for (int i = 0; i < countElem; i++) {
            sum += arrOfInf[i];
        }
        average = sum / countElem;
        minAbsDistanse = Math.abs(average - arrOfInf[0]);
        for (int i = 0; i < countElem; i++) {
            absDistanse = Math.abs(average - arrOfInf[i]);
            if (absDistanse < minAbsDistanse) {
                minAbsDistanse = absDistanse;
                indexOfNeededElem = i;
            }
        }

        System.out.print("Среднее арифметическое -- " + average + "\nБлижайший элемент -- "
                         + arrOfInf[indexOfNeededElem]);
    }
}