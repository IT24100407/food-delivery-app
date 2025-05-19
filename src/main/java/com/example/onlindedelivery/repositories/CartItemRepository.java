package com.example.onlindedelivery.repositories;

import com.example.onlindedelivery.models.CartItem;
import org.springframework.stereotype.Repository;  

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

@Repository  
public class CartItemRepository {

    private static final String FILE_PATH = "cart_items.txt";
    private static final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";

    public List<CartItem> findAll() throws IOException {
        List<CartItem> items = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 5) {
                    CartItem item = new CartItem();
                    item.setCartId(parts[0]);
                    item.setUserId(parts[1]);
                    item.setFoodItemId(parts[2]);
                    item.setQuantity(Integer.parseInt(parts[3]));
                    try {
                        item.getAddedTime(); // inherited field
                    } catch (Exception e) {
                        // ignored
                    }
                    return items;
                }
            }
        }
        return items;  
    }

    public void save(CartItem item) throws IOException {
        try (FileWriter fw = new FileWriter(FILE_PATH, true)) {
            fw.write(String.join(",",
                    item.getCartId(),
                    item.getUserId(),
                    item.getFoodItemId(),
                    String.valueOf(item.getQuantity()),
                    new SimpleDateFormat(DATE_FORMAT).format(item.getAddedTime())));
            fw.write("\n");
        }
    }

    public void update(CartItem updatedItem) throws IOException {
        List<CartItem> items = findAll();
        try (FileWriter fw = new FileWriter(FILE_PATH)) {
            for (CartItem item : items) {
                if (item.getCartId().equals(updatedItem.getCartId())) {
                    writeToFile(fw, updatedItem);
                } else {
                    writeToFile(fw, item);
                }
            }
        }
    }

    public void deleteById(String id) throws IOException {
        List<CartItem> items = findAll();
        try (FileWriter fw = new FileWriter(FILE_PATH)) {
            for (CartItem item : items) {
                if (!item.getCartId().equals(id)) {
                    writeToFile(fw, item);
                }
            }
        }
    }

    public CartItem findById(String id) throws IOException {
        for (CartItem item : findAll()) {
            if (item.getCartId().equals(id)) {
                return item;
            }
        }
        return null;
    }

    public List<CartItem> findByUserId(String userId) throws IOException {
        List<CartItem> result = new ArrayList<>();
        for (CartItem item : findAll()) {
            if (item.getUserId().equals(userId)) {
                result.add(item);
            }
        }
        return result;
    }

    private void writeToFile(FileWriter fw, CartItem item) throws IOException {
        fw.write(String.join(",",
                item.getCartId(),
                item.getUserId(),
                item.getFoodItemId(),
                String.valueOf(item.getQuantity()),
                new SimpleDateFormat(DATE_FORMAT).format(item.getAddedTime())));
        fw.write("\n");
    }
}
