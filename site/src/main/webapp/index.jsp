<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.net.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	Cookie[] cookies = request.getCookies();
	if (!BuyMe.Sessions.safetyCheck(cookies)) {
		response.sendRedirect("login.jsp");
		return;
	}
	User u = BuyMe.Sessions.getBySession(BuyMe.Sessions.getCurrentSession(cookies));
	
	ArrayList<Listing> listings = BuyMe.Listings.getAsList();
	SetAlert sportsAlert = BuyMe.SetAlerts.exists(u.account_uuid, "category", "sports");
	if (sportsAlert != null && sportsAlert.is_active == 0) sportsAlert = null;
	SetAlert clothingAlert = BuyMe.SetAlerts.exists(u.account_uuid, "category", "clothing");
	if (clothingAlert != null && clothingAlert.is_active == 0) clothingAlert = null;
	SetAlert vehiclesAlert = BuyMe.SetAlerts.exists(u.account_uuid, "category", "vehicles");
	if (vehiclesAlert != null && vehiclesAlert.is_active == 0) vehiclesAlert = null;
	SetAlert jewelryAlert = BuyMe.SetAlerts.exists(u.account_uuid, "category", "jewelry");
	if (jewelryAlert != null && jewelryAlert.is_active == 0) jewelryAlert = null;
	SetAlert electronicsAlert = BuyMe.SetAlerts.exists(u.account_uuid, "category", "electronics");
	if (electronicsAlert != null && electronicsAlert.is_active == 0) electronicsAlert = null;
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
  <link rel="apple-touch-icon" sizes="180x180" href="./apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="./favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="./favicon-16x16.png">
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
    <h2 class="listing-title"><a href="#">Featured Categories</a></h2>

    <div id="categoriesSlider" class="slider">
      <!-- Give wrapper ID to target with jQuery & CSS -->
      <section class="MS-content product-listing">
      <!-- fetch("setAlert.jsp?alert_type=" + alert_type + "&alert=" + alert); -->
        <article class="product-container item">
          <form action="<%= sportsAlert == null ? "setAlert.jsp" : "removeAlert.jsp" %>" id="sports-alert">
          <input name="alert_type" value="category" hidden>
          <input name="alert" value="Sports" hidden>
          <a href="listings.jsp?search-filters=category&search-query=Sports">
            <h3 class="category-title">sports<span onclick="event.preventDefault(); document.getElementById('sports-alert').submit()" class="closebtn"><i class="<%= sportsAlert != null ? "fa" : "far" %> fa-star"></i></span></h3>
            <img src="./img/volleyball.png" alt="" class="category-img">
          </a>
        </form>
        </article>
        <article class="product-container item">
          <form action="<%= clothingAlert == null ? "setAlert.jsp" : "removeAlert.jsp" %>" id="clothing-alert">
          <input name="alert_type" value="category" hidden>
          <input name="alert" value="Clothing" hidden>
          <a href="listings.jsp?search-filters=category&search-query=Clothing">
            <h3 class="category-title">clothing<span onclick="event.preventDefault(); document.getElementById('clothing-alert').submit()" class="closebtn"><i class="<%= clothingAlert != null ? "fa" : "far" %> fa-star"></i></span></h3>
            <img src="./img/tshirt.png" alt="" class="category-img">
          </a>
          </form>
        </article>
        <article class="product-container item">
          <form action="<%= vehiclesAlert == null ? "setAlert.jsp" : "removeAlert.jsp" %>" id="vehicles-alert">
          <input name="alert_type" value="category" hidden>
          <input name="alert" value="Vehicles" hidden>
          <a href="listings.jsp?search-filters=category&search-query=Vehicles">
            <h3 class="category-title">vehicles<span onclick="event.preventDefault(); document.getElementById('vehicles-alert').submit()" class="closebtn"><i class="<%= vehiclesAlert != null ? "fa" : "far" %> fa-star"></i></span></h3>
            <img src="./img/car.png" alt="" class="category-img">
          </a>
        </form>
        </article>
        <article class="product-container item">
          <form action="<%= jewelryAlert == null ? "setAlert.jsp" : "removeAlert.jsp" %>" id="jewelry-alert">
          <input name="alert_type" value="category" hidden>
          <input name="alert" value="Jewelry" hidden>
          <a href="listings.jsp?search-filters=category&search-query=Jewelry">
            <h3 class="category-title">jewelry<span onclick="event.preventDefault(); document.getElementById('jewelry-alert').submit()" class="closebtn"><i class="<%= jewelryAlert != null ? "fa" : "far" %> fa-star"></i></span></h3>
            <img src="./img/diamond.png" alt="" class="category-img">
          </a>
          </form>
        </article>
        <article class="product-container item">
          <form action="<%= electronicsAlert == null ? "setAlert.jsp" : "removeAlert.jsp" %>" id="electronics-alert">
          <input name="alert_type" value="category" hidden>
          <input name="alert" value="Electronics" hidden>
          <a href="listings.jsp?search-filters=category&search-query=Electronics">
            <h3 class="category-title">electronics<span onclick="event.preventDefault(); document.getElementById('electronics-alert').submit()" class="closebtn"><i class="<%= electronicsAlert != null ? "fa" : "far" %> fa-star"></i></span></h3>
            <img src="./img/desktop.png" alt="" class="category-img">
          </a>
          </form>
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


    <h2 class="listing-title"><a>Recent Listings</a></h2>
	<div id="exampleSlider">
      <section class="MS-content content">
          <% for (Listing l : listings) { %>
          <article class="product-container card item" style="max-width: 360px; min-height: 426px;">
            <a href="<%= "listing-item.jsp?listingUUID=" + l.listing_uuid %>" class="listing-item-link">
              <img src="<%= l.image %>" width="300" height="150" alt="" class="product-img">
              <h3 class="similar-product-title"><%= l.item_name %></h3>
              <ul class="similar-product-details">
                <li>
                  <p class="similar-desc"><%= l.description %></p>
                </li>
                <li>Price <span class="similar-product-price">$<%= BuyMe.Listings.getCurrentPrice(l) %></span></li>
                <li>Time <span class="product-time" id="<%= l.listing_uuid %>">00:00</span></li>
                <li>Sold By <span class="product-currency"><%= BuyMe.Users.get(l.seller_uuid).firstName %></span></li>
              </ul>
            </a>
            <div class="bid-options">
              <button class="btn btn-sm btn-bid" onclick="window.location.href='listing-item.jsp?listingUUID=<%= l.listing_uuid %>'">bid</button>
              <p class="number-of-bids"><span class="product-time"><%= BuyMe.Bids.getBidsByListing(l.listing_uuid).size() %></span> Bids</p>
            </div>
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
        </div>
    <%-- <div id="exampleSlider" class="slider">
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
    </div> --%>
  </main>
  <footer>
    &copy; 2020
  </footer>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="./js/multislider.min.js"></script>
  <script src="./js/initialize-slider.js"></script>
  <script src="./js/timeout.js"></script>
  
  <script>
    <% for (Listing l : listings) {%>
	countDown(new Date ('<%= l.end_time %>-04:00').getTime(),"<%= l.listing_uuid %>");
	<%}%>
	
  </script>
</body>

</html>