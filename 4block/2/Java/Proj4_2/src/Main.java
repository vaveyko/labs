import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.Scanner;

public class Main {

    enum ErrCode {
        SUCCESS,
        INCORRECT_DATA,
        EMPTY_LINE,
        NOT_TXT,
        FILE_NOT_EXIST,
        NOT_ENOUGH_DATA_FILE,
        A_LOT_OF_DATA_FILE,
        IN_OUT_FILE_EXCEPTION,

    }

    static final int MAX_NUMB = 70,
            MIN_NUMB = -70,
            MIN_SIZE = 1,
            MAX_SIZE = 5,
            MIN_CHOICE = 1,
            MAX_CHOICE = 2;

    static final String[] ERRORS = {"Successfully",
            "Data is not correct, or number is too large (must be from %d to %d)\n",
            "Line is empty, please be careful",
            "This is not a .txt file",
            "This file is not exist",
            "Data in file is not enough",
            "A lot of elements in file",
            "Exception with output/input from the file"};

    static ErrCode readOneNum(Scanner input, int[] numberArr, final int MIN, final int MAX, boolean isFile) {
        int number = 0;
        ErrCode err = ErrCode.SUCCESS;
        try {
            number = isFile ? Integer.parseInt(input.next()) : Integer.parseInt(input.nextLine());
        } catch (NumberFormatException e) {
            err = ErrCode.INCORRECT_DATA;
        }
        if ((err.equals(ErrCode.SUCCESS)) && (number < MIN || number > MAX))
            err = ErrCode.INCORRECT_DATA;
        numberArr[0] = err == ErrCode.SUCCESS ? number : 0;
        return err;
    }

    static int userChoice(Scanner input) {
        int[] choiceArr = {0};
        ErrCode err;
        do {
            System.out.println("Choose a way of input/output of data\n"
                    + "1 -- Console\n"
                    + "2 -- File");
            err = readOneNum(input, choiceArr, 1, 2, false);
            if (err != ErrCode.SUCCESS) {
                System.err.printf(ERRORS[err.ordinal()], MIN_CHOICE, MAX_CHOICE);
            }
        } while (err != ErrCode.SUCCESS);
        return choiceArr[0];
    }

    static int inputSizeConsole(Scanner input) {
        int[] sizeArr = {0};
        ErrCode err;
        do {
            err = readOneNum(input, sizeArr, MIN_SIZE, MAX_SIZE, false);
            if (err != ErrCode.SUCCESS) {
                System.err.printf(ERRORS[err.ordinal()], MIN_SIZE, MAX_SIZE);
                System.out.println("Try again");
            }
        } while (err != ErrCode.SUCCESS);
        return sizeArr[0];
    }

    static int[][] inputFromConsole(Scanner input) {
        int size;
        ErrCode err;
        System.out.println("Enter size of matrix");
        size = inputSizeConsole(input);
        int[][] matrix = new int[size][size];
        for (int i = 0; i < matrix.length; i++)
            for (int j = 0; j < matrix[i].length; j++) {
                int[] numArr = {0};
                do {
                    System.out.println("Enter element a[" + (i+1) + ", " + (j+1) + "]");
                    err = readOneNum(input, numArr, MIN_NUMB, MAX_NUMB, false);
                    if (err != ErrCode.SUCCESS)
                        System.err.printf(ERRORS[err.ordinal()], MIN_NUMB, MAX_NUMB);
                } while (err != ErrCode.SUCCESS);
                matrix[i][j] = numArr[0];
            }
        return matrix;
    }



    static ErrCode validateFileExistence(String fileName) {
        File file = new File(fileName);
        return file.exists() ? ErrCode.SUCCESS : ErrCode.FILE_NOT_EXIST;
    }

    static ErrCode validateFileExtension(String fileName) {
        return fileName.endsWith(".txt") ? ErrCode.SUCCESS : ErrCode.NOT_TXT;
    }

    static ErrCode enterFileName(String[] fileName, Scanner input) {
        ErrCode err;
        fileName[0] = input.nextLine();
        if (fileName[0].isEmpty())
            err = ErrCode.EMPTY_LINE;
        else {
            err = validateFileExistence(fileName[0]);
            if (err.equals(ErrCode.SUCCESS)) {
                err = validateFileExtension(fileName[0]);
            }
        }
        return err;
    }

    static String getFileName(Scanner input) {
        String[] fileName = {""};
        ErrCode err;
        System.out.println("Enter full path to file");
        do {
            err = enterFileName(fileName, input);
            if (err != ErrCode.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
            }
        } while (err != ErrCode.SUCCESS);
        return fileName[0];
    }

    static ErrCode readFile(int[][] matrix, Scanner file) {
        ErrCode err = ErrCode.SUCCESS;
        for (int i = 0; i < matrix.length && err == ErrCode.SUCCESS; i++)
            for (int j = 0; j < matrix.length && err == ErrCode.SUCCESS; j++) {
                int[] arrNum = new int[1];
                if (file.hasNext()) {
                    err = readOneNum(file, arrNum, MIN_NUMB, MAX_NUMB, true);
                    if (err.equals(ErrCode.SUCCESS)) {
                        matrix[i][j] = arrNum[0];
                    }
                } else {
                    err = ErrCode.NOT_ENOUGH_DATA_FILE;
                }
            }
        if (file.hasNext()) {
            err = ErrCode.A_LOT_OF_DATA_FILE;
        }
        return err;
    }

    static ErrCode readSize(int[] arrSize, Scanner file) {
        ErrCode err;
        if (file.hasNext())
            err = readOneNum(file, arrSize, MIN_SIZE, MAX_SIZE, true);
        else
            err = ErrCode.NOT_ENOUGH_DATA_FILE;
        return err;
    }

    static int[][] inputFromFile(Scanner input) {
        int[][] matrix = {};
        int[] arrSize = new int[1];
        ErrCode err;
        String fileName;
        do {
            fileName = getFileName(input);

            try(Scanner file = new Scanner(Paths.get(fileName))) {
                err = readSize(arrSize, file);
                if (err.equals(ErrCode.SUCCESS)) {
                    matrix = new int[arrSize[0]][arrSize[0]];
                    err = readFile(matrix, file);
                }
            } catch (IOException e) {
                err = ErrCode.IN_OUT_FILE_EXCEPTION;
            }

            if (err != ErrCode.SUCCESS) {
                System.err.printf(ERRORS[err.ordinal()], MIN_SIZE, MAX_SIZE);
            }
        } while (err != ErrCode.SUCCESS);

        return matrix;
    }

    static int[][] inputInf(Scanner input) {
        int[][] matrix;
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

    static void outputToFile(int det, int[][] matrix, Scanner input) {
        ErrCode err;
        do {
            err = ErrCode.SUCCESS;
            String fileName = getFileName(input);
            try (PrintWriter file = new PrintWriter(fileName)) {
                for (int[] row : matrix) {
                    for (int element : row) {
                        file.print(element + "\t");
                    }
                    file.println();
                }
                file.println("Determinant of the matrix = " + det);
            } catch (IOException e) {
                err = ErrCode.IN_OUT_FILE_EXCEPTION;
                System.err.println(ERRORS[err.ordinal()]);
            }
        } while (err != ErrCode.SUCCESS);
    }

    static void outputInf(int det, int[][] matrix, Scanner input) {
        int choice = userChoice(input);
        if (choice == 1) {
            outputToConsole(det, matrix);
        } else {
            outputToFile(det, matrix, input);
        }
    }

    static void printInf() {
        System.out.println("Program calculates the determinant of a given matrix");
        System.out.println("Size of matrix is from 1 to 5 and element from -70 to 70");
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[][] matrix;
        int det;

        printInf();
        matrix = inputInf(input);
        det = calculateDet(matrix);
        outputInf(det, matrix, input);

        input.close();
    }
}