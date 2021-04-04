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
	if(!BuyMe.Admins.isAdmin(u.account_uuid) && !BuyMe.Admins.isMod(u.account_uuid)) {
		response.sendRedirect("index.jsp");
		return;
	}

	String accountUUID = request.getParameter("accountUUID");
	User us = BuyMe.Users.get(accountUUID);
	
	BuyMe.Users.delete(accountUUID);
	Event e = new Event(u.account_uuid, "Deleted user: '" + us.email + "'");
	BuyMe.Events.insert(e);
	response.sendRedirect("admin.jsp");
	return;
%>