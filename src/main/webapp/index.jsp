<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mega City Cab Service</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>

        body {
            font-family: 'Poppins', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: url('images/MEGACITY CABS (2).png') no-repeat center center fixed;
            background-size: cover;
            color: white;
        }


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


        .hero {
            text-align: center;
            padding: 100px 20px;
            background: rgba(0, 0, 0, 0.5);
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
            margin: 50px auto;
            border-radius: 10px;
            width: 80%;
        }
        .hero h1 {
            font-size: 42px;
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
        }
        .hero p {
            font-size: 20px;
            color: #ddd;
            margin-bottom: 20px;
        }


        .btn {
            display: inline-block;
            padding: 15px 30px;
            background-color: #007BFF;
            color: white;
            text-decoration: none;
            font-size: 20px;
            border-radius: 5px;
            transition: 0.3s ease-in-out;
        }
        .btn:hover {
            background-color: #0056b3;
            transform: scale(1.1);
        }


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


<div class="navbar">
    <a href="index.jsp">Home</a>
    <a href="aboutUs.jsp">About Us</a>
    <a href="help.jsp">Help & Support</a>
    <a href="contactUs.jsp">Contact</a>
</div>

<div class="hero">
    <h1>Welcome to Mega City Cab Service</h1>
    <p>Experience the Difference in Every Ride</p>
    <a href="login.jsp" class="btn">START</a>
</div>


<div class="footer">
    <p>&copy; 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>
