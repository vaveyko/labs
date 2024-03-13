import java.io.*;
import java.util.Scanner;

record Toy (String name, int count, int cost, int minAge, int maxAge) {
    @Override
    public String toString() {
        return String.format("| %-20s | %-10d | %-10d | %5d - %-5d |",
                this.name, this.count, this.cost, this.minAge, this.maxAge);
    }
}
public class Main {

    enum ErrCode {
        SUCCESS,
        INCORRECT_DATA,
        INCORRECT_NAME,
        EMPTY_LINE,
        NO_SUCH_REC,
        IO_EXCEPTION,
        TO_MUCH_RECORDS,
    }

    enum Choice {
        addRec("Добавить"),
        deleteRec("Удалить"),
        changeRec("Изменить"),
        save("Сохранить изменения"),
        findByAge("Найти игрушки подходящие по возрасту"),
        findByCost("Найти игрушку по цене"),
        close("Закрыть");

        private final String inf;
        Choice (String infLine) {
            this.inf = infLine;
        }
        private String getInf(){return this.ordinal() + ") " + this.inf;}
    }

    static final int MIN_COUNT = 0,
            MAX_COUNT = 2000000000,
            MIN_COST = 0,
            MAX_COST = 2000000000,
            MIN_AGE = 1,
            MAX_AGE = 120,
            MAX_REC_COUNT = 999;

    static final String[] ERRORS = {"Удача",
            "Данные не корректные или число слишком большое (должно быть от %d до %d)\n",
            "Имя должно быть максимум 20 символов в длинну",
            "Строка пустая, будьте внимательны",
            "Записи с таким номером нет в списке!",
            "Ошибка чтения/записи файла",
            "Записей не может быть больше чем %d\n"};
    static final String STORAGE_FILE_PATH = "StorageFile.txt",
                        BUFFER_FILE_PATH = "BufferFile.txt",
                        CORRECTION_FILE_PATH = "CorrectionFile.txt",
                        INFORMATION_TEXT = """
                        Каталог игрушек.
                        Инструкция:
                            1) Имя ограничено 20 символами
                            2) Кол-во и цена могут принимать значенияот 0 до 2000000000
                            3) Возраст принимает значения от 1 до 120
                            4) Чтобы внесенные изменения остались, требуется сохраниться
                               или выйти через кнопку
                        """,
                        START_GRID_LINE = """
             
             ------------------------------------------------------------------------
             |  №  |         ИМЯ          | КОЛИЧЕСТВО |  ЦЕНА(BYN) |    ВОЗРАСТ    |
             ------------------------------------------------------------------------
             """;

    static void printInf(Scanner input) {
        System.out.println(INFORMATION_TEXT);
        System.out.println("нажмите enter чтобы продолжить");
        input.nextLine();
    }

    static DataOutputStream openFileToWrite(String fileName) throws IOException{
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
            System.err.println(ERRORS[ErrCode.IO_EXCEPTION.ordinal()]);
        }
    }
    static void addRecToFile(String fileName, Toy toy) {
        int countRec = 0;
        try(DataOutputStream outputFile = openFileToWrite(BUFFER_FILE_PATH);
            DataInputStream inputFile = openFileToRead(fileName)) {
            while (inputFile.available() > 0) {
                writeRec(outputFile, readRec(inputFile));
                countRec++;
            }
            if (countRec < MAX_REC_COUNT)
                writeRec(outputFile, toy);
            else
                System.err.printf(ERRORS[ErrCode.TO_MUCH_RECORDS.ordinal()], MAX_REC_COUNT);
        } catch (IOException e) {
            System.err.println(ERRORS[ErrCode.IO_EXCEPTION.ordinal()]);
        }
        renameFileTo(BUFFER_FILE_PATH, fileName);
    }

    static void printFile(String fileName) {
        Toy toy;
        String line;
        int count = 0;
        try(DataInputStream file = openFileToRead(fileName)) {
            System.out.printf(START_GRID_LINE);
            while (file.available() > 0) {
                count++;
                toy = readRec(file);
                line = String.format("| %-3d " + toy, count);
                System.out.printf(line + "\n");
                System.out.println("-".repeat(line.length()));

            }
        } catch (IOException e) {
            System.err.println(ERRORS[ErrCode.IO_EXCEPTION.ordinal()]);
        }
    }

    static ErrCode deleteRec(int index) {
        ErrCode err = ErrCode.NO_SUCH_REC;
        try (DataInputStream inputFile = openFileToRead(CORRECTION_FILE_PATH);
             DataOutputStream outputFile = openFileToWrite(BUFFER_FILE_PATH)) {
            for (int i = 1; inputFile.available() > 0; i++)
                if (i != index)
                    writeRec(outputFile, readRec(inputFile));
                else {
                    err = ErrCode.SUCCESS;
                    readRec(inputFile);
                }
        } catch (IOException e) {
            err = ErrCode.IO_EXCEPTION;
        }
        renameFileTo(BUFFER_FILE_PATH, CORRECTION_FILE_PATH);
        return err;
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

    static ErrCode enterNameConsole(String[] nameArr, Scanner input) {
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
            err = enterNameConsole(nameArr, input);
            if (err != ErrCode.SUCCESS) {
                System.err.println(ERRORS[err.ordinal()]);
                System.out.println("Введите снова");
            }
        } while (err != ErrCode.SUCCESS);
        return nameArr[0];
    }

    static int getNumConsole(Scanner input, final int MIN, final int MAX) {
        ErrCode err;
        int[] numberArr = {0};
        do {
            err = enterOneNum(numberArr, input, MIN, MAX);
            if (err != ErrCode.SUCCESS) {
                System.err.printf(ERRORS[err.ordinal()], MIN, MAX);
                System.out.println("Введите снова");
            }
        } while (err != ErrCode.SUCCESS);
        return numberArr[0];
    }

    static Toy enterNewToyFromConsole(Scanner input) {
        String name;
        int count, cost, minAge, maxAge;

        System.out.println("Введите имя игрушки:");
        name = getName(input);

        System.out.println("Введите кол-во игрушек:");
        count = getNumConsole(input, MIN_COUNT, MAX_COUNT);

        System.out.println("Введите цену игрушки (в BYN):");
        cost = getNumConsole(input, MIN_COST, MAX_COST);

        System.out.println("Введите минимальный возраст:");
        minAge = getNumConsole(input, MIN_AGE, MAX_AGE - 1);

        System.out.println("Введите максимальный возраст:");
        maxAge = getNumConsole(input, minAge+1, MAX_AGE);

        return new Toy(name, count, cost, minAge, maxAge);
    }

    static ErrCode changeRec(int index, Scanner input) {
        ErrCode err = ErrCode.NO_SUCH_REC;
        try (DataInputStream inputFile = openFileToRead(CORRECTION_FILE_PATH);
             DataOutputStream outputFile = openFileToWrite(BUFFER_FILE_PATH)) {
            for (int i = 1; inputFile.available() > 0; i++)
                if (i != index)
                    writeRec(outputFile, readRec(inputFile));
                else {
                    err = ErrCode.SUCCESS;
                    readRec(inputFile);
                    writeRec(outputFile, enterNewToyFromConsole(input));
                }
        } catch (IOException e) {
            err = ErrCode.IO_EXCEPTION;
        }
        renameFileTo(BUFFER_FILE_PATH, CORRECTION_FILE_PATH);
        return err;
    }

    static void printMenu() {
        Choice[] choices = Choice.values();
        for (Choice choice : choices) {
            System.out.println(choice.getInf());
        }
    }

    static Choice getChoice(Scanner input) {
        int choice;
        int maxChoice = Choice.values().length - 1;
        choice = getNumConsole(input, 0, maxChoice);
        return Choice.values()[choice];
    }
    
    static void findRec(Choice choice, int criteria) {
        Toy toy;
        boolean isValid;
        try (DataInputStream inputFile = openFileToRead(CORRECTION_FILE_PATH);
             DataOutputStream outputFile = openFileToWrite(BUFFER_FILE_PATH)) {
            while (inputFile.available() > 0) {
                toy = readRec(inputFile);
                if (choice.equals(Choice.findByAge))
                    isValid = criteria >= toy.minAge();
                else
                    isValid = criteria >= toy.cost();
                if (isValid)
                    writeRec(outputFile, toy);

            }
        } catch (IOException e) {
            System.err.println(ERRORS[ErrCode.IO_EXCEPTION.ordinal()]);
        }
        printFile(BUFFER_FILE_PATH);
        new File(BUFFER_FILE_PATH).delete();
    }

    static boolean doFunction(Scanner input) {
        Choice choice = getChoice(input);
        ErrCode err;
        boolean isClose = false;
        switch (choice) {
            case addRec -> {
                Toy toy = enterNewToyFromConsole(input);
                addRecToFile(CORRECTION_FILE_PATH, toy);
            }
            case deleteRec -> {
                System.out.print("Введите номер записи, которую хотите удалить: ");
                int index = getNumConsole(input, 0, MAX_COUNT);
                err = deleteRec(index);
                if (err != ErrCode.SUCCESS) {
                    System.err.println(ERRORS[err.ordinal()]);
                }
            }
            case changeRec -> {
                System.out.print("Введите номер записи, которую хотите изменить: ");
                int index = getNumConsole(input, 0, MAX_COUNT);
                err = changeRec(index, input);
                if (err != ErrCode.SUCCESS) {
                    System.err.println(ERRORS[err.ordinal()]);
                }
            }
            case save -> {
                copyFile(STORAGE_FILE_PATH, CORRECTION_FILE_PATH);
            }
            case findByAge -> {
                System.out.print("Введите возраст, для которого хотите найти игрушки: ");
                int age = getNumConsole(input, MIN_AGE, MAX_AGE);
                findRec(choice, age);
                System.out.println("нажмите enter чтобы продолжить");
                input.nextLine();
            }
            case findByCost -> {
                System.out.print("Введите цену, до которой хотите найти игрушки: ");
                int cost = getNumConsole(input, MIN_COST, MAX_COST);
                findRec(choice, cost);
                System.out.println("нажмите enter чтобы продолжить");
                input.nextLine();
            }
            case close -> {
                renameFileTo(CORRECTION_FILE_PATH, STORAGE_FILE_PATH);
                isClose = true;
            }
        }
        return isClose;
    }

    public static void main(String[] args) {

        Scanner input = new Scanner(System.in);
        printInf(input);
        copyFile(CORRECTION_FILE_PATH, STORAGE_FILE_PATH);

        boolean isClose;
        do {
            printFile(CORRECTION_FILE_PATH);
            printMenu();
            isClose = doFunction(input);
        } while (!isClose);
        input.close();
    }
}