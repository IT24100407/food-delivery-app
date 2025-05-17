package com.example.onlindedelivery.services;

import com.example.onlindedelivery.dtos.ReviewDTO;
import com.example.onlindedelivery.models.Review;
import com.example.onlindedelivery.repositories.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository repository;

    public List<ReviewDTO> getAllReviews() throws Exception {
        return repository.findAll().stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<ReviewDTO> getReviewsByFoodItemId(String foodItemId) throws Exception {
        return repository.findByFoodItemId(foodItemId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public ReviewDTO getReviewById(String id) throws Exception {
        Review review = repository.findById(id);
        if (review == null) throw new RuntimeException("Review not found");
        return toDTO(review);
    }

    public void createReview(Review review) throws Exception {
        repository.save(review);
    }

    public void updateReview(String id, Review updatedReview) throws Exception {
        updatedReview.setReviewId(id);
        repository.update(updatedReview);
    }

    public void deleteReview(String id) throws Exception {
        repository.deleteById(id);
    }

    private ReviewDTO toDTO(Review review) {
        ReviewDTO dto = new ReviewDTO();
        dto.setReviewId(review.getReviewId());
        dto.setUserId(review.getUserId());
        dto.setFoodItemId(review.getFoodItemId());
        dto.setReviewText(review.getReviewText());
        dto.setRating(review.getRating());
        dto.setCreatedAt(review.getCreatedAt());
        return dto;
    }
}