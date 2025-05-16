package com.example.onlindedelivery.models;

public class FoodItem {
    private String foodItemId;
    private String name;
    private String description;
    private double price;
    private String image;

    public FoodItem() {}
    @Override
    public FoodItem clone() {
        return new FoodItem(this.foodItemId, this.name, this.description, this.price, this.image);
    }
    public FoodItem(String foodItemId, String name, String description, double price, String image) {
        this.foodItemId = foodItemId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.image = image;
    }

    // Getters and Setters
    public String getFoodItemId() { return foodItemId; }
    public void setFoodItemId(String foodItemId) { this.foodItemId = foodItemId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
}