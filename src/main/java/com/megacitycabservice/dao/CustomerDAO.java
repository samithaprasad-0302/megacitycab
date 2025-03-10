package com.megacitycabservice.dao;

import com.megacitycabservice.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

public class CustomerDAO {

    private Connection getConnection() throws SQLException {
        return com.megacitycabservice.service.DatabaseConnection.getConnection();
    }

    public boolean registerCustomer(String name, String address, String nic, String contactNumber, String email, String username, String hashedPassword) throws SQLException {
        Connection connection = null;
        try {
            connection = getConnection();
            connection.setAutoCommit(false);

            String userSQL = "INSERT INTO user (username, password, role) VALUES (?, ?, ?)";
            try (PreparedStatement userStmt = connection.prepareStatement(userSQL)) {
                userStmt.setString(1, username);
                userStmt.setString(2, hashedPassword);
                userStmt.setString(3, "customer");

                int userInserted = userStmt.executeUpdate();
                if (userInserted <= 0) {
                    connection.rollback();
                    return false;
                }
            }

            String customerSQL = "INSERT INTO customer (Name, Address, NIC, ContactNumber, Email, Username, Password) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement customerStmt = connection.prepareStatement(customerSQL)) {
                customerStmt.setString(1, name);
                customerStmt.setString(2, address);
                customerStmt.setString(3, nic);
                customerStmt.setString(4, contactNumber);
                customerStmt.setString(5, email);
                customerStmt.setString(6, username);
                customerStmt.setString(7, hashedPassword);

                int customerInserted = customerStmt.executeUpdate();
                if (customerInserted > 0) {
                    connection.commit();
                    return true;
                } else {
                    connection.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            if (connection != null) {
                connection.rollback();
            }
            throw e;
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }

    public boolean updateCustomerProfile(String name, String address, String contactNumber, String email, String username) throws SQLException {
        Connection connection = null;
        try {
            connection = getConnection();
            String sql = "UPDATE customer SET Name = ?, Address = ?, ContactNumber = ?, Email = ? WHERE Username = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, address);
                stmt.setString(3, contactNumber);
                stmt.setString(4, email);
                stmt.setString(5, username);

                int rowsUpdated = stmt.executeUpdate();
                return rowsUpdated > 0;
            }
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }

    public com.megacitycabservice.model.Customer getCustomerByUsername(String username) throws SQLException {
        Connection connection = null;
        try {
            connection = getConnection();
            String sql = "SELECT * FROM customer WHERE Username = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, username);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return new com.megacitycabservice.model.Customer(
                                rs.getInt("customerID"),
                                rs.getString("Name"),
                                rs.getString("Address"),
                                rs.getString("NIC"),
                                rs.getString("ContactNumber"),
                                rs.getString("Email"),
                                rs.getString("Username"),
                                rs.getString("Password")
                        );
                    }
                }
            }
            return null;
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }
}