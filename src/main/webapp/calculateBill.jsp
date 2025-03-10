<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Calculate Bill - Mega City Cab Service</title>
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
      width: 80%;
      margin: 50px auto;
      padding: 20px;
      background: rgba(0, 0, 0, 0.8);
      border-radius: 10px;
      box-shadow: 0px 0px 15px rgba(255, 255, 255, 0.2);
    }

    h1 {
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

    .total-income {
      font-size: 20px;
      text-align: right;
      color: #FFD700;
      font-weight: bold;
      margin-top: 20px;
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
  <a href="manageCars">🚗 Manage Cars</a>
  <a href="manageDrivers">👨‍✈️ Manage Drivers</a>
  <a href="manageBookings">📖 Manage Customer Bookings</a>
  <a href="adminManageCustomers">👤 Manage Customers</a>
  <a href="calculateBill">🧾 payments</a>
  <a href="logout" style="color: red; font-weight: bold;">Logout</a>
</div>

<div class="container">
  <h1>Manage Payments & Total Income</h1>


  <c:choose>
    <c:when test="${not empty payments}">
      <table>
        <thead>
        <tr>
          <th>Payment ID</th>
          <th>Booking Number</th>
          <th>Total Amount (LKR)</th>
          <th>Payment Date</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="payment" items="${payments}">
          <tr>
            <td>${payment.paymentID}</td>
            <td>${payment.bookingNumber}</td>
            <td>${payment.totalAmount}</td>
            <td>${payment.paymentDate}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>

      <!-- Total Income -->
      <div class="total-income">
        Total Income: LKR ${totalIncome}
      </div>

    </c:when>
    <c:otherwise>
      <p style="text-align: center; color: red;">No payments found.</p>
    </c:otherwise>
  </c:choose>
</div>

<!-- Footer -->
<div class="footer">
  <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>
