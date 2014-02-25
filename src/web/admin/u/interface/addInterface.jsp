<html>
<head>
	<title>QuickLB Admin - Add Interface</title>
</head>
<body>

<center><h4>Add Interface</h4></center>

<a href="../../index.jsp">Home</a> <br/>

<a href="index.jsp">Interface List</a><br/>&nbsp;<br/>

<form action="addInterfaceAction.jsp" method="post">
<table border="1">
		<tr>
			<td>
				Interface Name
			</td>
			<td>
				<input name="name" size="20" type="text"/>
			<td>
		</tr>

		<tr>
			<td>
				Interface Bind IP
			</td>
			<td>
				<input name="ip" size="20" value="0.0.0.0" type="text"/>
			<td>
		</tr>

		<tr>
			<td>
				Interface Port
			</td>
			<td>
				<input name="port" size="10" value="80" type="number"/>
			<td>
		</tr>

		<tr>
			<td>
				Auto Start
			</td>
			<td>
				<input name="auto_start" value="true" type="checkbox" checked />
			<td>
		</tr>

		<tr>
			<td>
				SSL Offloaded
			</td>
			<td>
				<input name="ssl_offloaded" value="true" type="checkbox" disabled />
			<td>
		</tr>

		<tr>
			<td>
				Mac Connection
			</td>
			<td>
				<input name="max_connection" size="10" value="100" type="number"/>
			<td>
		</tr>

		<tr>
			<td colspan="2" align="center">
				
				<input name="submit" size="10" value="Add Interface" type="submit"/>
			<td>
		</tr>
</table>
</form>

</body>
</html>