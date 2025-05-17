<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Delivery</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-purple-100 to-blue-100 min-h-screen p-6">

<div class="max-w-4xl mx-auto">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-purple-700">Create Delivery</h1>
        <a href="/deliveries" class="text-blue-600 hover:underline flex items-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M9.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L7.414 9H15a1 1 0 110 2H7.414l2.293 2.293a1 1 0 010 1.414z" clip-rule="evenodd" />
            </svg>
            Back to Deliveries
        </a>
    </div>

    <div class="bg-white rounded-xl shadow-md overflow-hidden">
        <div class="p-6">
            <div id="loading" class="hidden text-center py-10">
                <svg class="animate-spin h-10 w-10 text-purple-600 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
                </svg>
                <p class="text-purple-600 mt-2">Loading...</p>
            </div>

            <div id="orderSelectContainer" class="mb-6">
                <label for="orderId" class="block text-gray-700 font-medium mb-2">Select Order</label>
                <select id="orderId" class="w-full border border-gray-300 rounded-md p-3 focus:ring-2 focus:ring-purple-500 focus:border-transparent">
                    <option value="">-- Select an order --</option>
                </select>
                <p id="orderIdError" class="text-red-500 text-sm mt-1 hidden">Please select an order</p>
            </div>

            <div id="orderDetails" class="mb-6 p-4 bg-gray-50 rounded-lg hidden">
                <h3 class="font-semibold text-lg mb-2">Order Details</h3>
                <div id="orderInfo" class="space-y-2">
                    <!-- Order details will be populated here -->
                </div>
            </div>

            <form id="deliveryForm" class="space-y-4">
                <div>
                    <label for="deliveryAddress" class="block text-gray-700 font-medium mb-2">Delivery Address</label>
                    <input type="text" id="deliveryAddress" class="w-full border border-gray-300 rounded-md p-3 focus:ring-2 focus:ring-purple-500 focus:border-transparent" placeholder="Enter delivery address">
                    <p id="addressError" class="text-red-500 text-sm mt-1 hidden">Please enter a valid address</p>
                </div>

                <div>
                    <label for="estimatedDeliveryTime" class="block text-gray-700 font-medium mb-2">Estimated Delivery Time</label>
                    <input type="datetime-local" id="estimatedDeliveryTime" class="w-full border border-gray-300 rounded-md p-3 focus:ring-2 focus:ring-purple-500 focus:border-transparent">
                    <p id="timeError" class="text-red-500 text-sm mt-1 hidden">Please select a valid delivery time</p>
                </div>

                <div>
                    <label for="deliveryStatus" class="block text-gray-700 font-medium mb-2">Delivery Status</label>
                    <select id="deliveryStatus" class="w-full border border-gray-300 rounded-md p-3 focus:ring-2 focus:ring-purple-500 focus:border-transparent">
                        <option value="Pending">Pending</option>
                        <option value="In Transit">In Transit</option>
                        <option value="Delivered">Delivered</option>
                    </select>
                </div>

                <button type="submit" id="submitBtn" class="w-full bg-purple-600 text-white py-3 px-4 rounded-md hover:bg-purple-700 transition duration-200 font-medium">
                    Create Delivery
                </button>
            </form>
        </div>
    </div>

    <div id="alertBox" class="hidden mt-4 p-4 rounded text-white text-center"></div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Load orders when page loads
        loadOrders();
        
        // Set up event listeners
        document.getElementById('orderId').addEventListener('change', function() {
            const selectedOrderId = this.value;
            if (selectedOrderId) {
                showOrderDetails(selectedOrderId);
            } else {
                document.getElementById('orderDetails').classList.add('hidden');
            }
        });
        
        document.getElementById('deliveryForm').addEventListener('submit', function(e) {
            e.preventDefault();
            if (validateForm()) {
                createDelivery();
            }
        });
    });
    
    function toggleLoading(show) {
        document.getElementById('loading').classList.toggle('hidden', !show);
        document.getElementById('orderSelectContainer').classList.toggle('hidden', show);
        document.getElementById('deliveryForm').classList.toggle('hidden', show);
        if (document.getElementById('orderDetails').classList.contains('hidden') === false) {
            document.getElementById('orderDetails').classList.toggle('hidden', show);
        }
    }
    
    function loadOrders() {
        toggleLoading(true);
        
        fetch('/api/orders')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to fetch orders');
                }
                return response.json();
            })
            .then(orders => {
                const orderSelect = document.getElementById('orderId');
                
                // Filter orders that are in "Pending" status
                const pendingOrders = orders.filter(order => order.status === 'Pending');
                
                if (pendingOrders.length === 0) {
                    showAlert('No pending orders available for delivery', 'bg-yellow-500');
                }
                
                pendingOrders.forEach(order => {
                    const option = document.createElement('option');
                    option.value = order.orderId;
                    option.textContent = "Order #" + order.orderId.substring(0, 8) + " - " + new Date(order.orderDate).toLocaleString();
                    orderSelect.appendChild(option);
                });
            })
            .catch(error => {
                console.error('Error loading orders:', error);
                showAlert('Failed to load orders. Please try again.', 'bg-red-500');
            })
            .finally(() => {
                toggleLoading(false);
            });
    }
    
    function showOrderDetails(orderId) {
        toggleLoading(true);
        
        fetch(`/api/orders/`+orderId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to fetch order details');
                }
                return response.json();
            })
            .then(order => {
                const orderInfo = document.getElementById('orderInfo');
                orderInfo.innerHTML =
                    "<p><span class=\"font-medium\">Order ID:</span> " + order.orderId + "</p>" +
                    "<p><span class=\"font-medium\">Date:</span> " + new Date(order.orderDate).toLocaleString() + "</p>" +
                    "<p><span class=\"font-medium\">Customer ID:</span> " + order.userId + "</p>" +
                    "<p><span class=\"font-medium\">Total:</span> $" + order.totalPrice.toFixed(2) + "</p>" +
                    "<p><span class=\"font-medium\">Payment Method:</span> " + order.paymentMethod + "</p>" +
                    "<p><span class=\"font-medium\">Address:</span> " + order.address + "</p>";
                
                // Pre-fill the delivery address with the order address
                document.getElementById('deliveryAddress').value = order.address;
                
                // Set default estimated delivery time to 2 hours from now
                const twoHoursLater = new Date();
                twoHoursLater.setHours(twoHoursLater.getHours() + 2);
                
                // Format date for datetime-local input
                const formattedDate = twoHoursLater.toISOString().slice(0, 16);
                document.getElementById('estimatedDeliveryTime').value = formattedDate;
                
                document.getElementById('orderDetails').classList.remove('hidden');
            })
            .catch(error => {
                console.error('Error loading order details:', error);
                showAlert('Failed to load order details', 'bg-red-500');
            })
            .finally(() => {
                toggleLoading(false);
            });
    }
    
    function validateForm() {
        let isValid = true;
        
        // Validate order selection
        const orderId = document.getElementById('orderId').value;
        if (!orderId) {
            document.getElementById('orderIdError').classList.remove('hidden');
            isValid = false;
        } else {
            document.getElementById('orderIdError').classList.add('hidden');
        }
        
        // Validate delivery address (at least 5 characters)
        const address = document.getElementById('deliveryAddress').value;
        const addressRegex = /^.{5,}$/;
        if (!addressRegex.test(address)) {
            document.getElementById('addressError').classList.remove('hidden');
            isValid = false;
        } else {
            document.getElementById('addressError').classList.add('hidden');
        }
        
        // Validate estimated delivery time
        const deliveryTime = document.getElementById('estimatedDeliveryTime').value;
        if (!deliveryTime) {
            document.getElementById('timeError').classList.remove('hidden');
            isValid = false;
        } else {
            document.getElementById('timeError').classList.add('hidden');
        }
        
        return isValid;
    }
    
    function createDelivery() {
        toggleLoading(true);
        
        const orderId = document.getElementById('orderId').value;
        const deliveryAddress = document.getElementById('deliveryAddress').value;
        const estimatedDeliveryTime = new Date(document.getElementById('estimatedDeliveryTime').value).toISOString();
        const deliveryStatus = document.getElementById('deliveryStatus').value;
        
        const deliveryData = {
            deliveryId: generateUUID(),
            orderId: orderId,
            estimatedDeliveryTime: estimatedDeliveryTime,
            deliveryStatus: deliveryStatus,
            deliveryAddress: deliveryAddress,
            actualDeliveryTime: null
        };
        
        fetch('/api/deliveries', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(deliveryData)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to create delivery');
            }
            
            // Also update the order status to "In Delivery"
            return fetch("/api/orders/" + orderId + "/status", {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ status: 'In Delivery' })
            });
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to update order status');
            }
            
            showAlert('Delivery created successfully!', 'bg-green-500');
            
            // Redirect to deliveries list after 2 seconds
            setTimeout(() => {
                window.location.href = '/deliveries';
            }, 2000);
        })
        .catch(error => {
            console.error('Error creating delivery:', error);
            showAlert('Failed to create delivery. Please try again.', 'bg-red-500');
        })
        .finally(() => {
            toggleLoading(false);
        });
    }
    
    function showAlert(message, bgColor) {
        const alertBox = document.getElementById('alertBox');
        alertBox.className = `p-4 rounded text-white text-center mt-4 `+bgColor;
        alertBox.textContent = message;
        alertBox.classList.remove('hidden');
        
        setTimeout(() => {
            alertBox.classList.add('hidden');
        }, 5000);
    }
    
    // Helper function to generate UUID
    function generateUUID() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            const r = Math.random() * 16 | 0;
            const v = c === 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }
</script>
</body>
</html>