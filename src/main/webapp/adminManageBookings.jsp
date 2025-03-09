<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycabservice.model.Booking" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Customer Bookings - Mega City Cab Service</title>
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

<!-- Booking List -->
<div class="container">
    <h1>View Customer Bookings</h1>

    <%
        List<Booking> bookingList = (List<Booking>) request.getAttribute("bookingList");
        if (bookingList == null) {
            bookingList = new ArrayList<>();
        }
    %>

    <% if (!bookingList.isEmpty()) { %>
    <table>
        <thead>
        <tr>
            <th>Booking Number</th>
            <th>Customer ID</th>
            <th>Car ID</th>
            <th>Pickup Location</th>
            <th>Dropoff Location</th>
            <th>Booking Date</th>
            <th>Payment Method</th>
            <th>Distance (km)</th>
            <th>Status</th>
            <th>Payment Status</th>
        </tr>
        </thead>
        <tbody>
        <% for (Booking booking : bookingList) { %>
        <tr>
            <td><%= booking.getBookingNumber() %></td>
            <td><%= booking.getCustomerID() %></td>
            <td><%= booking.getCarID() %></td>
            <td><%= booking.getPickupLocation() %></td>
            <td><%= booking.getDropoffLocation() %></td>
            <td><%= booking.getBookingDate() %></td>
            <td><%= booking.getPaymentMethod() %></td>
            <td><%= booking.getDistance() %></td>
            <td style="font-weight: bold; color: <%= booking.getStatus().equals("Completed") ? "green" : "orange" %>;">
                <%= booking.getStatus() %>
            </td>
            <td style="font-weight: bold; color: <%= booking.getPaymentStatus().equals("Paid") ? "green" : "red" %>;">
                <%= booking.getPaymentStatus() %>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <p style="text-align: center; font-size: 18px;">No bookings available.</p>
    <% } %>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>
