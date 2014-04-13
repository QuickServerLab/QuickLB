    <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">QuickLB Web Admin</a>
        </div>
        <%
            String username = (String) session.getAttribute("username");
        %>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="/u/interface/index.jsp">Home</a></li>
            <li><a href="/u/changePassword.jsp?user=<%=username%>">Change Password</a></li>
            <li><a href="/logout.jsp">Logout</a></li>
            <li><a href="#">Help</a></li>
          </ul>
        </div>
      </div>
    </div>
