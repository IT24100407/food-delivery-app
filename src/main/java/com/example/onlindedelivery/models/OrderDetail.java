package com.example.onlindedelivery.models;

import java.util.Date;

public class OrderDetail {
    private String orderId;
    private String userId;
   

    public OrderDetail() {
        this.orderDate = new Date(); // auto-set date
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }
}
