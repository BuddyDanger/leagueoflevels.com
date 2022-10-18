<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!--#include virtual="/assets/asp/functions/sha256.asp"-->
<%
	MatchupID = Session.Contents("Scores_Matchup_ID")

	sqlGetMatchup = "SELECT Matchups.MatchupID, Matchups.LevelID, Levels.Title, Matchups.Year, Matchups.Period, Matchups.IsPlayoffs, Matchups.IsCup, Matchups.TeamID1, Matchups.TeamID2, Teams1.CBSID AS TeamCBSID1,Teams2.CBSID AS TeamCBSID2, Accounts1.ProfileImage AS TeamCBSLogo1, Accounts2.ProfileImage AS TeamCBSLogo2, Teams1.TeamName AS TeamName1, Teams2.TeamName AS TeamName2, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.Leg "
	sqlGetMatchup = sqlGetMatchup & "FROM Matchups "
	sqlGetMatchup = sqlGetMatchup & "LEFT JOIN Levels ON Levels.LevelID = Matchups.LevelID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Teams1.TeamID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Teams2.TeamID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Accounts AS Accounts1 ON Accounts1.AccountID = Link1.AccountID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Accounts AS Accounts2 ON Accounts2.AccountID = Link2.AccountID "
	sqlGetMatchup = sqlGetMatchup & "WHERE MatchupID = " & MatchupID & "; "

	sqlGetMatchup = sqlGetMatchup & "SELECT Matchups.MatchupID, Matchups.LevelID, Levels.Title, Matchups.Year, Matchups.Period, Matchups.IsPlayoffs, Matchups.IsCup, Matchups.TeamID1, Matchups.TeamID2, Teams1.CBSID AS TeamCBSID1,Teams2.CBSID AS TeamCBSID2, Accounts1.ProfileImage AS TeamCBSLogo1, Accounts2.ProfileImage AS TeamCBSLogo2, Teams1.TeamName AS TeamName1, Teams2.TeamName AS TeamName2, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.Leg, Teams1.AbbreviatedName AS AbbreviatedName1, Teams2.AbbreviatedName AS AbbreviatedName2 "
	sqlGetMatchup = sqlGetMatchup & "FROM Matchups "
	sqlGetMatchup = sqlGetMatchup & "LEFT JOIN Levels ON Levels.LevelID = Matchups.LevelID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Teams1.TeamID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Teams2.TeamID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Accounts AS Accounts1 ON Accounts1.AccountID = Link1.AccountID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Accounts AS Accounts2 ON Accounts2.AccountID = Link2.AccountID "
	sqlGetMatchup = sqlGetMatchup & "WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " "
	sqlGetMatchup = sqlGetMatchup & "ORDER BY CASE WHEN Matchups.LevelID = 1 THEN 1 WHEN Matchups.LevelID = 0 THEN 2 WHEN Matchups.LevelID = 2 THEN 3 WHEN Matchups.LevelID = 3 THEN 4 ELSE 5 END;"

	Set rsMatchup = sqlDatabase.Execute(sqlGetMatchup)

	If rsMatchup.Eof Then

		'ERROR CATCH

	Else

		MatchupID = rsMatchup("MatchupID")
		MatchupYear = rsMatchup("Year")
		MatchupPeriod = rsMatchup("Period")
		LevelID = rsMatchup("LevelID")
		LevelTitle = rsMatchup("Title")
		IsPlayoffs = rsMatchup("IsPlayoffs")
		IsCup = rsMatchup("IsCup")
		TeamID1 = rsMatchup("TeamID1")
		TeamID2 = rsMatchup("TeamID2")
		TeamCBSID1 = rsMatchup("TeamCBSID1")
		TeamCBSID2 = rsMatchup("TeamCBSID2")
		TeamCBSLogo1 = "https://samelevel.imgix.net/" & rsMatchup("TeamCBSLogo1") & "?w=100&h=100&fit=crop&crop=focalpoint"
		TeamCBSLogo2 = "https://samelevel.imgix.net/" & rsMatchup("TeamCBSLogo2") & "?w=100&h=100&fit=crop&crop=focalpoint"
		TeamName1 = rsMatchup("TeamName1")
		TeamName2 = rsMatchup("TeamName2")
		TeamScore1 = rsMatchup("TeamScore1")
		TeamScore2 = rsMatchup("TeamScore2")
		Leg = rsMatchup("Leg")

		If LevelID = 0 Then
			LevelTitle = "CUP"
			BackgroundColor = "D00000"
		End If
		If LevelID = 1 Then
			LevelTitle = "OMEGA"
			BackgroundColor = "FFBA08"
		End If
		If LevelID = 2 Then
			LevelTitle = "SLFFL"
			BackgroundColor = "136F63"
		End If
		If LevelID = 3 Then
			LevelTitle = "FLFFL"
			BackgroundColor = "032B43"
		End If

		MatchupLevel = LevelTitle

	End If

	Set rsMatchup = rsMatchup.NextRecordset

	arrMatchups = rsMatchup.GetRows()

	thisSchmeckleTotal = 0

	sqlGetStatus = "SELECT * FROM Switchboard WHERE SwitchboardID = 1"
	Set rsStatus = sqlDatabase.Execute(sqlGetStatus)

	If Not rsStatus.Eof Then

		thisSportsbookStatus = rsStatus("Sportsbook")

		If thisSportsbookStatus = False Then thisFormDisabled = "disabled"

		rsStatus.Close
		Set rsStatus = Nothing

	End If

	If Request.Form("inputTicketGo") = "go" Then

		sqlGetSchmeckles = "SELECT SUM(TransactionTotal) AS CurrentSchmeckleTotal FROM SchmeckleTransactions WHERE AccountID = " & Session.Contents("AccountID")
		Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

		thisSchmeckleTotal = 0
		If Not rsSchmeckles.Eof Then

			thisSchmeckleTotal = rsSchmeckles("CurrentSchmeckleTotal")

			rsSchmeckles.Close
			Set rsSchmeckles = Nothing

		End If

		betTypeMoneyline = 0
		betTypeSpread = 0
		betTypeTotal = 0

		thisTicketType = Request.Form("inputTicketType")
		thisMatchupID = Request.Form("inputMatchupID")
		thisNFLGameID = Request.Form("inputNFLGameID")
		thisTeamID1 = Request.Form("inputTeamID1")
		thisTeamID2 = Request.Form("inputTeamID2")

		If thisTicketType = "1" Then

			thisMoneylineValue1 = Request.Form("inputMoneylineValue1")
			thisMoneylineValue2 = Request.Form("inputMoneylineValue2")
			thisMoneylineTeam = Request.Form("inputMoneylineTeam")
			thisMoneylineBetAmount = Request.Form("inputMoneylineBetAmount")
			thisMoneylineWin = Request.Form("inputMoneylineWin")
			thisMoneylinePayout = Request.Form("inputMoneylinePayout")

			If CInt(thisMoneylineTeam) = 1 Then
				betTeamID = thisTeamID1
				betMoneylineValue = thisMoneylineValue1
			Else
				betTeamID = thisTeamID2
				betMoneylineValue = thisMoneylineValue2
			End If

			If CDbl(thisSchmeckleTotal) >= CDbl(thisMoneylineBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				If Session.Contents("SITE_Bet_Type") = "nfl" Then rsInsert("NFLGameID") = thisNFLGameID
				If Session.Contents("SITE_Bet_Type") <> "nfl" Then rsInsert("MatchupID") = thisMatchupID
				rsInsert("TeamID") = betTeamID
				rsInsert("Moneyline") = betMoneylineValue
				rsInsert("BetAmount") = thisMoneylineBetAmount
				rsInsert("PayoutAmount") = thisMoneylinePayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				thisTransactionTypeID = 1008
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisMoneylineBetAmount * -1
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, thisTicketSlipID, thisTransactionTotal, thisTransactionDescription)

				betTypeMoneyline = 1

			End If

		ElseIf CInt(thisTicketType) = 2 Then

			thisSpreadValue1 = Request.Form("inputSpreadValue1")
			thisSpreadValue2 = Request.Form("inputSpreadValue2")
			thisSpreadTeam = Request.Form("inputSpreadTeam")
			thisSpreadBetAmount = Request.Form("inputSpreadBetAmount")
			thisSpreadWin = Request.Form("inputSpreadWin")
			thisSpreadPayout = Request.Form("inputSpreadPayout")

			If CInt(thisSpreadTeam) = 1 Then
				betTeamID = thisTeamID1
				betSpreadValue = thisSpreadValue1
			Else
				betTeamID = thisTeamID2
				betSpreadValue = thisSpreadValue2
			End If

			If CDbl(thisSchmeckleTotal) >= CDbl(thisSpreadBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				If Session.Contents("SITE_Bet_Type") = "nfl" Then rsInsert("NFLGameID") = thisNFLGameID
				If Session.Contents("SITE_Bet_Type") <> "nfl" Then rsInsert("MatchupID") = thisMatchupID
				rsInsert("TeamID") = betTeamID
				rsInsert("Spread") = betSpreadValue
				rsInsert("BetAmount") = thisSpreadBetAmount
				rsInsert("PayoutAmount") = thisSpreadPayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				thisTransactionTypeID = 1008
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisSpreadBetAmount * -1
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, thisTicketSlipID, thisTransactionTotal, thisTransactionDescription)

				betTypeSpread = 1

			End If

		ElseIf CInt(thisTicketType) = 3 Then

			thisOverUnderAmount = Request.Form("inputOverUnderAmount")
			thisOverUnderWin = Request.Form("inputOverUnderWin")
			thisOverUnderPayout = Request.Form("inputOverUnderPayout")
			thisOverUnderBet = Request.Form("inputOverUnderBet")
			thisOverUnderBetAmount = Request.Form("inputOverUnderBetAmount")

			If CInt(thisOverUnderBet) = 1 Then
				thisOverUnderBet = "OVER"
			Else
				thisOverUnderBet = "UNDER"
			End If

			If CDbl(thisSchmeckleTotal) >= CDbl(thisOverUnderBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				If Session.Contents("SITE_Bet_Type") = "nfl" Then rsInsert("NFLGameID") = thisNFLGameID
				If Session.Contents("SITE_Bet_Type") <> "nfl" Then rsInsert("MatchupID") = thisMatchupID
				rsInsert("TeamID") = 0
				rsInsert("OverUnderAmount") = thisOverUnderAmount
				rsInsert("OverUnderBet") = thisOverUnderBet
				rsInsert("BetAmount") = thisOverUnderBetAmount
				rsInsert("PayoutAmount") = thisOverUnderPayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				thisTransactionTypeID = 1008
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisOverUnderBetAmount * -1
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, thisTicketSlipID, thisTransactionTotal, thisTransactionDescription)

				betTypeTotal = 1

			End If

		ElseIf thisTicketType = "4" Then

			thisPropQuestionID = Request.Form("inputPropQuestionID")
			thisPropAnswerID = Request.Form("inputPropAnswer" & thisPropQuestionID)
			betMoneylineValue = Request.Form("inputPropBetMoneyline" & thisPropAnswerID)
			thisMoneylineBetAmount = Request.Form("inputPropBetAmount" & thisPropQuestionID)
			thisMoneylineWin = Request.Form("inputPropWin" & thisPropQuestionID)
			thisMoneylinePayout = Request.Form("inputPropPayout" & thisPropQuestionID)

			If CDbl(thisSchmeckleTotal) >= CDbl(thisMoneylineBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				If Session.Contents("SITE_Bet_Type") = "nfl" Then rsInsert("NFLGameID") = thisNFLGameID
				If Session.Contents("SITE_Bet_Type") <> "nfl" Then rsInsert("MatchupID") = thisMatchupID
				rsInsert("PropQuestionID") = thisPropQuestionID
				rsInsert("PropAnswerID") = thisPropAnswerID
				rsInsert("TeamID") = 0
				rsInsert("Moneyline") = betMoneylineValue
				rsInsert("BetAmount") = thisMoneylineBetAmount
				rsInsert("PayoutAmount") = thisMoneylinePayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				thisTransactionTypeID = 1008
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisMoneylineBetAmount * -1
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, thisTicketSlipID, thisTransactionTotal, thisTransactionDescription)

			End If

		End If

		thisSlackNotificationStatus = Slack_SportsbookBet(thisTicketSlipID, 2, slackIsNFL)

	End If

	If Len(Session.Contents("AccountID")) > 0 Then

		sqlGetSchmeckles = "SELECT SUM(TransactionTotal) AS CurrentSchmeckleTotal FROM SchmeckleTransactions WHERE AccountID = " & Session.Contents("AccountID")
		Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

		If Not rsSchmeckles.Eof Then

			thisSchmeckleTotal = rsSchmeckles("CurrentSchmeckleTotal")

			rsSchmeckles.Close
			Set rsSchmeckles = Nothing

		End If

	End If

	sqlGetSchedules = "SELECT MatchupID, Matchups.LevelID, Year, Period, IsPlayoffs, TeamID1, TeamID2, Team1.LevelID AS TeamLevelID1, Team2.LevelID AS TeamLevelID2, Team1.CBSID AS TeamCBSID1, Team2.CBSID AS TeamCBSID2, Team1.TeamName AS TeamName1, Team2.TeamName AS TeamName2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2, Leg, TeamProjected1, TeamProjected2, TeamWinPercentage1, TeamWinPercentage2, TeamMoneyline1, TeamMoneyline2, TeamSpread1, TeamSpread2 FROM Matchups "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team1 ON Team1.TeamID = Matchups.TeamID1 "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team2 ON Team2.TeamID = Matchups.TeamID2 "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Levels AS Level1 ON Level1.LevelID = Team1.LevelID "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Levels AS Level2 ON Level2.LevelID = Team2.LevelID "
	sqlGetSchedules = sqlGetSchedules & "WHERE Matchups.MatchupID = " & MatchupID

	Set rsSchedules = sqlDatabase.Execute(sqlGetSchedules)

	If Not rsSchedules.Eof Then

		thisMatchupID = rsSchedules("MatchupID")
		thisMatchupLevelID = rsSchedules("LevelID")
		thisYear = rsSchedules("Year")
		thisPeriod = rsSchedules("Period")
		thisTeamID1 = rsSchedules("TeamID1")
		thisTeamID2 = rsSchedules("TeamID2")
		thisTeamLevelID1 = rsSchedules("TeamLevelID1")
		thisTeamLevelID2 = rsSchedules("TeamLevelID2")
		thisTeamCBSID1 = rsSchedules("TeamCBSID1")
		thisTeamCBSID2 = rsSchedules("TeamCBSID2")
		thisTeamName1 = rsSchedules("TeamName1")
		thisTeamName2 = rsSchedules("TeamName2")
		thisTeamScore1 = rsSchedules("TeamScore1")
		thisTeamScore2 = rsSchedules("TeamScore2")
		thisTeamPMR1 = rsSchedules("TeamPMR1")
		thisTeamPMR2 = rsSchedules("TeamPMR2")
		thisTeamProjected1 = rsSchedules("TeamProjected1")
		thisTeamProjected2 = rsSchedules("TeamProjected2")
		thisTeamWinPercentage1 = rsSchedules("TeamWinPercentage1")
		thisTeamWinPercentage2 = rsSchedules("TeamWinPercentage2")
		thisTeamMoneyline1 = rsSchedules("TeamMoneyline1")
		thisTeamMoneyline2 = rsSchedules("TeamMoneyline2")
		thisTeamSpread1 = rsSchedules("TeamSpread1")
		thisTeamSpread2 = rsSchedules("TeamSpread2")
		thisOverUnderTotal = thisTeamProjected1 + thisTeamProjected2

		thisMatchupURL = "/scores/" & thisMatchupID & "/"

		rsSchedules.Close
		Set rsSchedules = Nothing

	End If


%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title><%= TeamName1 %> vs. <%= TeamName2 %> / <%= MatchupLevel %> WEEK <%= MatchupPeriod %> / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/scores/<%= MatchupID %>/" />
		<meta property="og:title" content="<%= TeamName1 %> vs. <%= TeamName2 %> / <%= MatchupLevel %> WEEK <%= MatchupPeriod %> / League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/scores/<%= MatchupID %>/" />
		<meta name="twitter:title" content="<%= TeamName1 %> vs. <%= TeamName2 %> / <%= MatchupLevel %> WEEK <%= MatchupPeriod %> / League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="<%= TeamName1 %> vs. <%= TeamName2 %> / <%= MatchupLevel %> WEEK <%= MatchupPeriod %> / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/scores/<%= MatchupID %>/" />

		<link href="/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/icons.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/style.css?version=3" rel="stylesheet" type="text/css" />

		<style>

			@media (max-width:1200px) {
				.gamestats { display: none !important; }
			}

			@media (max-width:768px) {
				.page-content { padding: 0 !important; padding-bottom: 2rem !important; }

			}

		</style>

	</head>

	<body>

		<!--#include virtual="/assets/asp/framework/topbar.asp" -->

		<div class="page-wrapper">

			<!--#include virtual="/assets/asp/framework/nav.asp" -->

			<div class="page-content">

				<div class="container-fluid pl-0 pl-lg-2 pr-0 pr-lg-2">

					<div class="page-content mt-sm-4">

						<div class="row">

							<div class="col-6 col-lg-3 pl-0 pr-0">

								<ul class="list-group" id="team-1-roster" style="margin-bottom: 1rem;">
<%
									BaseScore1 = 0
									BaseScore2 = 0

									'CUP LEVEL'
									If LevelID = 0 Then

										If CInt(Leg) = 2 Then

											sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & TeamID1 & " OR TeamID2 = " & TeamID1 & ") AND LevelID = 0 AND Year = " & MatchupYear & " AND Period = " & MatchupPeriod - 1
											Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

											If CInt(rsLastWeek("TeamID1")) = CInt(TeamID1) Then BaseScore1 = rsLastWeek("TeamScore1")
											If CInt(rsLastWeek("TeamID2")) = CInt(TeamID1) Then BaseScore1 = rsLastWeek("TeamScore2")

											sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & TeamID2 & " OR TeamID2 = " & TeamID2 & ") AND LevelID = 0 AND Year = " & MatchupYear & " AND Period = " & MatchupPeriod - 1
											Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

											If CInt(rsLastWeek("TeamID1")) = CInt(TeamID2) Then BaseScore2 = rsLastWeek("TeamScore1")
											If CInt(rsLastWeek("TeamID2")) = CInt(TeamID2) Then BaseScore2 = rsLastWeek("TeamScore2")


										End If

										sqlGetLeague = "SELECT LevelID FROM Teams WHERE TeamID = " & TeamID1
										Set rsLeague = sqlDatabase.Execute(sqlGetLeague)

										thisLevelID = CInt(rsLeague("LevelID"))

										If thisLevelID = 2 Then LevelTitle = "SLFFL"
										If thisLevelID = 3 Then LevelTitle = "FLFFL"

										rsLeague.Close
										Set rsLeague = Nothing

									End If

									Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
									oXML.loadXML(GetScores(LevelTitle, Session.Contents("CurrentPeriod")))

									oXML.setProperty "SelectionLanguage", "XPath"
									Set objTeam = oXML.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")

									TeamLevelTitle1 = LevelTitle
									Set objTeamName1 = objTeam.getElementsByTagName("name")
									Set objTeamScore1 = objTeam.getElementsByTagName("pts")
									Set objTeamPMR1 = objTeam.getElementsByTagName("pmr")
									Set objTeamPlayers1 = objTeam.getElementsByTagName("player")

									TeamName1 = objTeamName1.item(0).text
									TeamScore1 = FormatNumber(CDbl(objTeamScore1.item(0).text) + BaseScore1, 2)
									TeamPMR1 = CInt(objTeamPMR1.item(0).text)

									If LevelID = 1 Then

										TeamPMRColor1 = "success"
										If TeamPMR1 < 396 Then TeamPMRColor1 = "warning"
										If TeamPMR1 < 198 Then TeamPMRColor1 = "danger"
										TeamPMRPercent1 = (TeamPMR1 * 100) / 600

									Else

										TeamPMRColor1 = "success"
										If TeamPMR1 < 396 Then TeamPMRColor1 = "warning"
										If TeamPMR1 < 198 Then TeamPMRColor1 = "danger"
										TeamPMRPercent1 = (TeamPMR1 * 100) / 600

									End If

									If CInt(TeamID1) = 38 Then TeamName1 = "München on Bündchen"
%>
									<li class="list-group-item team-1-box m-0 p-0 bg-dark" style="color: #fff;border-radius: 0; border-top-left-radius: 5px;">
										<div class="row p-0 py-2 m-0">
											<div class="col-6 col-lg-2 p-0 pt-1">
												<span><img src="<%= TeamCBSLogo1 %>" width="40" alt="<%= TeamName1 %>" class="rounded-circle ml-3 ml-lg-2" /></span>
											</div>
											<div class="col-7 text-center d-none d-lg-block pt-1">
												<div class="py-2 px-2 bg-primary rounded" style="margin-top: 2px;"><b><%= TeamName1 %></b></div>
											</div>
											<div class="col-6 col-lg-3 pr-1 pt-2 text-right">
												<div><span class="badge team-1-score pt-0 text-right" style="font-size: 20px; color: #fff;"><%= TeamScore1 %></span></div>
												<div><span class="badge team-1-progress pt-0 text-right" style="font-size: 10px; color: #fff;"><%= TeamPMR1 %> PMR</span></div>
											</div>
										</div>
									</li>

									<li class="list-group-item d-block d-lg-none py-1 px-3 px-md-2 bg-light">

										<h6><b><%= TeamName1 %></b></h6>

									</li>
<%
									HitReserves = 0
									ExtraBorder = 0
									TeamRoster1 = ""
									For i = 0 to (objTeamPlayers1.length - 1)

										Set objPlayer = objTeamPlayers1.item(i)

										thisPlayerID = objPlayer.getAttribute("id")

										thisPlayerName = ""
										thisPlayerPoints = ""
										thisPlayerStatus = ""
										thisPlayerGameTimestamp = ""
										thisPlayerPMR = 0
										thisPlayerHomeGame = 2
										thisPlayerProTeam = ""
										thisPlayerPosition = ""
										thisPlayerOpponent = ""
										thisPlayerQuarter = ""
										thisPlayerQuarterTimeRemaining = ""

										Set objPlayerName = objPlayer.getElementsByTagName("fullname")
										If objPlayerName.Length > 0 Then thisPlayerName = objPlayerName.item(0).text

										Set objPlayerPoints = objPlayer.getElementsByTagName("fpts")
										If objPlayerPoints.Length > 0 Then thisPlayerPoints = objPlayerPoints.item(0).text
										If IsNumeric(thisPlayerPoints) Then thisPlayerPoints = FormatNumber(thisPlayerPoints, 2)

										Set objPlayerStatus = objPlayer.getElementsByTagName("status")
										If objPlayerStatus.Length > 0 Then thisPlayerStatus = objPlayerStatus.item(0).text

										Set objPlayerStats = objPlayer.getElementsByTagName("stats_period")
										If objPlayerStats.Length > 0 Then thisPlayerStats = objPlayerStats.item(0).text

										Set objPlayerGameTimestamp = objPlayer.getElementsByTagName("game_start_timestamp")
										If objPlayerGameTimestamp.Length > 0 Then thisPlayerGameTimestamp = objPlayerGameTimestamp.item(0).text

										Set objPlayerPMR = objPlayer.getElementsByTagName("minutes_remaining")
										If objPlayerPMR.Length > 0 Then thisPlayerPMR = CInt(objPlayerPMR.item(0).text)

										Set objPlayerHomeGame = objPlayer.getElementsByTagName("home_game")
										If objPlayerHomeGame.Length > 0 Then thisPlayerHomeGame = CInt(objPlayerHomeGame.item(0).text)

										Set objPlayerProTeam = objPlayer.getElementsByTagName("pro_team")
										If objPlayerProTeam.Length > 0 Then thisPlayerProTeam = objPlayerProTeam.item(0).text

										Set objPlayerPosition = objPlayer.getElementsByTagName("position")
										If objPlayerPosition.Length > 0 Then thisPlayerPosition = objPlayerPosition.item(0).text

										Set objPlayerOpponent = objPlayer.getElementsByTagName("opponent")
										If objPlayerOpponent.Length > 0 Then thisPlayerOpponent = objPlayerOpponent.item(0).text

										Set objPlayerQuarter = objPlayer.getElementsByTagName("quarter")
										If objPlayerQuarter.Length > 0 Then thisPlayerQuarter = objPlayerQuarter.item(0).text

										Set objPlayerQuarterTimeRemaining = objPlayer.getElementsByTagName("time_remaining")
										If objPlayerQuarterTimeRemaining.Length > 0 Then thisPlayerQuarterTimeRemaining = objPlayerQuarterTimeRemaining.item(0).text

										If thisPlayerHomeGame = 1 Then
											thisGameLine = thisPlayerProTeam & " vs. " & thisPlayerOpponent
										ElseIf thisPlayerHomeGame = 0 Then
											thisGameLine = thisPlayerProTeam & " @ " & thisPlayerOpponent
										Else
											thisGameLine = ""
										End If

										If thisPlayerHomeGame < 2 Then

											If thisPlayerPMR > 0 Then TeamRoster1 = TeamRoster1 & thisPlayerID & ","

											thisPlayerGameTimestamp = DateAdd("s", thisPlayerGameTimestamp, DateSerial(1970,1,1))
											thisPlayerGameTimestamp = DateAdd("h", -4, thisPlayerGameTimestamp)

											thisPlayerGameDay = UCase(WeekdayName(Weekday(thisPlayerGameTimestamp),True))
											thisPlayerHour = Hour(thisPlayerGameTimestamp)
											thisPlayerMinute = Minute(thisPlayerGameTimestamp)

											If thisPlayerHour > 12 Then
												AMPM = "PM"
												thisPlayerHour = thisPlayerHour - 12
											Else
												AMPM = "AM"
											End If

											If Len(thisPlayerMinute) = 1 Then thisPlayerMinute = "0" & thisPlayerMinute

										End If

										thisPlayerPMRColor = "success"
										If thisPlayerPMR < 40 Then thisPlayerPMRColor = "warning"
										If thisPlayerPMR < 20 Then thisPlayerPMRColor = "danger"
										thisPlayerPMRPercent = (thisPlayerPMR * 100) / 60

										If thisPlayerPosition = "DST" Then
											thisBackgroundPosition = "-100px 50%"
										Else
											thisBackgroundPosition = "-70px -20px"
										End If

										thisFirstInitial = Left(thisPlayerName, 1)
										thisLastName = ""
										arrPlayerName = Split(thisPlayerName, " ")

										For x = 0 to UBound(arrPlayerName)
											If x > 0 Then
												thisLastName = thisLastName & " " & arrPlayerName(x)
											End If
										Next

										If (thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured") And HitReserves = 0 Then StartReserves = 1
										If thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured" Then HitReserves = 1

										If StartReserves = 1 Then
%>
											<li class="list-group-item py-1 px-3 bg-light">

												<h6><b>BENCH PLAYERS</b></h6>

											</li>
<%
										End If
%>
										<li class="list-group-item team-1-player-<%= thisPlayerID %> pr-3 pt-3 pl-4 pl-md-3" <% If thisPlayerPMR = 0 Then %>style="background-color:#fafafa;"<% End If %>>

											<div class="row">

												<div class="col-1 col-lg-2 d-none d-lg-block m-0 p-0">
													<span><img src="https://sports.cbsimg.net/images/football/nfl/players/170x170/<%= thisPlayerID %>.png" width="40" alt="<%= thisPlayerName %>" class="rounded-circle" /></span>
												</div>

												<div class="col-12 col-lg-10 p-0 pb-0 m-0 text-left">
													<span class="team-1-player-<%= thisPlayerID %>-points player-points float-right font-weight-bold badge badge-dark"><%= thisPlayerPoints %></span>
													<div class="player-name"><b><% If thisPlayerPosition = "DST" Then %><%= thisPlayerName %><% Else %><%= thisFirstInitial %>. <%= thisLastName %><% End If %></b></div>
<%
													If thisPlayerHomeGame < 2 Then

														If thisPlayerQuarter > 1 Or (thisPlayerQuarter = 1 And Left(thisPlayerQuarterTimeRemaining, 2) <> "15") Then
%>
															<div class="pr-0">

																<div class="team-1-player-<%= thisPlayerID %>-gameline d-none"></div>
																<% If thisPlayerPMR > 0 Then %>
																	<span class="ml-2 rounded float-right font-weight-bold badge badge-info team-1-player-<%= thisPlayerID %>-gametime"><%= thisPlayerQuarter %>Q <%= thisPlayerQuarterTimeRemaining %></span>
																<% Else %>
																	<span class="ml-2 rounded float-right font-weight-bold badge badge-info">FINAL</span>
																<% End If %>

																<% If Len(thisPlayerStats) > 0 Then %>
																	<%= thisPlayerStats %>
																<% Else %>
																	&nbsp;
																<% End If %>

															</div>
<%
														Else
%>
															<div class="team-1-player-<%= thisPlayerID %>-gameline pl-0"><%= thisGameLine %> - <%= thisPlayerGameDay %>&nbsp;<%= thisPlayerHour %>:<%= thisPlayerMinute %><%= AMPM %></div>
<%
														End If

													Else
%>
														<span class="team-1-player-<%= thisPlayerID %>-gameline">BYE</span>
<%
													End If
%>
												</div>

											</div>

										</li>
<%
										If StartReserves = 1 Then StartReserves = 0

									Next

									If Right(TeamRoster1, 1) = "," Then TeamRoster1 = Left(TeamRoster1, Len(TeamRoster1)-1)
%>

								</ul>

							</div>

							<div class="col-6 col-lg-3 pl-0 pr-0">

								<ul class="list-group" id="team-2-roster" style="margin-bottom: 1rem;">
<%
									If LevelID = 0 Then

										sqlGetLeague = "SELECT LevelID FROM Teams WHERE TeamID = " & TeamID2
										Set rsLeague = sqlDatabase.Execute(sqlGetLeague)

										thisLevelID = CInt(rsLeague("LevelID"))

										If thisLevelID = 2 Then LevelTitle = "SLFFL"
										If thisLevelID = 3 Then LevelTitle = "FLFFL"

										rsLeague.Close
										Set rsLeague = Nothing

									End If

									Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
									oXML.loadXML(GetScores(LevelTitle, Session.Contents("CurrentPeriod")))

									oXML.setProperty "SelectionLanguage", "XPath"
									Set objTeam = oXML.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")

									Set objTeamName2 = objTeam.getElementsByTagName("name")
									Set objTeamScore2 = objTeam.getElementsByTagName("pts")
									Set objTeamPMR2 = objTeam.getElementsByTagName("pmr")
									Set objTeamPlayers2 = objTeam.getElementsByTagName("player")

									TeamLevelTitle2 = LevelTitle
									TeamName2 = objTeamName2.item(0).text
									TeamScore2 = FormatNumber(CDbl(objTeamScore2.item(0).text) + BaseScore2, 2)
									TeamPMR2 = CInt(objTeamPMR2.item(0).text)

									If LevelID = 1 Then

										TeamPMRColor2 = "success"
										If TeamPMR2 < 396 Then TeamPMRColor2 = "warning"
										If TeamPMR2 < 198 Then TeamPMRColor2 = "danger"
										TeamPMRPercent2 = (TeamPMR2 * 100) / 600

									Else

										TeamPMRColor2 = "success"
										If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
										If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"
										TeamPMRPercent2 = (TeamPMR2 * 100) / 420

									End If

									If CInt(TeamID2) = 38 Then TeamName2 = "München on Bündchen"
%>
									<li class="list-group-item team-2-box m-0 p-0 bg-dark" style="color: #fff; border-radius: 0; border-top-right-radius: 5px;">
										<div class="row p-0 py-2 m-0">
											<div class="col-6 col-lg-3 pl-1 pt-2 text-left">
												<div><span class="badge team-2-score pt-0 text-left" style="font-size: 20px; color: #fff;"><%= TeamScore2 %></span></div>
												<div><span class="badge team-2-progress pt-0 text-left" style="font-size: 10px; color: #fff;"><%= TeamPMR2 %> PMR</span></div>
											</div>
											<div class="col-7 text-center d-none d-lg-block pt-1">
												<div class="py-2 px-2 bg-primary rounded" style="margin-top: 2px;"><b><%= TeamName2 %></b></div>
											</div>
											<div class="col-6 col-lg-2 p-0 pt-1 text-right">
												<span><img src="<%= TeamCBSLogo2 %>" width="40" alt="<%= TeamName2 %>" class="rounded-circle mr-3 mr-lg-2" /></span>
											</div>


										</div>
									</li>

									<li class="list-group-item d-block d-lg-none py-1 px-2 pr-3 bg-light text-right">

										<h6><b><%= TeamName2 %></b></h6>

									</li>
<%
									HitReserves = 0
									ExtraBorder = 0
									TeamRoster2 = ""
									For i = 0 to (objTeamPlayers2.length - 1)

										Set objPlayer = objTeamPlayers2.item(i)

										thisPlayerID = objPlayer.getAttribute("id")

										thisPlayerName = ""
										thisPlayerPoints = ""
										thisPlayerStatus = ""
										thisPlayerGameTimestamp = ""
										thisPlayerPMR = 0
										thisPlayerHomeGame = 2
										thisPlayerProTeam = ""
										thisPlayerPosition = ""
										thisPlayerOpponent = ""
										thisPlayerQuarter = ""
										thisPlayerQuarterTimeRemaining = ""

										Set objPlayerName = objPlayer.getElementsByTagName("fullname")
										If objPlayerName.Length > 0 Then thisPlayerName = objPlayerName.item(0).text

										Set objPlayerPoints = objPlayer.getElementsByTagName("fpts")
										If objPlayerPoints.Length > 0 Then thisPlayerPoints = objPlayerPoints.item(0).text
										If IsNumeric(thisPlayerPoints) Then thisPlayerPoints = FormatNumber(thisPlayerPoints, 2)

										Set objPlayerStatus = objPlayer.getElementsByTagName("status")
										If objPlayerStatus.Length > 0 Then thisPlayerStatus = objPlayerStatus.item(0).text

										Set objPlayerStats = objPlayer.getElementsByTagName("stats_period")
										If objPlayerStats.Length > 0 Then thisPlayerStats = objPlayerStats.item(0).text

										Set objPlayerGameTimestamp = objPlayer.getElementsByTagName("game_start_timestamp")
										If objPlayerGameTimestamp.Length > 0 Then thisPlayerGameTimestamp = objPlayerGameTimestamp.item(0).text

										Set objPlayerPMR = objPlayer.getElementsByTagName("minutes_remaining")
										If objPlayerPMR.Length > 0 Then thisPlayerPMR = CInt(objPlayerPMR.item(0).text)

										Set objPlayerHomeGame = objPlayer.getElementsByTagName("home_game")
										If objPlayerHomeGame.Length > 0 Then thisPlayerHomeGame = CInt(objPlayerHomeGame.item(0).text)

										Set objPlayerProTeam = objPlayer.getElementsByTagName("pro_team")
										If objPlayerProTeam.Length > 0 Then thisPlayerProTeam = objPlayerProTeam.item(0).text

										Set objPlayerPosition = objPlayer.getElementsByTagName("position")
										If objPlayerPosition.Length > 0 Then thisPlayerPosition = objPlayerPosition.item(0).text

										Set objPlayerOpponent = objPlayer.getElementsByTagName("opponent")
										If objPlayerOpponent.Length > 0 Then thisPlayerOpponent = objPlayerOpponent.item(0).text

										Set objPlayerQuarter = objPlayer.getElementsByTagName("quarter")
										If objPlayerQuarter.Length > 0 Then thisPlayerQuarter = objPlayerQuarter.item(0).text

										Set objPlayerQuarterTimeRemaining = objPlayer.getElementsByTagName("time_remaining")
										If objPlayerQuarterTimeRemaining.Length > 0 Then thisPlayerQuarterTimeRemaining = objPlayerQuarterTimeRemaining.item(0).text

										If thisPlayerHomeGame = 1 Then
											thisGameLine = thisPlayerProTeam & " vs. " & thisPlayerOpponent
										ElseIf thisPlayerHomeGame = 0 Then
											thisGameLine = thisPlayerProTeam & " @ " & thisPlayerOpponent
										Else
											thisGameLine = ""
										End If

										If thisPlayerHomeGame < 2 Then

											If thisPlayerPMR > 0 Then TeamRoster2 = TeamRoster2 & thisPlayerID & ","

											thisPlayerGameTimestamp = DateAdd("s", thisPlayerGameTimestamp, DateSerial(1970,1,1))
											thisPlayerGameTimestamp = DateAdd("h", -4, thisPlayerGameTimestamp)

											thisPlayerGameDay = UCase(WeekdayName(Weekday(thisPlayerGameTimestamp),True))
											thisPlayerHour = Hour(thisPlayerGameTimestamp)
											thisPlayerMinute = Minute(thisPlayerGameTimestamp)

											If thisPlayerHour > 12 Then
												AMPM = "PM"
												thisPlayerHour = thisPlayerHour - 12
											Else
												AMPM = "AM"
											End If

											If Len(thisPlayerMinute) = 1 Then thisPlayerMinute = "0" & thisPlayerMinute

										End If

										thisPlayerPMRColor = "success"
										If thisPlayerPMR < 40 Then thisPlayerPMRColor = "warning"
										If thisPlayerPMR < 20 Then thisPlayerPMRColor = "danger"
										thisPlayerPMRPercent = (thisPlayerPMR * 100) / 60

										If thisPlayerPosition = "DST" Then
											thisBackgroundPosition = "-100px 50%"
										Else
											thisBackgroundPosition = "-70px -20px"
										End If

										thisFirstInitial = Left(thisPlayerName, 1)
										thisLastName = ""
										arrPlayerName = Split(thisPlayerName, " ")

										For x = 0 to UBound(arrPlayerName)
											If x > 0 Then
												thisLastName = thisLastName & " " & arrPlayerName(x)
											End If
										Next

										If (thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured") And HitReserves = 0 Then StartReserves = 1
										If thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured" Then HitReserves = 1

										If StartReserves = 1 Then
%>
											<li class="list-group-item py-1 px-3 bg-light text-right">

												<h6><b>BENCH PLAYERS</b></h6>

											</li>
<%
										End If
%>
										<li class="list-group-item team-2-player-<%= thisPlayerID %> pl-3 pt-3 pr-4 pr-md-3" <% If thisPlayerPMR = 0 Then %>style="background-color:#fafafa;"<% End If %>>

											<div class="row">
												<div class="col-12 col-lg-10 p-0 pb-0 m-0 text-right">
													<span class="team-2-player-<%= thisPlayerID %>-points player-points float-left font-weight-bold badge badge-dark"><%= thisPlayerPoints %></span>
													<div class="player-name"><b><% If thisPlayerPosition = "DST" Then %><%= thisPlayerName %><% Else %><%= thisFirstInitial %>. <%= thisLastName %><% End If %></b></div>

<%
													If thisPlayerHomeGame < 2 Then

														If thisPlayerQuarter > 1 Or (thisPlayerQuarter = 1 And Left(thisPlayerQuarterTimeRemaining, 2) <> "15") Then
%>
															<div class="pl-0">
																<div class="team-2-player-<%= thisPlayerID %>-gameline d-none"></div>
																<% If thisPlayerPMR > 0 Then %>
																	<span class="mr-2 rounded float-left font-weight-bold badge badge-info team-2-player-<%= thisPlayerID %>-gametime"><%= thisPlayerQuarter %>Q <%= thisPlayerQuarterTimeRemaining %></span>
																<% Else %>
																	<span class="mr-2 rounded float-left font-weight-bold badge badge-info">FINAL</span>
																<% End If %>

																<% If Len(thisPlayerStats) > 0 Then %>
																	<%= thisPlayerStats %>
																<% Else %>
																	&nbsp;
																<% End If %>

															</div>
<%
														Else
%>
															<div class="team-2-player-<%= thisPlayerID %>-gameline pl-0"><%= thisGameLine %> - <%= thisPlayerGameDay %>&nbsp;<%= thisPlayerHour %>:<%= thisPlayerMinute %><%= AMPM %></div>
<%
														End If

													Else
%>
														<span class="team-2-player-<%= thisPlayerID %>-gameline">BYE</span>
<%
													End If
%>
												</div>

												<div class="col-1 col-lg-2 d-none d-lg-block m-0 p-0 text-right">
													<span><img src="https://sports.cbsimg.net/images/football/nfl/players/170x170/<%= thisPlayerID %>.png" width="40" alt="<%= thisPlayerName %>" class="rounded-circle" /></span>
												</div>

											</div>

										</li>
<%
										If StartReserves = 1 Then StartReserves = 0

									Next

									If Right(TeamRoster2, 1) = "," Then TeamRoster2 = Left(TeamRoster2, Len(TeamRoster2)-1)
%>
								</ul>

							</div>

							<div class="col-12 col-xl-6 pl-lg-3 pr-lg-0">

								<div class="row">
<%
									If thisTeamWinPercentage1 < 0.3 Or thisTeamWinPercentage1 > 0.7 Then thisFormDisabled = "disabled"

									thisTeamWinPercentage1 = (thisTeamWinPercentage1 * 100) & "%"
									thisTeamWinPercentage2 = (thisTeamWinPercentage2 * 100) & "%"

									If thisTeamMoneyline1 > 0 Then thisTeamMoneyline1 = "+" & thisTeamMoneyline1
									If thisTeamMoneyline2 > 0 Then thisTeamMoneyline2 = "+" & thisTeamMoneyline2

									If thisTeamSpread1 > 0 Then thisTeamSpread1 = "+" & thisTeamSpread1
									If thisTeamSpread2 > 0 Then thisTeamSpread2 = "+" & thisTeamSpread2
%>
									<!--
									<div class="col-12 col-lg-4">
										<div class="card">
											<div class="card-body pb-0 pt-0">

												<form action="<%= thisMatchupURL %>" method="post">
													<div class="form-group">

														<input type="hidden" id="inputTicketGo" name="inputTicketGo" value="go" />
														<input type="hidden" id="inputTicketType" name="inputTicketType" value="1" />
														<input type="hidden" id="inputMatchupID" name="inputMatchupID" value="<%= thisMatchupID %>" />
														<input type="hidden" id="inputNFLGameID" name="inputNFLGameID" value="<%= thisNFLGameID %>" />
														<input type="hidden" id="inputTeamID1" name="inputTeamID1" value="<%= thisTeamID1 %>" />
														<input type="hidden" id="inputTeamID2" name="inputTeamID2" value="<%= thisTeamID2 %>" />
<%
														BoostText = ""
														If Len(thisBoostTeamMoneyline1) > 0 Then
															Response.Write("<input type=""hidden"" id=""inputMoneylineValue1"" name=""inputMoneylineValue1"" value=""" & thisBoostTeamMoneyline1 & """ />")
															BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
														Else
															Response.Write("<input type=""hidden"" id=""inputMoneylineValue1"" name=""inputMoneylineValue1"" value=""" & thisTeamMoneyline1 & """ />")
														End If

														If Len(thisBoostTeamMoneyline2) > 0 Then
															Response.Write("<input type=""hidden"" id=""inputMoneylineValue2"" name=""inputMoneylineValue2"" value=""" & thisBoostTeamMoneyline2 & """ />")
															BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
														Else
															Response.Write("<input type=""hidden"" id=""inputMoneylineValue2"" name=""inputMoneylineValue2"" value=""" & thisTeamMoneyline2 & """ />")
														End If
%>
														<input type="hidden" id="inputMoneylineWin" name="inputMoneylineWin" value="" />
														<input type="hidden" id="inputMoneylinePayout" name="inputMoneylinePayout" value="" />

														<label class="form-check-label-lg mt-4" for="inputMoneylineTeam" class="col-form-label"><b>Moneyline:</b> <%= BoostText %></label>
														<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg" name="inputMoneylineTeam" id="inputMoneylineTeam" onchange="calculate_moneyline_payout(document.getElementById('inputMoneylineBetAmount').value)" required>
															<option></option>
<%
															If Len(thisBoostTeamMoneyline1) > 0 Then
																Response.Write("<option value=""1"">" & thisTeamName1 & " (" & thisBoostTeamMoneyline1 & " ML)</option>")
															Else
																Response.Write("<option value=""1"">" & thisTeamName1 & " (" & thisTeamMoneyline1 & " ML)</option>")
															End If

															If Len(thisBoostTeamMoneyline2) > 0 Then
																Response.Write("<option value=""2"">" & thisTeamName2 & " (" & thisBoostTeamMoneyline2 & " ML)</option>")
															Else
																Response.Write("<option value=""2"">" & thisTeamName2 & " (" & thisTeamMoneyline2 & " ML)</option>")
															End If
%>
														</select>

														<label for="inputMoneylineBetAmount" class="col-form-label mt-2"><b>Bet Amount:</b></label>
														<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= thisSchmeckleTotal %>" id="inputMoneylineBetAmount" name="inputMoneylineBetAmount" onkeyup="calculate_moneyline_payout(this.value)" required>

														<label class="col-form-label mt-1 mb-1 py-3"><b>Total Payout:</b>  <span id="payoutMoneyline"><span></label>

														<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">Place Bet</button>

													</div>
												</form>

											</div>

										</div>
									</div>

									<div class="col-12 col-lg-4">
										<div class="card">

											<div class="card-body pb-0 pt-0">

												<form action="<%= thisMatchupURL %>" method="post">
													<div class="form-group">

														<input type="hidden" id="inputTicketGo" name="inputTicketGo" value="go" />
														<input type="hidden" id="inputTicketType" name="inputTicketType" value="2" />
														<input type="hidden" id="inputMatchupID" name="inputMatchupID" value="<%= thisMatchupID %>" />
														<input type="hidden" id="inputNFLGameID" name="inputNFLGameID" value="<%= thisNFLGameID %>" />
														<input type="hidden" id="inputTeamID1" name="inputTeamID1" value="<%= thisTeamID1 %>" />
														<input type="hidden" id="inputTeamID2" name="inputTeamID2" value="<%= thisTeamID2 %>" />
<%
														BoostText = ""
														If Len(thisBoostTeamSpreadMoneyline1) > 0 Then
															Response.Write("<input type=""hidden"" id=""inputSpreadMoneylineValue1"" name=""inputSpreadMoneylineValue1"" value=""" & thisBoostTeamSpreadMoneyline1 & """ />")
															BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
														Else
															Response.Write("<input type=""hidden"" id=""inputSpreadMoneylineValue1"" name=""inputSpreadMoneylineValue1"" value=""100"" />")
														End If

														If Len(thisBoostTeamSpreadMoneyline2) > 0 Then
															Response.Write("<input type=""hidden"" id=""inputSpreadMoneylineValue2"" name=""inputSpreadMoneylineValue2"" value=""" & thisBoostTeamSpreadMoneyline2 & """ />")
															BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
														Else
															Response.Write("<input type=""hidden"" id=""inputSpreadMoneylineValue2"" name=""inputSpreadMoneylineValue2"" value=""100"" />")
														End If

														If Len(thisBoostTeamSpread1) > 0 Then
															Response.Write("<input type=""hidden"" id=""inputSpreadValue1"" name=""inputSpreadValue1"" value=""" & thisBoostTeamSpread1 & """ />")
															BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
														Else
															Response.Write("<input type=""hidden"" id=""inputSpreadValue1"" name=""inputSpreadValue1"" value=""" & thisTeamSpread1 & """ />")
														End If

														If Len(thisBoostTeamSpread2) > 0 Then
															Response.Write("<input type=""hidden"" id=""inputSpreadValue2"" name=""inputSpreadValue2"" value=""" & thisBoostTeamSpread2 & """ />")
															BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
														Else
															Response.Write("<input type=""hidden"" id=""inputSpreadValue2"" name=""inputSpreadValue2"" value=""" & thisTeamSpread2 & """ />")
														End If
%>
														<input type="hidden" id="inputSpreadWin" name="inputSpreadWin" value="" />
														<input type="hidden" id="inputSpreadPayout" name="inputSpreadPayout" value="" />

														<label class="form-check-label-lg mt-4" for="inputSpreadTeam" class="col-form-label"><b>Point Spread:</b> <%= BoostText %></label>
														<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg" name="inputSpreadTeam" id="inputSpreadTeam" onchange="calculate_spread_payout('document.getElementById('inputSpreadBetAmount').value')" required>
															<option></option>
<%
															If (IsNumeric(thisBoostTeamSpread1) And thisBoostTeamSpread1 > 0) Or (IsNumeric(thisBoostTeamSpread2) And thisBoostTeamSpread2 > 0) Then

																If IsNumeric(thisBoostTeamSpread1) And thisBoostTeamSpread1 > 0 Then
																	Response.Write("<option value=""1"">" & thisTeamName1 & " (" & thisBoostTeamSpread1 & ")</option>")
																Else
																	Response.Write("<option value=""1"">" & thisTeamName1 & " (" & thisTeamSpread1 & ")</option>")
																End If

																If IsNumeric(thisBoostTeamSpread2) And thisBoostTeamSpread2 > 0 Then
																	Response.Write("<option value=""2"">" & thisTeamName2 & " (" & thisBoostTeamSpread2 & ")</option>")
																Else
																	Response.Write("<option value=""2"">" & thisTeamName2 & " (" & thisTeamSpread2 & ")</option>")
																End If

															ElseIf IsNumeric(thisBoostTeamSpreadMoneyline1) Or IsNumeric(thisBoostTeamSpreadMoneyline2) Then

																If IsNumeric(thisBoostTeamSpreadMoneyline1) And thisBoostTeamSpreadMoneyline1 > 0 Then
																	Response.Write("<option value=""1"">" & thisTeamName1 & " (" & thisTeamSpread1 & ") (" & thisBoostTeamSpreadMoneyline1 & " ML)</option>")
																Else
																	Response.Write("<option value=""1"">" & thisTeamName1 & " (" & thisTeamSpread1 & ")</option>")
																End If

																If IsNumeric(thisBoostTeamSpreadMoneyline2) And thisBoostTeamSpreadMoneyline2 > 0 Then
																	Response.Write("<option value=""2"">" & thisTeamName2 & " (" & thisTeamSpread2 & ") (" & thisBoostTeamSpreadMoneyline2 & " ML)</option>")
																Else
																	Response.Write("<option value=""2"">" & thisTeamName2 & " (" & thisTeamSpread2 & ")</option>")
																End If

															Else

																Response.Write("<option value=""1"">" & thisTeamName1 & " (" & thisTeamSpread1 & ")</option>")
																Response.Write("<option value=""2"">" & thisTeamName2 & " (" & thisTeamSpread2 & ")</option>")

															End If
%>
														</select>

														<label for="inputSpreadBetAmount" class="col-form-label mt-2"><b>Bet Amount:</b></label>
														<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= thisSchmeckleTotal %>" id="inputSpreadBetAmount" name="inputSpreadBetAmount" onkeyup="calculate_spread_payout(this.value)" required>

														<label class="col-form-label mt-1 mb-1 py-3"><b>Total Payout:</b>  <span id="payoutSpread"><span></label>

														<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">Place Bet</button>

													</div>
												</form>

											</div>

										</div>
									</div>

									<div class="col-12 col-lg-4">
										<div class="card">

											<div class="card-body pb-0 pt-0">

												<form action="<%= thisMatchupURL %>" method="post">
													<div class="form-group">

														<input type="hidden" id="inputTicketGo" name="inputTicketGo" value="go" />
														<input type="hidden" id="inputTicketType" name="inputTicketType" value="3" />
														<input type="hidden" id="inputMatchupID" name="inputMatchupID" value="<%= thisMatchupID %>" />
														<input type="hidden" id="inputNFLGameID" name="inputNFLGameID" value="<%= thisNFLGameID %>" />
<%
														BoostText = ""
														If IsNumeric(thisBoostOverUnderTotal) And thisBoostOverUnderTotal > 0 Then
															Response.Write("<input type=""hidden"" id=""inputOverUnderAmount"" name=""inputOverUnderAmount"" value=""" & thisBoostOverTotalMoneyline & """ />")
															BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
														Else
															Response.Write("<input type=""hidden"" id=""inputOverUnderAmount"" name=""inputOverUnderAmount"" value=""" & thisOverUnderTotal & """ />")
														End If

														If IsNumeric(thisBoostOverTotalMoneyline) And thisBoostOverTotalMoneyline > 0 Then
															Response.Write("<input type=""hidden"" id=""inputOverMoneyline"" name=""inputOverMoneyline"" value=""" & thisBoostOverTotalMoneyline & """ />")
															BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
														Else
															Response.Write("<input type=""hidden"" id=""inputOverMoneyline"" name=""inputOverMoneyline"" value=""100"" />")
														End If

														If IsNumeric(thisBoostUnderTotalMoneyline) And thisBoostUnderTotalMoneyline > 0 Then
															Response.Write("<input type=""hidden"" id=""inputUnderMoneyline"" name=""inputUnderMoneyline"" value=""" & thisBoostUnderTotalMoneyline & """ />")
															BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
														Else
															Response.Write("<input type=""hidden"" id=""inputUnderMoneyline"" name=""inputUnderMoneyline"" value=""100"" />")
														End If
%>
														<input type="hidden" id="inputOverUnderWin" name="inputOverUnderWin" value="" />
														<input type="hidden" id="inputOverUnderPayout" name="inputOverUnderPayout" value="" />

														<label class="form-check-label-lg mt-4" for="inputOverUnderBet" class="col-form-label"><b>Over / Under:</b> <%= BoostText %></label>
														<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg" name="inputOverUnderBet" id="inputOverUnderBet" onchange="calculate_ou_payout(document.getElementById('inputOverUnderBetAmount').value)">
															<option></option>
<%
															If IsNumeric(thisBoostOverUnderTotal) And thisBoostOverUnderTotal > 0 Then

																Response.Write("<option value=""1"">OVER (" & thisBoostOverUnderTotal & ")</option>")

															ElseIf (IsNumeric(thisBoostOverTotalMoneyline) Or IsNumeric(thisBoostUnderTotalMoneyline)) And (thisBoostOverTotalMoneyline > 0 Or thisBoostUnderTotalMoneyline > 0) Then

																If IsNumeric(thisBoostOverTotalMoneyline) Then
																	Response.Write("<option value=""1"">OVER (" & thisOverUnderTotal & ") (" & thisBoostOverTotalMoneyline & " ML)</option>")
																Else
																	Response.Write("<option value=""1"">OVER (" & thisOverUnderTotal & ")</option>")
																End If

																If IsNumeric(thisBoostUnderTotalMoneyline) Then
																	Response.Write("<option value=""2"">UNDER (" & thisOverUnderTotal & ") (" & thisBoostUnderTotalMoneyline & " ML)</option>")
																Else
																	Response.Write("<option value=""2"">UNDER (" & thisOverUnderTotal & ")</option>")
																End If

															Else

																Response.Write("<option value=""1"">OVER (" & thisOverUnderTotal & ")</option>")
																Response.Write("<option value=""2"">UNDER (" & thisOverUnderTotal & ")</option>")

															End If
%>
														</select>

														<label for="inputOverUnderBetAmount" class="col-form-label mt-2"><b>Bet Amount:</b></label>
														<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= thisSchmeckleTotal %>" id="inputOverUnderBetAmount" name="inputOverUnderBetAmount" onkeyup="calculate_ou_payout(this.value)">

														<label class="col-form-label mt-1 mb-1 py-3"><b>Total Payout:</b>  <span id="payoutOverUnder"><span></label>

														<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-2">Place Bet</button>

													</div>
												</form>

											</div>

										</div>
									</div>
									-->
	<%
									For i = 0 To UBound(arrMatchups, 2) - 1

										oMatchupID = arrMatchups(0, i)
										oLevelID = arrMatchups(1, i)
										oTeamID1 = arrMatchups(7, i)
										oTeamName1 = arrMatchups(13, i)
										oTeamLogo1 = arrMatchups(11, i)
										oTeamCBSID1 = arrMatchups(9, i)
										oTeamID2 = arrMatchups(8, i)
										oTeamName2 = arrMatchups(14, i)
										oTeamLogo2 = arrMatchups(12, i)
										oTeamCBSID2 = arrMatchups(10, i)
										oTeamScore1 = FormatNumber(arrMatchups(15, i), 2)
										oTeamScore2 = FormatNumber(arrMatchups(16, i), 2)
										oTeamAbbreviatedName1 = arrMatchups(18, i)
										oTeamAbbreviatedName2 = arrMatchups(19, i)

										If oLevelID = 0 Then LevelCSS = "cup"
										If oLevelID = 1 Then LevelCSS = "omega"
										If oLevelID = 2 Then LevelCSS = "slffl"
										If oLevelID = 3 Then LevelCSS = "flffl"
	%>
										<div class="col-12 col-lg-3">
										<a href="/scores/<%= oMatchupID %>/" style="text-decoration: none; display: block;">
											<ul class="list-group" id="matchup-<%= oMatchupID %>" style="margin-bottom: 1rem;">
												<li class="list-group-item team-<%= LevelCSS %>-box-<%= oTeamID1 %>" style="position: relative;">
													<span class="team-<%= LevelCSS %>-score-<%= oTeamID1 %>" style="font-size: 1em; line-height: 1.9rem; background-color: #fff; float: right; padding-top: 0rem;"><%= oTeamScore1 %></span>
													<span style="font-size: 13px; line-height: 1.9rem;  font-weight: bold;"><%= oTeamAbbreviatedName1 %></span>

												</li>
												<li class="list-group-item team-<%= LevelCSS %>-box-<%= oTeamID2 %>">
													<span class="team-<%= LevelCSS %>-score-<%= oTeamID2 %>" style="font-size: 1em; line-height: 1.9rem; background-color: #fff;  float: right; padding-top: 0rem;"><%= oTeamScore2 %></span>
													<span style="font-size: 13px; line-height: 1.9rem;  font-weight: bold;"><%= oTeamAbbreviatedName2 %></span>

												</li>
											</ul>
										</a>
										</div>
	<%
									Next
	%>

								</div>
							</div>

						</div>

					</div>

				</div>

				<footer class="footer text-center text-sm-left">&copy; <%= Year(Now()) %> League of Levels Fantasy <span class="text-muted d-none d-sm-inline-block float-right"></span></footer>

			</div>

		</div>

		<script src="/assets/js/jquery.min.js"></script>
		<script src="/assets/js/bootstrap.bundle.min.js"></script>
		<script src="/assets/js/metisMenu.min.js"></script>
		<script src="/assets/js/waves.min.js"></script>
		<script src="/assets/js/jquery.slimscroll.min.js"></script>

		<script src="/assets/js/app.js"></script>

		<!--#include virtual="/assets/asp/framework/google.asp" -->

		<script src="/assets/plugins/countUp/countUp.min.js" type="text/javascript"></script>
		<script src="/assets/plugins/howler/howler.min.js" type="text/javascript"></script>

		<!--#include virtual="/assets/js/matchup.asp"-->

		<script>

			function calculate_moneyline_payout(stake) {

				var isPositive = true;
				var payout = 0;
				var betTeam = document.getElementById("inputMoneylineTeam").value;

				if (betTeam == 1) { moneylineValue = document.getElementById("inputMoneylineValue1").value } else { moneylineValue = document.getElementById("inputMoneylineValue2").value }

				if(moneylineValue.toString().search("-") > -1) { isPositive = false; }

				moneylineValue = moneylineValue.replace("+","").replace("-","");

				if(isPositive) {
					document.getElementById("payoutMoneyline").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
					document.getElementById("inputMoneylineWin").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
					document.getElementById("inputMoneylinePayout").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
				} else {
					document.getElementById("payoutMoneyline").innerHTML = numberWithCommas(parseInt(stake / (moneylineValue / 100)) + parseInt(stake));
					document.getElementById("inputMoneylineWin").value = numberWithCommas(parseInt(stake / (moneylineValue / 100)));
					document.getElementById("inputMoneylinePayout").value = numberWithCommas(parseInt(stake / (moneylineValue / 100)) + parseInt(stake));
				}

				return 0;

			}

			function calculate_spread_payout(stake) {

				var payout = 0;
				moneylineValue = 100;

				document.getElementById("payoutSpread").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
				document.getElementById("inputSpreadWin").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
				document.getElementById("inputSpreadPayout").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));

				return 0;

			}

			function calculate_ou_payout(stake) {

				var payout = 0;
				moneylineValue = 100;

				document.getElementById("payoutOverUnder").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
				document.getElementById("inputOverUnderWin").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
				document.getElementById("inputOverUnderPayout").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));

				return 0;

			}

			function calculate_prop_payout(propID, stake) {

				var isPositive = true;
				var payout = 0;
				var answerID = document.getElementById("inputPropAnswer" + propID).value
 				var moneylineValue = document.getElementById("inputPropBetMoneyline" + answerID).value

				if(moneylineValue.toString().search("-") > -1) { isPositive = false; }

				moneylineValue = moneylineValue.replace("+","").replace("-","");

				if(isPositive) {
					document.getElementById("payoutPropBet" + propID).innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
					document.getElementById("inputPropWin" + propID).value = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
					document.getElementById("inputPropPayout" + propID).value = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
				} else {
					document.getElementById("payoutPropBet" + propID).innerHTML = numberWithCommas(parseInt(stake / (moneylineValue / 100)) + parseInt(stake));
					document.getElementById("inputPropWin" + propID).value = numberWithCommas(parseInt(stake / (moneylineValue / 100)));
					document.getElementById("inputPropPayout" + propID).value = numberWithCommas(parseInt(stake / (moneylineValue / 100)) + parseInt(stake));
				}

				return 0;

			}

			function numberWithCommas(x) { return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); }

		</script>

	</body>

</html>
