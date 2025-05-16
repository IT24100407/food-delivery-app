package com.example.onlindedelivery.controllers;

import com.example.onlindedelivery.dtos.ReviewDTO;
import com.example.onlindedelivery.models.Review;
import com.example.onlindedelivery.services.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
    
@RequestMapping("/api/reviews")
public class ReviewController {

    @Autowired
    private ReviewService service;

    // GET ALL REVIEWS
    @GetMapping
    public List<ReviewDTO> getAll() throws Exception {
        return service.getAllReviews();
    }

    // GET REVIEWS BY FOOD ITEM ID
    @GetMapping("/food/{foodItemId}")
    public List<ReviewDTO> getByFoodItemId(@PathVariable String foodItemId) throws Exception {
        return service.getReviewsByFoodItemId(foodItemId);
    }

    // GET REVIEW BY ID
    @GetMapping("/{id}")
    public ReviewDTO getById(@PathVariable String id) throws Exception {
        return service.getReviewById(id);
    }

    // CREATE NEW REVIEW
    @PostMapping
    public void create(@RequestBody Review review) throws Exception {
        service.createReview(review);
    }

    // UPDATE EXISTING REVIEW
    @PutMapping("/{id}")
    public void update(@PathVariable String id, @RequestBody Review updatedReview) throws Exception {
        service.updateReview(id, updatedReview);
    }

    // DELETE REVIEW
    @DeleteMapping("/{id}")
    public void delete(@PathVariable String id) throws Exception {
        service.deleteReview(id);
    }
}
