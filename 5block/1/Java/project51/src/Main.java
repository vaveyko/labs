import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;

class ListPt {
    int data;
    ListPt next;
    ListPt (int data, ListPt next) {
        this.data = data;
        this.next = next;
    }
}

public class Main {

    enum Choice {
        addElem("Добавить"),
        merge("Слить два списка"),
        close("Закрыть");

        private final String inf;
        Choice (String infLine) {
            this.inf = infLine;
        }
        private String getInf(){return this.ordinal() + ") " + this.inf;}
    }

    enum ErrCode {
        SUCCESS,
        INCORRECT_DATA,
        FILE_NOT_EXIST,
        EMPTY_LINE,
        NOT_TXT,
        IN_OUT_FILE_EXCEPTION,
        EMPTY_LISTS,
    }

    static final String[] ERRORS = {"Удача",
            "Данные не корректные или число слишком большое (должно быть от %d до %d)\n",
            "Такого файла не существует",
            "Строка пустая, будьте внимательны",
            "Файл не .txt",
            "Exception with output/input from the file",
            "Списки должны иметь хотя бы по одному элементу"};

    static final String INFORMATION_TEXT = """
                        Инструкция:
                            1) Элементы списка должны быть от 0 до 99999999
                            2) Чтобы добавить элемент выберите соответствующую кнопку
                            3) Данные предложится сохранить в файл
                        """,
                        CHOICE_SAVE_TEXT = """
                        Вы хотите сохранить результат?
                        1) да
                        2) нет
                        """;

    static final int MIN_ELEM = 0,
                     MAX_ELEM = 99999999;

    static void add(ListPt headPt, int elem) {
        boolean isAdded = false;
        int temp;
        ListPt tempPt;
        while ((headPt.next != null) && !isAdded) {
            headPt = headPt.next;
            if (headPt.data > elem) {
                temp = headPt.data;
                tempPt = headPt.next;
                headPt.data = elem;
                headPt.next = new ListPt(temp, tempPt);
                isAdded = true;
            }
        }
        if (!isAdded)
            headPt.next = new ListPt(elem, null);
    }

    static void merge(ListPt dest, ListPt first, ListPt second) {
        first = first.next;
        second = second.next;
        int temp;

        do {
            if (first.data > second.data) {
                temp = second.data;
                second = second.next;
            } else {
                temp = first.data;
                first = first.next;
            }
            dest.next = new ListPt(temp, null);
            dest = dest.next;
        } while (first != null && second != null);

        while (first != null) {
            dest.next = new ListPt(first.data, null);
            dest = dest.next;
            first = first.next;
        }
        while (second != null) {
            dest.next = new ListPt(second.data, null);
            dest = dest.next;
            second = second.next;
        }
    }

    static void printList(ListPt headPt, int countList) {
        System.out.printf("Список %d: ", countList);
        if (headPt.next == null)
            System.out.print("пусто");
        while (headPt.next != null) {
            headPt = headPt.next;
            System.out.print(headPt.data + " ");
        }
        System.out.println();
    }

    static void printMenu() {
        Choice[] choices = Choice.values();
        for (Choice choice : choices) {
            System.out.println(choice.getInf());
        }
    }

    static void printInf(Scanner input) {
        System.out.println(INFORMATION_TEXT);
        System.out.println("нажмите enter чтобы продолжить");
        input.nextLine();
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

    static Choice getChoice(Scanner input) {
        int choice;
        int maxChoice = Choice.values().length - 1;
        choice = getNumConsole(input, 0, maxChoice);
        return Choice.values()[choice];
    }

    static void addToList(ListPt headPt, Scanner input) {
        System.out.printf("Введите новый элемент списка (от %d до %d)\n", MIN_ELEM, MAX_ELEM);
        int elem = getNumConsole(input, MIN_ELEM, MAX_ELEM);
        add(headPt, elem);
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

    static void saveToFile(Scanner input, ListPt headPt) {
        ErrCode err;
        do {
            err = ErrCode.SUCCESS;
            String fileName = getFileName(input);
            try (PrintWriter file = new PrintWriter(fileName)) {
                while (headPt.next != null) {
                    headPt = headPt.next;
                    file.write(headPt.data + " ");
                }
            } catch (IOException e) {
                err = ErrCode.IN_OUT_FILE_EXCEPTION;
                System.err.println(ERRORS[err.ordinal()]);
            }
        } while (err != ErrCode.SUCCESS);
    }

    static void saveOrNot(Scanner input, ListPt headPt) {
        System.out.println(CHOICE_SAVE_TEXT);
        int choice = getNumConsole(input, 1, 2);
        if (choice == 1) {
            saveToFile(input, headPt);
        }
    }

    static boolean doFunction(ListPt firstList, ListPt secondList, Scanner input) {
        Choice choice = getChoice(input);
        boolean isClose = false;
        switch (choice) {
            case addElem -> {
                System.out.println("Введите список в который хотите добавить элемент (1 или 2)");
                int numList = getNumConsole(input, 1, 2);
                if (numList == 1) {
                    addToList(firstList, input);
                } else {
                    addToList(secondList, input);
                }
            }
            case merge -> {
                ListPt mergedList = new ListPt(0, null);
                if (firstList.next != null && secondList.next != null) {
                    merge(mergedList, firstList, secondList);
                    printList(mergedList, 0);
                    saveOrNot(input, mergedList);
                } else {
                    System.err.println(ERRORS[ErrCode.EMPTY_LISTS.ordinal()]);
                }

                System.out.println();
            }
            case close -> isClose = true;
        }
        return isClose;
    }

    public static void main(String[] args) {
        ListPt firstHead = new ListPt(0, null);
        ListPt secondHead = new ListPt(0, null);
        Scanner input = new Scanner(System.in);
        printInf(input);

        boolean isClose;
        do {
            printList(firstHead, 1);
            printList(secondHead, 2);
            printMenu();
            isClose = doFunction(firstHead, secondHead, input);
        } while (!isClose);
        input.close();
    }
}