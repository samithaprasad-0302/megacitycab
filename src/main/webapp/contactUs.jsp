<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - Mega City Cab Service</title>


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

        .navbar {
            background-color: rgba(0, 0, 0, 0.9);
            padding: 15px;
            width: 100%;
            text-align: center;
            position: fixed;
            top: 0;
            left: 0;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            padding: 10px 20px;
            margin: 0 10px;
            transition: 0.3s;
        }

        .navbar a:hover, .navbar a.active {
            background-color: #007BFF;
            border-radius: 5px;
        }

        .contact-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            width: 400px;
            text-align: center;
            margin-top: 80px;
            animation: fadeIn 0.5s ease-in-out;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .contact-container h2 {
            color: #FFD700;
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
            color: rgba(0, 0, 0, 0.96);
        }

        .form-group input, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid rgba(0, 0, 0, 0.93);
            border-radius: 5px;
            font-size: 16px;
            transition: 0.3s ease-in-out;
        }

        .form-group input:focus, .form-group textarea:focus {
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

        .footer {
            text-align: center;
            padding: 15px;
            background-color: rgba(0, 0, 0, 0.9);
            color: white;
            position: fixed;
            bottom: 0;
            width: 100%;
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


<div class="navbar">
    <a href="index.jsp">Home</a>
    <a href="aboutUs.jsp">About Us</a>
    <a href="help.jsp">Help & Support</a>
    <a href="contactUs.jsp" class="active">Contact</a>
</div>


<div class="contact-container">
    <h2>Contact Us</h2>
    <p style="color: white;">Have any questions? Reach out to us!</p>

    <form action="contactForm" method="post">
        <div class="form-group">
            <label for="name">Full Name:</label>
            <input type="text" id="name" name="name" required>
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
        </div>

        <div class="form-group">
            <label for="message">Message:</label>
            <textarea id="message" name="message" rows="4" required></textarea>
        </div>

        <div class="form-group">
            <button type="submit">Send Message</button>
        </div>
    </form>
</div>


<div class="footer">
    <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>


<%
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
%>
<script>
    Swal.fire({
        icon: 'success',
        title: 'Success!',
        text: '<%= successMessage %>'
    });
</script>
<%
        session.removeAttribute("successMessage");
    }
%>

</body>
</html>
