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

	if(is==null) {
		response.sendRedirect("index.jsp?error=Bad Interface Name passed");
		return;
	}

	String submit = request.getParameter("submit");
	if("Start Interface".equals(submit)) {
		if(is.getQuickserver().isClosed()==false) {
			response.sendRedirect("index.jsp?error=Interface already running");
			return;
		}
		
		boolean flag = is.getQuickserver().startService();

		if(flag) {
			response.sendRedirect("index.jsp?msg=Interface started");
		} else {
			response.sendRedirect("index.jsp?error=Error starting Interface");
		}
		return;
	}

	if("Stop Interface".equals(submit)) {
		if(is.getQuickserver().isClosed()) {
			response.sendRedirect("index.jsp?error=Interface already stopped");
			return;
		}
		
		boolean flag = is.getQuickserver().stopService();

		if(flag) {
			response.sendRedirect("index.jsp?msg=Interface stopped");
		} else {
			response.sendRedirect("index.jsp?error=Error stopping Interface");
		}
		return;
	}

	if("Update Interface".equals(submit)) {
		String newname = request.getParameter("newname");
		String ip = request.getParameter("ip");
		String port = request.getParameter("port");
		String auto_start = request.getParameter("auto_start");
		String ssl_offloaded = request.getParameter("ssl_offloaded");
		String max_connection = request.getParameter("max_connection");

		boolean renameInterfaceFolder = false;

		if(newname.equals(interfaceName)==false) {
			renameInterfaceFolder = true;
		}

		if(renameInterfaceFolder && is.isUp()) {
			response.sendRedirect("index.jsp?error=Error Interface Name change "+
				"can't be done if server is running");
			return;
		}
		
		is.getQuickserver().getConfig().setName(newname+" Interface Server");
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
			is.getConfig().put("auto_start", "false");
		}
		File newIni = new File(fileParent.getCanonicalPath() + File.separator + 
			"interface.ini");
		is.saveConfigToDisk(newIni);

		//update xml
		File newXml = new File(fileParent.getCanonicalPath() + File.separator + 
			"interface.xml");
		is.saveQSXmlToDisk(newXml);
		
		
		//rename folder
		if(renameInterfaceFolder) {
			File newFile = new File(is.getParentDir().getParent() + 
				File.separator + newname);
			boolean flag = is.getParentDir().renameTo(newFile);
			if(flag) {
				response.sendRedirect("index.jsp?msg=Interface updated!");
			} else {
				response.sendRedirect("index.jsp?msg=Interface updated! But name change failed!");
			}
			return;
		} else {
			response.sendRedirect("index.jsp?msg=Interface updated!");
			return;
		}
	}

	if("Delete Interface".equals(submit)) {
		if(is.getQuickserver().isClosed()==false) {
			response.sendRedirect("index.jsp?error=Interface running. Can not delete running interface.");
			return;
		}

		boolean flag = is.deleteInterface();

		if(flag) {
			response.sendRedirect("index.jsp?msg=Interface deleted!");
		} else {
			response.sendRedirect("index.jsp?error=Interface delete failed!");
		}
		return;
	}

	response.sendRedirect("index.jsp?error=Unknown Command passed - "+submit);
	return;
%>