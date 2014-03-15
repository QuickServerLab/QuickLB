<html>
    <head>
        <title>Change Password</title>
    </head>
    <body>
		
		<br/>
	<center><h3>Welcome to QuickLB Web Admin</h3></center>
	<br/>
	
<%
	String user = request.getParameter("user");
	if(user==null) {
		return;
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
	<center><h4>Change Password for <%=user%></h4></center>
	<br/>
        <form action="/UserValidatorServlet" method="post">
            Username: <input type="text" name="username" value="<%=user%>" readonly/><br/>
			Old Password: <input type="password" name="oldpassword"/><br/>
            Password: <input type="password" name="password"/><br/>
            <input type="submit" name="action" value="Change Password"/>
        </form>
    </body>
</html>