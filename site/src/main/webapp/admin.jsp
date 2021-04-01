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
	
	ArrayList<Question> questions = BuyMe.Questions.getUnanswered();
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
  <link rel="stylesheet" href="./css/admin.css">

  <title>BuyMe - Admin</title>
</head>

<body>
  <%@include file="./includes/header.jsp" %>
  <main class="main-content">
    <div class="tabs">
      <div class="listing-nav-container" role="tablist" aria-label="profile list">
        <picture class="user-profile-img-container">
          <img src="img/user.png" alt="" class="user-profile-img">
          <p class="user-profile-name"><%= u.toString() %></p>
          <p class="user-profile-name">[<%= BuyMe.Admins.getRole(u.account_uuid) %>]</p>
          <p class="user-profile-email"><%= u.email %></p>
        </picture>
        <button role="tab" class="listing-nav" id="create-account" aria-selected="true"><img src="./img/menu.svg" alt="" class="listing-nav-icon">create account</button>
        <button role="tab" class="listing-nav" id="generate-sales-report" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">total eanings</button>
        <button role="tab" class="listing-nav" id="earnings" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">earnings per</button>
        <button role="tab" class="listing-nav" id="best-selling-items" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">best selling items</button>
        <button role="tab" class="listing-nav" id="best-buyers" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">best buyers</button>
        <button role="tab" class="listing-nav" id="q-a" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">customer service questions</button>
        <button role="tab" class="listing-nav" id="user-management" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">user management</button>
        <button role="tab" class="listing-nav" id="listing-management" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">listing management</button>

        <a href="/signout.html" class="btn btn-sm blue in-block" id="signout-btn">signout</a>
      </div> <!-- end side navigation-->

      <div class="panels-container">
        <div class="" role="tabpanel" aria-labelledby="create-account" id="create-acount">
          <h2>create account panel</h2>
          <section class="listing-panel">
            <form action="registerValidation.jsp" class="listing-form">
              <div class="input-group">
                <label for="first-name" class="input-label">first name </label>
                <input type="text" class="input-field" name="fname" id="first-name">
              </div>
              <div class="input-group">
                <label for="last-name" class="input-label">last name </label>
                <input type="text" class="input-field" name="lname" id="last-name">
              </div>
              <div class="input-group">
                <label for="email" class="input-label">email </label>
                <input type="email" class="input-field" name="email" id="email">
              </div>
              <div class="input-group">
                <label for="password" class="input-label">password </label>
                <input type="password" class="input-field" name="password" id="password">
                <input hidden name="from-admin" value="true"></input>
              </div>
              <div class="input-group flex-end">
                <input type="submit" value="create" class="btn btn-sm green btn-confirm">
              </div>
              <%
				if (session.getAttribute("errorsRegAdmin") != null) {
					ArrayList<String> errors = (ArrayList<String>) session.getAttribute("errorsRegAdmin");
					if (!errors.isEmpty()) {
						out.println(errors + "<br>");
					}
				}
              %>
            </form>

          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="generate-sales-report" hidden id="generate-sales-report">
          <h2>Total earnings report panel</h2>
          <section class="listing-panel generate-sales-panel">
            <button class="btn btn-sm btn-confirm">generate total earnings</button>

            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th total-column"></th>
                <th class="listing-table__th">item name</th>
                <th class="listing-table__th">sell price</th>
                <th class="listing-table__th"></th>
              </thead>
              <tbody class="listing-table__body">
                <tr class="listing-table__tr">
                  <td class="total-column"></td>
                  <td class="listing-table__td">item 1</td>
                  <td class="listing-table__td sell-price-column">100</td>
                  <td class="listing-table__td">
                    <button class="btn btn-sm blue">view listing</button>
                  </td>
                </tr>
                <tr class="listing-table__tr">
                  <td class="total-column"></td>
                  <td class="listing-table__td">item 2</td>
                  <td class="listing-table__td sell-price-column">500</td>
                  <td class="listing-table__td">
                    <button class="btn btn-sm blue">view listing</button>
                  </td>
                </tr>
                <!-- last row should be like this one -->
                <tr class="listing-table__tr">
                  <td class="total-column total-row">Total</td>
                  <td class="listing-table__td total-row"></td>
                  <td class="listing-table__td total-row sell-price-column total-price-cell">600</td>
                  <td class="listing-table__td total-row">
                  </td>
                </tr>
              </tbody>
            </table>
          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="earnings" hidden>
          <h2>earnings per panel</h2>
          <section class="generate-earnings">
            <form action="" class="in-form">
              <input type="submit" class="btn btn-sm btn-confirm" value="Generate">
              <div class="input-group">
                <label for="search-filters" class="select-label">by: </label>
                <select id="search-filters" name="search-filters" class="">
                  <option value="category">Category</option>
                  <option value="item">Item</option>
                  <option value="user">User</option>
                </select>
                <input type="text">

              </div>

            </form>
          </section>
          <section class="listing-panel">
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">earnings per</th>
                <th class="listing-table__th">amount</th>
              </thead>
              <tbody class="listing-table__body">
                <tr class="listing-table__tr">
                  <td class="listing-table__td">item</td>
                  <td class="listing-table__td sell-price-column">
                    10
                  </td>
                </tr>
                <tr class="listing-table__tr">
                  <td class="listing-table__td">item type</td>
                  <td class="listing-table__td sell-price-column">
                    1
                  </td>
                </tr>
                <tr class="listing-table__tr">
                  <td class="listing-table__td">end user</td>
                  <td class="listing-table__td sell-price-column">0</td>
                </tr>
                <tr class="listing-table__tr">
                  <td class="listing-table__td">total</td>
                  <td class="listing-table__td sell-price-column">$$$222</td>
                </tr>
              </tbody>
            </table>

          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="best-selling-items" hidden>
          <h2>Best selling items panel</h2>
          <section class="listing-panel">
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">Ranking</th>
                <th class="listing-table__th">Item name</th>
              </thead>
              <tbody class="listing-table__body">
                <tr class="listing-table__tr">
                  <td class="listing-table__td">1</td>
                  <td class="listing-table__td">Toaster</td>
                </tr>
                <tr class="listing-table__tr">
                  <td class="listing-table__td">2</td>
                  <td class="listing-table__td">tomato</td>
                </tr>
              </tbody>
            </table>
          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="best-buyers" hidden>
          <h2>Best selling items panel</h2>
          <section class="listing-panel">
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">ranking</th>
                <th class="listing-table__th">email</th>
              </thead>
              <tbody class="listing-table__body">
                <tr class="listing-table__tr">
                  <td class="listing-table__td">1</td>
                  <td class="listing-table__td">john@mail.com</td>
                </tr>
                <tr class="listing-table__tr">
                  <td class="listing-table__td">2</td>
                  <td class="listing-table__td">jane@mail.org</td>
                </tr>
              </tbody>
            </table>
          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="q-a" hidden>
          <h2>Customer service questions panel</h2>
          <section class="listing-panel">
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">question</th>
                <th class="listing-table__th">date</th>
                <th class="listing-table__th">answer</th>
                <th class="listing-table__th">reject</th>
              </thead>
              <tbody class="listing-table__body">
                <% for (Question q : questions) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td question-cell" data-q-id="1"><%= q.question %></td>
                  <td class="listing-table__td"><span class="customer-question-date"><%= q.created %></span></td>
                  <td class="listing-table__td">
                    <button class="btn btn-sm blue cardbutton">Answer question</button>
                  </td>
                  <td class="listing-table__td">
                    <button class="btn btn-sm danger" onclick="dismissQuestion('<%= q.question_uuid %>');">Dismiss question</button>
                  </td>
                </tr>
                <% } %>
              </tbody>
            </table>
          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="user-management" hidden>
          <h2>user management panel</h2>
          <section class="listing-panel">
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">first name</th>
                <th class="listing-table__th">last name</th>
                <th class="listing-table__th">email</th>
                <th class="listing-table__th">edit </th>
                <th class="listing-table__th">delete </th>
              </thead>
              <tbody class="listing-table__body">
                <tr class="listing-table__tr">
                  <td class="listing-table__td">john</td>
                  <td class="listing-table__td">johnson</td>
                  <td class="listing-table__td">john@mail.com</td>
                  <td class="listing-table__td ">
                    <button type="button" name="button" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                  </td>
                  <td>
                    <button type="button" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="listing-management" hidden>
          <h2>listing management panel</h2>

          <section class="listing-panel">
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">product name</th>
                <th class="listing-table__th">price</th>
                <th class="listing-table__th">edit </th>
                <th class="listing-table__th">delete </th>
              </thead>
              <tbody class="listing-table__body">
                <tr class="listing-table__tr">
                  <td class="listing-table__td">Card Boxes</td>
                  <td class="listing-table__td sell-price-column">0.55</td>
                  <td class="listing-table__td ">
                    <button type="button" name="button" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                  </td>
                  <td>
                    <button type="button" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                  </td>
                </tr>

                <tr class="listing-table__tr">
                  <td class="listing-table__td">Pencil</td>
                  <td class="listing-table__td sell-price-column">10.00</td>
                  <td class="listing-table__td ">
                    <button type="button" name="button" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                  </td>
                  <td>
                    <button type="button" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </section>
        </div>
        <!--end panel-->

      </div>
      <!-- end panels container-->

    </div>
    <!--end tabs -->

  </main>
  <footer>
    &copy; 2020
  </footer>

  <!-- modal -->
  <div class="modal-outer">
    <div class="modal-inner">
      <h3>modal title</h3>
    </div>
  </div>



  <script src="js/tabs.js"></script>


  <script type="text/javascript">
    // get elements
    const cardButtons = document.querySelectorAll('.cardbutton');
    const modalInner = document.querySelector('.modal-inner');
    const modalOuter = document.querySelector('.modal-outer');
    
    function dismissQuestion(question_uuid) {
    	
    }

    function handleQuestionAnswer(event) {
      const button = event.currentTarget;
      // get the question and id
      const questionId = button.parentElement.parentElement.children[0].getAttribute('data-q-id');
      const question = button.parentElement.parentElement.children[0].textContent;

      modalInner.innerHTML = `
      <form action="" class="card modal-form">
        <h2>Answer question: </h2>
          <p>${question}</p>
          <label for="answer">Your answer:</label>
          <textarea name="answer" id="answer" cols="20" class="answer-area"></textarea>
          <input type="hidden"  value=${questionId} name="question-id"/>
        <input type="submit" value="Answer question" class='btn btn-sm btn-confirm'>
      </form>
      `;

      // show the modal
      modalOuter.classList.add('open');
    }
    cardButtons.forEach((button) => {
      button.addEventListener('click', handleQuestionAnswer);
    });

    function closeModal() {
      modalOuter.classList.remove('open');
    }

    modalOuter.addEventListener('click', function(event) {
      const isOutsise = !event.target.closest('.modal-inner');
      if (isOutsise) {
        modalOuter.classList.remove('open');
      }
    })


    window.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') {
        closeModal();
      }
    })
  </script>

  <script src="./js/hash-url.js"></script>

</body>

</html>
