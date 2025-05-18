<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-12">
            <h2>Customer Reviews</h2>
            <hr>
        </div>
    </div>
    
    <!-- Add Review Button -->
    <div class="row mb-4">
        <div class="col-md-12">
            <button type="button" class="btn btn-primary" id="addReviewBtn">
                <i class="bi bi-plus-circle"></i> Add Review
            </button>
        </div>
    </div>
    
    <!-- Reviews Container -->
    <div class="row" id="reviewsContainer">
        <!-- Reviews will be loaded here dynamically -->
        <div class="col-12 text-center" id="loadingReviews">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p>Loading reviews...</p>
        </div>
    </div>
    
    <!-- Add Review Modal -->
    <div class="modal fade" id="addReviewModal" tabindex="-1" aria-labelledby="addReviewModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addReviewModalLabel">Add New Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addReviewForm" novalidate>
                        <div class="mb-3">
                            <label for="foodItemSelect" class="form-label">Food Item</label>
                            <select class="form-select" id="foodItemSelect" required>
                                <option value="">Select a food item</option>
                                <!-- Food items will be loaded here -->
                            </select>
                            <div class="invalid-feedback">
                                Please select a food item.
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="reviewText" class="form-label">Your Review</label>
                            <textarea class="form-control" id="reviewText" rows="3" required minlength="10" maxlength="500"></textarea>
                            <div class="invalid-feedback">
                                Please provide a review (minimum 10 characters).
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Rating</label>
                            <div class="rating">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" id="rating1" value="1" required>
                                    <label class="form-check-label" for="rating1">1</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" id="rating2" value="2">
                                    <label class="form-check-label" for="rating2">2</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" id="rating3" value="3">
                                    <label class="form-check-label" for="rating3">3</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" id="rating4" value="4">
                                    <label class="form-check-label" for="rating4">4</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" id="rating5" value="5">
                                    <label class="form-check-label" for="rating5">5</label>
                                </div>
                                <div class="invalid-feedback d-block" id="ratingFeedback" style="display: none !important;">
                                    Please select a rating.
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitReview">Submit Review</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Review Modal -->
    <div class="modal fade" id="editReviewModal" tabindex="-1" aria-labelledby="editReviewModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editReviewModalLabel">Edit Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editReviewForm" novalidate>
                        <input type="hidden" id="editReviewId">
                        <div class="mb-3">
                            <label for="editFoodItemSelect" class="form-label">Food Item</label>
                            <select class="form-select" id="editFoodItemSelect" disabled>
                                <!-- Food items will be loaded here -->
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="editReviewText" class="form-label">Your Review</label>
                            <textarea class="form-control" id="editReviewText" rows="3" required minlength="10" maxlength="500"></textarea>
                            <div class="invalid-feedback">
                                Please provide a review (minimum 10 characters).
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Rating</label>
                            <div class="rating">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="editRating" id="editRating1" value="1" required>
                                    <label class="form-check-label" for="editRating1">1</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="editRating" id="editRating2" value="2">
                                    <label class="form-check-label" for="editRating2">2</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="editRating" id="editRating3" value="3">
                                    <label class="form-check-label" for="editRating3">3</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="editRating" id="editRating4" value="4">
                                    <label class="form-check-label" for="editRating4">4</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="editRating" id="editRating5" value="5">
                                    <label class="form-check-label" for="editRating5">5</label>
                                </div>
                                <div class="invalid-feedback d-block" id="editRatingFeedback" style="display: none !important;">
                                    Please select a rating.
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="updateReview">Update Review</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Review Modal -->
    <div class="modal fade" id="deleteReviewModal" tabindex="-1" aria-labelledby="deleteReviewModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteReviewModalLabel">Delete Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this review? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteReview">Delete</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- No User Modal -->
    <div class="modal fade" id="noUserModal" tabindex="-1" aria-labelledby="noUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="noUserModalLabel">Login Required</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>You need to be logged in to add a review. Please log in and try again.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Variables
        let foodItems = [];
        let reviews = [];
        let currentReviewId = null;
        const userId = localStorage.getItem('userId');
        
        // DOM Elements
        const reviewsContainer = document.getElementById('reviewsContainer');
        const loadingReviews = document.getElementById('loadingReviews');
        const addReviewBtn = document.getElementById('addReviewBtn');
        const foodItemSelect = document.getElementById('foodItemSelect');
        const editFoodItemSelect = document.getElementById('editFoodItemSelect');
        
        // Initialize
        fetchFoodItems();
        fetchReviews();
        
        // Event Listeners
        addReviewBtn.addEventListener('click', function() {
            if (!userId) {
                const noUserModal = new bootstrap.Modal(document.getElementById('noUserModal'));
                noUserModal.show();
                return;
            }
            
            const addReviewModal = new bootstrap.Modal(document.getElementById('addReviewModal'));
            addReviewModal.show();
        });
        
        document.getElementById('submitReview').addEventListener('click', submitReview);
        document.getElementById('updateReview').addEventListener('click', updateReview);
        document.getElementById('confirmDeleteReview').addEventListener('click', deleteReview);
        
        // Functions
        function fetchFoodItems() {
            fetch('/api/food-items')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    foodItems = data;
                    populateFoodItemsDropdown(foodItemSelect);
                    populateFoodItemsDropdown(editFoodItemSelect);
                })
                .catch(error => {
                    console.error('Error fetching food items:', error);
                    alert('Failed to load food items. Please try again later.');
                });
        }
        
        function populateFoodItemsDropdown(selectElement) {
            // Clear existing options except the first one
            while (selectElement.options.length > 1) {
                selectElement.remove(1);
            }
            
            // Add food items to dropdown
            foodItems.forEach(item => {
                const option = document.createElement('option');
                option.value = item.foodItemId;
                option.textContent = item.name;
                selectElement.appendChild(option);
            });
        }
        
        function fetchReviews() {
            fetch('/api/reviews')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    reviews = data;
                    renderReviews();
                })
                .catch(error => {
                    console.error('Error fetching reviews:', error);
                    loadingReviews.innerHTML = '<p class="text-danger">Failed to load reviews. Please try again later.</p>';
                });
        }
        
        function renderReviews() {
            // Hide loading indicator
            loadingReviews.style.display = 'none';
            
            // Clear reviews container
            reviewsContainer.innerHTML = '';
            
            if (reviews.length === 0) {
                reviewsContainer.innerHTML = '<div class="col-12"><p class="text-center">No reviews yet. Be the first to add a review!</p></div>';
                return;
            }
            
            // Render each review
            reviews.forEach(review => {
                const foodItem = foodItems.find(item => item.foodItemId === review.foodItemId) || { name: 'Unknown Item' };
                const isOwner = userId && review.userId === userId;
                
                const reviewCard = document.createElement('div');
                reviewCard.className = 'col-md-6 col-lg-4 mb-4';
                reviewCard.innerHTML =
                    "<div class=\"card h-100\">" +
                    "<div class=\"card-header d-flex justify-content-between align-items-center\">" +
                    "<h5 class=\"mb-0\">" + foodItem.name + "</h5>" +
                    "<div class=\"rating-display\">" +
                    getRatingStars(review.rating) +
                    "</div>" +
                    "</div>" +
                    "<div class=\"card-body\">" +
                    "<p class=\"card-text\">" + review.reviewText + "</p>" +
                    "</div>" +
                    "<div class=\"card-footer d-flex justify-content-between align-items-center\">" +
                    "<small class=\"text-muted\">Posted on " + formatDate(review.createdAt) + "</small>";

                if (isOwner) {
                    reviewCard.innerHTML +=
                        "<div class=\"btn-group\">" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-primary edit-review\" data-id=\"" + review.reviewId + "\">" +
                        "<i class=\"bi bi-pencil\"></i>" +
                        "</button>" +
                        "<button type=\"button\" class=\"btn btn-sm btn-outline-danger delete-review\" data-id=\"" + review.reviewId + "\">" +
                        "<i class=\"bi bi-trash\"></i>" +
                        "</button>" +
                        "</div>";
                }

                reviewCard.innerHTML +=
                    "</div>" +
                    "</div>";
                
                reviewsContainer.appendChild(reviewCard);
                
                // Add event listeners for edit and delete buttons
                if (isOwner) {
                    reviewCard.querySelector('.edit-review').addEventListener('click', function() {
                        openEditModal(review.reviewId);
                    });
                    
                    reviewCard.querySelector('.delete-review').addEventListener('click', function() {
                        openDeleteModal(review.reviewId);
                    });
                }
            });
        }
        
        function getRatingStars(rating) {
            let stars = '';
            for (let i = 1; i <= 5; i++) {
                if (i <= rating) {
                    stars += '<i class="bi bi-star-fill text-warning"></i>';
                } else {
                    stars += '<i class="bi bi-star text-warning"></i>';
                }
            }
            return stars;
        }
        
        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        }
        
        function validateForm(formId) {
            const form = document.getElementById(formId);
            
            // Check form validity
            if (!form.checkValidity()) {
                form.classList.add('was-validated');
                return false;
            }
            
            // Additional validation for rating
            const ratingName = formId === 'addReviewForm' ? 'rating' : 'editRating';
            const ratingFeedbackId = formId === 'addReviewForm' ? 'ratingFeedback' : 'editRatingFeedback';
            const selectedRating = document.querySelector("input[name=\"" + ratingName + "\"]:checked");
            
            if (!selectedRating) {
                document.getElementById(ratingFeedbackId).style.display = 'block !important';
                return false;
            }
            
            return true;
        }
        
        function submitReview() {
            if (!validateForm('addReviewForm')) {
                return;
            }
            
            const foodItemId = foodItemSelect.value;
            const reviewText = document.getElementById('reviewText').value;
            const rating = document.querySelector('input[name="rating"]:checked').value;
            
            const reviewData = {
                reviewId: generateReviewId(),
                userId: userId,
                foodItemId: foodItemId,
                reviewText: reviewText,
                rating: parseInt(rating)
            };
            
            fetch('/api/reviews', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(reviewData)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                
                // Close modal and reset form
                const addReviewModal = bootstrap.Modal.getInstance(document.getElementById('addReviewModal'));
                addReviewModal.hide();
                document.getElementById('addReviewForm').reset();
                document.getElementById('addReviewForm').classList.remove('was-validated');
                
                // Refresh reviews
                fetchReviews();
                
                // Show success message
                alert('Review submitted successfully!');
            })
            .catch(error => {
                console.error('Error submitting review:', error);
                alert('Failed to submit review. Please try again.');
            });
        }
        
        function generateReviewId() {
            return 'R' + Math.floor(Math.random() * 10000);
        }
        
        function openEditModal(reviewId) {
            const review = reviews.find(r => r.reviewId === reviewId);
            if (!review) return;
            
            currentReviewId = reviewId;
            
            // Populate form
            document.getElementById('editReviewId').value = review.reviewId;
            document.getElementById('editReviewText').value = review.reviewText;
            document.getElementById('editFoodItemSelect').value = review.foodItemId;
            
            // Set rating
            const ratingRadio = document.getElementById("editRating" + review.rating);
            if (ratingRadio) {
                ratingRadio.checked = true;
            }
            
            // Show modal
            const editReviewModal = new bootstrap.Modal(document.getElementById('editReviewModal'));
            editReviewModal.show();
        }
        
        function updateReview() {
            if (!validateForm('editReviewForm')) {
                return;
            }
            
            const reviewId = document.getElementById('editReviewId').value;
            const reviewText = document.getElementById('editReviewText').value;
            const rating = document.querySelector('input[name="editRating"]:checked').value;
            
            // Get the original review to preserve other fields
            const originalReview = reviews.find(r => r.reviewId === reviewId);
            if (!originalReview) return;
            
            const reviewData = {
                ...originalReview,
                reviewText: reviewText,
                rating: parseInt(rating)
            };
            
            fetch(`/api/reviews/`+reviewId, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(reviewData)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                
                // Close modal and reset form
                const editReviewModal = bootstrap.Modal.getInstance(document.getElementById('editReviewModal'));
                editReviewModal.hide();
                document.getElementById('editReviewForm').classList.remove('was-validated');
                
                // Refresh reviews
                fetchReviews();
                
                // Show success message
                alert('Review updated successfully!');
            })
            .catch(error => {
                console.error('Error updating review:', error);
                alert('Failed to update review. Please try again.');
            });
        }
        
        function openDeleteModal(reviewId) {
            currentReviewId = reviewId;
            const deleteReviewModal = new bootstrap.Modal(document.getElementById('deleteReviewModal'));
            deleteReviewModal.show();
        }
        
        function deleteReview() {
            if (!currentReviewId) return;
            
            fetch(`/api/reviews/`+currentReviewId, {
                method: 'DELETE'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                
                // Close modal
                const deleteReviewModal = bootstrap.Modal.getInstance(document.getElementById('deleteReviewModal'));
                deleteReviewModal.hide();
                
                // Refresh reviews
                fetchReviews();
                
                // Show success message
                alert('Review deleted successfully!');
            })
            .catch(error => {
                console.error('Error deleting review:', error);
                alert('Failed to delete review. Please try again.');
            });
        }
    });
</script>