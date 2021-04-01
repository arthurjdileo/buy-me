<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%!
	public ArrayList<FAQ> filterFAQ(ArrayList<FAQ> faqs, String filter) {
		ArrayList<FAQ> filtered = new ArrayList<FAQ>();
		for (FAQ f: faqs) {
			if (f.question.toLowerCase().contains(filter.toLowerCase())) {
				filtered.add(f);
			}
		}
		return filtered;
	}

	public ArrayList<Question> filterQ(ArrayList<Question> userQ, String filter) {
		ArrayList<Question> filtered = new ArrayList<Question>();
		for (Question q: userQ) {
			if (q.question.toLowerCase().contains(filter.toLowerCase())) {
				filtered.add(q);
			}
		}
		return filtered;
	}
%>

<%
	Cookie[] cookies = request.getCookies();
	if (!BuyMe.Sessions.safetyCheck(cookies)) {
		response.sendRedirect("login.jsp");
		return;
	}
	User u = BuyMe.Sessions.getBySession(BuyMe.Sessions.getCurrentSession(cookies));
	
	ArrayList<FAQ> faqs = BuyMe.FAQs.getAsList();
	ArrayList<Question> userQ = BuyMe.Questions.getByUser(u.account_uuid);
	ArrayList<FAQ> filteredFAQ = faqs;
	ArrayList<Question> filteredQ = userQ;
	String faqFilter = request.getParameter("faq-filter");
	String qFilter = request.getParameter("q-filter");
	if (faqFilter != null) {
		filteredFAQ = filterFAQ(faqs, faqFilter);
	}
	if (qFilter != null) {
		filteredQ = filterQ(userQ, qFilter);
	}
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
  <link rel="apple-touch-icon" sizes="180x180" href="./apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="./favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="./favicon-16x16.png">
  <meta name="theme-color" content="#ffffff">
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
        <form action="#" class="search-form keyword-form">
          <div class="input-container">
            <label for="search-by-keyword">Search By Keyword </label>
            <div class="search-container">
              <input type="text" value="<%= faqFilter != null ? faqFilter : "" %>" name="faq-filter" placeholder="e.g. payments" class="search-input by-keyword">
              <input type="submit" value="Search" class="search-btn">
            </div>
          </div>
        </form>

        <div class="accordion-container">
          <% for (FAQ f : filteredFAQ) { %>
          <button class="accordion"><%= f.question %></button>
          <div class="panel">
            <p><%= f.answer %></p>
          </div>
          <% } %>
        </div>
      </article>

      <article class="faq-sub-container">
        <h2 class="title-center">My Questions Answered</h2>
        <form action="#" class="search-form keyword-form">
          <div class="input-container">
            <label for="search-by-keyword">Search By Keyword </label>
            <div class="search-container">
              <input type="text" value="<%= qFilter != null ? qFilter : "" %>" name="q-filter" placeholder="e.g. payments" class="search-input by-keyword">
              <input type="submit" value="Search" class="search-btn">
            </div>
          </div>
        </form>

        <div class="accordion-container">
         <% for (Question q : filteredQ) { %>
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