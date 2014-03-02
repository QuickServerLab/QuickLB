<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<%@ page import="java.util.logging.*" %>
<%@ page import="org.quickserver.util.*" %>
<%!
	private static final Logger logger = Logger.getLogger("/u/interface/editNodesAction.jsp");
%>
<%
	String interfaceName = request.getParameter("name");

	if(interfaceName==null) {
		response.sendRedirect("index.jsp?error=No Interface Name passed1");
		return;
	}

	Map<String,InterfaceServer> map = InterfaceServer.getInterfaces();
	InterfaceServer is = map.get(interfaceName);

	if(is==null) {
		response.sendRedirect("index.jsp?error=Bad Interface Name passed");
		return;
	}

	String submit = request.getParameter("submit");
	

	if("Update Interface".equals(submit)) {
		
		String distribution = request.getParameter("distribution");
		String monitoringIntervalInSec = request.getParameter("monitoringIntervalInSec");
		

		//path, is
		Object[] store = is.getQuickserver().getStoreObjects();
		File fileParent = (File) store[0];

		//update auto_start
		is.getConfig().put("distribution", distribution);
		is.getConfig().put("monitoringIntervalInSec", monitoringIntervalInSec);

		File newIni = new File(fileParent.getCanonicalPath() + File.separator + 
			"interface.ini");
		is.saveConfigToDisk(newIni);

		response.sendRedirect("editNodes.jsp?name="+interfaceName+"&msg=Interface updated! Restarting Interface&action=restart");
		return;
	}

	if("Delete Interface".equals(submit)) {
		if(is.getQuickserver().isClosed()==false) {
			response.sendRedirect("editNodes.jsp?name="+interfaceName+"&error=Interface running. Can not delete running interface.");
			return;
		}

		boolean flag = is.deleteInterface();

		if(flag) {
			response.sendRedirect("editNodes.jsp?name="+interfaceName+"&msg=Interface deleted! Restarting Interface&action=restart");
		} else {
			response.sendRedirect("editNodes.jsp?name="+interfaceName+"&error=Interface delete failed!");
		}
		return;
	}

	response.sendRedirect("editNodes.jsp?name="+interfaceName+"&error=Unknown Command passed - "+submit);
	return;
%>