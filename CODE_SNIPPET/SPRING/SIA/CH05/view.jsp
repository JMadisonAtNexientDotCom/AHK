<%@ taglib uir="http://java.sun.com.jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>A JSP VIEW TEMPLATE! (view.jsp) </title>
	<link rel="stylesheet"
		type="text/css"
		href="<c:url value="/resources/style.css" />" >
</head>
<body>
	<h1>Welcome to a the view template!</h1>
	<p> I would be lying if I said I knew what all of this did. </p>
	<a href="<c:url value="/spittles" />">Spittles</a>
	<a href="<c:url value="/spittles/register"/>">Register</a>
</body>
</html>