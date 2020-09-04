<%@ LANGUAGE="VBScript" %>
<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!--#include virtual="/assets/asp/sql/connection.asp"-->
<!--#include virtual="/assets/asp/framework/user.asp"-->
<!--#include virtual="/assets/asp/functions/sha256.asp" -->
<%
	Response.Buffer = True
	DeadPage = 1

	Function ParseForAbsolutePath (sRawURI)

		On Error Resume Next
		iStringStart = InStr(1, sRawURI, "//", 1)
		If iStringStart > 0 Then
			iStringStart = InStr(iStringStart+2, sRawURI, "/", 1)
			sFinalPath = Mid(sRawURI, iStringStart)
		End If
		If Err.Number <> 0 Then sFinalPath = ""
		On Error Goto 0
		ParseForAbsolutePath = sFinalPath

	End Function

	sAbsolutePath = ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))
	If Right(sAbsolutePath, 1) = "/" Then sAbsolutePath = Left(sAbsolutePath, Len(sAbsolutePath)-1)

	arCurrentPageInfo = Split(sAbsolutePath, "/")
	iCounter          = 0
	sTransferURL      = "/"
	sCurrentURL       = "/"

	If Right(sAbsolutePath, 9) = "index.asp" Then
		sAbsolutePath = Left(sAbsolutePath, Len(sAbsolutePath)-9)
		Response.Redirect(sAbsolutePath)
	End If

	Session.Contents("AbsolutePath") = sAbsolutePath

	Session.Contents("SITE_Level_1") = ""
	Session.Contents("SITE_Level_2") = ""
	Session.Contents("SITE_Level_3") = ""
	Session.Contents("SITE_Level_4") = ""
	Session.Contents("SITE_Level_5") = ""
	Session.Contents("SITE_Level_6") = ""
	Session.Contents("SITE_Level_7") = ""
	Session.Contents("SITE_Level_8") = ""
	Session.Contents("SITE_Level_9") = ""
	Session.Contents("SITE_Level_10") = ""
	Session.Contents("SITE_Level_11") = ""
	Session.Contents("SITE_Level_12") = ""

	i = 0
	LevelString = ""

	For Each Directory In arCurrentPageInfo

		If i = 1 Then
			Session.Contents("SITE_Level_1")  = LCase(Directory)
		ElseIf i = 2 Then
			Session.Contents("SITE_Level_2")  = LCase(Directory)
		ElseIf i = 3 Then
			Session.Contents("SITE_Level_3")  = LCase(Directory)
		ElseIf i = 4 Then
			Session.Contents("SITE_Level_4")  = LCase(Directory)
		ElseIf i = 5 Then
			Session.Contents("SITE_Level_5")  = LCase(Directory)
		ElseIf i = 6 Then
			Session.Contents("SITE_Level_6")  = LCase(Directory)
		ElseIf i = 7 Then
			Session.Contents("SITE_Level_7")  = LCase(Directory)
		ElseIf i = 8 Then
			Session.Contents("SITE_Level_8")  = LCase(Directory)
		ElseIf i = 9 Then
			Session.Contents("SITE_Level_9")  = LCase(Directory)
		ElseIf i = 10 Then
			Session.Contents("SITE_Level_10") = LCase(Directory)
		ElseIf i = 11 Then
			Session.Contents("SITE_Level_11") = LCase(Directory)
		ElseIf i = 12 Then
			Session.Contents("SITE_Level_12") = LCase(Directory)
		End If

		If i > 1 Then LevelString = LevelString & LCase(Directory) & "||"

		i = i + 1

	Next

	If Right(LevelString, 2) = "||" Then LevelString = Left(LevelString, Len(LevelString)-2)

	Session.Contents("SITE_Current_URL") = sCurrentURL

	Session.Contents("Scores_Matchup_ID") = ""

	If Session.Contents("SITE_Level_1") = "scores" Then

		If Len(Session.Contents("SITE_Level_2")) > 0 And IsNumeric(Session.Contents("SITE_Level_2")) Then

			Session.Contents("Scores_Matchup_ID") = Session.Contents("SITE_Level_2")

			sTransferURL = "matchup/index.asp"
			DeadPage = 0

		End If

	End If

	'*****************************************************
	'*** ACCOUNT *****************************************
	'*****************************************************
	If Session.Contents("SITE_Level_1") = "account" Then

		If Session.Contents("SITE_Level_2") = "verify" Then

			thisKey = Session.Contents("SITE_Level_3")
			If InStr(thisKey, "'") Then thisKey = Replace(thisKey, "'", "")

			sqlVerify = "SELECT AccountID, Email FROM Accounts WHERE Password = '" & thisKey & "'"
			Set rsVerify = sqlDatabase.Execute(sqlVerify)

			If Not rsVerify.Eof Then

				thisAccountID = rsVerify("AccountID")
				thisEmail = rsVerify("Email")

				sqlUpdate = "UPDATE Accounts SET VerificationDate = '" & Now() & "', Hash = '" & sha256(thisEmail) & "' WHERE AccountID = " & thisAccountID
				Set rsUpdate = sqlDatabase.Execute(sqlUpdate)

				Session.Contents("AccountVerified") = 1

				rsVerify.Close
				Set rsVerify = Nothing

				sqlGetTeams = "SELECT * FROM Teams WHERE EmailAddress = '" & thisEmail & "'"
				Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

				If Not rsTeams.Eof Then

					Do While Not rsTeams.Eof

						Set rsAddTeamLink = Server.CreateObject("ADODB.RecordSet")
						rsAddTeamLink.CursorType = adOpenKeySet
						rsAddTeamLink.LockType = adLockOptimistic
						rsAddTeamLink.Open "LinkAccountsTeams", sqlDatabase, , , adCmdTable
						rsAddTeamLink.AddNew

						rsAddTeamLink("AccountID") = thisAccountID
						rsAddTeamLink("TeamID") = rsTeams("TeamID")
						rsAddTeamLink.Update

						Set rsAddTeamLink = Nothing

						rsTeams.MoveNext

					Loop

					rsTeams.Close
					Set rsTeams = Nothing

				End If

				Response.Redirect("/account/login/")

			End If

		End If

		If Session.Contents("SITE_Level_2") = "reset-password" Then

			thisKey = Session.Contents("SITE_Level_3")
			If InStr(thisKey, "'") Then thisKey = Replace(thisKey, "'", "")

			sqlVerify = "SELECT AccountID, Email FROM Accounts WHERE Hash = '" & thisKey & "'"
			Set rsVerify = sqlDatabase.Execute(sqlVerify)

			If Not rsVerify.Eof Then

				Session.Contents("AccountID") = rsVerify("AccountID")
				Session.Contents("AccountEmail") = rsVerify("Email")
				Session.Contents("ResetVerified") = 1

				rsVerify.Close
				Set rsVerify = Nothing

				Response.Redirect("/account/reset-password/")

			End If

		End If

	End If

	'*****************************************************
	'*** BLOG ********************************************
	'*****************************************************
	If Session.Contents("SITE_Level_1") = "blog" Then

		Session.Contents("SITE_Blog_Range") = ""
		Session.Contents("SITE_Blog_Month") = ""
		Session.Contents("SITE_Blog_Year") = ""
		Session.Contents("SITE_BlogID") = ""

		arLevels = Split(LevelString, "||")
		IsSingleBlog = 0
		RebuildURL = 0
		LevelCount = 1
		DeadPage = 0

		For Each Level In arLevels

			MatchFound = 0
			StrippedLevel = Level
			If InStr(StrippedLevel, "-") Then StrippedLevel = Replace(StrippedLevel, "-", " ")

			If MatchFound = 0 Then
				sqlGetBlog = "SELECT BlogID, PostDate FROM Blogs WHERE BlogLink = '" & Level & "'"
				Set rsBlog = sqlDatabase.Execute(sqlGetBlog)
				If Not rsBlog.Eof Then

					Session.Contents("SITE_BlogID") = rsBlog("BlogID")
					Session.Contents("SITE_Blog_Month") = Month(rsBlog("PostDate"))
					Session.Contents("SITE_Blog_Year") = Year(rsBlog("PostDate"))
					Session.Contents("SITE_Blog_Day") = Day(rsBlog("PostDate"))

					sTransferURL = "post.asp"
					IsSingleBlog = 1
					MatchFound = 1
					DeadPage = 0

					rsBlog.Close
					Set rsBlog = Nothing

				Else
					IsSingleBlog = 0
				End If

			End If

			LevelCount = LevelCount + 1

		Next

		If IsSingleBlog = 0 Then sTransferURL = "index.asp"

	End If

	If DeadPage = 0 Then

		sFinalTransfer = "/" & Session.Contents("SITE_Level_1") & "/" & sTransferURL
		Server.Transfer(sFinalTransfer)
		'Response.Write(sqlGetBlog)
	Else
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
<title>404 - File or directory not found.</title>
<style type="text/css">
<!--
body{margin:0;font-size:.7em;font-family:Verdana, Arial, Helvetica, sans-serif;background:#EEEEEE;}
fieldset{padding:0 15px 10px 15px;}
h1{font-size:2.4em;margin:0;color:#FFF;}
h2{font-size:1.7em;margin:0;color:#CC0000;}
h3{font-size:1.2em;margin:10px 0 0 0;color:#000000;}
#header{width:96%;margin:0 0 0 0;padding:6px 2% 6px 2%;font-family:"trebuchet MS", Verdana, sans-serif;color:#FFF;
background-color:#555555;}
#content{margin:0 0 0 2%;position:relative;}
.content-container{background:#FFF;width:96%;margin-top:8px;padding:10px;position:relative;}
-->
</style>
</head>
<body>
<div id="header"><h1>Server Error</h1></div>
<div id="content">
 <div class="content-container"><fieldset>
  <h2>404 - File or directory not found.</h2>
  <h3>The resource you are looking for might have been removed, had its name changed, or is temporarily unavailable.</h3>
 </fieldset></div>
</div>
	<!--#include virtual="/assets/asp/framework/google.asp"-->

</body>
</html>
<%
	End If
%>
