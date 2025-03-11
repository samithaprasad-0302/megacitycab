<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="com.megacitycabservice.model.Booking" %>
<%@ page import="java.util.ArrayList" %>

<html>
<head>
    <title>My Bookings</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { text-align: center; color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: center; }
        th { background-color: #f0f0f0; }
    </style>
</head>
<body>

<h1>My Bookings</h1>

<%
    List<Booking> bookingList = (List<Booking>) request.getAttribute("bookingList");
    if (bookingList == null) {
        bookingList = new ArrayList<>();
    }
%>

<% if (!bookingList.isEmpty()) { %>
<table>
    <thead>
    <tr>
        <th>Car</th>
        <th>Driver</th>
        <th>Booking Date</th>
        <th>Status</th>
    </tr>
    </thead>
    <tbody>
    <% for (Booking booking : bookingList) { %>
    <tr>
        <td><%= booking.getCarModel() %> (Plate: <%= booking.getLicensePlate() %>)</td>
        <td><%= booking.getDriverName() %></td>
        <td><%= booking.getBookingDate() %></td>
        <td><%= booking.getStatus() %></td>
    </tr>
    <% } %>
    </tbody>
</table>
<% } else { %>
<p style="text-align: center; color: red;">No bookings found.</p>
<% } %>

</body>
</html>
