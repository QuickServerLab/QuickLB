<%@ page import="com.quickserverlab.quicklb.server.*" %><%
	String pwd = UserValidator.getPasswordHash("admin");
	if(pwd==null) {
		response.sendRedirect("setPassword.jsp?user=admin");
		return;
	}
%>
<html>
<head>
	<title>QuickLB Admin</title>
</head>
<body>

<center><h3>Welcome to QuickLB Web Admin</h3></center>

<%
String error = request.getParameter("error");

	if(error!=null) {
	%>
	<h5><font color="red"><%=error%></font></h5>
	<%
	}
%>
<%
	String msg = request.getParameter("msg");

	if(msg!=null) {
	%>
	<h5>
		<font color="green"><%=msg%></font>
		
	</h5>
	<%
	}
%>


	<br/>
	<form action="/UserValidatorServlet" method="post">
		Username: <input type="text" name="username" value="admin"/><br/>
		Password: <input type="password" name="password"/><br/>
		<input type="submit" name="action" value="Login"/>
	</form>

</body>
</html>