package com.megacitycabservice.controller;

import com.megacitycabservice.service.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/processPayment")
public class ProcessPaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            int bookingID = Integer.parseInt(request.getParameter("bookingID"));
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            double baseAmount = Double.parseDouble(request.getParameter("baseAmount"));
            double tax = Double.parseDouble(request.getParameter("tax"));
            double discount = Double.parseDouble(request.getParameter("discount"));
            String paymentMethod = request.getParameter("paymentMethod");
            String customerName = request.getParameter("customerName");
            String driverName = request.getParameter("driverName");
            String carModel = request.getParameter("carModel");
            String pickupLocation = request.getParameter("pickupLocation");
            String dropoffLocation = request.getParameter("dropoffLocation");
            String bookingDate = request.getParameter("bookingDate");
            String distance = request.getParameter("distance");

            System.out.println("🔹 Debug: Booking ID = " + bookingID);
            System.out.println("🔹 Debug: Total Amount = " + totalAmount);
            System.out.println("🔹 Debug: Payment Method = " + paymentMethod);

            boolean paymentSuccess = processPayment(bookingID, totalAmount, paymentMethod, request);

            if (paymentSuccess) {
                session.setAttribute("successMessage", "Payment successful! Generating bill...");
                response.sendRedirect("bill.jsp?bookingID=" + bookingID +
                        "&baseAmount=" + baseAmount +
                        "&tax=" + tax +
                        "&discount=" + discount +
                        "&totalAmount=" + totalAmount +
                        "&paymentMethod=" + paymentMethod +
                        "&customerName=" + customerName +
                        "&driverName=" + driverName +
                        "&carModel=" + carModel +
                        "&pickupLocation=" + pickupLocation +
                        "&dropoffLocation=" + dropoffLocation +
                        "&bookingDate=" + bookingDate +
                        "&distance=" + distance);
            } else {
                session.setAttribute("errorMessage", "Payment failed! Please try again.");
                response.sendRedirect("payment.jsp?bookingID=" + bookingID +
                        "&baseAmount=" + baseAmount +
                        "&tax=" + tax +
                        "&discount=" + discount +
                        "&totalAmount=" + totalAmount +
                        "&paymentMethod=" + paymentMethod +
                        "&customerName=" + customerName +
                        "&driverName=" + driverName +
                        "&carModel=" + carModel +
                        "&pickupLocation=" + pickupLocation +
                        "&dropoffLocation=" + dropoffLocation +
                        "&bookingDate=" + bookingDate +
                        "&distance=" + distance +
                        "&rideCount=" + request.getParameter("rideCount"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect("payment.jsp?bookingID=" + request.getParameter("bookingID") +
                    "&totalAmount=" + request.getParameter("totalAmount") +
                    "&paymentMethod=" + request.getParameter("paymentMethod") +
                    "&customerName=" + request.getParameter("customerName") +
                    "&driverName=" + request.getParameter("driverName") +
                    "&carModel=" + request.getParameter("carModel") +
                    "&pickupLocation=" + request.getParameter("pickupLocation") +
                    "&dropoffLocation=" + request.getParameter("dropoffLocation") +
                    "&bookingDate=" + request.getParameter("bookingDate") +
                    "&rentalPricePerKm=" + request.getParameter("rentalPricePerKm") +
                    "&distance=" + request.getParameter("distance") +
                    "&rideCount=" + request.getParameter("rideCount"));
        }
    }

    private boolean processPayment(int bookingNumber, double totalAmount, String paymentMethod, HttpServletRequest request) {
        String insertPaymentQuery = "INSERT INTO payments (booking_number, total_amount, payment_date, payment_method) VALUES (?, ?, NOW(), ?)";
        String updateBookingQuery = "UPDATE booking SET PaymentStatus = 'Paid' WHERE booking_number = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement paymentStmt = conn.prepareStatement(insertPaymentQuery);
             PreparedStatement updateStmt = conn.prepareStatement(updateBookingQuery)) {

            conn.setAutoCommit(false);

            System.out.println("🔹 Debug: Booking Number = " + bookingNumber);
            System.out.println("🔹 Debug: Total Amount = " + totalAmount);
            System.out.println("🔹 Debug: Payment Method = " + paymentMethod);

            // Validate card details if payment method is Card
            if ("Card".equals(paymentMethod)) {
                String cardNumber = request.getParameter("cardNumber");
                String expiryDate = request.getParameter("expiryDate");
                String cvv = request.getParameter("cvv");
                String cardHolder = request.getParameter("cardHolder");

                System.out.println("🔹 Debug: Card Number = " + cardNumber);
                System.out.println("🔹 Debug: Expiry Date = " + expiryDate);
                System.out.println("🔹 Debug: CVV = " + cvv);
                System.out.println("🔹 Debug: Card Holder = " + cardHolder);

                if (cardNumber == null || !cardNumber.matches("\\d{16}") ||
                        cvv == null || !cvv.matches("\\d{3,4}") ||
                        expiryDate == null || expiryDate.isEmpty() ||
                        cardHolder == null || cardHolder.trim().isEmpty()) {
                    System.out.println("🔹 Debug: Invalid card details");
                    return false; // Fail if card details are invalid
                }
                // In a real app, integrate with a payment gateway (e.g., Stripe) here
            } else if (!"Cash".equals(paymentMethod)) {
                System.out.println("🔹 Debug: Unsupported payment method");
                return false; // Fail for unsupported methods
            }

            // Insert payment record
            paymentStmt.setInt(1, bookingNumber);
            paymentStmt.setDouble(2, totalAmount);
            paymentStmt.setString(3, paymentMethod);
            int paymentInserted = paymentStmt.executeUpdate();
            System.out.println("🔹 Debug: Payment Inserted = " + paymentInserted);

            // Update booking status
            updateStmt.setInt(1, bookingNumber);
            int bookingUpdated = updateStmt.executeUpdate();
            System.out.println("🔹 Debug: Booking Updated = " + bookingUpdated);

            if (paymentInserted > 0 && bookingUpdated > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}