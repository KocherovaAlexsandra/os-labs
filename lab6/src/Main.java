import java.util.*;

public class Main {

    public static void main(String[] args) {

        int[] sizes = {100, 1000, 5000, 10000};   // размеры данных
        Random rnd = new Random();

        for (int n : sizes) {
            System.out.println("\n=== Размер: " + n + " ===");

            int[] base = generateArray(n, rnd);

            // ArrayList
            ArrayList<Integer> al = toArrayList(base);
            long t1 = bubbleSortArrayList(al);
            System.out.println("ArrayList:  " + t1 + " ms");

            // LinkedList (через массив)
            LinkedList<Integer> ll = toLinkedList(base);
            long t2 = bubbleSortLinkedList(ll);
            System.out.println("LinkedList: " + t2 + " ms");

            // ArrayDeque (через массив)
            ArrayDeque<Integer> dq = toArrayDeque(base);
            long t3 = bubbleSortArrayDeque(dq);
            System.out.println("ArrayDeque: " + t3 + " ms");
        }
    }

    // ===== Генерация исходного массива =====
    static int[] generateArray(int n, Random rnd) {
        int[] a = new int[n];
        for (int i = 0; i < n; i++) a[i] = rnd.nextInt(1000000);
        return a;
    }

    // ===== Преобразования =====
    static ArrayList<Integer> toArrayList(int[] a) {
        ArrayList<Integer> list = new ArrayList<>(a.length);
        for (int v : a) list.add(v);
        return list;
    }

    static LinkedList<Integer> toLinkedList(int[] a) {
        LinkedList<Integer> list = new LinkedList<>();
        for (int v : a) list.add(v);
        return list;
    }

    static ArrayDeque<Integer> toArrayDeque(int[] a) {
        ArrayDeque<Integer> dq = new ArrayDeque<>(a.length);
        for (int v : a) dq.add(v);
        return dq;
    }

    // ===== Реализации пузырьковой сортировки =====
    static long bubbleSortArrayList(ArrayList<Integer> list) {
        long start = System.currentTimeMillis();
        int n = list.size();

        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - 1 - i; j++) {
                if (list.get(j) > list.get(j + 1)) {
                    int tmp = list.get(j);
                    list.set(j, list.get(j + 1));
                    list.set(j + 1, tmp);
                }
            }
        }

        return System.currentTimeMillis() - start;
    }

    static long bubbleSortLinkedList(LinkedList<Integer> list) {
        long start = System.currentTimeMillis();

        int n = list.size();
        int[] a = new int[n];
        int i = 0;
        for (int v : list) a[i++] = v;

        bubbleSortArray(a);

        list.clear();
        for (int v : a) list.add(v);

        return System.currentTimeMillis() - start;
    }

    static long bubbleSortArrayDeque(ArrayDeque<Integer> dq) {
        long start = System.currentTimeMillis();

        int n = dq.size();
        int[] a = new int[n];
        int i = 0;
        for (int v : dq) a[i++] = v;

        bubbleSortArray(a);

        dq.clear();
        for (int v : a) dq.add(v);

        return System.currentTimeMillis() - start;
    }

    // ===== Пузырёк для массива =====
    static void bubbleSortArray(int[] a) {
        int n = a.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - 1 - i; j++) {
                if (a[j] > a[j + 1]) {
                    int t = a[j];
                    a[j] = a[j + 1];
                    a[j + 1] = t;
                }
            }
        }
    }
}
