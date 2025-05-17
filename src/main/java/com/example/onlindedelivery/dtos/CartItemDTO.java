package com.example.onlindedelivery.dtos;

import java.util.Date;

public class CartItemDTO {
    private String cartId;
    private String userId;
    private String foodItemId;
    private int quantity;
    private Date addedTime;

    public String getCartId() { return cartId; }
    public void setCartId(String cartId) { this.cartId = cartId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getFoodItemId() { return foodItemId; }
    public void setFoodItemId(String foodItemId) { this.foodItemId = foodItemId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Date getAddedTime() { return addedTime; }
    public void setAddedTime(Date addedTime) { this.addedTime = addedTime; }
}