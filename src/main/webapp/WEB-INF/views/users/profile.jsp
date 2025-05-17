<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - FoodExpress</title>
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
        .profile-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0;
        }
        .profile-header {
            background-color: #ff6b6b;
            color: white;
            padding: 2rem;
            border-radius: 10px 10px 0 0;
        }
        .profile-avatar {
            width: 100px;
            height: 100px;
            background-color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: #ff6b6b;
            margin-right: 1.5rem;
        }
        .profile-content {
            background-color: white;
            padding: 2rem;
            border-radius: 0 0 10px 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .profile-section {
            margin-bottom: 2rem;
        }
        .profile-section:last-child {
            margin-bottom: 0;
        }
        .section-title {
            color: #343a40;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #dee2e6;
        }
        .info-item {
            margin-bottom: 1rem;
        }
        .info-label {
            font-weight: 600;
            color: #6c757d;
        }
        .btn-edit {
            background-color: #ff6b6b;
            border-color: #ff6b6b;
        }
        .btn-edit:hover, .btn-edit:focus {
            background-color: #ff5252;
            border-color: #ff5252;
        }
        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }
        .form-control:focus {
            border-color: #ff6b6b;
            box-shadow: 0 0 0 0.25rem rgba(255, 107, 107, 0.25);
        }
        .invalid-feedback {
            font-size: 80%;
        }
        .spinner-border {
            width: 1.5rem;
            height: 1.5rem;
        }
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            visibility: hidden;
            opacity: 0;
            transition: visibility 0s, opacity 0.3s;
        }
        .loading-overlay.show {
            visibility: visible;
            opacity: 1;
        }
        .loading-spinner {
            background-color: white;
            padding: 2rem;
            border-radius: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Include Navbar -->
    <jsp:include page="../common/navbar.jsp" />
    
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <div class="spinner-border text-primary mb-3" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mb-0" id="loadingMessage">Loading your profile...</p>
        </div>
    </div>
    
    <div class="container">
        <div class="profile-container">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="d-flex align-items-center">
                    <div class="profile-avatar" id="profileAvatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <h1 id="profileName">Loading...</h1>
                        <p class="mb-0" id="profileEmail">Please wait...</p>
                    </div>
                </div>
            </div>
            
            <!-- Profile Content -->
            <div class="profile-content">
                <!-- Personal Information Section -->
                <div class="profile-section">
                    <h3 class="section-title">Personal Information</h3>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">Full Name</div>
                                <div id="infoName">Loading...</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">Email Address</div>
                                <div id="infoEmail">Loading...</div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">Age</div>
                                <div id="infoAge">Loading...</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">Gender</div>
                                <div id="infoGender">Loading...</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Delivery Information Section -->
                <div class="profile-section">
                    <h3 class="section-title">Delivery Information</h3>
                    <div class="info-item">
                        <div class="info-label">Delivery Address</div>
                        <div id="infoAddress">Loading...</div>
                    </div>
                </div>
                
                <!-- Account Actions Section -->
                <div class="profile-section">
                    <h3 class="section-title">Account Actions</h3>
                    <div class="d-flex flex-wrap gap-2">
                        <button class="btn btn-primary btn-edit" id="editProfileBtn">
                            <i class="fas fa-user-edit me-2"></i>Edit Profile
                        </button>
                        <button class="btn btn-danger" id="deleteAccountBtn">
                            <i class="fas fa-user-times me-2"></i>Delete Account
                        </button>
                        <button class="btn btn-secondary" id="logoutBtn">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editProfileModalLabel">Edit Profile</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editProfileForm" novalidate>
                        <input type="hidden" id="editUserId">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="editName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="editName" required>
                                <div class="invalid-feedback">
                                    Please enter your name.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="editEmail" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="editEmail" required>
                                <div class="invalid-feedback">
                                    Please enter a valid email address.
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="editAge" class="form-label">Age</label>
                                <input type="number" class="form-control" id="editAge" min="18" max="120">
                                <div class="invalid-feedback">
                                    Age must be between 18 and 120.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="editGender" class="form-label">Gender</label>
                                <select class="form-select" id="editGender">
                                    <option value="">Select gender</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editAddress" class="form-label">Delivery Address</label>
                            <textarea class="form-control" id="editAddress" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveProfileBtn">Save Changes</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Account Confirmation Modal -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteAccountModalLabel">Delete Account</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Warning:</strong> This action cannot be undone.
                    </div>
                    <p>Are you sure you want to delete your account? All your data will be permanently removed.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete My Account</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Check if user is logged in
            const userId = localStorage.getItem('userId');
            if (!userId) {
                window.location.href = '/login';
                return;
            }
            
            // Initialize modals
            const editProfileModal = new bootstrap.Modal(document.getElementById('editProfileModal'));
            const deleteAccountModal = new bootstrap.Modal(document.getElementById('deleteAccountModal'));
            
            // Get DOM elements
            const profileName = document.getElementById('profileName');
            const profileEmail = document.getElementById('profileEmail');
            const profileAvatar = document.getElementById('profileAvatar');
            const infoName = document.getElementById('infoName');
            const infoEmail = document.getElementById('infoEmail');
            const infoAge = document.getElementById('infoAge');
            const infoGender = document.getElementById('infoGender');
            const infoAddress = document.getElementById('infoAddress');
            
            // Edit form elements
            const editUserId = document.getElementById('editUserId');
            const editName = document.getElementById('editName');
            const editEmail = document.getElementById('editEmail');
            const editAge = document.getElementById('editAge');
            const editGender = document.getElementById('editGender');
            const editAddress = document.getElementById('editAddress');
            
            // Buttons
            const editProfileBtn = document.getElementById('editProfileBtn');
            const saveProfileBtn = document.getElementById('saveProfileBtn');
            const deleteAccountBtn = document.getElementById('deleteAccountBtn');
            const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
            const logoutBtn = document.getElementById('logoutBtn');
            
            // Loading overlay
            const loadingOverlay = document.getElementById('loadingOverlay');
            const loadingMessage = document.getElementById('loadingMessage');
            
            // Fetch user data
            fetchUserData(userId);
            
            // Event listeners
            editProfileBtn.addEventListener('click', function() {
                editProfileModal.show();
            });
            
            saveProfileBtn.addEventListener('click', function() {
                if (validateEditForm()) {
                    updateUserProfile();
                }
            });
            
            deleteAccountBtn.addEventListener('click', function() {
                deleteAccountModal.show();
            });
            
            confirmDeleteBtn.addEventListener('click', function() {
                deleteUserAccount();
            });
            
            logoutBtn.addEventListener('click', function() {
                logout();
            });
            
            // Functions
            function fetchUserData(userId) {
                showLoading('Loading your profile...');
                
                fetch(`/api/users/`+userId)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Failed to fetch user data');
                        }
                        return response.json();
                    })
                    .then(data => {
                        // Update profile header
                        profileName.textContent = data.name || 'No Name';
                        profileEmail.textContent = data.email || 'No Email';
                        
                        // Update profile avatar with initials
                        if (data.name) {
                            const initials = data.name.split(' ')
                                .map(name => name.charAt(0))
                                .join('')
                                .toUpperCase();
                            profileAvatar.innerHTML = initials;
                        }
                        
                        // Update personal information
                        infoName.textContent = data.name || 'Not provided';
                        infoEmail.textContent = data.email || 'Not provided';
                        infoAge.textContent = data.age || 'Not provided';
                        infoGender.textContent = data.gender || 'Not provided';
                        infoAddress.textContent = data.address || 'Not provided';
                        
                        // Populate edit form
                        editUserId.value = data.userId;
                        editName.value = data.name || '';
                        editEmail.value = data.email || '';
                        editAge.value = data.age || '';
                        editGender.value = data.gender || '';
                        editAddress.value = data.address || '';
                        
                        hideLoading();
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        hideLoading();
                        alert('Failed to load profile data. Please try again later.');
                    });
            }
            
            function validateEditForm() {
                let isValid = true;
                
                // Reset validation state
                editName.classList.remove('is-invalid');
                editEmail.classList.remove('is-invalid');
                editAge.classList.remove('is-invalid');
                
                // Validate name
                if (!editName.value.trim()) {
                    editName.classList.add('is-invalid');
                    isValid = false;
                }
                
                // Validate email
                if (!editEmail.value || !isValidEmail(editEmail.value)) {
                    editEmail.classList.add('is-invalid');
                    isValid = false;
                }
                
                // Validate age if provided
                if (editAge.value && (editAge.value < 18 || editAge.value > 120)) {
                    editAge.classList.add('is-invalid');
                    isValid = false;
                }
                
                return isValid;
            }
            
            function isValidEmail(email) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            }
            
            function updateUserProfile() {
                showLoading('Updating your profile...');
                
                const userData = {
                    userId: editUserId.value,
                    name: editName.value,
                    email: editEmail.value,
                    age: editAge.value ? parseInt(editAge.value) : null,
                    gender: editGender.value,
                    address: editAddress.value
                };
                
                fetch(`/api/users/`+userData.userId, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(userData)
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to update profile');
                    }
                    
                    // Close modal
                    editProfileModal.hide();
                    
                    // Refresh user data
                    fetchUserData(userData.userId);
                    
                    // Show success message
                    alert('Profile updated successfully!');
                })
                .catch(error => {
                    console.error('Error:', error);
                    hideLoading();
                    alert('Failed to update profile. Please try again later.');
                });
            }
            
            function deleteUserAccount() {
                showLoading('Deleting your account...');
                
                fetch(`/api/users/`+userId, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to delete account');
                    }
                    
                    // Clear local storage
                    localStorage.removeItem('userId');
                    
                    // Redirect to home page
                    window.location.href = '/';
                })
                .catch(error => {
                    console.error('Error:', error);
                    hideLoading();
                    deleteAccountModal.hide();
                    alert('Failed to delete account. Please try again later.');
                });
            }
            
            function logout() {
                // Clear local storage
                localStorage.removeItem('userId');
                
                // Redirect to home page
                window.location.href = '/';
            }
            
            function showLoading(message) {
                loadingMessage.textContent = message;
                loadingOverlay.classList.add('show');
            }
            
            function hideLoading() {
                loadingOverlay.classList.remove('show');
            }
        });
    </script>
</body>
</html>