package com.megacitycabservice.dao;

import com.megacitycabservice.model.User;
import java.sql.*;

public class UserDAO {

    private Connection getConnection() throws SQLException {
        return com.megacitycabservice.service.DatabaseConnection.getConnection();
    }


    public User validateUser(String username, String hashedPassword, String role) throws SQLException {
        String tableName = getTableName(role);
        String usernameColumn = getUsernameColumn(role);

        if (tableName == null) {
            return null;
        }

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM " + tableName + " WHERE " + usernameColumn + " = ? AND password = ?")) {
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                String retrievedUsername = rs.getString(usernameColumn);
                String retrievedPassword = rs.getString("password");
                return new User(retrievedUsername, retrievedPassword, role);
            }
            return null;
        }
    }


    public String getTableName(String role) {
        switch (role.toLowerCase()) {
            case "admin": return "user";
            case "customer": return "customer";
            case "driver": return "driver";
            default: return null;
        }
    }


    public String getUsernameColumn(String role) {
        switch (role.toLowerCase()) {
            case "admin": return "username";
            case "customer": return "Username";
            case "driver": return "Username";
            default: return "username";
        }
    }
}