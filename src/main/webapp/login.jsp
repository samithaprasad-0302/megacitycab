<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Mega City Cab Service</title>


    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: url('images/MEGACITY CABS (5).png') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            width: 350px;
            text-align: center;
            margin-top: 100px;
        }

        .login-container h2 {
            color: #007bff;
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
            margin-bottom: 5px;
            color: rgba(0, 0, 0, 0.93);
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid rgba(0, 0, 0, 0.93);
            border-radius: 5px;
            font-size: 16px;
            transition: 0.3s ease-in-out;
        }

        .form-group input:focus, .form-group select:focus {
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
            outline: none;
        }

        .form-group button {
            width: 100%;
            padding: 12px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: 0.3s ease-in-out;
        }

        .form-group button:hover {
            background: #0056b3;
        }

        .register-link {
            margin-top: 15px;
            font-size: 14px;
            color: rgba(0, 0, 0, 0.93);
            text-align: center;
        }

        .register-link a {
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .hidden {
            display: none;
        }
    </style>

    <script>
        function checkAdmin() {
            let username = document.getElementById("username").value;
            let roleField = document.getElementById("roleField");
            let roleInput = document.getElementById("role");

            if (username.toLowerCase() === "admin") {
                roleField.classList.add("hidden");
                roleInput.value = "admin";
            } else {
                roleField.classList.remove("hidden");
                roleInput.value = "";
            }
        }
    </script>
</head>
<body>

<div class="login-container">
    <h2>Login</h2>
    <form action="login" method="post">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" onkeyup="checkAdmin()" required>
        </div>
        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>


        <div class="form-group" id="roleField">
            <label for="role">Role:</label>
            <select id="role" name="role" required>
                <option value="">Select Role</option>
                <option value="admin"></option>
                <option value="customer">Customer</option>
                <option value="driver">Driver</option>
            </select>
        </div>

        <div class="form-group">
            <button type="submit">Login</button>
        </div>
    </form>


    <div class="register-link">
        <p>Don't have an account? <a href="registerCustomer.jsp">Register as a Customer</a></p>
    </div>
</div>

</body>
</html>
