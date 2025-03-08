package com.megacitycabservice.controller;

import com.megacitycabservice.model.Car;
import com.megacitycabservice.dao.CarDAO;
import com.megacitycabservice.service.DatabaseConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "CarServlet", urlPatterns = {"/manageCars", "/editCar", "/updateCar", "/deleteCar", "/addCar"})
public class CarServlet extends HttpServlet {
    private CarDAO carDAO;

    @Override
    public void init() throws ServletException {
        carDAO = new CarDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/editCar":
                showEditForm(request, response);
                break;
            case "/deleteCar":
                deleteCar(request, response);
                break;
            default:
                listCars(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/updateCar":
                updateCar(request, response);
                break;
            case "/addCar":
                addCar(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
                break;
        }
    }

    private void listCars(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Car> carList = carDAO.getAllCars();
            request.setAttribute("carList", carList);
        } catch (SQLException e) {
            getServletContext().log("Database error in CarServlet", e);
            request.setAttribute("errorMessage", "Database error while fetching cars.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("manageCars.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int carID;
        try {
            carID = Integer.parseInt(request.getParameter("carId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid car ID.");
            return;
        }

        try {
            Car car = carDAO.getCarById(carID);
            if (car != null) {
                request.setAttribute("car", car);
                RequestDispatcher dispatcher = request.getRequestDispatcher("editCar.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Car not found.");
            }
        } catch (SQLException e) {
            getServletContext().log("Database error while fetching car details", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error.");
        }
    }

    private void addCar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String model = request.getParameter("model");
        String licensePlate = request.getParameter("licensePlate");
        String fuelType = request.getParameter("fuelType");
        String status = request.getParameter("status");

        int capacity = parseInt(request.getParameter("capacity"), 0);
        double rentalPricePerKm = parseDouble(request.getParameter("rentalPricePerKm"), 0.0);

        if (model == null || model.isEmpty() || licensePlate == null || licensePlate.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Model and License Plate are required.");
            return;
        }

        if (status == null || status.isEmpty()) {
            status = "Unavailable";
        }

        try {
            boolean isAdded = carDAO.addCar(model, licensePlate, capacity, fuelType, rentalPricePerKm, status);
            if (isAdded) {
                response.sendRedirect("manageCars");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to add car.");
            }
        } catch (SQLException e) {
            getServletContext().log("Database insert error in CarServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void updateCar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int carID;
        try {
            carID = Integer.parseInt(request.getParameter("carID"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid car ID.");
            return;
        }

        String model = request.getParameter("model");
        String licensePlate = request.getParameter("licensePlate");
        String fuelType = request.getParameter("fuelType");
        String status = request.getParameter("status");

        int capacity = parseInt(request.getParameter("capacity"), 0);
        double rentalPricePerKm = parseDouble(request.getParameter("rentalPricePerKm"), 0.0);

        if (status == null || status.isEmpty()) {
            status = "Unavailable";
        }

        try {
            boolean isUpdated = carDAO.updateCar(carID, model, licensePlate, capacity, fuelType, rentalPricePerKm, status);
            if (isUpdated) {
                response.sendRedirect("manageCars");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update car.");
            }
        } catch (SQLException e) {
            getServletContext().log("Database update error in CarServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void deleteCar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int carID;
        try {
            carID = Integer.parseInt(request.getParameter("carId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid car ID.");
            return;
        }

        try {
            boolean isDeleted = carDAO.deleteCar(carID);
            if (isDeleted) {
                response.sendRedirect("manageCars");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete car.");
            }
        } catch (SQLException e) {
            getServletContext().log("Database delete error in CarServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private double parseDouble(String value, double defaultValue) {
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}