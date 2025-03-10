<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.sql.*, com.megacitycabservice.service.DatabaseConnection" %>

<html>
<head>
    <title>Payment Receipt</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; text-align: center; }
        table { width: 60%; margin: auto; border-collapse: collapse; border: 1px solid #ddd; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f8f9fa; }
        .download-btn { margin-top: 20px; padding: 10px 20px; background-color: green; color: white; border: none; cursor: pointer; }
        .download-btn:hover { background-color: darkgreen; }
    </style>

    <script>
        function downloadBill() {

            let billFrame = document.createElement("iframe");
            billFrame.style.display = "none";
            billFrame.src = "downloadBill?bookingID=<%= request.getParameter("bookingID") %>";
            document.body.appendChild(billFrame);


            setTimeout(function () {
                window.location.href = "customerDashboard";
            }, 3000);
        }
    </script>
</head>

<body>
<h2>Payment Receipt</h2>

<%
    String bookingID = request.getParameter("bookingID");
    String customerName = "N/A", driverName = "N/A", carModel = "N/A", pickupLocation = "N/A",
            dropoffLocation = "N/A", bookingDate = "N/A";
    double rentalPricePerKm = 0.0, distance = 0.0, totalAmount = 0.0, vat = 0.0, finalAmount = 0.0;

    if (bookingID != null && !bookingID.isEmpty()) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String query = "SELECT b.booking_number, cust.Name AS CustomerName, d.Name AS DriverName, " +
                    "c.Model AS CarModel, b.PickupLocation, b.DropoffLocation, b.BookingDate, " +
                    "c.RentalPricePerKm, b.Distance, (b.Distance * c.RentalPricePerKm * 1.10) AS TotalAmount " +
                    "FROM booking b " +
                    "JOIN customer cust ON b.CustomerID = cust.CustomerID " +
                    "JOIN driver d ON b.DriverID = d.DriverID " +
                    "JOIN car c ON b.CarID = c.CarID " +
                    "WHERE b.booking_number = ?";

            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, Integer.parseInt(bookingID));
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    customerName = rs.getString("CustomerName");
                    driverName = rs.getString("DriverName");
                    carModel = rs.getString("CarModel");
                    pickupLocation = rs.getString("PickupLocation");
                    dropoffLocation = rs.getString("DropoffLocation");
                    bookingDate = rs.getString("BookingDate");
                    rentalPricePerKm = rs.getDouble("RentalPricePerKm");
                    distance = rs.getDouble("Distance");
                    totalAmount = rs.getDouble("TotalAmount");
                    vat = (distance * rentalPricePerKm * 0.10);
                    finalAmount = totalAmount;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<table>
    <tr><th>Booking ID</th><td><%= bookingID %></td></tr>
    <tr><th>Customer Name</th><td><%= customerName %></td></tr>
    <tr><th>Driver Name</th><td><%= driverName %></td></tr>
    <tr><th>Car Model</th><td><%= carModel %></td></tr>
    <tr><th>Pickup Location</th><td><%= pickupLocation %></td></tr>
    <tr><th>Dropoff Location</th><td><%= dropoffLocation %></td></tr>
    <tr><th>Booking Date</th><td><%= bookingDate %></td></tr>
    <tr><th>Rental Price Per Km</th><td><%= String.format("%.2f", rentalPricePerKm) %> LKR</td></tr>
    <tr><th>Distance (Km)</th><td><%= String.format("%.2f", distance) %> Km</td></tr>
    <tr><th>Base Amount</th><td><%= String.format("%.2f", (totalAmount - vat)) %> LKR</td></tr>
    <tr><th>VAT (10%)</th><td><%= String.format("%.2f", vat) %> LKR</td></tr>
    <tr><th>Total Amount</th><td><strong><%= String.format("%.2f", finalAmount) %> LKR</strong></td></tr>
</table>



<button class="download-btn" onclick="downloadBill()">Download Bill</button>

</body>
</html>
