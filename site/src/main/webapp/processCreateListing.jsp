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
	int category = request.getParameter("category") != null && !request.getParameter("category").equals("other") ? Integer.parseInt(request.getParameter("category")) : -1;
	int subCategory = request.getParameter("sub-category") != null ? Integer.parseInt(request.getParameter("sub-category")) : -1;
	String categoryCustom = request.getParameter("category-custom");
	String subCategoryCustom = request.getParameter("sub-category-custom");
	if (categoryCustom == "") categoryCustom = null;
	if (categoryCustom != null) {
		category = BuyMe.Categories.insert(categoryCustom);
		subCategory = BuyMe.SubCategories.insert(subCategoryCustom, category);
	}
	

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
	if (categoryCustom == null) BuyMe.SetAlerts.categoryProcess(l);
	
	if (request.getParameter("edit") != null && Integer.parseInt(request.getParameter("edit")) == 1 && !u.account_uuid.equals(l.seller_uuid)) {
		Event e = new Event(u.account_uuid, "Edited Listing: '" + l.item_name + "'");
		BuyMe.Events.insert(e);
	}
	
	// redirect to listings page
	response.sendRedirect("listing-item.jsp?listingUUID=" + listingUUID);
%>