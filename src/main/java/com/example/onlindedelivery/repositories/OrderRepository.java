package com.example.onlindedelivery.repositories;

import com.example.onlindedelivery.models.Order;
import com.example.onlindedelivery.models.OrderedItem;
import org.springframework.stereotype.Repository;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Repository
public class OrderRepository {
    private static final String ORDER_FILE = "orders.txt";
    private static final String ITEMS_FILE = "order_items.txt";
    private static final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";

    // Ensure the files exist or create them if not
    private void ensureFilesExist() throws IOException {
        File orderFile = new File(ORDER_FILE);
        if (!orderFile.exists()) {
            orderFile.createNewFile();
        }

        File itemsFile = new File(ITEMS_FILE);
        if (!itemsFile.exists()) {
            itemsFile.createNewFile();
        }
    }

    // Save an order to the database
    public Order save(Order order) throws IOException {
        ensureFilesExist();
        
        // Generate a unique order ID if not provided
        if (order.getOrderId() == null || order.getOrderId().isEmpty()) {
            order.setOrderId(UUID.randomUUID().toString());
        }
        
        // Save order details
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(ORDER_FILE, true))) {
            SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT);
            String orderLine = String.format("%s,%s,%s,%.2f,%s,%s,%s\n",
                    order.getOrderId(),
                    order.getUserId(),
                    dateFormat.format(order.getOrderDate()),
                    order.getTotalPrice(),
                    order.getPaymentMethod(),
                    order.getAddress(),
                    order.getStatus());
            writer.write(orderLine);
        }
        
        // Save ordered items
        if (order.getOrderedItems() != null && !order.getOrderedItems().isEmpty()) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(ITEMS_FILE, true))) {
                for (OrderedItem item : order.getOrderedItems()) {
                    String itemLine = String.format("%s,%s,%d,%.2f\n",
                            order.getOrderId(),
                            item.getFoodItemId(),
                            item.getQuantity(),
                            item.getPrice());
                    writer.write(itemLine);
                }
            }
        }
        
        return order;
    }

    // Find an order by its ID
    public Optional<Order> findById(String orderId) throws IOException {
        ensureFilesExist();
        
        // Find the order
        Order order = null;
        try (BufferedReader reader = new BufferedReader(new FileReader(ORDER_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 7 && parts[0].equals(orderId)) {
                    order = parseOrderFromLine(parts);
                    break;
                }
            }
        }
        
        if (order == null) {
            return Optional.empty();
        }
        
        // Load ordered items
        loadOrderItems(order);
        
        return Optional.of(order);
    }

    // Find all orders
    public List<Order> findAll() throws IOException {
        ensureFilesExist();
        
        // Load all orders
        Map<String, Order> orderMap = new HashMap<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(ORDER_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 7) {
                    Order order = parseOrderFromLine(parts);
                    orderMap.put(order.getOrderId(), order);
                }
            }
        }
        
        // Load ordered items for all orders
        try (BufferedReader reader = new BufferedReader(new FileReader(ITEMS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    String orderId = parts[0];
                    Order order = orderMap.get(orderId);
                    
                    if (order != null) {
                        if (order.getOrderedItems() == null) {
                            order.setOrderedItems(new ArrayList<>());
                        }
                        
                        OrderedItem item = new OrderedItem();
                        item.setFoodItemId(parts[1]);
                        item.setQuantity(Integer.parseInt(parts[2]));
                        item.setPrice(Double.parseDouble(parts[3]));
                        order.getOrderedItems().add(item);
                    }
                }
            }
        }
        
        return new ArrayList<>(orderMap.values());
    }

    // Find orders by user ID
    public List<Order> findByUserId(String userId) throws IOException {
        List<Order> allOrders = findAll();
        List<Order> userOrders = new ArrayList<>();
        
        for (Order order : allOrders) {
            if (order.getUserId().equals(userId)) {
                userOrders.add(order);
            }
        }
        
        return userOrders;
    }

    // Update an existing order
    public Optional<Order> update(Order order) throws IOException {
        if (order.getOrderId() == null || order.getOrderId().isEmpty()) {
            return Optional.empty();
        }
        
        // Delete the existing order
        delete(order.getOrderId());
        
        // Save the updated order
        save(order);
        
        return Optional.of(order);
    }

    // Delete an order by ID
    public boolean delete(String orderId) throws IOException {
        ensureFilesExist();
        
        // Delete from orders file
        boolean orderFound = false;
        List<String> remainingOrders = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(ORDER_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length > 0 && !parts[0].equals(orderId)) {
                    remainingOrders.add(line);
                } else {
                    orderFound = true;
                }
            }
        }
        
        if (orderFound) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(ORDER_FILE))) {
                for (String line : remainingOrders) {
                    writer.write(line);
                    writer.newLine();
                }
            }
        }
        
        // Delete from items file
        List<String> remainingItems = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(ITEMS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length > 0 && !parts[0].equals(orderId)) {
                    remainingItems.add(line);
                }
            }
        }
        
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(ITEMS_FILE))) {
            for (String line : remainingItems) {
                writer.write(line);
                writer.newLine();
            }
        }
        
        return orderFound;
    }

    // Helper method to parse an order from a line in the orders file
    private Order parseOrderFromLine(String[] parts) throws IOException {
        Order order = new Order();
        order.setOrderId(parts[0]);
        order.setUserId(parts[1]);
        
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT);
            order.setOrderDate(dateFormat.parse(parts[2]));
        } catch (ParseException e) {
            order.setOrderDate(new Date()); // Default to current date if parsing fails
        }
        
        order.setTotalPrice(Double.parseDouble(parts[3]));
        order.setPaymentMethod(parts[4]);
        order.setAddress(parts[5]);
        order.setStatus(parts[6]);
        order.setOrderedItems(new ArrayList<>());
        
        return order;
    }

    // Helper method to load ordered items for a specific order
    private void loadOrderItems(Order order) throws IOException {
        List<OrderedItem> items = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(new FileReader(ITEMS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4 && parts[0].equals(order.getOrderId())) {
                    OrderedItem item = new OrderedItem();
                    item.setFoodItemId(parts[1]);
                    item.setQuantity(Integer.parseInt(parts[2]));
                    item.setPrice(Double.parseDouble(parts[3]));
                    items.add(item);
                }
            }
        }
        
        order.setOrderedItems(items);
    }
}
