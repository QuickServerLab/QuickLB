<%@ page import="java.util.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<%@ page import="org.quickserver.net.client.*" %>
<%@ page import="java.util.logging.*" %>
<!DOCTYPE html>
<html lang="en">
    
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
    
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>QuickLB Admin | <%=interfaceName%> | Add Node</title>
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/dashboard.css" rel="stylesheet">
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  
	<body>
	<%@ include file="/u/header.jsp" %>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li><a href="listInterface.jsp">Interface Overview</a></li>
            <li ><a href="addInterface.jsp">Add New Interface</a></li>
            <li><a href="reloadInterfaceAction.jsp">Reload All Interfaces</a></li>
            <li><hr/></li>
            <li><a href="../stat/index.jsp">Stats</a></li>
          </ul>
          <%@ include file="/u/footer.jsp" %>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

        <ol class="breadcrumb" style="font-size:1.3em;">
            <li><a href="index.jsp">QuickLB</a></li>
            <li><a href="editInterface.jsp?name=<%=interfaceName%>"><%=interfaceName%></a></li>
            <li><a href="editNodes.jsp?name=<%=interfaceName%>">Nodes</a></li>
            <li class="active">Add Node</li>
        </ol>
          
          <form  class="form-horizontal" role="form"action="addNodeAction.jsp" method="post" style="width:450px;margin-top:20px;">
              
            <input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
              
             <div class="form-group">
                <label for="node_name" class="col-sm-4 control-label">Host Name</label>
                <div class="col-sm-8">
                  <input type="text" class="form-control" maxlength="20" name="node_name" placeholder="Node Name" value="">
                </div>
              </div>
              
              <div class="form-group">
                <label for="ip" class="col-sm-4 control-label">Host IP</label>
                <div class="col-sm-8">
                  <input type="text" class="form-control" name="ip" value="" placeholder="Host IP">
                </div>
              </div>
              
              <div class="form-group">
                <label for="port" class="col-sm-4 control-label">Host Port</label>
                <div class="col-sm-8">
                  <input type="number" class="form-control" name="port" value="80" placeholder="Host Port">
                </div>
              </div>
              
              <div class="form-group">
                <label for="timeout" class="col-sm-4 control-label">Timeout (ms)</label>
                <div class="col-sm-8">
                  <input type="number" class="form-control" name="timeout" value="60000" placeholder="Timeout (ms)">
                </div>
              </div>
                
              <div class="form-group">
                <label for="welcome_data_check" class="col-sm-4 control-label">Welcome Msg</label>
                <div class="col-sm-8">
                  <input type="checkbox" name="welcome_data_check" value="true"> Enabled
                  <textarea class="form-control" rows="4" cols="50" name="welcome_data"></textarea>
                </div>
              </div>
                
              <div class="form-group">
                <label for="req_data_check" class="col-sm-4 control-label">Request Data</label>
                <div class="col-sm-8">
                  <input type="checkbox" name="req_data_check" value="true"> Enabled
                  <textarea class="form-control" rows="4" cols="50" name="req_data"></textarea>
                </div>
              </div>
                
              <div class="form-group">
                <label for="res_data_check" class="col-sm-4 control-label">Response Data</label>
                <div class="col-sm-8">
                  <input type="checkbox" name="res_data_check" value="true"> Enabled
                  <textarea class="form-control" rows="4" cols="50" name="res_data"></textarea>
                </div>
              </div>
              

              
              <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                  <div class="checkbox">
                    <label>
                      <input type="checkbox" name="default" value="true"> Default
                    </label>
                  </div>
                </div>
              </div>
                
              <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                  <div class="checkbox">
                    <label>
                      <input type="checkbox" name="default" value="true"> SSL
                    </label>
                  </div>
                </div>
              </div>
              
              <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                  <div class="checkbox">
                    <label>
                      <input type="checkbox" name="maintenance" value="true"> Maintenance
                    </label>
                  </div>
                </div>
              </div>
              

              
              <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                  <button  name="submit" type="submit" class="btn btn-success" value="Add Node">Add Node</button>
                </div>
              </div>
              
        </form>
        </div>
      </div>
    </div>

    <script src="/scripts/jquery.min.js"></script>
    <script src="/scripts/bootstrap.min.js"></script>
    <script src="/scripts/docs.min.js"></script>
  </body>
</html>