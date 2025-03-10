package com.megacitycabservice.controller;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.megacitycabservice.service.DatabaseConnection;
import com.megacitycabservice.dao.CustomerDAO;

@WebServlet({"/registerCustomer", "/updateProfile"})
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/registerCustomer".equals(servletPath)) {
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String nic = request.getParameter("nic");
            String contactNumber = request.getParameter("contactNumber");
            String email = request.getParameter("email");
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            String hashedPassword = hashPassword(password);

            try {
                boolean isRegistered = customerDAO.registerCustomer(name, address, nic, contactNumber, email, username, hashedPassword);
                if (isRegistered) {
                    HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Registration successful! Please log in.");
                    response.sendRedirect("login.jsp");
                    return;
                } else {
                    request.setAttribute("errorMessage", "❌ Registration failed. Please try again.");
                    request.getRequestDispatcher("registerCustomer.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "❌ Database error: " + e.getMessage());
                request.getRequestDispatcher("registerCustomer.jsp").forward(request, response);
            }
        } else if ("/updateProfile".equals(servletPath)) {
            HttpSession session = request.getSession();
            String username = (String) session.getAttribute("username");

            if (username == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String contactNumber = request.getParameter("contactNumber");
            String email = request.getParameter("email");

            try {
                boolean isUpdated = customerDAO.updateCustomerProfile(name, address, contactNumber, email, username);
                if (isUpdated) {
                    session.setAttribute("successMessage", "Profile updated successfully!");
                    response.sendRedirect("customerDashboard");
                } else {
                    request.setAttribute("errorMessage", "❌ Profile update failed. Please try again.");
                    request.getRequestDispatcher("manageProfile.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "❌ Database error: " + e.getMessage());
                request.getRequestDispatcher("manageProfile.jsp").forward(request, response);
            }
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashedBytes) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
}