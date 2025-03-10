<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.DecimalFormat" %>
<html>
<head>
    <title>Payment Details</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; text-align: center; }
        .container { width: 50%; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background-color: #f9f9f9; }
        h2 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f0f0f0; }
        .pay-button { padding: 10px 20px; background-color: #4CAF50; color: white; border: none; cursor: pointer; }
        .pay-button:hover { background-color: #45a049; }
        .card-form { margin-top: 20px; display: none; }
        .card-form.active { display: block; }
        .card-form label { display: block; text-align: left; margin-top: 10px; }
        .card-form input { width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ddd; border-radius: 4px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Payment Details</h2>

    <%
        int bookingID = request.getParameter("bookingID") != null ? Integer.parseInt(request.getParameter("bookingID")) : 0;
        String paymentMethod = request.getParameter("paymentMethod") != null ? request.getParameter("paymentMethod") : "Cash";
        System.out.println("🔹 Debug: Payment Method on paymentDetails.jsp = " + paymentMethod);

        String customerName = request.getParameter("customerName") != null ? request.getParameter("customerName") : "N/A";
        String driverName = request.getParameter("driverName") != null ? request.getParameter("driverName") : "N/A";
        String carModel = request.getParameter("carModel") != null ? request.getParameter("carModel") : "N/A";
        String pickupLocation = request.getParameter("pickupLocation") != null ? request.getParameter("pickupLocation") : "N/A";
        String dropoffLocation = request.getParameter("dropoffLocation") != null ? request.getParameter("dropoffLocation") : "N/A";
        String bookingDate = request.getParameter("bookingDate") != null ? request.getParameter("bookingDate") : "N/A";


        BigDecimal rentalPricePerKm = request.getParameter("rentalPricePerKm") != null && !request.getParameter("rentalPricePerKm").isEmpty() ?
                new BigDecimal(request.getParameter("rentalPricePerKm")) : BigDecimal.ZERO;
        BigDecimal distance = request.getParameter("distance") != null && !request.getParameter("distance").isEmpty() ?
                new BigDecimal(request.getParameter("distance")) : BigDecimal.ZERO;


        BigDecimal baseAmount = rentalPricePerKm.multiply(distance).setScale(2, BigDecimal.ROUND_HALF_UP);


        BigDecimal taxRate = new BigDecimal("0.10");
        BigDecimal tax = baseAmount.multiply(taxRate).setScale(2, BigDecimal.ROUND_HALF_UP);


        BigDecimal totalAmount = baseAmount.add(tax);


        int rideCount = request.getParameter("rideCount") != null ? Integer.parseInt(request.getParameter("rideCount")) : 0;
        BigDecimal discount = BigDecimal.ZERO;
        if (rideCount >= 3) {
            BigDecimal discountRate = new BigDecimal("0.05");
            discount = totalAmount.multiply(discountRate).setScale(2, BigDecimal.ROUND_HALF_UP);
            totalAmount = totalAmount.subtract(discount);
        }


        DecimalFormat df = new DecimalFormat("#,##0.00");
        String formattedBaseAmount = df.format(baseAmount);
        String formattedTax = df.format(tax);
        String formattedDiscount = df.format(discount);
        String formattedTotalAmount = df.format(totalAmount);
    %>

    <table>
        <tr><th>Booking ID</th><td><%= bookingID %></td></tr>
        <tr><th>Customer Name</th><td><%= customerName %></td></tr>
        <tr><th>Driver Name</th><td><%= driverName %></td></tr>
        <tr><th>Car Model</th><td><%= carModel %></td></tr>
        <tr><th>Pickup Location</th><td><%= pickupLocation %></td></tr>
        <tr><th>Dropoff Location</th><td><%= dropoffLocation %></td></tr>
        <tr><th>Booking Date</th><td><%= bookingDate %></td></tr>
        <tr><th>Rental Price Per Km</th><td><%= rentalPricePerKm.setScale(2, BigDecimal.ROUND_HALF_UP) %> LKR</td></tr>
        <tr><th>Distance (Km)</th><td><%= distance.setScale(2, BigDecimal.ROUND_HALF_UP) %> Km</td></tr>
        <tr><th>Base Amount</th><td><%= formattedBaseAmount %> LKR</td></tr>
        <tr><th>VAT (10%)</th><td><%= formattedTax %> LKR</td></tr>
        <% if (discount.compareTo(BigDecimal.ZERO) > 0) { %>
        <tr><th>Frequent Customer Discount (5%)</th><td>-<%= formattedDiscount %> LKR</td></tr>
        <% } %>
        <tr><th>Total Amount</th><td><b><%= formattedTotalAmount %> LKR</b></td></tr>
        <tr><th>Payment Method</th><td><%= paymentMethod %></td></tr>
    </table>

    <% if ("Card".equals(paymentMethod)) { %>
    <div class="card-form active">
        <label for="cardNumber">Card Number:</label>
        <input type="text" id="cardNumber" name="cardNumber" placeholder="Enter card number" required pattern="\d{16}" title="Please enter a 16-digit card number">

        <label for="expiryDate">Expiry Date:</label>
        <input type="month" id="expiryDate" name="expiryDate" required>

        <label for="cvv">CVV:</label>
        <input type="text" id="cvv" name="cvv" placeholder="Enter CVV" required pattern="\d{3,4}" title="Please enter a 3 or 4-digit CVV">

        <label for="cardHolder">Card Holder Name:</label>
        <input type="text" id="cardHolder" name="cardHolder" placeholder="Enter card holder name" required>
    </div>
    <% } %>

    <form action="processPayment" method="POST">
        <input type="hidden" name="bookingID" value="<%= bookingID %>">
        <input type="hidden" name="baseAmount" value="<%= baseAmount %>">
        <input type="hidden" name="tax" value="<%= tax %>">
        <input type="hidden" name="discount" value="<%= discount %>">
        <input type="hidden" name="totalAmount" value="<%= totalAmount %>">
        <input type="hidden" name="paymentMethod" value="<%= paymentMethod %>">
        <input type="hidden" name="customerName" value="<%= customerName %>">
        <input type="hidden" name="driverName" value="<%= driverName %>">
        <input type="hidden" name="carModel" value="<%= carModel %>">
        <input type="hidden" name="pickupLocation" value="<%= pickupLocation %>">
        <input type="hidden" name="dropoffLocation" value="<%= dropoffLocation %>">
        <input type="hidden" name="bookingDate" value="<%= bookingDate %>">
        <input type="hidden" name="distance" value="<%= distance %>">
        <% if ("Card".equals(paymentMethod)) { %>
        <input type="hidden" name="cardNumber" id="cardNumberHidden">
        <input type="hidden" name="expiryDate" id="expiryDateHidden">
        <input type="hidden" name="cvv" id="cvvHidden">
        <input type="hidden" name="cardHolder" id="cardHolderHidden">
        <% } %>
        <button type="submit" class="pay-button" onclick="submitPaymentForm()">Confirm Payment</button>
    </form>

    <script>
        function submitPaymentForm() {
            <% if ("Card".equals(paymentMethod)) { %>
            document.getElementById("cardNumberHidden").value = document.getElementById("cardNumber").value;
            document.getElementById("expiryDateHidden").value = document.getElementById("expiryDate").value;
            document.getElementById("cvvHidden").value = document.getElementById("cvv").value;
            document.getElementById("cardHolderHidden").value = document.getElementById("cardHolder").value;

            if (!document.getElementById("cardNumber").value.match(/\d{16}/) ||
                !document.getElementById("cvv").value.match(/\d{3,4}/) ||
                !document.getElementById("expiryDate").value ||
                !document.getElementById("cardHolder").value) {
                alert("Please fill all fields with valid card details.");
                event.preventDefault();
                return;
            }
            <% } %>
        }
    </script>
</div>
</body>
</html>