<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycabservice.model.Car" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Cars - Mega City Cab Service</title>
    <style>
        /* Global Styles */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background:url("images/MEGACITY CABS (11).png") no-repeat center center fixed;
            background-size: cover;
            color: white;
        }

        /* Navbar */
        .navbar {
            background-color: rgba(0, 0, 0, 0.9);
            padding: 15px;
            text-align: center;
            display: flex;
            justify-content: center;
            position: fixed;
            width: 100%;
            top: 0;
            left: 0;
            z-index: 1000;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            padding: 12px 20px;
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
            width: 80%;
            margin: 80px auto 40px;
            padding: 30px;
            background: rgba(0, 0, 0, 0.8);
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
            text-align: center;
        }

        h1 {
            color: #FFD700;
            margin-bottom: 20px;
        }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            color: black;
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 12px;
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
            background-color: #e9ecef;
        }

        /* Status Labels */
        .status-available {
            color: green;
            font-weight: bold;
        }

        .status-unavailable {
            color: red;
            font-weight: bold;
        }

        .status-unknown {
            color: orange;
            font-weight: bold;
        }

        /* Buttons */
        a {
            text-decoration: none;
            color: #007BFF;
            font-weight: bold;
            transition: 0.3s;
        }

        a:hover {
            text-decoration: underline;
            color: #0056b3;
        }

        .add-button {
            margin-top: 20px;
            display: inline-block;
            padding: 12px 25px;
            background-color: #28a745;
            color: white;
            font-size: 16px;
            font-weight: bold;
            border-radius: 5px;
            text-decoration: none;
            transition: 0.3s;
        }

        .add-button:hover {
            background-color: #218838;
        }

        /* Footer */
        .footer {
            text-align: center;
            padding: 15px;
            background-color: rgba(0, 0, 0, 0.9);
            color: white;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="manageCars">🚗 Manage Cars</a>
    <a href="manageDrivers">👨‍✈️ Manage Drivers</a>
    <a href="manageBookings">📖 Manage Customer Bookings</a>
    <a href="adminManageCustomers">👤 Manage Customers</a>
    <a href="calculateBill">🧾 payments</a>
    <a href="logout" style="color: red; font-weight: bold;">Logout</a>
</div>


<div class="container">
    <h1>Manage Cars</h1>

    <%
        List<Car> carList = (List<Car>) request.getAttribute("carList");
        if (carList == null) {
            carList = new ArrayList<>();
        }
    %>

    <% if (!carList.isEmpty()) { %>
    <table>
        <thead>
        <tr>
            <th>Car ID</th>
            <th>Model</th>
            <th>License Plate</th>
            <th>Capacity</th>
            <th>Fuel Type</th>
            <th>Rental Price per Km (LKR)</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% for (Car car : carList) { %>
        <tr>
            <td><%= car.getCarID() %></td>
            <td><%= car.getModel() != null ? car.getModel() : "N/A" %></td>
            <td><%= car.getLicensePlate() != null ? car.getLicensePlate() : "N/A" %></td>
            <td><%= car.getCapacity() %></td>
            <td><%= car.getFuelType() != null ? car.getFuelType() : "N/A" %></td>
            <td><%= car.getRentalPricePerKm() %></td>
            <td>
                <% if (car.getStatus() != null && !car.getStatus().isEmpty()) { %>
                <% if (car.getStatus().equalsIgnoreCase("Available")) { %>
                <span class="status-available">Available</span>
                <% } else if (car.getStatus().equalsIgnoreCase("Unavailable")) { %>
                <span class="status-unavailable">Unavailable</span>
                <% } else { %>
                <span class="status-unknown"><%= car.getStatus() %></span>
                <% } %>
                <% } else { %>
                <span class="status-unknown">Not Specified</span>
                <% } %>
            </td>
            <td>
                <a href="editCar?carId=<%= car.getCarID() %>">✏️ Edit</a> |
                <a href="deleteCar?carId=<%= car.getCarID() %>" onclick="return confirm('Are you sure you want to delete this car?')">🗑️ Delete</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <p>No cars found in the database.</p>
    <% } %>

    <br>
    <a href="addCar.jsp" class="add-button">➕ Add New Car</a>
</div>


<div class="footer">
    <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>
