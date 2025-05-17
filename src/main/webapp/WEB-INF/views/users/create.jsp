<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - FoodExpress</title>
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
        .register-container {
            max-width: 550px;
            margin: auto;
            padding: 2rem;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            margin-top: 2rem;
            margin-bottom: 2rem;
        }
        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .register-header img {
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
        .register-footer {
            text-align: center;
            margin-top: 1.5rem;
        }
        .register-footer a {
            color: #ff6b6b;
            text-decoration: none;
        }
        .register-footer a:hover {
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
        <div class="register-container">
            <div class="register-header">
                <i class="fas fa-utensils fa-3x mb-3" style="color: #ff6b6b;"></i>
                <h2>Create Account</h2>
                <p class="text-muted">Join FoodExpress for delicious meals delivered to your door</p>
            </div>
            
            <div class="alert alert-danger" id="errorAlert" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <span id="errorMessage">Registration failed</span>
            </div>
            
            <div class="alert alert-success" id="successAlert" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                Registration successful! Redirecting to login...
            </div>
            
            <form id="registerForm" novalidate>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="name" placeholder="Full Name" required>
                            <label for="name">Full Name</label>
                            <div class="invalid-feedback">
                                Please enter your name.
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="email" class="form-control" id="email" placeholder="name@example.com" required>
                            <label for="email">Email address</label>
                            <div class="invalid-feedback">
                                Please enter a valid email address.
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="password" class="form-control" id="password" placeholder="Password" required minlength="6">
                            <label for="password">Password</label>
                            <div class="invalid-feedback">
                                Password must be at least 6 characters.
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="password" class="form-control" id="confirmPassword" placeholder="Confirm Password" required>
                            <label for="confirmPassword">Confirm Password</label>
                            <div class="invalid-feedback">
                                Passwords do not match.
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="number" class="form-control" id="age" placeholder="Age" min="18" max="120">
                            <label for="age">Age (Optional)</label>
                            <div class="invalid-feedback">
                                Age must be between 18 and 120.
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <select class="form-select" id="gender">
                                <option value="" selected>Select gender (Optional)</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                            <label for="gender">Gender</label>
                        </div>
                    </div>
                </div>
                
                <div class="form-floating mb-4">
                    <textarea class="form-control" id="address" placeholder="Address" style="height: 100px"></textarea>
                    <label for="address">Delivery Address (Optional)</label>
                </div>
                
                <button class="btn btn-primary w-100 py-2" type="submit" id="registerButton">
                    <span id="registerSpinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    Create Account
                </button>
            </form>
            
            <div class="register-footer">
                <p>Already have an account? <a href="/login">Sign in</a></p>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const registerForm = document.getElementById('registerForm');
            const registerButton = document.getElementById('registerButton');
            const registerSpinner = document.getElementById('registerSpinner');
            const errorAlert = document.getElementById('errorAlert');
            const errorMessage = document.getElementById('errorMessage');
            const successAlert = document.getElementById('successAlert');
            
            // Check if user is already logged in
            if (localStorage.getItem('userId')) {
                window.location.href = '/';
                return;
            }
            
            registerForm.addEventListener('submit', function(event) {
                event.preventDefault();
                
                // Reset previous messages
                errorAlert.style.display = 'none';
                successAlert.style.display = 'none';
                
                // Form validation
                if (!validateForm()) {
                    return;
                }
                
                // Show loading state
                setLoading(true);
                
                // Prepare user data
                const userData = {
                    userId: generateUUID(),
                    name: document.getElementById('name').value,
                    email: document.getElementById('email').value,
                    password: document.getElementById('password').value,
                    age: document.getElementById('age').value ? parseInt(document.getElementById('age').value) : null,
                    gender: document.getElementById('gender').value,
                    address: document.getElementById('address').value
                };
                
                // Call register API
                fetch('/api/users', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(userData)
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Registration failed');
                    }
                    
                    // Show success message
                    successAlert.style.display = 'block';
                    
                    // Redirect to login page after 2 seconds
                    setTimeout(() => {
                        window.location.href = '/login';
                    }, 2000);
                })
                .catch(error => {
                    console.error('Error:', error);
                    errorMessage.textContent = 'Registration failed. Please try again.';
                    errorAlert.style.display = 'block';
                })
                .finally(() => {
                    setLoading(false);
                });
            });
            
            function validateForm() {
                let isValid = true;
                const name = document.getElementById('name');
                const email = document.getElementById('email');
                const password = document.getElementById('password');
                const confirmPassword = document.getElementById('confirmPassword');
                const age = document.getElementById('age');
                
                // Reset validation state
                name.classList.remove('is-invalid');
                email.classList.remove('is-invalid');
                password.classList.remove('is-invalid');
                confirmPassword.classList.remove('is-invalid');
                age.classList.remove('is-invalid');
                
                // Validate name
                if (!name.value.trim()) {
                    name.classList.add('is-invalid');
                    isValid = false;
                }
                
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
                
                // Validate confirm password
                if (password.value !== confirmPassword.value) {
                    confirmPassword.classList.add('is-invalid');
                    isValid = false;
                }
                
                // Validate age if provided
                if (age.value && (age.value < 18 || age.value > 120)) {
                    age.classList.add('is-invalid');
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
                    registerButton.disabled = true;
                    registerSpinner.classList.remove('d-none');
                } else {
                    registerButton.disabled = false;
                    registerSpinner.classList.add('d-none');
                }
            }
            
            // Generate UUID for user ID
            function generateUUID() {
                return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                    const r = Math.random() * 16 | 0;
                    const v = c === 'x' ? r : (r & 0x3 | 0x8);
                    return v.toString(16);
                });
            }
        });
    </script>
</body>
</html>