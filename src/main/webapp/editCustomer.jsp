<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.megacitycabservice.model.Customer" %>


<%
  Customer customer = (Customer) request.getAttribute("customer");
  if (customer == null) {
    response.sendRedirect("adminManageCustomers");
    return;
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Customer</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }

    .container {
      background: rgba(255, 255, 255, 0.9);
      padding: 25px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      width: 400px;
      text-align: center;
    }

    h2 {
      margin-bottom: 20px;
      color: #333;
    }

    .form-group {
      text-align: left;
      margin-bottom: 15px;
    }

    .form-group label {
      font-weight: bold;
      display: block;
    }

    .form-group input {
      width: 100%;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 5px;
      font-size: 16px;
    }

    .form-group button {
      width: 100%;
      padding: 10px;
      background-color: #007BFF;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 16px;
    }

    .form-group button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>

<div class="container">
  <h2>Edit Customer</h2>
  <form action="editCustomer" method="post">
    <input type="hidden" name="customerID" value="<%= customer.getCustomerID() %>">

    <div class="form-group">
      <label for="name">Name:</label>
      <input type="text" id="name" name="name" value="<%= customer.getName() %>" required>
    </div>

    <div class="form-group">
      <label for="address">Address:</label>
      <input type="text" id="address" name="address" value="<%= customer.getAddress() %>" required>
    </div>

    <div class="form-group">
      <label for="nic">NIC:</label>
      <input type="text" id="nic" name="nic" value="<%= customer.getNic() %>" required>
    </div>

    <div class="form-group">
      <label for="contactNumber">Contact Number:</label>
      <input type="text" id="contactNumber" name="contactNumber" value="<%= customer.getContactNumber() %>" required>
    </div>

    <div class="form-group">
      <label for="email">Email:</label>
      <input type="email" id="email" name="email" value="<%= customer.getEmail() %>" required>
    </div>

    <div class="form-group">
      <label for="username">Username:</label>
      <input type="text" id="username" name="username" value="<%= customer.getUsername() %>" required>
    </div>

    <div class="form-group">
      <button type="submit">Update Customer</button>
    </div>
  </form>
</div>

</body>
</html>
