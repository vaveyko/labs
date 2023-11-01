import java.util.Scanner;

public class Main {

    public final static int MAX_ARRAY_SIZE = 100;
    public final static int MIN_ARRAY_SIZE = 4;

    public final static int MIN_ARRAY_VALUE = 1;
    public final static int MAX_ARRAY_VALUE = 100;

    public static void printTask(){
        System.out.println("Дан массив А, состоящий из n-натуральных чисел. Определить максимальное число идущих подряд элементов, равных 1");
    }

    public static int inputNum(int leftBorder, int rightBorder){
        int num;
        boolean isNumNotCorrect;

        Scanner inp = new Scanner(System.in);
        do {
            num = -1;
            isNumNotCorrect = false;


            try {
                num = Integer.parseInt(inp.nextLine());
            }catch (NumberFormatException e){
                System.err.println("Это не было число");
                isNumNotCorrect = true;
            }

            if (!isNumNotCorrect && (num < leftBorder || num > rightBorder)){
                isNumNotCorrect = true;
                System.err.printf("Введите числов в диапазоне от %d до %d", leftBorder, rightBorder);
            }

        }while (isNumNotCorrect);
        inp.close();

        return num;
    }

    public static int inputSizeFromConsole(){
        int num;

        System.out.println("Введите размер массива");
        num = inputNum(MIN_ARRAY_SIZE, MAX_ARRAY_SIZE);

        return num;
    }

    public static int[] inputArrayFromConsole(){
        int size = inputSizeFromConsole();

        int[] arr = new int[size];

        for (int i = 0; i < size; i++) {
            System.out.printf("Введите [%d]-й элемент массива", i + 1);
            arr[i] = inputNum(MIN_ARRAY_VALUE, MAX_ARRAY_VALUE);
        }

        return arr;
    }

    public static int[] inputArray(){
        int[] arr;
        arr = inputArrayFromConsole();
        return arr;
    }

    public static void main(String[] args) {
        printTask();
        int[] arr = inputArray();
    }
}