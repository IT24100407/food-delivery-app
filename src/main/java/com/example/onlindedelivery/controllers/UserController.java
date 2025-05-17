package com.example.onlindedelivery.controllers;

import com.example.onlindedelivery.dtos.UserDTO;
import com.example.onlindedelivery.models.User;
import com.example.onlindedelivery.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    // LOGIN
    @PostMapping("/login")
    public UserDTO login(@RequestParam String email, @RequestParam String password) throws Exception {
        return userService.login(email, password)
                .orElseThrow(() -> new RuntimeException("Invalid credentials"));
    }

    // GET ALL USERS
    @GetMapping
    public List<UserDTO> getAllUsers() throws Exception {
        return userService.getAllUsers();
    }

    // GET USER BY ID
    @GetMapping("/{userId}")
    public UserDTO getUserById(@PathVariable String userId) throws Exception {
        return userService.getUserById(userId);
    }

    // CREATE USER
    @PostMapping
    public void createUser(@RequestBody User user) throws Exception {
        userService.createUser(user);
    }

    // UPDATE USER
    @PutMapping("/{userId}")
    public void updateUser(@PathVariable String userId, @RequestBody User updatedUser) throws Exception {
        updatedUser.setUserId(userId); // ensure ID matches path
        userService.updateUser(updatedUser);
    }

    // DELETE USER
    @DeleteMapping("/{userId}")
    public void deleteUser(@PathVariable String userId) throws Exception {
        userService.deleteUser(userId);
    }
}