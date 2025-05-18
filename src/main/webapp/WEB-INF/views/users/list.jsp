<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        .action-buttons .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
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
                        <h1 class="mb-0">Users Management</h1>
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
                        <input type="text" id="searchInput" class="form-control" placeholder="Search users...">
                    </div>
                </div>
            </div>
        </div>

        <!-- Users Table -->
        <div class="card shadow-sm">
            <div class="card-body">
                <div class="table-responsive">
                    <table id="usersTable" class="table table-striped table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Age</th>
                                <th>Gender</th>
                                <th>Address</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="usersTableBody">
                            <!-- Table content will be loaded dynamically -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editUserForm">
                        <input type="hidden" id="editUserId">
                        <div class="mb-3">
                            <label for="editName" class="form-label">Name</label>
                            <input type="text" class="form-control" id="editName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="editEmail" required>
                        </div>
                        <div class="mb-3">
                            <label for="editAge" class="form-label">Age</label>
                            <input type="number" class="form-control" id="editAge" required>
                        </div>
                        <div class="mb-3">
                            <label for="editGender" class="form-label">Gender</label>
                            <select class="form-select" id="editGender" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="editAddress" class="form-label">Address</label>
                            <textarea class="form-control" id="editAddress" rows="2" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveUserChanges">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this user? This action cannot be undone.</p>
                    <p><strong>User: </strong><span id="deleteUserName"></span></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDelete">Delete</button>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    <!-- jsPDF for PDF export -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.25/jspdf.plugin.autotable.min.js"></script>

    <script>
        // Global variables
        let users = [];
        let currentUserId = null;

        $(document).ready(function() {
            // Fetch users data
            fetchUsers();

            // Initialize search functionality
            $("#searchInput").on("keyup", function() {
                const value = $(this).val().toLowerCase();
                filterUsers(value);
            });

            // Export PDF button click
            $("#exportPdf").click(function() {
                exportToPdf();
            });

            // Add event listeners for edit and delete buttons
            $(document).on("click", ".edit-user", function() {
                const userId = $(this).data("id");
                openEditModal(userId);
            });

            $(document).on("click", ".delete-user", function() {
                const userId = $(this).data("id");
                openDeleteModal(userId);
            });

            // Save user changes
            $("#saveUserChanges").click(function() {
                saveUserChanges();
            });

            // Confirm delete
            $("#confirmDelete").click(function() {
                deleteUser(currentUserId);
            });
        });

        // Fetch users from API
        function fetchUsers() {
            $.ajax({
                url: "/api/users",
                type: "GET",
                dataType: "json",
                success: function(data) {
                    users = data;
                    renderUsersTable(users);
                },
                error: function(error) {
                    console.error("Error fetching users:", error);
                    alert("Failed to load users. Please try again later.");
                }
            });
        }

        // Render users table
        function renderUsersTable(usersData) {
            const tableBody = $("#usersTableBody");
            tableBody.empty();

            usersData.forEach(user => {
                tableBody.append(
                    "<tr>" +
                    "<td>" + user.userId + "</td>" +
                    "<td>" + user.name + "</td>" +
                    "<td>" + user.email + "</td>" +
                    "<td>" + user.age + "</td>" +
                    "<td>" + user.gender + "</td>" +
                    "<td>" + user.address + "</td>" +
                    "<td class=\"action-buttons\">" +

                    "<button class=\"btn btn-sm btn-danger delete-user\" data-id=\"" + user.userId + "\">" +
                    "<i class=\"fas fa-trash\"></i>" +
                    "</button>" +
                    "</td>" +
                    "</tr>"
                );

            });
        }

        // Filter users based on search input
        function filterUsers(searchTerm) {
            if (searchTerm === "") {
                renderUsersTable(users);
                return;
            }

            const filteredUsers = users.filter(user => {
                return (
                    user.userId.toLowerCase().includes(searchTerm) ||
                    user.name.toLowerCase().includes(searchTerm) ||
                    user.email.toLowerCase().includes(searchTerm) ||
                    user.address.toLowerCase().includes(searchTerm) ||
                    user.gender.toLowerCase().includes(searchTerm) ||
                    user.age.toString().includes(searchTerm)
                );
            });

            renderUsersTable(filteredUsers);
        }

        // Open edit modal with user data
        function openEditModal(userId) {
            const user = users.find(u => u.userId === userId);
            if (user) {
                $("#editUserId").val(user.userId);
                $("#editName").val(user.name);
                $("#editEmail").val(user.email);
                $("#editAge").val(user.age);
                $("#editGender").val(user.gender);
                $("#editAddress").val(user.address);
                
                $("#editUserModal").modal("show");
            }
        }

        // Open delete confirmation modal
        function openDeleteModal(userId) {
            const user = users.find(u => u.userId === userId);
            if (user) {
                currentUserId = userId;
                $("#deleteUserName").text(user.name);
                $("#deleteConfirmModal").modal("show");
            }
        }

        // Delete user
        function deleteUser(userId) {
            $.ajax({
                url: `/api/users/`+userId,
                type: "DELETE",
                success: function() {
                    // Remove from local data
                    users = users.filter(u => u.userId !== userId);
                    
                    // Close modal and refresh table
                    $("#deleteConfirmModal").modal("hide");
                    renderUsersTable(users);
                    
                    // Show success message
                    alert("User deleted successfully!");
                },
                error: function(error) {
                    console.error("Error deleting user:", error);
                    alert("Failed to delete user. Please try again.");
                }
            });
        }

        // Export table to PDF
        function exportToPdf() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            
            // Add title
            doc.setFontSize(18);
            doc.text("Users List", 14, 22);
            
            // Add date
            doc.setFontSize(11);
            doc.text("Generated: " + new Date().toLocaleString(), 14, 30);
            
            // Create table
            const tableColumn = ["ID", "Name", "Email", "Age", "Gender", "Address"];
            const tableRows = [];
            
            users.forEach(user => {
                const userData = [
                    user.userId,
                    user.name,
                    user.email,
                    user.age,
                    user.gender,
                    user.address
                ];
                tableRows.push(userData);
            });
            
            // Generate PDF with table
            doc.autoTable({
                head: [tableColumn],
                body: tableRows,
                startY: 35,
                styles: {
                    fontSize: 10,
                    cellPadding: 3,
                    overflow: 'linebreak'
                },
                columnStyles: {
                    5: { cellWidth: 'auto' }
                }
            });
            
            // Save PDF
            doc.save("users_list.pdf");
        }
    </script>
</body>
</html>