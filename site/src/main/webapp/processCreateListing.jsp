<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="me.arthurdileo.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="com.google.cloud.storage.*,java.nio.file.Files,java.nio.file.Paths" %>

<%
	Cookie[] cookies = request.getCookies();
	if (!BuyMe.Sessions.safetyCheck(cookies)) {
		response.sendRedirect("login.jsp");
		return;
	}
	User u = BuyMe.Sessions.getBySession(BuyMe.Sessions.getCurrentSession(cookies));
	
	String product = null;
	String categoryStr = null;
	int category;
	String subCategoryStr = null;
	int subCategory;
	String categoryCustom = null;
	String subCategoryCustom = null;
	String description = null;
	String numDaysStr = null;
	int numDays;
	String itemCondition = null;
	String startPriceStr = null;
	double startPrice;
	String reservePriceStr = null;
	double reservePrice;
	String bidIncrementStr = null;
	double bidIncrement;
	String currency = null;
	java.sql.Timestamp endDate;
	String edit = null;
	String listingUUIDPassed = null;
	String listingUUID = BuyMe.genUUID();
	FileItem storedFile = null;
	
	File file ;
	String ext = null;
	String projectId = "arthurdileo-me";
	String bucketName = "buy_me_images";
	Storage storage = StorageOptions.newBuilder().setProjectId(projectId).build().getService();
	int maxFileSize = 5000 * 1024;
	int maxMemSize = 5000 * 1024;
	ServletContext context = pageContext.getServletContext();
	String filePath = "./";
	// Verify the content type
	String contentType = request.getContentType();
   
	DiskFileItemFactory factory = new DiskFileItemFactory();
	// maximum size that will be stored in memory
	factory.setSizeThreshold(maxMemSize);

	// Create a new file upload handler
	ServletFileUpload upload = new ServletFileUpload(factory);
	
	// maximum file size to be uploaded.
	upload.setSizeMax( maxFileSize );
	
	try { 
		 // Parse the request to get file items.
		 List fileItems = upload.parseRequest(request);

		 // Process the uploaded file items
		 Iterator i = fileItems.iterator();

		 while ( i.hasNext () ) {
			FileItem fi = (FileItem)i.next();
			if ( !fi.isFormField () ) {
			  if (fi.getName().equals("")) continue;
			 // Get the uploaded file parameters
			 String fieldName = fi.getFieldName();
			 String fileName = fi.getName();
			 boolean isInMemory = fi.isInMemory();
			 long sizeInBytes = fi.getSize();
			 storedFile = fi;
			 ext = BuyMe.getExt(fileName);
			} else {
				String name = fi.getFieldName();
				String val = fi.getString();
				if (name.equalsIgnoreCase("product")) {
					product = val;
				} else if (name.equalsIgnoreCase("description")) {
					description = val;
				} else if (name.equalsIgnoreCase("num-days")) {
					numDaysStr = val;
				} else if (name.equalsIgnoreCase("price")) {
					startPriceStr = val;
				} else if (name.equalsIgnoreCase("reserve-price")) {
					reservePriceStr = val;
				} else if (name.equalsIgnoreCase("bid-increment")) {
					bidIncrementStr = val;
				} else if (name.equalsIgnoreCase("currency")) {
					currency = val;
				} else if (name.equalsIgnoreCase("category")) {
					categoryStr = val;
				} else if (name.equalsIgnoreCase("sub-category")) {
					subCategoryStr = val;
				} else if (name.equalsIgnoreCase("category-custom")) {
					categoryCustom = val;
				} else if (name.equalsIgnoreCase("sub-category-custom")) {
					subCategoryCustom = val;
				} else if (name.equalsIgnoreCase("edit")) {
					edit = val;
				} else if (name.equalsIgnoreCase("listingUUID")) {
					listingUUIDPassed = val;
				} else if (name.equalsIgnoreCase("item-condition")) {
					itemCondition = val;
				}
			}
		 }
	} catch(Exception ex) {
		 System.out.println(ex);
	}
	
	category = (categoryStr != null && !categoryStr.equals("")) && !categoryStr.equals("other") ? Integer.parseInt(categoryStr) : -1;
	subCategory = (subCategoryStr != null && !subCategoryStr.equals("")) ? Integer.parseInt(subCategoryStr) : -1;
	if (categoryCustom.equals("")) categoryCustom = null;
	if (categoryCustom != null) {
		category = BuyMe.Categories.insert(categoryCustom);
		subCategory = BuyMe.SubCategories.insert(subCategoryCustom, category);
	}
	
	numDays = Integer.parseInt(numDaysStr);
	startPrice = Double.parseDouble(startPriceStr);
	reservePrice = Double.parseDouble(reservePriceStr);
	bidIncrement = Double.parseDouble(bidIncrementStr);
	Calendar c = Calendar.getInstance();
	c.add(Calendar.DATE, numDays);
	endDate = new java.sql.Timestamp(c.getTimeInMillis());
	if (edit != null && !edit.equals("") && Integer.parseInt(edit) == 1) {
		Listing l = BuyMe.Listings.get(listingUUIDPassed);
		if (!l.seller_uuid.equals(u.account_uuid) && !BuyMe.Admins.isAdmin(u.account_uuid) && !BuyMe.Admins.isMod(u.account_uuid)) {
			response.sendRedirect("index.jsp");
			return;
		}
		listingUUID = l.listing_uuid;
	}
	
	// Write the file
	String imgURL;
	if (storedFile != null) {
		file = new File( filePath + listingUUID + "." + ext) ;
		storedFile.write(file) ;
		BlobId blobId = BlobId.of(bucketName, listingUUID + "." + ext);
		BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType(storedFile.getContentType()).setCacheControl("no-cache, no-store, must-revalidate").build();
		storage.create(blobInfo, Files.readAllBytes(Paths.get(filePath + listingUUID + "." + ext)));
		file.delete();
		imgURL = "https://storage.googleapis.com/buy_me_images/" + listingUUID + "." + ext;
	} else {
		imgURL = BuyMe.Listings.get(listingUUIDPassed).image;
	}
	
	if (listingUUIDPassed != null && numDays == BuyMe.Listings.get(listingUUIDPassed).listing_days) {
		endDate = BuyMe.Listings.get(listingUUIDPassed).end_time;
	}
	
	Listing l = new Listing(listingUUID, u.account_uuid, category,
			subCategory, description, product, imgURL, numDays,
			itemCondition, currency, startPrice, reservePrice,
			endDate, bidIncrement, 1);

	BuyMe.Listings.insert(l);
	if (categoryCustom == null) BuyMe.SetAlerts.categoryProcess(l);
	
	if (edit != null && !edit.equals("") && Integer.parseInt(edit) == 1 && !u.account_uuid.equals(l.seller_uuid)) {
		Event e = new Event(u.account_uuid, "Edited Listing: '" + l.item_name + "'");
		BuyMe.Events.insert(e);
	}
	
	// redirect to listings page
	response.sendRedirect("listing-item.jsp?listingUUID=" + listingUUID);
%>