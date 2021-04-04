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
	if (!BuyMe.Admins.isAdmin(u.account_uuid) && !BuyMe.Admins.isMod(u.account_uuid)) {
		response.sendRedirect("index.jsp");
		return;
	}
	
	ArrayList<Question> questions = BuyMe.Questions.getUnanswered();
	ArrayList<User> users = BuyMe.Users.getAsList();
	ArrayList<User> sellers = BuyMe.TransactionHistory.getSellers();
	ArrayList<User> buyers = BuyMe.TransactionHistory.getBuyers();
	ArrayList<Listing> listings = BuyMe.Listings.getAsList();
	ArrayList<Transaction> transactions = BuyMe.TransactionHistory.getAsList();
	ArrayList<Category> categories = BuyMe.Categories.getAsList();
	ArrayList<SubCategory> subcategories = BuyMe.SubCategories.getAsList();
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
  <link rel="apple-touch-icon" sizes="180x180" href="./apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="./favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="./favicon-16x16.png">
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
        <% if (BuyMe.Admins.isAdmin(u.account_uuid)) { %>
        <button role="tab" class="listing-nav" id="generate-sales-report" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">total eanings</button>
        <button role="tab" class="listing-nav" id="earnings" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">earnings per</button>
        <button role="tab" class="listing-nav" id="best-selling-items" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">best selling items</button>
        <button role="tab" class="listing-nav" id="best-buyers" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">best buyers</button>
        <% } %>
        <button role="tab" class="listing-nav" id="q-a" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">customer service questions</button>
        <button role="tab" class="listing-nav" id="user-management" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">user management</button>
        <button role="tab" class="listing-nav" id="listing-management" aria-selected="false"><img src="./img/menu.svg" alt="" class="listing-nav-icon">listing management</button>

        <a href="logout.jsp" class="btn btn-sm blue listing-nav" id="signout-btn">Sign Out</a>
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
              <% if (BuyMe.Admins.isAdmin(u.account_uuid)) { %>
              <div class="input-group">
              	<label for="isMod" class="input-label">Moderator?</label>
              	<input hidden name="isMod" value="false" id="isMod">
              	<input type="checkbox" value="true" class="input-field" name="isMod" id="isMod">
              </div>
              <% } %>
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
            <!-- <button class="btn btn-sm btn-confirm">generate total earnings</button> -->

            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th total-column"></th>
                <th class="listing-table__th">item name</th>
                <th class="listing-table__th">sell price</th>
                <th class="listing-table__th"></th>
              </thead>
              <tbody class="listing-table__body">
                <% double sum = 0; %>
                <% for (Transaction t : transactions) { %>
                <% Listing l = BuyMe.Listings.get(t.listing_uuid); %>
                <% sum = sum + t.amount; %>
                <tr class="listing-table__tr">
                  <td class="total-column"></td>
                  <td class="listing-table__td"><%= l.item_name %></td>
                  <td class="listing-table__td sell-price-column"><%= t.amount %></td>
                  <td class="listing-table__td">
                    <button class="btn btn-sm blue" onclick="window.location.href = 'listing-item.jsp?sold=1&listingUUID=<%= l.listing_uuid %>';">view listing</button>
                  </td>
                </tr>
                <% } %>
                <!-- last row should be like this one -->
                <tr class="listing-table__tr">
                  <td class="total-column total-row">Total</td>
                  <td class="listing-table__td total-row"></td>
                  <td class="listing-table__td total-row sell-price-column total-price-cell"><%= sum %></td>
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
<%--             <form action="admin.jsp" class="in-form">
              <input type="submit" class="btn btn-sm btn-confirm" value="Generate">
              <div class="input-group">
                <label for="search-filters" class="select-label">by: </label>
                <select id="search-filters" onchange="updateInput(this);" name="search-filters" class="">
                  <option value="category">Category</option>
                  <option value="sub-category">Sub Category</option>
                  <option value="item">Item</option>
                  <option value="buyer">Buyer</option>
                  <option value="seller">Seller</option>
                </select>
                <input type="text" id="earningInput" name="earningInput" style="display: none;"></input>
                <select id="categories" name="category">
                	<% for (Category c : categories) { %>
                		<option value="<%= c.id %>"><%= c.name %></option>
                	<% } %>
                </select>
                <select id="sub-categories" name="sub-category" style="display: none;">
                	<% for (SubCategory sc : subcategories) { %>
                		<option value="<%= sc.id %>"><%= sc.name %></option>
                	<% } %>
                </select>

              </div>

            </form> --%>
          </section>
          <section class="listing-panel">
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">Category</th>
                <th class="listing-table__th">amount</th>
              </thead>
              <tbody class="listing-table__body">
                <% for (Category c : categories) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><%= c.name %></td>
                  <td class="listing-table__td sell-price-column"><%= BuyMe.TransactionHistory.earningsByCategory(c.id) %></td>
                </tr>
                <% } %>
              </tbody>
            </table>
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">Sub Category</th>
                <th class="listing-table__th">amount</th>
              </thead>
              <tbody class="listing-table__body">
                <% for (SubCategory sc : subcategories) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><%= sc.name %></td>
                  <td class="listing-table__td sell-price-column"><%= BuyMe.TransactionHistory.earningsBySubCategory(sc.id) %></td>
                </tr>
                <% } %>
              </tbody>
            </table>
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">Seller</th>
                <th class="listing-table__th">amount</th>
              </thead>
              <tbody class="listing-table__body">
                <% for (User seller : sellers) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><%= seller.toString() %></td>
                  <td class="listing-table__td sell-price-column"><%= BuyMe.TransactionHistory.earningsBySeller(seller.account_uuid) %></td>
                </tr>
                <% } %>
              </tbody>
            </table>
            
            <table class="listing-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">Item</th>
                <th class="listing-table__th">amount</th>
              </thead>
              <tbody class="listing-table__body">
                <% for (Transaction t : transactions) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><%= BuyMe.Listings.get(t.listing_uuid).item_name %></td>
                  <td class="listing-table__td sell-price-column"><%= t.amount %></td>
                </tr>
                <% } %>
              </tbody>
            </table>

          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="best-selling-items" hidden>
          <h2>Best selling items panel</h2>
          <section class="listing-panel">
            <table class="listing-table" id="best-sold">
              <thead class="listing-table__head">
              <tr>
                <th class="listing-table__th" colspan="2">Best Sold By Price</th></tr>
                <tr>
                <th class="listing-table__th">Item name</th>
                <th class="listing-table__th">Price</th></tr>
              </thead>
              <tbody class="listing-table__body">
                <% for (Transaction t : transactions) { %>
                <% Listing l = BuyMe.Listings.get(t.listing_uuid); %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><%= l.item_name %></td>
                  <td class="listing-table__td"><%= t.amount %></td>
                </tr>
                <% } %>
              </tbody>
            </table>
            <table class="listing-table" id="best-bid">
              <thead class="listing-table__head">
                <tr><th class="listing-table__th" colspan="2">Hottest Listings</th></tr>
                <tr><th class="listing-table__th">Item name</th>
                <th class="listing-table__th">Num. Bids</th></tr>
              </thead>
              <tbody class="listing-table__body">
                <% for (Listing l : listings) { %>
                <% ArrayList<Bid> bids = BuyMe.Bids.getBidsByListing(l.listing_uuid); %>
                <% if (l.is_active == 1 && bids.size() > 0) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><%= l.item_name %></td>
                  <td class="listing-table__td"><%= bids.size() %></td>
                </tr>
                <% } %>
                <% } %>
              </tbody>
            </table>
          </section>
        </div>
        <!--end panel-->

        <div class="" role="tabpanel" aria-labelledby="best-buyers" hidden>
          <h2>Best Buyers</h2>
          <section class="listing-panel">
            <table class="listing-table" id="best-buyer-table">
              <thead class="listing-table__head">
                <th class="listing-table__th">Name</th>
                <th class="listing-table__th">Total Amount Spent</th>
              </thead>
              <tbody class="listing-table__body">
                <% for (User bu : buyers) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><%= bu.toString() %></td>
                  <td class="listing-table__td"><%= BuyMe.TransactionHistory.earningsByBuyer(bu.account_uuid) %></td>
                </tr>
                <% } %>
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
                  <td class="listing-table__td question-cell" data-q-id="<%= q.question_uuid %>"><%= q.question %></td>
                  <td class="listing-table__td"><span class="customer-question-date"><%= q.created %></span></td>
                  <td class="listing-table__td">
                    <button class="btn btn-sm blue cardbutton">Answer question</button>
                  </td>
                  <td class="listing-table__td">
                    <form action="dismissQuestion.jsp">
                        <input hidden name="question_uuid" value="<%= q.question_uuid %>"></input>
                    	<button class="btn btn-sm danger">Dismiss question</button>
                    </form>
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
                <th class="listing-table__th">Admin Role</th>
                <th class="listing-table__th">edit </th>
                <th class="listing-table__th">delete </th>
              </thead>
              <tbody class="listing-table__body">
 				<% for (User user : users) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><%= user.firstName %></td>
                  <td class="listing-table__td"><%= user.lastName %></td>
                  <td class="listing-table__td"><%= user.email %></td>
                  <td class="listing-table__td"><%= BuyMe.Admins.isAdmin(user.account_uuid) || BuyMe.Admins.isMod(user.account_uuid) ? BuyMe.Admins.getRole(user. account_uuid) : "N/A" %></td>
                  <td class="listing-table__td">
                    <% if ((BuyMe.Admins.isAdmin(u.account_uuid) && !BuyMe.Admins.isAdmin(user.account_uuid)) || (BuyMe.Admins.isMod(u.account_uuid) && !BuyMe.Admins.isAdmin(user.account_uuid) && !BuyMe.Admins.isMod(user.account_uuid))) { %>
                    <form action="edit-user.jsp">
                    <input hidden name="acc_uuid" value="<%= user.account_uuid %>"></input>
                    <button type="submit" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                    </form>
                    <% } %>
                  </td>
                  <td class="listing-table__td">
                    <% if ((BuyMe.Admins.isAdmin(u.account_uuid) && !BuyMe.Admins.isAdmin(user.account_uuid)) || (BuyMe.Admins.isMod(u.account_uuid) && !BuyMe.Admins.isAdmin(user.account_uuid) && !BuyMe.Admins.isMod(user.account_uuid))) { %>
                    <button type="button" name="button" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                    <% } %>
                  </td>
                </tr>
                <% } %>
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
                <% for (Listing l : listings) { %>
                <tr class="listing-table__tr">
                  <td class="listing-table__td"><%= l.item_name %></td>
                  <td class="listing-table__td sell-price-column">$<%= BuyMe.Listings.getCurrentPrice(l) %></td>
                  <td class="listing-table__td ">
                    <form action="create-listing.jsp?edit=1">
                    <input hidden name="listingUUID" value="<%= l.listing_uuid %>"></input>
                    <input hidden name="edit" value="1"></input>
                    <button type="submit" class="btn btn-sm bg-caution">
                      Edit
                    </button>
                    </form>
                  </td>
                  <td class="listing-table__td">
                    <form action="deleteListing.jsp">
                    <input hidden name="listingUUID" value="<%= l.listing_uuid %>"></input>
                    <input hidden name="from-admin" value="true"></input>
                    <button type="submit" class="btn btn-sm bg-danger">
                      Delete
                    </button>
                    </form>
                  </td>
                </tr>
                <% } %>
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
    function sortTable(table_name, index, skip) {
  	  var table, rows, switching, i, x, y, shouldSwitch;
  	  table = document.getElementById(table_name);
  	  switching = true;
  	  /*Make a loop that will continue until
  	  no switching has been done:*/
  	  while (switching) {
  	    //start by saying: no switching is done:
  	    switching = false;
  	    rows = table.rows;
  	    /*Loop through all table rows (except the
  	    first, which contains table headers):*/
  	    for (i = (1+skip); i < (rows.length - 1); i++) {
  	      //start by saying there should be no switching:
  	      shouldSwitch = false;
  	      /*Get the two elements you want to compare,
  	      one from current row and one from the next:*/
  	      x = rows[i].getElementsByTagName("TD")[index];
  	      y = rows[i + 1].getElementsByTagName("TD")[index];
  	      //check if the two rows should switch place:
  	      if (Number(x.innerHTML) < Number(y.innerHTML)) {
  	        //if so, mark as a switch and break the loop:
  	        shouldSwitch = true;
  	        break;
  	      }
  	    }
  	    if (shouldSwitch) {
  	      /*If a switch has been marked, make the switch
  	      and mark that a switch has been done:*/
  	      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
  	      switching = true;
  	    }
  	  }
  	}
  sortTable("best-buyer-table", 1, 0);
  sortTable("best-sold", 1, 1);
  sortTable("best-bid", 1, 1);
/*     let categories = document.getElementById("categories");
	let subcategories = document.getElementById("sub-categories");
	let earnings = document.getElementById("earningInput");
    
    function updateInput(event) {
     	if (event.value == 'category') {
    		categories.style.display = "inline-block";
    		subcategories.style.display = "none";
    		earnings.style.display = "none";
    	} else if (event.value == 'sub-category') {
    		categories.style.display = "none";
    		subcategories.style.display = "inline-block";
    		earnings.style.display = "none";
    	} else {
    		categories.style.display = "none";
    		subcategories.style.display = "none";
    		earnings.style.display = "inline-block";
    	}
    } */

    function handleQuestionAnswer(event) {
      const button = event.currentTarget;
      // get the question and id
      const questionId = button.parentElement.parentElement.children[0].getAttribute('data-q-id');
      const question = button.parentElement.parentElement.children[0].textContent;

      modalInner.innerHTML = `
      <form action="answerQuestion.jsp" class="card modal-form">
        <h2>Answer question: </h2>
          <p>` + question + `</p>
          <textarea name="answer" id="answer" placeholder="Answer here..." cols="20" class="answer-area"></textarea>
          <input hidden name="question_uuid" value="` +  questionId + `"></input>
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
