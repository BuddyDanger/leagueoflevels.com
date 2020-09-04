<%@ LANGUAGE="VBScript" %>
<!--#include virtual="/adovbs.inc" -->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<%
	thisAction = Request.Form("action")

	If thisAction = "go" Then

		thisAccountID = Session.Contents("AccountID")

		Set rsExisting = sqlDatabase.Execute("SELECT * FROM WaitingList WHERE AccountID = " & Session.Contents("AccountID"))

		If rsExisting.Eof Then

			Set rsInsert = Server.CreateObject("ADODB.RecordSet")
			rsInsert.CursorType = adOpenKeySet
			rsInsert.LockType = adLockOptimistic
			rsInsert.Open "WaitingList", sqlDatabase, , , adCmdTable
			rsInsert.AddNew

			rsInsert("AccountID") = Session.Contents("AccountID")

			rsInsert.Update
			Set rsInsert = Nothing

		Else

			rsExisting.Close
			Set rsExisting = Nothing

		End If

	End If

	Response.Redirect("/")
%>
