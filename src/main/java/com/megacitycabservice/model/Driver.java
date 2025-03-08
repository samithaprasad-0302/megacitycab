package com.megacitycabservice.model;

public class Driver {
    private int driverID;
    private String name;
    private int age;
    private String nationality;
    private int drivingExperience;
    private String nic;
    private String contactNumber;
    private String username;
    private String password;
    private String status;

    public Driver(int driverID, String name, int age, String nationality, int drivingExperience,
                  String nic, String contactNumber, String username, String password, String status) {
        this.driverID = driverID;
        this.name = name;
        this.age = age;
        this.nationality = nationality;
        this.drivingExperience = drivingExperience;
        this.nic = nic;
        this.contactNumber = contactNumber;
        this.username = username;
        this.password = password;
        this.status = status;
    }

    // Getters and Setters
    public int getDriverID() { return driverID; }
    public String getName() { return name; }
    public int getAge() { return age; }
    public String getNationality() { return nationality; }
    public int getDrivingExperience() { return drivingExperience; }
    public String getNic() { return nic; }
    public String getContactNumber() { return contactNumber; }
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getStatus() { return status; }

    public void setStatus(String status) { this.status = status; }

    public void setPassword(String s) {
    }
}
