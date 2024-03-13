import java.util.Scanner;

class HeadPt {
    Node root;
    HeadPt (Node root) {
        this.root = root;
    }
}
class Node {
    int data;

    Node leftPt;
    Node rightPt;
    Node (int data) {
        this.data = data;
        this.leftPt = null;
        this.rightPt = null;
    }
}

public class Main {

    static HeadPt head;

    enum ErrCode {
        SUCCESS,
        INCORRECT_DATA,
        TREE_NOT_EXIST,
        SUCH_ELEMENT_ALREADY_EXIST
    }

    static final String[] ERRORS = {"Удача",
            "Данные некорректные или число слишком большое (должно быть от %d до %d)\n",
            "Сначала стоит создать дерево)",
            "Такой элемент уже существует"};

    enum Choice {
        createTree("Создать новое дерево"),
        addElem("Добавить элемент"),
        print("Визуализировать дерево"),
        close("Закрыть");

        private final String inf;
        Choice (String infLine) {
            this.inf = infLine;
        }
        private String getInf(){return this.ordinal() + ") " + this.inf;}
    }

    static final int MIN_NODE = -99999,
                     MAX_NODE = 99999;
    static final char ROOT_CHAR = '+',
                      LEFT_CHAR = 'L',
                      RIGHT_CHAR = 'R';

    static final String INFORMATION_TEXT = """
                        Инструкция:
                            1) Элементы дерева должны быть от -99999 до 99999
                            2) Элементы не могут повторяться
                        """,
                        ATTENTION_TEXT = """
                        Внимание! Старое дерево удалится, вы уверены?
                            1) Да
                            2) Нет
                        """;

    static HeadPt createTree(int elem) {
        Node firstNode = new Node(elem);
        return new HeadPt(firstNode);
    }

    static boolean addElem(Node head, int elem) {
        boolean isAdded = true;
        if (elem > head.data) {
            if (head.rightPt != null)
                isAdded = addElem(head.rightPt, elem);
            else
                head.rightPt = new Node(elem);
        } else if (elem < head.data) {
            if (head.leftPt != null)
                isAdded = addElem(head.leftPt, elem);
            else
                head.leftPt = new Node(elem);
        } else {
            isAdded = false;
        }
        return isAdded;
    }

    static void printTree(Node node, int layer, char side) {
        if (node.rightPt != null)
            printTree(node.rightPt, layer + 1, RIGHT_CHAR);


        for (int i = 0; i < layer; i++)
            System.out.print("   ");
        System.out.println("(" + side + ")" + node.data);

        if (node.leftPt != null)
            printTree(node.leftPt, layer + 1, LEFT_CHAR);
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

    static boolean doFunction(Scanner input) {
        Choice choice = getChoice(input);
        boolean isClose = false;
        switch (choice) {
            case createTree -> {
                System.out.println(ATTENTION_TEXT);
                int localChoice = getNumConsole(input, 1, 2);
                if (localChoice == 1) {
                    System.out.print("Введите корень дерева: ");
                    int root = getNumConsole(input, MIN_NODE, MAX_NODE);
                    head = createTree(root);
                }
            }
            case addElem -> {
                if (head != null) {
                    System.out.println("Введите новый элемент: ");
                    int newElem = getNumConsole(input, MIN_NODE, MAX_NODE);
                    if (!addElem(head.root, newElem)) {
                        System.err.println(ERRORS[ErrCode.SUCH_ELEMENT_ALREADY_EXIST.ordinal()]);
                    }
                }
                else
                    System.err.println(ERRORS[ErrCode.TREE_NOT_EXIST.ordinal()]);
            }
            case print -> {
                if (head != null)
                    printTree(head.root, 0, ROOT_CHAR);
                else
                    System.err.println(ERRORS[ErrCode.TREE_NOT_EXIST.ordinal()]);
                System.out.println();
            }
            case close -> isClose = true;
        }
        return isClose;
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        printInf(input);

        boolean isClose;
        do {
            printMenu();
            isClose = doFunction(input);
        } while (!isClose);
        input.close();
    }
}