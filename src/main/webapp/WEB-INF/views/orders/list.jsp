<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Tailwind CSS -->
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
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
        .order-card {
            transition: all 0.3s ease;
        }
        .order-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        .modal-dialog.modal-lg {
            max-width: 800px;
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
                        <h1 class="mb-0">Orders Management</h1>
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
                        <input type="text" id="searchInput" class="form-control" placeholder="Search orders...">
                    </div>
                </div>
            </div>
        </div>

        <!-- Loading Indicator -->
        <div id="loading" class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">Loading orders...</p>
        </div>

        <!-- No Orders Message -->
        <div id="noOrders" class="text-center py-5 bg-white rounded shadow-sm hidden">
            <i class="fas fa-shopping-bag fa-3x text-gray-400 mb-3"></i>
            <h2 class="text-xl font-semibold text-gray-700 mb-2">No Orders Found</h2>
            <p class="text-gray-500 mb-4">There are no orders in the system yet.</p>
        </div>

        <!-- Orders List -->
        <div id="ordersList" class="row hidden">
            <!-- Orders will be loaded here dynamically -->
        </div>
    </div>

    <!-- Order Details Modal -->
    <div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="orderDetailsModalLabel">Order Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="orderDetailsContent">
                    <!-- Order details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="printInvoiceBtn">Print Invoice</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Order Status Modal -->
    <div class="modal fade" id="editStatusModal" tabindex="-1" aria-labelledby="editStatusModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editStatusModalLabel">Update Order Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editStatusForm">
                        <input type="hidden" id="editOrderId">
                        <div class="mb-3">
                            <label for="orderStatus" class="form-label">Status</label>
                            <select class="form-select" id="orderStatus" required>
                                <option value="Pending">Pending</option>
                                <option value="Completed">Completed</option>
                                <option value="Cancelled">Cancelled</option>
                                <option value="Delivered">Delivered</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveStatusBtn">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Order Confirmation Modal -->
    <div class="modal fade" id="deleteOrderModal" tabindex="-1" aria-labelledby="deleteOrderModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteOrderModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this order? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete Order</button>
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
        let allOrders = [];
        let currentOrderId = null;

        document.addEventListener('DOMContentLoaded', function() {
            // Fetch all orders
            fetchOrders();

            // Initialize search functionality
            document.getElementById("searchInput").addEventListener("keyup", function() {
                const value = this.value.toLowerCase();
                filterOrders(value);
            });

            // Export PDF button click
            document.getElementById("exportPdf").addEventListener("click", function() {
                exportToPdf();
            });

            // Save status changes
            document.getElementById("saveStatusBtn").addEventListener("click", function() {
                updateOrderStatus();
            });

            // Confirm delete
            document.getElementById("confirmDeleteBtn").addEventListener("click", function() {
                deleteOrder();
            });

            // Print invoice
            document.getElementById("printInvoiceBtn").addEventListener("click", function() {
                printInvoice(currentOrderId);
            });
        });

        async function fetchOrders() {
            try {
                const response = await fetch('/api/orders');
                if (!response.ok) {
                    throw new Error('Failed to fetch orders');
                }
                
                allOrders = await response.json();
                
                if (allOrders.length === 0) {
                    document.getElementById('loading').classList.add('hidden');
                    document.getElementById('noOrders').classList.remove('hidden');
                    return;
                }
                
                displayOrders(allOrders);
                
                document.getElementById('loading').classList.add('hidden');
                document.getElementById('ordersList').classList.remove('hidden');
            } catch (error) {
                console.error('Error fetching orders:', error);
                document.getElementById('loading').classList.add('hidden');
                alert('Failed to load orders. Please try again later.');
            }
        }

        function displayOrders(orders) {
            const ordersList = document.getElementById('ordersList');
            ordersList.innerHTML = '';
            
            orders.forEach(order => {
                const orderCard = document.createElement('div');
                orderCard.className = 'col-md-6 col-lg-4 mb-4';
                orderCard.innerHTML = createOrderCardHtml(order);
                ordersList.appendChild(orderCard);
            });

            // Add event listeners for action buttons
            document.querySelectorAll('.view-order').forEach(btn => {
                btn.addEventListener('click', function() {
                    const orderId = this.getAttribute('data-id');
                    viewOrderDetails(orderId);
                });
            });

            document.querySelectorAll('.edit-status').forEach(btn => {
                btn.addEventListener('click', function() {
                    const orderId = this.getAttribute('data-id');
                    const currentStatus = this.getAttribute('data-status');
                    openEditStatusModal(orderId, currentStatus);
                });
            });

            document.querySelectorAll('.delete-order').forEach(btn => {
                btn.addEventListener('click', function() {
                    const orderId = this.getAttribute('data-id');
                    openDeleteModal(orderId);
                });
            });
        }

        function createOrderCardHtml(order) {
            const orderDate = new Date(order.orderDate).toLocaleString();
            const statusColor = getStatusColor(order.status);
            return (
                "<div class=\"card order-card h-100\">" +
                "<div class=\"card-header d-flex justify-content-between align-items-center\">" +
                "<h5 class=\"mb-0\">Order #" + order.orderId.substring(0, 8) + "</h5>" +
                "<span class=\"badge " + statusColor + "\">" + order.status + "</span>" +
                "</div>" +
                "<div class=\"card-body\">" +
                "<p><strong>Customer:</strong> " + order.customerName + "</p>" +
                "<p><strong>Date:</strong> " + orderDate + "</p>" +
                "<p><strong>Total:</strong> $" + order.totalPrice.toFixed(2) + "</p>" +
                "<p><strong>Payment:</strong> " + order.paymentMethod + "</p>" +
                "</div>" +
                "<div class=\"card-footer d-flex justify-content-between\">" +
                "<button class=\"btn btn-sm btn-outline-primary view-order\" data-id=\"" + order.orderId + "\">" +
                "<i class=\"fas fa-eye\"></i> View" +
                "</button>" +
                "<button class=\"btn btn-sm btn-outline-secondary edit-status\" data-id=\"" + order.orderId + "\" data-status=\"" + order.status + "\">" +
                "<i class=\"fas fa-edit\"></i> Status" +
                "</button>" +
                "<button class=\"btn btn-sm btn-outline-danger delete-order\" data-id=\"" + order.orderId + "\">" +
                "<i class=\"fas fa-trash\"></i> Delete" +
                "</button>" +
                "</div>" +
                "</div>"
            );

        }

        function getStatusColor(status) {
            switch (status.toLowerCase()) {
                case 'pending':
                    return 'bg-warning text-dark';
                case 'completed':
                    return 'bg-success text-white';
                case 'cancelled':
                    return 'bg-danger text-white';
                case 'delivered':
                    return 'bg-info text-white';
                default:
                    return 'bg-secondary text-white';
            }
        }

        async function viewOrderDetails(orderId) {
            currentOrderId = orderId;
            const order = allOrders.find(o => o.orderId === orderId);
            
            if (!order) {
                alert('Order not found');
                return;
            }
            
            const modalContent = document.getElementById('orderDetailsContent');
            modalContent.innerHTML = '<div class="text-center"><div class="spinner-border" role="status"></div><p>Loading order details...</p></div>';
            
            const orderDetailsModal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
            orderDetailsModal.show();
            
            try {
                const orderDetails = await buildOrderDetailsHtml(order);
                modalContent.innerHTML = orderDetails;
            } catch (error) {
                console.error('Error loading order details:', error);
                modalContent.innerHTML = '<div class="alert alert-danger">Failed to load order details</div>';
            }
        }

        async function buildOrderDetailsHtml(order) {
            const orderDate = new Date(order.orderDate).toLocaleString();
            const statusColor = getStatusColor(order.status);
            
            let itemsHtml = '<div class="table-responsive mt-4"><table class="table table-striped">';
            itemsHtml += '<thead><tr><th>Item</th><th>Price</th><th>Quantity</th><th>Subtotal</th></tr></thead><tbody>';
            
            for (const item of order.orderedItems) {
                try {
                    const foodItem = await fetchFoodItem(item.foodItemId);
                    itemsHtml +=
                        "<tr>" +
                        "<td>" +
                        "<div class=\"d-flex align-items-center\">" +
                        "<img src=\"" + foodItem.image + "\" alt=\"" + foodItem.name + "\" class=\"me-2\" style=\"width: 50px; height: 50px; object-fit: cover; border-radius: 4px;\">" +
                        "<div>" +
                        "<h6 class=\"mb-0\">" + foodItem.name + "</h6>" +
                        "<small class=\"text-muted\">" +
                        (foodItem.description.substring(0, 50) + (foodItem.description.length > 50 ? '...' : '')) +
                        "</small>" +
                        "</div>" +
                        "</div>" +
                        "</td>" +
                        "<td>$" + item.price.toFixed(2) + "</td>" +
                        "<td>" + item.quantity + "</td>" +
                        "<td>$" + (item.price * item.quantity).toFixed(2) + "</td>" +
                        "</tr>";
                } catch (error) {
                    console.error('Error fetching food item:', error);

                }
            }

            itemsHtml += '</tbody></table></div>';
            return (
                "<div class=\"order-details\">" +
                "<div class=\"row mb-4\">" +
                "<div class=\"col-md-6\">" +
                "<h5>Order Information</h5>" +
                "<p><strong>Order ID:</strong> " + order.orderId + "</p>" +
                "<p><strong>Date:</strong> " + orderDate + "</p>" +
                "<p><strong>Status:</strong> <span class=\"badge " + statusColor + "\">" + order.status + "</span></p>" +
                "<p><strong>Payment Method:</strong> " + order.paymentMethod + "</p>" +
                "</div>" +
                "<div class=\"col-md-6\">" +
                "<h5>Customer Information</h5>" +
                "<p><strong>Name:</strong> " + order.customerName + "</p>" +
                "<p><strong>Email:</strong> " + (order.customerEmail || 'N/A') + "</p>" +
                "<p><strong>Phone:</strong> " + (order.customerPhone || 'N/A') + "</p>" +
                "<p><strong>Address:</strong> " + order.address + "</p>" +
                "</div>" +
                "</div>" +

                "<h5>Ordered Items</h5>" +
                itemsHtml +

                "<div class=\"row mt-4\">" +
                "<div class=\"col-md-6 offset-md-6\">" +
                "<table class=\"table\">" +
                "<tr>" +
                "<td><strong>Total:</strong></td>" +
                "<td class=\"text-end\"><strong>$" + order.totalPrice.toFixed(2) + "</strong></td>" +
                "</tr>" +
                "</table>" +
                "</div>" +
                "</div>" +
                "</div>"
            );

        }

        function openEditStatusModal(orderId, currentStatus) {
            currentOrderId = orderId;
            document.getElementById('editOrderId').value = orderId;
            document.getElementById('orderStatus').value = currentStatus;
            
            const editStatusModal = new bootstrap.Modal(document.getElementById('editStatusModal'));
            editStatusModal.show();
        }

        function openDeleteModal(orderId) {
            currentOrderId = orderId;
            
            const deleteOrderModal = new bootstrap.Modal(document.getElementById('deleteOrderModal'));
            deleteOrderModal.show();
        }

        async function updateOrderStatus() {
            const orderId = document.getElementById('editOrderId').value;
            const newStatus = document.getElementById('orderStatus').value;
            
            try {
                const response = await fetch("/api/orders/" + orderId + "/status", {
                    method: 'PATCH',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ status: newStatus })
                });
                
                if (!response.ok) {
                    throw new Error('Failed to update order status');
                }
                
                // Close modal
                const editStatusModal = bootstrap.Modal.getInstance(document.getElementById('editStatusModal'));
                editStatusModal.hide();
                
                // Refresh orders
                fetchOrders();
                
                alert('Order status updated successfully');
            } catch (error) {
                console.error('Error updating order status:', error);
                alert('Failed to update order status. Please try again.');
            }
        }

        async function deleteOrder() {
            try {
                const response = await fetch(`/api/orders/`+currentOrderId, {
                    method: 'DELETE'
                });
                
                if (!response.ok) {
                    throw new Error('Failed to delete order');
                }
                
                // Close modal
                const deleteOrderModal = bootstrap.Modal.getInstance(document.getElementById('deleteOrderModal'));
                deleteOrderModal.hide();
                
                // Refresh orders
                fetchOrders();
                
                alert('Order deleted successfully');
            } catch (error) {
                console.error('Error deleting order:', error);
                alert('Failed to delete order. Please try again.');
            }
        }

        function filterOrders(searchTerm) {
            if (!searchTerm) {
                displayOrders(allOrders);
                return;
            }
            
            const filteredOrders = allOrders.filter(order => {
                return (
                    (order.orderId && order.orderId.toLowerCase().includes(searchTerm)) ||
                    (order.customerName && order.customerName.toLowerCase().includes(searchTerm)) ||
                    (order.customerEmail && order.customerEmail.toLowerCase().includes(searchTerm)) ||
                    (order.status && order.status.toLowerCase().includes(searchTerm)) ||
                    (order.paymentMethod && order.paymentMethod.toLowerCase().includes(searchTerm))
                );
            });
            
            displayOrders(filteredOrders);
        }

        async function fetchFoodItem(foodItemId) {
            const response = await fetch(`/api/food-items/`+foodItemId);
            if (!response.ok) {
                throw new Error('Failed to fetch food item');
            }
            return await response.json();
        }

        function printInvoice(orderId) {
            const order = allOrders.find(o => o.orderId === orderId);
            if (!order) {
                alert('Order not found');
                return;
            }
            
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            
            // Add title
            doc.setFontSize(20);
            doc.text("INVOICE", 105, 20, null, null, "center");
            
            // Add order info
            doc.setFontSize(12);
            doc.text("Order #: " + order.orderId, 14, 40);
            doc.text("Date: " + new Date(order.orderDate).toLocaleString(), 14, 48);
            doc.text("Status: " + order.status, 14, 56);

// Add customer info
            doc.text("Bill To:", 14, 70);
            doc.text("" + order.customerName, 14, 78);
            doc.text("" + order.address, 14, 86);
            doc.text("Phone: " + (order.customerPhone || 'N/A'), 14, 94);
            doc.text("Email: " + (order.customerEmail || 'N/A'), 14, 102);
            
            // Create table for items
            const tableColumn = ["Item", "Price", "Qty", "Total"];
            const tableRows = [];
            
            // Add items to table
            order.orderedItems.forEach(item => {
                const itemData = [
                    "Item #" + item.foodItemId.substring(0, 8),
                    "$" + item.price.toFixed(2),
                    item.quantity,
                    "$" + (item.price * item.quantity).toFixed(2)
                ];
                tableRows.push(itemData);
            });
            
            // Generate table
            doc.autoTable({
                head: [tableColumn],
                body: tableRows,
                startY: 115,
                theme: 'grid',
                styles: {
                    fontSize: 10,
                    cellPadding: 3
                },
                headStyles: {
                    fillColor: [66, 66, 66]
                }
            });
            
            // Add total
            const finalY = doc.lastAutoTable.finalY + 10;
            doc.text("Total Amount: $" + order.totalPrice.toFixed(2), 150, finalY, null, null, "right");

// Add footer
            doc.setFontSize(10);
            doc.text("Thank you for your business!", 105, finalY + 20, null, null, "center");

// Save PDF
            doc.save("invoice_" + order.orderId + ".pdf");
        }

        function exportToPdf() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            
            // Add title
            doc.setFontSize(18);
            doc.text("Orders List", 14, 22);
            
            // Add date
            doc.setFontSize(11);
            doc.text("Generated: " + new Date().toLocaleString(), 14, 30);
            
            // Create table
            const tableColumn = ["Order ID", "Customer", "Date", "Status", "Total"];
            const tableRows = [];
            
            allOrders.forEach(order => {
                const orderDate = new Date(order.orderDate).toLocaleString();
                const itemData = [
                    order.orderId.substring(0, 8),
                    order.customerName,
                    orderDate,
                    order.status,
                    order.totalPrice.toFixed(2)
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
                    0: { cellWidth: 30 },
                    1: { cellWidth: 40 },
                    2: { cellWidth: 40 },
                    3: { cellWidth: 30 },
                    4: { cellWidth: 30 }
                }
            });
            
            // Save PDF
            doc.save("orders_list.pdf");
        }
    </script>
</body>
</html>