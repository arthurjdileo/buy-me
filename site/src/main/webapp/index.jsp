<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	Cookie[] cookies = request.getCookies();
	if (!BuyMe.Sessions.safetyCheck(cookies)) {
		response.sendRedirect("login.jsp");
		return;
	}
	User u = BuyMe.Sessions.getBySession(BuyMe.Sessions.getCurrentSession(cookies));
	
	ArrayList<Listing> listings = BuyMe.Listings.getAsList();
%>

<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="./css/base.css">
  <link rel="stylesheet" href="./css/home.css">
  <link rel="stylesheet" href="./css/slider.css">
  <title>BuyMe - Home</title>
  <script src="https://kit.fontawesome.com/56050ab723.js" crossorigin="anonymous"></script>
</head>

<body>
  <%@include file="./includes/header.jsp" %>
  <main class="main-content">
    <div id="sell-your-item">
      <a href="create-listing.jsp" class="btn" id="sell-your-item-btn">Sell Your Item</a>
    </div>
    <h2 class="title-center mb-medium user-greeting">Welcome <span class="user-name"><%= u.firstName %>!</span></h2>
    <h2 class="listing-title"><a href="#">Categories</a></h2>

    <div id="categoriesSlider" class="slider">
      <!-- Give wrapper ID to target with jQuery & CSS -->
      <section class="MS-content product-listing">
        <article class="product-container item">
          <a href="listings.jsp?search-filters=category&search-query=Sports">
            <h3 class="category-title">sports<span class="closebtn"><i onclick="event.preventDefault(); setAlert('category', 'sports')" class="<%= BuyMe.SetAlerts.exists(u.account_uuid, "category", "sports") != null ? "fa" : "far" %> fa-star"></i></span></h3>
            <img src="./img/volleyball.png" alt="" class="category-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="listings.jsp?search-filters=category&search-query=Clothing">
            <h3 class="category-title">clothing<span class="closebtn"><i onclick="event.preventDefault(); setAlert('category', 'clothing')" class="<%= BuyMe.SetAlerts.exists(u.account_uuid, "category", "clothing") != null ? "fa" : "far" %> fa-star"></i></span></h3>
            <img src="./img/tshirt.png" alt="" class="category-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="listings.jsp?search-filters=category&search-query=Vehicles">
            <h3 class="category-title">vehicles<span class="closebtn"><i onclick="event.preventDefault(); setAlert('category', 'vehicles')" class="<%= BuyMe.SetAlerts.exists(u.account_uuid, "category", "vehicles") != null ? "fa" : "far" %> fa-star"></i></span></h3>
            <img src="./img/car.png" alt="" class="category-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="listings.jsp?search-filters=category&search-query=Jewelry">
            <h3 class="category-title">jewelry<span class="closebtn"><i onclick="event.preventDefault(); setAlert('category', 'jewelry')" class="<%= BuyMe.SetAlerts.exists(u.account_uuid, "category", "jewelry") != null ? "fa" : "far" %> fa-star"></i></span></h3>
            <img src="./img/diamond.png" alt="" class="category-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="#listings.jsp?search-filters=category&search-query=Electronics">
            <h3 class="category-title">electronics<span class="closebtn"><i onclick="event.preventDefault(); setAlert('category', 'electronics')" class="<%= BuyMe.SetAlerts.exists(u.account_uuid, "category", "electronics") != null ? "fa" : "far" %> fa-star"></i></span></h3>
            <img src="./img/desktop.png" alt="" class="category-img">
          </a>
        </article>
      </section>

      <div class="MS-controls">
        <button class="MS-left">
          <img src="./img/left-arrow.svg" alt="" class="slider-arrow-img" />
        </button>
        <button class="MS-right">
          <img src="./img/right-arrow.svg" alt="" class="slider-arrow-img" />
        </button>
      </div>
    </div> <!-- end multislider-->


    <h2 class="listing-title"><a href="listing.html">Recent Listings</a></h2>

    <div id="exampleSlider" class="slider">
      <!-- Give wrapper ID to target with jQuery & CSS -->
      <section class="MS-content product-listing">
        <% for (Listing l : listings) { %>
        <article class="product-container item">
          <a href="<%= "listing-item.jsp?listingUUID=" + l.listing_uuid %>">
            <h3 class="product-title"><%= l.item_name %></h3>
            <img src="<%= l.image %>" width="300" height="300" alt="" class="product-img">
            <h3 class="product-title">$<%= BuyMe.Listings.getCurrentPrice(l) %></h3>
          </a>
        </article>
      <% } %>
      </section>

      <div class="MS-controls">
        <button class="MS-left">
          <img src="./img/left-arrow.svg" alt="" class="slider-arrow-img" />
        </button>
        <button class="MS-right">
          <img src="./img/right-arrow.svg" alt="" class="slider-arrow-img" />
        </button>
      </div>
    </div> <!-- end multislider-->
  </main>
  <footer>
    &copy; 2020
  </footer>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="./js/multislider.min.js"></script>
  <script src="./js/initialize-slider.js"></script>
  <script>
  	function setAlert(alert_type, alert) {
  		fetch("setAlert.jsp?alert_type=" + alert_type + "&alert=" + alert);
  		location.reload(true);
  	}
  </script>
</body>

</html>