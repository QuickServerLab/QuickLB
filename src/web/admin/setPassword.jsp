<html>
    <head>
        <title>Set Password</title>
    </head>
    <body>
<%
	String user = request.getParameter("user");
	if(user==null) {
		user = "";
	}

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
	<center><h3>Welcome to QuickLB Web Admin</h3></center>
	<br/>
	<center><h3>Set New Password</h3></center>
	<br/>
        <form action="/UserValidatorServlet" method="post">
            Username: <input type="text" name="username" value="<%=user%>"/><br/>
            Password: <input type="password" name="password"/><br/>
            <input type="submit" name="action" value="Set Password"/>
        </form>
    </body>
</html>