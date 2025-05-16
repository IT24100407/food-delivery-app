<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Food Item</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .page-header {
            background-color: #f8f9fa;
            padding: 20px 0;
            margin-bottom: 20px;
            border-bottom: 1px solid #dee2e6;
        }
        .btn-back {
            margin-right: 15px;
        }
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .preview-image {
            max-width: 100%;
            max-height: 200px;
            margin-top: 10px;
            border-radius: 4px;
            display: none;
        }
        .invalid-feedback {
            display: none;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 80%;
            color: #dc3545;
        }
    </style>
</head>
<body>
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <div class="d-flex align-items-center">
                        <a href="/admin" class="btn btn-outline-secondary btn-back">
                            <i class="fas fa-arrow-left"></i> Back
                        </a>
                        <h1 class="mb-0">Create New Food Item</h1>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="form-container">
            <div class="card shadow-sm">
                <div class="card-body">
                    <form id="createItemForm">
                        <div class="mb-3">
                            <label for="name" class="form-label">Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="name" name="name" required>
                            <div class="invalid-feedback" id="nameError">
                                Please enter a valid name (3-50 characters).
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                            <div class="invalid-feedback" id="descriptionError">
                                Please enter a valid description (10-500 characters).
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="price" class="form-label">Price ($) <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" min="0.01" class="form-control" id="price" name="price" required>
                            <div class="invalid-feedback" id="priceError">
                                Please enter a valid price (greater than 0).
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="image" class="form-label">Image URL</label>
                            <input type="text" class="form-control" id="image" name="image">
                            <div class="invalid-feedback" id="imageError">
                                Please enter a valid image URL.
                            </div>
                            <img id="imagePreview" src="" alt="Image Preview" class="preview-image">
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <button type="button" class="btn btn-secondary me-md-2" onclick="window.location.href='/items'">Cancel</button>
                            <button type="submit" class="btn btn-primary">Create Food Item</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("createItemForm");
            const nameInput = document.getElementById("name");
            const descriptionInput = document.getElementById("description");
            const priceInput = document.getElementById("price");
            const imageInput = document.getElementById("image");
            const imagePreview = document.getElementById("imagePreview");
            
            // Regular expressions for validation
            const nameRegex = /^.{3,50}$/;
            const descriptionRegex = /^.{10,500}$/;
            const priceRegex = /^[0-9]+(\.[0-9]{1,2})?$/;
            const imageUrlRegex = /^(https?:\/\/.*\.(?:png|jpg|jpeg|gif|webp))$/i;
            
            // Image preview functionality
            imageInput.addEventListener("input", function() {
                const imageUrl = this.value.trim();
                if (imageUrl && imageUrlRegex.test(imageUrl)) {
                    imagePreview.src = imageUrl;
                    imagePreview.style.display = "block";
                } else {
                    imagePreview.style.display = "none";
                }
            });
            
            // Form submission
            form.addEventListener("submit", function(event) {
                event.preventDefault();
                
                // Reset validation states
                resetValidation();
                
                // Get form values
                const name = nameInput.value.trim();
                const description = descriptionInput.value.trim();
                const price = priceInput.value.trim();
                const image = imageInput.value.trim();
                
                // Validate inputs
                let isValid = true;
                
                if (!nameRegex.test(name)) {
                    showError(nameInput, "nameError");
                    isValid = false;
                }
                
                if (!descriptionRegex.test(description)) {
                    showError(descriptionInput, "descriptionError");
                    isValid = false;
                }
                
                if (!priceRegex.test(price) || parseFloat(price) <= 0) {
                    showError(priceInput, "priceError");
                    isValid = false;
                }
                
                if (image && !imageUrlRegex.test(image)) {
                    showError(imageInput, "imageError");
                    isValid = false;
                }
                
                // If form is valid, submit it
                if (isValid) {
                    const foodItem = {
                        name: name,
                        description: description,
                        price: parseFloat(price),
                        image: image
                    };
                    
                    createFoodItem(foodItem);
                }
            });
            
            // Helper functions
            function showError(inputElement, errorId) {
                inputElement.classList.add("is-invalid");
                document.getElementById(errorId).style.display = "block";
            }
            
            function resetValidation() {
                const invalidInputs = form.querySelectorAll(".is-invalid");
                const errorMessages = form.querySelectorAll(".invalid-feedback");
                
                invalidInputs.forEach(input => {
                    input.classList.remove("is-invalid");
                });
                
                errorMessages.forEach(error => {
                    error.style.display = "none";
                });
            }
            
            // Create food item using fetch API
            function createFoodItem(foodItem) {
                fetch("/api/food-items", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(foodItem)
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error("Network response was not ok");
                    }
                    
                    // Redirect to items list page on success
                    window.location.href = "/items";
                })
                .catch(error => {
                    console.error("Error creating food item:", error);
                    alert("Failed to create food item. Please try again.");
                });
            }
        });
    </script>
</body>
</html>