<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/sha256.asp" -->
<%
	blockProfileDetailsSuccess = "d-none"
	blockAccountLogoSuccess = "d-none"
	blockPasswordSuccess = "d-none"
	blockProfileDetails = ""
	blockAccountLogo = ""
	blockPassword = ""

	AspMaxRequestEntityAllowed = 1073741824
	Set objFileUpload = Server.CreateObject("aspSmartUpload.SmartUpload")
	objFileUpload.Upload

	objFileUpload.AllowedFilesList = "jpg,gif,png"

	If objFileUpload.Files("AccountImage").FileName <> "" Then

		thisFilename = "icon-" & sha256(Session.Contents("Email") & Now())
		thisExt = objFileUpload.Files("AccountImage").FileExt

		objFileUpload.Files("AccountImage").SaveAs(Server.MapPath("/assets/images/uploads/" & thisFilename & "." & objFileUpload.Files("AccountImage").FileExt))

		Session.Contents("AccountImage") = thisFilename & "." & thisExt

		sqlUpdateAccount = "UPDATE Accounts SET ProfileImage = '" & Session.Contents("AccountImage") & "' WHERE AccountID = " & Session.Contents("AccountID")
		Set rsUpdate = sqlDatabase.Execute(sqlUpdateAccount)

	End If

	Response.Redirect("/account/")
%>
