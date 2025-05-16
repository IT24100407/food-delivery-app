package com.example.onlindedelivery.models;

public class CartItem extends CartItemDetail {
    private String foodItemId;
    private int quantity;

    public CartItem() {}

    public CartItem(String cartId, String userId, String foodItemId, int quantity) {
        super.setCartId(cartId);
        super.setUserId(userId);
        this.foodItemId = foodItemId;
        this.quantity = quantity;
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

    public void setQuantity(int quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than zero.");
        }
        this.quantity = quantity;
    }
}