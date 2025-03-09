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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/driverDashboard")
public class DriverDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String driverUsername = (String) session.getAttribute("username");

        if (driverUsername == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int driverID = getDriverID(driverUsername);
        if (driverID == -1) {
            request.setAttribute("errorMessage", "❌ Driver not found in the system!");
            request.getRequestDispatcher("driverDashboard.jsp").forward(request, response);
            return;
        }

        request.setAttribute("pendingBookings", getBookingsByStatus(driverID, "Pending"));
        request.setAttribute("activeBookings", getBookingsByStatus(driverID, "Confirmed"));
        request.setAttribute("completedBookings", getBookingsByStatus(driverID, "Completed"));

        request.getRequestDispatcher("driverDashboard.jsp").forward(request, response);
    }

    private int getDriverID(String username) {
        int driverID = -1;
        String query = "SELECT DriverID FROM driver WHERE Username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                driverID = rs.getInt("DriverID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return driverID;
    }

    private List<Map<String, String>> getBookingsByStatus(int driverID, String status) {
        List<Map<String, String>> bookings = new ArrayList<>();
        String query = "SELECT b.booking_number, c.Model AS CarModel, cust.Name AS CustomerName, " +
                "b.PickupLocation, b.DropoffLocation, b.BookingDate, b.Status " +
                "FROM booking b " +
                "JOIN car c ON b.CarID = c.CarID " +
                "JOIN customer cust ON b.CustomerID = cust.CustomerID " +
                "WHERE b.DriverID = ? AND b.Status = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, driverID);
            stmt.setString(2, status);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> booking = new HashMap<>();
                booking.put("bookingNumber", rs.getString("booking_number"));
                booking.put("carModel", rs.getString("CarModel"));
                booking.put("customerName", rs.getString("CustomerName"));
                booking.put("pickupLocation", rs.getString("PickupLocation"));
                booking.put("dropoffLocation", rs.getString("DropoffLocation"));
                booking.put("bookingDate", rs.getString("BookingDate"));
                booking.put("status", rs.getString("Status"));

                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }
}
