package com.example.onlindedelivery.views;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class AdminViewController {

    // Serve index.jsp at root URL
    @GetMapping("/")
    public String showIndex() {
        return "index";
    }
    @GetMapping("/admin")
    public String showAdmin() {
        return "admin";
    }
    @GetMapping("/feedbacks")
    public String showFeedbacks() {
        return "feedbacks/all";
    }

    @GetMapping("/users")
    public String showUsers() {
        return "users/list";
    }

    @GetMapping("/items")
    public String showItems() {
        return "items/list";
    }

    @GetMapping("/orders")
    public String showOrders() {
        return "orders/list";
    }

    @GetMapping("/create-item")
    public String createItem() {
        return "items/create";
    }

    @GetMapping("/login")
    public String login() {
        return "users/login";
    }

    @GetMapping("/register")
    public String register() {
        return "users/create";
    }

    @GetMapping("/profile")
    public String profile() {
        return "users/profile";
    }

    @GetMapping("/item/{id}")
    public String item(@PathVariable String id) {
        return "users/profile";
    }

    @GetMapping("/cart")
    public String cart() {
        return "cart/list";
    }
    @GetMapping("/place-order")
    public String placeOrder() {
        return "orders/create";
    }

    @GetMapping("/my-orders")
    public String myOrders() {
        return "orders/my-orders";
    }

    @GetMapping("/create-delivery")
    public String createDeliver() {
        return "deliveries/create";
    }

    @GetMapping("/edit-delivery/{id}")
    public String editDelivery(@PathVariable String id) {
        return "deliveries/edit";
    }
    @GetMapping("/deliveries")
    public String allDeliveries() {
        return "deliveries/list";
    }

}