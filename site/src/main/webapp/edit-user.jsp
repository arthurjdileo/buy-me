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
	if (!BuyMe.Admins.isAdmin(u.account_uuid)) {
		response.sendRedirect("index.jsp");
		return;
	}
	String acc_uuid = request.getParameter("acc_uuid");
	User editing = BuyMe.Users.get(acc_uuid);
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
  <title>BuyMe - Edit User</title>
 
</head>

<body>
  <%@include file="./includes/header.jsp" %>
  <main class="main-content">
    <div class="tabs">
      <div class="listing-nav-container" role="tablist" aria-label="profile list">
        <picture class="user-profile-img-container">
          <img src="img/user.png" alt="" class="user-profile-img">
          <p class="user-profile-name"><%= u.toString() %></p>
          <% if (BuyMe.Admins.isAdmin(u.account_uuid)) { %>
          <p class="user-profile-name">[<%= BuyMe.Admins.getRole(u.account_uuid) %>]</p>
          <% } %>
          <p class="user-profile-email"><%= u.email %></p>
        </picture>
        <button role="tab" class="listing-nav" id="dashboard" aria-selected="true"><img src="./img/menu.svg" type="image/svg-xml" alt="" class="listing-nav-icon">edit user</button>
        <a href="logout.jsp" class="btn btn-sm blue listing-nav" id="signout-btn">Sign Out</a>
      </div>

      <div class="panels-container">
        <div class="" role="tabpanel" aria-labelledby="dashboard" id="personal-pro" hidden>
          <section class="listing-panel">
            <form action="updateProfile.jsp" class="listing-form">
              <div class="panel-article">
                <h3 class="panel-article-title">Personal Details</h3>
                <div class="input-group">
                  <label for="first-name" class="input-label">first name </label>
                  <input type="text" class="input-field" name="first-name" id="first-name" value="<%= editing.firstName %>">
                </div>
                <div class="input-group">
                  <label for="last-name" class="input-label">last name </label>
                  <input type="text" class="input-field" name="last-name" id="last-name" value="<%= editing.lastName %>">
                </div>
              </div>
              <div class="panel-article">
                <h3 class="panel-article-title">Email</h3>
                <div class="input-group">
                  <label for="email" class="input-label">email </label>
                  <input type="email" class="input-field" name="email" id="email" value="<%= editing.email %>">
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
                  <input hidden name="from-admin" value="true"></input>
                  <input hidden name="acc_uuid" value="<%= acc_uuid %>"></input>
                </div>
              </div>
              <% if (BuyMe.Admins.isAdmin(u.account_uuid)) { %>
              <div class="panel-article">
                <h3 class="panel-article-title">Admin</h3>
                <div class="input-group">
                  <label for="password" class="input-label">Moderator? </label>
                  <input hidden name="isMod" value="false" id="isMod">
              	<input type="checkbox" value="true" class="input-field" name="isMod" id="isMod">
                </div>
              </div>
              <% } %>
              <%
	              if (session.getAttribute("errorUpdateProfileAdmin") != null) {
	          		ArrayList<String> errors = (ArrayList<String>) session.getAttribute("errorUpdateProfileAdmin");
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