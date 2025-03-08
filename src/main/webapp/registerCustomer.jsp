<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url('images/MEGACITY CABS (2).png') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .register-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            width: 380px;
            text-align: center;
            animation: fadeIn 0.5s ease-in-out;
        }

        .register-container h2 {
            color: #007BFF;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            color: #333;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            transition: border 0.3s ease-in-out;
        }

        .form-group input:focus {
            border-color: #007BFF;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
            outline: none;
        }

        .form-group input:invalid {
            border-color: red;
        }

        .form-group input:valid {
            border-color: green;
        }

        .form-group button {
            width: 100%;
            padding: 12px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: background 0.3s ease-in-out;
        }

        .form-group button:hover {
            background: #218838;
        }

        .error-message {
            color: red;
            font-size: 14px;
            display: none;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>

<div class="register-container">
    <h2>Customer Registration</h2>

    <form action="registerCustomer" method="post">
        <div class="form-group">
            <label for="name">Full Name:</label>
            <input type="text" id="name" name="name" pattern=".{3,}" title="Full name must be at least 3 characters" required>
        </div>

        <div class="form-group">
            <label for="address">Address:</label>
            <input type="text" id="address" name="address" required>
        </div>

        <div class="form-group">
            <label for="nic">NIC:</label>
            <input type="text" id="nic" name="nic" pattern=".{10,12}" title="NIC must be 10 or 12 characters" required>
        </div>

        <div class="form-group">
            <label for="contactNumber">Contact Number:</label>
            <input type="tel" id="contactNumber" name="contactNumber" pattern="[0-9]{10}" title="Enter a valid 10-digit phone number" required>
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
        </div>

        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" pattern=".{5,}" title="Username must be at least 5 characters" required>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" pattern="(?=.*\d)(?=.*[a-zA-Z]).{6,}" title="Password must be at least 6 characters and contain letters and numbers" required>
        </div>

        <div class="form-group">
            <button type="submit">Register</button>
        </div>
    </form>
</div>

</body>
</html>
