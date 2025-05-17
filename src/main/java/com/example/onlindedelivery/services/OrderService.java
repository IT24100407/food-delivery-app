package com.example.onlindedelivery.services;

import com.example.onlindedelivery.models.Order;
import com.example.onlindedelivery.models.OrderedItem;
import com.example.onlindedelivery.repositories.OrderRepository;
import com.example.onlindedelivery.utils.OrderQueue;
import com.oracle.wls.shaded.org.apache.xpath.operations.Or;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;


@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;
    

    private OrderQueue orderQueue = new OrderQueue();
    
    // Create a new order
    public Order createOrder(Order order) throws Exception {
        // Generate a unique ID if not provided
        if (order.getOrderId() == null || order.getOrderId().isEmpty()) {
            order.setOrderId(UUID.randomUUID().toString());
        }
        
        // Set default status if not provided
        if (order.getStatus() == null || order.getStatus().isEmpty()) {
            order.setStatus("Pending");
        }
        
        // Save the order
        Order savedOrder = orderRepository.save(order);
        
        // Add to processing queue
        orderQueue.enqueueOrder(savedOrder);
        
        return savedOrder;
    }
    
    // Get order by ID
    public Optional<Order> getOrderById(String orderId) throws Exception {
        return orderRepository.findById(orderId);
    }
    
    // Get all orders
    public List<Order> getAllOrders() throws Exception {
        return orderRepository.findAll();
    }
    
    // Get orders by user ID
    public List<Order> getOrdersByUserId(String userId) throws Exception {
        return orderRepository.findByUserId(userId);
    }
    
    // Update order status
    public Optional<Order> updateOrderStatus(String orderId, String status) throws Exception {
        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            order.setStatus(status);
            return orderRepository.update(order);
        }
        return Optional.empty();
    }
    
    // Update entire order
    public Optional<Order> updateOrder(Order updatedOrder) throws Exception {
        return orderRepository.update(updatedOrder);
    }
    
    // Delete an order
    public boolean deleteOrder(String orderId) throws Exception {
        return orderRepository.delete(orderId);
    }
    
    // Calculate total price for an order based on ordered items
    public double calculateOrderTotal(List<OrderedItem> items) {
        if (items == null || items.isEmpty()) {
            return 0.0;
        }
        
        return items.stream()
                .mapToDouble(item -> item.getPrice() * item.getQuantity())
                .sum();
    }
    
    // Get next order from queue for processing
    public Order getNextOrderForProcessing() {
        return orderQueue.dequeueOrder();
    }
    
    // Get all orders in queue
    public List<Order> getQueuedOrders() {
        return orderQueue.getAllQueuedOrders();
    }
}