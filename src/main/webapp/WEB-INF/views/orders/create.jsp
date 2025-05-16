<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Place Order</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-purple-100 to-blue-100 min-h-screen flex items-center justify-center p-6">

<div class="w-full max-w-xl bg-white rounded-3xl shadow-xl p-8 space-y-6">
    <div class="flex justify-between items-center">
        <h1 class="text-3xl font-bold text-purple-700">Place Your Order</h1>
        <a href="/" class="text-blue-600 hover:underline">← Back</a>
    </div>

    <div id="orderSummary" class="border rounded-lg p-4 bg-gray-50">
        <h2 class="text-xl font-semibold mb-2">Order Summary</h2>
        <div id="orderItems" class="space-y-2 mb-3"></div>
        <div class="flex justify-between font-bold text-lg border-t pt-2">
            <span>Total:</span>
            <span id="orderTotal">$0.00</span>
        </div>
    </div>

    <div id="orderForm" class="space-y-4">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
                <label class="block text-gray-700 mb-1" for="name">Full Name</label>
                <input type="text" id="name" class="w-full border border-gray-300 rounded-md p-2 focus:ring-2 focus:ring-purple-500 focus:border-transparent" placeholder="John Doe" required>
                <p id="nameError" class="text-red-500 text-sm hidden">Please enter a valid name</p>
            </div>
            
            <div>
                <label class="block text-gray-700 mb-1" for="phone">Phone Number</label>
                <input type="tel" id="phone" class="w-full border border-gray-300 rounded-md p-2 focus:ring-2 focus:ring-purple-500 focus:border-transparent" placeholder="123-456-7890" required>
                <p id="phoneError" class="text-red-500 text-sm hidden">Please enter a valid phone number</p>
            </div>
        </div>

        <div>
            <label class="block text-gray-700 mb-1" for="address">Delivery Address</label>
            <textarea id="address" class="w-full border border-gray-300 rounded-md p-2 focus:ring-2 focus:ring-purple-500 focus:border-transparent" rows="2" placeholder="123 Main St, City, Country" required></textarea>
            <p id="addressError" class="text-red-500 text-sm hidden">Please enter a valid address (min 10 characters)</p>
        </div>

        <div>
            <label class="block text-gray-700 mb-1" for="email">Email</label>
            <input type="email" id="email" class="w-full border border-gray-300 rounded-md p-2 focus:ring-2 focus:ring-purple-500 focus:border-transparent" placeholder="your@email.com" required>
            <p id="emailError" class="text-red-500 text-sm hidden">Please enter a valid email address</p>
        </div>

        <div>
            <label class="block text-gray-700 mb-1" for="paymentMethod">Payment Method</label>
            <select id="paymentMethod" class="w-full border border-gray-300 rounded-md p-2 focus:ring-2 focus:ring-purple-500 focus:border-transparent">
                <option value="Card">Card</option>
                <option value="Cash">Cash on Delivery</option>
                <option value="UPI">UPI</option>
            </select>
        </div>

        <button id="placeOrderBtn" class="bg-purple-600 text-white w-full py-3 rounded-md hover:bg-purple-700 transition font-semibold">
            Place Order
        </button>
    </div>

    <div id="loading" class="text-center hidden">
        <svg class="animate-spin h-10 w-10 text-purple-600 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
        </svg>
        <p class="text-purple-600 mt-2">Processing your order...</p>
    </div>

    <div id="alertBox" class="hidden p-4 rounded text-white text-center"></div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        loadCartItems();
        
        document.getElementById('placeOrderBtn').addEventListener('click', function(e) {
            e.preventDefault();
            if (validateForm()) {
                placeOrder();
            }
        });
    });

    function loadCartItems() {
        const cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
        const orderItems = document.getElementById("orderItems");
        const orderTotal = document.getElementById("orderTotal");
        
        if (cartItems.length === 0) {
            orderItems.innerHTML = "<p class='text-gray-500'>Your cart is empty.</p>";
            orderTotal.innerText = "$0.00";
            document.getElementById("placeOrderBtn").disabled = true;
            document.getElementById("placeOrderBtn").classList.add("opacity-50");
            return;
        }
        
        let total = 0;
        orderItems.innerHTML = "";
        
        cartItems.forEach(item => {
            total += item.price * item.quantity;
            
            const itemElement = document.createElement("div");
            itemElement.className = "flex justify-between items-center";
            itemElement.innerHTML =
                "<span>" + item.name + " x " + item.quantity + "</span>" +
                "<span>$" + (item.price * item.quantity).toFixed(2) + "</span>";
            orderItems.appendChild(itemElement);
        });

        orderTotal.innerText = "$" + total.toFixed(2);
    }

    function validateForm() {
        let isValid = true;
        
        // Name validation
        const name = document.getElementById("name").value;
        const nameRegex = /^[a-zA-Z\s]{2,50}$/;
        if (!nameRegex.test(name)) {
            document.getElementById("nameError").classList.remove("hidden");
            isValid = false;
        } else {
            document.getElementById("nameError").classList.add("hidden");
        }
        
        // Phone validation
        const phone = document.getElementById("phone").value;
        const phoneRegex = /^[0-9]{3}-?[0-9]{3}-?[0-9]{4}$/;
        if (!phoneRegex.test(phone)) {
            document.getElementById("phoneError").classList.remove("hidden");
            isValid = false;
        } else {
            document.getElementById("phoneError").classList.add("hidden");
        }
        
        // Address validation
        const address = document.getElementById("address").value;
        if (address.length < 10) {
            document.getElementById("addressError").classList.remove("hidden");
            isValid = false;
        } else {
            document.getElementById("addressError").classList.add("hidden");
        }
        
        // Email validation
        const email = document.getElementById("email").value;
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(email)) {
            document.getElementById("emailError").classList.remove("hidden");
            isValid = false;
        } else {
            document.getElementById("emailError").classList.add("hidden");
        }
        
        return isValid;
    }

    function placeOrder() {
        const name = document.getElementById("name").value;
        const phone = document.getElementById("phone").value;
        const address = document.getElementById("address").value;
        const email = document.getElementById("email").value;
        const paymentMethod = document.getElementById("paymentMethod").value;
        const cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];

        if (cartItems.length === 0) {
            showAlert("Your cart is empty.", "bg-red-500");
            return;
        }

        const orderedItems = cartItems.map(item => ({
            foodItemId: item.id,
            quantity: item.quantity,
            price: item.price
        }));

        const totalPrice = orderedItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);

        const orderPayload = {
            orderId: "O" + Date.now(),
            userId: localStorage.getItem("userId"),
            totalPrice: parseFloat(totalPrice.toFixed(2)),
            paymentMethod: paymentMethod,
            address: address,
            orderedItems: orderedItems,
            customerName: name,
            customerPhone: phone,
            customerEmail: email
        };

        toggleLoading(true);

        fetch("/api/orders", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(orderPayload)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Failed to place order");
            }
            return response.json();
        })
        .then(data => {
            localStorage.removeItem("cartItems");
            showAlert("Order placed successfully! 🎉", "bg-green-500");
            setTimeout(() => {
                window.location.href = "/";
            }, 2000);
        })
        .catch(error => {
            console.error("Order Error:", error);
            showAlert("Something went wrong. Please try again.", "bg-red-500");
        })
        .finally(() => {
            toggleLoading(false);
        });
    }

    function toggleLoading(show) {
        document.getElementById("orderForm").style.display = show ? "none" : "block";
        document.getElementById("orderSummary").style.display = show ? "none" : "block";
        document.getElementById("loading").classList.toggle("hidden", !show);
    }

    function showAlert(message, bgColor) {
        const alertBox = document.getElementById("alertBox");
        alertBox.className = "p-4 rounded text-white text-center mt-4 " + bgColor;
        alertBox.innerText = message;
        alertBox.classList.remove("hidden");

        setTimeout(() => {
            alertBox.classList.add("hidden");
        }, 4000);
    }
</script>
</body>
</html>
