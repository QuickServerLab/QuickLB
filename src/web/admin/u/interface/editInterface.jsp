<html>
<head>
	<title>QuickLB Admin - Add Interface</title>
</head>
<body>

<center><h4>Edit Interface</h4></center>

<a href="../../index.jsp">Home</a> <br/>

<a href="index.jsp">Interface List</a><br/>&nbsp;<br/>

<%@ page import="java.util.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<%
	String interfaceName = request.getParameter("name");

	if(interfaceName==null) {
		response.sendRedirect("index.jsp?error=No Interface Name passed");
		return;
	}

	Map<String,InterfaceServer> map = InterfaceServer.getInterfaces();
	InterfaceServer is = map.get(interfaceName);

	if(is==null) {
		response.sendRedirect("index.jsp?error=Bad Interface Name passed");
		return;
	}
%>

<form action="editInterfaceAction.jsp" method="post">
<input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
<table border="1">
		<tr>
			<td>
				Interface Name
			</td>
			<td>
				<input name="newname" size="20" type="text" value="<%=interfaceName%>"/>
				
			<td>
		</tr>

		<tr>
			<td colspan="2" align="center">
			&nbsp;
			</td>
		</tr>

		<tr>
			<td>
				Running
			</td>
			<td>
				<%=!is.getQuickserver().isClosed()%> &nbsp;
				<input name="submit" size="10" value="Start Interface" type="submit"/>
				&nbsp;
				<input name="submit" size="10" value="Stop Interface" type="submit"/>
			<td>
		</tr>

		<tr>
			<td>
				Current Connection
			</td>
			<td>
				<%=is.getQuickserver().getClientCount()%>
			<td>
		</tr>

		<tr>
			<td>
				Up Time
			</td>
			<td>
				<%=is.getQuickserver().getUptime()%>
			<td>
		</tr>

		<tr>
			<td colspan="2" align="center">
			&nbsp;
			</td>
		</tr>

		<tr>
			<td>
				Interface Bind IP
			</td>
			<td>
				<input name="ip" size="20" value="<%=is.getQuickserver().getBindAddr().getHostAddress()%>" type="text"/>
			<td>
		</tr>

		<tr>
			<td>
				Interface Port
			</td>
			<td>
				<input name="port" size="10" value="<%=is.getQuickserver().getPort()%>" type="number"/>
			<td>
		</tr>

		<tr>
			<td>
				Auto Start
			</td>
			<td>
				<input name="auto_start" value="true" type="checkbox" <%
					if(is.isAutoStart()) {
						%>checked<%
					}%> />
			<td>
		</tr>

		<tr>
			<td>
				SSL Offloaded
			</td>
			<td>
				<input name="ssl_offloaded" value="true" type="checkbox" disabled />
			<td>
		</tr>

		<tr>
			<td>
				Mac Connection
			</td>
			<td>
				<input name="max_connection" size="10" value="<%=is.getQuickserver().getMaxConnection()%>" type="number"/>
			<td>
		</tr>

		<tr>
			<td colspan="2" align="center">
				<br/>
				<input name="submit" size="10" value="Update Interface" type="submit"/>
				&nbsp;&nbsp;&nbsp;
				<input name="submit" size="10" value="Delete Interface" type="submit"/>
				<br/>&nbsp;<br/>
			<td>
		</tr>
</table>
</form>

</body>
</html>