package com.example.onlindedelivery.models;

import java.util.Date;

public class CartItemDetail {
    private String cartId;
    private String userId;
    private Date addedTime;

    public CartItemDetail() {
        this.addedTime = new Date(); // Auto-set time on creation
    }

    public String getCartId() {
        return cartId;
    }

    public void setCartId(String cartId) {
        this.cartId = cartId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Date getAddedTime() {
        return addedTime;
    }

    public void setAddedTime(Date addedTime) {
        this.addedTime = addedTime;
    }
}