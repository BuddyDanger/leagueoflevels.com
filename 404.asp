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

			sqlVerify = "SELECT AccountID, Email FROM Accounts WHERE Password = '" & thisKey & "' AND Hash IS NULL AND VerificationDate IS NULL"
			Set rsVerify = sqlDatabase.Execute(sqlVerify)

			If Not rsVerify.Eof Then

				thisAccountID = rsVerify("AccountID")
				thisEmail = rsVerify("Email")

				sqlUpdate = "UPDATE Accounts SET VerificationDate = '" & Now() & "', Hash = '" & sha256(thisEmail) & "' WHERE AccountID = " & thisAccountID
				Set rsUpdate = sqlDatabase.Execute(sqlUpdate)

				Session.Contents("AccountVerified") = 1

				rsVerify.Close
				Set rsVerify = Nothing

				sqlCheckDeposits = "SELECT * FROM SchmeckleTransactions WHERE AccountID = " & thisAccountID & " AND TransactionTypeID = 1000 AND TransactionTotal = 5000"
				Set rsDeposits   = sqlDatabase.Execute(sqlCheckDeposits)

				If rsDeposits.Eof Then
					Set rsAddSchmeckles = Server.CreateObject("ADODB.RecordSet")
					rsAddSchmeckles.CursorType = adOpenKeySet
					rsAddSchmeckles.LockType = adLockOptimistic
					rsAddSchmeckles.Open "SchmeckleTransactions", sqlDatabase, , , adCmdTable
					rsAddSchmeckles.AddNew
					rsAddSchmeckles("TransactionTypeID") = 1000
					rsAddSchmeckles("TransactionTotal") = 5000
					rsAddSchmeckles("AccountID") = thisAccountID
					rsAddSchmeckles.Update
					Set rsAddSchmeckles = Nothing
				End If

				'ATTACH TEAMS'
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

	'*****************************************************
	'*** BET  ********************************************
	'*****************************************************
	If Session.Contents("SITE_Level_1") = "sportsbook" Then

		Session.Contents("SITE_Bet_MatchupID") = ""
		Session.Contents("SITE_Bet_Type") = ""

		arLevels = Split(LevelString, "||")
		RebuildURL = 0
		LevelCount = 1
		DeadPage = 0

		For Each Level In arLevels

			MatchFound = 0
			StrippedLevel = Level
			If InStr(StrippedLevel, "-") Then StrippedLevel = Replace(StrippedLevel, "-", " ")

			If MatchFound = 0 And Level = "nfl" Then
				Session.Contents("SITE_Bet_Type") = "nfl"
				MatchFound = 1
			End If

			If MatchFound = 0 And IsNumeric(Level) Then

				If Session.Contents("SITE_Bet_Type") = "nfl" Then
					sqlGetMatchup = "SELECT NFLGameID AS MatchupID FROM NFLGames WHERE NFLGameID = " & Level
				Else
					sqlGetMatchup = "SELECT MatchupID FROM Matchups WHERE MatchupID = " & Level
				End If

				Set rsMatchup = sqlDatabase.Execute(sqlGetMatchup)
				If Not rsMatchup.Eof Then

					Session.Contents("SITE_Bet_MatchupID") = rsMatchup("MatchupID")

					sTransferURL = "matchup.asp"
					MatchFound = 1
					IsSingleMatchup = 1
					DeadPage = 0

					rsMatchup.Close
					Set rsMatchup = Nothing

				Else
					IsSingleMatchup = 0
				End If

			End If

			LevelCount = LevelCount + 1

		Next

		If IsSingleMatchup = 0 Then sTransferURL = "index.asp"

	End If

	'*****************************************************
	'*** SCHMECKLES  *************************************
	'*****************************************************
	If Session.Contents("SITE_Level_1") = "schmeckles" Then

		Session.Contents("SITE_Schmeckles_AccountID") = ""
		Session.Contents("SITE_Schmeckles_TransactionHash") = ""
		Session.Contents("SITE_Schmeckles_AccountID") = ""
		Session.Contents("SITE_Schmeckles_AccountProfileName") = ""
		Session.Contents("SITE_Schmeckles_TypeID") = ""
		Session.Contents("SITE_Schmeckles_TypeTitle") = ""

		arLevels = Split(LevelString, "||")
		RebuildURL = 0
		LevelCount = 1
		DeadPage = 0

		For Each Level In arLevels

			MatchFound = 0
			StrippedLevel = Level
			If InStr(StrippedLevel, "-") Then StrippedLevel = Replace(StrippedLevel, "-", " ")

			If MatchFound = 0 Then

				sqlCheckTransaction = "SELECT TransactionHash FROM SchmeckleTransactions WHERE TransactionHash = '" & Level & "'"
				Set rsTransaction = sqlDatabase.Execute(sqlCheckTransaction)

				If Not rsTransaction.Eof Then

					Session.Contents("SITE_Schmeckles_TransactionHash") = rsTransaction("TransactionHash")

					rsTransaction.Close
					Set rsTransaction = Nothing

					sTransferURL = "transactions/detail.asp"

					MatchFound = 1

				End If

			End If

			If MatchFound = 0 Then

				sqlCheckAccounts = "SELECT * FROM Accounts WHERE ProfileURL = '" & Level & "'"
				Set rsAccounts = sqlDatabase.Execute(sqlCheckAccounts)

				If Not rsAccounts.Eof Then

					Session.Contents("SITE_Schmeckles_AccountID") = rsAccounts("AccountID")
					Session.Contents("SITE_Schmeckles_AccountProfileName") = rsAccounts("ProfileName")

					rsAccounts.Close
					Set rsAccounts = Nothing

					sTransferURL = "transactions/index.asp"

					MatchFound = 1

				End If

			End If

			If MatchFound = 0 Then

				sqlCheckTypes = "SELECT * FROM SchmeckleTransactionTypes WHERE TransactionTypeSafeTitle = '" & Level & "'"
				Set rsTypes = sqlDatabase.Execute(sqlCheckTypes)

				If Not rsTypes.Eof Then

					Session.Contents("SITE_Schmeckles_TypeID") = rsTypes("TransactionTypeID")
					Session.Contents("SITE_Schmeckles_TypeTitle") = rsTypes("TransactionTypeTitle")

					rsTypes.Close
					Set rsTypes = Nothing

					sTransferURL = "transactions/index.asp"

					MatchFound = 1

				End If

			End If

			If MatchFound = 0 And Session.Contents("SITE_Level_2") = "redeem" Then

				sqlCheckRedemption = "SELECT * FROM SchmeckleRedemptions WHERE RedemptionCode = '" & Level & "'"
				Set rsRedemption = sqlDatabase.Execute(sqlCheckRedemption)

				If Not rsRedemption.Eof Then

					Session.Contents("SITE_Schmeckles_RedemptionID") = rsRedemption("RedemptionID")

					rsRedemption.Close
					Set rsRedemption = Nothing

					sTransferURL = "redeem.asp"

					MatchFound = 1

				End If

			End If

			LevelCount = LevelCount + 1

		Next

	End If

	'*****************************************************
	'*** TICKETS     *************************************
	'*****************************************************
	If Session.Contents("SITE_Level_1") = "sportsbook" And Session.Contents("SITE_Level_2") = "tickets" Then

		Session.Contents("SITE_Tickets_AccountID") = ""
		Session.Contents("SITE_Tickets_AccountProfileName") = ""
		Session.Contents("SITE_Tickets_TypeID") = ""
		Session.Contents("SITE_Tickets_TypeTitle") = ""
		Session.Contents("SITE_Tickets_Progress") = ""

		arLevels = Split(LevelString, "||")
		RebuildURL = 0
		LevelCount = 1
		DeadPage = 0

		For Each Level In arLevels

			MatchFound = 0
			StrippedLevel = Level
			If InStr(StrippedLevel, "-") Then StrippedLevel = Replace(StrippedLevel, "-", " ")

			If MatchFound = 0 Then

				If Level = "active" Then

					Session.Contents("SITE_Tickets_Processed") = "active"

					sTransferURL = "tickets/index.asp"

					MatchFound = 1

				End If

			End If

			If MatchFound = 0 Then

				sqlCheckAccounts = "SELECT * FROM Accounts WHERE ProfileURL = '" & Level & "'"
				Set rsAccounts = sqlDatabase.Execute(sqlCheckAccounts)

				If Not rsAccounts.Eof Then

					Session.Contents("SITE_Tickets_AccountID") = rsAccounts("AccountID")
					Session.Contents("SITE_Tickets_AccountProfileName") = rsAccounts("ProfileName")

					rsAccounts.Close
					Set rsAccounts = Nothing

					sTransferURL = "tickets/index.asp"

					MatchFound = 1

				End If

			End If

			If MatchFound = 0 Then

				sqlCheckTypes = "SELECT * FROM TicketTypes WHERE TypeSafeTitle = '" & Level & "'"
				Set rsTypes = sqlDatabase.Execute(sqlCheckTypes)

				If Not rsTypes.Eof Then

					Session.Contents("SITE_Tickets_TypeID") = rsTypes("TicketTypeID")
					Session.Contents("SITE_Tickets_TypeTitle") = rsTypes("TypeTitle")

					rsTypes.Close
					Set rsTypes = Nothing

					sTransferURL = "tickets/index.asp"

					MatchFound = 1

				End If

			End If

			LevelCount = LevelCount + 1

		Next

	End If

	'*****************************************************
	'*** TRANSACTIONS  ***********************************
	'*****************************************************
	If Session.Contents("SITE_Level_1") = "transactions" Then

		Session.Contents("SITE_Transactions_LevelID") = ""

		arLevels = Split(LevelString, "||")
		RebuildURL = 0
		LevelCount = 1
		DeadPage = 0

		For Each Level In arLevels

			MatchFound = 0
			StrippedLevel = Level
			If InStr(StrippedLevel, "-") Then StrippedLevel = Replace(StrippedLevel, "-", " ")

			If Level = "same-level" Then Session.Contents("SITE_Transactions_LevelID") = 2
			If Level = "farm-level" Then Session.Contents("SITE_Transactions_LevelID") = 3
			If Level = "omega-level" Then Session.Contents("SITE_Transactions_LevelID") = 1

			sTransferURL = "index.asp"

		Next

	End If

	'*****************************************************
	'*** STANDINGS ***************************************
	'*****************************************************
	If Session.Contents("SITE_Level_1") = "standings" Then

		Session.Contents("SITE_Standings_LevelID") = ""
		Session.Contents("SITE_Standings_Start_Year") = Year(Now())
		Session.Contents("SITE_Standings_End_Year") = Year(Now())
		Session.Contents("SITE_Standings_Start_Period") = "1"
		Session.Contents("SITE_Standings_End_Period") = "17"

		arLevels = Split(LevelString, "||")
		IsSingleTeam = 0
		LevelCount = 1

		For Each Level In arLevels

			MatchFound = 0
			StrippedLevel = Level
			If InStr(StrippedLevel, "-") Then StrippedLevel = Replace(StrippedLevel, "-", " ")

			If MatchFound = 0 Then

				sqlGetLevel = "SELECT LevelID FROM Levels WHERE Title = '" & StrippedLevel & "'"
				Set rsLevel = sqlDatabase.Execute(sqlGetLevel)

				If Not rsLevel.Eof Then

					Session.Contents("SITE_Standings_LevelID") = rsLevel("LevelID")
					MatchFound = 1 : DeadPage = 0

					rsLevel.Close
					Set rsLevel = Nothing

				End If

			End If

			If MatchFound = 0 Then

				If IsNumeric(Level) Then

					If CInt(Level) >= 2008 And CInt(Level) <= Year(Now()) Then

						Session.Contents("SITE_Standings_Start_Year") = Level
						Session.Contents("SITE_Standings_End_Year") = Level
						MatchFound = 1 : DeadPage = 0

					End If

					If MatchFound = 0 And CInt(Level) >= 1 And CInt(Level) <= 18 Then

						Session.Contents("SITE_Standings_Start_Period") = Level
						Session.Contents("SITE_Standings_End_Period") = Level
						MatchFound = 1 : DeadPage = 0

					End If

				Else

					If InStr(Level, "-") Then

						arrSplit = Split(Level, "-")

						If IsNumeric(arrSplit(0)) And IsNumeric(arrSplit(1)) Then

							If CInt(arrSplit(0)) >= 2008 And CInt(arrSplit(1)) <= Year(Now()) Then

								Session.Contents("SITE_Standings_Start_Year") = arrSplit(0)
								Session.Contents("SITE_Standings_End_Year") = arrSplit(1)
								MatchFound = 1 : DeadPage = 0

							End If

							If MatchFound = 0 And CInt(arrSplit(0)) >= 1 And CInt(arrSplit(1)) <= 18 Then

								Session.Contents("SITE_Standings_Start_Period") = arrSplit(0)
								Session.Contents("SITE_Standings_End_Period") = arrSplit(1)
								MatchFound = 1 : DeadPage = 0

							End If

						End If

					End If

				End If

			End If

			LevelCount = LevelCount + 1

		Next

		If IsSingleBlog = 0 Then sTransferURL = "index.asp"

	End If

	'*****************************************************
	'*** SCHEDULE ****************************************
	'*****************************************************
	If Session.Contents("SITE_Level_1") = "schedule" Then

		Session.Contents("SITE_Schedule_LevelID") = ""
		Session.Contents("SITE_Schedule_TeamID") = ""
		Session.Contents("SITE_Schedule_Year") = ""
		Session.Contents("SITE_Schedule_Period") = ""

		arLevels = Split(LevelString, "||")
		IsSingleTeam = 0
		LevelCount = 1

		For Each Level In arLevels

			MatchFound = 0
			StrippedLevel = Level
			If InStr(StrippedLevel, "-") Then StrippedLevel = Replace(StrippedLevel, "-", " ")

			If MatchFound = 0 Then

				sqlGetLevel = "SELECT LevelID, Title FROM Levels WHERE Title = '" & StrippedLevel & "'"
				Set rsLevel = sqlDatabase.Execute(sqlGetLevel)

				If Not rsLevel.Eof Then

					Session.Contents("SITE_Schedule_LevelID") = rsLevel("LevelID")
					Session.Contents("SITE_Schedule_LevelTitle") = rsLevel("Title")
					MatchFound = 1 : DeadPage = 0

					rsLevel.Close
					Set rsLevel = Nothing

				End If

			End If

			If MatchFound = 0 Then

				If IsNumeric(Level) Then

					If CInt(Level) >= 2008 And CInt(Level) <= Year(Now()) Then

						Session.Contents("SITE_Schedule_Year") = Level
						MatchFound = 1 : DeadPage = 0

					End If

					If MatchFound = 0 And CInt(Level) >= 1 And CInt(Level) <= 18 Then

						Session.Contents("SITE_Schedule_Period") = Level
						MatchFound = 1 : DeadPage = 0

					End If

				End If

			End If

			LevelCount = LevelCount + 1

		Next

		sTransferURL = "index.asp"

	End If

	If Session.Contents("SITE_Level_1") = "chronicle" Then

		'CHECK FOR LEVEL'
		If MatchFound = 0 Then

			sqlGetLevel = "SELECT * FROM Levels WHERE Abbreviation = '" & UCase(Session.Contents("SITE_Level_2")) & "'"
			Set rsLevel = sqlDatabase.Execute(sqlGetLevel)

			If Not rsLevel.Eof Then

				Session.Contents("SITE_Chronicle_LevelID") = rsLevel("LevelID")
				Session.Contents("SITE_Chronicle_LevelTitle") = rsLevel("Title")
				Session.Contents("SITE_Chronicle_LevelAbbreviation") = rsLevel("Abbreviation")
				Session.Contents("SITE_Chronicle_LevelLogo") = rsLevel("Logo")

				sTransferURL = "level.asp"
				MatchFound = 1 : DeadPage = 0
				rsLevel.Close
				Set rsLevel = Nothing

			End If

		End If

		'CHECK FOR ACCOUNT'
		If MatchFound = 0 Then

			sqlGetProfile = "SELECT * FROM Accounts WHERE ProfileURL = '" & LCase(Session.Contents("SITE_Level_2")) & "'"
			Set rsProfile = sqlDatabase.Execute(sqlGetProfile)

			If Not rsProfile.Eof Then

				Session.Contents("SITE_Chronicle_AccountID") = rsProfile("AccountID")
				Session.Contents("SITE_Chronicle_AccountName") = rsProfile("ProfileName")
				Session.Contents("SITE_Chronicle_AccountImage") = rsProfile("ProfileImage")
				Session.Contents("SITE_Chronicle_AccountBallCount") = rsProfile("Balls")
				Session.Contents("SITE_Chronicle_AccountLockCount") = rsProfile("Locks")

				sTransferURL = "account.asp"
				MatchFound = 1 : DeadPage = 0
				rsProfile.Close
				Set rsProfile = Nothing

			End If

		End If

	End If

	If DeadPage = 0 Then

		sFinalTransfer = "/" & Session.Contents("SITE_Level_1") & "/" & sTransferURL
		Server.Transfer(sFinalTransfer)

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
