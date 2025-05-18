<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Feedback Management</title>
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
        .search-container {
            margin-bottom: 20px;
        }
        .star-filled {
            color: #ffc107;
        }
        .star-empty {
            color: #e4e5e9;
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
                        <h1 class="mb-0">Customer Feedback Management</h1>
                    </div>
                </div>
                <div class="col-md-6 text-md-end">
                    <button id="exportPdf" class="btn btn-success">
                        <i class="fas fa-file-pdf"></i> Export PDF
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Search Container -->
        <div class="search-container">
            <div class="row">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                        <input type="text" id="searchInput" class="form-control" placeholder="Search feedbacks...">
                    </div>
                </div>
                <div class="col-md-2">
                    <select id="ratingFilter" class="form-select">
                        <option value="">All Ratings</option>
                        <option value="5">5 Stars</option>
                        <option value="4">4 Stars</option>
                        <option value="3">3 Stars</option>
                        <option value="2">2 Stars</option>
                        <option value="1">1 Star</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Loading Indicator -->
        <div id="loading" class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">Loading feedbacks...</p>
        </div>

        <!-- No Feedbacks Message -->
        <div id="noFeedbacks" class="text-center py-5 bg-white rounded shadow-sm d-none">
            <i class="fas fa-comments fa-3x text-gray-400 mb-3"></i>
            <h2 class="h4 font-weight-bold text-gray-700 mb-2">No Feedbacks Found</h2>
            <p class="text-gray-500 mb-4">There are no customer feedbacks in the system yet.</p>
        </div>

        <!-- Feedbacks Table -->
        <div id="feedbacksTable" class="table-responsive d-none">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Food Item</th>
                        <th>Rating</th>
                        <th>Review</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody id="feedbacksTableBody">
                    <!-- Feedbacks will be loaded here dynamically -->
                </tbody>
            </table>
        </div>
    </div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jsPDF for PDF export -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.25/jspdf.plugin.autotable.min.js"></script>

    <script>
        // Global variables
        let allFeedbacks = [];
        let foodItems = {};
        let users = {};

        document.addEventListener("DOMContentLoaded", function() {
            // Fetch all feedbacks
            fetchFeedbacks();

            // Initialize search functionality
            document.getElementById("searchInput").addEventListener("keyup", function() {
                filterFeedbacks();
            });

            // Initialize rating filter
            document.getElementById("ratingFilter").addEventListener("change", function() {
                filterFeedbacks();
            });

            // Export PDF button click
            document.getElementById("exportPdf").addEventListener("click", function() {
                exportToPdf();
            });
        });

        async function fetchFeedbacks() {
            try {
                const response = await fetch("/api/reviews");
                if (!response.ok) {
                    throw new Error("Failed to fetch feedbacks");
                }
                
                allFeedbacks = await response.json();
                
                if (allFeedbacks.length === 0) {
                    document.getElementById("loading").classList.add("d-none");
                    document.getElementById("noFeedbacks").classList.remove("d-none");
                    return;
                }
                
                // Fetch additional data for each feedback
                await fetchAdditionalData();
                
                // Display feedbacks
                displayFeedbacks(allFeedbacks);
                
                document.getElementById("loading").classList.add("d-none");
                document.getElementById("feedbacksTable").classList.remove("d-none");
            } catch (error) {
                console.error("Error fetching feedbacks:", error);
                document.getElementById("loading").classList.add("d-none");
                alert("Failed to load feedbacks. Please try again later.");
            }
        }

        async function fetchAdditionalData() {
            const foodItemIds = [...new Set(allFeedbacks.map(feedback => feedback.foodItemId))];
            const userIds = [...new Set(allFeedbacks.map(feedback => feedback.userId))];
            
            // Fetch food items
            for (const foodItemId of foodItemIds) {
                try {
                    const response = await fetch("/api/food-item/" + foodItemId);
                    if (response.ok) {
                        const foodItem = await response.json();
                        foodItems[foodItemId] = foodItem;
                    }
                } catch (error) {
                    console.error("Error fetching food item " + foodItemId + ":", error);
                    foodItems[foodItemId] = { name: "Item #" + foodItemId.substring(0, 8) };
                }
            }
            
            // Fetch users
            for (const userId of userIds) {
                try {
                    const response = await fetch("/api/users/" + userId);
                    if (response.ok) {
                        const user = await response.json();
                        users[userId] = user;
                    }
                } catch (error) {
                    console.error("Error fetching user " + userId + ":", error);
                    users[userId] = { name: "User #" + userId };
                }
            }
        }

        function displayFeedbacks(feedbacks) {
            const tableBody = document.getElementById("feedbacksTableBody");
            tableBody.innerHTML = "";
            
            feedbacks.forEach(feedback => {
                const foodItem = foodItems[feedback.foodItemId] || { name: "Item #" + feedback.foodItemId.substring(0, 8) };
                const user = users[feedback.userId] || { name: "User #" + feedback.userId };
                
                const row = document.createElement("tr");
                row.innerHTML = 
                    "<td>" + feedback.reviewId + "</td>" +
                    "<td>" + (user.name || user.email || user.userId) + "</td>" +
                    "<td>" + foodItem.name + "</td>" +
                    "<td>" + getRatingStars(feedback.rating) + "</td>" +
                    "<td>" + feedback.reviewText + "</td>" +
                    "<td>" + formatDate(feedback.createdAt) + "</td>";
                
                tableBody.appendChild(row);
            });
        }

        function getRatingStars(rating) {
            let stars = "";
            for (let i = 1; i <= 5; i++) {
                if (i <= rating) {
                    stars += "<i class=\"fas fa-star star-filled\"></i>";
                } else {
                    stars += "<i class=\"far fa-star star-empty\"></i>";
                }
            }
            return stars;
        }

        function formatDate(dateString) {
            if (!dateString) return "N/A";
            const date = new Date(dateString);
            return date.toLocaleDateString() + " " + date.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
        }

        function filterFeedbacks() {
            const searchTerm = document.getElementById("searchInput").value.toLowerCase();
            const ratingFilter = document.getElementById("ratingFilter").value;
            
            const filteredFeedbacks = allFeedbacks.filter(feedback => {
                // Rating filter
                if (ratingFilter && feedback.rating != ratingFilter) {
                    return false;
                }
                
                // Text search
                const foodItem = foodItems[feedback.foodItemId] || { name: "" };
                const user = users[feedback.userId] || { name: "", email: "" };
                
                return (
                    (feedback.reviewId && feedback.reviewId.toLowerCase().includes(searchTerm)) ||
                    (feedback.reviewText && feedback.reviewText.toLowerCase().includes(searchTerm)) ||
                    (foodItem.name && foodItem.name.toLowerCase().includes(searchTerm)) ||
                    (user.name && user.name.toLowerCase().includes(searchTerm)) ||
                    (user.email && user.email.toLowerCase().includes(searchTerm))
                );
            });
            
            displayFeedbacks(filteredFeedbacks);
            
            // Show/hide no results message
            if (filteredFeedbacks.length === 0) {
                document.getElementById("feedbacksTable").classList.add("d-none");
                document.getElementById("noFeedbacks").classList.remove("d-none");
                document.getElementById("noFeedbacks").querySelector("h2").textContent = "No Matching Feedbacks";
                document.getElementById("noFeedbacks").querySelector("p").textContent = "Try adjusting your search criteria.";
            } else {
                document.getElementById("feedbacksTable").classList.remove("d-none");
                document.getElementById("noFeedbacks").classList.add("d-none");
            }
        }

        function exportToPdf() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            
            // Add title
            doc.setFontSize(18);
            doc.text("Customer Feedbacks Report", 14, 22);
            
            // Add date
            doc.setFontSize(11);
            doc.text("Generated: " + new Date().toLocaleString(), 14, 30);
            
            // Create table
            const tableColumn = ["ID", "Customer", "Food Item", "Rating", "Review", "Date"];
            const tableRows = [];
            
            // Get currently filtered feedbacks
            const searchTerm = document.getElementById("searchInput").value.toLowerCase();
            const ratingFilter = document.getElementById("ratingFilter").value;
            
            const filteredFeedbacks = allFeedbacks.filter(feedback => {
                if (ratingFilter && feedback.rating != ratingFilter) {
                    return false;
                }
                
                const foodItem = foodItems[feedback.foodItemId] || { name: "" };
                const user = users[feedback.userId] || { name: "", email: "" };
                
                return (
                    (feedback.reviewId && feedback.reviewId.toLowerCase().includes(searchTerm)) ||
                    (feedback.reviewText && feedback.reviewText.toLowerCase().includes(searchTerm)) ||
                    (foodItem.name && foodItem.name.toLowerCase().includes(searchTerm)) ||
                    (user.name && user.name.toLowerCase().includes(searchTerm)) ||
                    (user.email && user.email.toLowerCase().includes(searchTerm))
                );
            });
            
            filteredFeedbacks.forEach(feedback => {
                const foodItem = foodItems[feedback.foodItemId] || { name: "Item #" + feedback.foodItemId.substring(0, 8) };
                const user = users[feedback.userId] || { name: "User #" + feedback.userId };
                
                const itemData = [
                    feedback.reviewId,
                    user.name || user.email || user.userId,
                    foodItem.name,
                    feedback.rating + "/5",
                    feedback.reviewText,
                    formatDate(feedback.createdAt)
                ];
                tableRows.push(itemData);
            });
            
            // Generate PDF with table
            doc.autoTable({
                head: [tableColumn],
                body: tableRows,
                startY: 35,
                styles: {
                    fontSize: 9,
                    cellPadding: 3,
                    overflow: "linebreak"
                },
                columnStyles: {
                    0: { cellWidth: 20 },
                    1: { cellWidth: 30 },
                    2: { cellWidth: 30 },
                    3: { cellWidth: 15 },
                    4: { cellWidth: 60 },
                    5: { cellWidth: 25 }
                }
            });
            
            // Save PDF
            doc.save("customer_feedbacks.pdf");
        }
    </script>
</body>
</html>