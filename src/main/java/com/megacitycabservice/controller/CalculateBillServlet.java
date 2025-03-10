package com.megacitycabservice.controller;

import com.megacitycabservice.model.Payment;
import com.megacitycabservice.service.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CalculateBillServlet", urlPatterns = {"/calculateBill"})
public class CalculateBillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Payment> payments = new ArrayList<>();
        double totalIncome = 0.0;

        String query = "SELECT * FROM payments";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Payment payment = new Payment(
                        rs.getInt("payment_id"),
                        rs.getInt("booking_number"),
                        rs.getDouble("total_amount"),
                        rs.getTimestamp("payment_date")
                );

                payments.add(payment);
                totalIncome += payment.getTotalAmount();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("payments", payments);
        request.setAttribute("totalIncome", totalIncome);
        request.getRequestDispatcher("calculateBill.jsp").forward(request, response);
    }
}
