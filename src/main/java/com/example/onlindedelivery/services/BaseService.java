package com.example.onlindedelivery.services;

import org.springframework.stereotype.Service;
import java.util.Date;

@Service
public abstract class BaseService {
    // Common timestamp methods that can be used by all services
    protected Date getCurrentTimestamp() {
        return new Date();
    }

    // Common validation method
    protected void validateId(String id) {
        if (id == null || id.trim().isEmpty()) {
            throw new IllegalArgumentException("ID cannot be null or empty");
        }
    }

    // Common method to check if a string is empty
    protected boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    // Common method to validate rating
    protected void validateRating(int rating) {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }
}
