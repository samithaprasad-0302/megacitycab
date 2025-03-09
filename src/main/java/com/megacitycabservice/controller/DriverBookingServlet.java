package com.megacitycabservice.controller;

import com.megacitycabservice.service.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/driverBooking")
public class DriverBookingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingNumber = Integer.parseInt(request.getParameter("bookingNumber"));
        String action = request.getParameter("action");

        if ("accept".equals(action)) {
            confirmBooking(bookingNumber);
        } else if ("reject".equals(action)) {
            rejectBooking(bookingNumber);
        }

        response.sendRedirect("driverDashboard");
    }


    private void confirmBooking(int bookingNumber) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    private void rejectBooking(int bookingNumber) {
        String deleteBookingQuery = "DELETE FROM booking WHERE booking_number = ?";
        String updateDriverStatusQuery = "UPDATE driver SET Status = 'Available' WHERE DriverID = (SELECT DriverID FROM booking WHERE booking_number = ?)";
        String updateCarStatusQuery = "UPDATE car SET Status = 'Available' WHERE CarID = (SELECT CarID FROM booking WHERE booking_number = ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement deleteStmt = conn.prepareStatement(deleteBookingQuery);
             PreparedStatement driverStmt = conn.prepareStatement(updateDriverStatusQuery);
             PreparedStatement carStmt = conn.prepareStatement(updateCarStatusQuery)) {

            conn.setAutoCommit(false);

            driverStmt.setInt(1, bookingNumber);
            driverStmt.executeUpdate();

            carStmt.setInt(1, bookingNumber);
            carStmt.executeUpdate();

            deleteStmt.setInt(1, bookingNumber);
            deleteStmt.executeUpdate();

            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
