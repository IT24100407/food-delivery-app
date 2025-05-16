package com.example.onlindedelivery.models;

public class OrderedItem {
    private String foodItemId;
    private int quantity;
    private double price;

    public OrderedItem() {}

    public OrderedItem(String foodItemId, int quantity, double price) {
        this.foodItemId = foodItemId;
        this.quantity = quantity;
        this.price = price;
    }

    public String getFoodItemId() {
        return foodItemId;
    }

    public void setFoodItemId(String foodItemId) {
        this.foodItemId = foodItemId;
    }

    public int getQuantity() {
        return quantity;
    }

