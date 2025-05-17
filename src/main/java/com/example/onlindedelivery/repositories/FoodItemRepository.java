package com.example.onlindedelivery.repositories;

import com.example.onlindedelivery.models.FoodItem;
import org.springframework.stereotype.Repository;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class FoodItemRepository {

    private static final String FILE_PATH = "food_items.txt";

    public List<FoodItem> findAll() throws IOException {
        List<FoodItem> items = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 5) {
                    FoodItem item = new FoodItem();
                    item.setFoodItemId(parts[0]);
                    item.setName(parts[1]);
                    item.setDescription(parts[2]);
                    item.setPrice(Double.parseDouble(parts[3]));
                    item.setImage(parts[4]);
                    items.add(item);
                }
            }
        }
        return items;
    }

    public void save(FoodItem item) throws IOException {
        try (FileWriter fw = new FileWriter(FILE_PATH, true)) {
            fw.write(String.join(",", item.getFoodItemId(),
                    item.getName(),
                    item.getDescription(),
                    String.valueOf(item.getPrice()),
                    item.getImage()));
            fw.write("\n");
        }
    }

    public void update(FoodItem updatedItem) throws IOException {
        List<FoodItem> items = findAll();
        try (FileWriter fw = new FileWriter(FILE_PATH)) {
            for (FoodItem item : items) {
                if (item.getFoodItemId().equals(updatedItem.getFoodItemId())) {
                    writeItemToFile(fw, updatedItem);
                } else {
                    writeItemToFile(fw, item);
                }
            }
        }
    }

    public void deleteById(String id) throws IOException {
        List<FoodItem> items = findAll();
        try (FileWriter fw = new FileWriter(FILE_PATH)) {
            for (FoodItem item : items) {
                if (!item.getFoodItemId().equals(id)) {
                    writeItemToFile(fw, item);
                }
            }
        }
    }

    public FoodItem findById(String id) throws IOException {
        for (FoodItem item : findAll()) {
            if (item.getFoodItemId().equals(id)) {
                return item;
            }
        }
        return null;
    }

    private void writeItemToFile(FileWriter fw, FoodItem item) throws IOException {
        fw.write(String.join(",",
                item.getFoodItemId(),
                item.getName(),
                item.getDescription(),
                String.valueOf(item.getPrice()),
                item.getImage()));
        fw.write("\n");
    }
}