<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-purple-100 to-blue-100 min-h-screen p-6">

<div class="max-w-6xl mx-auto">
    <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold text-purple-700">My Orders</h1>
        <a href="/" class="text-blue-600 hover:underline">← Back to Home</a>
    </div>

    <div id="loading" class="text-center py-10">
        <svg class="animate-spin h-10 w-10 text-purple-600 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
        </svg>
        <p class="text-purple-600 mt-2">Loading your orders...</p>
    </div>

    <div id="noOrders" class="hidden bg-white rounded-xl shadow-md p-8 text-center">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 text-gray-400 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
        <h2 class="text-xl font-semibold text-gray-700 mb-2">No Orders Found</h2>
        <p class="text-gray-500 mb-4">You haven't placed any orders yet.</p>
        <a href="/" class="inline-block bg-purple-600 text-white px-6 py-2 rounded-md hover:bg-purple-700 transition">Browse Menu</a>
    </div>

    <div id="ordersList" class="space-y-6 hidden"></div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const userId = localStorage.getItem('userId') || 'U3'; // Default user ID if none found
        fetchOrders(userId);
    });

    async function fetchOrders(userId) {
        try {
            const response = await fetch('/api/orders');
            if (!response.ok) {
                throw new Error('Failed to fetch orders');
            }
            
            const orders = await response.json();
            const userOrders = orders.filter(order => order.userId === userId);
            
            if (userOrders.length === 0) {
                document.getElementById('loading').classList.add('hidden');
                document.getElementById('noOrders').classList.remove('hidden');
                return;
            }
            
            await displayOrders(userOrders);
            
            document.getElementById('loading').classList.add('hidden');
            document.getElementById('ordersList').classList.remove('hidden');
        } catch (error) {
            console.error('Error fetching orders:', error);
            document.getElementById('loading').classList.add('hidden');
            document.getElementById('noOrders').classList.remove('hidden');
            document.getElementById('noOrders').innerHTML =
                "<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-16 w-16 text-red-500 mx-auto mb-4\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\">" +
                "<path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z\" />" +
                "</svg>" +
                "<h2 class=\"text-xl font-semibold text-gray-700 mb-2\">Error Loading Orders</h2>" +
                "<p class=\"text-gray-500 mb-4\">There was a problem loading your orders. Please try again later.</p>";
        }
    }

    async function displayOrders(orders) {
        const ordersList = document.getElementById('ordersList');
        ordersList.innerHTML = '';
        
        // Sort orders by date (newest first)
        orders.sort((a, b) => new Date(b.orderDate) - new Date(a.orderDate));
        
        for (const order of orders) {
            const orderCard = document.createElement('div');
            orderCard.className = 'bg-white rounded-xl shadow-md overflow-hidden';
            
            // Order header
            const orderHeader = document.createElement('div');
            orderHeader.className = 'p-6 border-b';
            
            const orderDate = new Date(order.orderDate).toLocaleString();
            const statusColor = getStatusColor(order.status);

            orderHeader.innerHTML =
                "<div class=\"flex justify-between items-center\">" +
                "<div>" +
                "<h3 class=\"text-lg font-semibold\">Order #" + order.orderId.substring(0, 8) + "</h3>" +
                "<p class=\"text-gray-500\">" + orderDate + "</p>" +
                "</div>" +
                "<div>" +
                "<span class=\"px-3 py-1 rounded-full text-sm font-medium " + statusColor + "\">" +
                order.status +
                "</span>" +
                "</div>" +
                "</div>" +
                "<div class=\"mt-2\">" +
                "<p class=\"text-gray-700\"><span class=\"font-medium\">Delivery Address:</span> " + order.address + "</p>" +
                "<p class=\"text-gray-700\"><span class=\"font-medium\">Payment Method:</span> " + order.paymentMethod + "</p>" +
                "</div>";
            
            orderCard.appendChild(orderHeader);
            
            // Order items
            const orderItems = document.createElement('div');
            orderItems.className = 'p-6';
            
            const itemsContainer = document.createElement('div');
            itemsContainer.className = 'space-y-4';
            
            // Fetch and display each ordered item
            for (const item of order.orderedItems) {
                const itemElement = await createOrderItemElement(item);
                itemsContainer.appendChild(itemElement);
            }
            
            orderItems.appendChild(itemsContainer);
            
            // Order total
            const orderTotal = document.createElement('div');
            orderTotal.className = 'mt-4 pt-4 border-t flex justify-between items-center';

            orderTotal.innerHTML =
                "<span class=\"font-medium text-gray-700\">Total</span>" +
                "<span class=\"font-bold text-lg\">$" + order.totalPrice.toFixed(2) + "</span>";
            orderItems.appendChild(orderTotal);
            orderCard.appendChild(orderItems);
            ordersList.appendChild(orderCard);
        }
    }

    async function createOrderItemElement(item) {
        const itemElement = document.createElement('div');
        itemElement.className = 'flex items-center space-x-4';
        
        try {
            // Fetch food item details
            const foodItem = await fetchFoodItem(item.foodItemId);
            itemElement.innerHTML =
                "<div class=\"flex-shrink-0 w-16 h-16 bg-gray-100 rounded-md overflow-hidden\">" +
                "<img src=\"" + foodItem.image + "\" alt=\"" + foodItem.name + "\" class=\"w-full h-full object-cover\">" +
                "</div>" +
                "<div class=\"flex-1\">" +
                "<h4 class=\"font-medium\">" + foodItem.name + "</h4>" +
                "<p class=\"text-sm text-gray-500\">" +
                (foodItem.description.substring(0, 50) + (foodItem.description.length > 50 ? '...' : '')) +
                "</p>" +
                "</div>" +
                "<div class=\"text-right\">" +
                "<p class=\"font-medium\">$" + item.price.toFixed(2) + " x " + item.quantity + "</p>" +
                "<p class=\"font-bold\">$" + (item.price * item.quantity).toFixed(2) + "</p>" +
                "</div>";

        } catch (error) {
            console.error('Error fetching food item:', error);

            itemElement.innerHTML =
                "<div class=\"flex-shrink-0 w-16 h-16 bg-gray-100 rounded-md flex items-center justify-center\">" +
                "<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-8 w-8 text-gray-400\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\">" +
                "<path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z\" />" +
                "</svg>" +
                "</div>" +
                "<div class=\"flex-1\">" +
                "<h4 class=\"font-medium\">Item #" + item.foodItemId.substring(0, 8) + "</h4>" +
                "<p class=\"text-sm text-gray-500\">Item details unavailable</p>" +
                "</div>" +
                "<div class=\"text-right\">" +
                "<p class=\"font-medium\">$" + item.price.toFixed(2) + " x " + item.quantity + "</p>" +
                "<p class=\"font-bold\">$" + (item.price * item.quantity).toFixed(2) + "</p>" +
                "</div>";

        }
        
        return itemElement;
    }

    async function fetchFoodItem(foodItemId) {
        const response = await fetch(`/api/food-items/`+foodItemId);
        if (!response.ok) {
            throw new Error('Failed to fetch food item');
        }
        return await response.json();
    }

    function getStatusColor(status) {
        switch (status.toLowerCase()) {
            case 'pending':
                return 'bg-yellow-100 text-yellow-800';
            case 'processing':
                return 'bg-blue-100 text-blue-800';
            case 'delivered':
                return 'bg-green-100 text-green-800';
            case 'cancelled':
                return 'bg-red-100 text-red-800';
            default:
                return 'bg-gray-100 text-gray-800';
        }
    }
</script>
</body>
</html>