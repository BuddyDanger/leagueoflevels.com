<%@ LANGUAGE="VBScript" %>
<!--#include virtual="/adovbs.inc" -->
<%
	Response.Cookies("AccountID").Expires = Date() - 1
	Response.Cookies("AccountHash").Expires = Date() - 1

	Session.Contents.Remove("LoggedIn")
	Session.Contents.Remove("AccountID")
	Session.Contents.Remove("AccountHash")
	Session.Contents.Remove("AccountEmail")
	Session.Contents.Remove("AccountName")
	Session.Contents.Remove("AccountImage")

	Response.Redirect("/")
%>
