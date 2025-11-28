import java.util.*;

public class Main {

    public static void main(String[] args) {

        int[] sizes = {100, 1000, 5000, 10000, 20000};

        System.out.println("Лабораторная работа №6 — Вариант 0 (Сортировка пузырьком)");
        System.out.println("Структуры данных: ArrayList, LinkedList, ArrayDeque\n");

        System.out.printf("%-15s %-20s %-20s %-20s\n",
                "Размер", "ArrayList (мс)", "LinkedList (мс)", "ArrayDeque (мс)");

        for (int size : sizes) {

            long tArr = testArrayList(size);
            long tLink = testLinkedList(size);
            long tDeque = testArrayDeque(size);

            System.out.printf("%-15d %-20d %-20d %-20d\n",
                    size, tArr, tLink, tDeque);
        }

        System.out.println("\nАналитическая сложность Bubble Sort: O(N^2)");
        System.out.println("Эксперимент показывает квадратичный рост времени.");
    }


    // ---------- 1. Реализация пузырька над ArrayList ----------
    public static long testArrayList(int n) {
        ArrayList<Integer> list = generateArrayList(n);

        long start = System.currentTimeMillis();
        bubbleSortArrayList(list);
        long end = System.currentTimeMillis();

        return end - start;
    }

    public static void bubbleSortArrayList(ArrayList<Integer> list) {
        int n = list.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (list.get(j) > list.get(j + 1)) {
                    int temp = list.get(j);
                    list.set(j, list.get(j + 1));
                    list.set(j + 1, temp);
                }
            }
        }
    }


    // ---------- 2. Реализация пузырька над LinkedList ----------
    public static long testLinkedList(int n) {
        LinkedList<Integer> list = generateLinkedList(n);

        long start = System.currentTimeMillis();
        bubbleSortLinkedList(list);
        long end = System.currentTimeMillis();

        return end - start;
    }

    public static void bubbleSortLinkedList(LinkedList<Integer> list) {
        int n = list.size();
        ListIterator<Integer> it;

        for (int i = 0; i < n - 1; i++) {
            it = list.listIterator();
            int prev = it.next();

            for (int j = 0; j < n - i - 1; j++) {
                int curr = it.next();
                if (prev > curr) {
                    it.set(prev);
                    it.previous();
                    it.previous();
                    it.set(curr);
                    it.next();
                    prev = curr;
                } else {
                    prev = curr;
                }
            }
        }
    }


    // ---------- 3. Реализация для ArrayDeque ----------
    public static long testArrayDeque(int n) {
        ArrayDeque<Integer> dq = generateDeque(n);

        // BubbleSort требует массив → извлекаем
        Integer[] arr = dq.toArray(new Integer[0]);

        long start = System.currentTimeMillis();
        bubbleSortArray(arr);
        long end = System.currentTimeMillis();

        return end - start;
    }

    public static void bubbleSortArray(Integer[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    int t = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = t;
                }
            }
        }
    }


    // ---------- Генерация данных ----------
    public static ArrayList<Integer> generateArrayList(int n) {
        ArrayList<Integer> list = new ArrayList<>(n);
        Random r = new Random();
        for (int i = 0; i < n; i++) list.add(r.nextInt(1000000));
        return list;
    }

    public static LinkedList<Integer> generateLinkedList(int n) {
        LinkedList<Integer> list = new LinkedList<>();
        Random r = new Random();
        for (int i = 0; i < n; i++) list.add(r.nextInt(1000000));
        return list;
    }

    public static ArrayDeque<Integer> generateDeque(int n) {
        ArrayDeque<Integer> dq = new ArrayDeque<>();
        Random r = new Random();
        for (int i = 0; i < n; i++) dq.add(r.nextInt(1000000));
        return dq;
    }
}
