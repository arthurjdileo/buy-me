<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/login.css">
  <title>login</title>
</head>

<body>
  <header class="main-header">
    <figure>
      <a href="/">
        <div class="logo">
          <img src="" alt=" ">
        </div>
      </a>
    </figure>
    <h1 class="title-center register-title">Register </h1>
  </header>
  <main class="main-content">
    <div class="login-container">

      <form action="registerValidation.jsp" class="login-form">

        <div class="input-group">
          <label for="fname" class="input-label">First Name </label>
          <input type="text" class="input-field" name="fname" placeholder="Your First Name" id="fname" required>
        </div>
        
        <div class="input-group">
          <label for="lname" class="input-label">Last Name </label>
          <input type="text" class="input-field" name="lname" placeholder="Your Last Name" id="lname" required>
        </div>

        <div class="input-group">
          <label for="email" class="input-label">Email </label>
          <input type="email" class="input-field" name="email" placeholder="e.g. john@mail.com" id="email" required>
        </div>

        <div class="input-group">
          <label for="password" class="input-label">Password </label>
          <input type="password" class="input-field" name="password" placeholder="Your secret password" id="password" required>
        </div>
        
        <%
        	Cookie[] cookies = request.getCookies();
        	String sessionUUID = null;
        	if (cookies != null) {
        		for (Cookie cookie : cookies) {
        			if (cookie.getName().equals("SESSION_UUID")) {
        				sessionUUID = cookie.getValue();
        			}
        		}
        	}
        	if (BuyMe.Sessions.validateSession(sessionUUID)) {
        		response.sendRedirect("index.jsp");
        		return;
        	}
        	if (session.getAttribute("errorsReg") != null) {
        		ArrayList<String> errors = (ArrayList<String>) session.getAttribute("errorsReg");
        		if (!errors.isEmpty()) {
        			out.println(errors + "<br>");
        		}
        	}
        %>

        <input type="submit" value="register" class="btn btn-sm green" id="btn-login">

      </form>

      <p class="register-account-text">Already have an account? <a href="login.jsp" id="btn-register" class="btn btn-sm blue">login</a></p>

    </div>

  </main>

  <footer>
    &copy; 2020
  </footer>

</body>

</html>