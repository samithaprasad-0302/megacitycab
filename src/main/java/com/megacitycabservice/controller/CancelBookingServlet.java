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

@WebServlet(name = "CancelBookingServlet", urlPatterns = {"/cancelBooking"})
public class CancelBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String bookingNumberStr = request.getParameter("bookingNumber");
        String carIDStr = request.getParameter("carID");
        String driverIDStr = request.getParameter("driverID");

        if (bookingNumberStr == null || carIDStr == null || driverIDStr == null ||
                bookingNumberStr.isEmpty() || carIDStr.isEmpty() || driverIDStr.isEmpty()) {
            response.getWriter().println("❌ Error: Missing booking parameters.");
            return;
        }

        int bookingNumber = Integer.parseInt(bookingNumberStr);
        int carID = Integer.parseInt(carIDStr);
        int driverID = Integer.parseInt(driverIDStr);

        // Attempt to delete booking
        boolean success = deleteBooking(bookingNumber, carID, driverID);

        if (success) {
            response.sendRedirect("customerDashboard");
        } else {
            response.getWriter().println("❌ Error: Unable to cancel booking.");
        }
    }

    private boolean deleteBooking(int bookingNumber, int carID, int driverID) {
        String deleteBookingQuery = "DELETE FROM booking WHERE booking_number = ?";
        String updateCarStatusQuery = "UPDATE car SET Status = 'Available' WHERE CarID = ?";
        String updateDriverStatusQuery = "UPDATE driver SET Status = 'Available' WHERE DriverID = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteBookingQuery);
                 PreparedStatement carStmt = conn.prepareStatement(updateCarStatusQuery);
                 PreparedStatement driverStmt = conn.prepareStatement(updateDriverStatusQuery)) {


                deleteStmt.setInt(1, bookingNumber);
                int bookingDeleted = deleteStmt.executeUpdate();


                carStmt.setInt(1, carID);
                int carUpdated = carStmt.executeUpdate();

                driverStmt.setInt(1, driverID);
                int driverUpdated = driverStmt.executeUpdate();

                if (bookingDeleted > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }

            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
