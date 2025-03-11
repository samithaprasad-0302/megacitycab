package com.megacitycabservice.controller;

import com.megacitycabservice.service.DatabaseConnection;
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/processBooking")
public class ProcessBookingServlet extends HttpServlet {
    private static final String GOOGLE_API_KEY = "AIzaSyAC25mXxrVn9pTIFZTrH8TokvdZYwZHq9I";


    private static final String TWILIO_ACCOUNT_SID = "ACf3e4b9b6a7b2a04840ce037718b02a53";
    private static final String TWILIO_AUTH_TOKEN = "3801317f7c2493dbaf8925753ea2c5e3";
    private static final String TWILIO_PHONE_NUMBER = "+13312725387";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            session.setAttribute("errorMessage", "You must be logged in to book a cab!");
            response.sendRedirect("login.jsp");
            return;
        }

        String pickupLocation = request.getParameter("pickupLocation");
        String dropoffLocation = request.getParameter("dropoffLocation");
        String bookingDate = request.getParameter("bookingDate");
        String paymentMethod = request.getParameter("paymentMethod");
        String distanceStr = request.getParameter("distance");

        double distance = (distanceStr != null && !distanceStr.isEmpty()) ? Double.parseDouble(distanceStr) : 0;

        int carID = Integer.parseInt(request.getParameter("carID"));
        int driverID = Integer.parseInt(request.getParameter("driverID"));
        int customerID = getCustomerID(username);

        if (customerID == -1) {
            session.setAttribute("errorMessage", "Customer not found!");
            response.sendRedirect("customerDashboard");
            return;
        }

        // Insert booking and update statuses
        String insertBookingQuery = "INSERT INTO booking (CustomerID, CarID, DriverID, PickupLocation, DropoffLocation, BookingDate, PaymentMethod, Distance, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";
        String updateCarStatusQuery = "UPDATE car SET Status = 'Unavailable' WHERE CarID = ?";
        String updateDriverStatusQuery = "UPDATE driver SET Status = 'On a Journey' WHERE DriverID = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement bookingStmt = conn.prepareStatement(insertBookingQuery, PreparedStatement.RETURN_GENERATED_KEYS);
                 PreparedStatement carStmt = conn.prepareStatement(updateCarStatusQuery);
                 PreparedStatement driverStmt = conn.prepareStatement(updateDriverStatusQuery)) {

                // Insert the booking
                bookingStmt.setInt(1, customerID);
                bookingStmt.setInt(2, carID);
                bookingStmt.setInt(3, driverID);
                bookingStmt.setString(4, pickupLocation);
                bookingStmt.setString(5, dropoffLocation);
                bookingStmt.setString(6, bookingDate);
                bookingStmt.setString(7, paymentMethod);
                bookingStmt.setDouble(8, distance);
                bookingStmt.executeUpdate();

                // Get the generated booking number
                int bookingNumber = -1;
                ResultSet generatedKeys = bookingStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    bookingNumber = generatedKeys.getInt(1);
                }

                // Update car and driver status
                carStmt.setInt(1, carID);
                carStmt.executeUpdate();

                driverStmt.setInt(1, driverID);
                driverStmt.executeUpdate();

                conn.commit();

                // Send SMS to the driver
                String driverPhoneNumber = getDriverPhoneNumber(driverID);
                if (driverPhoneNumber != null && !driverPhoneNumber.isEmpty()) {
                    sendSMSToDriver(driverPhoneNumber, bookingNumber, pickupLocation, dropoffLocation, bookingDate);
                    session.setAttribute("successMessage", "Booking successful! Driver has been notified via SMS.");
                } else {
                    session.setAttribute("successMessage", "Booking successful! Failed to notify driver (phone number missing).");
                }

                response.sendRedirect("customerDashboard");

            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                session.setAttribute("errorMessage", "Error processing booking!");
                response.sendRedirect("customerDashboard");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database connection error!");
            response.sendRedirect("customerDashboard");
        }
    }

    private int getCustomerID(String username) {
        int customerID = -1;
        String query = "SELECT CustomerID FROM customer WHERE Username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                customerID = rs.getInt("CustomerID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customerID;
    }

    // Fetch the driver's phone number
    private String getDriverPhoneNumber(int driverID) {
        String phoneNumber = null;
        String query = "SELECT ContactNumber FROM driver WHERE DriverID = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, driverID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                phoneNumber = rs.getString("ContactNumber");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return phoneNumber;
    }

    // Send SMS to the driver using Twilio
    private void sendSMSToDriver(String driverPhoneNumber, int bookingNumber, String pickupLocation, String dropoffLocation, String bookingDate) {
        Twilio.init(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN);

        String messageBody = "New Booking Received! " +
                "Booking ID: " + bookingNumber + "\n" +
                "Pickup: " + pickupLocation + "\n" +
                "Dropoff: " + dropoffLocation + "\n" +
                "Date: " + bookingDate + "\n" +
                "Please log in to accept or reject.";

        try {
            Message.creator(
                    new PhoneNumber(driverPhoneNumber),
                    new PhoneNumber(TWILIO_PHONE_NUMBER),
                    messageBody
            ).create();

            System.out.println("SMS sent successfully to: " + driverPhoneNumber);
        } catch (Exception e) {
            System.out.println("Failed to send SMS to: " + driverPhoneNumber);
            e.printStackTrace();
        }
    }
}