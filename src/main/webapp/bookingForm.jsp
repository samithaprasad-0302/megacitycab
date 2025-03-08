<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
  <title>Booking Details</title>
  <style>

    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background: url('images/MEGACITY CABS (5).png') no-repeat center center fixed;
      background-size: cover;
      color: white;
    }


    .navbar {
      background-color: rgba(0, 0, 0, 0.64);
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
      width: 40%;
      margin: 50px auto;
      padding: 20px;
      background: rgba(0, 0, 0, 0.7);
      border-radius: 10px;
      box-shadow: 0px 0px 15px rgba(255, 255, 255, 0.2);
    }

    h1 {
      text-align: center;
      color: #FFD700;
      margin-bottom: 20px;
      text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
    }

    label {
      font-weight: bold;
      display: block;
      margin-top: 10px;
      color: white;
    }

    input, select {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      border: none;
      border-radius: 5px;
      box-sizing: border-box;
      font-size: 16px;
    }

    input:focus, select:focus {
      outline: 2px solid #007BFF;
    }

    button {
      width: 100%;
      padding: 12px;
      background-color: #28a745;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 18px;
      margin-top: 15px;
      transition: 0.3s;
    }

    button:hover {
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
<%

  String successMessage = (String) session.getAttribute("successMessage");
  if (successMessage != null) {
%>
<script>
  Swal.fire({
    icon: 'success',
    title: 'Success!',
    text: '<%= successMessage %>'
  });
</script>
<%
    session.removeAttribute("successMessage");
  }

  String errorMessage = (String) session.getAttribute("errorMessage");
  if (errorMessage != null) {
%>
<script>
  Swal.fire({
    icon: 'error',
    title: 'Error!',
    text: '<%= errorMessage %>'
  });
</script>
<%
    session.removeAttribute("errorMessage");
  }
%>

<div class="navbar">
  <a href="customerDashboard">Dashboard</a>

  <a href="logout" style="color: red;">Logout</a>
</div>


<div class="container">
  <h1>Enter Booking Details</h1>

  <%
    int carID = Integer.parseInt(request.getParameter("carID"));
    int driverID = Integer.parseInt(request.getParameter("driverID"));
    String username = (String) session.getAttribute("username");
  %>

  <form action="processBooking" method="POST">
    <input type="hidden" name="carID" value="<%= carID %>">
    <input type="hidden" name="driverID" value="<%= driverID %>">
    <input type="hidden" name="username" value="<%= username %>">

    <label for="pickupLocation">Pickup Location:</label>
    <input type="text" id="pickupLocation" name="pickupLocation" required placeholder="Enter pickup location">

    <label for="dropoffLocation">Drop-off Location:</label>
    <input type="text" id="dropoffLocation" name="dropoffLocation" required placeholder="Enter dropoff location">

    <label for="distance">Distance (km):</label>
    <input type="number" id="distance" name="distance" required placeholder="Enter distance in km">

    <label for="bookingDate">Booking Date & Time:</label>
    <input type="datetime-local" id="bookingDate" name="bookingDate" required>

    <label for="paymentMethod">Payment Method:</label>
    <select id="paymentMethod" name="paymentMethod" required>
      <option value="Cash">Cash</option>
      <option value="Card">Card</option>
    </select>

    <button type="submit">Confirm Booking</button>
  </form>
</div>

<!-- Footer -->
<div class="footer">
  <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>
