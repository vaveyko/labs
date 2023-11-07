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
        A_LOT_OF_DATA_FILE,
        IN_OUT_FILE_EXCEPTION;


    }
    static final String[] ERRORS ={"Successfull",
            "Data is not correct, or number is too large",
            "Line is empty, please be careful",
            "This is not a .txt file",
            "This file is not exist",
            "There is only one line in file should be",
            "Exception with output/input from the file"};

    static void printInf() {
        System.out.println("Program selects a substring consisting of digits corresponding"
                           + "to an integer \n(starts with a '+' or '-' "
                           + "and there are no letters and dots inside the substring");
    }

    static String getNumFromLine(String line) {
        String numb;
        int i, size;
        boolean isNumbNotExist;
        isNumbNotExist = true;
        size = line.length();
        i = 0;
        numb = "not exist";

        while (i < size) {
            if (isNumbNotExist && (line.charAt(i) == '+' || line.charAt(i) == '-')) {
                numb = String.valueOf(line.charAt(i));
                i++;
                while (i < size && Character.isDigit(line.charAt(i)))
                    numb += line.charAt(i++);
                isNumbNotExist = numb.length() == 1;
                if (isNumbNotExist)
                    numb = "not exist";
            }
            else
                ++i;
        }
        return numb;
    }

    static int inputChoice(Scanner input,int[] choice){
        int err;
        String choiceStr;
        err = Codes.SUCCESS.ordinal();
        choiceStr = input.nextLine();
        if (choiceStr.equals("1") || choiceStr.equals("2")) {
            choice[0] = Integer.parseInt(choiceStr);
        } else {
            err = choiceStr.isEmpty() ? Codes.EMPTY_LINE.ordinal() : Codes.INCORRECT_DATA.ordinal();
        }
        return err;
    }

    static int userChoice(Scanner input) {
        int[] choice = {0};
        System.out.println("Choose a way of input/output of data\n"
                + "1 -- Console\n"
                + "2 -- File");
        int err;
        do {
            err = inputChoice(input, choice);
            if (err > 0) {
                System.err.println(ERRORS[err]);
                System.out.println("Please, enter again");
            }
        } while (err > 0);
        return choice[0];
    }

    static int inpValidLine(String[] line, Scanner input) {
        int err;
        err = Codes.SUCCESS.ordinal();
        line[0] = input.nextLine();
        if (line[0].isEmpty()) {
            err = Codes.EMPTY_LINE.ordinal();
        }
        return err;
    }

    static int readFile(String[] line, String fileName) throws IOException{
        int errCode;
        Path path = Paths.get(fileName);
        Scanner file = new Scanner(path);
        errCode = Codes.SUCCESS.ordinal();
        line[0] = file.nextLine();
        if (line[0].isEmpty())
            errCode = Codes.EMPTY_LINE.ordinal();
        if (file.hasNextLine()) {
            errCode = Codes.A_LOT_OF_DATA_FILE.ordinal();
        }
        file.close();
        return errCode;

    }

    static int isFileExist(String fileName) {
        File file = new File(fileName);
        int err;
        err = file.exists() ? Codes.SUCCESS.ordinal() : Codes.FILE_NOT_EXIST.ordinal();
        return err;
    }

    static int thisIsTxtFile(String fileName) {
        int err;
        err = fileName.endsWith(".txt") ? Codes.SUCCESS.ordinal() : Codes.NOT_TXT.ordinal();
        return err;
    }

    static String getFileName(Scanner input) {
        boolean isIncorrect;
        String fileName;
        int errTxt, errExist;
        System.out.println("Enter full path to file");
        do {
            isIncorrect = false;
            fileName = input.nextLine();
            errTxt = thisIsTxtFile(fileName);
            errExist = isFileExist(fileName);
            if (errTxt > 0) {
                isIncorrect = true;
                System.err.println(ERRORS[errTxt]);
            }
            else if (errExist > 0) {
                isIncorrect = true;
                System.err.println(ERRORS[errExist]);
            }
        } while (isIncorrect);
        return fileName;
    }

    static void inputFromFile(Scanner input, String[] line){
        int err;
        do {
            String fileName = getFileName(input);
            try {
                err = readFile(line, fileName);
            } catch (IOException e) {
                err = Codes.IN_OUT_FILE_EXCEPTION.ordinal();
            }
            if (err > 0) {
                System.err.println(ERRORS[err]);
                System.out.println("Please, enter full path again");
            }
        } while (err > 0);
        System.out.println("Reading is successfull");
    }

    static void inputFromConsole(Scanner input, String[] line) {
        System.out.println("Enter the line");
        int err;
        do {
            err = inpValidLine(line, input);
            if (err > 0) {
                System.err.println(ERRORS[err]);
                System.out.println("Please, enter again");
            }
        } while (err > 0);
    }

    static String inputInf(Scanner input){
        int choice = userChoice(input);
        String[] line = {""};
        if (choice == 1) {
            inputFromConsole(input, line);
        } else {
            inputFromFile(input, line);
        }
        return line[0];
    }

    static void writeInConsole(String line, String num) {
        System.out.println("Default line\n" + line);
        System.out.println("Substring\n" + num);
    }

    static void writeInFile(Scanner input, String line, String num) throws IOException {
        String fileName = getFileName(input);
        PrintWriter file = new PrintWriter(fileName);
        file.println("Default line\n" + line);
        file.println("Substring\n" + num);
        file.close();
        System.out.println("Writing is successfull");
    }

    static void outputInf(String line, String num, Scanner input) throws IOException {
        int choice = userChoice(input);
        if (choice == 1) {
            writeInConsole(line, num);
        } else {
            try {
                writeInFile(input, line, num);
            } catch (IOException e) {
                throw new IOException(ERRORS[Codes.IN_OUT_FILE_EXCEPTION.ordinal()]);
            }
        }
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        String line, num;
        printInf();
        line = inputInf(input);
        num = getNumFromLine(line);
        try {
            outputInf(line, num, input);
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
        input.close();
    }
}