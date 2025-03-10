<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.megacitycabservice.model.Car" %>
<%@ page import="java.util.ArrayList" %>

<html>
<head>
  <title>Customer Dashboard - Book a Car</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background: url('images/MEGACITY CABS (6).png') no-repeat center center fixed;
      background-size: cover;
      color: white;
    }

    .dashboard-container {
      width: 85%;
      margin: 50px auto;
      padding: 20px;
      background: rgba(0, 0, 0, 0.7);
      border-radius: 10px;
      backdrop-filter: blur(2px);
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.16);
      padding-bottom: 30px;
    }

    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 15px;
      background-color: rgba(0, 123, 255, 0.9);
      border-top-left-radius: 10px;
      border-top-right-radius: 10px;
    }

    .header h2 {
      margin: 0;
    }

    .logout-button, .profile-button {
      padding: 10px 15px;
      background-color: #dc3545;
      color: white;
      border: none;
      cursor: pointer;
      border-radius: 5px;
      font-size: 16px;
      transition: 0.3s;
      text-decoration: none;
    }

    .logout-button:hover, .profile-button:hover {
      background-color: #c82333;
    }

    .profile-button {
      background-color: #092e57;
      margin-right: 10px;
    }

    .profile-button:hover {
      background-color: #0056b3;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
      background: rgba(255, 255, 255, 0.9);
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

    .book-button, .cancel-button {
      padding: 8px 15px;
      color: white;
      border: none;
      cursor: pointer;
      border-radius: 5px;
      font-size: 14px;
      transition: 0.3s;
    }

    .book-button {
      background-color: #28a745;
    }

    .book-button:hover {
      background-color: #218838;
    }

    .cancel-button {
      background-color: #dc3545;
    }

    .cancel-button:hover {
      background-color: #c82333;
    }

    .pay-button {
      background-color: blue;
      color: white;
      padding: 8px;
      border-radius: 5px;
    }

    .status-paid {
      color: green;
      font-weight: bold;
    }

    .status-pending {
      color: orange;
      font-weight: bold;
    }

    .status-completed {
      color: gray;
      font-weight: bold;
    }

    h2 {
      text-align: center;
      color: #FFD700;
      margin-top: 20px;
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

<div class="dashboard-container">

  <div class="header">
    <h2>Welcome,
      <%
        String customerName = (String) session.getAttribute("username");
        if (customerName != null) {
          out.print(customerName);
        } else {
          response.sendRedirect("login.jsp");
        }
      %>
    </h2>
    <div>
      <a href="manageProfile.jsp" class="profile-button">Manage Profile</a>
      <a href="logout" class="logout-button">Logout</a>
    </div>
  </div>

  <h2>Available Cars for Booking</h2>

    <%
    List<Car> carList = (List<Car>) request.getAttribute("availableCars");
    if (carList == null) carList = new ArrayList<>();
  %>

    <% if (!carList.isEmpty()) { %>
  <table>
    <thead>
    <tr>
      <th>Model</th>
      <th>License Plate</th>
      <th>Capacity</th>
      <th>Fuel Type</th>
      <th>Rental Price per Km</th>
      <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <% for (Car car : carList) { %>
    <tr>
      <td><%= car.getModel() %></td>
      <td><%= car.getLicensePlate() %></td>
      <td><%= car.getCapacity() %></td>
      <td><%= car.getFuelType() %></td>
      <td><%= car.getRentalPricePerKm() %> LKR</td>
      <td>
        <form action="selectDriver" method="POST">
          <input type="hidden" name="carID" value="<%= car.getCarID() %>">
          <button type="submit" class="book-button">Book Now</button>
        </form>
      </td>
    </tr>
    <% } %>
    </tbody>
  </table>
    <% } else { %>
  <p style="text-align: center; color: red;">No available cars at the moment.</p>
    <% } %>

  <h2>My Bookings</h2>

    <%
    List<Map<String, String>> customerBookings = (List<Map<String, String>>) request.getAttribute("customerBookings");
  %>

    <% if (customerBookings != null && !customerBookings.isEmpty()) { %>
  <table>
    <thead>
    <tr>
      <th>Booking ID</th>
      <th>Car Model</th>
      <th>Driver Name</th>
      <th>Pickup Location</th>
      <th>Dropoff Location</th>
      <th>Booking Date</th>
      <th>Payment Method</th>
      <th>Payment Status</th>
      <th>Status</th>
      <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <% for (Map<String, String> booking : customerBookings) { %>
    <tr>
      <td><%= booking.get("bookingNumber") %></td>
      <td><%= booking.get("carModel") %></td>
      <td><%= booking.get("driverName") %></td>
      <td><%= booking.get("pickupLocation") %></td>
      <td><%= booking.get("dropoffLocation") %></td>
      <td><%= booking.get("bookingDate") %></td>
      <td><%= booking.get("paymentMethod") %></td>
      <td>
        <% if ("Pending".equals(booking.get("paymentStatus"))) { %>
        <form action="payment.jsp" method="GET">
          <input type="hidden" name="bookingID" value="<%= booking.get("bookingNumber") != null ? booking.get("bookingNumber") : "" %>">
          <input type="hidden" name="carID" value="<%= booking.get("carID") != null ? booking.get("carID") : "" %>">
          <input type="hidden" name="carModel" value="<%= booking.get("carModel") != null ? booking.get("carModel") : "" %>">
          <input type="hidden" name="driverID" value="<%= booking.get("driverID") != null ? booking.get("driverID") : "" %>">
          <input type="hidden" name="customerName" value="<%= customerName %>">
          <input type="hidden" name="driverName" value="<%= booking.get("driverName") %>">
          <input type="hidden" name="pickupLocation" value="<%= booking.get("pickupLocation") %>">
          <input type="hidden" name="dropoffLocation" value="<%= booking.get("dropoffLocation") %>">
          <input type="hidden" name="bookingDate" value="<%= booking.get("bookingDate") %>">
          <input type="hidden" name="rentalPricePerKm" value="<%= booking.get("rentalPricePerKm") %>">
          <input type="hidden" name="distance" value="<%= booking.get("distance") %>">
          <button type="submit" class="pay-button">Pay Now</button>
        </form>
        <% } else if ("Paid".equals(booking.get("paymentStatus"))) { %>
        <span style="color: green;">✔ Paid</span>
        <% } %>
      </td>
      <td>
        <% if ("Completed".equals(booking.get("status"))) { %>
        <span style="color: gray;">✔ Completed</span>
        <% } else { %>
        <span style="color: orange;">Active</span>
        <% } %>
      </td>
      <td>
        <% if (!"Completed".equals(booking.get("status"))) { %>
        <form action="cancelBooking" method="POST">
          <input type="hidden" name="bookingNumber" value="<%= booking.get("bookingNumber") %>">
          <input type="hidden" name="carID" value="<%= booking.get("carID") %>">
          <input type="hidden" name="driverID" value="<%= booking.get("driverID") %>">
          <button type="submit" class="cancel-button">Cancel</button>
        </form>
        <% } %>
      </td>
    </tr>
    <% } %>
    </tbody>
  </table>
    <% } else { %>
  <p style="text-align: center; color: red;">No bookings found.</p>
    <% } %>

</body>
</html>