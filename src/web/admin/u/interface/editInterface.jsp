<%@ page import="java.util.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>QuickLB Admin | Edit Interface</title>
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
  <body>
      
    <%@ include file="/u/header.jsp" %>    

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li class="active"><a href="listInterface.jsp">Interface Overview</a></li>
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
            <li><a href="listInterface.jsp">Interface</a></li>
            <li class="active">Edit Interface (<%=interfaceName%>) <a class="btn btn-primary btn-xs active" href="editNodes.jsp?name=<%=interfaceName%>">Edit Nodes</a></li>
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
    
    <div class="alert alert-success alert-dismissable">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <%=msg%>
    </div>
        
	<%
	}
%>


          <form  class="form-horizontal" role="form"action="editInterfaceAction.jsp" method="post" style="width:450px;margin-top:20px;">
              
            <div class="row form-group" style="margin-left:15px;">
                <div class="col-md-12 post-header-line" style="text-align: center">
                    <span style="font-size:12px;"><strong>Up time : </strong><span class="badge"><%=is.getQuickserver().getUptime()%></span></span>
                    &nbsp;&nbsp;&nbsp;
                    <span style="font-size:12px;"><strong>Current Connection : </strong><span class="badge"><%=is.getQuickserver().getClientCount()%></span></span>&nbsp;&nbsp;&nbsp;
                    
                </div>
            </div>
    
              <div class="form-group">
                <label for="" class="col-sm-5 control-label">Running</label>
                <div class="col-sm-7">
                    <%if(is.getQuickserver().isClosed()){%>
                        <button type="submit" name="submit" value="Start Interface" class="btn btn-primary btn-xs" style="margin-top: 8px;">Start Interface</button>
                    <%}else{%>
                         <button type="submit" name="submit" value="Stop Interface" class="btn btn-xs btn-warning" style="margin-top: 8px;">Stop Interface</button>
                    <%}%>
                </div>
              </div>
              
             <div class="form-group">
                <label for="name" class="col-sm-5 control-label">Interface Name</label>
                <div class="col-sm-7">
                    <input type="text" class="form-control" maxlength="20" name="newname" placeholder="Interface Name" value="<%=interfaceName%>">
                  <input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
                </div>
              </div>
                
              <div class="form-group">
                <label for="ip" class="col-sm-5 control-label">Interface Bind IP</label>
                <div class="col-sm-7">
                  <input type="text" class="form-control" name="ip" value="<%=is.getQuickserver().getBindAddr().getHostAddress()%>" placeholder="Bind IP">
                </div>
              </div>
                
              <div class="form-group">
                <label for="max_connection" class="col-sm-5 control-label">Max Connection</label>
                <div class="col-sm-7">
                  <input type="text" class="form-control" name="max_connection" value="<%=is.getQuickserver().getMaxConnection()%>" placeholder="Max Connection">
                </div>
              </div>
              
              <div class="form-group">
                <label for="port" class="col-sm-5 control-label">Interface Port</label>
                <div class="col-sm-7">
                  <input type="number" class="form-control" name="port" value="<%=is.getQuickserver().getPort()%>" placeholder="Port">
                </div>
              </div>
              
              <div class="form-group">
                <div class="col-sm-offset-5 col-sm-7">
                  <div class="checkbox">
                    <label>
                      <input type="checkbox" name="auto_start" value="true" <%if(is.isAutoStart()) {%> checked <%}%> > Auto Start
                    </label>
                  </div>
                </div>
              </div>
              
              <div class="form-group">
                <div class="col-sm-offset-5 col-sm-7">
                  <div class="checkbox">
                    <label>
                      <input type="checkbox" name="ssl_offloaded" value="true" disabled> SSL Offloaded
                    </label>
                  </div>
                </div>
              </div>
              
              <div class="form-group">
                <div class="col-sm-offset-3 col-sm-9">
                  <button  name="submit" type="submit" class="btn btn-danger" value="Delete Interface">Delete Interface</button>&nbsp;&nbsp;&nbsp;
                  <button  name="submit" type="submit" class="btn btn-success" value="Update Interface">Update Interface</button>
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
