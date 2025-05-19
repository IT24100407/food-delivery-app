<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Cart</title>
    <script defer src="/js/cart.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen p-6">

<div class="max-w-4xl mx-auto bg-white rounded-2xl shadow p-6">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold">🛒 Your Cart</h1>
        <button onclick="window.history.back()" class="text-blue-600 underline">← Back</button>
    </div>

    <div id="cartContainer" class="space-y-4"></div>

    <div class="flex justify-between items-center mt-8">
        <button onclick="checkout()" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">
            Proceed to Checkout
        </button>
        <div id="totalAmount" class="text-xl font-semibold text-gray-800"></div>
    </div>
</div>

</body>
<script>
    document.addEventListener("DOMContentLoaded", loadCart);

    function loadCart() {
        const cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
        const container = document.getElementById("cartContainer");
        container.innerHTML = "";

        let total = 0;

        if (cartItems.length === 0) {
            container.innerHTML = "<p class='text-gray-500'>Your cart is empty.</p>";
            document.getElementById("totalAmount").innerText = "";
            return;
        }

        cartItems.forEach(item => {
            fetch("/api/food-items/" + item.id)
                .then(response => response.json())
                .then(data => {
                    total += data.price * item.quantity;

                    const itemElement = document.createElement("div");
                    itemElement.className = "flex items-center justify-between border p-4 rounded-lg shadow-sm bg-gray-50";

                    itemElement.innerHTML =
                        "<div class=\"flex items-center space-x-4\">" +
                        "<img src=\"" + data.image + "\" alt=\"" + data.name + "\" class=\"w-20 h-20 rounded object-cover\" />" +
                        "<div>" +
                        "<h2 class=\"text-lg font-semibold\">" + data.name + "</h2>" +
                        "<p class=\"text-gray-600\">$" + data.price + " x " + item.quantity + "</p>" +
                        "<div class=\"flex mt-2 space-x-2\">" +
                        "<button onclick=\"changeQuantity('" + item.id + "', -1)\" class=\"px-2 py-1 bg-gray-200 rounded hover:bg-gray-300\">-</button>" +
                        "<button onclick=\"changeQuantity('" + item.id + "', 1)\" class=\"px-2 py-1 bg-gray-200 rounded hover:bg-gray-300\">+</button>" +
                        "<button onclick=\"removeItem('" + item.id + "')\" class=\"px-2 py-1 bg-red-500 text-white rounded hover:bg-red-600\">Remove</button>" +
                        "</div>" +
                        "</div>" +
                        "</div>";

                    container.appendChild(itemElement);
                    document.getElementById("totalAmount").innerText = "Total: $" + total.toFixed(2);
                });
        });
    }

    function changeQuantity(itemId, delta) {
        const cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
        const item = cartItems.find(i => i.id === itemId);

        if (!item) return;

        item.quantity += delta;
        if (item.quantity <= 0) {
            const index = cartItems.indexOf(item);
            cartItems.splice(index, 1);
        }

        localStorage.setItem("cartItems", JSON.stringify(cartItems));
        loadCart();
    }

    function removeItem(itemId) {
        let cartItems = JSON.parse(localStorage.getItem("cartItems")) || [];
        cartItems = cartItems.filter(item => item.id !== itemId);
        localStorage.setItem("cartItems", JSON.stringify(cartItems));
        loadCart();
    }

    function checkout() {
        window.location.href = "/place-order";
    }

</script>
</html>
