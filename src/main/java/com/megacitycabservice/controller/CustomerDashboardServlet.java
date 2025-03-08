package com.megacitycabservice.controller;

import com.megacitycabservice.model.Car;
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

@WebServlet(name = "CustomerDashboardServlet", urlPatterns = {"/customerDashboard"})
public class CustomerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        listAvailableCars(request);
        listCustomerBookings(request);

        request.getRequestDispatcher("customerDashboard.jsp").forward(request, response);
    }


    private void listAvailableCars(HttpServletRequest request) {
        List<Car> availableCars = new ArrayList<>();
        String query = "SELECT * FROM car WHERE Status = 'Available'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Car car = new Car(
                        rs.getInt("CarID"),
                        rs.getString("Model"),
                        rs.getString("LicensePlate"),
                        rs.getInt("Capacity"),
                        rs.getString("FuelType"),
                        rs.getDouble("RentalPricePerKm"),
                        rs.getString("Status")
                );
                availableCars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("availableCars", availableCars);
    }


    private void listCustomerBookings(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            return;
        }

        List<Map<String, String>> bookings = new ArrayList<>();
        String query = "SELECT b.booking_number, b.CarID, b.DriverID, c.Model AS CarModel, d.Name AS DriverName, " +
                "b.PickupLocation, b.DropoffLocation, b.BookingDate, b.PaymentMethod, b.PaymentStatus, " +
                "b.Distance, c.RentalPricePerKm, b.Status " +
                "FROM booking b " +
                "JOIN car c ON b.CarID = c.CarID " +
                "JOIN driver d ON b.DriverID = d.DriverID " +
                "JOIN customer cust ON b.CustomerID = cust.CustomerID " +
                "WHERE cust.Username = ? AND (b.Status = 'Confirmed' OR b.Status = 'Completed')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> booking = new HashMap<>();
                booking.put("bookingNumber", rs.getString("booking_number"));
                booking.put("carID", rs.getString("CarID"));
                booking.put("driverID", rs.getString("DriverID"));
                booking.put("carModel", rs.getString("CarModel"));
                booking.put("driverName", rs.getString("DriverName"));
                booking.put("pickupLocation", rs.getString("PickupLocation"));
                booking.put("dropoffLocation", rs.getString("DropoffLocation"));
                booking.put("bookingDate", rs.getString("BookingDate"));
                booking.put("paymentMethod", rs.getString("PaymentMethod"));
                booking.put("paymentStatus", rs.getString("PaymentStatus"));
                booking.put("rentalPricePerKm", rs.getString("RentalPricePerKm"));
                booking.put("distance", rs.getString("Distance"));
                booking.put("status", rs.getString("Status"));

                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("customerBookings", bookings);
    }
}
