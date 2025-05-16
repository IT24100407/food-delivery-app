package com.example.onlindedelivery.utils;

import com.example.onlindedelivery.models.Order;
import org.springframework.context.annotation.Bean;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

public class OrderQueue {
    private final Queue<Order> orderQueue = new LinkedList<>();

    // Add an order to queue
    public void enqueueOrder(Order order) {
        orderQueue.add(order);
    }

    // Process and remove next order
    public Order dequeueOrder() {
        return orderQueue.poll();
    }

    // Peek at next order without removing
    public Order peekNextOrder() {
        return orderQueue.peek();
    }

    // Check if queue is empty
    public boolean isQueueEmpty() {
        return orderQueue.isEmpty();
    }

    // Get all queued orders as a list
    public List<Order> getAllQueuedOrders() {
        return new ArrayList<>(orderQueue);
    }
}
