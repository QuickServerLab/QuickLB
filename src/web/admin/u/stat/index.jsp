<html>

	<head>
		<title>QuickLB Web Admin | Statistics</title>

	</head>

	<body>

		<%@ include file="/u/header.jsp" %>

	<center><h4>Statistics Report</h4></center>
	<br/>&nbsp;<br/>

	<%@ page import="java.util.*" %>
	<%@ page import="com.quickserverlab.quicklb.*" %>
	<%@ page import="com.quickserverlab.quicklb.server.*" %>
	<%@ page import="org.quickserver.net.server.*" %>
	<%@ page import="org.quickserver.util.*" %>
	<%!
	Runtime runtime = Runtime.getRuntime();
	%>

	<h5>General process information</h5><br/>
	PID : <%=QuickServer.getPID()%><br/>
	QuickServer v : <%=QuickServer.getVersion()%><br/>
	Java VM v : <%=System.getProperty("java.version")%><br/>
	Operating System: <%=System.getProperty("os.name") + " " + System.getProperty("os.version")%><br/>
	Total memory currently available : <%=MyString.getMemInfo(runtime.totalMemory())%><br/>
	Memory currently in use : <%=MyString.getMemInfo(runtime.totalMemory()-runtime.freeMemory())%><br/>
	Maximum memory available : <%=MyString.getMemInfo(runtime.maxMemory())%><br/>
	Uptime : <%=JvmUtil.getUptime(QuickLB.getStartTime())%>
	<br/>&nbsp;<br/>



	<%
		Map<String,InterfaceServer> map = InterfaceServer.getInterfaces();

		Iterator<String> iterator = map.keySet().iterator();
		String key = null;
		InterfaceServer is = null;

	%>

	<style type="text/css">  
      td.thinBorder{ border: dotted #000 1px;}  
	  tr.thinBorder td{ border: dotted #000 1px;}  
    </style>  

	<table border="0" cellspacing="1" cellpadding="5" align="center" width="80%">
		<tr>
			<td>&nbsp;</td>

			<td>&nbsp;</td>

			<td>&nbsp;</td>

			<td>&nbsp;</td>

			<td colspan="4" align="center" class="thinBorder">Connection</td>
			

			<td colspan="2" align="center" class="thinBorder">Bytes</td>

			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		
		<tr class="thinBorder">
			<td>&nbsp;</td>

			<td>IP</td>

			<td>Port</td>

			<td>Up</td>

			<td>Count</td>
			<td>Current</td>
			<td>Max</td>
			<td>Limit</td>

			<td>In</td>
			<td>Out</td>
			
			<td>Dropped</td>
			<td>Error</td>
			<td>Uptime</td>
			<td>Downtime</td>
		</tr>

		<%

		while(iterator.hasNext()) {
			key = iterator.next();
			is = map.get(key);
		%>
		<tr bgcolor="#64C9F5">
			<td><%=key%></td>

			<td><%=is.getQuickserver().getBindAddr().getHostAddress()%></td>

			<td><%=is.getQuickserver().getPort()%></td>

			<td><%=!is.getQuickserver().isClosed()%></td>
			
			<td><%=is.getStats().getClientCount().get()%></td>
			
			<td><%=is.getQuickserver().getClientCount()%></td>

			<td><%=is.getQuickserver().getHighestActiveClientCount()%></td>
			
			<td><%=is.getQuickserver().getMaxConnection()%></td>
			

			<td><%=is.getStats().getInByteCount().get()%></td>
			<td><%=is.getStats().getOutByteCount().get()%></td>

			<td><%=is.getStats().getDroppedCount().get()%></td>
			<td><%=is.getStats().getConErrorCount().get()%></td>
			
			<td><%=is.getQuickserver().getUptime()%></td>
			<td><%=is.getStats().getDownTimeText()%></td>
		</tr>

		<%

	}//end while
		%>
	</table>

	<%@ include file="/u/footer.jsp" %>
</body>
</html>