package com.example.onlindedelivery.services;

import com.example.onlindedelivery.dtos.UserDTO;
import com.example.onlindedelivery.models.User;
import com.example.onlindedelivery.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public Optional<UserDTO> login(String email, String password) throws IOException {
        User user = userRepository.findByEmail(email);
        if (user != null && user.getPassword().equals(password)) {
            return Optional.of(toDTO(user));
        }
        return Optional.empty();
    }

    public UserDTO getUserById(String id) throws IOException {
        User user = userRepository.findById(id);
        if (user == null) throw new RuntimeException("User not found");
        return toDTO(user);
    }

    public List<UserDTO> getAllUsers() throws IOException {
        return userRepository.findAll().stream()
                .map(this::toDTO).toList();
    }

    public void createUser(User user) throws IOException {
        userRepository.save(user);
    }

    public void updateUser(User updatedUser) throws IOException {
        userRepository.update(updatedUser);
    }

    public void deleteUser(String userId) throws IOException {
        userRepository.deleteById(userId);
    }

    private UserDTO toDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setUserId(user.getUserId());
        dto.setName(user.getName());
        dto.setEmail(user.getEmail());
        dto.setAge(user.getAge());
        dto.setGender(user.getGender());
        dto.setAddress(user.getAddress());
        return dto;
    }
}