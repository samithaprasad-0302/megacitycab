<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycabservice.model.Driver" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Drivers - Mega City Cab Service</title>
    <style>

        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background:url("images/MEGACITY CABS (11).png")no-repeat center center fixed;
            background-size: cover;
            color: white;
        }


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


        .container {
            width: 85%;
            margin: 80px auto 40px;
            padding: 30px;
            background: rgba(0, 0, 0, 0.85);
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
            text-align: center;
        }

        h1 {
            color: #FFD700;
            margin-bottom: 20px;
        }


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


        .status-available {
            color: green;
            font-weight: bold;
        }

        .status-journey {
            color: red;
            font-weight: bold;
        }


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
    <a href="manageCars">Manage Cars</a>
    <a href="manageDrivers"class="active">Manage Drivers</a>
    <a href="manageBookings" >Manage Customer Bookings</a>
    <a href="adminManageCustomers">Manage Customers</a>
    <a href="calculateBill">Payments</a>
    <a href="logout" style="color: red; font-weight: bold;">Logout</a>
</div>


<div class="container">
    <h1>Manage Drivers</h1>

    <%
        List<Driver> driverList = (List<Driver>) request.getAttribute("driverList");
        if (driverList == null) {
            driverList = new ArrayList<>();
        }
    %>

    <% if (!driverList.isEmpty()) { %>
    <table>
        <thead>
        <tr>
            <th>Driver ID</th>
            <th>Name</th>
            <th>Age</th>
            <th>Nationality</th>
            <th>Experience</th>
            <th>NIC</th>
            <th>Contact</th>
            <th>Username</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% for (Driver driver : driverList) { %>
        <tr>
            <td><%= driver.getDriverID() %></td>
            <td><%= driver.getName() %></td>
            <td><%= driver.getAge() %></td>
            <td><%= driver.getNationality() %></td>
            <td><%= driver.getDrivingExperience() %> yrs</td>
            <td><%= driver.getNic() %></td>
            <td><%= driver.getContactNumber() %></td>
            <td><%= driver.getUsername() %></td>
            <td>
                <% if ("Available".equals(driver.getStatus())) { %>
                <span class="status-available">Available</span>
                <% } else { %>
                <span class="status-journey">On a Journey</span>
                <% } %>
            </td>
            <td>
                <a href="editDriver?driverId=<%= driver.getDriverID() %>">✏️ Edit</a> |
                <a href="deleteDriver?driverId=<%= driver.getDriverID() %>" onclick="return confirm('Are you sure you want to delete this driver?')">🗑️ Delete</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <p>No drivers found in the database.</p>
    <% } %>

    <br>
    <a href="addDriver.jsp" class="add-button">➕ Add New Driver</a>
</div>


<div class="footer">
    <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>
