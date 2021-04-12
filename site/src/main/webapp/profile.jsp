<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.util.concurrent.TimeUnit.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	Cookie[] cookies = request.getCookies();
	if (!BuyMe.Sessions.safetyCheck(cookies)) {
		response.sendRedirect("login.jsp");
		return;
	}
	User u = BuyMe.Sessions.getBySession(BuyMe.Sessions.getCurrentSession(cookies));
	ArrayList<Bid> userBids = BuyMe.Bids.getBidsByUser(u.account_uuid);
	ArrayList<Transaction> buyerTrans = BuyMe.TransactionHistory.getByBuyer(u.account_uuid);
	ArrayList<Listing> listings = BuyMe.Listings.getByUser(u.account_uuid);
	ArrayList<SetAlert> setAlerts = BuyMe.SetAlerts.getByUser(u.account_uuid);
	ArrayList<Alert> userAlerts = BuyMe.Alerts.getByUserBid(u.account_uuid);
	ArrayList<SetAlert> setAlertsCategory = BuyMe.SetAlerts.getByUserCategory(u.account_uuid);
	ArrayList<Alert> userAlertsCategory = BuyMe.Alerts.getByUserCategory(u.account_uuid);
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
  <link rel="stylesheet" href="./css/listing.css">
  <link rel="stylesheet" href="./css/profile.css">
  <link rel="apple-touch-icon" sizes="180x180" href="./apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="./favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="./favicon-16x16.png">
  <title>BuyMe - Profile</title>
 
</head>

<body>
  <%@include file="./includes/header.jsp" %>
  <main class="main-content">
    <div class="tabs">
      <div class="listing-nav-container" role="tablist" aria-label="profile list">
        <picture class="user-profile-img-container">
          <img src="img/user.png" alt="" class="user-profile-img">
          <p class="user-profile-name"><%= u.toString() %></p>
          <% if (BuyMe.Admins.isAdmin(u.account_uuid) || BuyMe.Admins.isMod(u.account_uuid)) { %>
          <p class="user-profile-name">[<%= BuyMe.Admins.getRole(u.account_uuid) %>]</p>
          <% } %>
          <p class="user-profile-email"><%= u.email %></p>
        </picture>
        <button role="tab" class="listing-nav" id="dashboard" aria-selected="true"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">dashboard</button>
        <button role="tab" class="listing-nav" id="personal-profile" aria-selected="false"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">personal profile</button>
        <button role="tab" class="listing-nav" id="listings" aria-selected="false"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">my listings</button>
        <button role="tab" class="listing-nav" id="alerts" aria-selected="false"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">my alerts</button>
        <button role="tab" class="listing-nav" id="won-auctions" aria-selected="false"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">won auctions</button>
        <button role="tab" class="listing-nav" onclick="window.location.href = 'faq.jsp'"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">FAQ's</button>
        <a href="logout.jsp" class="btn btn-sm blue listing-nav" id="signout-btn">Sign Out</a>
      </div>

      <div class="panels-container">
        <div class="" role="tabpanel" aria-labelledby="dashboard">
          <section class="listing-panel dashboard-panel">
            <article class="panel-article">
              <h3 class="panel-article-title">My Activity</h3>
              <div class="activity-row">
                <div class="activity-item">
                  <img src="./img/menu.svg" type="image/svg-xml" alt="" class="activity-icon">
                  <p class="activity-figure"><%= userBids.size() %></p>
                  <h4 class="activity-name">Active Bids</h4>
                </div>
                <div class="activity-item">
                  <img src="./img/menu.svg" type="image/svg-xml" alt="" class="activity-icon">
                  <p class="activity-figure"><%= buyerTrans.size() %></p>
                  <h4 class="activity-name">Items Won</h4>
                </div>
                <div class="activity-item">
                  <img src="./img/menu.svg" type="image/svg-xml" alt="" class="activity-icon">
                  <p class="activity-figure"><%= setAlerts.size() %></p>
                  <h4 class="activity-name">Watching</h4>
                </div>
              </div>
            </article>

            <article class="panel-article">
              <h3 class="credits">Credits available:
                <p class="in-block"> <span class="currency-symbol">$</span><span class="credit-amount"><%= u.credits %></span></p>
              </h3>
            </article>

          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="personal-profile" id="personal-pro" hidden>
          <section class="listing-panel">
            <form action="updateProfile.jsp" class="listing-form">
              <div class="panel-article">
                <h3 class="panel-article-title">Personal Details</h3>
                <div class="input-group">
                  <label for="first-name" class="input-label">first name </label>
                  <input type="text" class="input-field" name="first-name" id="first-name" value="<%= u.firstName %>">
                </div>
                <div class="input-group">
                  <label for="last-name" class="input-label">last name </label>
                  <input type="text" class="input-field" name="last-name" id="last-name" value="<%= u.lastName %>">
                </div>
              </div>
              <div class="panel-article">
                <h3 class="panel-article-title">Email</h3>
                <div class="input-group">
                  <label for="email" class="input-label">email </label>
                  <input type="email" class="input-field" name="email" id="email" value="<%= u.email %>">
                </div>
              </div>
              <div class="panel-article">
                <h3 class="panel-article-title">Security</h3>
                <div class="input-group">
                  <label for="password" class="input-label">password </label>
                  <input type="password" class="input-field" name="password" id="password">
                </div>
                <div class="input-group">
                  <label for="change-password" class="input-label">confirm password </label>
                  <input type="password" class="input-field" name="change-password" id="change-password">
                </div>
              </div>
              <%
	              if (session.getAttribute("errorUpdateProfile") != null) {
	          		ArrayList<String> errors = (ArrayList<String>) session.getAttribute("errorUpdateProfile");
	          		if (!errors.isEmpty()) {
	          			out.println(errors + "<br>");
	          		}
	          	  }
              %>
              <div class="input-group flex-end form-btn-group">
                <input type="submit" value="update" class="btn btn-sm green btn-confirm">
              </div>
            </form>

          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="listings" hidden>
          <h2>listing panel</h2>
          <section class="listing-panel">
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">Product</th>
                <th class="listing-table__th view-column">View</th>
                <th class="listing-table__th action-column">Action</th>
              </thead>
              <tbody class="listing-table__body">
              <% for (Listing l : listings) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><b><%= l.item_name %></b><br>
                    <p><%= l.description %></p>
                  </td>
                  <td class="listing-table__td view-column">
                    <button type="button" name="button" class="btn btn-sm" onclick="location.href='listing-item.jsp?listingUUID=<%= l.listing_uuid %>'">
                      view item
                    </button>
                  </td>
                  <td class="listing-table__td action-column">
                    <button type="button" name="button" class="btn btn-sm bg-caution" onclick="location.href='create-listing.jsp?edit=1&listingUUID=<%= l.listing_uuid %>'">
                      Edit
                    </button>
                    <form action="deleteListing.jsp">
                    <input name="listingUUID" value="<%= l.listing_uuid %>" type="text" hidden></input>
                    <button type="submit" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                    </form>
                  </td>
                </tr>
				<% } %>
              </tbody>
            </table>
          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="alerts" hidden>
          <!-- notifications -->
          <section class="listing-panel ">
            <article class="panel-article notifications-panel">
              <h3 class="panel-article-title">Notifications </h3>
              <div class="notifications-container">
                <% for (Alert a : userAlerts) { %>
                <form action="ackNotification.jsp" id="<%= a.alert_uuid %>">
                <input name="alertUUID" value="<%= a.alert_uuid %>" hidden></input>
                <div class="notification-item"><%= a.msg %><span onclick="document.getElementById('<%= a.alert_uuid %>').submit(); console.log('hit');" class="closebtn">&times;</span></div>
                </form>
                <% } %>
              </div>
            </article>
          </section>
          <!-- end notifications -->

          <h2 class="panel-article-title">My Alerts</h2>
          <section class="">
            <!-- Tab links -->
            <div class="tab">
              <% for (SetAlert sa : setAlertsCategory) { %>
              <button class="tablinks" onclick="showAlertListing(event, '<%= sa.alert_uuid %>')"><%= sa.alert %></button>
              <% } %>
            </div>

            <!-- Tab content -->
            <% for (SetAlert sa : setAlertsCategory) { %>
            <div id="<%= sa.alert_uuid %>" class="tabcontent">
              <h3>List of <%= sa.alert %> Alert</h3>
              <ul class="alert-type-list">
              <% for (Alert a : userAlertsCategory) { %>
              <% Listing l = BuyMe.Listings.get(a.msg); %>
              <% if (l != null) { %>
                <li>
                  <article class="product-container alert-listing-item">
                    <img src="<%= l.image %>" width="100" height="100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title"><%= l.item_name %></h3>
                      <ul class="product-details">
                        <li>
                          <p class="similar-desc" style="max-width: 315px;"><%= l.description %></p>
                        </li>
                        <li>Price <span class="product-price">$<%= BuyMe.Listings.getCurrentPrice(l) %></span></li>
                        <li>Time <span class="product-time" id="<%= l.listing_uuid %>">00:00</span></li>
                        <!--  <li>Currency <span class="product-currency">USD</span></li>-->
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid " onclick="location.href='listing-item.jsp?listingUUID=<%= l.listing_uuid %>'">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>
                <% } %>
                <% } %>
              </ul>
            </div>
            <% } %>
            <!--end tabcontent-->
          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="won-auctions" hidden>
          <h2>Won Auctions</h2>
          <section class="listing-panel">
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">Product</th>
                <th class="listing-table__th view-column">View</th>
              </thead>
              <tbody class="listing-table__body">
                <% for (Transaction t : buyerTrans) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><b><%= BuyMe.Listings.get(t.listing_uuid).item_name %></b><br>
                    <p><%= BuyMe.Listings.get(t.listing_uuid).description %></p>
                  </td>
                  <td class="listing-table__td view-column">
                    <button type="button" name="button" class="btn btn-sm" onclick="location.href='listing-item.jsp?sold=1&listingUUID=<%= t.listing_uuid %>'">
                      view item
                    </button>
                  </td>
				<% } %>
                </tr>
              </tbody>
            </table>
            <!-- <button class="btn btn-sm danger">Create alert</button> -->
          </section>
        </div>
        <!--end panel-->

      </div>

    </div>
    <!--end tabs -->

  </main>
  <footer>
    &copy; 2020
  </footer>

  <script src="./js/tabs.js"></script>
  <script src="./js/hash-url.js"></script>
  <script src="./js/timeout.js"></script>
  
  <script>
    <% for (Alert a : userAlertsCategory) { %>
    <% Listing l = BuyMe.Listings.get(a.msg); %>
    <% if (l != null) { %>
	countDown(new Date ('<%= l.end_time %>-04:00').getTime(),"<%= l.listing_uuid %>");
	<%}%>
	<%}%>
  </script>

</body>

</html>

<%
/* 	long start = System.currentTimeMillis();
	while (true) {
		long diff = System.currentTimeMillis() - start;
		int sec = (int)diff / 1000;
		if (sec != 0 && sec % 5 == 0) {
			System.out.println("test");
			start = System.currentTimeMillis();
		}
	} */
%>