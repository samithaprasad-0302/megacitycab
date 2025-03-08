package com.megacitycabservice.model;

public class Car {
    private int carID;
    private String model;
    private String licensePlate;
    private int capacity;
    private String fuelType;
    private double rentalPricePerKm;
    private String status;


    public Car(int carID, String model, String licensePlate, int capacity, String fuelType, double rentalPricePerKm, String status) {
        this.carID = carID;
        this.model = model;
        this.licensePlate = licensePlate;
        this.capacity = capacity;
        this.fuelType = fuelType;
        this.rentalPricePerKm = rentalPricePerKm;
        this.status = status;
    }


    public Car(String model, String licensePlate, int capacity, String fuelType, double rentalPricePerKm, String status) {
        this.model = model;
        this.licensePlate = licensePlate;
        this.capacity = capacity;
        this.fuelType = fuelType;
        this.rentalPricePerKm = rentalPricePerKm;
        this.status = status;
    }

    public int getCarID() { return carID; }
    public void setCarID(int carID) { this.carID = carID; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public String getFuelType() { return fuelType; }
    public void setFuelType(String fuelType) { this.fuelType = fuelType; }

    public double getRentalPricePerKm() { return rentalPricePerKm; }
    public void setRentalPricePerKm(double rentalPricePerKm) { this.rentalPricePerKm = rentalPricePerKm; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
