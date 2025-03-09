package com.megacitycabservice.controller;

import com.megacitycabservice.model.Booking;
import com.megacitycabservice.service.DatabaseConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/manageBookings", "/markAsPaid", "/markAsCompleted"})
public class ManageBookingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {

            case "/markAsPaid":
                markAsPaid(request, response);
                break;
            case "/markAsCompleted":
                markAsCompleted(request, response);
                break;
            default:
                listBookings(request, response);
                break;
        }
    }

    /**
     * Fetches all bookings from the database and forwards to adminManageBookings.jsp
     */
    private void listBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Booking> bookingList = new ArrayList<>();
        String query = "SELECT * FROM booking";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Booking booking = new Booking(
                        rs.getInt("booking_number"),
                        rs.getInt("CustomerID"),
                        rs.getInt("CarID"),
                        rs.getString("PickupLocation"),
                        rs.getString("DropoffLocation"),
                        rs.getTimestamp("BookingDate"),
                        rs.getString("PaymentMethod"),
                        rs.getInt("Distance"),
                        rs.getString("Status"),
                        rs.getString("PaymentStatus")
                );
                bookingList.add(booking);
            }

        } catch (SQLException e) {
            getServletContext().log("Database error in ManageBookingsServlet", e);
        }

        request.setAttribute("bookingList", bookingList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("adminManageBookings.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Cancels a booking by removing it from the database.
     */


    /**
     * Marks a booking as 'Paid' in the database.
     */
    private void markAsPaid(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int bookingNumber = Integer.parseInt(request.getParameter("bookingNumber"));
        String query = "UPDATE booking SET PaymentStatus = 'Paid' WHERE booking_number = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, bookingNumber);
            stmt.executeUpdate();
        } catch (SQLException e) {
            getServletContext().log("Database error while marking booking as Paid", e);
        }

        response.sendRedirect("manageBookings");
    }

    /**
     * Marks a booking as 'Completed' in the database.
     */
    private void markAsCompleted(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int bookingNumber = Integer.parseInt(request.getParameter("bookingNumber"));
        String query = "UPDATE booking SET Status = 'Completed' WHERE booking_number = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, bookingNumber);
            stmt.executeUpdate();
        } catch (SQLException e) {
            getServletContext().log("Database error while marking booking as Completed", e);
        }

        response.sendRedirect("manageBookings");
    }
}
