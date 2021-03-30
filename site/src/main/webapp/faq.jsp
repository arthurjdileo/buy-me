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
	
	ArrayList<FAQ> faqs = BuyMe.FAQs.getAsList();
	ArrayList<Question> userQ = BuyMe.Questions.getByUser(u.account_uuid);
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
  <link rel="stylesheet" href="./css/faq.css">
  <title>BuyMe - FAQ</title>
</head>

<body>
  <%@include file="./includes/header.jsp" %>
  <main class="main-content">
    <section class="ask-question-container">
      <h2 class="title-center">Ask your question</h2>
      <form action="askQuestion.jsp" class="question-form">
        <div class="input-container">
          <label for="question-body">What do you want to know?
          </label>
          <textarea name="question-body" rows="8" cols="" id="question-body" placeholder="I want to know..."></textarea>
        </div>
        <input type="submit" value="Ask question" class="btn btn-sm blue" id="ask-submit-btn">
      </form>

      <!-- <ul class="previous-questions-list">
        <li class="previous-questions-list__item">a</li>
        <li class="previous-questions-list__item">b</li>
        <li class="previous-questions-list__item">c</li>
      </ul> -->
    </section>
    <section class="faq-container">
      <article class="faq-sub-container">
        <h2 class="title-center">Frequently Asked Questions</h2>
        <form action="" class="search-form keyword-form">
          <div class="input-container">
            <label for="search-by-keyword">Search by keyword </label>
            <div class="search-container">
              <input type="text" placeholder="e.g. payments" class="search-input by-keyword">
              <input type="submit" value="Search" class="search-btn">
            </div>
          </div>
        </form>

        <div class="accordion-container">
          <% for (FAQ f : faqs) { %>
          <button class="accordion"><%= f.question %></button>
          <div class="panel">
            <p><%= f.answer %></p>
          </div>
          <% } %>
        </div>
      </article>

      <article class="faq-sub-container">
        <h2 class="title-center">My Questions Answered</h2>
        <form action="" class="search-form keyword-form">
          <div class="input-container">
            <label for="search-by-keyword">Search by keyword </label>
            <div class="search-container">
              <input type="text" placeholder="e.g. payments" class="search-input by-keyword">
              <input type="submit" value="Search" class="search-btn">
            </div>
          </div>
        </form>

        <div class="accordion-container">
          <% for (Question q : userQ) { %>
          <button class="accordion"><%= q.question %></button>
          <div class="panel">
            <p><%= q.answer == null ? "This question is still being answered..." : q.answer %></p>
          </div>
          <% } %>
        </div>
      </article>

    </section>

  </main>

  <footer>
    &copy; 2020
  </footer>


  <script src="./js/faq.js"></script>

</body>

</html>