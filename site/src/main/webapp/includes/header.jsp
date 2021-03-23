<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	ArrayList<Category> cat = BuyMe.Categories.getAsList();
%>

  <header class="main-header">
    <div class="logo-container">
      <a href="index.jsp"><img src="./img/logo.png" alt=" "></a>
    </div>
    <nav class="top-nav">
      <p id="show-list-on-hover" class="">Shop By Category</p>
      <ul class="list-content" id="categories">
      <% for (Category c : cat) { %>
        <li class=""><a href="listings.jsp?search-filters=category&search-query=<%= c.name %>"><%= c.name %></a></li>
      <% } %>
      </ul>
    </nav>
    <form action="listings.jsp" class="search-form">
      <div class="search-input-container">
        <input type="text" placeholder="Search" name="search-query" class="search-input">
        <label for="search-filters" class="select-label">Filter by: </label>
        <select id="search-filters" name="search-filters" class="search-filters-select">
          <option value="item">Item</option>
          <option value="category">Category</option>
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