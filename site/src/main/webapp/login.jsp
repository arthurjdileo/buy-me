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
      <h1 class="title-center register-title">Login </h1>
    </header>

    <main class="main-content">

      <div class="login-container">

        <form action="#" class="login-form">

          <div class="input-group">
            <label for="email" class="input-label">email </label>
            <input type="email" class="input-field" name="email" placeholder="e.g. john@mail.com" id="email" required>
          </div>

          <div class="input-group">
            <label for="password" class="input-label">password </label>
            <input type="password" class="input-field" name="password" placeholder="Your secret password" id="password" required>
          </div>

          <input type="submit" value="login" class="btn btn-sm blue" id="btn-login">

        </form>

        <p class="register-account-text">Don't have an account? <a href="register.html" id="btn-register" class="btn btn-sm green">register</a></p>

      </div>
    </main>
    <footer>
      &copy; 2020
    </footer>

  </body>
</html>