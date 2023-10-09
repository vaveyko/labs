import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        final int MINVALUE = 1;
        final int MAXVALUE = 100;
        int lenOfArr = 0;
        int answer = 0;
        boolean isIncorrect;
        System.out.println("Программа вычисляет сумму элементов стоящих на нечетных местах в данном массиве");
        do {
            isIncorrect = false;
            System.out.println("Введите количество элементов в массиве");
            try {
                lenOfArr = Integer.parseInt(in.nextLine());
            } catch (NumberFormatException e) {
                isIncorrect = true;
                System.err.println("Неверные входные данные");
            }
            if (!isIncorrect && (lenOfArr < MINVALUE || lenOfArr > MAXVALUE)) {
                isIncorrect = true;
                System.err.println("Количество элементов в массиве должно быть больше " + MINVALUE + " и меньше " + MAXVALUE);
            }
        } while(isIncorrect);
        // initialization and filling the array
        int[] arr = new int[lenOfArr];
        for (int i = 0; i < lenOfArr; i++) {
            do {
                System.out.println("Введите " + (i+1) + " элемент");
                try {
                    arr[i] = Integer.parseInt(in.nextLine());
                    isIncorrect = false;
                } catch (NumberFormatException e) {
                    isIncorrect = true;
                    System.err.println("Неверные входные данные");
                }
            } while(isIncorrect);
        }
        in.close();
        System.out.print("Элементы на нечетых местах");
        for (int i = 0; i < lenOfArr; i+=2) {
            answer += arr[i];
            System.out.print(", " + arr[i]);
        }
        System.out.print("\nСумма равна -- " + answer);
    }
}