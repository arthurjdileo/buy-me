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
	ArrayList<SubCategory> subCategories = BuyMe.SubCategories.getAsList();
	
	int currentCategory = 0;
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
  <title>BuyMe - Create Listing</title>
</head>

<body>
  <%@include file="./includes/header.jsp" %>
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
            <form action="processCreateListing.jsp" class="create-listing-form">
              <div class="input-group">
                <label for="name" class="input-label">product name* </label>
                <input type="text" class="input-field" name="product" required>
              </div>
              <div class="input-group">
                <label for="category" class="input-label">category* </label>
                <select id="category" name="category" required>
                  <% for (Category c : categories) { %>
                  <option value="<%= c.id %>"><%= c.name %></option>
                  <% } %>
                </select>
              </div>
              <div class="input-group">
                <label for="sub-category" class="input-label">sub-category* </label>
                <select id="subcategory" name="sub-category" required>
                  <% for (SubCategory c : subCategories) { %>
                  <option value="<%= c.id %>"><%= c.name %></option>
                  <% } %>
                </select>
              </div>
              <div class="input-group">
                <label for="description" class="input-label">description*
                  <textarea name="description" rows="8" cols="" class="listing-text-area" required></textarea>
                </label>
              </div>
              
              <div class="input-group">
                <label for="num-days" class="input-label">number of days* </label>
                <input type="number" class="input-field" id="num-days" name="num-days" min="1" max="30" required>
              </div>

              <div class="input-group">
                <label for="price" class="input-label">image link* </label>
                <input type="url" class="input-field" id="image-link" name="image-link" required>
              </div>

              <div class="input-group">
                <label for="price" class="input-label">start price* </label>
                <input type="number" class="input-field" id="price" name="price" min="0.01" step="0.01" required>
              </div>

              <div class="input-group">
                <label for="reserve-price" class="input-label">reserve price </label>
                <input type="number" class="input-field" id="reserve-price" name="reserve-price" min="0.01" step="0.01">
              </div>

              <div class="input-group">
                <label for="bid-increment" class="input-label">bid increment* </label>
                <input type="number" class="input-field" id="bid-increment" name="bid-increment" min="0.01" step="0.01">
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