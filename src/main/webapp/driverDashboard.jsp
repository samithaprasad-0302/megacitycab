<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Driver Dashboard</title>
    <style>

        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: url('images/MEGACITY CABS (9).png') no-repeat center center fixed;
            background-size: cover;
            color: white;
        }


        .navbar {
            background-color: rgba(0, 0, 0, 0.93);
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


        .container {
            width: 80%;
            margin: 30px auto;
            padding: 20px;
            background: rgba(0, 0, 0, 0.8);
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(255, 255, 255, 0.2);
        }

        h1, h2 {
            text-align: center;
            color: #FFD700;
        }


        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 10px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            text-align: center;
        }

        th {
            background-color: #007BFF;
            color: white;
        }

        tr:hover {
            background: rgba(255, 255, 255, 0.2);
        }


        .accept-button {
            background-color: #28a745;
            color: white;
            padding: 8px 12px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            transition: 0.3s;
        }

        .accept-button:hover {
            background-color: #218838;
        }

        .reject-button {
            background-color: #dc3545;
            color: white;
            padding: 8px 12px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            transition: 0.3s;
        }

        .reject-button:hover {
            background-color: #c82333;
        }

        .complete-button {
            background-color: #007BFF;
            color: white;
            padding: 8px 12px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            transition: 0.3s;
        }

        .complete-button:hover {
            background-color: #0056b3;
        }

        .completed-text {
            color: #ccc;
            font-weight: bold;
        }


        .footer {
            text-align: center;
            padding: 15px;
            background-color: rgba(0, 0, 0, 0.93);
            color: white;
            position: fixed;
            bottom: 0;
            width: 100%;
        }

    </style>
</head>
<body>
<%
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
%>
<script>
    alert("<%= successMessage %>");
</script>
<%
        session.removeAttribute("successMessage");
    }
%>


<div class="navbar">

    <a href="logout" style="color: red;">Logout</a>
</div>


<div class="container">
    <h1>Welcome, <%= session.getAttribute("username") %></h1>


    <h2>Pending Bookings</h2>
    <c:choose>
        <c:when test="${not empty pendingBookings}">
            <table>
                <tr>
                    <th>Booking ID</th>
                    <th>Car Model</th>
                    <th>Customer</th>
                    <th>Pickup</th>
                    <th>Dropoff</th>
                    <th>Booking Date</th>
                    <th>Action</th>
                </tr>
                <c:forEach var="booking" items="${pendingBookings}">
                    <tr>
                        <td>${booking.bookingNumber}</td>
                        <td>${booking.carModel}</td>
                        <td>${booking.customerName}</td>
                        <td>${booking.pickupLocation}</td>
                        <td>${booking.dropoffLocation}</td>
                        <td>${booking.bookingDate}</td>
                        <td>
                            <form action="driverBooking" method="POST">
                                <input type="hidden" name="bookingNumber" value="${booking.bookingNumber}">
                                <button type="submit" name="action" value="accept" class="accept-button">Accept</button>
                                <button type="submit" name="action" value="reject" class="reject-button">Reject</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:when>
        <c:otherwise>
            <p style="text-align: center; color: red;">No pending bookings.</p>
        </c:otherwise>
    </c:choose>


    <h2>Active Bookings</h2>
    <c:choose>
        <c:when test="${not empty activeBookings}">
            <table>
                <tr>
                    <th>Booking ID</th>
                    <th>Car Model</th>
                    <th>Customer</th>
                    <th>Pickup</th>
                    <th>Dropoff</th>
                    <th>Booking Date</th>
                    <th>Action</th>
                </tr>
                <c:forEach var="booking" items="${activeBookings}">
                    <tr>
                        <td>${booking.bookingNumber}</td>
                        <td>${booking.carModel}</td>
                        <td>${booking.customerName}</td>
                        <td>${booking.pickupLocation}</td>
                        <td>${booking.dropoffLocation}</td>
                        <td>${booking.bookingDate}</td>
                        <td>
                            <form action="completeBooking" method="POST">
                                <input type="hidden" name="bookingNumber" value="${booking.bookingNumber}">
                                <button type="submit" class="complete-button">Mark as Completed</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:when>
        <c:otherwise>
            <p style="text-align: center; color: red;">No active bookings.</p>
        </c:otherwise>
    </c:choose>

    <!-- Completed Rides -->
    <h2>Completed Rides</h2>
    <c:choose>
        <c:when test="${not empty completedBookings}">
            <table>
                <tr>
                    <th>Booking ID</th>
                    <th>Car Model</th>
                    <th>Customer</th>
                    <th>Pickup</th>
                    <th>Dropoff</th>
                    <th>Booking Date</th>
                    <th>Status</th>
                </tr>
                <c:forEach var="booking" items="${completedBookings}">
                    <tr>
                        <td>${booking.bookingNumber}</td>
                        <td>${booking.carModel}</td>
                        <td>${booking.customerName}</td>
                        <td>${booking.pickupLocation}</td>
                        <td>${booking.dropoffLocation}</td>
                        <td>${booking.bookingDate}</td>
                        <td class="completed-text">✔ Completed</td>
                    </tr>
                </c:forEach>
            </table>
        </c:when>
    </c:choose>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>
