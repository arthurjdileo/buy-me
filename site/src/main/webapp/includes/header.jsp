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
    <nav class="">
      <ul class="dropdown">
        <li class="list-top-level-item"><a href="">Shop by category</a>
          <ul class="list-content" id="">
            <% for (Category c : cat) { %>
            <li class=""><a href="listings.jsp?search-filters=category&search-query=<%= c.name %>"><%= c.name %></a>
              <ul class="sublist-content">
                <% for (SubCategory s : BuyMe.SubCategories.getByCategory(c.id)) { %>
                <li><a href="listings.jsp?search-filters=category&search-query=<%= s.name %>"><%= s.name %></a></li>
				<% } %>
              </ul>
            </li>
            <% } %>
          </ul>
        </li>
      </ul>
    </nav>
    <!-- end multidropdown -->
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