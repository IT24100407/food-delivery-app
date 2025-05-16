package com.example.onlindedelivery.models;

import java.util.Date;

public class Review {
    // Encapsulated fields
    private String reviewId;
    private String userId;
    private String foodItemId;
    private String reviewText;
    private int rating; // 1 to 5
    private Date createdAt;

    // Constructors
    public Review() {
        this.createdAt = new Date(); // auto set date on creation
    }

    public Review(String reviewId, String userId, String foodItemId, String reviewText, int rating) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.foodItemId = foodItemId;
        this.reviewText = reviewText;
        this.rating = rating;
        this.createdAt = new Date();
    }

    // Getters and Setters
    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getFoodItemId() {
        return foodItemId;
    }

    public void setFoodItemId(String foodItemId) {
        this.foodItemId = foodItemId;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        this.rating = rating;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}