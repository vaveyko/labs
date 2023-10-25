import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;

public class Main {

    static final int MAX_SIZE = 100;
    static final int MIN_SIZE = 2;
    static final int MIN_ELEM = -2000000000;
    static final int MAX_ELEM = 2000000000;
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
                System.out.println("Please, enter again");
            }
            if (!isIncorrect && (number < MIN || number > MAX)) {
                isIncorrect = true;
                System.err.println("Error, number should be from " + MIN + " to " + MAX);
                System.out.println("Please, enter again");
            }
        } while (isIncorrect);
        return number;
    }

    static int[][] enterArr(Scanner input, int row, int col) {
        int[][] arr = new int[row][col];
        int i, j;
        for (i = 0; i < row; i++) {
            for (j = 0; j < col; j++) {
                System.out.println("Enter a" +  (i+1) + (j+1) + " element");
                arr[i][j] = inputNum(input, MIN_ELEM, MAX_ELEM);
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
        int i, j, buffer;
        isNotSorted = true;
        while (isNotSorted) {
            isNotSorted = false;
            for (i = 1; i < arr.length; i++) {
                for (j = i; j < arr.length; j++) {
                    if (arr[j - 1] < arr[j]) {
                        isNotSorted = true;
                        buffer = arr[j];
                        arr[j] = arr[j - 1];
                        arr[j - 1] = buffer;
                    }
                }
            }
        }
    }

    static int[][] sortEvenRow(int[][] arrOfNum)
    {
        int i;
        int[][] arr = copyArr(arrOfNum);
        for (i = 1; i < arr.length; i += 2)
        {
            sortArr(arr[i]);
        }
        return arr;
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

    static int readSizeFromFile(Scanner file) {
        int size = 0;
        boolean isCorrect = true;
        try {
            size = Integer.parseInt(file.next());
        } catch (NumberFormatException e) {
            System.err.println("Data is not correct, or number is too large");
            isCorrect = false;
        }
        if (isCorrect && (size < MIN_SIZE || size > MAX_SIZE)) {
            System.err.println("Error, number should be from " + MIN_SIZE + " to " + MAX_SIZE);
            size = 0;
        }
        return size;
    }

    static boolean isAnyException(boolean isCorrect, boolean isElemIncorrect) {
        boolean anyException = !isCorrect;
        if (isElemIncorrect) {
            System.err.println("One of the element is incorrect or out of range [ " + MIN_ELEM + ", " + MAX_ELEM + " ]");
            anyException = true;
        } else if (isCorrect) {
            System.out.println("Reading is successfull");
        }
        return anyException;
    }

    static int[][] readFile(String fileName) throws IOException{
        int size;
        boolean isCorrect;
        Path path = Paths.get(fileName);
        Scanner file = new Scanner(path);
        size = readSizeFromFile(file);
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
        if (isAnyException(isCorrect, isElemIncorrect)) {
            return new int[0][0];
        } else {
            return arr;
        }
    }

    static int userChoice(Scanner input) {
        int choice;
        System.out.println("Choose a way of input/output of data\n"
                + "1 -- Console\n"
                + "2 -- File");
        choice = inputNum(input,1, 2);
        return choice;
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

    static int[][]inputFromConsole(Scanner input) {
        boolean isIncorrect;
        int size;
        int[][] arr;
        System.out.println("Enter size of array, please");
        size = inputNum(input, MIN_SIZE, MAX_SIZE);
        System.out.println("Now enter the elements");
        arr = enterArr(input, size, size);
        return arr;
    }

    static int[][] inputFromFile(Scanner input) {
        String fileName = getFileName(input);
        int[][] arr = null;
        try {
            arr = readFile(fileName);
        } catch (IOException e) {
            System.err.println("IOException");
        }
        return arr;
    }
    
    static int[][] inputInf(Scanner input) {
        int choice = userChoice(input);
        int[][] arr;
        if (choice == 1) {
            arr = inputFromConsole(input);
        } else {
            arr = inputFromFile(input);
        }
        return arr;
    }

    static void writeFile(int[][] defaultArr, int[][] sortedArr, String fileName) throws IOException {
        int i, j;
        PrintWriter file = new PrintWriter(fileName);
        file.println("Default array");
        for (i = 0; i < defaultArr.length; i++){
            for (j = 0; j < defaultArr[i].length; j++) {
                file.print(defaultArr[i][j] + " ");
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
        System.out.println("Writing is successfull");
    }

    static void outputInConsole(int[][] defaultArr, int[][] sortedArr) {
        System.out.println("Default array");
        printArr(defaultArr);
        System.out.println("Sorted array");
        printArr(sortedArr);
    }

    static void outputInFile(int[][] defaultArr, int[][] sortedArr, Scanner input) {
        String fileName = getFileName(input);
        try {
            writeFile(defaultArr, sortedArr, fileName);
        } catch(IOException e) {
            System.err.println("Write error");
        }
    }

    static void outputInf(int[][] defaultArr, int[][] sortedArr, Scanner input) {
        if (defaultArr.length > 1) {
            int choice = userChoice(input);
            if (choice == 1) {
                outputInConsole(defaultArr, sortedArr);
            } else {
                outputInFile(defaultArr, sortedArr, input);
            }
        }
    }

    public static void main(String[] args) throws IOException {
        Scanner input = new Scanner(System.in);
        int[][] arrOfNum;
        int[][] sortedArr;

        printInf();
        arrOfNum = inputInf(input);
        sortedArr = sortEvenRow(arrOfNum);
        outputInf(arrOfNum, sortedArr, input);
        input.close();
    }
}