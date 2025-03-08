package com.megacitycabservice.dao;

import com.megacitycabservice.model.Car;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CarDAO {

    private Connection getConnection() throws SQLException {
        return com.megacitycabservice.service.DatabaseConnection.getConnection();
    }


    public List<Car> getAllCars() throws SQLException {
        List<Car> carList = new ArrayList<>();
        String query = "SELECT * FROM car";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String status = rs.getString("Status");
                if (status == null || status.trim().isEmpty()) {
                    status = "Unavailable";
                }

                Car car = new Car(
                        rs.getInt("CarID"),
                        rs.getString("Model"),
                        rs.getString("LicensePlate"),
                        rs.getInt("Capacity"),
                        rs.getString("FuelType"),
                        rs.getDouble("RentalPricePerKm"),
                        status
                );
                carList.add(car);
            }
        }
        return carList;
    }


    public Car getCarById(int carID) throws SQLException {
        String query = "SELECT * FROM car WHERE CarID = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, carID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String status = rs.getString("Status");
                if (status == null || status.isEmpty()) {
                    status = "Unavailable";
                }

                return new Car(
                        rs.getInt("CarID"),
                        rs.getString("Model"),
                        rs.getString("LicensePlate"),
                        rs.getInt("Capacity"),
                        rs.getString("FuelType"),
                        rs.getDouble("RentalPricePerKm"),
                        status
                );
            }
            return null;
        }
    }


    public boolean addCar(String model, String licensePlate, int capacity, String fuelType, double rentalPricePerKm, String status) throws SQLException {
        String insertQuery = "INSERT INTO car (Model, LicensePlate, Capacity, FuelType, RentalPricePerKm, Status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
            stmt.setString(1, model);
            stmt.setString(2, licensePlate);
            stmt.setInt(3, capacity);
            stmt.setString(4, fuelType);
            stmt.setDouble(5, rentalPricePerKm);
            stmt.setString(6, status);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        }
    }


    public boolean updateCar(int carID, String model, String licensePlate, int capacity, String fuelType, double rentalPricePerKm, String status) throws SQLException {
        String updateQuery = "UPDATE car SET Model = ?, LicensePlate = ?, Capacity = ?, FuelType = ?, RentalPricePerKm = ?, Status = ? WHERE CarID = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
            stmt.setString(1, model);
            stmt.setString(2, licensePlate);
            stmt.setInt(3, capacity);
            stmt.setString(4, fuelType);
            stmt.setDouble(5, rentalPricePerKm);
            stmt.setString(6, status);
            stmt.setInt(7, carID);

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        }
    }


    public boolean deleteCar(int carID) throws SQLException {
        String deleteQuery = "DELETE FROM car WHERE CarID = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(deleteQuery)) {
            stmt.setInt(1, carID);
            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;
        }
    }
}