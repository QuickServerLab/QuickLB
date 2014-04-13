<!DOCTYPE html>
<html lang="en">

  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>QuickLB Admin | Change password</title>
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/dashboard.css" rel="stylesheet">
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  
	<%
		String user = request.getParameter("user");
		if(user==null) {
			return;
		}
     %>   
  
	<body>
	<%@ include file="/u/header.jsp" %>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li><a href="/u/interface/listInterface.jsp">Interface Overview</a></li>
            <li><a href="/u/interface/addInterface.jsp">Add New Interface</a></li>
            <li><a href="/u/interface/reloadInterfaceAction.jsp">Reload All Interfaces</a></li>
            <li><hr/></li>
            <li><a href="/u/stat/index.jsp">Stats</a></li>
          </ul>
          <%@ include file="/u/footer.jsp" %>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

        <ol class="breadcrumb" style="font-size:1.3em;">
            <li><a href="#">QuickLB</a></li>
            <li class="active">Change password</li>
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
            
            
          
          <form  class="form-horizontal" role="form" action="/UserValidatorServlet" method="post" style="width:450px;margin-top:20px;">
              
             <div class="form-group">
                <label for="username" class="col-sm-4 control-label">Username</label>
                <div class="col-sm-8">
                  <input type="text" class="form-control" maxlength="20" name="username" readonly value="<%=user%>">
                </div>
              </div>
              
              <div class="form-group">
                <label for="oldpassword" class="col-sm-4 control-label">Old Password</label>
                <div class="col-sm-8">
                  <input type="password" class="form-control" name="oldpassword" placeholder="Old Password">
                </div>
              </div>
              
              <div class="form-group">
                <label for="password" class="col-sm-4 control-label">Host Port</label>
                <div class="col-sm-8">
                  <input type="password" class="form-control" name="password" placeholder="New password">
                </div>
              </div>
                
              <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                  <button  name="action" type="submit" class="btn btn-success" value="Change Password">Change Password</button>
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