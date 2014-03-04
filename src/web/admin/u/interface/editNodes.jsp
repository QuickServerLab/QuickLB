<%@ page import="java.util.logging.*" %>
<%!
	private static final Logger logger = Logger.getLogger("admin.u.interface.editNodes.jsp");
%>
<html>
	<head>
		<title>QuickLB Admin - Edit Nodes</title>
	</head>
	<%
	String interfaceName = request.getParameter("name");
	boolean showGif = false;
	if(interfaceName==null) {
		response.sendRedirect("index.jsp?error=No Interface Name passed");
		return;
	}
	String action = request.getParameter("action");

	if(action!=null) {
		if(action.equals("restart")) {
			showGif = true;
			%>
			<meta http-equiv="refresh" content="3; URL=editInterfaceAction.jsp?name=<%=interfaceName%>&submit=Restart Interface">
			<%
		}
	}
%>
	<body>
		<%
			

			Map<String,InterfaceServer> map = InterfaceServer.getInterfaces();
			InterfaceServer is = map.get(interfaceName);

			if(is==null) {
				response.sendRedirect("index.jsp?error=Bad Interface Name passed");
				return;
			}
		%>

	<center><h4>Edit Nodes for <%=interfaceName%></h4></center>

	<a href="../../index.jsp">Home</a> <br/>

	<a href="index.jsp">Interface List</a><br/>&nbsp;<br/>
	
	
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
	<%@ page import="org.quickserver.net.client.*" %>

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


		<tr>
			<td><%=interfaceName%></td>

			<td><%=is.getQuickserver().getBindAddr().getHostAddress()%></td>

			<td><%=is.getQuickserver().getPort()%></td>

			<td><%=is.isAutoStart()%></td>

			<td><%=is.getQuickserver().isRunningSecure()%></td>

			<td><%=!is.getQuickserver().isClosed()%></td>

			<td><%=is.getQuickserver().getMaxConnection()%></td>

			<td><%=is.getQuickserver().getClientCount()%></td>

			<td><%=is.getQuickserver().getUptime()%></td>

			<td><a href="editInterface.jsp?name=<%=interfaceName%>">Edit Interface</a></td>

			<td>
				<form action="editInterfaceAction.jsp" method="post">
					<input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
					<br/>
					<input name="submit" size="10" value="Start Interface" type="submit"/>
					&nbsp;
					<input name="submit" size="10" value="Stop Interface" type="submit"/>
				</form>
			</td>
		</tr>
	</table>

	<br/>&nbsp;<br/>


	<form action="editNodesAction.jsp" method="post">
		<input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
		<table border="1">
			<tr>
				<td>
					Distribution Method
				</td>
				<td>
					<%
					String dis = is.getDistribution();
					%>
					<select name="distribution"  >
						<option value="ip_based" <%=dis.equals("ip_based")?"selected":""%>>Client IP Based (sticky)</option>
						<option value="roundrobin" <%=dis.equals("roundrobin")?"selected":""%>>Roundrobin</option>
						<option value="failover" <%=dis.equals("failover")?"selected":""%>>Failover</option>
						<option value="random" <%=dis.equals("random")?"selected":""%>>Random</option>
					</select>				
				</td>
			</tr>
			<tr>
				<td>
					Monitoring Interval
				</td>
				<td>
					<input name="monitoringIntervalInSec" size="10" value="<%=is.getMonitoringIntervalInSec()%>" type="number"/> In Sec
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<br/>
					<input name="submit" size="10" value="Update Interface" type="submit"/>
				</td>
			</tr>
		</table>
	</form>

	<center><h4>Nodes List for <%=interfaceName%></h4></center>
	<a href="addNode.jsp?name=<%=interfaceName%>">Add New Node</a>
	<table border="1">
		<tr>
			<td>Node Name</td>

			<td>Host</td>

			<td>Port</td>
			
			<td>SSL</td>

			<td>Timeout</td>

			<td>Default</td>
			
			<td>Maintenance</td>
			
			<td>Status</td>

			<td>Up Time</td>

			<td>Action</td>
		</tr>
		<%
			InterfaceHosts ih = is.getInterfaceHosts();
			HostList hostList = null;
			logger.fine("hostList: "+hostList);

			List<SocketBasedHost> list = null;
			
			if(ih!=null) {
				hostList = ih.getHostList();
			}
			if(hostList!=null) {
				list = (List<SocketBasedHost>)hostList.getFullList();
				logger.fine("list "+list);
			} else {
				logger.fine("host list was null!");
			}

			if(list==null || list.isEmpty()) {
				%>
				<tr>
					<td colspan="10" align="center">
						No Nodes Visible. Please Make sure interface is UP
					</td>
				</tr>
				<%
				
			} else {
				
				
				for(int i=0;i<list.size();i++) {

					%>
					<tr>
						<td><%=InterfaceHosts.getRealNodeName(list.get(i))%></td>

						<td><%=list.get(i).getInetSocketAddress().getHostString()%></td>

						<td><%=list.get(i).getInetSocketAddress().getPort()%></td>

						<td><%=list.get(i).isSecure()%></td>

						<td><%=list.get(i).getTimeout()%></td>

						<td><%=i==0?true:false%></td>

						<td><%=list.get(i).getStatus()==Host.MAINTENANCE?true:false%></td>
						
						<td><%=list.get(i).getStatus()%></td>

						<td><%=list.get(i).getUptime()%></td>


						<form action="editNode.jsp" method="post">
						<td>
							
								<input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
								<input name="node_name" size="20" type="hidden" value="<%=list.get(i).getName()%>"/>
								<input name="node_default" size="20" type="hidden" value="<%=i==0?true:false%>"/>
								
								<input name="submit" size="10" value="Edit Node" type="submit"/>
							
						</td>
						</form>
					</tr>

					<%
				}//for
				
			}
		%>

		
	</table>
</body>
</html>