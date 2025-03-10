package com.megacitycabservice.model;

import java.sql.Timestamp;

public class Payment {
    private int paymentID;
    private int bookingNumber;
    private double totalAmount;
    private Timestamp paymentDate;

    public Payment(int paymentID, int bookingNumber, double totalAmount, Timestamp paymentDate) {
        this.paymentID = paymentID;
        this.bookingNumber = bookingNumber;
        this.totalAmount = totalAmount;
        this.paymentDate = paymentDate;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public int getBookingNumber() {
        return bookingNumber;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }
}
