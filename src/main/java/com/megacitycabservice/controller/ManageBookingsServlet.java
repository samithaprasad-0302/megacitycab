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
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;

@WebServlet({"/manageBookings", "/markAsPaid", "/markAsCompleted", "/generateMonthlyReport"})
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
            case "/generateMonthlyReport":
                generateMonthlyReport(request, response);
                break;
            default:
                listBookings(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if ("/generateMonthlyReport".equals(request.getServletPath())) {
            generateMonthlyReport(request, response);
        }
    }


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

    private void generateMonthlyReport(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String month = request.getParameter("month");
        String year = request.getParameter("year");
        List<Booking> bookingList = new ArrayList<>();


        String startDate = year + "-" + month + "-01 00:00:00";
        String endDate = year + "-" + month + "-31 23:59:59";
        String query = "SELECT * FROM booking WHERE BookingDate BETWEEN ? AND ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, startDate);
            stmt.setString(2, endDate);
            ResultSet rs = stmt.executeQuery();

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
            getServletContext().log("Database error while generating monthly report", e);
            response.sendRedirect("manageBookings");
            return;
        }

        // Generate CSV content
        StringBuilder csvContent = new StringBuilder();
        csvContent.append("Booking Number,Customer ID,Car ID,Pickup Location,Dropoff Location,Booking Date,Payment Method,Distance (km),Status,Payment Status\n");

        for (Booking booking : bookingList) {
            csvContent.append(String.format("%d,%d,%d,\"%s\",\"%s\",\"%s\",\"%s\",%d,\"%s\",\"%s\"\n",
                    booking.getBookingNumber(),
                    booking.getCustomerID(),
                    booking.getCarID(),
                    booking.getPickupLocation().replace("\"", "\"\""),
                    booking.getDropoffLocation().replace("\"", "\"\""),
                    booking.getBookingDate(),
                    booking.getPaymentMethod(),
                    booking.getDistance(),
                    booking.getStatus(),
                    booking.getPaymentStatus()));
        }

        // Set response headers for file download
        response.setContentType("text/csv");
        String fileName = "monthly_booking_report_" + month + "_" + year + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // Write CSV content to response
        response.getWriter().write(csvContent.toString());
    }
}