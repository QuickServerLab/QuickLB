<html>
    <head>
        <title>Login</title>
    </head>
    <body>
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
            <input type="submit" value="Login"/>
        </form>
    </body>
</html>