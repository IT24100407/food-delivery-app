<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - FoodExpress</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .login-container {
            max-width: 450px;
            margin: auto;
            padding: 2rem;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            margin-top: 2rem;
            margin-bottom: 2rem;
        }
        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .login-header img {
            width: 80px;
            margin-bottom: 1rem;
        }
        .form-control:focus {
            border-color: #ff6b6b;
            box-shadow: 0 0 0 0.25rem rgba(255, 107, 107, 0.25);
        }
        .btn-primary {
            background-color: #ff6b6b;
            border-color: #ff6b6b;
        }
        .btn-primary:hover, .btn-primary:focus {
            background-color: #ff5252;
            border-color: #ff5252;
        }
        .form-floating label {
            color: #6c757d;
        }
        .invalid-feedback {
            font-size: 80%;
        }
        .login-footer {
            text-align: center;
            margin-top: 1.5rem;
        }
        .login-footer a {
            color: #ff6b6b;
            text-decoration: none;
        }
        .login-footer a:hover {
            text-decoration: underline;
        }
        .alert {
            display: none;
        }
        .spinner-border {
            width: 1.5rem;
            height: 1.5rem;
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>
    <!-- Include Navbar -->
    <jsp:include page="../common/navbar.jsp" />
    
    <div class="container">
        <div class="login-container">
            <div class="login-header">
                <i class="fas fa-utensils fa-3x mb-3" style="color: #ff6b6b;"></i>
                <h2>Welcome Back</h2>
                <p class="text-muted">Sign in to continue to FoodExpress</p>
            </div>
            
            <div class="alert alert-danger" id="errorAlert" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <span id="errorMessage">Invalid email or password</span>
            </div>
            
            <form id="loginForm" novalidate>
                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" placeholder="name@example.com" required>
                    <label for="email">Email address</label>
                    <div class="invalid-feedback">
                        Please enter a valid email address.
                    </div>
                </div>
                
                <div class="form-floating mb-4">
                    <input type="password" class="form-control" id="password" placeholder="Password" required minlength="6">
                    <label for="password">Password</label>
                    <div class="invalid-feedback">
                        Password must be at least 6 characters.
                    </div>
                </div>
                
                <button class="btn btn-primary w-100 py-2" type="submit" id="loginButton">
                    <span id="loginSpinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    Sign In
                </button>
            </form>
            
            <div class="login-footer">
                <p>Don't have an account? <a href="/register">Sign up</a></p>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const loginForm = document.getElementById('loginForm');
            const loginButton = document.getElementById('loginButton');
            const loginSpinner = document.getElementById('loginSpinner');
            const errorAlert = document.getElementById('errorAlert');
            const errorMessage = document.getElementById('errorMessage');
            
            // Check if user is already logged in
            if (localStorage.getItem('userId')) {
                window.location.href = '/';
                return;
            }
            
            loginForm.addEventListener('submit', function(event) {
                event.preventDefault();
                
                // Reset previous error messages
                errorAlert.style.display = 'none';
                
                // Form validation
                if (!validateForm()) {
                    return;
                }
                
                // Show loading state
                setLoading(true);
                
                const email = document.getElementById('email').value;
                const password = document.getElementById('password').value;
                
                // Call login API
                fetch('/api/users/login?email=' + encodeURIComponent(email) + '&password=' + encodeURIComponent(password), {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Login failed');
                    }
                    return response.json();
                })
                .then(data => {
                    // Store user data in localStorage
                    localStorage.setItem('userId', data.userId);
                    
                    // Redirect to home page
                    window.location.href = '/';
                })
                .catch(error => {
                    console.error('Error:', error);
                    errorMessage.textContent = 'Invalid email or password. Please try again.';
                    errorAlert.style.display = 'block';
                })
                .finally(() => {
                    setLoading(false);
                });
            });
            
            function validateForm() {
                let isValid = true;
                const email = document.getElementById('email');
                const password = document.getElementById('password');
                
                // Reset validation state
                email.classList.remove('is-invalid');
                password.classList.remove('is-invalid');
                
                // Validate email
                if (!email.value || !isValidEmail(email.value)) {
                    email.classList.add('is-invalid');
                    isValid = false;
                }
                
                // Validate password
                if (!password.value || password.value.length < 6) {
                    password.classList.add('is-invalid');
                    isValid = false;
                }
                
                return isValid;
            }
            
            function isValidEmail(email) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            }
            
            function setLoading(isLoading) {
                if (isLoading) {
                    loginButton.disabled = true;
                    loginSpinner.classList.remove('d-none');
                } else {
                    loginButton.disabled = false;
                    loginSpinner.classList.add('d-none');
                }
            }
        });
    </script>
</body>
</html>