package com.megacitycabservice.controller;

import com.megacitycabservice.dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");


        if ("admin".equalsIgnoreCase(username)) {
            role = "admin";
        }

        String tableName = userDAO.getTableName(role);
        if (tableName == null) {
            request.setAttribute("errorMessage", "Invalid role selected!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String hashedPassword = hashPassword(password);

        try {

            com.megacitycabservice.model.User user = userDAO.validateUser(username, hashedPassword, role);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                session.setAttribute("successMessage", "Login Successful!");

                if ("admin".equals(role)) {
                    response.sendRedirect("adminDashboard.jsp");
                } else if ("customer".equals(role)) {
                    response.sendRedirect("customerDashboard");
                } else if ("driver".equals(role)) {
                    response.sendRedirect("driverDashboard");
                }
            } else {
                request.setAttribute("errorMessage", "Invalid username or password!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database connection error: " + e.getMessage());
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
}