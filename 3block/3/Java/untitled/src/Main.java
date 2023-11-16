import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;

public class Main {

    static enum Codes {
        SUCCESS,
        INCORRECT_DATA,
        EMPTY_LINE,
        NOT_TXT,
        FILE_NOT_EXIST,
        INCORRECT_DATA_FILE,
        A_LOT_OF_DATA_FILE,
        IN_OUT_FILE_EXCEPTION,
        OUT_OF_BORDER_SIZE,
        OUT_OF_BORDER_NUMB,
    }

    static final String[] ERRORS ={"Successfull",
            "Data is not correct, or number is too large",
            "Line is empty, please be careful",
            "This is not a .txt file",
            "This file is not exist",
            "Data in file is not correct",
            "There are only elements of array should be in file",
            "Exception with output/input from the file",
            "Out of border size [2, 100]",
            "Out of border [-2000000000, 2000000000]"};
    static final int MAX_NUMB = 2000000000,
                     MIN_NUMB = -2000000000,
                     MAX_SIZE = 100,
                     MIN_SIZE = 2;
    static void printInf() {
        System.out.println("The program implements sorting by natural merging");
    }

    static int[] mergeWithPointers(int[] arr, int[] pointersArr) {
        int start1, stop1, start2, stop2, i, j, counter, pointerInd;
        int [] mergedArr = new int[arr.length];
        i = 0;
        counter = pointersArr.length - pointersArr.length % 4;
        pointerInd = 0;
        do {
            start1 = pointersArr[pointerInd++];
            stop1 = pointersArr[pointerInd++];
            start2 = pointersArr[pointerInd++];
            stop2 = pointersArr[pointerInd++];
            while (start1 < stop1 && start2 < stop2) {
                if (arr[start1] > arr[start2])
                    mergedArr[i++] = arr[start2++];
                else
                    mergedArr[i++] = arr[start1++];
            }
            while (start1 < stop1) {
                mergedArr[i++] = arr[start1++];
            }
            while (start2 < stop2) {
                mergedArr[i++] = arr[start2++];
            }
        } while (pointerInd < counter && pointersArr[pointerInd] > 0);
        if (i < arr.length) {
            for (j = pointersArr[pointerInd++]; j < pointersArr[pointerInd]; j++) {
                mergedArr[i++] = arr[j];
            }
        }
        return mergedArr;
    }

    static void fillWithZero(int[] arr) {
        for (int i = 0; i < arr.length; i++) {
            arr[i] = 0;
        }
    }

    static int[] mergeSort(int[] arr) {
        int i, pointInd, size;
        size = arr.length;
        int[] pointersArr = new int[2*size];
        do {
            fillWithZero(pointersArr);
            pointInd = 0;
            pointersArr[pointInd++] = 0;
            for (i = 1; i < size; i++) {
                if (arr[i] < arr[i - 1]) {
                    pointersArr[pointInd++] = i;
                    pointersArr[pointInd++] = i;
                }
            }
            pointersArr[pointInd] = i;

            arr = mergeWithPointers(arr, pointersArr);
        } while (pointersArr[1] != arr.length);
        return arr;
    }

    static Codes inputChoice(Scanner input, int[] choice){
        Codes err;
        String choiceStr;
        err = Codes.SUCCESS;
        choiceStr = input.nextLine();
        if (choiceStr.equals("1") || choiceStr.equals("2")) {
            choice[0] = Integer.parseInt(choiceStr);
        } else {
            err = choiceStr.isEmpty() ? Codes.EMPTY_LINE : Codes.INCORRECT_DATA;
        }
        return err;
    }

    static int userChoice(Scanner input) {
        int[] choice = {0};
        System.out.println("Choose a way of input/output of data\n"
                + "1 -- Console\n"
                + "2 -- File");
        Codes err;
        do {
            err = inputChoice(input, choice);
            if (err != Codes.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
                System.out.println("Please, enter again");
            }
        } while (err != Codes.SUCCESS);
        return choice[0];
    }

    static Codes inpValidSize(int[] size, Scanner input) {
        Codes err;
        int sizeInt;
        sizeInt = 0;
        err = Codes.SUCCESS;
        try {
            sizeInt = Integer.parseInt(input.nextLine());
        } catch (NumberFormatException e) {
            err = Codes.INCORRECT_DATA;
        }
        if (err == Codes.SUCCESS && (sizeInt > MAX_SIZE || sizeInt < MIN_SIZE)) {
            err = Codes.OUT_OF_BORDER_SIZE;
        }
        size[0] = sizeInt;
        return err;
    }

    static Codes inpValidArr(int[] arr, Scanner input) {
        Codes err;
        int i;
        i = 0;
        err = Codes.SUCCESS;
        while (i < arr.length && err == Codes.SUCCESS) {
            try {
                arr[i] = Integer.parseInt(input.nextLine());
            } catch (NumberFormatException e) {
                err = Codes.INCORRECT_DATA;
            }
            if (err == Codes.SUCCESS && (arr[i] > MAX_NUMB || arr[i] < MIN_NUMB)) {
                err = Codes.OUT_OF_BORDER_NUMB;
            }
            i++;
        }
        return err;
    }
    static int[] inputFromConsole(Scanner input) {
        System.out.println("Enter the size[2, 100] and then the \n"
                           + "elements[-2000000000, 2000000000] through the Enter");
        Codes err;
        int[] size = {0};
        do {
            err = inpValidSize(size, input);
            if (err != Codes.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
                System.out.println("Please, enter again size");
            }
        } while (err != Codes.SUCCESS);
        int[] defaultArr = new int[size[0]];
        System.out.println("Enter the " + size[0] + " elements");
        do {
            err = inpValidArr(defaultArr, input);
            if (err != Codes.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
                System.out.println("Please, enter again " + size[0] + " elements");
            }
        } while (err != Codes.SUCCESS);
        return defaultArr;
    }

    static Codes readSizeFromFile(int[] size, Scanner file) {
        Codes err;
        int sizeInt;
        err = Codes.SUCCESS;
        sizeInt = 0;
        try {
            sizeInt = Integer.parseInt(file.next());
        } catch (NumberFormatException e) {
            err = Codes.INCORRECT_DATA_FILE;
        }
        if (err == Codes.SUCCESS)
            if ((sizeInt > MAX_SIZE) || (sizeInt < MIN_SIZE))
                err = Codes.OUT_OF_BORDER_SIZE;
            else
                size[0] = sizeInt;
        return err;
    }

    static Codes readArrFromFile(int[] arr, Scanner file){
        Codes err;
        int i;
        err = Codes.SUCCESS;
        i = 0;
        while (i < arr.length && err == Codes.SUCCESS) {
            try {
                arr[i] = Integer.parseInt(file.next());
            } catch (NumberFormatException e) {
                err = Codes.INCORRECT_DATA_FILE;
            }
            if (err == Codes.SUCCESS && (arr[i] > MAX_NUMB || arr[i] < MIN_NUMB)) {
                err = Codes.OUT_OF_BORDER_NUMB;
            }
            i++;
        }
        if (i == arr.length && file.hasNextLine())
            err = Codes.A_LOT_OF_DATA_FILE;

        return err;
    }

    static Codes isFileExist(String fileName) {
        File file = new File(fileName);
        Codes err;
        err = file.exists() ? Codes.SUCCESS : Codes.FILE_NOT_EXIST;
        return err;
    }

    static Codes thisIsTxtFile(String fileName) {
        Codes err;
        err = fileName.endsWith(".txt") ? Codes.SUCCESS : Codes.NOT_TXT;
        return err;
    }

    static String getFileName(Scanner input) {
        boolean isIncorrect;
        String fileName;
        Codes errTxt, errExist;
        System.out.println("Enter full path to file");
        do {
            isIncorrect = false;
            fileName = input.nextLine();
            errTxt = thisIsTxtFile(fileName);
            errExist = isFileExist(fileName);
            if (errTxt != Codes.SUCCESS) {
                isIncorrect = true;
                System.err.println(ERRORS[errTxt.ordinal()]);
            }
            else if (errExist != Codes.SUCCESS) {
                isIncorrect = true;
                System.err.println(ERRORS[errExist.ordinal()]);
            }
        } while (isIncorrect);
        return fileName;
    }

    static int[] inputFromFile(Scanner input){
        Codes err;
        int[] defaultArr = {};
        err = Codes.SUCCESS;
        int[] size = {0};
        do {
            String fileName = getFileName(input);
            Path path = Paths.get(fileName);
            try(Scanner file = new Scanner(path)) {
                err = readSizeFromFile(size, file);
                defaultArr = new int[size[0]];
                if (err == Codes.SUCCESS) {
                    err = readArrFromFile(defaultArr, file);
                }
                if (err != Codes.SUCCESS) {
                    System.err.println(ERRORS[err.ordinal()]);
                }
            } catch (IOException e) {
                System.err.println(ERRORS[Codes.IN_OUT_FILE_EXCEPTION.ordinal()]);
                System.out.println("Please, enter full path again");
            }
        } while (err != Codes.SUCCESS);
        System.out.println("Reading is successfull");
        return defaultArr;
    }

    static int[] inputInf(Scanner input){
        int choice = userChoice(input);
        int[] borders = {0, 0};
        if (choice == 1) {
            borders = inputFromConsole(input);
        } else {
            borders = inputFromFile(input);
        }
        return borders;
    }

    static void writeInConsole(int[] defaultArr, int[] sortedArr) {
        int i;
        System.out.println("Default arr");
        for (i = 0; i < defaultArr.length; i++)
            System.out.print(defaultArr[i] + " ");
        System.out.println("\nSorted arr");
        for (i = 0; i < sortedArr.length; i++)
            System.out.print(sortedArr[i] + " ");
    }

    static void writeInFile(int[] defaultArr, int[] sortedArr, Scanner input) {
        boolean isIncorrect;
        int i;
        do {
            String fileName = getFileName(input);
            isIncorrect = false;
            try (PrintWriter file = new PrintWriter(fileName)) {
                file.println("Default arr");
                for (i = 0; i < defaultArr.length; i++)
                    file.print(defaultArr[i] + " ");
                file.println("\nSorted arr");
                for (i = 0; i < sortedArr.length; i++)
                    file.print(sortedArr[i] + " ");
            } catch (IOException e) {
                isIncorrect = true;
                System.err.println(ERRORS[Codes.IN_OUT_FILE_EXCEPTION.ordinal()]);
            }
        } while (isIncorrect);
        System.out.println("Writing is successfull");
    }

    static void outputInf(int[] defaultArr, int[] sortedArr, Scanner input){
        int choice = userChoice(input);
        if (choice == 1) {
            writeInConsole(defaultArr, sortedArr);
        } else {
            writeInFile(defaultArr, sortedArr, input);
        }
    }

    static int[] copyArr(int[] arr) {
        int[] copyedArr = new int[arr.length];
        int i;
        for (i = 0; i < arr.length; i++) {
            copyedArr[i] = arr[i];
        }
        return copyedArr;
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[] defaultArr;
        int[] sortedArr;

        printInf();
        defaultArr = inputInf(input);
        sortedArr = copyArr(defaultArr);
        sortedArr = mergeSort(sortedArr);
        outputInf(defaultArr, sortedArr, input);

        input.close();
    }
}