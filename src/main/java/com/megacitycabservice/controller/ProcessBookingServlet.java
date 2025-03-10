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
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;
import org.json.JSONArray;

@WebServlet("/processBooking")
public class ProcessBookingServlet extends HttpServlet {
    private static final String GOOGLE_API_KEY = "AIzaSyAC25mXxrVn9pTIFZTrH8TokvdZYwZHq9I"; // Replace with your Google API key

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
        String distanceStr = request.getParameter("distance"); // Get the autofilled distance

        double distance = (distanceStr != null && !distanceStr.isEmpty()) ? Double.parseDouble(distanceStr) : 0;

        int carID = Integer.parseInt(request.getParameter("carID"));
        int driverID = Integer.parseInt(request.getParameter("driverID"));
        int customerID = getCustomerID(username);

        if (customerID == -1) {
            session.setAttribute("errorMessage", "Customer not found!");
            response.sendRedirect("customerDashboard");
            return;
        }

        String insertBookingQuery = "INSERT INTO booking (CustomerID, CarID, DriverID, PickupLocation, DropoffLocation, BookingDate, PaymentMethod, Distance, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";
        String updateCarStatusQuery = "UPDATE car SET Status = 'Unavailable' WHERE CarID = ?";
        String updateDriverStatusQuery = "UPDATE driver SET Status = 'On a Journey' WHERE DriverID = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement bookingStmt = conn.prepareStatement(insertBookingQuery);
                 PreparedStatement carStmt = conn.prepareStatement(updateCarStatusQuery);
                 PreparedStatement driverStmt = conn.prepareStatement(updateDriverStatusQuery)) {

                bookingStmt.setInt(1, customerID);
                bookingStmt.setInt(2, carID);
                bookingStmt.setInt(3, driverID);
                bookingStmt.setString(4, pickupLocation);
                bookingStmt.setString(5, dropoffLocation);
                bookingStmt.setString(6, bookingDate);
                bookingStmt.setString(7, paymentMethod);
                bookingStmt.setDouble(8, distance);
                bookingStmt.executeUpdate();

                carStmt.setInt(1, carID);
                carStmt.executeUpdate();

                driverStmt.setInt(1, driverID);
                driverStmt.executeUpdate();

                conn.commit();

                session.setAttribute("successMessage", "Booking successful! Please wait for the driver's response.");

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
}