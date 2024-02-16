import java.io.*;
import java.util.Scanner;

record Toy (String name, int count, int cost, int minAge, int maxAge) {}
public class Main {

    enum ErrCode {
        SUCCESS,
        INCORRECT_DATA,
        INCORRECT_NAME,
        EMPTY_LINE,

    }

    static final int MIN_COUNT = 0,
            MAX_COUNT = 2000000000,
            MIN_COST = 0,
            MAX_COST = 2000000000,
            MIN_AGE = 1,
            MAX_AGE = 120;

    static final String[] ERRORS = {"Successfully",
            "Data is not correct , or number is too large (must be from %d to %d)\n",
            "The name must be no more than 20 characters long",
            "Line is empty, please be careful"};
    static final String STORAGE_FILE_PATH = "StorageFile.txt";
    static final String BUFFER_FILE_PATH = "BufferFile.txt";
    static final String CORRECTION_FILE_PATH = "CorrectionFile.txt";

    static DataOutputStream openFileToWrite(String fileName) throws IOException{
        DataOutputStream openedFile = null;
        File file = new File(fileName);
        if (!file.exists())
            file.createNewFile();
        return new DataOutputStream(new FileOutputStream(fileName));
    }

    static DataInputStream openFileToRead(String fileName) throws IOException{
        File file = new File(fileName);
        if (!file.exists()) {
            file.createNewFile();
        }
        return new DataInputStream(new FileInputStream(fileName));
    }

    static Toy readRec(DataInputStream file) throws IOException{
        String name;
        int count, cost, minAge, maxAge;
        name = file.readUTF();
        count = file.readInt();
        cost = file.readInt();
        minAge = file.readInt();
        maxAge = file.readInt();
        return new Toy(name, count, cost, minAge, maxAge);
    }

    static void writeRec(DataOutputStream file, Toy toy) throws IOException{
        file.writeUTF(toy.name());
        file.writeInt(toy.count());
        file.writeInt(toy.cost());
        file.writeInt(toy.minAge());
        file.writeInt(toy.maxAge());
    }

    static void renameFileTo(String oldName, String newName) {
        File oldFile = new File(newName);
        oldFile.delete();
        File newFile = new File(oldName);
        newFile.renameTo(oldFile);
    }

    static void copyFile(String destFilePath, String soursFilePath) {
        try(DataInputStream inputFile = openFileToRead(soursFilePath);
            DataOutputStream outputFile = openFileToWrite(destFilePath)) {
            while (inputFile.available() > 0)
                writeRec(outputFile, readRec(inputFile));
        } catch (IOException e) {
            System.err.println("malo toy`s");
        }
    }
    static void addRecToFile(String fileName, Toy toy) {
        try(DataOutputStream outputFile = openFileToWrite(BUFFER_FILE_PATH);
            DataInputStream inputFile = openFileToRead(fileName)) {
            while (inputFile.available() > 0)
                writeRec(outputFile, readRec(inputFile));
            writeRec(outputFile, toy);
        } catch (IOException e) {
            System.err.println("malo toy`s");
        }
        renameFileTo(BUFFER_FILE_PATH, fileName);
    }

    static void printFile(String fileName) {
        try(DataInputStream file = openFileToRead(fileName)) {
            while (file.available() > 0)
                System.out.println(readRec(file));
        } catch (IOException e) {
            System.err.println("malo toy`s");
        }
    }

    static void deleteRec(int index) {
        try (DataInputStream inputFile = openFileToRead(CORRECTION_FILE_PATH);
             DataOutputStream outputFile = openFileToWrite(BUFFER_FILE_PATH)) {
            for (int i = 1; inputFile.available() > 0; i++)
                if (i != index)
                    writeRec(outputFile, readRec(inputFile));
                else
                    readRec(inputFile);
        } catch (IOException e) {
            System.err.println(e.getMessage());
        }
        renameFileTo(BUFFER_FILE_PATH, CORRECTION_FILE_PATH);
    }

    static ErrCode enterOneNum(int[] numberArr, Scanner input, final int MIN, final int MAX) {
        int number = 0;
        ErrCode err = ErrCode.SUCCESS;
        try {
            number = Integer.parseInt(input.nextLine());
        } catch (NumberFormatException e) {
            err = ErrCode.INCORRECT_DATA;
        }
        if ((err == ErrCode.SUCCESS) && (number < MIN || number > MAX))
            err = ErrCode.INCORRECT_DATA;
        numberArr[0] = err == ErrCode.SUCCESS ? number : 0;
        return err;
    }

    static ErrCode enterName(String[] nameArr, Scanner input) {
        ErrCode err = ErrCode.SUCCESS;
        nameArr[0] = input.nextLine();
        if (nameArr[0].length() > 20)
            err = ErrCode.INCORRECT_NAME;
        if (nameArr[0].isEmpty())
            err = ErrCode.EMPTY_LINE;
        return err;
    }

    static String getName(Scanner input) {
        String[] nameArr = {""};
        ErrCode err;
        do {
            err = enterName(nameArr, input);
            if (err != ErrCode.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
                System.out.println("Enter agane please");
            }
        } while (err != ErrCode.SUCCESS);
        return nameArr[0];
    }

    static int enterField(Scanner input, final int MIN, final int MAX) {
        ErrCode err;
        int[] fieldArr = {0};
        do {
            err = enterOneNum(fieldArr, input, MIN, MAX);
            if (err != ErrCode.SUCCESS) {
                System.err.printf(ERRORS[err.ordinal()], MIN, MAX);
                System.out.println("Enter agane please");
            }
        } while (err != ErrCode.SUCCESS);
        return fieldArr[0];
    }

    static Toy enterNewToyFromConsole(Scanner input) {
        String name = "";
        int count, cost, minAge, maxAge;

        System.out.println("Enter name of toy:");
        name = getName(input);

        System.out.println("Enter count of toy:");
        count = enterField(input, MIN_COUNT, MAX_COUNT);

        System.out.println("Enter cost of toy:");
        cost = enterField(input, MIN_COST, MAX_COST);

        System.out.println("Enter minimal age of toy:");
        minAge = enterField(input, MIN_AGE, MAX_AGE);

        System.out.println("Enter maximum age of toy:");
        maxAge = enterField(input, minAge, MAX_AGE);

        return new Toy(name, count, cost, minAge+1, maxAge);
    }

    static void changeRec(int index, Scanner input) {
        try (DataInputStream inputFile = openFileToRead(CORRECTION_FILE_PATH);
             DataOutputStream outputFile = openFileToWrite(BUFFER_FILE_PATH)) {
            for (int i = 1; inputFile.available() > 0; i++)
                if (i != index)
                    writeRec(outputFile, readRec(inputFile));
                else {
                    readRec(inputFile);
                    writeRec(outputFile, enterNewToyFromConsole(input));
                }
        } catch (IOException e) {
            System.err.println(e.getMessage());
        }
        renameFileTo(BUFFER_FILE_PATH, CORRECTION_FILE_PATH);
    }

    public static void main(String[] args) {
        System.out.println("Hello world!");
        Scanner input = new Scanner(System.in);
        copyFile(CORRECTION_FILE_PATH, STORAGE_FILE_PATH);

//        deleteRec(1);
        printFile(CORRECTION_FILE_PATH);

        System.out.println('\n');
        //Toy toy = enterNewToyFromConsole(input);
        //addRecToFile(CORRECTION_FILE_PATH, toy);
        deleteRec(2);
        printFile(CORRECTION_FILE_PATH);

        System.out.println('\n');
        changeRec(2, input);
        printFile(CORRECTION_FILE_PATH);

        copyFile(STORAGE_FILE_PATH, CORRECTION_FILE_PATH);
    }
}