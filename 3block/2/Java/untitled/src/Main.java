import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;
import java.util.TreeSet;

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
        OUT_OF_BORDER,
        INCORRECT_BORDERS;

    }

    static final int MAX_NUMB = 255,
                     MIN_NUMB = 0;

    static final String[] ERRORS ={"Successfull",
            "Data is not correct, or number is too large",
            "Line is empty, please be careful",
            "This is not a .txt file",
            "This file is not exist",
            "Data in file is not correct",
            "There are two numbers in file should be",
            "Exception with output/input from the file",
            "Out of border [0, 255]",
            "Incorrect borders"};

    static void printInf() {
        System.out.println("Program forms two sets, the first of which contains all simple "
                + "\nnumbers from this set, and the second contains others");
        System.out.println("Borders and numbers should be in the interval [0, 255]");
    }

    static boolean isNumbSimple(int numb) {
        boolean isSimple;
        isSimple = true;
        int rightBord;
        rightBord = (int) Math.sqrt(numb)+1;
        if (numb > 3)
            for (int i = 2; i < rightBord && isSimple; i++)
                if (numb % i == 0)
                    isSimple = false;
        return isSimple;
    }

    static TreeSet<Integer> getSetOfSimple(TreeSet<Integer> defaultSet) {
        TreeSet<Integer> simpleSet = new TreeSet<>();
        for (int numb : defaultSet)
            if (isNumbSimple(numb))
                simpleSet.add(numb);
        return simpleSet;
    }

    static TreeSet<Integer> getSetOfComposit(TreeSet<Integer> defaultSet, TreeSet<Integer> simpleSet) {
        TreeSet<Integer> compositSet = new TreeSet<>();
        for(int numb : defaultSet)
            if (!simpleSet.contains(numb))
                compositSet.add(numb);
        return compositSet;
    }

    static TreeSet<Integer> createSetWithBorders(int[] borders) {
        TreeSet<Integer> numbSet = new TreeSet<>();
        borders[1]++;
        int i;
        for (i = borders[0]; i < borders[1]; i++)
            numbSet.add(i);
        return numbSet;
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

    static Codes inpValidBorder(int[] numb, Scanner input) {
        int numbInt;
        Codes err;
        boolean isCorrect;
        err = Codes.SUCCESS;
        isCorrect = true;
        numbInt = -1;
        try {
            numbInt = Integer.parseInt(input.nextLine());
        } catch (NumberFormatException e) {
            err = Codes.INCORRECT_DATA;
            isCorrect = false;
        }
        if (isCorrect)
            if (numbInt > MAX_NUMB || numbInt < MIN_NUMB)
                err = Codes.OUT_OF_BORDER;
            else
                numb[0] = numbInt;
        return err;
    }

    static Codes inpValidBorders(int[] borders, Scanner input) {
        Codes err;
        int[] border = {0};
        border[0] = borders[0];
        err = inpValidBorder(border, input);
            if (err == Codes.SUCCESS) {
                borders[0] = border[0];
                border[0] = borders[1];
                err = inpValidBorder(border, input);
                if (err == Codes.SUCCESS) {
                    borders[1] = border[0];
                    if (borders[0] > borders[1])
                        err = Codes.INCORRECT_BORDERS;
                }
            }
        return err;
    }

    static int[] inputFromConsole(Scanner input) {
        int[] borders = {0,0};
        System.out.println("Enter the borders through the Enter");
        Codes err;
        do {
            err = inpValidBorders(borders, input);
            if (err != Codes.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
                System.out.println("Please, enter again");
            }
        } while (err != Codes.SUCCESS);
        return borders;
    }

    static Codes readOneFromFile(int[] numb, Scanner file) {
        Codes err;
        int numbInt;
        boolean isCorrect;
        err = Codes.SUCCESS;
        numbInt = 0;
        isCorrect = true;
        try {
            numbInt = Integer.parseInt(file.next());
        } catch (NumberFormatException e) {
            err = Codes.INCORRECT_DATA_FILE;
            isCorrect = false;
        }
        if (isCorrect)
            if ((numbInt > MAX_NUMB) || (numbInt < MIN_NUMB))
                err = Codes.OUT_OF_BORDER;
            else
                numb[0] = numbInt;
        return err;
    }

    static Codes readFile(int[] borders, String fileName) throws IOException{
        Codes err;
        Path path = Paths.get(fileName);
        Scanner file = new Scanner(path);

        int[] border = {0};
        border[0] = borders[0];
        err = readOneFromFile(border, file);
        if (err == Codes.SUCCESS) {
            borders[0] = border[0];
            border[0] = borders[1];
            err = readOneFromFile(border, file);
            if (err == Codes.SUCCESS) {
                borders[1] = border[0];
                if (borders[0] > borders[1])
                    err = Codes.INCORRECT_BORDERS;
                if (file.hasNextLine())
                    err = Codes.A_LOT_OF_DATA_FILE;
            }
        }
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
        int[] borders = {0, 0};
        do {
            String fileName = getFileName(input);
            try {
                err = readFile(borders, fileName);
            } catch (IOException e) {
                err = Codes.IN_OUT_FILE_EXCEPTION;
            }
            if (err != Codes.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
                System.out.println("Please, enter full path again");
            }
        } while (err != Codes.SUCCESS);
        System.out.println("Reading is successfull");
        return borders;
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

    static void writeInConsole(TreeSet<Integer> defaultSet, TreeSet<Integer> setSimple, TreeSet<Integer> setComposit) {
        System.out.print("Default set\n{ ");
        for (int i : defaultSet)
            System.out.print(i + " ");
        System.out.print("}\nSet with simple numbers\n{ ");
        for (int i : setSimple)
            System.out.print(i + " ");
        System.out.print("}\nSet with composite numbers\n{ ");
        for (int i : setComposit)
            System.out.print(i + " ");
        System.out.println("}");
    }

    static void writeInFile(TreeSet<Integer> defaultSet, TreeSet<Integer> setSimple,
                            TreeSet<Integer> setComposit, Scanner input) {
        boolean isIncorrect;
        do {
            String fileName = getFileName(input);
            isIncorrect = false;
            try (PrintWriter file = new PrintWriter(fileName)) {
                file.print("Default set\n{ ");
                for (int i : defaultSet)
                    file.print(i + " ");
                file.print("}\nSet with simple numbers\n{ ");
                for (int i : setSimple)
                    file.print(i + " ");
                file.print("}\nSet with composite numbers\n{ ");
                for (int i : setComposit)
                    file.print(i + " ");
                file.println("}");
            } catch (IOException e) {
                isIncorrect = true;
                System.err.println(ERRORS[Codes.IN_OUT_FILE_EXCEPTION.ordinal()]);
            }
        } while (isIncorrect);
        System.out.println("Writing is successfull");
    }

    static void outputInf(TreeSet<Integer> defaultSet, TreeSet<Integer> setSimple,
                          TreeSet<Integer> setComposit, Scanner input){
        int choice = userChoice(input);
        if (choice == 1) {
            writeInConsole(defaultSet, setSimple, setComposit);
        } else {
            writeInFile(defaultSet, setSimple, setComposit, input);
        }
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[] borders;
        TreeSet<Integer> defaultSet, setWithSimple, setWithComposit;

        printInf();
        borders = inputInf(input);
        defaultSet = createSetWithBorders(borders);
        setWithSimple = getSetOfSimple(defaultSet);
        setWithComposit = getSetOfComposit(defaultSet, setWithSimple);
        outputInf(defaultSet, setWithSimple, setWithComposit, input);

        input.close();
    }
}