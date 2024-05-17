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

    static final int MIN_SIZE = 3,
            MAX_SIZE = 18,
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

    static ErrCode readSizeFile(int[] arrSize, Scanner file) {
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
                err = readSizeFile(arrSize, file);
            } catch (IOException e) {
                err = ErrCode.IN_OUT_FILE_EXCEPTION;
            }

            if (err != ErrCode.SUCCESS) {
                System.err.printf(ERRORS[err.ordinal()], MIN_SIZE, MAX_SIZE);
            }
        } while (err != ErrCode.SUCCESS);

        return arrize;
    }

    static int inputInf(Scanner input) {
        int size;
        int choice;
        choice = userChoice(input);
        if (choice == 1) {
            size = inputSizeConsole(input);
        } else {
            size = inputFromFile(input);
        }
        return size;
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

    static int[][] calcSquare(int size) {
        int[][] square = new int[size][size];

        int n2 = size / 2;

        // Построение четырех квадратов порядка size / 2
        for (int i = 0, j = (n2 - 1) / 2, number = 1; number <= n2 * n2; number++, j++, i--) {
            if (i < 0)
                i += n2;
            if (i >= n2)
                i -= n2;
            if (j >= n2)
                j -= n2;
            if (j < 0)
                j += n2;

            square[i][j] = number;
            square[i + n2][j + n2] = number + n2 * n2;
            square[i][j + n2] = number + 2 * n2 * n2;
            square[i + n2][j] = number + 3 * n2 * n2;

            if (number % n2 == 0) {
                i++;
                j--; // for iteration
                i++;
            }
        }

        // Меняем местами ломанные
        int temp = square[0][0];
        square[0][0] = square[n2][0];
        square[n2][0] = temp;

        temp = square[n2 - 1][0];
        square[n2 - 1][0] = square[size - 1][0];
        square[size - 1][0] = temp;

        for (int i = 1, j = 1; i < n2 - 1; i++) {
            temp = square[i][j];
            square[i][j] = square[i + n2][j];
            square[i + n2][j] = temp;
        }

        // Свап столбцов
        int numOfColumnsToSwap = n2 - ((n2 - 3) / 2);
        for (int j = numOfColumnsToSwap; j < n2 + (n2 - 3) / 2; j++) {
            for (int i = 0; i < n2; i++) {
                temp = square[i][j];
                square[i][j] = square[i + n2][j];
                square[i + n2][j] = temp;
            }
        }

        return square;
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int size;
        int[][] square;

        printInf();
        size = inputInf(input);
        square = calcSquare(size);
        outputInf(square, size, input);

        input.close();
    }
}