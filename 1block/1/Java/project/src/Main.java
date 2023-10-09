import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        final int MIN = 0, MAX = 200;
        int firstSide = 0;
        int secondSide = 0;
        int thirdSide = 0;
        boolean isIncorrect = false;
        boolean isTriangleNotExist = false;
        System.out.println("Программа определяет: является ли треугольник с данными сторонами равнобедренным.");
        System.out.println("Длинна стороны - целое, положительное число.");
        do {
            do {
                isIncorrect = false;
                System.out.println("Введите 1 сторону треугольника");
                try {
                    firstSide = Integer.parseInt(in.nextLine());
                } catch (Exception e) {
                    System.err.println("Некорректный формат ввода!");
                    isIncorrect = true;
                }
                if (!isIncorrect && (firstSide < MIN+1 || firstSide > MAX-1)) {
                    isIncorrect = true;
                    System.err.println("Сторона треугольника должна быть больше " + MIN + " и меньше " + MAX +".");
                }
            } while (isIncorrect);
            do {
                isIncorrect = false;
                System.out.println("Введите 2 сторону треугольника");
                try {
                    secondSide = Integer.parseInt(in.nextLine());
                } catch (Exception e) {
                    System.err.println("Некорректный формат ввода!");
                    isIncorrect = true;
                }
                if (!isIncorrect && (secondSide < MIN+1 || secondSide > MAX-1)) {
                    isIncorrect = true;
                    System.err.println("Сторона треугольника должна быть больше " + MIN + " и меньше " + MAX +".");
                }
            } while (isIncorrect);
            do {
                isIncorrect = false;
                System.out.println("Введите 3 сторону треугольника");
                try {
                    thirdSide = Integer.parseInt(in.nextLine());
                } catch (Exception e) {
                    System.err.println("Некорректный формат ввода!");
                    isIncorrect = true;
                }
                if (!isIncorrect && (thirdSide < MIN+1 || thirdSide > MAX-1)) {
                    isIncorrect = true;
                    System.err.println("Сторона треугольника должна быть больше " + MIN + " и меньше " + MAX +".");
                }
            } while (isIncorrect);
            isTriangleNotExist = !((firstSide + secondSide > thirdSide) && (secondSide + thirdSide > firstSide) && (thirdSide + secondSide > firstSide));
            if (isTriangleNotExist) {
                System.err.println("Треугольника с такими сторонами не существует.");
            }
        } while (isTriangleNotExist);
        in.close();
        if ((firstSide == secondSide) || (firstSide == thirdSide) || (secondSide == thirdSide)) {
            System.out.println("Треугольник равнобедренный");
        } else {
            System.out.println("Треугольник не равнобедренный");
        }
    }
}