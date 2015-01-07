<%@ page import="java.util.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<%@ page import="org.quickserver.net.client.*" %>
<%@ page import="java.util.logging.*" %>
<%!
	private static final Logger logger = Logger.getLogger("admin.u.interface.editNodes.jsp");
%>
<!DOCTYPE html>
<html lang="en">
  <head>
	<%
	String interfaceName = request.getParameter("name");
	boolean showGif = false;
	if(interfaceName==null) {
		response.sendRedirect("index.jsp?error=No Interface Name passed");
		return;
	}
	String action = request.getParameter("action");

	if(action!=null) {
		if(action.equals("restart")) {
			showGif = true;
	%>
	<meta http-equiv="refresh" content="3; URL=editInterfaceAction.jsp?name=<%=interfaceName%>&submit=Restart Interface">
	<%
		}
	}
	%>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>QuickLB Admin | <%=interfaceName%> | Edit Nodes</title>
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
    
    <%


        Map<String,InterfaceServer> map = InterfaceServer.getInterfaces();
        InterfaceServer is = map.get(interfaceName);

        if(is==null) {
            response.sendRedirect("index.jsp?error=Bad Interface Name passed");
            return;
        }
    %>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li><a href="listInterface.jsp">Interface Overview</a></li>
            <li class="active"><a href="addInterface.jsp">Add New Interface</a></li>
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
            <li class="active">Edit Nodes</li>
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

                    
                    
                   <blockquote  class="bg-info">
                        <span>Interface details</span>
                    
                        <a  class="btn btn-primary btn-xs active" style="float: right; margin-right: 10px; margin-top: 3px;" href="editInterface.jsp?name=<%=interfaceName%>">Edit Interface</a>
                        <form  style="clear: none;width: 100px;float: right;" action="editInterfaceAction.jsp" method="post" style="clear:both">
                            <input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
                            <%if(is.getQuickserver().isClosed()){%>
                            <button type="submit" name="submit" value="Start Interface" class="btn btn-success btn-xs">Start Interface</button>
                        <%}else{%>
                             <button type="submit" name="submit" value="Stop Interface" class="btn btn-xs btn-warning">Stop Interface</button>
                         <%}%>
                        </form>

                    </blockquote>
                    
                      <div class="table-responsive">
                        <table class="table table-condensed table-bordered">
                          <thead>
                            <tr>
                              <th>IP</th>
                              <th>Port</th>
                              <th>Auto Start</th>
                              <th>SSL Offloaded</th>
                              <th>Running</th>
                              <th>Max Connection</th>
                              <th>Current Connection</th>
                              <th>Up Time</th>
                            </tr>
                          </thead>

                          <tbody>
                            <tr>

                                <td><%=is.getQuickserver().getBindAddr().getHostAddress()%></td>

                                <td><%=is.getQuickserver().getPort()%></td>

                                <td><%=is.isAutoStart()%></td>

                                <td><%=is.getQuickserver().isRunningSecure()%></td>

                                <td><%=!is.getQuickserver().isClosed()%></td>

                                <td><%=is.getQuickserver().getMaxConnection()%></td>

                                <td><%=is.getQuickserver().getClientCount()%></td>

                                <td><%=is.getQuickserver().getUptime()%></td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                       
                       <blockquote  class="bg-info" style="margin-top: 40px;">
                            <span>Available Nodes</span>
                            <a  class="btn btn-primary btn-xs active" style="float: right; margin-right: 10px; margin-top: 3px;" href="addNode.jsp?name=<%=interfaceName%>">Add New Node</a>
                        </blockquote>
                          
                            
                        <div class="table-responsive">
                        <table class="table table-condensed table-bordered">
                          <thead>
                            <tr>
                              <th>Node Name</th>
                              <th>Host</th>
                              <th>Port</th>
                              <th>SSL</th>
                              <th>Timeout</th>
                              <th>Default</th>
                              <th>Maintenance</th>
                              <th>Status</th>
                              <th>Up Time</th>
                              <th>Action</th>
                            </tr>
                          </thead>
                          <tbody>
                            <%
                                InterfaceHosts ih = is.getInterfaceHosts();
                                HostList hostList = null;
                                logger.fine("hostList: "+hostList);

                                List<SocketBasedHost> list = null;

                                if(ih!=null) {
                                    hostList = ih.getHostList();
                                }
                                if(hostList!=null) {
                                    list = (List<SocketBasedHost>)hostList.getFullList();
                                    logger.fine("list "+list);
                                } else {
                                    logger.fine("host list was null!");
                                }

                                if(list==null || list.isEmpty()) {
                            %>
                            
                            <tr>
                                <td colspan="10" align="center">
                                    <p class="text-danger">No Nodes Visible. Please Make sure interface is UP</p>
                                </td>
                            </tr>
                            
                            <%} else {
                                for(int i=0;i<list.size();i++) {
                            %>
                          
                            <tr>
                                <td><%=InterfaceHosts.getRealNodeName(list.get(i))%></td>

                                <td><%=list.get(i).getInetAddress().getHostAddress()%></td>

                                <td><%=list.get(i).getInetSocketAddress().getPort()%></td>

                                <td><%=list.get(i).isSecure()%></td>

                                <td><%=list.get(i).getTimeout()%></td>

                                <td><%=i==0?true:false%></td>

                                <td><%=list.get(i).getStatus()==Host.MAINTENANCE?true:false%></td>

                                <td><%=list.get(i).getStatus()%></td>
                                
                                <td><%=list.get(i).getUptime()%></td>
                                
                                <td>
                                    <form action="editNode.jsp" method="post">
                                            <input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
                                            <input name="node_name" size="20" type="hidden" value="<%=list.get(i).getName()%>"/>
                                            <input name="node_default" size="20" type="hidden" value="<%=i==0?true:false%>"/>

                                            <input class="btn btn-primary btn-xs active" name="submit" size="10" value="Edit Node" type="submit"/>

                                    </form>
                                </td>
                            </tr>
                            	<%
                            }//for

                        }
                            %>
                          </tbody>
                        </table>
                      </div>
                            
                            
                       <blockquote  class="bg-info" style="margin-top: 40px;">
                            <span>Distribution parameters </span>
                        </blockquote>
                          
                        
      <div class="row">            
		<div style="width:450px;margin-top:30px; margin-left: 15px;">
            <form class="form-horizontal" action="editNodesAction.jsp" method="post" role="form">
              <input name="name" size="20" type="hidden" value="<%=interfaceName%>"/>
              <div class="form-group">
                <label for="distribution" class="col-sm-6 control-label">Method</label>
                <div class="col-sm-6">
                    <%
                    String dis = is.getDistribution();
                    %>
                    <select name="distribution" class="form-control" >
                        <option value="ip_based" <%=dis.equals("ip_based")?"selected":""%>>Client IP Based (sticky)</option>
                        <option value="roundrobin" <%=dis.equals("roundrobin")?"selected":""%>>Roundrobin</option>
                        <option value="failover" <%=dis.equals("failover")?"selected":""%>>Failover</option>
                        <option value="random" <%=dis.equals("random")?"selected":""%>>Random</option>
                    </select>	
                </div>
              </div>

              <div class="form-group">
                <label for="monitoringIntervalInSec" class="col-sm-6 control-label">Monitoring Interval (In Sec)</label>
                <div class="col-sm-6">
                  <input type="number" class="form-control" name="monitoringIntervalInSec" value="<%=is.getMonitoringIntervalInSec()%>">
                </div>
              </div>

              <div class="form-group">
                <div class="col-sm-offset-6 col-sm-6">
                  <button  name="submit" type="submit" class="btn btn-success" value="Update Interface">Update Interface</button>
                </div>
              </div>
            </form>
		</div>
      </div>

          
        </div>
      </div>
    </div>

    <script src="/scripts/jquery.min.js"></script>
    <script src="/scripts/bootstrap.min.js"></script>
    <script src="/scripts/docs.min.js"></script>
  </body>
</html>