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

	String questionUUID = request.getParameter("question_uuid");
	Question q = BuyMe.Questions.get(questionUUID);
	String answer = request.getParameter("answer");
	
	BuyMe.Questions.answer(questionUUID, answer, u.account_uuid);
	
	Event e = new Event(u.account_uuid, "Answered question: '" + q.question + "' with '" + answer + "'");
	BuyMe.Events.insert(e);
	response.sendRedirect("admin.jsp");
	return;
%>