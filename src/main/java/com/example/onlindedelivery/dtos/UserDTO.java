package com.example.onlindedelivery.dtos;

public class UserDTO {
    private String userId;
    private String name;
    private String email;
    private int age;
    private String gender;
    private String address;

    // Constructors
    public UserDTO() {}

    public UserDTO(String userId, String name, String email, int age, String gender, String address) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.age = age;
        this.gender = gender;
        this.address = address;
    }

    // Getters and Setters
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}