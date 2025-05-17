package com.example.onlindedelivery.repositories;

import com.example.onlindedelivery.models.Review;
import org.springframework.stereotype.Repository;

import java.io.*;


import java.text.SimpleDateFormat;

import java.util.*;

@Repository
public class ReviewRepository {

    private static final String FILE_PATH = "reviews.txt";
    private static final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";

    public List<Review> findAll() throws IOException {
        List<Review> reviews = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 6) {
                    Review review = new Review();
                    review.setReviewId(parts[0]);
                    review.setUserId(parts[1]);
                    review.setFoodItemId(parts[2]);
                    review.setReviewText(parts[3]);
                    review.setRating(Integer.parseInt(parts[4]));
                    try {
                        review.setCreatedAt(new SimpleDateFormat(DATE_FORMAT).parse(parts[5]));
                    } catch (Exception e) {
                        review.setCreatedAt(new Date());
                    }
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    public void save(Review review) throws IOException {
        try (FileWriter fw = new FileWriter(FILE_PATH, true)) {
            fw.write(String.join(",",
                    review.getReviewId(),
                    review.getUserId(),
                    review.getFoodItemId(),
                    review.getReviewText(),
                    String.valueOf(review.getRating()),
                    new SimpleDateFormat(DATE_FORMAT).format(review.getCreatedAt())));
            fw.write("\n");
        }
    }

    public void update(Review updatedReview) throws IOException {
        List<Review> reviews = findAll();
        try (FileWriter fw = new FileWriter(FILE_PATH)) {
            for (Review r : reviews) {
                if (r.getReviewId().equals(updatedReview.getReviewId())) {
                    writeReviewToFile(fw, updatedReview);
                } else {
                    writeReviewToFile(fw, r);
                }
            }
        }
    }

    public void deleteById(String id) throws IOException {
        List<Review> reviews = findAll();
        try (FileWriter fw = new FileWriter(FILE_PATH)) {
            for (Review r : reviews) {
                if (!r.getReviewId().equals(id)) {
                    writeReviewToFile(fw, r);
                }
            }
        }
    }

    public Review findById(String id) throws IOException {
        for (Review r : findAll()) {
            if (r.getReviewId().equals(id)) {
                return r;
            }
        }
        return null;
    }

    public List<Review> findByFoodItemId(String foodItemId) throws IOException {
        List<Review> result = new ArrayList<>();
        for (Review r : findAll()) {
            if (r.getFoodItemId().equals(foodItemId)) {
                result.add(r);
            }
        }
        return result;
    }

    private void writeReviewToFile(FileWriter fw, Review r) throws IOException {
        fw.write(String.join(",",
                r.getReviewId(),
                r.getUserId(),
                r.getFoodItemId(),
                r.getReviewText(),
                String.valueOf(r.getRating()),
                new SimpleDateFormat(DATE_FORMAT).format(r.getCreatedAt())));
        fw.write("\n");
    }
}
