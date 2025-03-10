<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & Support - MegaCity Cab Service</title>
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

        /* Navbar Styles */
        .navbar {
            background-color: rgba(0, 0, 0, 0.8);
            padding: 15px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }
        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            padding: 10px 20px;
            margin: 0 10px;
            transition: 0.3s;
            border-radius: 5px;
        }
        .navbar a:hover {
            background-color: #007BFF;
        }
        .navbar a.active {
            background-color: #007BFF;
            font-weight: 600;
        }

        /* Container Styles */
        .container {
            width: 80%;
            max-width: 1200px;
            margin: 50px auto;
            padding: 30px;
            background: rgba(0, 0, 0, 0.9);
            border-radius: 15px;
            backdrop-filter: blur(5px);
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
        }

        /* Section Header */
        h1 {
            text-align: center;
            color: #FFD700;
            font-size: 36px;
            margin-bottom: 30px;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
        }

        /* Help Sections */
        .help-section {
            margin-bottom: 20px;
            padding: 20px;
            border-left: 5px solid #FFD700;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 5px;
            transition: 0.3s;
        }
        .help-section:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(5px);
        }

        .help-section h2 {
            color: #FFD700;
            font-size: 24px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
        }

        .help-section h2 span {
            background: #007BFF;
            color: white;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 18px;
            font-weight: 500;
        }

        .help-section p {
            font-size: 16px;
            line-height: 1.8;
            margin: 5px 0;
        }

        /* FAQ Section */
        .faq-section {
            margin-top: 40px;
        }

        .faq-section h2 {
            color: #FFD700;
            font-size: 28px;
            text-align: center;
            margin-bottom: 20px;
        }

        .faq-item {
            margin-bottom: 10px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 5px;
            overflow: hidden;
        }

        .faq-question {
            padding: 15px;
            font-size: 18px;
            color: #FFD700;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.3s;
        }

        .faq-question:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .faq-answer {
            padding: 15px;
            font-size: 16px;
            display: none;
            background: rgba(255, 255, 255, 0.05);
            line-height: 1.6;
        }

        .faq-answer.active {
            display: block;
        }

        .faq-question::after {
            content: '\25BC';
            font-size: 14px;
            transition: transform 0.3s;
        }

        .faq-question.active::after {
            transform: rotate(180deg);
        }

        /* Contact Form Section */
        .contact-section {
            margin-top: 40px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
        }

        .contact-section h2 {
            color: #FFD700;
            font-size: 28px;
            text-align: center;
            margin-bottom: 20px;
        }

        .contact-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .contact-form label {
            font-size: 16px;
            font-weight: 500;
        }

        .contact-form input,
        .contact-form textarea {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            box-sizing: border-box;
        }

        .contact-form input:focus,
        .contact-form textarea:focus {
            outline: 2px solid #007BFF;
            background: rgba(255, 255, 255, 0.3);
        }

        .contact-form textarea {
            resize: vertical;
            min-height: 100px;
        }

        .contact-form button {
            padding: 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: 0.3s;
        }

        .contact-form button:hover {
            background-color: #218838;
        }

        /* Footer Styles */
        .footer {
            text-align: center;
            padding: 15px;
            background-color: rgba(0, 0, 0, 0.8);
            color: white;
            position: fixed;
            bottom: 0;
            width: 100%;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.3);
        }
    </style>
</head>
<body>

<div class="navbar">
    <a href="index.jsp">Home</a>
    <a href="aboutUs.jsp">About Us</a>
    <a href="help.jsp" class="active">Help & Support</a>
    <a href="contactUs.jsp">Contact</a>

</div>


<div class="container">
    <h1>Help & Support</h1>


    <div class="help-section">
        <h2><span>1</span> Getting Started with MegaCity Cab Service</h2>
        <p>If you're new to MegaCity Cab Service, start by logging in or registering an account. Click the <strong>Login</strong> button on the homepage and enter your username and password. If you don't have an account, contact our support team to register.</p>
        <p>Once logged in, you can access your dashboard to book a cab, view your bookings, and manage your profile.</p>
    </div>

    <div class="help-section">
        <h2><span>2</span> How to Book a Cab</h2>
        <p>From your dashboard, navigate to the <strong>Available Cars</strong> section. Select a car, enter your pickup and drop-off locations, choose a date and time, and select your payment method (Cash or Card). Confirm your booking, and you'll receive a confirmation once the driver accepts your request.</p>
        <p>You can also use the interactive map to visualize your route while booking.</p>
    </div>

    <div class="help-section">
        <h2><span>3</span> Managing Your Bookings</h2>
        <p>View all your bookings in the <strong>My Bookings</strong> section of your dashboard. You can:</p>
        <ul style="padding-left: 20px; line-height: 1.8;">
            <li>Check the status of your booking (Pending, Active, or Completed).</li>
            <li>Cancel an active booking if the ride hasn't started yet.</li>
            <li>Make payments for pending bookings by clicking <strong>Pay Now</strong>.</li>
        </ul>
    </div>

    <div class="help-section">
        <h2><span>4</span> Payment & Pricing</h2>
        <p>The fare is calculated based on the distance traveled and the car's rental price per kilometer. A 10% VAT is added to the base fare. If you've completed 3 or more rides, you qualify for a 5% frequent customer discount.</p>
        <p>We support two payment methods:</p>
        <ul style="padding-left: 20px; line-height: 1.8;">
            <li><strong>Cash:</strong> Pay the driver directly upon completing your ride.</li>
            <li><strong>Card:</strong> Pay securely online by entering your card details during the payment process. After payment, you'll receive a downloadable receipt.</li>
        </ul>
    </div>

    <div class="help-section">
        <h2><span>5</span> Canceling a Booking</h2>
        <p>You can cancel an active booking from the <strong>My Bookings</strong> section by clicking the <strong>Cancel</strong> button. Note that cancellations are only allowed before the driver starts the journey. Once the ride is completed, the booking status will change to "Completed," and cancellation will no longer be available.</p>
    </div>

    <div class="help-section">
        <h2><span>6</span> Troubleshooting Common Issues</h2>
        <p>If you encounter issues, here are some quick fixes:</p>
        <ul style="padding-left: 20px; line-height: 1.8;">
            <li><strong>Can't log in?</strong> Ensure your username and password are correct. If you've forgotten your password, contact support to reset it.</li>
            <li><strong>Payment failed?</strong> Verify your card details and ensure you have sufficient funds. For cash payments, ensure you have the exact amount ready.</li>
            <li><strong>Booking not confirmed?</strong> Wait a few minutes for the driver to accept. If the issue persists, contact support.</li>
        </ul>
    </div>


    <div class="faq-section">
        <h2>Frequently Asked Questions (FAQs)</h2>
        <div class="faq-item">
            <div class="faq-question">What payment methods are available?</div>
            <div class="faq-answer">
                We accept both Cash and Card payments. You can select your preferred method during the booking process. Card payments require you to enter your card details securely on the payment page.
            </div>
        </div>
        <div class="faq-item">
            <div class="faq-question">Can I change my pickup or drop-off location after booking?</div>
            <div class="faq-answer">
                Currently, you cannot modify a booking once it's confirmed. You'll need to cancel the booking and create a new one with the updated locations.
            </div>
        </div>
        <div class="faq-item">
            <div class="faq-question">How is the fare calculated?</div>
            <div class="faq-answer">
                The fare is calculated by multiplying the distance (in kilometers) by the car's rental price per kilometer. A 10% VAT is added to the base fare. If you've completed 3 or more rides, a 5% discount is applied.
            </div>
        </div>
        <div class="faq-item">
            <div class="faq-question">What happens if the driver cancels my booking?</div>
            <div class="faq-answer">
                If a driver cancels your booking, you'll be notified, and the booking status will be updated to "Cancelled." You can then book another cab from the available cars list.
            </div>
        </div>
        <div class="faq-item">
            <div class="faq-question">How do I download my payment receipt?</div>
            <div class="faq-answer">
                After making a payment (via Cash or Card), you'll be redirected to a bill page where you can download your receipt by clicking the <strong>Download Bill</strong> button.
            </div>
        </div>
    </div>
</div>


<div class="footer">
    <p>© 2025 MegaCity Cab Service. All rights reserved.</p>
</div>


<script>
    document.querySelectorAll('.faq-question').forEach(item => {
        item.addEventListener('click', () => {
            const answer = item.nextElementSibling;
            const isActive = answer.classList.contains('active');

            // Close all other answers
            document.querySelectorAll('.faq-answer').forEach(ans => {
                ans.classList.remove('active');
            });
            document.querySelectorAll('.faq-question').forEach(q => {
                q.classList.remove('active');
            });

            // Toggle the clicked answer
            if (!isActive) {
                answer.classList.add('active');
                item.classList.add('active');
            }
        });
    });
</script>

</body>
</html>