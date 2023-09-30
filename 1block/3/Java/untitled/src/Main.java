import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        final int MINVALUE = 1;
        final int MAXVALUE = 1000000;
        boolean isIncorrect = false;
        int num = 0;
        int lenOfNum = 0;
        System.out.println("Программа считает количество цифр в натуральном числе n");
        do {
            isIncorrect = false;
            System.out.println("Введите натуральное число");
            try {
                num = Integer.parseInt(input.nextLine());
            } catch (NumberFormatException e) {
                System.err.println("Неправильные входные данные");
                isIncorrect = true;
            }
            if (!isIncorrect && (num < MINVALUE || num > MAXVALUE)) {
                isIncorrect = true;
                System.err.println("Число должно быть в промежутке от " + MINVALUE + " до " + MAXVALUE);
            }
        } while (isIncorrect);
        input.close();
        while (num > 0) {
            num /= 10;
            lenOfNum++;
        }
        System.out.println("Длинна этого числа -- " + lenOfNum);
    }
}