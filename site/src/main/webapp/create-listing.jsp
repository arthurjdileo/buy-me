<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="javax.servlet.annotation.MultipartConfig" %>

<%
	Cookie[] cookies = request.getCookies();
	if (!BuyMe.Sessions.safetyCheck(cookies)) {
		response.sendRedirect("login.jsp");
		return;
	}
	User u = BuyMe.Sessions.getBySession(BuyMe.Sessions.getCurrentSession(cookies));
	ArrayList<Category> categories = BuyMe.Categories.getAsList();
	ArrayList<SubCategory> subCategories = BuyMe.SubCategories.getAsList();
	int edit = 0;
	Listing l = null;
	if (request.getParameter("edit") != null && Integer.parseInt(request.getParameter("edit")) == 1) {
		l = BuyMe.Listings.get(request.getParameter("listingUUID"));
		if (!l.seller_uuid.equals(u.account_uuid) && !BuyMe.Admins.isAdmin(u.account_uuid) && !BuyMe.Admins.isMod(u.account_uuid)) {
			response.sendRedirect("index.jsp");
			return;
		}
		edit = 1;
	}
	
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
  <link rel="apple-touch-icon" sizes="180x180" href="./apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="./favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="./favicon-16x16.png">
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
            <form action="processCreateListing.jsp" method="post" class="create-listing-form" enctype="multipart/form-data">
              <div class="input-group">
                <label for="name" class="input-label">product name* </label>
                <% if (edit == 1) { %>
                <input type="text" class="input-field" value="<%= l.item_name %>" name="product" required>
                <% } else { %>
                <input type="text" class="input-field" name="product" required>
                <% } %>
              </div>
              <div class="input-group">
                <label for="category" class="input-label">category* </label>
                <select onchange="showCustom(this);" id="category" name="category" required>
                  <% for (Category c : categories) { %>
                  <% if (edit == 1 && c.id == l.cat_id) { %>
                  <option value="<%= c.id %>" selected><%= c.name %></option>
                  <% } %>
                  <option value="<%= c.id %>"><%= c.name %></option>
                  <% } %>
                  <option value="other">Other</option>
                </select>
              </div>
              <div id="customCategory" style="display: none;">
	              <div class="input-group">
		              <label for="category" class="input-label">Custom category* </label>
		              <input name="category-custom" type="text"></input>
	              </div>
              </div>
              <div id="customSubCategory" style="display: none;">
        	      <div class="input-group">
		              <label for="category" class="input-label">Custom sub-category* </label>
		              <input name="sub-category-custom" type="text"></input>
	              </div>
	          </div>
              <div class="input-group" id="sub-categories">
                <label for="sub-category" class="input-label">sub-category* </label>
                <select id="subcategory" name="sub-category" required>
                  <% for (SubCategory c : subCategories) { %>
                  <% if (edit == 1 && c.id == l.sub_id) { %>
                  <option value="<%= c.id %>" selected><%= c.name %></option>
                  <% } %>
                  <option value="<%= c.id %>"><%= c.name %></option>
                  <% } %>
                </select>
              </div>
              <div class="input-group">
                <label for="description" class="input-label">description*
                  <% if (edit == 1) { %>
                  <textarea name="description" rows="8" cols="" class="listing-text-area" required><%= l.description %></textarea>
                  <% } else { %>
                  <textarea name="description" rows="8" cols="" class="listing-text-area" required></textarea>
                  <% } %>
                </label>
              </div>
              
              <div class="input-group" id="item-conditions">
                <label for="item-condition" class="input-label">Item Condition* </label>
                <select id="itemcondition" name="item-condition" required>
                  <% if (edit == 1) { %>
                  		<% if (l.item_condition.equals("New")) { %>
                  		<option value="New" selected>New</option>
                  		<option value="Pre-Owned">Pre-Owned</option>
                  		<% } else { %>
                		<option value="New">New</option>
                  		<option value="Pre-Owned" selected>Pre-Owned</option>
                  		<% } %>
                  <% } else { %>
                  		<option value="New">New</option>
                  		<option value="Pre-Owned">Pre-Owned</option>
                  <% } %>
                  
                </select>
              </div>
              
              <div class="input-group">
                <label for="num-days" class="input-label">number of days* </label>
                <% if (edit == 1) { %>
                <input type="number" class="input-field" id="num-days" value="<%= l.listing_days %>" name="num-days" min="1" max="30" required>
                <% } else { %>
                <input type="number" class="input-field" id="num-days" name="num-days" min="1" max="30" required>
                <% } %>
              </div>

              <%-- <div class="input-group">
                <label for="price" class="input-label">image link* </label>
                <% if (edit == 1) { %>
                <input type="url" class="input-field" id="image-link" value="<%= l.image %>" name="image-link" required>
                <% } else { %>
                <input type="url" class="input-field" id="image-link" name="image-link" required>
                <% } %>
              </div> --%>
              <div class="input-group">
                <div class="img-placeholder">

                  <label for="uploadi-image" class="input-label" id="image-upload-label">Upload an image
                  </label>
                  <% if (edit == 1) { %>
                  <input type="file" class="input-field" id="img" accept="image/*" id="upload-image" name="listing-image" style="display: none;">
                  <label for="img"><%= l.item_name %> Uploaded.</label>
                  <% } else { %>
                  <input type="file" class="input-field" accept="image/*" id="upload-image" name="listing-image">
                  <% } %>
                </div>
              </div>

              <div class="input-group">
                <label for="price" class="input-label">start price* </label>
                <% if (edit == 1) { %>
                <input type="number" class="input-field" id="price" value="<%= l.start_price %>" name="price" min="0.01" step="0.01" required>
                <% } else { %>
                <input type="number" class="input-field" id="price" name="price" min="0.01" step="0.01" required>
                <% } %>
              </div>

              <div class="input-group">
                <label for="reserve-price" class="input-label">reserve price* </label>
                <% if (edit == 1) { %>
                <input type="number" class="input-field" id="reserve-price" value="<%= l.reserve_price %>" name="reserve-price" min="0.01" step="0.01" required>
                <% } else { %>
                <input type="number" class="input-field" id="reserve-price" name="reserve-price" min="0.01" step="0.01" required>
                <% } %>
              </div>

              <div class="input-group">
                <label for="bid-increment" class="input-label">min. bid increment* </label>
                <% if (edit == 1) { %>
                <input type="number" class="input-field" id="bid-increment" value="<%= l.bid_increment %>" name="bid-increment" min="0.01" step="0.01">
                <% } else { %>
                <input type="number" class="input-field" id="bid-increment" name="bid-increment" min="0.01" step="0.01">
                <% } %>
              </div>
              <div class="input-group">
                <label for="currency" class="input-label">currency* </label>
                <select id="currency" name="currency">
                  <option value="USD">USD</option>
<!--                   <option value="GBP">GBP</option>
                  <option value="CAD">CAD</option>
                  <option value="EUR">EUR</option> -->
                </select>
              </div>
			  <% if (edit == 1) { %>
			  <input type="text" name="listingUUID" value="<%= l.listing_uuid %>" hidden>
			  <input type="number" name="edit" value="1" hidden>
			  <input type="submit" class="submit-btn" value="edit listing">
			  <% } else { %>
              <input type="submit" class="submit-btn" value="create listing">
              <% } %>
            </form>

        </div>
      </div>

    </div>
    <!--end tabs -->

  </main>

  <footer>
    &copy; 2020
  </footer>
  
  <script type="text/javascript">
  
  	function showCustom(e) {
  		if (e.value == 'other') {
  			console.log("custom");
  			document.getElementById("customCategory").style.display = "flex";
  			document.getElementById("customSubCategory").style.display = "flex";
  			document.getElementById("sub-categories").style.display = "none";
  		} else {
  			console.log("not custom")
  			document.getElementById("customCategory").style.display = "none";
  			document.getElementById("customSubCategory").style.display = "none";
  			document.getElementById("sub-categories").style.display = "flex";
  		}
  	}
  
  </script>

</body>

</html>