package com.example.onlindedelivery.utils;

import com.example.onlindedelivery.models.FoodItem;

import java.util.List;

public class FoodItemQuickSort {

    public static void sortFoodItemsByPrice(List<FoodItem> items) {
        if (items == null || items.size() <= 1) return;
        quickSort(items, 0, items.size() - 1);
    }

    private static void quickSort(List<FoodItem> items, int low, int high) {
        if (low < high) {
            int pivotIndex = partition(items, low, high);
            quickSort(items, low, pivotIndex - 1);
            quickSort(items, pivotIndex + 1, high);
        }
    }

    private static int partition(List<FoodItem> items, int low, int high) {
        double pivot = items.get(high).getPrice();
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (items.get(j).getPrice() <= pivot) {
                i++;
                swap(items, i, j);
            }
        }

        swap(items, i + 1, high);
        return i + 1;
    }

    private static void swap(List<FoodItem> items, int i, int j) {
        FoodItem temp = items.get(i);
        items.set(i, items.get(j));
        items.set(j, temp);
    }
}