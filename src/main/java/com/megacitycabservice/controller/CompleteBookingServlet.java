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

@WebServlet("/completeBooking")
public class CompleteBookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingNumber = request.getParameter("bookingNumber");

        if (bookingNumber == null || bookingNumber.isEmpty()) {
            response.sendRedirect("driverDashboard");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false); // Start transaction


            String updateBookingQuery = "UPDATE booking SET Status = 'Completed' WHERE booking_number = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateBookingQuery)) {
                stmt.setInt(1, Integer.parseInt(bookingNumber));
                stmt.executeUpdate();
            }


            int carID = -1, driverID = -1;
            String getCarDriverQuery = "SELECT CarID, DriverID FROM booking WHERE booking_number = ?";
            try (PreparedStatement stmt = conn.prepareStatement(getCarDriverQuery)) {
                stmt.setInt(1, Integer.parseInt(bookingNumber));
                var rs = stmt.executeQuery();
                if (rs.next()) {
                    carID = rs.getInt("CarID");
                    driverID = rs.getInt("DriverID");
                }
            }

            if (carID != -1) {

                String updateCarQuery = "UPDATE car SET Status = 'Available' WHERE CarID = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateCarQuery)) {
                    stmt.setInt(1, carID);
                    stmt.executeUpdate();
                }
            }

            if (driverID != -1) {

                String updateDriverQuery = "UPDATE driver SET Status = 'Available' WHERE DriverID = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateDriverQuery)) {
                    stmt.setInt(1, driverID);
                    stmt.executeUpdate();
                }
            }

            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("driverDashboard");
    }
}
