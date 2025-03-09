package com.megacitycabservice.controller;

import com.megacitycabservice.model.Customer;
import com.megacitycabservice.service.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "EditCustomerServlet", urlPatterns = {"/editCustomer"})
public class EditCustomerServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int customerID = Integer.parseInt(request.getParameter("customerId"));

        String query = "SELECT * FROM customer WHERE CustomerID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, customerID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer(
                        rs.getInt("CustomerID"),
                        rs.getString("Name"),
                        rs.getString("Address"),
                        rs.getString("NIC"),
                        rs.getString("ContactNumber"),
                        rs.getString("Email"),
                        rs.getString("Username"),
                        rs.getString("Password")
                );

                request.setAttribute("customer", customer);
                request.getRequestDispatcher("editCustomer.jsp").forward(request, response);
            } else {
                response.sendRedirect("adminManageCustomers.jsp?error=CustomerNotFound");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int customerID = Integer.parseInt(request.getParameter("customerID"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String nic = request.getParameter("nic");
        String contactNumber = request.getParameter("contactNumber");
        String email = request.getParameter("email");
        String username = request.getParameter("username");

        String updateQuery = "UPDATE customer SET Name=?, Address=?, NIC=?, ContactNumber=?, Email=?, Username=? WHERE CustomerID=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateQuery)) {

            stmt.setString(1, name);
            stmt.setString(2, address);
            stmt.setString(3, nic);
            stmt.setString(4, contactNumber);
            stmt.setString(5, email);
            stmt.setString(6, username);
            stmt.setInt(7, customerID);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("adminManageCustomers?success=CustomerUpdated");
            } else {
                request.setAttribute("errorMessage", "Update failed. Try again.");
                request.getRequestDispatcher("editCustomer.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
