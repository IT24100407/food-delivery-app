package com.example.onlindedelivery.repositories;

import com.example.onlindedelivery.models.Delivery;
import org.springframework.stereotype.Repository;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

@Repository
public class DeliveryRepository {

    private static final String FILE_PATH = "deliveries.txt";
    private static final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";

    public List<Delivery> findAll() throws IOException {
        List<Delivery> deliveries = new ArrayList<>();
        File file = new File(FILE_PATH);
        
        // Create file if it doesn't exist
        if (!file.exists()) {
            file.createNewFile();
            return deliveries;
        }
        
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 6) {
                    Delivery d = new Delivery();
                    d.setDeliveryId(parts[0]);
                    d.setOrderId(parts[1]);
                    d.setDeliveryStatus(parts[2]);
                    
                    // Parse dates safely
                    if (!parts[3].isEmpty()) {
                        try {
                            d.setEstimatedDeliveryTime(new SimpleDateFormat(DATE_FORMAT).parse(parts[3]));
                        } catch (Exception e) {
                            System.err.println("Error parsing estimated delivery time: " + e.getMessage());
                        }
                    }
                    
                    if (!parts[4].isEmpty()) {
                        try {
                            d.setActualDeliveryTime(new SimpleDateFormat(DATE_FORMAT).parse(parts[4]));
                        } catch (Exception e) {
                            System.err.println("Error parsing actual delivery time: " + e.getMessage());
                        }
                    }
                    
                    d.setDeliveryAddress(parts[5]);
                    deliveries.add(d);
                }
            }
        } catch (FileNotFoundException e) {
            // File doesn't exist yet, return empty list
            return deliveries;
        }
        
        return deliveries;
    }

    public Delivery findById(String id) throws IOException {
        for (Delivery d : findAll()) {
            if (d.getDeliveryId().equals(id)) {
                return d;
            }
        }
        return null;
    }

    public void save(Delivery delivery) throws IOException {
        // Ensure file exists
        File file = new File(FILE_PATH);
        if (!file.exists()) {
            file.createNewFile();
        }
        
        try (FileWriter fw = new FileWriter(FILE_PATH, true)) {
            fw.write(String.join(",",
                    delivery.getDeliveryId(),
                    delivery.getOrderId(),
                    delivery.getDeliveryStatus(),
                    formatDate(delivery.getEstimatedDeliveryTime()),
                    formatDate(delivery.getActualDeliveryTime()),
                    delivery.getDeliveryAddress()));
            fw.write("\n");
        }
    }

    public void update(Delivery updated) throws IOException {
        List<Delivery> list = findAll();
        File file = new File(FILE_PATH);
        
        try (FileWriter fw = new FileWriter(file)) {
            for (Delivery d : list) {
                if (d.getDeliveryId().equals(updated.getDeliveryId())) {
                    writeToFile(fw, updated);
                } else {
                    writeToFile(fw, d);
                }
            }
        }
    }

    public void deleteById(String id) throws IOException {
        List<Delivery> list = findAll();
        File file = new File(FILE_PATH);
        
        try (FileWriter fw = new FileWriter(file)) {
            for (Delivery d : list) {
                if (!d.getDeliveryId().equals(id)) {
                    writeToFile(fw, d);
                }
            }
        }
    }

    private void writeToFile(FileWriter fw, Delivery d) throws IOException {
        fw.write(String.join(",",
                d.getDeliveryId(),
                d.getOrderId(),
                d.getDeliveryStatus(),
                formatDate(d.getEstimatedDeliveryTime()),
                formatDate(d.getActualDeliveryTime()),
                d.getDeliveryAddress()));
        fw.write("\n");
    }

    private String formatDate(Date date) {
        return date != null ? new SimpleDateFormat(DATE_FORMAT).format(date) : "";
    }
}