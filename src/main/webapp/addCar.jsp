<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Add New Car</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <!-- Using version 11 as requested -->

    <style>
        body {
            font-family: Arial, sans-serif;
            background: url("images/MEGACITY CABS (6).png") no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            width: 400px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            color: #333;
            text-align: center;
        }

        h1 {
            margin-top: 0;
            font-size: 24px;
            color: #333;
        }

        form {
            display: inline-block;
            text-align: left;
            width: 100%;
        }

        label {
            font-weight: bold;
            margin-top: 10px;
            display: block;
        }

        input, select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            color: #333;
            background-color: white;
        }

        button {
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            margin-right: 10px;
        }

        button:hover {
            background-color: #45a049;
        }

        .back-button {
            background-color: #007BFF;
            margin-top: 15px;
        }

        .back-button:hover {
            background-color: #0056b3;
        }

        .error {
            color: red;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }


        .button-group {
            display: flex;
            justify-content: center;
            gap: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Add New Car</h1>

    <form id="addCarForm" action="${pageContext.request.contextPath}/addCar" method="POST" onsubmit="return validateForm();">
        <label for="model">Model:</label>
        <input type="text" id="model" name="model" required>
        <span class="error" id="modelError">❌ Model name is required.</span>

        <label for="licensePlate">License Plate:</label>
        <input type="text" id="licensePlate" name="licensePlate" required pattern="[A-Z0-9\s-]{3,10}">
        <span class="error" id="licenseError">❌ Enter a valid license plate (e.g., ABC 1234).</span>

        <label for="capacity">Capacity:</label>
        <input type="number" id="capacity" name="capacity" min="1" required>
        <span class="error" id="capacityError">❌ Capacity must be at least 1.</span>

        <label for="fuelType">Fuel Type:</label>
        <select id="fuelType" name="fuelType" required>
            <option value="">Select Fuel Type</option>
            <option value="Petrol">Petrol</option>
            <option value="Diesel">Diesel</option>
            <option value="Electric">Electric</option>
            <option value="Hybrid">Hybrid</option>
        </select>
        <span class="error" id="fuelError">❌ Please select a fuel type.</span>

        <label for="rentalPricePerKm">Rental Price per Km (LKR):</label>
        <input type="number" id="rentalPricePerKm" name="rentalPricePerKm" step="0.01" min="1" required>
        <span class="error" id="priceError">❌ Price must be at least 1 LKR.</span>

        <label for="status">Status:</label>
        <select id="status" name="status" required>
            <option value="">Select Status</option>
            <option value="Available">Available</option>
            <option value="Unavailable">Unavailable</option>
        </select>
        <span class="error" id="statusError">❌ Please select a status.</span>

        <div class="button-group">
            <button type="submit">Add Car</button>
            <button type="button" class="back-button" onclick="window.location.href='manageCars'">Back</button>
        </div>
    </form>
</div>

<script>
    function validateForm() {
        let isValid = true;

        let model = document.getElementById("model");
        let licensePlate = document.getElementById("licensePlate");
        let capacity = document.getElementById("capacity");
        let fuelType = document.getElementById("fuelType");
        let rentalPrice = document.getElementById("rentalPricePerKm");
        let status = document.getElementById("status");

        let modelError = document.getElementById("modelError");
        let licenseError = document.getElementById("licenseError");
        let capacityError = document.getElementById("capacityError");
        let fuelError = document.getElementById("fuelError");
        let priceError = document.getElementById("priceError");
        let statusError = document.getElementById("statusError");

        // Hide all error messages initially
        modelError.style.display = "none";
        licenseError.style.display = "none";
        capacityError.style.display = "none";
        fuelError.style.display = "none";
        priceError.style.display = "none";
        statusError.style.display = "none";

        // Validate Model
        if (model.value.trim() === "") {
            modelError.style.display = "block";
            isValid = false;
        }

        // Validate License Plate
        let licensePattern = /^[A-Z0-9\s-]{3,10}$/;
        if (!licensePattern.test(licensePlate.value.trim())) {
            licenseError.style.display = "block";
            isValid = false;
        }

        // Validate Capacity
        if (capacity.value < 1) {
            capacityError.style.display = "block";
            isValid = false;
        }

        // Validate Fuel Type
        if (fuelType.value === "") {
            fuelError.style.display = "block";
            isValid = false;
        }

        // Validate Rental Price
        if (rentalPrice.value < 1) {
            priceError.style.display = "block";
            isValid = false;
        }

        // Validate Status
        if (status.value === "") {
            statusError.style.display = "block";
            isValid = false;
        }

        // Show SweetAlert2 if validation fails
        if (!isValid) {
            Swal.fire({
                icon: 'error',
                title: 'Form Validation Failed',
                text: 'Please fix the errors before submitting.'
            });
        }

        return isValid;
    }
</script>

</body>
</html>