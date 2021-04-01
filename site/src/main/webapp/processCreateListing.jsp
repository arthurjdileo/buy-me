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
	String product = request.getParameter("product");
	for (String s : request.getParameterValues("category")) {
		System.out.println(s);
	}
	return;
/* 	//int category = Integer.parseInt(request.getParameter("category"));
	int subCategory = Integer.parseInt(request.getParameter("sub-category"));
	String description = request.getParameter("description");
	int numDays = Integer.parseInt(request.getParameter("num-days"));
	String imgURL = request.getParameter("image-link");
	double startPrice = Double.parseDouble(request.getParameter("price"));
	double reservePrice = -1;
	if (request.getParameter("reserve-price") != "") {
		reservePrice = Double.parseDouble(request.getParameter("reserve-price"));
	}
	double bidIncrement = Double.parseDouble(request.getParameter("bid-increment"));
	String currency = request.getParameter("currency");

	Calendar c = Calendar.getInstance();
	c.add(Calendar.DATE, numDays);
	java.sql.Timestamp endDate = new java.sql.Timestamp(c.getTimeInMillis());

	String listingUUID;
	if (request.getParameter("edit") != null && Integer.parseInt(request.getParameter("edit")) == 1) {
		Listing l = BuyMe.Listings.get(request.getParameter("listingUUID"));
		if (!l.seller_uuid.equals(u.account_uuid) && !BuyMe.Admins.isAdmin(u.account_uuid) && !BuyMe.Admins.isMod(u.account_uuid)) {
			response.sendRedirect("index.jsp");
			return;
		}
		listingUUID = l.listing_uuid;
	} else {
		listingUUID = BuyMe.genUUID();
	}
	Listing l = new Listing(listingUUID, u.account_uuid, category,
			subCategory, description, product, imgURL, numDays,
			currency, startPrice, reservePrice,
			endDate, bidIncrement, 1);

	BuyMe.Listings.insert(l);
	BuyMe.SetAlerts.categoryProcess(l);
	
	// redirect to listings page
	response.sendRedirect("listing-item.jsp?listingUUID=" + listingUUID); */
%>