<%@ page import="java.util.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>QuickLB Admin | Interface</title>
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/dashboard.css" rel="stylesheet">
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
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
      
    <%@ include file="/u/header.jsp" %>    

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li class="active"><a href="#">Interface Overview</a></li>
            <li><a href="addInterface.jsp">Add New Interface</a></li>
            <li><a href="reloadInterfaceAction.jsp">Reload All Interfaces</a></li>
            <li><hr/></li>
            <li><a href="../stat/index.jsp">Stats</a></li>
          </ul>
            
          <%@ include file="/u/footer.jsp" %>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            
        <ol class="breadcrumb" style="font-size:1.3em;">
            <li><a href="index.jsp">QuickLB</a></li>
            <li class="active">Interface <a class="btn btn-primary btn-xs active" href="addInterface.jsp">Add New Interface</a></li>
        </ol>
          
    <%
String error = request.getParameter("error");

	if(error!=null) {
	%>
<div class="alert alert-warning alert-dismissable">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <strong>Error! </strong><%=error%>
</div>
	<%}%>

<%
String msg = request.getParameter("msg");
	if(msg!=null) {
	%>
    
    <%if(showGif) {%>
        <div class="alert alert-success">
            <%=msg%><img src="../../pics/loader_small.gif" valign="bottom"/>
        </div>
    <%}else{%>
        <div class="alert alert-success alert-dismissable">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <%=msg%>
        </div>
    <%}%>
        

	<%
	}
%>

<%
	Map<String,InterfaceServer> map = InterfaceServer.getInterfaces();

	Iterator<String> iterator = map.keySet().iterator();
	String key = null;
	InterfaceServer is = null;
    boolean hasRow = false;
    
%>
          
          <div class="table-responsive">
            <table class="table table-bordered table-condensed table-hover">
              <thead>
                <tr>
                  <th>Interface Name</th>
                  <th>IP</th>
                  <th>Port</th>
                  <th>Auto Start</th>
                  <th>SSL Offloaded</th>
                  <th>Running</th>
                  <th>Max Connection</th>
                  <th>Current Connection</th>
                  <th>Up Time</th>
                  <th>Action</th>
                </tr>
              </thead>
              
              <tbody>
                  
	<%

	while(iterator.hasNext()) {
        hasRow = true;
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

			<td>
                <div class="btn-group">
                  <button class="btn btn-default btn-sm dropdown-toggle" type="button" data-toggle="dropdown">
                    Action <span class="caret"></span>
                  </button>
                  <ul class="dropdown-menu">
                    <li><a href="editInterface.jsp?name=<%=key%>">Edit Interface</a></li>
                    <li class="divider"></li>
                    <li><a href="editNodes.jsp?name=<%=key%>">Edit Nodes</a></li>
                  </ul>
                </div>
            </td>
		</tr>

		<%

	}//end while
%>
              </tbody>
            </table>
          </div>
             
    <%if(hasRow==false) {%>
        <div class="alert alert-warning">
            No interfaces added, <a href="addInterface.jsp" class="alert-link">Click here to add new interface</a>
        </div>
    <%}%>   

              
              
        </div>
      </div>
    </div>
    

    <script src="/scripts/jquery.min.js"></script>
    <script src="/scripts/bootstrap.min.js"></script>
    <script src="/scripts/docs.min.js"></script>
  </body>
</html>
