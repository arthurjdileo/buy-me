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
	
	String alert_type = request.getParameter("alert_type");
	String alert = request.getParameter("alert");
	
	String alertUUID = BuyMe.genUUID();
	SetAlert userAlert = BuyMe.SetAlerts.exists(u.account_uuid, alert_type, alert);
	if (userAlert == null) {
		SetAlert a = new SetAlert(alertUUID, u.account_uuid, alert_type, alert);
		BuyMe.SetAlerts.insert(a);
	} else if (userAlert != null && userAlert.is_active == 0) {
		BuyMe.SetAlerts.setActive(userAlert);
	}
	response.sendRedirect(request.getHeader("referer"));
%>