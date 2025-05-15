package com.example.onlindedelivery.controllers;

import com.example.onlindedelivery.models.Order;
import com.example.onlindedelivery.models.OrderedItem;
import com.example.onlindedelivery.services.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    // Get all orders
    @GetMapping
    public ResponseEntity<List<Order>> getAll() {
        try {
            List<Order> orders = orderService.getAllOrders();
            return ResponseEntity.ok(orders);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Get order by ID
    @GetMapping("/{id}")
    public ResponseEntity<Order> getById(@PathVariable String id) {
        try {
            Optional<Order> order = orderService.getOrderById(id);
            return order.map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Get orders by user ID
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Order>> getByUserId(@PathVariable String userId) {
        try {
            List<Order> orders = orderService.getOrdersByUserId(userId);
            return ResponseEntity.ok(orders);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Create a new order
    @PostMapping
    public ResponseEntity<Order> create(@RequestBody Order order) {
        try {
            // Calculate total price if not provided
            if (order.getTotalPrice() == 0 && order.getOrderedItems() != null) {
                double total = orderService.calculateOrderTotal(order.getOrderedItems());
                order.setTotalPrice(total);
            }
            
            Order createdOrder = orderService.createOrder(order);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdOrder);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Update an order
    @PutMapping("/{id}")
    public ResponseEntity<Order> update(@PathVariable String id, @RequestBody Order order) {
        try {
            // Ensure the ID in the path matches the order
            order.setOrderId(id);
            
            // Calculate total price if needed
            if (order.getTotalPrice() == 0 && order.getOrderedItems() != null) {
                double total = orderService.calculateOrderTotal(order.getOrderedItems());
                order.setTotalPrice(total);
            }
            
            Optional<Order> updatedOrder = orderService.updateOrder(order);
            return updatedOrder.map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Update order status
    @PatchMapping("/{id}/status")
    public ResponseEntity<Order> updateStatus(@PathVariable String id, @RequestBody Map<String, String> statusUpdate) {
        try {
            String newStatus = statusUpdate.get("status");
            if (newStatus == null || newStatus.isEmpty()) {
                return ResponseEntity.badRequest().build();
            }
            
            Optional<Order> updatedOrder = orderService.updateOrderStatus(id, newStatus);
            return updatedOrder.map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Delete an order
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        try {
            boolean deleted = orderService.deleteOrder(id);
            if (deleted) {
                return ResponseEntity.noContent().build();
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Get all orders in the processing queue
    @GetMapping("/queue")
    public ResponseEntity<List<Order>> getQueuedOrders() {
        try {
            List<Order> queuedOrders = orderService.getQueuedOrders();
            return ResponseEntity.ok(queuedOrders);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Process the next order in the queue
    @PostMapping("/process-next")
    public ResponseEntity<Order> processNextOrder() {
        try {
            Order nextOrder = orderService.getNextOrderForProcessing();
            if (nextOrder != null) {
                return ResponseEntity.ok(nextOrder);
            } else {
                return ResponseEntity.noContent().build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}