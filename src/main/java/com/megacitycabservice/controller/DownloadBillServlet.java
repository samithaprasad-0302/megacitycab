package com.megacitycabservice.controller;

import com.megacitycabservice.service.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;

@WebServlet("/downloadBill")
public class DownloadBillServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));


        String customerName = "", driverName = "", carModel = "", pickupLocation = "", dropoffLocation = "", bookingDate = "";
        double rentalPricePerKm = 60.0, distance = 0.0, totalAmount = 0.0;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT b.booking_number, cust.Name AS CustomerName, d.Name AS DriverName, " +
                             "c.Model AS CarModel, b.PickupLocation, b.DropoffLocation, b.BookingDate, " +
                             "b.Distance, (b.Distance * c.RentalPricePerKm * 1.10) AS TotalAmount " +
                             "FROM booking b " +
                             "JOIN customer cust ON b.CustomerID = cust.CustomerID " +
                             "JOIN driver d ON b.DriverID = d.DriverID " +
                             "JOIN car c ON b.CarID = c.CarID " +
                             "WHERE b.booking_number = ?"
             )

        ) {

            stmt.setInt(1, bookingID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                customerName = rs.getString("CustomerName");
                driverName = rs.getString("DriverName");
                carModel = rs.getString("CarModel");
                pickupLocation = rs.getString("PickupLocation");
                dropoffLocation = rs.getString("DropoffLocation");
                bookingDate = rs.getString("BookingDate");
                distance = rs.getDouble("Distance");
                totalAmount = rs.getDouble("TotalAmount");
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("❌ Database Error: " + e.getMessage());
            return;
        }


        PDDocument document = new PDDocument();
        PDPage page = new PDPage();
        document.addPage(page);

        try (PDPageContentStream contentStream = new PDPageContentStream(document, page)) {
            contentStream.setFont(PDType1Font.HELVETICA_BOLD, 14);
            contentStream.beginText();
            contentStream.newLineAtOffset(100, 700);
            contentStream.showText("MegaCity Cab Service - Payment Receipt");
            contentStream.endText();


            contentStream.setFont(PDType1Font.HELVETICA, 12);
            contentStream.beginText();
            contentStream.newLineAtOffset(100, 670);
            contentStream.showText("Booking Number: " + bookingID);
            contentStream.newLineAtOffset(0, -20);
            contentStream.showText("Customer Name: " + customerName);
            contentStream.newLineAtOffset(0, -20);
            contentStream.showText("Driver Name: " + driverName);
            contentStream.newLineAtOffset(0, -20);
            contentStream.showText("Car Model: " + carModel);
            contentStream.newLineAtOffset(0, -20);
            contentStream.showText("Pickup Location: " + pickupLocation);
            contentStream.newLineAtOffset(0, -20);
            contentStream.showText("Dropoff Location: " + dropoffLocation);
            contentStream.newLineAtOffset(0, -20);
            contentStream.showText("Booking Date: " + bookingDate);
            contentStream.newLineAtOffset(0, -20);
            contentStream.showText("Distance: " + distance + " Km");


            double vat = distance * rentalPricePerKm * 0.10;
            double finalAmount = totalAmount;
            contentStream.newLineAtOffset(0, -20);
            contentStream.showText("Base Amount: " + (totalAmount - vat) + " LKR");
            contentStream.newLineAtOffset(0, -20);
            contentStream.showText("VAT (10%): " + vat + " LKR");
            contentStream.newLineAtOffset(0, -20);
            contentStream.showText("Total Amount: " + finalAmount + " LKR");

            contentStream.endText();


        }


        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Bill_" + bookingID + ".pdf");

        OutputStream out = response.getOutputStream();
        document.save(out);
        document.close();
        out.flush();
    }
}
