<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Deliveries Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .delivery-table {
            margin-top: 20px;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Deliveries Management</h2>
            <a href="/create-delivery" class="btn btn-primary">
                <i class="fas fa-plus"></i> Create New Delivery
            </a>
        </div>

        <div class="alert alert-info" role="alert" id="loading-message">
            Loading deliveries...
        </div>
        
        <div class="alert alert-danger" role="alert" id="error-message" style="display: none;">
            Error loading deliveries. Please try again later.
        </div>
        
        <div id="deliveries-container" style="display: none;">
            <table class="table table-striped delivery-table">
                <thead>
                    <tr>
                        <th>Delivery ID</th>
                        <th>Order ID</th>
                        <th>Status</th>
                        <th>Estimated Delivery</th>
                        <th>Actual Delivery</th>
                        <th>Address</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="deliveries-list">
                    <!-- Deliveries will be loaded here -->
                </tbody>
            </table>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this delivery?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Fetch all deliveries
            fetchDeliveries();
            
            // Set up delete confirmation - initialize modal once
            const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            let deliveryToDelete = null;
            
            document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
                if (deliveryToDelete) {
                    deleteDelivery(deliveryToDelete);
                    deleteModal.hide();
                }
            });
            
            // Event delegation for delete buttons
            document.getElementById('deliveries-list').addEventListener('click', function(e) {
                if (e.target.classList.contains('delete-btn') || e.target.closest('.delete-btn')) {
                    const button = e.target.classList.contains('delete-btn') ? e.target : e.target.closest('.delete-btn');
                    deliveryToDelete = button.getAttribute('data-id');
                    deleteModal.show();
                }
            });
        });
        
        function fetchDeliveries() {
            fetch('/api/deliveries')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(deliveries => {
                    displayDeliveries(deliveries);
                    document.getElementById('loading-message').style.display = 'none';
                    document.getElementById('deliveries-container').style.display = 'block';
                })
                .catch(error => {
                    console.error('Error fetching deliveries:', error);
                    document.getElementById('loading-message').style.display = 'none';
                    document.getElementById('error-message').style.display = 'block';
                });
        }
        
        function displayDeliveries(deliveries) {
            const tableBody = document.getElementById('deliveries-list');
            tableBody.innerHTML = '';
            
            if (deliveries.length === 0) {
                const emptyRow = document.createElement('tr');
                emptyRow.innerHTML = '<td colspan="7" class="text-center">No deliveries found</td>';
                tableBody.appendChild(emptyRow);
                return;
            }
            
            deliveries.forEach(delivery => {
                const row = document.createElement('tr');
                
                // Format dates for display
                const estimatedDate = delivery.estimatedDeliveryTime ? new Date(delivery.estimatedDeliveryTime).toLocaleString() : 'Not set';
                const actualDate = delivery.actualDeliveryTime ? new Date(delivery.actualDeliveryTime).toLocaleString() : 'Not delivered';


                row.innerHTML =
                    "<td>" + delivery.deliveryId + "</td>" +
                    "<td>" + delivery.orderId + "</td>" +
                    "<td><span class=\"badge bg-" + getStatusBadgeColor(delivery.deliveryStatus) + "\">" + delivery.deliveryStatus + "</span></td>" +
                    "<td>" + estimatedDate + "</td>" +
                    "<td>" + actualDate + "</td>" +
                    "<td>" + delivery.deliveryAddress + "</td>" +
                    "<td class=\"action-buttons\">" +
                    "<a href=\"/edit-delivery/" + delivery.deliveryId + "\" class=\"btn btn-sm btn-warning\">" +
                    "<i class=\"fas fa-edit\"></i> Edit" +
                    "</a>" +
                    "<button class=\"btn btn-sm btn-danger delete-btn\" data-id=\"" + delivery.deliveryId + "\">" +
                    "<i class=\"fas fa-trash\"></i> Delete" +
                    "</button>" +
                    "</td>";
                tableBody.appendChild(row);
            });
            
            // Add event listeners to delete buttons
            document.querySelectorAll('.delete-btn').forEach(button => {
                button.addEventListener('click', function() {
                    deliveryToDelete = this.getAttribute('data-id');
                    const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                    deleteModal.show();
                });
            });
        }
        
        function getStatusBadgeColor(status) {
            switch(status.toLowerCase()) {
                case 'delivered':
                    return 'success';
                case 'in transit':
                    return 'primary';
                case 'pending':
                    return 'warning';
                case 'cancelled':
                    return 'danger';
                default:
                    return 'secondary';
            }
        }
        
        function deleteDelivery(id) {
            fetch("/api/deliveries/" + id, {
                method: 'DELETE'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to delete delivery');
                }
                // Refresh the list after successful deletion
                fetchDeliveries();
            })
            .catch(error => {
                console.error('Error deleting delivery:', error);
                alert('Failed to delete delivery. Please try again.');
            });
        }
    </script>
</body>
</html>