<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;500;700&display=swap" rel="stylesheet"> 
  <link rel="stylesheet" href="./css/base.css">
  <link rel="stylesheet" href="./css/login.css">
  <title>BuyMe - Login</title>
</head>

<body>

  <header class="main-header">
    <div class="logo-container">
      <a href="index.jsp"><img src="./img/logo.png" alt=" "></a>
    </div>
    <h1 class="title-center register-title">Login </h1>
  </header>

  <main class="main-content">

    <div class="login-container">

      <form action="loginValidation.jsp" class="login-form">

        <div class="input-group">
          <label for="email" class="input-label">email </label>
          <input type="email" class="input-field" name="email" placeholder="e.g. john@mail.com" id="email" required>
        </div>

        <div class="input-group">
          <label for="password" class="input-label">password </label>
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
        	if (session.getAttribute("errors") != null) {
        		ArrayList<String> errors = (ArrayList<String>) session.getAttribute("errors");
        		if (!errors.isEmpty()) {
        			out.println(errors + "<br>");
        		}
        	}
        %>

        <input type="submit" value="login" class="btn btn-sm blue" id="btn-login">

      </form>

      <p class="register-account-text">Don't have an account? <a href="register.jsp" id="btn-register" class="btn btn-sm green">register</a></p>

    </div>
  </main>
  <footer>
    &copy; 2020
  </footer>

</body>

</html>