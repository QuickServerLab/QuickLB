<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="java.util.logging.*" %>
<%!
	private static final Logger logger = Logger.getLogger("/u/iinterface/reloadInterfaceAction.jsp");
%>
<html>
<head>
	<title>QuickLB Admin - Add Interface</title>
	<meta http-equiv="refresh" content="5; URL=index.jsp?msg=All Interfaces Reloaded">
</head>
<body>
<center>
<h5>Please wait</h5>
</center>
</body>
</html>
<%
out.flush();
%>
<%
	InterfaceServer.initInterfaces();
%>