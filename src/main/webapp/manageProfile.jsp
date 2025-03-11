<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.megacitycabservice.dao.CustomerDAO" %>
<%@ page import="com.megacitycabservice.model.Customer" %>

<html>
<head>
  <title>Manage Profile</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background: url('images/MEGACITY CABS (6).png') no-repeat center center fixed;
      background-size: cover;
      color: white;
    }

    .container {
      width: 50%;
      margin: 50px auto;
      padding: 20px;
      background: rgba(0, 0, 0, 0.7);
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.16);
    }

    h2 {
      text-align: center;
      color: #FFD700;
    }

    .form-group {
      margin-bottom: 15px;
    }

    label {
      display: block;
      margin-bottom: 5px;
    }

    input[type="text"], input[type="email"] {
      width: 100%;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 5px;
      box-sizing: border-box;
    }

    .update-button, .back-button {
      padding: 10px 15px;
      color: white;
      border: none;
      cursor: pointer;
      border-radius: 5px;
      font-size: 16px;
      transition: 0.3s;
    }

    .update-button {
      background-color: #28a745;
    }

    .update-button:hover {
      background-color: #218838;
    }

    .back-button {
      background-color: #dc3545;
      margin-left: 10px;
    }

    .back-button:hover {
      background-color: #c82333;
    }

    .error-message {
      color: red;
      text-align: center;
    }
  </style>
</head>
<body>
<%
  String username = (String) session.getAttribute("username");
  if (username == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  CustomerDAO customerDAO = new CustomerDAO();
  Customer customer = customerDAO.getCustomerByUsername(username);
  if (customer == null) {
    response.sendRedirect("customerDashboard.jsp");
    return;
  }

  String errorMessage = (String) request.getAttribute("errorMessage");
%>

<div class="container">
  <h2>Manage Profile</h2>
  <% if (errorMessage != null) { %>
  <p class="error-message"><%= errorMessage %></p>
  <% } %>
  <form action="updateProfile" method="POST">
    <div class="form-group">
      <label for="name">Name:</label>
      <input type="text" id="name" name="name" value="<%= customer.getName() %>" required>
    </div>
    <div class="form-group">
      <label for="address">Address:</label>
      <input type="text" id="address" name="address" value="<%= customer.getAddress() %>" required>
    </div>
    <div class="form-group">
      <label for="contactNumber">Contact Number:</label>
      <input type="text" id="contactNumber" name="contactNumber" value="<%= customer.getContactNumber() %>" required>
    </div>
    <div class="form-group">
      <label for="email">Email:</label>
      <input type="email" id="email" name="email" value="<%= customer.getEmail() %>" required>
    </div>
    <div>
      <button type="submit" class="update-button">Update Profile</button>
      <a href="customerDashboard" class="back-button">Back to Dashboard</a>
    </div>
  </form>
</div>
</body>
</html>