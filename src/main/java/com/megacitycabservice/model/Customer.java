package com.megacitycabservice.model;

public class Customer {
    private int customerID;
    private String name;
    private String address;
    private String nic;
    private String contactNumber;
    private String email;
    private String username;
    private String password; // Stored as a hashed password

    // Constructor
    public Customer(int customerID, String name, String address, String nic, String contactNumber, String email, String username, String password) {
        this.customerID = customerID;
        this.name = name;
        this.address = address;
        this.nic = nic;
        this.contactNumber = contactNumber;
        this.email = email;
        this.username = username;
        this.password = password;
    }

    // Getters and Setters
    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNic() {
        return nic;
    }

    public void setNic(String nic) {
        this.nic = nic;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
