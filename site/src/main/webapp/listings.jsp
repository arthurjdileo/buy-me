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
	ArrayList<Category> cat = BuyMe.Categories.getAsList();
	
	String query = request.getParameter("search-query");
	String filter = request.getParameter("search-filters");
	ArrayList<Listing> listings;

	if (filter.equals("item")) {
		listings = BuyMe.Listings.searchByName(query);
	} else if (filter.equals("user")) {
		listings = BuyMe.Listings.searchByUser(query);
	} else {
		listings = BuyMe.Listings.searchByCategory(query);
	}
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
  <link rel="stylesheet" href="./css/nouislider.min.css">
  <link rel="stylesheet" href="./css/listing.css">
  <style>

  </style>
  <title>BuyMe - Listings</title>
</head>

<body>
    <header class="main-header">
    <div class="logo-container">
      <a href="index.jsp"><img src="./img/logo.png" alt=" "></a>
    </div>
    <nav class="top-nav">
      <p id="show-list-on-hover" class="">Shop By Category</p>
      <ul class="list-content" id="categories">
      <% for (Category c : cat) { %>
        <li class=""><a href="listings.jsp?search-filters=category&search-query=<%= c.name %>"><%= c.name %></a></li>
      <% } %>
      </ul>
    </nav>
    <form action="listings.jsp" class="search-form">
      <div class="search-input-container">
        <input type="text" placeholder="Search" name="search-query" value="<%= query %>" class="search-input">
        <label for="search-filters" class="select-label">Filter by: </label>
        <select id="search-filters" name="search-filters" class="search-filters-select">
          <option value="item" <%= filter.equalsIgnoreCase("item") ? "selected" : "null" %>>Item</option>
          <option value="category" <%= filter.equalsIgnoreCase("category") ? "selected" : "null" %>>Category</option>
          <option value="user" <%= filter.equalsIgnoreCase("user") ? "selected" : "null" %>>User</option>
        </select>
        <input type="submit" value="Search" class="search-btn">
      </div>
    </form>
    <div class="profile-container">
      <a href="profile.jsp">
        <img src="./img/user.png" alt="" class="profile-img">
        <span>Profile</span>
      </a>
    </div>
  </header>
  <main class="main-content">
    <section id="recent-listing" class="listing-section">
      <h2 class="listing-title">Listings</h2>

      <div class="listing-grid">
        <div class="filter-top">
          <div class="filter-top-container">
            <form action="" class="inline-form">
              <label for="">Sort by</label>
              <select class="" name="sort-by">
                <option value="all">All</option>
                <option value="name">Name</option>
                <option value="type">Type</option>
              </select>
            </form>

            <form action="" class="inline-form">
              <label for="">Show</label>
              <select class="" name="show">
                <option value="6">6</option>
                <option value="12">12</option>
                <option value="24">24</option>
              </select>
            </form>

            <form action="" class="inline-form">
              <!-- <label for="">Show</label> -->
              <input type="text" placeholder="search...">
              <input type="submit" value="search">
            </form>
          </div>
        </div>
        <div class="side-column">
          <div class="filter-card">
            <h2>Filter by price</h2>
            <form action="" class="block-form">
              <div id="slider"></div>
              <div class="input-group range-container">
                <label for="">Price: </label>
                <div class="range-input-group">
                  <p readonly id="price-min" class="price-input">
                  <p readonly id="price-max" class="price-input">
                </div>
              </div>
              <input type="submit" value="Filter" class="btn btn-sm btn-pill blue" id="filter-submit-btn">
            </form>
          </div>
          <div class="filter-card">
            <h2>Auction type</h2>
            <form action="" class="block-form">
              <div class="input-group">
                <input type="checkbox" id="live-auction" name="live-auction" value="live-auction">
                <label for="live-auction">Live auction</label>
              </div>
              <div class="input-group">
                <input type="checkbox" id="timed-auction" name="timed-auction" value="timed-auction">
                <label for="live-auction">Timed auction</label>
              </div>
              <div class="input-group">
                <input type="checkbox" id="buy-now" name="buy-now" value="buy-now">
                <label for="buy-now">Buy now</label>
              </div>
            </form>
          </div>
          <div class="filter-card">
            <h2>Ending within</h2>
            <form action="" class="block-form">
              <div class="input-group">
                <input type="checkbox" id="1-day" name="1-day" value="1-day">
                <label for="1-day">1 Day</label>
              </div>
              <div class="input-group">
                <input type="checkbox" id="1-week" name="1-week" value="1-week">
                <label for="1-week">1 Week</label>
              </div>
              <div class="input-group">
                <input type="checkbox" id="1-month" name="1-month" value="1-month">
                <label for="1-month">1 Month</label>
              </div>
            </form>
          </div>
        </div>
        <section class="content">
          <% for (Listing l : listings) { %>
          <article class="product-container card" style="max-width: 360px;">
            <a href="<%= "listing-item.jsp?listingUUID=" + l.listing_uuid %>" class="listing-item-link">
              <img src="<%= l.image %>" width="300" height="150" alt="" class="product-img">
              <h3 class="product-title"><%= l.item_name %></h3>
              <ul class="product-details">
                <li>
                  <p><%= l.description %></p>
                </li>
                <li>Price <span class="product-price">$<%= BuyMe.Listings.getCurrentPrice(l) %></span></li>
                <li>Time <span class="product-time" id="<%= l.listing_uuid %>">00:00</span></li>
                <!--<li>Currency <span class="product-currency">USD</span></li>-->
              </ul>
            </a>
            <div class="bid-options">
              <button class="btn btn-sm btn-bid" onclick="window.location.href='listing-item.jsp?listingUUID=<%= l.listing_uuid %>'">bid</button>
              <p class="number-of-bids"><span class="product-time"><%= BuyMe.Bids.getBidsByListing(l.listing_uuid).size() %></span> Bids</p>
            </div>
          </article>
          <% } %>
        </section>


      </div>
    </section>
  </main>
  <footer>
    &copy; 2020
  </footer>

  <script src="./js/timeout.js"></script>
  <script src="./js/nouislider.min.js"></script>

  <script type="text/javascript">
    const slider = document.getElementById('slider');
    console.log(slider)
    noUiSlider.create(slider, {
      start: [20, 500],
      connect: true,
      range: {
        'min': 0,
        'max': 10000
      }

    });
	
    <% for (Listing l : listings) {%>
    	countDown(new Date ('<%= l.end_time %> UTC').getTime(),"<%= l.listing_uuid %>");
    <%}%>

    var priceValues = [
      document.getElementById('price-min'),
      document.getElementById('price-max')
    ];

    slider.noUiSlider.on('update', function(values, handle) {
      priceValues[handle].innerHTML = `$ ${Math.round(values[handle])}`;
    });
  </script>
</body>

</html>