<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycabservice.model.Driver" %>

<html>
<head>
    <title>Select a Driver</title>
    <style>

        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: url('images/MEGACITY CABS (3).png') no-repeat center center fixed;
            background-size: cover;
            color: white;
        }


        .navbar {
            background-color: rgb(0, 123, 255);
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


        h1 {
            text-align: center;
            color: #FFD700;
            margin-top: 20px;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
        }

        h2 {
            text-align: center;
            color: #FFF;
            font-size: 22px;
            margin-bottom: 20px;
        }


        .container {
            width: 80%;
            margin: 20px auto;
            background: rgba(0, 0, 0, 0.7);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(255, 255, 255, 0.2);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
            color: black;
        }

        th {
            background-color: #007BFF;
            color: white;
            text-transform: uppercase;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }


        .book-button {
            padding: 10px 15px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }

        .book-button:hover {
            background-color: #218838;
        }


        .footer {
            text-align: center;
            padding: 15px;
            background-color: rgba(0, 0, 0, 0.8);
            color: white;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
    </style>
</head>
<body>


<div class="navbar">
    <a href="customerDashboard">Dashboard</a>

    <a href="logout" style="color: red;">Logout</a>
</div>


<div class="container">
    <h1>Select a Driver</h1>
    <h2>Car Model: ${carModel}</h2>

    <%
        List<Driver> availableDrivers = (List<Driver>) request.getAttribute("availableDrivers");
        Integer carID = (Integer) request.getAttribute("carID");

        if (availableDrivers == null || availableDrivers.isEmpty()) {
            out.println("<p style='color:red; text-align:center;'>❌ No available drivers found.</p>");
        }
    %>

    <% if (availableDrivers != null && !availableDrivers.isEmpty()) { %>
    <table>
        <thead>
        <tr>
            <th>Name</th>
            <th>Age</th>
            <th>Nationality</th>
            <th>Experience</th>
            <th>NIC</th>
            <th>Contact</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <% for (Driver driver : availableDrivers) { %>
        <tr>
            <td><%= driver.getName() %></td>
            <td><%= driver.getAge() %></td>
            <td><%= driver.getNationality() %></td>
            <td><%= driver.getDrivingExperience() %> years</td>
            <td><%= driver.getNic() %></td>
            <td><%= driver.getContactNumber() %></td>
            <td>
                <form action="bookingForm.jsp" method="GET">
                    <input type="hidden" name="carID" value="<%= carID %>">
                    <input type="hidden" name="driverID" value="<%= driver.getDriverID() %>">
                    <button type="submit" class="book-button">Select</button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</div>


<div class="footer">
    <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>
