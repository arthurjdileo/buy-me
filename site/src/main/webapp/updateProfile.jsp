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
	String acc_uuid = request.getParameter("acc_uuid");
	String fromAdmin = request.getParameter("from-admin");
	User u = BuyMe.Sessions.getBySession(BuyMe.Sessions.getCurrentSession(cookies));
	if (fromAdmin != null) {
		u = BuyMe.Users.get(acc_uuid);
	}

	String firstName = request.getParameter("first-name");
	String lastName = request.getParameter("last-name");
	String email = request.getParameter("email");
	String pwd = request.getParameter("password");
	String confirmPw = request.getParameter("change-password");
	ArrayList<String> errors = new ArrayList<String>();
	if (fromAdmin != null) {
		session.setAttribute("errorUpdateProfileAdmin", errors);
	} else {
		session.setAttribute("errorUpdateProfile", errors);
	}

	if (!pwd.equals(confirmPw)) {
		errors.add("Passwords are not matching");
		if (fromAdmin != null) response.sendRedirect("edit-user.jsp?acc_uuid=" + acc_uuid);
		else response.sendRedirect("profile.jsp");
		return;
	} else if (!pwd.equals("") && (pwd.length() < 8 || pwd == null)) {
		errors.add("Password must be at least 8 characters.");
		if (fromAdmin != null) response.sendRedirect("edit-user.jsp?acc_uuid=" + acc_uuid);
		else response.sendRedirect("profile.jsp");
		return;
	}
	if (firstName.equals("")) {
		firstName = u.firstName;
	}
	if (lastName.equals("")) {
		lastName = u.lastName;
	}
	if (email.equals("")) {
		email = u.email;
	}
	if (pwd.equals("") && confirmPw.equals("")) {
		pwd = u.password;
	}
	
	String hashedPw = BuyMe.Sessions.hashPassword(pwd);
	User updated = new User(email, hashedPw, u.account_uuid, firstName, lastName, u.credits, u.lastIP, u.pwReset, u.isActive);
	BuyMe.Users.update(updated);
	if (fromAdmin != null) {
		String isMod = request.getParameter("isMod");
		if (isMod != null && isMod.equalsIgnoreCase("true")) {
			BuyMe.Admins.setRole(acc_uuid, "Moderator");
		}
		response.sendRedirect("admin.jsp");
	} else {
		response.sendRedirect("profile.jsp");
	}
	return;
%>