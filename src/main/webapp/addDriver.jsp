<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
  <title>Add New Driver</title>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

  <style>
    body {
      font-family: Arial, sans-serif;
      background: url("images/MEGACITY CABS (9).png") no-repeat center center fixed;
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
  <h1>Add New Driver</h1>

  <form id="addDriverForm" action="${pageContext.request.contextPath}/addDriver" method="POST" onsubmit="return validateForm();">
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" required>
    <span class="error" id="nameError">❌ Name is required.</span>

    <label for="age">Age:</label>
    <input type="number" id="age" name="age" min="18" required>
    <span class="error" id="ageError">❌ Age must be at least 18.</span>

    <label for="nationality">Nationality:</label>
    <input type="text" id="nationality" name="nationality" required>
    <span class="error" id="nationalityError">❌ Nationality is required.</span>

    <label for="drivingExperience">Driving Experience (Years):</label>
    <input type="number" id="drivingExperience" name="drivingExperience" min="0" required>
    <span class="error" id="experienceError">❌ Driving experience must be 0 or greater.</span>

    <label for="nic">NIC:</label>
    <input type="text" id="nic" name="nic" required pattern="^[0-9]{9}[VvXx]?$|^[0-9]{12}$">
    <span class="error" id="nicError">❌ Enter a valid NIC (e.g., 123456789V or 200012345678).</span>

    <label for="contactNumber">Contact Number:</label>
    <input type="text" id="contactNumber" name="contactNumber" required pattern="^\d{10}$">
    <span class="error" id="contactError">❌ Contact number must be 10 digits.</span>

    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required>
    <span class="error" id="usernameError">❌ Username is required.</span>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>
    <span class="error" id="passwordError">❌ Password is required.</span>

    <label for="status">Status:</label>
    <select id="status" name="status" required>
      <option value="">Select Status</option>
      <option value="Available">Available</option>
      <option value="On a Journey">On a Journey</option>
    </select>
    <span class="error" id="statusError">❌ Please select a status.</span>

    <div class="button-group">
      <button type="submit">Add Driver</button>
      <button type="button" class="back-button" onclick="window.location.href='manageDrivers'">Back</button>
    </div>
  </form>
</div>

<script>
  function validateForm() {
    let isValid = true;

    let name = document.getElementById("name");
    let age = document.getElementById("age");
    let nationality = document.getElementById("nationality");
    let drivingExperience = document.getElementById("drivingExperience");
    let nic = document.getElementById("nic");
    let contactNumber = document.getElementById("contactNumber");
    let username = document.getElementById("username");
    let password = document.getElementById("password");
    let status = document.getElementById("status");

    let nameError = document.getElementById("nameError");
    let ageError = document.getElementById("ageError");
    let nationalityError = document.getElementById("nationalityError");
    let experienceError = document.getElementById("experienceError");
    let nicError = document.getElementById("nicError");
    let contactError = document.getElementById("contactError");
    let usernameError = document.getElementById("usernameError");
    let passwordError = document.getElementById("passwordError");
    let statusError = document.getElementById("statusError");


    document.querySelectorAll(".error").forEach(e => e.style.display = "none");


    if (name.value.trim() === "") { nameError.style.display = "block"; isValid = false; }


    if (age.value < 18) { ageError.style.display = "block"; isValid = false; }


    if (nationality.value.trim() === "") { nationalityError.style.display = "block"; isValid = false; }


    if (drivingExperience.value < 0) { experienceError.style.display = "block"; isValid = false; }


    if (!nic.checkValidity()) { nicError.style.display = "block"; isValid = false; }


    if (!contactNumber.checkValidity()) { contactError.style.display = "block"; isValid = false; }


    if (username.value.trim() === "") { usernameError.style.display = "block"; isValid = false; }


    if (password.value.trim() === "") { passwordError.style.display = "block"; isValid = false; }


    if (status.value === "") { statusError.style.display = "block"; isValid = false; }


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