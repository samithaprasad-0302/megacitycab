package com.megacitycabservice.model;

import java.sql.Timestamp;

public class Booking {
    private int bookingNumber;
    private int customerID;
    private int carID;
    private String pickupLocation;
    private String dropoffLocation;
    private Timestamp bookingDate;
    private String paymentMethod;
    private int distance;
    private String status;
    private String paymentStatus;

    // Constructor
    public Booking(int bookingNumber, int customerID, int carID, String pickupLocation, String dropoffLocation,
                   Timestamp bookingDate, String paymentMethod, int distance, String status, String paymentStatus) {
        this.bookingNumber = bookingNumber;
        this.customerID = customerID;
        this.carID = carID;
        this.pickupLocation = pickupLocation;
        this.dropoffLocation = dropoffLocation;
        this.bookingDate = bookingDate;
        this.paymentMethod = paymentMethod;
        this.distance = distance;
        this.status = status;
        this.paymentStatus = paymentStatus;
    }

    // Getters
    public int getBookingNumber() { return bookingNumber; }
    public int getCustomerID() { return customerID; }
    public int getCarID() { return carID; }
    public String getPickupLocation() { return pickupLocation; }
    public String getDropoffLocation() { return dropoffLocation; }
    public Timestamp getBookingDate() { return bookingDate; }
    public String getPaymentMethod() { return paymentMethod; }
    public int getDistance() { return distance; }
    public String getStatus() { return status; }
    public String getPaymentStatus() { return paymentStatus; }

    // Setters
    public void setBookingNumber(int bookingNumber) { this.bookingNumber = bookingNumber; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }
    public void setCarID(int carID) { this.carID = carID; }
    public void setPickupLocation(String pickupLocation) { this.pickupLocation = pickupLocation; }
    public void setDropoffLocation(String dropoffLocation) { this.dropoffLocation = dropoffLocation; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public void setDistance(int distance) { this.distance = distance; }
    public void setStatus(String status) { this.status = status; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
}
