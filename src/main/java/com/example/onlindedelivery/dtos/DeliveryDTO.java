package com.example.onlindedelivery.dtos;

import java.util.Date;

public class DeliveryDTO {
    private String deliveryId;
    private String orderId;
    private String deliveryStatus;
    private Date estimatedDeliveryTime;
    private Date actualDeliveryTime;
    private String deliveryAddress;

    public String getDeliveryId() { return deliveryId; }
    public void setDeliveryId(String deliveryId) { this.deliveryId = deliveryId; }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getDeliveryStatus() { return deliveryStatus; }
    public void setDeliveryStatus(String deliveryStatus) { this.deliveryStatus = deliveryStatus; }

    public Date getEstimatedDeliveryTime() { return estimatedDeliveryTime; }
    public void setEstimatedDeliveryTime(Date estimatedDeliveryTime) { this.estimatedDeliveryTime = estimatedDeliveryTime; }

    public Date getActualDeliveryTime() { return actualDeliveryTime; }
    public void setActualDeliveryTime(Date actualDeliveryTime) { this.actualDeliveryTime = actualDeliveryTime; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }
}