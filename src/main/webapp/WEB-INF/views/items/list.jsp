<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Items Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .action-buttons .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
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
        .food-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
        }
        .table-responsive {
            overflow-x: auto;
        }
        .price-column {
            min-width: 100px;
        }
        .description-column {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
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
                        <h1 class="mb-0">Food Items Management</h1>
                    </div>
                </div>
                <div class="col-md-6 text-md-end">
                    <button id="exportPdf" class="btn btn-success">
                        <i class="fas fa-file-pdf"></i> Export PDF
                    </button>
                    <a href="${pageContext.request.contextPath}/create-item" id="addItem" class="btn btn-primary ms-2">
                        <i class="fas fa-plus"></i> Add New Item
                    </a>
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
                        <input type="text" id="searchInput" class="form-control" placeholder="Search food items...">
                    </div>
                </div>
                <div class="col-md-6 text-md-end">
                    <button id="sortByPrice" class="btn btn-outline-secondary">
                        <i class="fas fa-sort-amount-down"></i> Sort by Price
                    </button>
                </div>
            </div>
        </div>

        <!-- Food Items Table -->
        <div class="card shadow-sm">
            <div class="card-body">
                <div class="table-responsive">
                    <table id="foodItemsTable" class="table table-striped table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>Image</th>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th class="price-column">Price</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="foodItemsTableBody">
                            <!-- Table content will be loaded dynamically -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Item Modal -->
    <div class="modal fade" id="editItemModal" tabindex="-1" aria-labelledby="editItemModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editItemModalLabel">Edit Food Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editItemForm">
                        <input type="hidden" id="editItemId">
                        <div class="mb-3">
                            <label for="editName" class="form-label">Name</label>
                            <input type="text" class="form-control" id="editName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="editDescription" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="editPrice" class="form-label">Price</label>
                            <input type="number" step="0.01" class="form-control" id="editPrice" required>
                        </div>
                        <div class="mb-3">
                            <label for="editImage" class="form-label">Image URL</label>
                            <input type="text" class="form-control" id="editImage">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveItemChanges">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this food item? This action cannot be undone.</p>
                    <p><strong>Item: </strong><span id="deleteItemName"></span></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDelete">Delete</button>
                </div>
            </div>
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
        let foodItems = [];
        let currentItemId = null;

        document.addEventListener("DOMContentLoaded", function() {
            // Fetch food items data
            fetchFoodItems();

            // Initialize search functionality
            document.getElementById("searchInput").addEventListener("keyup", function() {
                const value = this.value.toLowerCase();
                filterFoodItems(value);
            });

            // Export PDF button click
            document.getElementById("exportPdf").addEventListener("click", function() {
                exportToPdf();
            });

            // Sort by price button click
            document.getElementById("sortByPrice").addEventListener("click", function() {
                fetchSortedByPrice();
            });

            // Add event listeners for edit and delete buttons
            document.addEventListener("click", function(e) {
                if (e.target.closest(".edit-item")) {
                    const itemId = e.target.closest(".edit-item").getAttribute("data-id");
                    openEditModal(itemId);
                } else if (e.target.closest(".delete-item")) {
                    const itemId = e.target.closest(".delete-item").getAttribute("data-id");
                    openDeleteModal(itemId);
                }
            });

            // Save item changes
            document.getElementById("saveItemChanges").addEventListener("click", function() {
                saveItemChanges();
            });

            // Confirm delete
            document.getElementById("confirmDelete").addEventListener("click", function() {
                deleteItem(currentItemId);
            });
        });

        // Fetch food items from API
        function fetchFoodItems() {
            fetch("/api/food-items")
                .then(response => {
                    if (!response.ok) {
                        throw new Error("Network response was not ok");
                    }
                    return response.json();
                })
                .then(data => {
                    foodItems = data;
                    renderFoodItemsTable(foodItems);
                })
                .catch(error => {
                    console.error("Error fetching food items:", error);
                    alert("Failed to load food items. Please try again later.");
                });
        }

        // Fetch food items sorted by price
        function fetchSortedByPrice() {
            fetch("/api/food-items/sorted-by-price")
                .then(response => {
                    if (!response.ok) {
                        throw new Error("Network response was not ok");
                    }
                    return response.json();
                })
                .then(data => {
                    foodItems = data;
                    renderFoodItemsTable(foodItems);
                })
                .catch(error => {
                    console.error("Error fetching sorted food items:", error);
                    alert("Failed to load sorted food items. Please try again later.");
                });
        }

        // Render food items table
        function renderFoodItemsTable(items) {
            const tableBody = document.getElementById("foodItemsTableBody");
            tableBody.innerHTML = "";

            items.forEach(item => {
                const row = document.createElement("tr");
                
                // Handle null values
                const itemId = item.foodItemId || "";
                const name = item.name || "";
                const description = item.description || "";
                const price = item.price !== undefined && item.price !== null ? item.price.toFixed(2) : "0.00";
                const image = item.image || "https://www.svgrepo.com/show/508699/landscape-placeholder.svg";
                row.innerHTML =
                    "<td>" +
                    "<img src=\"" + (image || 'https://www.svgrepo.com/show/508699/landscape-placeholder.svg') + "\" " +
                    "alt=\"" + name + "\" " +
                    "class=\"food-image\" " +
                    "onerror=\"this.src='https://via.placeholder.com/60x60?text=Error'\">" +
                    "</td>" +
                    "<td>" + itemId + "</td>" +
                    "<td>" + name + "</td>" +
                    "<td class=\"description-column\" title=\"" + description + "\">" + description + "</td>" +
                    "<td class=\"price-column\">$" + price + "</td>" +
                    "<td class=\"action-buttons\">" +
                    "<button class=\"btn btn-sm btn-primary edit-item\" data-id=\"" + itemId + "\">" +
                    "<i class=\"fas fa-edit\"></i>" +
                    "</button>" +
                    "<button class=\"btn btn-sm btn-danger delete-item\" data-id=\"" + itemId + "\">" +
                    "<i class=\"fas fa-trash\"></i>" +
                    "</button>" +
                    "</td>";


                tableBody.appendChild(row);
            });
        }

        // Filter food items based on search input
        function filterFoodItems(searchTerm) {
            if (searchTerm === "") {
                renderFoodItemsTable(foodItems);
                return;
            }

            const filteredItems = foodItems.filter(item => {
                return (
                    (item.foodItemId && item.foodItemId.toLowerCase().includes(searchTerm)) ||
                    (item.name && item.name.toLowerCase().includes(searchTerm)) ||
                    (item.description && item.description.toLowerCase().includes(searchTerm)) ||
                    (item.price !== undefined && item.price !== null && item.price.toString().includes(searchTerm))
                );
            });

            renderFoodItemsTable(filteredItems);
        }

        // Open edit modal with item data
        function openEditModal(itemId) {
            const item = foodItems.find(i => i.foodItemId === itemId);
            if (item) {
                document.getElementById("editItemId").value = item.foodItemId || "";
                document.getElementById("editName").value = item.name || "";
                document.getElementById("editDescription").value = item.description || "";
                document.getElementById("editPrice").value = item.price !== undefined && item.price !== null ? item.price : "";
                document.getElementById("editImage").value = item.image || "";
                
                const editItemModal = new bootstrap.Modal(document.getElementById("editItemModal"));
                editItemModal.show();
            }
        }

        // Save item changes
        function saveItemChanges() {
            const itemId = document.getElementById("editItemId").value;
            const itemData = {
                foodItemId: itemId,
                name: document.getElementById("editName").value,
                description: document.getElementById("editDescription").value,
                price: parseFloat(document.getElementById("editPrice").value),
                image: document.getElementById("editImage").value
            };

            fetch(`/api/food-items/`+itemId, {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(itemData)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                
                // Update local data
                const index = foodItems.findIndex(i => i.foodItemId === itemId);
                if (index !== -1) {
                    foodItems[index] = itemData;
                }
                
                // Close modal and refresh table
                const editItemModal = bootstrap.Modal.getInstance(document.getElementById("editItemModal"));
                editItemModal.hide();
                renderFoodItemsTable(foodItems);
                
                // Show success message
                alert("Food item updated successfully!");
            })
            .catch(error => {
                console.error("Error updating food item:", error);
                alert("Failed to update food item. Please try again.");
            });
        }

        // Open delete confirmation modal
        function openDeleteModal(itemId) {
            const item = foodItems.find(i => i.foodItemId === itemId);
            if (item) {
                currentItemId = itemId;
                document.getElementById("deleteItemName").textContent = item.name || "Unknown";
                const deleteConfirmModal = new bootstrap.Modal(document.getElementById("deleteConfirmModal"));
                deleteConfirmModal.show();
            }
        }

        // Delete item
        function deleteItem(itemId) {
            fetch(`/api/food-items/`+itemId, {
                method: "DELETE"
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                
                // Remove from local data
                foodItems = foodItems.filter(i => i.foodItemId !== itemId);
                
                // Close modal and refresh table
                const deleteConfirmModal = bootstrap.Modal.getInstance(document.getElementById("deleteConfirmModal"));
                deleteConfirmModal.hide();
                renderFoodItemsTable(foodItems);
                
                // Show success message
                alert("Food item deleted successfully!");
            })
            .catch(error => {
                console.error("Error deleting food item:", error);
                alert("Failed to delete food item. Please try again.");
            });
        }

        // Export table to PDF
        function exportToPdf() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            
            // Add title
            doc.setFontSize(18);
            doc.text("Food Items List", 14, 22);
            
            // Add date
            doc.setFontSize(11);
            doc.text("Generated: " + new Date().toLocaleString(), 14, 30);
            
            // Create table
            const tableColumn = ["ID", "Name", "Description", "Price"];
            const tableRows = [];
            
            foodItems.forEach(item => {
                const itemData = [
                    item.foodItemId || "",
                    item.name || "",
                    item.description || "",
                    item.price !== undefined && item.price !== null ? "$" + item.price.toFixed(2) : "$0.00"
                ];
                tableRows.push(itemData);
            });
            
            // Generate PDF with table
            doc.autoTable({
                head: [tableColumn],
                body: tableRows,
                startY: 35,
                styles: {
                    fontSize: 10,
                    cellPadding: 3,
                    overflow: "linebreak"
                },
                columnStyles: {
                    2: { cellWidth: "auto" }
                }
            });
            
            // Save PDF
            doc.save("food_items_list.pdf");
        }
    </script>
</body>
</html>