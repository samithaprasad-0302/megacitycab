<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.megacitycabservice.model.Driver" %>

<html>
<head>
    <title>Edit Driver</title>
    <style>
        body { font-family: Arial, sans-serif; }
        form { width: 400px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background-color: #f9f9f9; }
        label { font-weight: bold; margin-top: 10px; display: block; }
        input, select { width: 100%; padding: 8px; margin-top: 5px; box-sizing: border-box; }
        button { margin-top: 15px; padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer; }
        button:hover { background-color: #45a049; }
    </style>
</head>
<body>

<h1 style="text-align: center;">Edit Driver</h1>

<%
    Driver driver = (Driver) request.getAttribute("driver");
    if (driver != null) {
%>
<form action="${pageContext.request.contextPath}/updateDriver" method="POST">
    <input type="hidden" name="driverID" value="<%= driver.getDriverID() %>">

    <label for="name">Name:</label>
    <input type="text" id="name" name="name" value="<%= driver.getName() %>" required>

    <label for="age">Age:</label>
    <input type="number" id="age" name="age" min="18" value="<%= driver.getAge() %>" required>

    <label for="nationality">Nationality:</label>
    <input type="text" id="nationality" name="nationality" value="<%= driver.getNationality() %>" required>

    <label for="drivingExperience">Driving Experience (Years):</label>
    <input type="number" id="drivingExperience" name="drivingExperience" min="0" value="<%= driver.getDrivingExperience() %>" required>

    <label for="nic">NIC:</label>
    <input type="text" id="nic" name="nic" value="<%= driver.getNic() %>" required>

    <label for="contactNumber">Contact Number:</label>
    <input type="text" id="contactNumber" name="contactNumber" value="<%= driver.getContactNumber() %>" required>

    <label for="username">Username:</label>
    <input type="text" id="username" name="username" value="<%= driver.getUsername() %>" required>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" placeholder="Enter new password (leave blank to keep old one)">

    <label for="status">Status:</label>
    <select id="status" name="status" required>
        <option value="Available" <%= "Available".equals(driver.getStatus()) ? "selected" : "" %>>Available</option>
        <option value="On a Journey" <%= "On a Journey".equals(driver.getStatus()) ? "selected" : "" %>>On a Journey</option>
    </select>

    <button type="submit">Update Driver</button>
</form>
<% } else { %>
<p style="text-align: center; color: red;">Driver not found.</p>
<% } %>

</body>
</html>
