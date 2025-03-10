<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Mega City Cab Service</title>
    <style>
        body {
            font-family: 'Poppins', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: url('images/MEGACITY CABS (2).png') no-repeat center center fixed;
            background-size: cover;
            color: white;
        }

        /* Navbar */
        .navbar {
            background-color: rgba(0, 0, 0, 0.8);
            padding: 15px;
            text-align: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            padding: 10px 20px;
            margin: 0 10px;
            transition: 0.3s;
        }
        .navbar a:hover {
            background-color: #007BFF;
            border-radius: 5px;
        }
        .navbar a.active {
            background-color: #007BFF;
            border-radius: 5px;
        }

        /* About Content */
        .container {
            width: 80%;
            margin: 50px auto;
            padding: 20px;
            background: rgba(0, 0, 0, 0.8);
            border-radius: 10px;
            text-align: center;
        }

        h1 {
            color: #FFD700;
        }

        p {
            font-size: 18px;
            line-height: 1.6;
        }

        .features {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            margin-top: 30px;
        }

        .feature {
            width: 30%;
            padding: 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }

        .feature h3 {
            color: #FFD700;
        }

        /* Footer */
        .footer {
            text-align: center;
            padding: 15px;
            background-color: rgba(0, 0, 0, 0.8);
            color: white;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <a href="index.jsp">Home</a>
    <a href="aboutUs.jsp" class="active">About Us</a>
    <a href="help.jsp">Help & Support</a>
    <a href="contactUs.jsp">Contact</a>
</div>

<!-- About Section -->
<div class="container">
    <h1>About Mega City Cab Service</h1>
    <p>
        Welcome to Mega City Cab Service, the leading cab service provider in Colombo City.
        We are committed to offering **safe, comfortable, and reliable** transportation for our customers.
    </p>

    <h2>Our Mission & Vision</h2>
    <p>
        Our **mission** is to provide an efficient and affordable cab service with the latest technology.
        Our **vision** is to be the most trusted cab service in Sri Lanka, ensuring customer satisfaction.
    </p>

    <h2>Why Choose Us?</h2>
    <div class="features">
        <div class="feature">
            <h3>🚗 Reliable Rides</h3>
            <p>We ensure our customers have **on-time** and **safe rides** with professional drivers.</p>
        </div>
        <div class="feature">
            <h3>📱 Easy Booking</h3>
            <p>Book a ride instantly using our **online platform** and track your cab in real-time.</p>
        </div>
        <div class="feature">
            <h3>💳 Multiple Payment Methods</h3>
            <p>Pay via **cash, card, or digital payments** for your convenience.</p>
        </div>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>
