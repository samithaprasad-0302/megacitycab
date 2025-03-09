package com.megacitycabservice.controller;

import com.megacitycabservice.model.Customer;
import com.megacitycabservice.service.DatabaseConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminManageCustomersServlet", urlPatterns = {"/adminManageCustomers"})
public class AdminManageCustomersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("search");
        String deleteId = request.getParameter("delete");

        if (deleteId != null) {
            deleteCustomer(Integer.parseInt(deleteId));
            response.sendRedirect("adminManageCustomers");
            return;
        }

        List<Customer> customers = (searchQuery == null || searchQuery.isEmpty())
                ? getAllCustomers()
                : searchCustomers(searchQuery);

        request.setAttribute("customerList", customers);
        RequestDispatcher dispatcher = request.getRequestDispatcher("adminManageCustomers.jsp");
        dispatcher.forward(request, response);
    }



    private List<Customer> getAllCustomers() {
        List<Customer> customerList = new ArrayList<>();
        String query = "SELECT CustomerID, Name, Address, NIC, ContactNumber, Email, Username FROM customer";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Customer customer = new Customer(
                        rs.getInt("CustomerID"),
                        rs.getString("Name"),
                        rs.getString("Address"),
                        rs.getString("NIC"),
                        rs.getString("ContactNumber"),
                        rs.getString("Email"),
                        rs.getString("Username"),
                        "" // Don't expose the password
                );
                customerList.add(customer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customerList;
    }

    private List<Customer> searchCustomers(String searchQuery) {
        List<Customer> customerList = new ArrayList<>();
        String query = "SELECT CustomerID, Name, Address, NIC, ContactNumber, Email, Username FROM customer WHERE Name LIKE ? OR NIC LIKE ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, "%" + searchQuery + "%");
            stmt.setString(2, "%" + searchQuery + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Customer customer = new Customer(
                        rs.getInt("CustomerID"),
                        rs.getString("Name"),
                        rs.getString("Address"),
                        rs.getString("NIC"),
                        rs.getString("ContactNumber"),
                        rs.getString("Email"),
                        rs.getString("Username"),
                        "" // Avoid exposing password
                );
                customerList.add(customer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customerList;
    }

    

    private void deleteCustomer(int customerID) {
        String query = "DELETE FROM customer WHERE CustomerID=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, customerID);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
