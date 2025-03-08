package com.megacitycabservice.dao;

import com.megacitycabservice.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

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
}