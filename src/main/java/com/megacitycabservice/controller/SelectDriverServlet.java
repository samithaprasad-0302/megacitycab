package com.megacitycabservice.controller;

import com.megacitycabservice.model.Driver;
import com.megacitycabservice.service.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/selectDriver")
public class SelectDriverServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Driver> availableDrivers = new ArrayList<>();
        int carID = Integer.parseInt(request.getParameter("carID"));
        String carModel = getCarModelById(carID);


        String query = "SELECT DriverID, Name, Age, Nationality, DrivingExperience, NIC, ContactNumber, Status FROM driver WHERE Status = 'Available'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Driver driver = new Driver(
                        rs.getInt("DriverID"),
                        rs.getString("Name"),
                        rs.getInt("Age"),
                        rs.getString("Nationality"),
                        rs.getInt("DrivingExperience"),
                        rs.getString("NIC"),
                        rs.getString("ContactNumber"),
                        rs.getString("Status"),
                        null,
                        null
                );
                availableDrivers.add(driver);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }


        request.setAttribute("availableDrivers", availableDrivers);
        request.setAttribute("carID", carID);
        request.setAttribute("carModel", carModel);
        RequestDispatcher dispatcher = request.getRequestDispatcher("selectDriver.jsp");
        dispatcher.forward(request, response);
    }


    private String getCarModelById(int carID) {
        String carModel = "Unknown";
        String query = "SELECT Model FROM car WHERE CarID = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, carID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                carModel = rs.getString("Model");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return carModel;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
