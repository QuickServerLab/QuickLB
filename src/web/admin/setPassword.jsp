<html>
	<!--[if lt IE 7]> <html class="lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
	<!--[if IE 7]> <html class="lt-ie9 lt-ie8" lang="en"> <![endif]-->
	<!--[if IE 8]> <html class="lt-ie9" lang="en"> <![endif]-->
	<!--[if gt IE 8]><!--> <html lang="en"> <!--<![endif]-->
    <head>
        <title>Set Password</title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<link rel="stylesheet" href="css/style.css">
		<!--[if lt IE 9]><script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
    </head>
    <body>
		
		<%@ include file="header.jsp" %>

			<br/>&nbsp;<br/>
<%
	String user = request.getParameter("user");
	if(user==null) {
		user = "";
	}

	String error = request.getParameter("error");

	if(error!=null) {
	%>
	<section class="msg"><h5><font color="red" size="3"><%=error%></font></h5></section>
	<%
	}
%>
<%
String msg = request.getParameter("msg");

	if(msg!=null) {
	%>
	<section class="msg"><h5><font color="green" size="3"><%=msg%></font></h5></section>
	<%
	}
%>
	
	<section class="msg"><h3>Set New Password</h3></section>
	<br/>
        <form action="/UserValidatorServlet" method="post" class="login">
			<p>
					<label for="username">Username:</label>
					<input type="text" name="username" id="username" value="<%=user%>">
				</p>

				<p>
					<label for="password">Password:</label>
					<input type="password" name="password" id="password" value="">
				</p>

				<p class="login-submit">
					<button type="submit" class="login-button">Login</button>
				</p>

				<input type="hidden" name="action" value="Set Password"/>
				
        </form>
			
			<%@ include file="footer.jsp" %>
    </body>
</html>