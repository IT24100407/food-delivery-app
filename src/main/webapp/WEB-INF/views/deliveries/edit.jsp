<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Delivery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .status-badge {
            font-size: 1rem;
            padding: 0.5rem 1rem;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Edit Delivery</h2>
            <a href="/deliveries" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left"></i> Back to Deliveries
            </a>
        </div>

        <div id="loading" class="loading-overlay">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>

        <div id="alert-container"></div>

        <div class="form-container">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Delivery Information</h5>
                </div>
                <div class="card-body">
                    <form id="editDeliveryForm">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="deliveryId" class="form-label">Delivery ID</label>
                                <input type="text" class="form-control" id="deliveryId" readonly>
                            </div>
                            <div class="col-md-6">
                                <label for="orderId" class="form-label">Order ID</label>
                                <input type="text" class="form-control" id="orderId" readonly>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-12">
                                <label for="deliveryAddress" class="form-label">Delivery Address</label>
                                <textarea class="form-control" id="deliveryAddress" rows="2" required></textarea>
                                <div class="invalid-feedback">
                                    Please provide a delivery address.
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="estimatedDeliveryTime" class="form-label">Estimated Delivery Time</label>
                                <input type="datetime-local" class="form-control" id="estimatedDeliveryTime" required>
                                <div class="invalid-feedback">
                                    Please provide an estimated delivery time.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="actualDeliveryTime" class="form-label">Actual Delivery Time</label>
                                <input type="datetime-local" class="form-control" id="actualDeliveryTime">
                                <small class="text-muted">Leave blank if not delivered yet</small>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="deliveryStatus" class="form-label">Delivery Status</label>
                            <select class="form-select" id="deliveryStatus" required>
                                <option value="Pending">Pending</option>
                                <option value="In Transit">In Transit</option>
                                <option value="Delivered">Delivered</option>
                                <option value="Cancelled">Cancelled</option>
                            </select>
                            <div class="invalid-feedback">
                                Please select a delivery status.
                            </div>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <button type="button" class="btn btn-secondary me-md-2" onclick="window.location.href='/deliveries'">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Get delivery ID from URL
            const pathParts = window.location.pathname.split("/");
            const deliveryId = pathParts[pathParts.length - 1];
            
            // Fetch delivery data
            fetchDelivery(deliveryId);
            
            // Set up form submission
            document.getElementById("editDeliveryForm").addEventListener("submit", function(e) {
                e.preventDefault();
                if (validateForm()) {
                    updateDelivery();
                }
            });
            
            // Auto-update status when actual delivery time is set
            document.getElementById("actualDeliveryTime").addEventListener("change", function() {
                if (this.value) {
                    document.getElementById("deliveryStatus").value = "Delivered";
                }
            });
            
            // Auto-clear actual delivery time when status is not "Delivered"
            document.getElementById("deliveryStatus").addEventListener("change", function() {
                if (this.value !== "Delivered") {
                    document.getElementById("actualDeliveryTime").value = "";
                }
            });
        });
        
        function fetchDelivery(id) {
            showLoading(true);
            
            fetch("/api/deliveries/" + id)
                .then(response => {
                    if (!response.ok) {
                        throw new Error("Failed to fetch delivery data");
                    }
                    return response.json();
                })
                .then(delivery => {
                    populateForm(delivery);
                    showLoading(false);
                })
                .catch(error => {
                    console.error("Error:", error);
                    showAlert("Failed to load delivery data. Please try again.", "danger");
                    showLoading(false);
                });
        }
        
        function populateForm(delivery) {
            document.getElementById("deliveryId").value = delivery.deliveryId;
            document.getElementById("orderId").value = delivery.orderId;
            document.getElementById("deliveryAddress").value = delivery.deliveryAddress;
            document.getElementById("deliveryStatus").value = delivery.deliveryStatus;
            
            // Format dates for datetime-local input
            if (delivery.estimatedDeliveryTime) {
                const estimatedDate = new Date(delivery.estimatedDeliveryTime);
                document.getElementById("estimatedDeliveryTime").value = formatDateForInput(estimatedDate);
            }
            
            if (delivery.actualDeliveryTime) {
                const actualDate = new Date(delivery.actualDeliveryTime);
                document.getElementById("actualDeliveryTime").value = formatDateForInput(actualDate);
            }
        }
        
        function formatDateForInput(date) {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, "0");
            const day = String(date.getDate()).padStart(2, "0");
            const hours = String(date.getHours()).padStart(2, "0");
            const minutes = String(date.getMinutes()).padStart(2, "0");
            
            return `${year}-${month}-${day}T${hours}:${minutes}`;
        }
        
        function validateForm() {
            const form = document.getElementById("editDeliveryForm");
            form.classList.add("was-validated");
            
            // Basic validation
            if (!form.checkValidity()) {
                return false;
            }
            
            // Additional validation
            const status = document.getElementById("deliveryStatus").value;
            const actualTime = document.getElementById("actualDeliveryTime").value;
            
            // If status is "Delivered", actual delivery time must be set
            if (status === "Delivered" && !actualTime) {
                showAlert("Actual delivery time is required when status is 'Delivered'", "warning");
                return false;
            }
            
            // If actual delivery time is set, status should be "Delivered"
            if (actualTime && status !== "Delivered") {
                document.getElementById("deliveryStatus").value = "Delivered";
            }
            
            return true;
        }
        
        function updateDelivery() {
            showLoading(true);
            
            const deliveryId = document.getElementById("deliveryId").value;
            const orderId = document.getElementById("orderId").value;
            const deliveryAddress = document.getElementById("deliveryAddress").value;
            const deliveryStatus = document.getElementById("deliveryStatus").value;
            const estimatedDeliveryTime = document.getElementById("estimatedDeliveryTime").value;
            const actualDeliveryTime = document.getElementById("actualDeliveryTime").value;
            
            const deliveryData = {
                deliveryId: deliveryId,
                orderId: orderId,
                deliveryStatus: deliveryStatus,
                deliveryAddress: deliveryAddress,
                estimatedDeliveryTime: estimatedDeliveryTime ? new Date(estimatedDeliveryTime).toISOString() : null,
                actualDeliveryTime: actualDeliveryTime ? new Date(actualDeliveryTime).toISOString() : null
            };
            
            fetch("/api/deliveries/" + deliveryId, {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(deliveryData)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error("Failed to update delivery");
                }
                
                showAlert("Delivery updated successfully!", "success");
                
                // Redirect after 2 seconds
                setTimeout(() => {
                    window.location.href = "/deliveries";
                }, 2000);
            })
            .catch(error => {
                console.error("Error:", error);
                showAlert("Failed to update delivery. Please try again.", "danger");
                showLoading(false);
            });
        }
        
        function showLoading(show) {
            document.getElementById("loading").style.display = show ? "flex" : "none";
        }
        
        function showAlert(message, type) {
            const alertContainer = document.getElementById("alert-container");
            alertContainer.innerHTML = "<div class=\"alert alert-" + type + " alert-dismissible fade show\" role=\"alert\">" +
                message +
                "<button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>" +
                "</div>";
            
            // Auto-dismiss after 5 seconds
            setTimeout(() => {
                const alert = document.querySelector(".alert");
                if (alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            }, 5000);
        }
    </script>
</body>
</html>