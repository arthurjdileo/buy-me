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
  <link rel="stylesheet" href="./css/slider.css">
  <title>home</title>
</head>

<body>
  <%@include file="./includes/header.jsp" %>
  <main class="main-content">
    <div id="sell-your-item">
      <a href="create-listing.jsp" class="btn" id="sell-your-item-btn">Sell Your Item</a>
    </div>
    <h2 class="title-center mb-medium user-greeting">Welcome <span class="user-name"><%= u.firstName %>!</span></h2>
    <h2 class="listing-title"><a href="#">Categories</a></h2>

    <div id="categoriesSlider" class="slider">
      <!-- Give wrapper ID to target with jQuery & CSS -->
      <section class="MS-content product-listing">
        <article class="product-container item">
          <a href="#sports">
            <h3 class="category-title">sports</h3>
            <img src="./img/volleyball.png" alt="" class="category-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="#real-estate">
            <h3 class="category-title">clothing</h3>
            <img src="./img/tshirt.png" alt="" class="category-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="#vehicles">
            <h3 class="category-title">vehicles</h3>
            <img src="./img/car.png" alt="" class="category-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="#jewelry">
            <h3 class="category-title">jewelry</h3>
            <img src="./img/diamond.png" alt="" class="category-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="#electronics">
            <h3 class="category-title">electronics</h3>
            <img src="./img/desktop.png" alt="" class="category-img">
          </a>
        </article>
      </section>

      <div class="MS-controls">
        <button class="MS-left">
          <img src="./img/left-arrow.svg" alt="" class="slider-arrow-img" />
        </button>
        <button class="MS-right">
          <img src="./img/right-arrow.svg" alt="" class="slider-arrow-img" />
        </button>
      </div>
    </div> <!-- end multislider-->


    <h2 class="listing-title"><a href="listing.html">Recent listing</a></h2>

    <div id="exampleSlider" class="slider">
      <!-- Give wrapper ID to target with jQuery & CSS -->
      <section class="MS-content product-listing">
        <article class="product-container item">
          <a href="./listing-item.html">
            <h3 class="product-title">product</h3>
            <img src="https://picsum.photos/id/119/200" alt="" class="product-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="./listing-item.html">
            <h3 class="product-title">product</h3>
            <img src="https://picsum.photos/id/119/200" alt="" class="product-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="./listing-item.html">
            <h3 class="product-title">product</h3>
            <img src="https://picsum.photos/id/119/200" alt="" class="product-img">
          </a>
        </article>
        <article class="product-container item">
          <a href="./listing-item.html"></a>
          <h3 class="product-title">product</h3>
          <img src="https://picsum.photos/id/119/200" alt="" class="product-img">
        </article>
        <article class="product-container item">
          <a href="./listing-item.html">
            <h3 class="product-title">product</h3>
            <img src="https://picsum.photos/id/119/200" alt="" class="product-img">
          </a>
        </article>
      </section>

      <div class="MS-controls">
        <button class="MS-left">
          <img src="./img/left-arrow.svg" alt="" class="slider-arrow-img" />
        </button>
        <button class="MS-right">
          <img src="./img/right-arrow.svg" alt="" class="slider-arrow-img" />
        </button>
      </div>
    </div> <!-- end multislider-->
  </main>
  <footer>
    &copy; 2020
  </footer>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="./js/multislider.min.js"></script>
  <script src="./js/initialize-slider.js"></script>
</body>

</html>