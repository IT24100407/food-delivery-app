package com.example.onlindedelivery.models;

import java.util.Date;

public class Delivery extends DeliveryInfo {
    private String deliveryStatus; // e.g., Pending, In Transit, Delivered
    private Date actualDeliveryTime;
    private String deliveryAddress;

    public Delivery() {}

    public Delivery(String deliveryId, String orderId,
                    Date estimatedDeliveryTime, String deliveryStatus,
                    Date actualDeliveryTime, String deliveryAddress) {
        super.setDeliveryId(deliveryId);
        super.setOrderId(orderId);
        super.setEstimatedDeliveryTime(estimatedDeliveryTime);
        this.deliveryStatus = deliveryStatus;
        this.actualDeliveryTime = actualDeliveryTime;
        this.deliveryAddress = deliveryAddress;
    }

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public Date getActualDeliveryTime() {
        return actualDeliveryTime;
    }

    public void setActualDeliveryTime(Date actualDeliveryTime) {
        this.actualDeliveryTime = actualDeliveryTime;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }
}