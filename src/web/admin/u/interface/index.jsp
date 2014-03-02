<html>
<head>
	<title>QuickLB Admin</title>
</head>
<%
	String interfaceName = request.getParameter("name");	
	String action = request.getParameter("action");
	boolean showGif = false;
	if(action!=null) {
		if(action.equals("restart")) {
			showGif = true;
			%>
			<meta http-equiv="refresh" content="3; URL=editInterfaceAction.jsp?name=<%=interfaceName%>&submit=Restart Interface">
			<%
		} else if(action.equals("reloadall")) {
			showGif = true;
			%>
			<meta http-equiv="refresh" content="3; URL=reloadInterfaceAction.jsp">
			<%
		}
	}
%>
<body>

<center><h4>Interface Admin</h4></center>

<a href="../../index.jsp">Home</a> <br/>

Interface List 

<a href="addInterface.jsp">Add New Interface</a>
&nbsp;&nbsp;
<a href="reloadInterfaceAction.jsp">Reload All Interfaces</a>

<br/>&nbsp;<br/>

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
		<%
			if(showGif) {
		%>
		<img src="../../pics/loader_small.gif" valign="bottom"/>
		<%
			}
		%>
	</h5>
	<%
	}
%>

<%@ page import="java.util.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<%
	Map<String,InterfaceServer> map = InterfaceServer.getInterfaces();
	
	Iterator<String> iterator = map.keySet().iterator();
	String key = null;
	InterfaceServer is = null;

	%>
	<table border="1">
		<tr>
			<td>Interface Name</td>
		
			<td>IP</td>
		
			<td>Port</td>

			<td>Auto Start</td>

			<td>SSL Offloaded</td>
		
			<td>Running</td>

			<td>Max Connection</td>

			<td>Current Connection</td>

			<td>Up Time</td>
		
			<td>Action</td>

			<td>Action</td>
		</tr>

	<%

	while(iterator.hasNext()) {
		key = iterator.next();
		is = map.get(key);
		%>
		<tr>
			<td><%=key%></td>
		
			<td><%=is.getQuickserver().getBindAddr().getHostAddress()%></td>
		
			<td><%=is.getQuickserver().getPort()%></td>

			<td><%=is.isAutoStart()%></td>

			<td><%=is.getQuickserver().isRunningSecure()%></td>
		
			<td><%=!is.getQuickserver().isClosed()%></td>

			<td><%=is.getQuickserver().getMaxConnection()%></td>

			<td><%=is.getQuickserver().getClientCount()%></td>

			<td><%=is.getQuickserver().getUptime()%></td>
		
			<td><a href="editInterface.jsp?name=<%=key%>">Edit Interface</a></td>

			<td><a href="editNodes.jsp?name=<%=key%>">Edit Nodes</a></td>
		</tr>
		
		<%
		
	}//end while
%>
	</table>

</body>
</html>