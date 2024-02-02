import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Scanner;

public class Main {

    static enum ErrCodes {
        SUCCESS,
        INCORRECT_DATA,
        EMPTY_LINE,
        NOT_TXT,
        FILE_NOT_EXIST,
        NOT_ENOUGH_DATA_FILE,
        A_LOT_OF_DATA_FILE,
        IN_OUT_FILE_EXCEPTION,
        SIZE_IN_FILE_INCORRECT,

    }

    static final int MAX_NUMB = 50,
            MIN_NUMB = -50,
            MIN_SIZE = 1,
            MAX_SIZE = 5;

    static final String[] ERRORS = {"Successfull",
            "Data is not correct, or number is too large",
            "Line is empty, please be careful",
            "This is not a .txt file",
            "This file is not exist",
            "Data in file is not enough",
            "A lot of elements in file",
            "Exception with output/input from the file",
            "Size must be from 1 to 5"};

    static ErrCodes readOneNum(Scanner input, int[] numberArr, final int MIN, final int MAX) {
        int number = 0;
        ErrCodes err = ErrCodes.SUCCESS;
        try {
            number = Integer.parseInt(input.next());
        } catch (NumberFormatException e) {
            err = ErrCodes.INCORRECT_DATA;
        }
        if ((err == ErrCodes.SUCCESS) && (number < MIN || number > MAX))
            err = ErrCodes.INCORRECT_DATA;
        numberArr[0] = err == ErrCodes.SUCCESS ? number : 0;
        return err;
    }

    static int userChoice(Scanner input) {
        int[] choiceArr = {0};
        ErrCodes err;
        do {
            System.out.println("Choose a way of input/output of data\n"
                    + "1 -- Console\n"
                    + "2 -- File");
            err = readOneNum(input, choiceArr, 1, 2);
            if (err != ErrCodes.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
            }
        } while (err != ErrCodes.SUCCESS);
        input.nextLine();
        return choiceArr[0];
    }

    static int inputSize(Scanner input) {
        int[] sizeArr = {0};
        ErrCodes err;
        do {
            err = readOneNum(input, sizeArr, MIN_SIZE, MAX_SIZE);
            if (err != ErrCodes.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
                System.out.println("Try again");
            }
        } while (err != ErrCodes.SUCCESS);
        return sizeArr[0];
    }

    static int[][] inputFromConsole(Scanner input) {
        int size = 0;
        ErrCodes err;
        System.out.println("Enter size of matrix");
        size = inputSize(input);
        int[][] matrix = new int[size][size];
        for (int i = 0; i < matrix.length; i++)
            for (int j = 0; j < matrix[i].length; j++) {
                int[] numArr = {0};
                do {
                    System.out.println("Enter element a[" + (i+1) + ", " + (j+1) + "]");
                    err = readOneNum(input, numArr, MIN_NUMB, MAX_NUMB);
                    if (err != ErrCodes.SUCCESS)
                        System.err.println(ERRORS[err.ordinal()]);
                } while (err != ErrCodes.SUCCESS);
                matrix[i][j] = numArr[0];
            }
        return matrix;
    }



    static ErrCodes isFileExist(String fileName) {
        File file = new File(fileName);
        ErrCodes err;
        err = file.exists() ? ErrCodes.SUCCESS : ErrCodes.FILE_NOT_EXIST;
        return err;
    }

    static ErrCodes thisIsTxtFile(String fileName) {
        ErrCodes err;
        err = fileName.endsWith(".txt") ? ErrCodes.SUCCESS : ErrCodes.NOT_TXT;
        return err;
    }

    static ErrCodes enterFileName(String[] fileName, Scanner input) {
        ErrCodes errTxt, errExist, err;
        fileName[0] = input.nextLine();
        if (fileName[0].isEmpty())
            err = ErrCodes.EMPTY_LINE;
        else {
            errTxt = thisIsTxtFile(fileName[0]);
            errExist = isFileExist(fileName[0]);
            err = errExist != ErrCodes.SUCCESS ? errExist : errTxt;
        }
        return err;
    }

    static String getFileName(Scanner input) {
        String[] fileName = {""};
        ErrCodes err;
        System.out.println("Enter full path to file");
        do {
            err = enterFileName(fileName, input);
            if (err != ErrCodes.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
            }
        } while (err != ErrCodes.SUCCESS);
        return fileName[0];
    }

    static ErrCodes readFile(int[][] matrix, Scanner file) {
        ErrCodes err = ErrCodes.SUCCESS;
        for (int i = 0; i < matrix.length && err == ErrCodes.SUCCESS; i++)
            for (int j = 0; j < matrix.length && err == ErrCodes.SUCCESS; j++) {
                int[] arrNum = new int[1];
                if (file.hasNext()) {
                    err = readOneNum(file, arrNum, MIN_NUMB, MAX_NUMB);
                    if (err == ErrCodes.SUCCESS) {
                        matrix[i][j] = arrNum[0];
                    }
                } else {
                    err = ErrCodes.NOT_ENOUGH_DATA_FILE;
                }
            }
        if (file.hasNext()) {
            err = ErrCodes.A_LOT_OF_DATA_FILE;
        }
        return err;
    }

    static ErrCodes readSize(int[] arrSize, Scanner file) {
        ErrCodes err;
        if (file.hasNext()) {
            err = readOneNum(file, arrSize, MIN_SIZE, MAX_SIZE);
            err = err == ErrCodes.INCORRECT_DATA ? ErrCodes.SIZE_IN_FILE_INCORRECT : err;
        }
        else
            err = ErrCodes.NOT_ENOUGH_DATA_FILE;
        return err;
    }

    static int[][] inputFromFile(Scanner input) {
        int[][] matrix = {};
        int[] arrSize = new int[1];
        ErrCodes err;
        String fileName;
        do {
            fileName = getFileName(input);

            try(Scanner file = new Scanner(Paths.get(fileName))) {
                err = readSize(arrSize, file);
                if (err == ErrCodes.SUCCESS) {
                    matrix = new int[arrSize[0]][arrSize[0]];
                    err = readFile(matrix, file);
                }
            } catch (IOException e) {
                err = ErrCodes.IN_OUT_FILE_EXCEPTION;
            }

            if (err != ErrCodes.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
            }
        } while (err != ErrCodes.SUCCESS);

        return matrix;
    }

    static int[][] inputInf(Scanner input) {
        int[][] matrix = {};
        int choice;
        choice = userChoice(input);
        if (choice == 1) {
            matrix = inputFromConsole(input);
        } else {
            matrix = inputFromFile(input);
        }
        return matrix;
    }

    static int[][] deleteColRow(int[][] oldMatrix, int colInd, int rowInd) {
        int size = oldMatrix.length-1;
        int[][] newMatrix = new int[size][size];
        int curCol = 0;
        int curRow = 0;

        for (int i = 0; i < oldMatrix.length; i++) {
            if (i != rowInd) {
                for (int j = 0; j < oldMatrix.length; j++) {
                    if (j != colInd) {
                        newMatrix[curRow][curCol] = oldMatrix[i][j];
                        curCol++;
                    }
                }
                curCol = 0;
                curRow++;
            }
        }
        return newMatrix;
    }
    static int calculateDet(int[][] matrix) {
        int det = 0;
        if (matrix.length == 1)
            det = matrix[0][0];
        else {
            for (int i = 0; i < matrix.length; i++) {
                if (matrix[0][i] != 0) {
                    int[][] newMatrix = deleteColRow(matrix, i, 0);
                    int addition = matrix[0][i] * calculateDet(newMatrix);
                    addition = i % 2 == 0 ? addition : -addition;
                    det += addition;
                }
            }
        }
        return det;
    }

    static void outputToConsole(int det, int[][] matrix) {
        for (int[] row : matrix) {
            for (int element : row) {
                System.out.print(element + "\t");
            }
            System.out.println();
        }
        System.out.println("Determinant of the matrix = " + det);
    }

    static void outputInf(int det, int[][] matrix, Scanner input) {
        int choice = userChoice(input);
        if (choice == 1) {
            outputToConsole(det, matrix);
        }
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[][] matrix;
        int det;

        matrix = inputInf(input);
        det = calculateDet(matrix);
        outputInf(det, matrix, input);

        input.close();
    }
}