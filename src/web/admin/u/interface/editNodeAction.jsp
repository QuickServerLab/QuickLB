<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<%@ page import="org.quickserver.net.client.*" %>
<%@ page import="java.util.logging.*" %>
<%@ page import="org.quickserver.util.*" %>
<%!
	private static final Logger logger = Logger.getLogger("/u/interface/editNodeAction.jsp");
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

	InterfaceHosts ih = is.getInterfaceHosts();
	HostList hostList = ih.getHostList();

	String nodeName = request.getParameter("node_name");
	SocketBasedHost host = (SocketBasedHost) hostList.getHostByName(nodeName);
	if(host==null) {
		response.sendRedirect("index.jsp?error=Bad Host Name passed");
		return;
	}

	String submit = request.getParameter("submit");
	

	if("Update Node".equals(submit)) {		
		String newNodeName = request.getParameter("new_node_name");
		String ip = request.getParameter("ip");
		String port = request.getParameter("port");
		String ssl = request.getParameter("ssl");
		String timeout = request.getParameter("timeout");
		boolean defaultFlag = "true".equals(request.getParameter("default"))?true:false;
		String maintenance = request.getParameter("maintenance");

		String welcomeDataCheck = request.getParameter("welcome_data_check");
		String welcomeData = request.getParameter("welcome_data");

		String reqDataCheck = request.getParameter("req_data_check");
		String reqData = request.getParameter("req_data");

		String resDataCheck = request.getParameter("res_data_check");
		String resData = request.getParameter("res_data");
		

		//path, is
		Object[] store = is.getQuickserver().getStoreObjects();
		File fileParent = (File) store[0];

		SocketBasedHost sbh = new SocketBasedHost();
		sbh.setName(nodeName);
		if("true".equals(ssl)) {
			sbh.setSecure(true);
		} else {
			sbh.setSecure(false);
		}
		if("true".equals(maintenance)) {
			sbh.setStatus(Host.MAINTENANCE);
		} else {
			sbh.setStatus(Host.UNKNOWN);
		}

		sbh.setInetSocketAddress(ip, Integer.parseInt(port));
		sbh.setTimeout(Integer.parseInt(timeout));

		if("true".equals(welcomeDataCheck)) {
			sbh.setTextToExpect(welcomeData);
		}

		if("true".equals(reqDataCheck)) {
			sbh.setRequestText(reqData);
		}

		if("true".equals(resDataCheck)) {
			sbh.setResponseTextToExpect(resData);
		}

		boolean flag = is.getInterfaceHosts().saveSocketBasedHostToDisk(
			is, sbh, newNodeName, defaultFlag);
		
		if(flag) {
			response.sendRedirect("editNodes.jsp?name="+interfaceName+"&msg=Node updated! Restarting Interface&action=restart");
		} else {
			response.sendRedirect("editNodes.jsp?name="+interfaceName+"&error=Node failed update!");
		}
		return;
	}

	if("Delete Node".equals(submit)) {
		boolean flag = is.getInterfaceHosts().deleteSocketBasedHostFromDisk(
			is, host);

		if(flag) {
			response.sendRedirect("editNodes.jsp?name="+interfaceName+"&msg=Node deleted! Restarting Interface&action=restart");
		} else {
			response.sendRedirect("editNodes.jsp?name="+interfaceName+"&error=Node delete failed!");
		}
		return;
	}

	response.sendRedirect("index.jsp?error=Unknown Command passed - "+submit);
	return;
%>