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
	<body>
	<%@ include file="/u/header.jsp" %>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li><a href="listInterface.jsp">Interface Overview</a></li>
            <li class="active"><a href="#">Add New Interface</a></li>
            <li><a href="reloadInterfaceAction.jsp">Reload All Interfaces</a></li>
            <li><hr/></li>
            <li><a href="../stat/index.jsp">Stats</a></li>
          </ul>
           
          <%@ include file="/u/footer.jsp" %>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

        <ol class="breadcrumb" style="font-size:1.3em;">
            <li><a href="/u/interface/index.jsp">QuickLB</a></li>
            <li class="active">Add New Interface</li>
        </ol>
          
          <form  class="form-horizontal" role="form"action="addInterfaceAction.jsp" method="post" style="width:450px;margin-top:30px;">
              
             <div class="form-group">
                <label for="name" class="col-sm-4 control-label">Interface Name</label>
                <div class="col-sm-8">
                  <input type="text" class="form-control" maxlength="20" name="name" placeholder="Interface Name">
                </div>
              </div>
              
              <div class="form-group">
                <label for="ip" class="col-sm-4 control-label">Bind IP</label>
                <div class="col-sm-8">
                  <input type="text" class="form-control" name="ip" value="0.0.0.0" placeholder="Bind IP">
                </div>
              </div>
              
              <div class="form-group">
                <label for="port" class="col-sm-4 control-label">Interface Port</label>
                <div class="col-sm-8">
                  <input type="number" class="form-control" name="port" value="8080" placeholder="Interface Port">
                </div>
              </div>
              
              <div class="form-group">
                <label for="max_connection" class="col-sm-4 control-label">Max Connection</label>
                <div class="col-sm-8">
                  <input type="number" class="form-control" name="max_connection" value="100" placeholder="Max Connection">
                </div>
              </div>
              
              <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                  <div class="checkbox">
                    <label>
                      <input type="checkbox" name="auto_start" value="true" checked> Auto Start
                    </label>
                  </div>
                </div>
              </div>
              
              <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                  <div class="checkbox">
                    <label>
                      <input type="checkbox" name="ssl_offloaded" value="true" disabled> SSL Offloaded
                    </label>
                  </div>
                </div>
              </div>
              
              <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                  <button  name="submit" type="submit" class="btn btn-success" value="Add Interface">Add Interface</button>
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