import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        final int MINVALUE = 2;
        final int MAXVALUE = 15;
        int countNum = 0;
        long multipliedNum = 2;
        boolean isIncorrect = false;
        System.out.println("Эта программа считает произведение 2*4*6*...*2n для заданного n.");
        System.out.println("Число n должно быть быть больше " + MINVALUE + " и меньше " + MAXVALUE + ".");
        do {
            isIncorrect = false;
            System.out.println("Введите n");
            try {
                countNum = Integer.parseInt(in.nextLine());
            } catch (NumberFormatException e) {
                System.err.println("Некорректный формат ввода!");
                isIncorrect = true;
            }
            if (!isIncorrect && ((countNum < MINVALUE || countNum > MAXVALUE))) {
                System.err.println("Число n должно находиться в промежутке (" + MINVALUE + ", " + MAXVALUE + ")");
                isIncorrect = true;
            }
        } while (isIncorrect);
        in.close();
        System.out.print(multipliedNum);
        for (int i = MINVALUE; i < countNum + 1; i++) {
            System.out.print(" * " + 2 * i);
            multipliedNum *= 2 * i;
        }
        System.out.println(" = " + multipliedNum);
    }
}