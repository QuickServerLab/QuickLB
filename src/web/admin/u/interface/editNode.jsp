<html>
<head>
	<title>QuickLB Admin - Edit Node</title>
</head>
<body>

<center><h4>Edit Node</h4></center>

<a href="../../index.jsp">Home</a> <br/>

<a href="index.jsp">Interface List</a><br/>&nbsp;<br/>

<%@ page import="java.util.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<%@ page import="org.quickserver.net.client.*" %>
<%@ page import="java.util.logging.*" %>
<%!
	private static final Logger logger = Logger.getLogger("admin.u.interface.editNode.jsp");
%>
<%
	String interfaceName = request.getParameter("name");
	String nodeName = request.getParameter("node_name");
	String nodeDefault = request.getParameter("node_default");

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

	InterfaceHosts ih = is.getInterfaceHosts();
	HostList hostList = null;
	logger.fine("hostList: "+hostList);

	

	if(ih!=null) {
		hostList = ih.getHostList();
	}

	SocketBasedHost host = (SocketBasedHost) hostList.getHostByName(nodeName);
	if(host==null) {
		response.sendRedirect("index.jsp?error=Bad Host Name passed");
		return;
	}
%>

<a href="editNodes.jsp?name=<%=interfaceName%>">View All Nodes</a><br/>&nbsp;<br/>
<form action="editNodeAction.jsp" method="post">
<input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
<input name="node_name" size="20" type="hidden" value="<%=nodeName%>"/>
<table border="1">
		<tr>
			<td>
				Host Name
			</td>
			<td>
				<input name="new_node_name" size="20" type="text" value="<%=InterfaceHosts.getRealNodeName(host)%>"/>
				
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
				<input name="ip" size="20" value="<%=host.getInetSocketAddress().getHostString()%>" type="text"/>
			</td>
		</tr>

		<tr>
			<td>
				Host Port
			</td>
			<td>
				<input name="port" size="10" value="<%=host.getInetSocketAddress().getPort()%>" type="number"/>
			</td>
		</tr>

		<tr>
			<td>
				SSL
			</td>
			<td>
				<input name="ssl" value="true" type="checkbox" <%
					if(host.isSecure()) {
						%>checked<%
					}%> />
			</td>
		</tr>

		
		<tr>
			<td>
				Timeout (ms)
			</td>
			<td>
				<input name="timeout" size="10" value="<%=host.getTimeout()%>" type="number"/>
			</td>
		</tr>
		
		<tr>
			<td>
				Default
			</td>
			<td>
				<input name="default" value="true" type="checkbox" <%
					if("true".equals(nodeDefault)) {
						%>checked<%
					}%> />
			</td>
		</tr>
		
		<tr>
			<td>
				Maintenance
			</td>
			<td>
				<input name="maintenance" value="true" type="checkbox" <%
					if(host.getStatus()==Host.MAINTENANCE) {
						%>checked<%
					}%> />
			</td>
		</tr>
		
		<tr>
			<td>
				Up Time
			</td>
			<td>
				<%=host.getUptime()%>
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
				Enabled <input name="welcome_data_check" value="true" type="checkbox" <%
					if(host.getTextToExpect()!=null && host.getTextToExpect().length()!=0) {
						%>checked<%
					}%> /> <br/>
				<textarea rows="4" cols="50" name="welcome_data"><%=host.getTextToExpect()!=null?host.getTextToExpect():""%></textarea>
			</td>
		</tr>
		
		<tr>
			<td>
				Request Data
			</td>
			<td>
				Enabled <input name="req_data_check" value="true" type="checkbox" <%
					if(host.getRequestText()!=null && host.getRequestText().length()!=0) {
						%>checked<%
					}%> /> <br/>
				<textarea rows="4" cols="50" name="req_data"><%=host.getRequestText()!=null?host.getRequestText():""%></textarea>
			</td>
		</tr>
		
		<tr>
			<td>
				Response Data
			</td>
			<td>
				Enabled <input name="res_data_check" value="true" type="checkbox" <%
					if(host.getResponseTextToExpect()!=null && host.getResponseTextToExpect().length()!=0) {
						%>checked<%
					}%> /> <br/>
				<textarea rows="4" cols="50" name="res_data"><%=host.getResponseTextToExpect()!=null?host.getResponseTextToExpect():""%></textarea>
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
				<input name="submit" size="10" value="Update Node" type="submit"/>
				&nbsp;&nbsp;&nbsp;
				<input name="submit" size="10" value="Delete Node" type="submit"/>
				<br/>&nbsp;<br/>
			</td>
		</tr>
</table>
</form>
</body>
</html>