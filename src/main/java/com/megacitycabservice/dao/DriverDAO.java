package com.megacitycabservice.dao;

import com.megacitycabservice.model.Driver;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DriverDAO {

    private Connection getConnection() throws SQLException {
        return com.megacitycabservice.service.DatabaseConnection.getConnection();
    }


    public List<Driver> getAllDrivers() throws SQLException {
        List<Driver> driverList = new ArrayList<>();
        String query = "SELECT * FROM driver";

        try (Connection conn = getConnection();
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
                        rs.getString("Username"),
                        rs.getString("Password"),
                        rs.getString("Status")
                );
                driverList.add(driver);
            }
        }
        return driverList;
    }


    public Driver getDriverById(int driverID) throws SQLException {
        String query = "SELECT * FROM driver WHERE DriverID = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, driverID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Driver(
                        rs.getInt("DriverID"),
                        rs.getString("Name"),
                        rs.getInt("Age"),
                        rs.getString("Nationality"),
                        rs.getInt("DrivingExperience"),
                        rs.getString("NIC"),
                        rs.getString("ContactNumber"),
                        rs.getString("Username"),
                        rs.getString("Password"),
                        rs.getString("Status")
                );
            }
            return null;
        }
    }


    public boolean addDriver(String name, int age, String nationality, int drivingExperience, String nic, String contactNumber, String username, String hashedPassword, String status) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // Insert into driver table
            String insertDriverQuery = "INSERT INTO driver (Name, Age, Nationality, DrivingExperience, NIC, ContactNumber, Username, Password, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmtDriver = conn.prepareStatement(insertDriverQuery)) {
                stmtDriver.setString(1, name);
                stmtDriver.setInt(2, age);
                stmtDriver.setString(3, nationality);
                stmtDriver.setInt(4, drivingExperience);
                stmtDriver.setString(5, nic);
                stmtDriver.setString(6, contactNumber);
                stmtDriver.setString(7, username);
                stmtDriver.setString(8, hashedPassword);
                stmtDriver.setString(9, status);
                int driverInserted = stmtDriver.executeUpdate();
                if (driverInserted <= 0) {
                    conn.rollback();
                    return false;
                }
            }


            String insertUserQuery = "INSERT INTO user (Username, Password, Role) VALUES (?, ?, ?)";
            try (PreparedStatement stmtUser = conn.prepareStatement(insertUserQuery)) {
                stmtUser.setString(1, username);
                stmtUser.setString(2, hashedPassword);
                stmtUser.setString(3, "driver");
                int userInserted = stmtUser.executeUpdate();
                if (userInserted <= 0) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }


    public boolean updateDriver(int driverID, String name, int age, String nationality, int drivingExperience, String nic, String contactNumber, String username, String password, String status) throws SQLException {
        String updateQuery;
        if (password != null && !password.isEmpty()) {
            updateQuery = "UPDATE driver SET Name = ?, Age = ?, Nationality = ?, DrivingExperience = ?, NIC = ?, ContactNumber = ?, Username = ?, Password = ?, Status = ? WHERE DriverID = ?";
        } else {
            updateQuery = "UPDATE driver SET Name = ?, Age = ?, Nationality = ?, DrivingExperience = ?, NIC = ?, ContactNumber = ?, Username = ?, Status = ? WHERE DriverID = ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
            stmt.setString(1, name);
            stmt.setInt(2, age);
            stmt.setString(3, nationality);
            stmt.setInt(4, drivingExperience);
            stmt.setString(5, nic);
            stmt.setString(6, contactNumber);
            stmt.setString(7, username);

            if (password != null && !password.isEmpty()) {
                stmt.setString(8, password);
                stmt.setString(9, status);
                stmt.setInt(10, driverID);
            } else {
                stmt.setString(8, status);
                stmt.setInt(9, driverID);
            }

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        }
    }


    public boolean deleteDriver(int driverID) throws SQLException {
        String deleteQuery = "DELETE FROM driver WHERE DriverID = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(deleteQuery)) {
            stmt.setInt(1, driverID);
            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;
        }
    }
}