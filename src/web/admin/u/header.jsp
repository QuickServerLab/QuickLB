<table width="100%" height="100%">
	<tr>
		<td bgcolor="#fafafa" width="100%" height="10">
			<table width="100%">
				<tr>
					<td >
						<br/>
						&nbsp;&nbsp;QuickLB Web Admin
					</td>		
				</tr>	
			</table>
			<br/>

		</td>
	</tr>
	<tr>
		<td width="100%" height="10">
			<table width="100%">
				<tr>
					<td width="70%">
						<%
						String username = (String) session.getAttribute("username");
						%>

						<a href="index.jsp">Home</a> 
					</td>
					<td width="30%" align="right">

						<a href="changePassword.jsp?user=<%=username%>">Change Password</a> |  <a href="/logout.jsp">Logout</a>
					</td>		
				</tr>	
			</table>
		</td>
	</tr>

	<tr width="100%" height="*">
		<td >


