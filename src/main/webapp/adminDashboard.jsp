<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Mega City Cab Service</title>
    <style>

        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: url("images/MEGACITY CABS (11).png")no-repeat center center fixed;
            background-size: cover;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }


        .dashboard-container {
            width: 60%;
            padding: 30px;
            background: rgba(0, 0, 0, 0.85);
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
        }

        h1 {
            color: #FFD700;
            margin-bottom: 20px;
        }

        .menu-list {
            list-style: none;
            padding: 0;
        }
        .menu-list li {
            margin: 15px 0;
        }
        .menu-list a {
            display: block;
            padding: 15px;
            background: #007BFF;
            color: white;
            text-decoration: none;
            font-size: 18px;
            border-radius: 5px;
            transition: 0.3s;
        }
        .menu-list a:hover {
            background: #0056b3;
        }


    </style>
</head>
<body>


<div class="dashboard-container">
    <h1>Admin Dashboard</h1>
    <ul class="menu-list">
        <li><a href="manageCars">🚗 Manage Cars</a></li>
        <li><a href="manageDrivers">👨‍✈️ Manage Drivers</a></li>
        <li><a href="manageBookings">📖 Manage Customer Bookings</a></li>
        <li><a href="adminManageCustomers">👤 Manage Customers</a></li>
        <li><a href="calculateBill">🧾 payments</a></li>
    </ul>

</div>

</body>
</html>
