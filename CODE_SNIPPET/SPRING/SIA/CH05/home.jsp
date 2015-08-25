<%@ taglib uir="http://java.sun.com.jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Spittr</title>
	<link rel="stylesheet"
		type="text/css"
		href="<c:url value="/resources/style.css" />" >
</head>
<body>
	<h1>Welcome to Spittr</h1>
	<a href="<c:url value="/spittles" />">Spittles</a>
	<a href="<c:url value="/spittles/register"/>">Register</a>
</body>
</html>