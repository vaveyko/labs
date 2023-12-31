import java.util.Scanner;

public class Main {
    static void printInf(final int MIN,final long MAX){
        System.out.println("Программа вычисляет все числа Марсена меньше n, где n ["+ MIN +", "+ MAX +"]");
        System.out.println("Число Мерсена -- простое число, которое можно представить в виде 2^р – 1, где р – тоже простое число.");
    }

    static long inputNum(final int MIN,final long MAX){
        long number;
        boolean isIncorrect;
        number = 0L;
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
            if (!isIncorrect && number < MIN || number > MAX){
                isIncorrect = true;
                System.err.println("Ошибка, число должно быть больше "+ MIN +" и меньше "+ MAX);
            }
        } while (isIncorrect);
        input.close();
        return number;
    }

    static boolean isNumSimpl(long numb) {
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
            if (isBordIncros && isNumSimpl(i) && isNumSimpl(mersenNum)) {
                System.out.println("Mersen(" + i + ") -- " + mersenNum);
            }
            i++;
        }
    }

    public static void main(String[] args) {
        final int MIN_VALUE = 1;
        final long MAX_VALUE = 3000000000L;
        long highBorder;
        printInf(MIN_VALUE, MAX_VALUE);
        highBorder = inputNum(MIN_VALUE, MAX_VALUE);
        printMersen(highBorder);
    }
}