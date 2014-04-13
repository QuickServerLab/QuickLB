<%@ page import="java.util.*" %>
<%@ page import="com.quickserverlab.quicklb.*" %>
<%@ page import="com.quickserverlab.quicklb.server.*" %>
<%@ page import="org.quickserver.net.server.*" %>
<%@ page import="org.quickserver.util.*" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>QuickLB Admin | Statistics</title>
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/dashboard.css" rel="stylesheet">
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
<%!
	Runtime runtime = Runtime.getRuntime();
%>
  <body>
      
    <%@ include file="/u/header.jsp" %>    

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li><a href="../interface/listInterface.jsp">Interface Overview</a></li>
            <li><a href="../interface/addInterface.jsp">Add New Interface</a></li>
            <li><a href="../interface/reloadInterfaceAction.jsp">Reload All Interfaces</a></li>
            <li><hr/></li>
            <li class="active"><a href="#">Stats</a></li>
          </ul>
            
          <%@ include file="/u/footer.jsp" %>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            
        <ol class="breadcrumb" style="font-size:1.3em;">
            <li><a href="/u/interface/index.jsp">QuickLB</a></li>
            <li class="active">Statistics</li>
        </ol>
          
                                
           <blockquote  class="bg-info">
                <span>Process Information</span>
            </blockquote>
            
            <div class="row">
                
                <div class="col-md-3">
                    <div class="row ">
                        <div class="post-header-line" style="margin-left: 15px; border-top:0px; ">
                            <span style="font-size:12px;">
                                <strong>PID : </strong>
                                <span class="badge"><%=QuickServer.getPID()%></span>
                            </span>
                        </div>
                    </div>
                    <div class="row ">
                        <div class="post-header-line" style="margin-left: 15px; border-top:0px; ">
                            <span style="font-size:12px;">
                                <strong>Up time : </strong>
                                <span class="badge"><%=JvmUtil.getUptime(QuickLB.getStartTime())%></span>
                            </span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="post-header-line" style="margin-left: 15px; border-top:0px; ">
                            <span style="font-size:12px;">
                                <strong>Java version : </strong>
                                <span class="badge"><%=System.getProperty("java.version")%></span>
                            </span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="post-header-line" style="margin-left: 15px; border-top:0px; ">
                            <span style="font-size:12px;">
                                <strong>QuickServer version : </strong>
                                <span class="badge"><%=QuickServer.getVersion()%></span>
                            </span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="post-header-line" style="margin-left: 15px; border-top:0px; ">
                            <span style="font-size:12px;">
                                <strong>Operating System : </strong>
                                <span class="badge"><%=System.getProperty("os.name") + " " + System.getProperty("os.version")%></span>
                            </span>
                        </div>
                    </div>
                </div>
                        
                <div class="col-md-8" style="padding-left:30px;">
                    
                    <%
                    
                    long maxMem = runtime.maxMemory();
                    long usedmemeory = runtime.totalMemory()-runtime.freeMemory();
                    long availableMemory = runtime.totalMemory();
                    
                    long usedPc = ((100*usedmemeory)/maxMem);
                    String usedPcClass = "progress-bar-info";
                    if(usedPc < 40 ){
                        usedPcClass = "progress-bar-success";
                    }else if(usedPc > 40 && usedPc < 80){
                        usedPcClass = "progress-bar-warning";
                    }else{
                        usedPcClass = "progress-bar-danger";
                    }
                    
                    long avaialblePc = ((100*availableMemory)/maxMem);
                    String avaialblePcClass = "progress-bar-info";
                    if(avaialblePc < 40 ){
                        avaialblePcClass = "progress-bar-success";
                    }else if(avaialblePc > 40 && avaialblePc < 80){
                        avaialblePcClass = "progress-bar-warning";
                    }else{
                        avaialblePcClass = "progress-bar-danger";
                    }
                    
                    %>
                    
                    Maximum memory available : <%=MyString.getMemInfo(maxMem)%>
                    <div class="progress">
                      <div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%;">
                         <%=MyString.getMemInfo(maxMem)%>
                      </div>
                    </div> 
                      
                    Total memory currently available : <%=MyString.getMemInfo(availableMemory)%>
                    <div class="progress">
                      <div class="progress-bar <%=avaialblePcClass%>" role="progressbar" aria-valuenow="<%=avaialblePc%>" aria-valuemin="0" aria-valuemax="100" style="width: <%=avaialblePc%>%;">
                         <%=avaialblePc%>%
                      </div>
                    </div>
                    
                    Memory currently in use : <%=MyString.getMemInfo(usedmemeory)%>
                    <div class="progress">
                      <div class="progress-bar <%=usedPcClass%>" role="progressbar" aria-valuenow="<%=usedPc%>" aria-valuemin="0" aria-valuemax="100" style="width: <%=usedPc%>%;">
                         <%=usedPc%>%
                      </div>
                    </div>
                      
                </div>
                                    

                
            </div>
                      
           <blockquote  class="bg-info">
                <span>Connection Information</span>
            </blockquote>
            
	<%
		Map<String,InterfaceServer> map = InterfaceServer.getInterfaces();

		Iterator<String> iterator = map.keySet().iterator();
		String key = null;
		InterfaceServer is = null;
        boolean hasRow = false;
	%>
    
          
          <div class="table-responsive">
            <table class="table table-bordered table-condensed table-hover" >
              <thead>
                <tr>
                  <th rowspan="2"></th>
                  <th style="text-align:center;" rowspan="2">IP</th>
                  <th style="text-align:center;" rowspan="2">Port</th>
                  <th style="text-align:center;" colspan="4">Connection</th>
                  <th style="text-align:center;" colspan="2">Bytes</th>
                  <th style="text-align:center;" rowspan="2">Dropped</th>
                  <th style="text-align:center;" rowspan="2">Error</th>
                  <th style="text-align:center;" rowspan="2">Uptime</th>
                  <th style="text-align:center;" rowspan="2">Downtime</th>
                </tr>
                <tr>
                  <th style="text-align:center;" >Count</th>
                  <th style="text-align:center;" >Current</th>
                  <th style="text-align:center;" >Max</th>
                  <th style="text-align:center;" >Limit</th>
                  <th style="text-align:center;" >In</th>
                  <th style="text-align:center;" >Out</th>
                </tr>
              </thead>
              
              <tbody>
                  
	<%
    String intStatus = "";
	while(iterator.hasNext()) {
        hasRow = true;
		key = iterator.next();
		is = map.get(key);
        if(!is.getQuickserver().isClosed()){
            intStatus = "success";
        }else{
            intStatus = "danger";
        }
		%>
		<tr>
			<td class="<%=intStatus%>" style="text-align:center;"><strong><%=key%></strong></td>

			<td style="text-align:center;" ><%=is.getQuickserver().getBindAddr().getHostAddress()%></td>

			<td style="text-align:center;" ><%=is.getQuickserver().getPort()%></td>
			
			<td style="text-align:center;" ><%=is.getStats().getClientCount().get()%></td>
			
			<td style="text-align:center;" ><%=is.getQuickserver().getClientCount()%></td>

			<td style="text-align:center;" ><%=is.getQuickserver().getHighestActiveClientCount()%></td>
			
			<td style="text-align:center;" ><%=is.getQuickserver().getMaxConnection()%></td>
			

			<td style="text-align:center;" ><%=is.getStats().getInByteCount().get()%></td>
			<td style="text-align:center;" ><%=is.getStats().getOutByteCount().get()%></td>

			<td style="text-align:center;" ><%=is.getStats().getDroppedCount().get()%></td>
			<td style="text-align:center;" ><%=is.getStats().getConErrorCount().get()%></td>
			
			<td style="text-align:center;" ><%=is.getQuickserver().getUptime()%></td>
			<td style="text-align:center;" ><%=is.getStats().getDownTimeText()%></td>
            
		</tr>

		<%

	}//end while
%>
              </tbody>
            </table>
          </div>
             
    <%if(hasRow==false) {%>
        <div class="alert alert-warning">
            No interfaces added
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
