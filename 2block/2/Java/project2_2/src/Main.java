import java.math.BigInteger;
import java.util.Scanner;

public class Main {
    static void printInf(int min,long max){
        System.out.println("Программа вычисляет все числа Марсена меньше n, где n ["+ min +", "+ max +"]");
        System.out.println("Число Мерсена -- простое число, которое можно представить в виде 2^р – 1, где р – тоже простое число.");
    }

    static long inputNum(int min, long max){
        long number;
        boolean isIncorrect;
        number = 0L;
        isIncorrect = false;
        Scanner input = new Scanner(System.in);
        System.out.println("Введите n");
        do {
            isIncorrect = false;
            try {
                number = Long.parseLong(input.nextLine());
            } catch (NumberFormatException error) {
                System.err.println("Ошибка, неверные данные");
                isIncorrect = true;
            }
            if (!isIncorrect && number < min || number > max){
                isIncorrect = true;
                System.err.println("Ошибка, число должно быть больше "+ min +" и меньше "+ max);
            }
        } while (isIncorrect);
        return number;
    }

    static boolean isNumSympl(long numb) {
        int sqrtNum;
        sqrtNum = (int) Math.sqrt(numb) + 1;
        if (numb > 3) {
            for (int i = 2; i < sqrtNum; i++) {
                if (numb % i == 0) {
                    return false;
                }
            }
        }
        return true;
    }

    static void printMersen(long highBord) {
        long mersenNum;
        boolean isBordIncros;
        int i;
        i = 2;
        mersenNum = 1;
        isBordIncros = mersenNum < highBord;
        while (isBordIncros) {
            mersenNum = mersenNum * 2 + 1;
            isBordIncros = mersenNum < highBord;
            if (isBordIncros && isNumSympl(i) && isNumSympl(mersenNum)) {
                System.out.println("Mersen(" + i + ") -- " + mersenNum);
            }
            i++;
        }
    }

    public static void main(String[] args) {
        final int MIN_VALUE = 1;
        final long MAX_VALUE = 3000000000L;
        printInf(MIN_VALUE, MAX_VALUE);
        printMersen(inputNum(MIN_VALUE, MAX_VALUE));
    }
}