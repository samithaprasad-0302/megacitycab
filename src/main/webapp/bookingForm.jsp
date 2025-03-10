<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
  <title>Booking Details</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAC25mXxrVn9pTIFZTrH8TokvdZYwZHq9I&libraries=places"></script>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-size: cover;
      color: white;
    }

    .navbar {
      background-color: rgba(0, 0, 0, 0.64);
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

    .container {
      width: 90%;
      max-width: 900px;
      margin: 50px auto;
      padding: 20px;
      background: rgba(0, 0, 0, 0.7);
      border-radius: 10px;
      box-shadow: 0px 0px 15px rgba(255, 255, 255, 0.2);
      display: flex;
      gap: 20px;
    }

    .form-section, .map-section {
      flex: 1;
    }

    h1 {
      text-align: center;
      color: #FFD700;
      margin-bottom: 20px;
      text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
    }

    label {
      font-weight: bold;
      display: block;
      margin-top: 10px;
      color: white;
    }

    input, select {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      border: none;
      border-radius: 5px;
      box-sizing: border-box;
      font-size: 16px;
    }

    input:focus, select:focus {
      outline: 2px solid #007BFF;
    }

    button {
      width: 100%;
      padding: 12px;
      background-color: #28a745;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 18px;
      margin-top: 15px;
      transition: 0.3s;
    }

    button:hover {
      background-color: #218838;
    }

    #map {
      height: 300px;
      width: 100%;
      border-radius: 5px;
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
  <script>
    let map;
    let directionsService;
    let directionsRenderer;
    let markers = [];

    function initMap() {
      if (typeof google === 'undefined' || !google.maps) {
        console.error("Google Maps API not loaded.");
        return;
      }
      map = new google.maps.Map(document.getElementById("map"), {
        center: { lat: 6.9271, lng: 79.8612 }, // Default to Colombo, Sri Lanka
        zoom: 10,
      });
      directionsService = new google.maps.DirectionsService();
      directionsRenderer = new google.maps.DirectionsRenderer();
      directionsRenderer.setMap(map);
    }

    function initAutocomplete() {
      if (typeof google === 'undefined' || !google.maps) {
        console.error("Google Maps API not loaded for autocomplete.");
        return;
      }
      var pickupInput = document.getElementById("pickupLocation");
      var dropoffInput = document.getElementById("dropoffLocation");
      var distanceInput = document.getElementById("distance");

      var autocompletePickup = new google.maps.places.Autocomplete(pickupInput);
      var autocompleteDropoff = new google.maps.places.Autocomplete(dropoffInput);

      autocompletePickup.addListener("place_changed", function() {
        var place = autocompletePickup.getPlace();
        if (!place.geometry) {
          alert("Please select a valid pickup location from the suggestions.");
          return;
        }
        updateMapAndRoute();
        calculateDistance();
      });

      autocompleteDropoff.addListener("place_changed", function() {
        var place = autocompleteDropoff.getPlace();
        if (!place.geometry) {
          alert("Please select a valid drop-off location from the suggestions.");
          return;
        }
        updateMapAndRoute();
        calculateDistance();
      });
    }

    function updateMapAndRoute() {
      if (!map) {
        console.error("Map not initialized.");
        return;
      }
      markers.forEach(marker => marker.setMap(null));
      markers = [];

      var pickupInput = document.getElementById("pickupLocation");
      var dropoffInput = document.getElementById("dropoffLocation");

      if (pickupInput.value && dropoffInput.value) {
        var request = {
          origin: pickupInput.value,
          destination: dropoffInput.value,
          travelMode: 'DRIVING'
        };
        directionsService.route(request, function(result, status) {
          if (status === 'OK') {
            directionsRenderer.setDirections(result);
          } else {
            alert("Error drawing route: " + status);
          }
        });
      }
    }

    function calculateDistance() {
      var pickupInput = document.getElementById("pickupLocation");
      var dropoffInput = document.getElementById("dropoffLocation");
      var distanceInput = document.getElementById("distance");

      if (!pickupInput.value || !dropoffInput.value) {
        distanceInput.value = "";
        return;
      }

      var service = new google.maps.DistanceMatrixService();
      service.getDistanceMatrix({
        origins: [pickupInput.value],
        destinations: [dropoffInput.value],
        travelMode: 'DRIVING',
        unitSystem: google.maps.UnitSystem.METRIC,
        avoidHighways: false,
        avoidTolls: false,
      }, function(response, status) {
        if (status === "OK") {
          var distance = response.rows[0].elements[0].distance.value / 1000;
          distanceInput.value = distance.toFixed(2);
        } else {
          alert("Error calculating distance: " + status);
          distanceInput.value = "";
        }
      });
    }

    window.onload = function() {
      try {
        initMap();
        initAutocomplete();
      } catch (e) {
        console.error("Error initializing map or autocomplete: ", e);
      }
    };
  </script>
</head>
<body>
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

  String errorMessage = (String) session.getAttribute("errorMessage");
  if (errorMessage != null) {
%>
<script>
  Swal.fire({
    icon: 'error',
    title: 'Error!',
    text: '<%= errorMessage %>'
  });
</script>
<%
    session.removeAttribute("errorMessage");
  }
%>

<div class="navbar">
  <a href="customerDashboard">Dashboard</a>
  <a href="logout" style="color: red;">Logout</a>
</div>

<div class="container">
  <div class="form-section">
    <h1>Enter Booking Details</h1>

    <%
      int carID = Integer.parseInt(request.getParameter("carID"));
      int driverID = Integer.parseInt(request.getParameter("driverID"));
      String username = (String) session.getAttribute("username");
    %>

    <form action="processBooking" method="POST">
      <input type="hidden" name="carID" value="<%= carID %>">
      <input type="hidden" name="driverID" value="<%= driverID %>">
      <input type="hidden" name="username" value="<%= username %>">

      <label for="pickupLocation">Pickup Location:</label>
      <input type="text" id="pickupLocation" name="pickupLocation" required placeholder="Enter pickup location">

      <label for="dropoffLocation">Drop-off Location:</label>
      <input type="text" id="dropoffLocation" name="dropoffLocation" required placeholder="Enter dropoff location">

      <label for="distance">Distance (km):</label>
      <input type="number" id="distance" name="distance" required placeholder="Distance will autofill" readonly>

      <label for="bookingDate">Booking Date & Time:</label>
      <input type="datetime-local" id="bookingDate" name="bookingDate" required>

      <label for="paymentMethod">Payment Method:</label>
      <select id="paymentMethod" name="paymentMethod" required>
        <option value="Cash">Cash</option>
        <option value="Card">Card</option>
      </select>

      <button type="submit">Confirm Booking</button>
    </form>
  </div>
  <div class="map-section">
    <h1>Route Map</h1>
    <div id="map"></div>
  </div>
</div>

<div class="footer">
  <p>© 2025 Mega City Cab Service. All rights reserved.</p>
</div>

</body>
</html>