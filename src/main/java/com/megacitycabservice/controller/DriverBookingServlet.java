package com.megacitycabservice.controller;

import com.megacitycabservice.service.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

@WebServlet("/driverBooking")
public class DriverBookingServlet extends HttpServlet {


    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "infozytech360@gmail.com";
    private static final String EMAIL_PASSWORD = "cldb znfk fkec gvrs";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingNumber = Integer.parseInt(request.getParameter("bookingNumber"));
        String action = request.getParameter("action");


        String customerEmail = getCustomerEmail(bookingNumber);

        if (customerEmail == null) {

            request.getSession().setAttribute("errorMessage", "Failed to notify customer: Email not found.");
        } else {
            if ("accept".equals(action)) {
                confirmBooking(bookingNumber, customerEmail);
                request.getSession().setAttribute("successMessage", "Booking accepted! Customer has been notified.");
            } else if ("reject".equals(action)) {
                rejectBooking(bookingNumber, customerEmail);
                request.getSession().setAttribute("successMessage", "Booking rejected! Customer has been notified.");
            }
        }

        response.sendRedirect("driverDashboard");
    }


    private String getCustomerEmail(int bookingNumber) {
        String email = null;
        String query = "SELECT c.Email " +
                "FROM megacitycabdb.booking b " +
                "JOIN megacitycabdb.customer c ON b.CustomerID = c.CustomerID " +
                "WHERE b.booking_number = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, bookingNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                email = rs.getString("Email");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return email;
    }


    private void confirmBooking(int bookingNumber, String customerEmail) {
        String updateBookingQuery = "UPDATE booking SET Status = 'Confirmed' WHERE booking_number = ?";
        String updateDriverStatusQuery = "UPDATE driver SET Status = 'On a Journey' WHERE DriverID = (SELECT DriverID FROM booking WHERE booking_number = ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement bookingStmt = conn.prepareStatement(updateBookingQuery);
             PreparedStatement driverStmt = conn.prepareStatement(updateDriverStatusQuery)) {

            conn.setAutoCommit(false);


            bookingStmt.setInt(1, bookingNumber);
            bookingStmt.executeUpdate();


            driverStmt.setInt(1, bookingNumber);
            driverStmt.executeUpdate();

            conn.commit();


            String[] bookingDetails = getBookingDetails(bookingNumber);


            String subject = "MegaCity Cab Service - Booking Confirmed (Booking #" + bookingNumber + ")";
            String message = "Dear Customer,\n\n" +
                    "Your booking has been confirmed!\n\n" +
                    "Booking Details:\n" +
                    "Booking ID: " + bookingNumber + "\n" +
                    "Car Model: " + bookingDetails[0] + "\n" +
                    "Pickup Location: " + bookingDetails[1] + "\n" +
                    "Dropoff Location: " + bookingDetails[2] + "\n" +
                    "Booking Date: " + bookingDetails[3] + "\n\n" +
                    "We look forward to serving you!\n\n" +
                    "Best Regards,\n" +
                    "MegaCity Cab Service Team";
            sendEmail(customerEmail, subject, message);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    private void rejectBooking(int bookingNumber, String customerEmail) {
        String deleteBookingQuery = "DELETE FROM booking WHERE booking_number = ?";
        String updateDriverStatusQuery = "UPDATE driver SET Status = 'Available' WHERE DriverID = (SELECT DriverID FROM booking WHERE booking_number = ?)";
        String updateCarStatusQuery = "UPDATE car SET Status = 'Available' WHERE CarID = (SELECT CarID FROM booking WHERE booking_number = ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement deleteStmt = conn.prepareStatement(deleteBookingQuery);
             PreparedStatement driverStmt = conn.prepareStatement(updateDriverStatusQuery);
             PreparedStatement carStmt = conn.prepareStatement(updateCarStatusQuery)) {

            conn.setAutoCommit(false);


            String[] bookingDetails = getBookingDetails(bookingNumber);


            driverStmt.setInt(1, bookingNumber);
            driverStmt.executeUpdate();


            carStmt.setInt(1, bookingNumber);
            carStmt.executeUpdate();


            deleteStmt.setInt(1, bookingNumber);
            deleteStmt.executeUpdate();

            conn.commit();


            String subject = "MegaCity Cab Service - Booking Rejected (Booking #" + bookingNumber + ")";
            String message = "Dear Customer,\n\n" +
                    "We regret to inform you that your booking has been rejected by the driver.\n\n" +
                    "Booking Details:\n" +
                    "Booking ID: " + bookingNumber + "\n" +
                    "Car Model: " + bookingDetails[0] + "\n" +
                    "Pickup Location: " + bookingDetails[1] + "\n" +
                    "Dropoff Location: " + bookingDetails[2] + "\n" +
                    "Booking Date: " + bookingDetails[3] + "\n\n" +
                    "Please try booking another cab from the available options.\n\n" +
                    "Best Regards,\n" +
                    "MegaCity Cab Service Team";
            sendEmail(customerEmail, subject, message);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    private String[] getBookingDetails(int bookingNumber) {
        String[] details = new String[4]; // [carModel, pickupLocation, dropoffLocation, bookingDate]
        String query = "SELECT c.Model AS carModel, b.PickupLocation, b.DropoffLocation, b.BookingDate " +
                "FROM megacitycabdb.booking b " +
                "JOIN megacitycabdb.car c ON b.CarID = c.CarID " +
                "WHERE b.booking_number = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, bookingNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                details[0] = rs.getString("carModel");
                details[1] = rs.getString("PickupLocation");
                details[2] = rs.getString("DropoffLocation");
                details[3] = rs.getString("BookingDate");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }


    private void sendEmail(String toEmail, String subject, String messageText) {

        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);


        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        try {

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(messageText);


            Transport.send(message);
            System.out.println("Email sent successfully to: " + toEmail);

        } catch (MessagingException e) {
            System.out.println("Failed to send email to: " + toEmail);
            e.printStackTrace();
        }
    }
}