<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycabservice.model.Customer" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Customers - Mega City Cab Service</title>
    <style>
        /* Global Styles */
        body {
            font-family: Arial, sans-serif;
            background:url("images/MEGACITY CABS (11).png")no-repeat center center fixed;
            margin: 0;
            padding: 0;
        }

        /* Navbar */
        .navbar {
            background-color: #333;
            padding: 15px;
            text-align: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            padding: 10px 20px;
            margin: 0 10px;
            transition: 0.3s;
        }
        .navbar a:hover {
            background-color: #007BFF;
            border-radius: 5px;
        }
        .navbar a.active {
            background-color: #007BFF;
            border-radius: 5px;
        }

        /* Container */
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
            background: white;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        /* Search Bar */
        .search-box {
            text-align: center;
            margin-bottom: 20px;
        }
        .search-box input {
            padding: 10px;
            width: 300px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .search-box button {
            padding: 10px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        .search-box button:hover {
            background-color: #0056b3;
        }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }

        /* Action Buttons */
        .edit-btn {
            background-color: #FFC107;
            padding: 8px 12px;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .edit-btn:hover {
            background-color: #E0A800;
        }

        .delete-btn {
            background-color: #DC3545;
            padding: 8px 12px;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .delete-btn:hover {
            background-color: #C82333;
        }

        /* Footer */
        .footer {
            text-align: center;
            padding: 15px;
            background-color: #333;
            color: white;
            position: fixed;
            bottom: 0;
            width: 100%;
        }

    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <a href="manageCars">🚗 Manage Cars</a>
    <a href="manageDrivers">👨‍✈️ Manage Drivers</a>
    <a href="manageBookings">📖 Manage Customer Bookings</a>
    <a href="adminManageCustomers">👤 Manage Customers</a>
    <a href="calculateBill">🧾 payments</a>
    <a href="logout" style="color: red; font-weight: bold;">Logout</a>
</div>

<!-- Search Bar -->
<div class="search-box">
    <form action="adminManageCustomers" method="get">
        <input type="text" name="search" placeholder="Search by Name or NIC">
        <button type="submit">Search</button>
    </form>
</div>

<!-- Customers List -->
<div class="container">
    <h1>Manage Customers</h1>

    <%
        List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
        if (customerList == null) {
            customerList = new ArrayList<>();
        }
    %>

    <% if (!customerList.isEmpty()) { %>
    <table>
        <thead>
        <tr>
            <th>Customer ID</th>
            <th>Name</th>
            <th>Address</th>
            <th>NIC</th>
            <th>Contact Number</th>
            <th>Email</th>
            <th>Username</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% for (Customer customer : customerList) { %>
        <tr>
            <td><%= customer.getCustomerID() %></td>
            <td><%= customer.getName() %></td>
            <td><%= customer.getAddress() %></td>
            <td><%= customer.getNic() %></td>
            <td><%= customer.getContactNumber() %></td>
            <td><%= customer.getEmail() %></td>
            <td><%= customer.getUsername() %></td>
            <td>
                <a href="editCustomer?customerId=<%= customer.getCustomerID() %>">
                    <button class="edit-btn">Edit</button>
                </a>
                <a href="adminManageCustomers?delete=<%= customer.getCustomerID() %>" onclick="return confirm('Are you sure you want to delete this customer?');">
                    <button class="delete-btn">Delete</button>
                </a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <p style="text-align: center; font-size: 18px;">No customers found.</p>
    <% } %>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>
