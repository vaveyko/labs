import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;

public class Main {
    static void printInf() {
        System.out.println("Program sort even rows of square matrix from larger to smaller");
    }

    static int inputNum(Scanner input, final int MIN, final int MAX) {
        int number = 0;
        boolean isIncorrect;
        do {
            isIncorrect = false;
            try {
                number = Integer.parseInt(input.next());
            } catch (NumberFormatException e) {
                isIncorrect = true;
                System.err.println("Data is not correct, or number is too large");
            }
            if (!isIncorrect && (number < MIN || number > MAX)) {
                isIncorrect = true;
                System.err.println("Error, number should be from " + MIN + " to " + MAX);
            }
        } while (isIncorrect);
        return number;
    }

    static int[][] enterArr(Scanner input, int row, int col, final int MIN, final int MAX) {
        int[][] arr = new int[row][col];
        int i, j;
        for (i = 0; i < row; i++) {
            for (j = 0; j < col; j++) {
                arr[i][j] = inputNum(input, MIN, MAX);
            }
        }
        return arr;
    }

    static void printArr(int[][] arr) {
        int i, j;
        for (i = 0; i < arr.length; i++) {
            for (j = 0; j < arr.length; j++) {
                System.out.print(arr[i][j] + " ");
            }
            System.out.println();
        }
    }

    static void sortArr(int[] arr) {
        boolean isNotSorted;
        int i, buffer;
        isNotSorted = true;
        while (isNotSorted) {
            isNotSorted = false;
            for (i = 1; i < arr.length; i++) {
                if (arr[i - 1] < arr[i]) {
                    isNotSorted = true;
                    buffer = arr[i];
                    arr[i] = arr[i - 1];
                    arr[i - 1] = buffer;
                }
            }
        }
    }

    static void sortEvenRow(int[][] arr)
    {
        int i;
        for (i = 1; i < arr.length; i += 2)
        {
            sortArr(arr[i]);
        }
    }

    static int[][] copyArr(int[][] mainArr)
    {
        int i, j;
        int size = mainArr.length;
        int[][] copiedArr = new int[size][size];
        for (i = 0; i < size; i++)
        {
            for (j = 0; j < size; j++)
            {
                copiedArr[i][j] = mainArr[i][j];
            }
        }
        return copiedArr;
    }

    static boolean thisIsTxtFile(String fileName) {
        if (fileName.endsWith(".txt")) {
            return true;
        } else {
            System.err.println("This is not a .txt file");
            return false;
        }
    }

    static boolean isFileExist(String fileName) {
        File file = new File(fileName);
        if (file.exists()) {
            return true;
        } else {
            System.err.println("This file is not exist");
            return false;
        }
    }

    static int readSize(Scanner file, final int MIN, final int MAX) {
        int size = 0;
        boolean isCorrect = true;
        try {
            size = Integer.parseInt(file.next());
        } catch (NumberFormatException e) {
            System.err.println("Data is not correct, or number is too large");
            isCorrect = false;
        }
        if (isCorrect && (size < MIN || size > MAX)) {
            System.err.println("Error, number should be from " + MIN + " to " + MAX);
            size = 0;
        }
        return size;
    }

    static boolean isEnyException(boolean isCorrect, boolean isElemIncorrect, final int MIN, final int MAX) {
        boolean enyException = !isCorrect;
        if (isElemIncorrect) {
            System.err.println("One of the element is incorrect or out of range [ " + MIN + ", " + MAX + " ]");
            enyException = true;
        } else if (isCorrect) {
            System.out.println("Reading is successfull");
        }
        return enyException;
    }

    static int[][] readFile(String fileName, final int MIN_SIZE, final int MAX_SIZE, final int MIN_ELEM, final int MAX_ELEM) throws IOException{
        int size;
        boolean isCorrect;
        Path path = Paths.get(fileName); // <----- fileName
        Scanner file = new Scanner(path);
        size = readSize(file, MIN_SIZE, MAX_SIZE);
        isCorrect = size > 1;

        int i, j;
        boolean isElemIncorrect = false;
        int[][] arr = new int[size][size];
        for ( i = 0; i < size; i++) {
            for ( j = 0; j < size; j++) {
                try {
                    arr[i][j] = Integer.parseInt(file.next());
                } catch (NumberFormatException e) {
                    isElemIncorrect = true;
                }
                if (!isElemIncorrect && (arr[i][j] > MAX_ELEM || arr[i][j] < MIN_ELEM)) {
                    isElemIncorrect = true;
                }
            }
        }
        if (isEnyException(isCorrect, isElemIncorrect, MIN_ELEM, MAX_ELEM)) {
            return new int[0][0];
        } else {
            return arr;
        }
    }

    static boolean chooseConsole(Scanner input) {
        int button;
        System.out.println("Choose a way of input/output of data\n"
                + "1 -- Console\n"
                + "2 -- File");
        button = inputNum(input,1, 2);
        return button == 1;
    }

    static int[][]inputFromConsole(Scanner input) {
        final int MAX_SIZE = 100;
        final int MIN_SIZE = 2;
        final int MIN_ELEM = -2000000000;
        final int MAX_ELEM = 2000000000;
        boolean isIncorrect;
        int size;
        int[][] arr;
        System.out.println("Enter size of array, please");
        size = inputNum(input, MIN_SIZE, MAX_SIZE);
        System.out.println("Now enter the elements");
        arr = enterArr(input, size, size, MIN_ELEM, MAX_ELEM);
        return arr;
    }

    static int[][] inputFromFile(String fileName) {
        final int MAX_SIZE = 100;
        final int MIN_SIZE = 2;
        final int MIN_ELEM = -2000000000;
        final int MAX_ELEM = 2000000000;
        boolean isIncorrect;
        int size;
        int[][] arr = null;
        try {
            arr = readFile(fileName, MIN_SIZE, MAX_SIZE, MIN_ELEM, MAX_ELEM);
        } catch (IOException e) {
            System.err.println("IOException");
        }
        return arr;
    }

    static void writeFile(int[][] defoltArr, int[][] sortedArr, String fileName) throws IOException {
        int i, j;
        PrintWriter file = new PrintWriter(fileName);
        file.println("Defolt array");
        for (i = 0; i < defoltArr.length; i++){
            for (j = 0; j < defoltArr[i].length; j++) {
                file.print(defoltArr[i][j] + " ");
            }
            file.println();
        }
        file.println("Sorted array");
        for (i = 0; i < sortedArr.length; i++){
            for (j = 0; j < sortedArr[i].length; j++) {
                file.print(sortedArr[i][j] + " ");
            }
            file.println();
        }
        file.close();
        System.out.println("Wruting is successfull");
    }

    static void outputInf(int[][] defoltArr, int[][] sortedArr, boolean isConsole, String fileName) {
        if (isConsole) {
            System.out.println("Defolt array");
            printArr(defoltArr);
            System.out.println("Sorted array");
            printArr(sortedArr);
        } else {
            if (defoltArr.length > 1) {
                try {
                    writeFile(defoltArr, sortedArr, fileName);
                } catch(IOException e) {
                    System.err.println("Write error");
                }
            }
        }
    }

    static String getFileName(Scanner input) {
        boolean isIncorrect;
        String fileName;
        fileName = input.nextLine();
        do {
            System.out.println("Enter full path to file");
            fileName = input.nextLine();
            isIncorrect = !thisIsTxtFile(fileName) || !isFileExist(fileName);
        } while (isIncorrect);
        return fileName;
    }

    public static void main(String[] args) throws IOException {
        Scanner input = new Scanner(System.in);
        int[][] arrOfNum;
        int[][] sortedArr;
        boolean isConsoleOutIn;
        String fileName = null;

        printInf();
        isConsoleOutIn = chooseConsole(input);
        if (isConsoleOutIn) {
            arrOfNum = inputFromConsole(input);
            input.close();
            sortedArr = copyArr(arrOfNum);
            sortEvenRow(sortedArr);
            outputInf(arrOfNum, sortedArr, isConsoleOutIn, fileName);
        } else {
            fileName = getFileName(input);
            input.close();
            arrOfNum = inputFromFile(fileName);
            sortedArr = copyArr(arrOfNum);
            sortEvenRow(sortedArr);
            outputInf(arrOfNum, sortedArr, isConsoleOutIn, fileName);
        }
    }
}