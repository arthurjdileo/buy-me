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
  <title>BuyMe - Profile</title>
 
</head>

<body>
  <header class="main-header">
    <div class="logo-container">
      <a href="index.jsp"><img src="./img/logo.png" alt=" "></a>
    </div>
    <nav class="top-nav">
      <p id="show-list-on-hover" class="">Shop By Category</p>
      <ul class="list-content" id="categories">
        <li class=""><a href="">Category 1</a></li>
        <li class=""><a href="">Category 2</a></li>
        <li class=""><a href="">Category 3</a></li>
      </ul>
    </nav>
    <form action="" class="search-form">
      <div class="search-input-container">
        <input type="text" placeholder="Search" class="search-input">
        <label for="search-filters" class="select-label">Filter by: </label>
        <select id="search-filters" name="search-filters" class="search-filters-select">
          <option value="category">Category</option>
          <option value="item">Item</option>
          <option value="user">User</option>
        </select>
        <input type="submit" value="Search" class="search-btn">
      </div>
    </form>
    <div class="profile-container">
      <a href="profile.jsp">
        <img src="img/user.png" alt="" class="profile-img">
        <span>Profile</span>
      </a>
    </div>
  </header>

  <main class="main-content">
    <div class="tabs">
      <div class="listing-nav-container" role="tablist" aria-label="profile list">
        <picture class="user-profile-img-container">
          <img src="img/user.png" alt="" class="user-profile-img">
          <p class="user-profile-name"><%= u.firstName + " " + u.lastName %></p>
          <% if (BuyMe.Admins.isAdmin(u.account_uuid)) { %>
          <p class="user-profile-name">[<%= BuyMe.Admins.getRole(u.account_uuid) %>]</p>
          <% } %>
          <p class="user-profile-email"><%= u.email %></p>
        </picture>
        <button role="tab" class="listing-nav" id="dashboard" aria-selected="true"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">dashboard</button>
        <button role="tab" class="listing-nav" id="personal-profile" aria-selected="false"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">personal profile</button>
        <button role="tab" class="listing-nav" id="listings" aria-selected="false"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">my listings</button>
        <button role="tab" class="listing-nav" id="alerts" aria-selected="false"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">my alerts</button>
        <button role="tab" class="listing-nav" id="won-auctions" aria-selected="false"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">won auctions</button>
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
                  <p class="activity-figure">100</p>
                  <h4 class="activity-name">Alerts</h4>
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
                <tr class="listing-table__tr">
                  <td class="listing-table__td">Orange juice pack...
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
                      consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                  </td>
                  <td class="listing-table__td view-column">
                    <button type="button" name="button" class="btn btn-sm ">
                      view item
                    </button>
                  </td>
                  <td class="listing-table__td action-column">
                    <button type="button" name="button" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                    <button type="button" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                  </td>
                </tr>

                <tr class="listing-table__tr">
                  <td class="listing-table__td">Orange juice pack...
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
                      consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                  </td>
                  <td class="listing-table__td view-column">
                    <button type="button" name="button" class="btn btn-sm ">
                      view item
                    </button>
                  </td>
                  <td class="listing-table__td action-column">
                    <button type="button" name="button" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                    <button type="button" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                  </td>
                </tr>

                <tr class="listing-table__tr">
                  <td class="listing-table__td">Orange juice pack...
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
                      consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                  </td>
                  <td class="listing-table__td view-column">
                    <button type="button" name="button" class="btn btn-sm ">
                      view item
                    </button>
                  </td>
                  <td class="listing-table__td action-column">
                    <button type="button" name="button" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                    <button type="button" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
            <!-- <button class="btn btn-sm danger">Create alert</button> -->
          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="alerts" hidden>
          <!-- notifications -->
          <section class="listing-panel ">
            <article class="panel-article notifications-panel">
              <h3 class="panel-article-title">Notifications </h3>
              <div class="notifications-container">
                <div class="notification-item">notification here</div>
                <div class="notification-item">notification here</div>
                <div class="notification-item">notification here</div>
                <div class="notification-item">notification here</div>
              </div>
            </article>
          </section>
          <!-- end notifications -->

          <h2 class="panel-article-title">alerts panel</h2>
          <section class="">
            <!-- Tab links -->
            <div class="tab">
              <button class="tablinks" onclick="showAlertListing(event, 'alert-type-1')">Alert 1</button>
              <button class="tablinks" onclick="showAlertListing(event, 'alert-type-2')">Alert 2</button>
              <button class="tablinks" onclick="showAlertListing(event, 'alert-type-3')">Alert 3</button>
            </div>

            <!-- Tab content -->
            <div id="alert-type-1" class="tabcontent">
              <h3>List of listing alert type 1</h3>
              <ul class="alert-type-list">
                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/119/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>
                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/119/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>
                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/119/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>

                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/119/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>
              </ul>
            </div>
            <!--end tabcontent-->

            <div id="alert-type-2" class="tabcontent">
              <h3>List of listing alert type 2</h3>
              <ul class="alert-type-list">
                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/118/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>
                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/118/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>
                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/118/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>

                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/118/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>
              </ul>
            </div>
            <!--end tabcontent-->

            <div id="alert-type-3" class="tabcontent">
              <h3>List of listing alert type 3</h3>
              <ul class="alert-type-list">
                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/117/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>
                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/117/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>
                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/117/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>

                <li>
                  <article class="product-container alert-listing-item">
                    <img src="https://picsum.photos/id/117/100" alt="" class="product-img">
                    <div class="product-data-container">
                      <h3 class="product-title">product name</h3>
                      <ul class="product-details">
                        <li>
                          <p>Product description This product...</p>
                        </li>
                        <li>Price <span class="product-price">100</span></li>
                        <li>Time <span class="product-time" id="demo">00:00</span></li>
                        <li>Currency <span class="product-currency">USD</span></li>
                      </ul>
                      <div class="bid-options">
                        <button class="btn btn-sm btn-bid ">view listing</button>

                      </div>
                    </div>
                  </article>
                </li>
              </ul>
            </div>
            <!--end tabcontent-->

            <button class="btn btn-sm danger create-alert-btn">Create alert</button>
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
                <th class="listing-table__th action-column">Action</th>
              </thead>
              <tbody class="listing-table__body">
                <tr class="listing-table__tr">
                  <td class="listing-table__td">Orange juice pack...
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                  </td>
                  <td class="listing-table__td view-column">
                    <button type="button" name="button" class="btn btn-sm ">
                      view item
                    </button>
                  </td>
                  <td class="listing-table__td action-column">
                    <button type="button" name="button" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                    <button type="button" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                  </td>
                </tr>

                <tr class="listing-table__tr">
                  <td class="listing-table__td">Orange juice pack...
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                  </td>
                  <td class="listing-table__td view-column">
                    <button type="button" name="button" class="btn btn-sm ">
                      view item
                    </button>
                  </td>
                  <td class="listing-table__td action-column">
                    <button type="button" name="button" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                    <button type="button" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                  </td>
                </tr>

                <tr class="listing-table__tr">
                  <td class="listing-table__td">Orange juice pack...
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
                  </td>
                  <td class="listing-table__td view-column">
                    <button type="button" name="button" class="btn btn-sm ">
                      view item
                    </button>
                  </td>
                  <td class="listing-table__td action-column">
                    <button type="button" name="button" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                    <button type="button" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                  </td>
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