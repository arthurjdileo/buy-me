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
	ArrayList<Category> categories = BuyMe.Categories.getAsList();
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
  <style media="screen">
    h2 {
      margin-left: 1rem;
    }

    .create-listing-form {
      background: var(--cream);
      display: flex;
      flex-direction: column;
      padding: 1.5rem 2.5rem;
      border: 1px solid var(--black);
      border-radius: 6px;
      box-shadow: 1px 1px 20px rgba(0, 0, 0, 0.2);
      min-width: 650px;
    }

    .input-group {
      display: flex;
      font-size: 1.5rem;
      margin-bottom: 1rem;
    }

    .input-label {
      font-weight: 400;
      margin-bottom: 10px;
    }

    #end-date {
      height: 1rem;
    }
  </style>
  <title>Create Listing</title>
</head>

<body>
  <header class="main-header">
    <div class="logo-container">
      <a href="index.jsp"><img src="./img/logo.png" alt=" "></a>
    </div>
    <nav class="top-nav">
      <p id="show-list-on-hover" class="">Shop By Category</p>
      <ul class="list-content" id="categories">
      <% for (Category c : categories) { %>
        <li class=""><a href=""><%= c.name %></a></li>
      <% } %>
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
        <img src="./img/user.png" alt="" class="profile-img">
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
          <p class="user-profile-email"><%= u.email %></p>
        </picture>

        <a href="logout.jsp" class="btn btn-sm blue in-block" id="signout-btn">signout</a>
      </div> <!-- end side navigation-->

      <div class="panels-container">
        <div class="" role="tabpanel" aria-labelledby="description">
          <h2>Create listing </h2>
          <section class="listing-panel">
            <form action="" class="create-listing-form">
              <div class="input-group">
                <label for="name" class="input-label">product name* </label>
                <input type="text" class="input-field" required>
              </div>
              <div class="input-group">
                <label for="category" class="input-label">category* </label>
                <select id="category" name="category" required>
                  <% for (Category c : categories) { %>
                  <option value="<%= c.name %>"><%= c.name %></option>
                  <% } %>
                </select>
              </div>
              <div class="input-group">
                <label for="sub-category" class="input-label">sub-category* </label>
                <select id="subcategory" name="sub-category" required>
                  <option value="cat 1">sub cat 1</option>
                  <option value="cat 2">sub cat 2</option>
                  <option value="cat 3">sub cat 3</option>
                  <option value="cat 4">sub cat 4</option>
                </select>
              </div>
              <div class="input-group">
                <label for="description" class="input-label">description*
                  <textarea name="description" rows="8" cols="" class="listing-text-area" required></textarea>
                </label>
              </div>
              <div class="input-group">
                <label for="end-date" class="input-label">Ending date*</label>
                <input type="date" id="end-date" name="end-date" class="input-field" required>
              </div>

              <div class="input-group">
                <label for="price" class="input-label">image link* </label>
                <input type="url" class="input-field" id="image-link" name="image-link" required>
              </div>

              <div class="input-group">
                <label for="price" class="input-label">price* </label>
                <input type="number" class="input-field" id="price" name="price" min="1" required>
              </div>

              <div class="input-group">
                <label for="reserve-price" class="input-label">reserve price </label>
                <input type="number" class="input-field" id="reserve-price" name="reserve-price" min="0">
              </div>

              <div class="input-group">
                <label for="bid-increment" class="input-label">bid increment* </label>
                <input type="number" class="input-field" id="bid-increment" name="bid-increment" min="0">
              </div>
              <div class="input-group">
                <label for="currency" class="input-label">currency* </label>
                <select id="currency" name="currency">
                  <option value="USD">USD</option>
                  <option value="GBP">GBP</option>
                  <option value="CAD">CAD</option>
                  <option value="EUR">EUR</option>
                </select>
              </div>

              <input type="submit" class="submit-btn" value="create listing">
            </form>

        </div>
      </div>

    </div>
    <!--end tabs -->

  </main>

  <footer>
    &copy; 2020
  </footer>

</body>

</html>