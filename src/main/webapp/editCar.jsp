<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.megacitycabservice.model.Car" %>
<html>
<head>
    <title>Edit Car</title>
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

<h1 style="text-align: center;">Edit Car</h1>

<%
    Car car = (Car) request.getAttribute("car");
    if (car != null) {
%>
<form action="${pageContext.request.contextPath}/updateCar" method="POST">
    <input type="hidden" name="carID" value="<%= car.getCarID() %>">

    <label for="model">Model:</label>
    <input type="text" id="model" name="model" value="<%= car.getModel() %>" required>

    <label for="licensePlate">License Plate:</label>
    <input type="text" id="licensePlate" name="licensePlate" value="<%= car.getLicensePlate() %>" required>

    <label for="capacity">Capacity:</label>
    <input type="number" id="capacity" name="capacity" min="1" value="<%= car.getCapacity() %>" required>

    <label for="fuelType">Fuel Type:</label>
    <select id="fuelType" name="fuelType" required>
        <option value="Petrol" <%= "Petrol".equals(car.getFuelType()) ? "selected" : "" %>>Petrol</option>
        <option value="Diesel" <%= "Diesel".equals(car.getFuelType()) ? "selected" : "" %>>Diesel</option>
        <option value="Electric" <%= "Electric".equals(car.getFuelType()) ? "selected" : "" %>>Electric</option>
        <option value="Hybrid" <%= "Hybrid".equals(car.getFuelType()) ? "selected" : "" %>>Hybrid</option>
    </select>

    <label for="rentalPricePerKm">Rental Price per Km (LKR):</label>
    <input type="number" id="rentalPricePerKm" name="rentalPricePerKm" step="0.01" min="0" value="<%= car.getRentalPricePerKm() %>" required>

    <label for="status">Status:</label>
    <select id="status" name="status" required>
        <option value="Available" <%= (car.getStatus() != null && car.getStatus().equals("Available")) ? "selected" : "" %>>Available</option>
        <option value="Unavailable" <%= (car.getStatus() != null && car.getStatus().equals("Unavailable")) ? "selected" : "" %>>Unavailable</option>
    </select>

    <button type="submit">Update Car</button>
</form>
<% } else { %>
<p style="text-align: center; color: red;">Car not found.</p>
<% } %>

</body>
</html>
