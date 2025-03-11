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
        body {
            font-family: Arial, sans-serif;
            background: url("images/MEGACITY CABS (11).png") no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            color: #333;
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
            margin-bottom: 30px;
        }

        .report-form {
            text-align: center;
            margin-bottom: 20px;
        }
        .report-form select, .report-form button {
            padding: 10px;
            font-size: 16px;
            margin: 0 10px;
            border-radius: 5px;
            border: 1px solid #ddd;
        }
        .report-form button {
            background-color: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
            transition: 0.3s;
        }
        .report-form button:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
            max-width: 150px;
            word-wrap: break-word;
            font-size: 14px;
        }
        th {
            background-color: #007BFF;
            color: white;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }

        .action-link {
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 5px;
            margin: 0 5px;
            display: inline-block;
            transition: 0.3s;
        }
        .action-link.mark-paid {
            color: green;
            background: #e6ffe6;
        }
        .action-link.mark-completed {
            color: blue;
            background: #e6f0ff;
        }
        .action-link:hover {
            opacity: 0.8;
        }

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

<div class="navbar">
    <a href="manageCars">Manage Cars</a>
    <a href="manageDrivers">Manage Drivers</a>
    <a href="manageBookings" class="active">Manage Customer Bookings</a>
    <a href="adminManageCustomers">Manage Customers</a>
    <a href="calculateBill">Payments</a>
    <a href="logout" style="color: red; font-weight: bold;">Logout</a>
</div>

<div class="container">
    <h1>View Customer Bookings</h1>

    <!-- Report Generation Form -->
    <div class="report-form">
        <form action="generateMonthlyReport" method="post">
            <label for="month">Month:</label>
            <select name="month" id="month" required>
                <option value="01">January</option>
                <option value="02">February</option>
                <option value="03">March</option>
                <option value="04">April</option>
                <option value="05">May</option>
                <option value="06">June</option>
                <option value="07">July</option>
                <option value="08">August</option>
                <option value="09">September</option>
                <option value="10">October</option>
                <option value="11">November</option>
                <option value="12">December</option>
            </select>
            <label for="year">Year:</label>
            <select name="year" id="year" required>
                <% for (int year = 2023; year <= 2025; year++) { %>
                <option value="<%= year %>"><%= year %></option>
                <% } %>
            </select>
            <button type="submit">Generate Monthly Report</button>
        </form>
    </div>

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
            <th>Actions</th>
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
            <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(booking.getBookingDate()) %></td>
            <td><%= booking.getPaymentMethod() %></td>
            <td><%= booking.getDistance() %></td>
            <td style="font-weight: bold; color: <%= booking.getStatus().equals("Completed") ? "green" : booking.getStatus().equals("Confirmed") ? "orange" : "red" %>;">
                <%= booking.getStatus() %>
            </td>
            <td style="font-weight: bold; color: <%= booking.getPaymentStatus().equals("Paid") ? "green" : "red" %>;">
                <%= booking.getPaymentStatus() %>
            </td>
            <td>
                <% if (!"Paid".equals(booking.getPaymentStatus())) { %>
                <a href="markAsPaid?bookingNumber=<%= booking.getBookingNumber() %>"
                   class="action-link mark-paid">Mark as Paid</a>
                <% } %>
                <% if (!"Completed".equals(booking.getStatus())) { %>
                <a href="markAsCompleted?bookingNumber=<%= booking.getBookingNumber() %>"
                   class="action-link mark-completed">Mark as Completed</a>
                <% } %>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <p style="text-align: center; font-size: 18px;">No bookings available.</p>
    <% } %>
</div>

</body>
</html>