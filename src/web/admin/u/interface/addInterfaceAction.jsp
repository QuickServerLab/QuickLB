<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<%@ page import="java.util.logging.*" %>
<%@ page import="org.quickserver.util.*" %>
<%!
	private static final Logger logger = Logger.getLogger("/u/iinterface/editInterfaceAction.jsp");
%>
<%
	String interfaceName = request.getParameter("name");

	if(interfaceName==null) {
		response.sendRedirect("index.jsp?error=No Interface Name passed");
		return;
	}

	Map<String,InterfaceServer> map = InterfaceServer.getInterfaces();
	InterfaceServer is = map.get(interfaceName);

	if(is!=null) {
		response.sendRedirect("index.jsp?error=Interface Name passed already exists");
		return;
	}

	String submit = request.getParameter("submit");
	
	if("Add Interface".equals(submit)) {
		String ip = request.getParameter("ip");
		String port = request.getParameter("port");
		String auto_start = request.getParameter("auto_start");
		String ssl_offloaded = request.getParameter("ssl_offloaded");
		String max_connection = request.getParameter("max_connection");

		is = InterfaceServer.createDefaultInterface(interfaceName);
		
		is.getQuickserver().getConfig().setName(interfaceName+" Interface Server");
		is.getQuickserver().getConfig().setBindAddr(ip);
		is.getQuickserver().getConfig().setPort(Integer.parseInt(port));
		is.getQuickserver().getConfig().setMaxConnection(Integer.parseInt(max_connection));

		//todo - ssl_offloaded

		//path, is
		Object[] store = is.getQuickserver().getStoreObjects();
		File fileParent = (File) store[0];

		//update auto_start
		if("true".equals(auto_start)) {
			is.getConfig().put("auto_start", "true");
		} else {
			is.getConfig().put("auto_start", "true");
		}
		File newIni = new File(fileParent.getCanonicalPath() + File.separator + 
			"interface.ini");
		is.saveConfigToDisk(newIni);

		//update xml
		File newXml = new File(fileParent.getCanonicalPath() + File.separator + 
			"interface.xml");
		is.saveQSXmlToDisk(newXml);
		
		
		response.sendRedirect("index.jsp?msg=Interface Added! Reloading All Interfaces&action=reloadall");
		return;
		
	}

	response.sendRedirect("index.jsp?error=Unknown Command passed - "+submit);
	return;
%>