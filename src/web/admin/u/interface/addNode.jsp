<html>
<head>
	<title>QuickLB Admin - Add Node</title>
</head>
<body>

	<%@ include file="/u/header.jsp" %>
	
<center><h4>Add Node</h4></center>


<%@ page import="java.util.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<%@ page import="org.quickserver.net.client.*" %>
<%@ page import="java.util.logging.*" %>
<%!
	private static final Logger logger = Logger.getLogger("admin.u.interface.addNode.jsp");
%>
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

<a href="editNodes.jsp?name=<%=interfaceName%>">View All Nodes</a><br/>&nbsp;<br/>
<form action="addNodeAction.jsp" method="post">
<input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
<table border="1">
		<tr>
			<td>
				Host Name
			</td>
			<td>
				<input name="node_name" size="20" type="text" value=""/>
				
			</td>
		</tr>

		<tr>
			<td colspan="2" align="center">
			&nbsp;
			</td>
		</tr>

		<tr>
			<td>
				Host IP
			</td>
			<td>
				<input name="ip" size="20" value="" type="text"/>
			</td>
		</tr>

		<tr>
			<td>
				Host Port
			</td>
			<td>
				<input name="port" size="10" value="80" type="number"/>
			</td>
		</tr>

		<tr>
			<td>
				SSL
			</td>
			<td>
				<input name="ssl" value="true" type="checkbox" />
			</td>
		</tr>

		
		<tr>
			<td>
				Timeout (ms)
			</td>
			<td>
				<input name="timeout" size="10" value="60000" type="number"/>
			</td>
		</tr>
		
		<tr>
			<td>
				Default
			</td>
			<td>
				<input name="default" value="true" type="checkbox" />
			</td>
		</tr>
		
		<tr>
			<td>
				Maintenance
			</td>
			<td>
				<input name="maintenance" value="true" type="checkbox"  />
			</td>
		</tr>
		
		
		<tr>
			<td colspan="2" align="center">
			&nbsp;
			</td>
		</tr>
		
		<tr>
			<td>
				Welcome Msg 
			</td>
			<td>
				Enabled <input name="welcome_data_check" value="true" type="checkbox" /> <br/>
				<textarea rows="4" cols="50" name="welcome_data"></textarea>
			</td>
		</tr>
		
		<tr>
			<td>
				Request Data
			</td>
			<td>
				Enabled <input name="req_data_check" value="true" type="checkbox"  /> <br/>
				<textarea rows="4" cols="50" name="req_data"></textarea>
			</td>
		</tr>
		
		<tr>
			<td>
				Response Data
			</td>
			<td>
				Enabled <input name="res_data_check" value="true" type="checkbox"  /> <br/>
				<textarea rows="4" cols="50" name="res_data"></textarea>
			</td>
		</tr>
		
		
		<tr>
			<td colspan="2" align="center">
			&nbsp;
			</td>
		</tr>

		<tr>
			<td colspan="2" align="center">
				<br/>
				<input name="submit" size="10" value="Add Node" type="submit"/>
				<br/>&nbsp;<br/>
			</td>
		</tr>
</table>
</form>

<%@ include file="/u/footer.jsp" %>
</body>
</html>