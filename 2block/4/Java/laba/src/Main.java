import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;

public class Main {

    static final String[] ERRORS ={"Successfull",
                                   "Data is not correct, or number is too large",
                                   "Enter the number within the borders",
                                   "This is not a .txt file",
                                   "This file is not exist"};

    static final int MIN_ELEM = -2147483647;
    static final int MAX_ELEM = 2147483647;

    static void printInf() {
        System.out.println("Program converts decimal to hexadecimal");
    }
    static int getLenOfNum(int num) {
        int len = 1;
        while (num > 9) {
            len++;
            num /= 10;
        }
        return len;
    }

    static void fillWithZero(char[] arr) {
        int i;
        for (i = 0; i < arr.length; i++) {
            arr[i] = '0';
        }
    }

    static char[] intToHexArr(int num, boolean isNumNegative) {
        final char[] HEX_ELEM = {'0', '1', '2', '3', '4', '5', '6', '7', '8',
                                  '9', 'A', 'B', 'C', 'D', 'E', 'F', '-'};
        if (isNumNegative)
            num = -num;

        int lenNum = getLenOfNum(num);
        int index = 0;
        char[] hexNumArr = new char[lenNum];
        fillWithZero(hexNumArr);
        if (num > 15) {
            while (num > 1) {
                hexNumArr[index++] = HEX_ELEM[num % 16];
                num /= 16;
            }
        } else {
            hexNumArr[index] = HEX_ELEM[num];
            index++;
        }
        if (isNumNegative)
            hexNumArr[index] = HEX_ELEM[16];
        return hexNumArr;
    }

    static char[] reversArr(char[] arr) {
        char[] reversedArr = new char[arr.length];
        int index = 0;
        int i = arr.length - 1;
        while (index < reversedArr.length) {
            reversedArr[index++] = arr[i--];
        }
        return reversedArr;
    }

    static int inputNum(Scanner input,int[] number, final int MIN, final int MAX){
        int errorCode = 0;
        boolean isIncorrect = false;
        try {
            number[0] = Integer.parseInt(input.next());
        } catch (NumberFormatException e) {
            isIncorrect = true;
            errorCode = 1;
        }
        if (!isIncorrect && (number[0] < MIN || number[0] > MAX)) {
            errorCode = 2;
        }
        return errorCode;
    }

    static int userChoice(Scanner input) {
        int[] choice = {0};
        System.out.println("Choose a way of input/output of data\n"
                + "1 -- Console\n"
                + "2 -- File");
        int err = inputNum(input, choice, 1, 2);
        while (err != 0) {
            System.err.println(ERRORS[err]);
            System.out.println("Please, enter again");
            err = inputNum(input, choice, 1, 2);
        }
        return choice[0];
    }

    static int readFile(String fileName) throws IOException, NumberFormatException{
        Path path = Paths.get(fileName);
        Scanner file = new Scanner(path);
        int num = 0;
        try {
            num = Integer.parseInt(file.nextLine());
        } catch (NumberFormatException e) {
            throw new NumberFormatException("Data in file is not correct");
        }
        System.out.println("Reading is successfull");
        return num;

    }

    static int isFileExist(String fileName) {
        File file = new File(fileName);
        int err = 0;
        if (!file.exists())
            err = 4;
        return err;
    }

    static int thisIsTxtFile(String fileName) {
        int err = 0;
        if (!fileName.endsWith(".txt"))
            err = 3;
        return err;
    }

    static String getFileName(Scanner input) {
        boolean isIncorrect;
        String fileName;
        fileName = input.nextLine();
        System.out.println("Enter full path to file");
        do {
            isIncorrect = false;
            fileName = input.nextLine();
            int errTxt = thisIsTxtFile(fileName);
            int errExist = isFileExist(fileName);
            if (errTxt != 0) {
                isIncorrect = true;
                System.err.println(ERRORS[errTxt]);
            }
            else if (errExist != 0) {
                isIncorrect = true;
                System.err.println(ERRORS[errExist]);
            }
        } while (isIncorrect);
        return fileName;
    }

    static void inputFromFile(Scanner input, int[] num) throws NumberFormatException, IOException {
        String fileName = getFileName(input);
        try {
            num[0] = readFile(fileName);
        } catch (IOException e) {
            throw new IOException("Exception with reading from the file");
        }
    }

    static void inputFromConsole(Scanner input, int[] num) {
        System.out.println("Enter the number from " + MIN_ELEM + " to " + MAX_ELEM);
        int err = inputNum(input, num, MIN_ELEM, MAX_ELEM);
        while(err != 0) {
            System.err.println(ERRORS[err]);
            System.out.println("Please, enter again");
            err = inputNum(input, num, MIN_ELEM, MAX_ELEM);
        }
    }

    static int inputInf(Scanner input) throws NumberFormatException, IOException{
        int choice = userChoice(input);
        int[] num = {0};
        if (choice == 1) {
            inputFromConsole(input, num);
        } else {
            inputFromFile(input, num);
        }
        return num[0];
    }

    static char[] getArrOfHexDigit(int num) {
        boolean isNumNegative = num < 0;
        return intToHexArr(num, isNumNegative);
    }

    static void writeInConsole(int num, char[] arr) {
        int i;
        int index = 0;
        System.out.println("Decimal number:");
        System.out.println(num);
        System.out.println("hexadecimal number");
        if (arr.length > 1) {
            while (arr[index] == '0') {
                index++;
            }
            for (i = index; i < arr.length; i++) {
                System.out.print(arr[i]);
            }
        } else {
            System.out.println(arr[index]);
        }
    }

    static void writeInFile(Scanner input,int num, char[] arr) throws IOException {
        int i;
        int index = 0;
        String fileName = getFileName(input);
        PrintWriter file = new PrintWriter(fileName);
        file.println("Decimal number:");
        file.println(num);
        file.println("hexadecimal number");
        while (arr[index] == '0') {
            index++;
        }
        for (i = index; i < arr.length; i++)
            file.print(arr[i]);
        file.close();
        System.out.println("Writing is successfull");
    }

    static void outputInf(char[] arr, int num, Scanner input) throws IOException{
        arr = reversArr(arr);
        int choice = userChoice(input);
        if (choice == 1) {
            writeInConsole(num, arr);
        } else {
            try {
                writeInFile(input, num, arr);
            } catch (IOException e) {
                throw new IOException("Exception with writing in the file");
            }
        }
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        printInf();
        try {
            int num = inputInf(input);
            char[] arrOfDigit = getArrOfHexDigit(num);
            outputInf(arrOfDigit, num, input);
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
        input.close();
    }
}