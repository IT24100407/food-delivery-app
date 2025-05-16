package com.example.onlindedelivery.models;

import java.util.Date;
import java.util.List;

public class Order extends OrderDetail {
    private double totalPrice;
    private String paymentMethod; // optional
    private List<OrderedItem> orderedItems;

    public Order() {}
    private String address;

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
    private String status = "Pending"; // Default

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Order(String orderId, String userId, double totalPrice,
                 String paymentMethod, String address, List<OrderedItem> orderedItems) {
        super.setOrderId(orderId);
        super.setUserId(userId);
        this.totalPrice = totalPrice;
        this.paymentMethod = paymentMethod;
        this.address = address;
        this.orderedItems = orderedItems;
        super.setOrderDate(new Date());
    }


    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        if (totalPrice < 0) throw new IllegalArgumentException("Total price cannot be negative");
        this.totalPrice = totalPrice;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public List<OrderedItem> getOrderedItems() {
        return orderedItems;
    }

    public void setOrderedItems(List<OrderedItem> orderedItems) {
        this.orderedItems = orderedItems;
    }
}
