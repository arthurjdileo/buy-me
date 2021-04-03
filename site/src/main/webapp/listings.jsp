<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%!
	public ArrayList<Listing> filterByPrice(ArrayList<Listing> listings, double price, boolean min) throws SQLException {
		ArrayList<Listing> filtered = new ArrayList<Listing>();
		
		for (Listing l : listings) {
			double curr = BuyMe.Listings.getCurrentPrice(l);
			if (min) {
				if (curr >= price) {
					filtered.add(l);
				}
			} else {
				if (curr <= price) {
					filtered.add(l);
				}
			}
		}
		return filtered;
	}

  	public ArrayList<Listing> filterByEnding(ArrayList<Listing> listings, String ending) {
  		ArrayList<Listing> filtered = new ArrayList<Listing>();
		java.sql.Timestamp t = new Timestamp(System.currentTimeMillis());
		Calendar c = Calendar.getInstance();
		c.setTime(t);
		if (ending.equals("1-day")) {
			c.add(Calendar.DAY_OF_WEEK, 1);
		} else if (ending.equals("1-week")) {
			c.add(Calendar.DAY_OF_WEEK, 7);
		} else {
			c.add(Calendar.DAY_OF_WEEK, 30);
		}
		t.setTime(c.getTime().getTime());
		
		for (Listing l : listings) {
			int comp = t.compareTo(l.end_time);
			if (comp >= 0) {
				filtered.add(l);
			}
		}
		return filtered;
	}
  	
  	public ArrayList<Listing> sortByName(ArrayList<Listing> listings) {
  		ArrayList<Listing> filtered = listings;
  		Comparator<Listing> nameOrder = new Comparator<Listing>() {
  			@Override
  			public int compare(Listing l1, Listing l2) {
  				System.out.println(l1.item_name);
  				System.out.println(l2.item_name);
  				System.out.println(l1.item_name.compareTo(l2.item_name));
  				return l1.item_name.compareTo(l2.item_name);
  			}
  		};
  		
  		Collections.sort(filtered, nameOrder);
  		return filtered;
  	}
%>

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
	if (query == null || filter == null) {
		response.sendRedirect("index.jsp");
		return;
	}
	ArrayList<Listing> listings;

	if (filter.equalsIgnoreCase("item")) {
		listings = BuyMe.Listings.searchByName(null, query);
	} else if (filter.equalsIgnoreCase("user")) {
		listings = BuyMe.Listings.searchByUser(query);
	} else if (filter.equalsIgnoreCase("category")) {
		listings = BuyMe.Listings.searchByCategory(query);
	} else {
		listings = new ArrayList<Listing>();
	}
	String priceMin = request.getParameter("price-min");
	String priceMax = request.getParameter("price-max");
	String endingWithin = request.getParameter("ending-within");
	String sortBy = request.getParameter("sort-by");
	String subSearch = request.getParameter("sub-search");
	if (priceMin != null) {
		listings = filterByPrice(listings, Double.parseDouble(priceMin), true);
	}
	if (priceMax != null) {
		listings = filterByPrice(listings, Double.parseDouble(priceMax), false);
	}
 	if (endingWithin != null) {
		listings = filterByEnding(listings, endingWithin);
	}
 	if (subSearch != null) {
 		listings = BuyMe.Listings.searchByName(listings, subSearch);
 	}
 	if (sortBy != null) {
 		listings = sortByName(listings);
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
  <link rel="apple-touch-icon" sizes="180x180" href="./apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="./favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="./favicon-16x16.png">
  <style>

  </style>
  <title>BuyMe - Listings</title>
</head>

<body>
    <header class="main-header">
    <div class="logo-container">
      <a href="index.jsp"><img src="./img/logo.png" alt=" "></a>
    </div>
    <nav class="">
      <ul class="dropdown">
        <li class="list-top-level-item"><a href="">Shop by category</a>
          <ul class="list-content" id="">
            <% for (Category c : cat) { %>
            <li class=""><a href="listings.jsp?search-filters=category&search-query=<%= c.name %>"><%= c.name %></a>
              <ul class="sublist-content">
                <% for (SubCategory s : BuyMe.SubCategories.getByCategory(c.id)) { %>
                <li><a href="listings.jsp?search-filters=category&search-query=<%= s.name %>"><%= s.name %></a></li>
				<% } %>
              </ul>
            </li>
            <% } %>
          </ul>
        </li>
      </ul>
    </nav>
    <!-- end multidropdown -->
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
              <label for="">Sort By</label>
              <select class="" id="sort-by">
                <option value="n/a" <%= sortBy == null ? "selected" : "null" %>>N/A</option>
                <option value="name" <%= sortBy != null ? "selected" : "null" %>>Name</option>
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

            <div class="inline-form">
              <!-- <label for="">Show</label> -->
              <input type="text" id="sub-search" value="<%= subSearch != null ? subSearch : "" %>" placeholder="search...">
              <button onclick="subSearch();" value="search">Search</button>
            </div>
          </div>
        </div>
        <div class="side-column">
          <div class="filter-card">
            <h2>Filter By Price</h2>
            <form action="listings.jsp" class="block-form">
              <div id="slider"></div>
              <div class="input-group range-container">
                <label for="">Price: </label>
                <div class="range-input-group">
                  <input hidden name="search-query" value="<%= query %>"></input>
                  <input hidden name="search-filters" value="<%= filter %>"></input>
                  $<input name="price-min" id="price-min" style="border:none; width:5em" value="100"></input>
                  $<input name="price-max" id="price-max" style="border:none; width:5em;" value="100"></input>
                </div>
              </div>
              <input type="submit" value="Filter" class="btn btn-sm btn-pill blue" id="filter-submit-btn">
            </form>
          </div>
<!--           <div class="filter-card">
            <h2>Auction Type</h2>
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
          </div> -->
          <div class="filter-card">
            <h2>Ending Within</h2>
            <form action="" id="ending" class="block-form">
              <div class="input-group">
                <input type="radio" id="1-day" name="ending-within" <%= endingWithin != null && endingWithin.equals("1-day") ? "checked" : null %> value="1-day">
                <label for="1-day">1 Day</label>
              </div>
              <div class="input-group">
                <input type="radio" id="1-week" name="ending-within" <%= endingWithin != null && endingWithin.equals("1-week") ? "checked" : null %> value="1-week">
                <label for="1-week">1 Week</label>
              </div>
              <div class="input-group">
                <input type="radio" id="1-month" name="ending-within" <%= endingWithin != null && endingWithin.equals("1-month") ? "checked" : null %> value="1-month">
                <label for="1-month">1 Month</label>
              </div>
              <input value="Clear" class="btn btn-sm btn-pill blue" onclick="clearEnding();" style="width: 100px; margin: 0 auto; text-align: center;" >
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
                  <p class="similar-desc"><%= l.description %></p>
                </li>
                <li>Price <span class="product-price">$<%= BuyMe.Listings.getCurrentPrice(l) %></span></li>
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
	noUiSlider.create(slider, {
	  start: [<%= priceMin != null ? priceMin : 20 %>, <%= priceMax != null ? priceMax : 500 %>],
	  connect: true,
	  range: {
	    'min': 0,
	    'max': 50000
	  }
	
	});
	
	
	var priceValues = [
	  document.getElementById('price-min'),
	  document.getElementById('price-max')
	];
	
 	slider.noUiSlider.on('update', function(values, handle) {
	  //priceValues[handle].innerHTML = `$ ${Math.round(values[handle])}`;
	  priceValues[handle].value = Math.round(values[handle]);
	  //priceValues[handle].value = `$ ${Math.round(values[handle])}`;
	});
 	
 	priceValues[0].addEventListener('change', function() {
 		slider.noUiSlider.set([this.value, null]);
 	});
 	priceValues[1].addEventListener('change', function() {
 		slider.noUiSlider.set([null, this.value]);
 	});
    <% for (Listing l : listings) {%>
	countDown(new Date ('<%= l.end_time %>-04:00').getTime(),"<%= l.listing_uuid %>");
	<%}%>
	
	let form = document.querySelector("#ending");
	form.addEventListener("change", function(event) {
		var url = new URL(location.href);
		url.searchParams.set("ending-within", event.target.defaultValue);
		location.href = url;
	})
	
	let sortBy = document.getElementById("sort-by");
	sortBy.addEventListener("change", function(event) {
		console.log(event.target.value);
		if (event.target.value == 'name') {
			var url = new URL(location.href);
			url.searchParams.set("sort-by", event.target.value);
			location.href = url;
		} else {
			var url = new URL(location.href);
			url.searchParams.delete("sort-by");
			location.href = url;
		}
	})
	
	function clearEnding() {
		let e = document.getElementsByName("ending-within");
		for (let i = 0; i < e.length; i++) {
			e[i].checked = false;
		}
		var url = new URL(location.href);
		url.searchParams.delete("ending-within");
		location.href = url;
	}
	
	function subSearch() {
		let e = document.getElementById("sub-search");
 		if (e.value != "") {
			var url = new URL(location.href);
			url.searchParams.set("sub-search", e.value);
			location.href = url;
		} else {
			var url = new URL(location.href);
			url.searchParams.delete("sub-search");
			location.href = url;
		}
	}
  </script>
</body>

</html>