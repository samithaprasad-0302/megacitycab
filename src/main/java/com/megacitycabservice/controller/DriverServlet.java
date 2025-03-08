package com.megacitycabservice.controller;

import com.megacitycabservice.model.Driver;
import com.megacitycabservice.dao.DriverDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "DriverServlet", urlPatterns = {"/manageDrivers", "/editDriver", "/updateDriver", "/deleteDriver", "/addDriver"})
public class DriverServlet extends HttpServlet {
    private DriverDAO driverDAO;

    @Override
    public void init() throws ServletException {
        driverDAO = new DriverDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/editDriver":
                showEditForm(request, response);
                break;
            case "/deleteDriver":
                deleteDriver(request, response);
                break;
            default:
                listDrivers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/updateDriver":
                updateDriver(request, response);
                break;
            case "/addDriver":
                addDriver(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
                break;
        }
    }

    private void listDrivers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Driver> driverList = driverDAO.getAllDrivers();
            request.setAttribute("driverList", driverList);
        } catch (SQLException e) {
            getServletContext().log("Database error in DriverServlet", e);
            request.setAttribute("errorMessage", "Database error while fetching drivers.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("manageDrivers.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int driverID;
        try {
            driverID = Integer.parseInt(request.getParameter("driverId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid driver ID.");
            return;
        }

        try {
            Driver driver = driverDAO.getDriverById(driverID);
            if (driver != null) {
                request.setAttribute("driver", driver);
                RequestDispatcher dispatcher = request.getRequestDispatcher("editDriver.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Driver not found.");
            }
        } catch (SQLException e) {
            getServletContext().log("Database error while fetching driver details", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error.");
        }
    }

    private void addDriver(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        int age;
        int drivingExperience;
        String nationality = request.getParameter("nationality");
        String nic = request.getParameter("nic");
        String contactNumber = request.getParameter("contactNumber");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String status = request.getParameter("status");

        try {
            age = Integer.parseInt(request.getParameter("age"));
            drivingExperience = Integer.parseInt(request.getParameter("drivingExperience"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid age or driving experience.");
            return;
        }

        String hashedPassword = hashPassword(password);
        if (hashedPassword == null) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to hash password.");
            return;
        }

        try {
            boolean isAdded = driverDAO.addDriver(name, age, nationality, drivingExperience, nic, contactNumber, username, hashedPassword, status);
            if (isAdded) {
                response.sendRedirect("manageDrivers");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to add driver.");
            }
        } catch (SQLException e) {
            getServletContext().log("Database insert error in DriverServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void updateDriver(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int driverID;
        int age;
        int drivingExperience;
        try {
            driverID = Integer.parseInt(request.getParameter("driverID"));
            age = Integer.parseInt(request.getParameter("age"));
            drivingExperience = Integer.parseInt(request.getParameter("drivingExperience"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid driver ID, age, or driving experience.");
            return;
        }

        String name = request.getParameter("name");
        String nationality = request.getParameter("nationality");
        String nic = request.getParameter("nic");
        String contactNumber = request.getParameter("contactNumber");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String status = request.getParameter("status");

        try {
            boolean isUpdated = driverDAO.updateDriver(driverID, name, age, nationality, drivingExperience, nic, contactNumber, username, password, status);
            if (isUpdated) {
                response.sendRedirect("manageDrivers");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update driver.");
            }
        } catch (SQLException e) {
            getServletContext().log("Database update error in DriverServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void deleteDriver(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int driverID;
        try {
            driverID = Integer.parseInt(request.getParameter("driverId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid driver ID.");
            return;
        }

        try {
            boolean isDeleted = driverDAO.deleteDriver(driverID);
            if (isDeleted) {
                response.sendRedirect("manageDrivers");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete driver.");
            }
        } catch (SQLException e) {
            getServletContext().log("Database delete error in DriverServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
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