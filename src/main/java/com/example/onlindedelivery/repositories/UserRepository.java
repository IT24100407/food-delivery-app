package com.example.onlindedelivery.repositories;

import com.example.onlindedelivery.models.User;
import org.springframework.stereotype.Repository;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class UserRepository {

    private static final String FILE_PATH = "users.txt";

    public List<User> findAll() throws IOException {
        List<User> users = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 7) {
                    User user = new User();
                    user.setUserId(parts[0]);
                    user.setName(parts[1]);
                    user.setEmail(parts[2]);
                    user.setPassword(parts[3]);
                    user.setAge(Integer.parseInt(parts[4]));
                    user.setGender(parts[5]);
                    user.setAddress(parts[6]);
                    users.add(user);
                }
            }
        }
        return users;
    }

    public void save(User user) throws IOException {
        try (FileWriter fw = new FileWriter(FILE_PATH, true)) {
            fw.write(String.join(",", user.getUserId(),
                    user.getName(),
                    user.getEmail(),
                    user.getPassword(),
                    String.valueOf(user.getAge()),
                    user.getGender(),
                    user.getAddress()));
            fw.write("\n");
        }
    }

    public void update(User updatedUser) throws IOException {
        List<User> users = findAll();
        try (FileWriter fw = new FileWriter(FILE_PATH)) {
            for (User user : users) {
                if (user.getUserId().equals(updatedUser.getUserId())) {
                    fw.write(String.join(",", updatedUser.getUserId(),
                            updatedUser.getName(),
                            updatedUser.getEmail(),
                            updatedUser.getPassword(),
                            String.valueOf(updatedUser.getAge()),
                            updatedUser.getGender(),
                            updatedUser.getAddress()));
                } else {
                    fw.write(String.join(",", user.getUserId(),
                            user.getName(),
                            user.getEmail(),
                            user.getPassword(),
                            String.valueOf(user.getAge()),
                            user.getGender(),
                            user.getAddress()));
                }
                fw.write("\n");
            }
        }
    }

    public void deleteById(String userId) throws IOException {
        List<User> users = findAll();
        try (FileWriter fw = new FileWriter(FILE_PATH)) {
            for (User user : users) {
                if (!user.getUserId().equals(userId)) {
                    fw.write(String.join(",", user.getUserId(),
                            user.getName(),
                            user.getEmail(),
                            user.getPassword(),
                            String.valueOf(user.getAge()),
                            user.getGender(),
                            user.getAddress()));
                    fw.write("\n");
                }
            }
        }
    }

    public User findById(String userId) throws IOException {
        for (User user : findAll()) {
            if (user.getUserId().equals(userId)) {
                return user;
            }
        }
        return null;
    }

    public User findByEmail(String email) throws IOException {
        for (User user : findAll()) {
            if (user.getEmail().equals(email)) {
                return user;
            }
        }
        return null;
    }
}