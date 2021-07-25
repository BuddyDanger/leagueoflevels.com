<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!--#include virtual="/assets/asp/functions/sha256.asp"-->
<!DOCTYPE html>
<html lang="en">

	<head>



	</head>

	<body>

<%
		thisString = Request.QueryString("s")
		thisString = sha256(thisString)

		Response.Write(thisString)
%>

	</body>

</html>
