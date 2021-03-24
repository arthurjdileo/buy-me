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
	
	String listingUUID = request.getParameter("listingUUID");
	if (listingUUID == null || listingUUID.equals("")) {
		response.sendRedirect("index.jsp");
		return;
	}
	
	int sold = 0;
	Listing l = null;
	if (request.getParameter("sold") != null && Integer.parseInt(request.getParameter("sold")) == 1) {
		l = BuyMe.Listings.get(request.getParameter("listingUUID"));
		sold = 1;
	} else {
		l = BuyMe.Listings.get(listingUUID);
		if (l.is_active == 0) {
			response.sendRedirect("listing-item.jsp?sold=1&listingUUID=" + l.listing_uuid);
			return;
		}
	}
	ArrayList<Bid> bids = BuyMe.Bids.getBidsByListing(listingUUID);
	Bid topBid = BuyMe.Bids.topBid(l);
	AutomaticBid autoBid = BuyMe.AutomaticBids.exists(listingUUID, u.account_uuid);
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
  <link rel="stylesheet" href="./css/listing-item.css">
  <style media="screen">
    .listing-section {
      flex-direction: column;
      /* background: red; */
      border-radius: 10px;
    }

    .previous-bids-title {
      width: 80%;
      margin: 1rem auto;

    }

    .previous-bids-container {
      background: white;
      width: 80%;
      margin: 1rem auto;
      border-radius: 10px;
      padding: 1rem;
    }

    .bids-table {
      width: 100%;
      background: white;
      border-collapse: collapse;
    }

    .user-row-cell {
      display: flex;
      justify-content: flex-start;
      padding-left: 0;
      margin-left: 0;
      align-items: center;
    }

    .user-row-cell img {
      margin: 0;
      margin-right: 1rem;
      height: 50px;
      width: 50px;
    }

    .bids-table th:first-of-type {
      text-align: left;
    }

    .bids-table th {
      border-bottom: 1px solid var(--bright-blue-2);
      padding: 1rem;
      font-size: 1.4rem;
    }

    .bids-table td {
      text-align: center;
      font-size: 1.3rem;
      border-bottom: 1px solid var(--bright-blue-2);

      padding: 1rem 0;
    }

    .bids-table tr {}

    /* bid form */
    .bid-form-box {
      /* background: yellow; */
      display: flex;
      flex: 1 1 auto;
      justify-content: flex-start;
      padding: 1rem 0;
      border-bottom: 1px solid var(--light-grey);
      border-top: 1px solid var(--light-grey);
    }

    .inline-form {
      /* background: red; */
      /* margin-left: -10px; */
      flex: 1 1 auto;
    }

    .inline-form-input {
      height: 3.6rem;
      border-radius: 500px;
      padding: 1rem;
      font-size: 1.2rem;
      border: 1px solid var(--bright-blue-2);
      flex: 1 0 auto;
      margin-right: 1rem;
    }

    .input-group {
      display: flex;
      /* background: green; */
      justify-content: space-between;
    }
  </style>
  <title>BuyMe - <%= l.item_name %></title>
</head>

<body>
  <%@include file="./includes/header.jsp" %>
  <main class="main-content">
    <section id="recent-listing" class="listing-section">
      <div class=" breadcrumb-container">
        <div class="breadcrumb">
          <span class="breadcrumb-step"><a href="listings.jsp?search-filters=category&search-query=<%=BuyMe.Categories.getByID(l.cat_id).name%>"><%= BuyMe.Categories.getByID(l.cat_id).name %></a></span>
          <span class="breadcrumb-step"><a href="listings.jsp?search-filters=category&search-query=<%=BuyMe.SubCategories.getByID(l.sub_id).name%>"><%= BuyMe.SubCategories.getByID(l.sub_id).name %></a></span>
          <span class="breadcrumb-step"><a href="listings.jsp?search-filters=item&search-query=<%= l.item_name %>"><%= l.item_name %></a></span>
        </div>
      </div>
      <div class="row-container">
        <article class="single-item-container">
          <img src="<%= l.image %>" alt="" class="product-img" width="1024" height="500">
          <div class="item-data-container">
            <h3 class="product-title"><%= l.item_name %></h3>
            <div class="item-data-row">
              <ul class="product-details main-details">
                <li class="product-price product-detail-box"><%= sold == 0 ? "Current Price" : "Sold Price" %> <span class="product-price-amount"><span class="currency-symbol">$</span><%= BuyMe.Listings.getCurrentPrice(l) %></span></li>
                <li class="product-detail-box"><%= l.description %></li>
                <% if (sold == 0) { %>
                <li class="bid-form-box">
                  <div class="row-container">
                    <div class="">
                      <form action="processBid.jsp" class="inline-form">
                        <div class="input-group">
                          <input type="number" class="inline-form-input" name="bidAmt" placeholder="Enter your bid amount" step="0.01" value="<%= BuyMe.Listings.getMinBidPrice(l) %>" min="<%= BuyMe.Listings.getMinBidPrice(l) %>">
                          <input type="text" name="listingUUID" value="<%= l.listing_uuid %>" hidden="true">
                          <input type="submit" value="SUBMIT A BID" class="btn btn-pill btn-confirm">
                          <%
                          	if (session.getAttribute("errorsBid") != null) {
	                      		ArrayList<String> errors = (ArrayList<String>) session.getAttribute("errorsBid");
	                      		if (!errors.isEmpty()) {
	                      			out.println(errors + "<br>");
	                      		}
                      		}
                          %>
                        </div>
                      </form>
                    </div>
                  </div>
                </li>
                <% } %>
              </ul>
              <div class="product-details-2">
                <h3 class="">This Auction Ends in:</h3>
                <% if (sold == 0) { %>
                <h4 class="timeout-big"><span class="product-time" id="demo">00:00</span></h4>
                <% } else if (sold == 1 && BuyMe.TransactionHistory.get(l.listing_uuid).buyer_uuid.equals(u.account_uuid)) { %>
                <h4 class="timeout-big"><span class="product-time">YOU WON!</span></h4>
                <% } else {%>
                <h4 class="timeout-big"><span class="product-time">SOLD TO <%= BuyMe.Users.get(BuyMe.TransactionHistory.get(l.listing_uuid).buyer_uuid) %>!</span></h4>
                <% } %>
                <ul class="product-details">
                  <li><span><%= BuyMe.Bids.getBiddersByListing(l.listing_uuid).size() %></span> <%= BuyMe.Bids.getBiddersByListing(l.listing_uuid).size() > 1 ? "Bidders" : "Bidder" %></li>
                  <li><span>100</span> <%= sold == 0 ? "Watching" : "Watched" %></li>
                  <li><span><%= BuyMe.Bids.getBidsByListing(l.listing_uuid).size() %></span> <%= BuyMe.Bids.getBidsByListing(l.listing_uuid).size() > 1 ? "Bids" : "Bid" %></li>
                </ul>

              </div>
              <!--end details 2-->
            </div>
            <% if (sold == 0) { %>
            <div class="bid-options-container">
              <!-- <button class="btn  danger cardbutton" data-btn="bid">bid</button> -->
              <% if (autoBid != null) { %>
              <button class="btn  blue cardbutton">update autobid</button>
              <% } else { %>
              <button class="btn  blue cardbutton">create autobid</button>
              <% } %>
              <button class="btn   btn-bid">create alert</button>
            </div>
            <% } %>
            <!--end row-->
          </div>

          <!--end data container-->
        </article>
      </div>



      <div class="row-container">
        <h2 class="previous-bids-title">Bid History</h2>
      </div>

      <div class="row-container">
        <article class="previous-bids-container">
          <table class="bids-table">
            <thead>
              <th>Bidder</th>
              <th>Date</th>
              <th>Time</th>
              <th>Unit price</th>
            </thead>
            <tbody>
              <%  for (Bid b : BuyMe.Bids.sort(bids)) { %>
              <tr>
                <td class="user-row">
                  <div class="user-row-cell">
                    <img src="./img/user.png" alt="" class="profile-img">
                    <span><%= BuyMe.Users.get(b.buyer_uuid).firstName %></span>
                  </div>
                </td>
                <td><%= BuyMe.Bids.format(b, "MMMM d, yyyy") %></td>
                <td><%= BuyMe.Bids.format(b, "h:m a") %></td>
                <td><%= b.amount %></td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </article>

      </div>
    </section>
  </main>
  <footer>
    &copy; 2020
  </footer>


  <!-- modal -->
  <div class="modal-outer">
    <div class="modal-inner">
      <h3>modal title</h3>
    </div>
  </div>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="./js/timeout.js"></script>
  
  <script>
  countDown(new Date ('<%= l.end_time %> UTC').getTime(), "demo");
  </script>

  <script type="text/javascript">
    // get elements
    const cardButtons = document.querySelectorAll('.cardbutton');
    const modalInner = document.querySelector('.modal-inner');
    const modalOuter = document.querySelector('.modal-outer');

    function handleBidButton(event) {
      const button = event.currentTarget;
      modalInner.innerHTML = `
	      <form action="processAutoBid.jsp" class="card">
	      <h2><%= autoBid != null ? "Update Auto Bid" : "Create Auto Bid" %></h2>
	      <div class="input-group">
	      <label for="max-amount">Max Amount</label>
	      <input type="number" id="max-number" name="max-number" value="<%= autoBid != null ? autoBid.upper_limit : BuyMe.Listings.getMinBidPrice(l) %>" min="<%= BuyMe.Listings.getMinBidPrice(l) %>" />
	      </div>
	      <div class="input-group">
	      <label for="bid-amount">Increment Amt.</label>
	      <input type="number" id="bid-number" name="bid-number" value="<%= autoBid != null ? autoBid.increment : l.bid_increment %>" min="<%= l.bid_increment %>" />
	      </div>
	      <input type="text" name="listingUUID" value="<%= l.listing_uuid %>" hidden/>
	      <input type="submit" value="<%= autoBid != null ? "update auto bid" : "create auto bid" %>" class='btn btn-sm btn-confirm'>
	      </form>
      `;
      // show the modal
      modalOuter.classList.add('open');
    }
    cardButtons.forEach((button) => {
      button.addEventListener('click', handleBidButton);
    });

    function closeModal() {
      modalOuter.classList.remove('open');
    }

    modalOuter.addEventListener('click', function(event) {
      const isOutsise = !event.target.closest('.modal-inner');
      if (isOutsise) {
        modalOuter.classList.remove('open');
      }
    })


    window.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') {
        closeModal();
      }
    })
  </script>
</body>

</html>