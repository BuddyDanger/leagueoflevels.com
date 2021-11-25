<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!--#include virtual="/assets/asp/functions/sha256.asp"-->
<%
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

	If Session.Contents("SITE_Bet_Type") = "nfl" Then

		sqlGetSchedules = "SELECT NFLGameID, Year, Period, DateTimeEST, DateAdd(hour,-5,getdate()) AS CurrentDateTime, AwayTeamID, A.City + ' ' + A.Name AS AwayTeam, HomeTeamID, B.City + ' ' + B.Name AS HomeTeam, AwayTeamScore, HomeTeamScore, Notes, AwayTeamMoneyline, HomeTeamMoneyline, AwayTeamSpread, HomeTeamSpread, OverUnderTotal, Boost_AwayTeamMoneyline, Boost_HomeTeamMoneyline, Boost_AwayTeamSpread, Boost_HomeTeamSpread, Boost_AwayTeamSpreadMoneyline, Boost_HomeTeamSpreadMoneyline, Boost_OverUnderTotal, Boost_OverTotalMoneyline, Boost_UnderTotalMoneyline "
		sqlGetSchedules = sqlGetSchedules & "FROM dbo.NFLGames INNER JOIN NFLTeams A ON A.NFLTeamID = NFLGames.AwayTeamID INNER JOIN NFLTeams B ON B.NFLTeamID = NFLGames.HomeTeamID WHERE NFLGameID = " & Session.Contents("SITE_Bet_MatchupID")
		Set rsSchedules = sqlDatabase.Execute(sqlGetSchedules)

		If Not rsSchedules.Eof Then

			thisNFLGameID = rsSchedules("NFLGameID")
			thisYear = rsSchedules("Year")
			thisPeriod = rsSchedules("Period")
			thisTeamID1 = rsSchedules("AwayTeamID")
			thisTeamID2 = rsSchedules("HomeTeamID")
			thisTeamName1 = rsSchedules("AwayTeam")
			thisTeamName2 = rsSchedules("HomeTeam")
			thisTeamScore1 = rsSchedules("AwayTeamScore")
			thisTeamScore2 = rsSchedules("HomeTeamScore")
			thisTeamMoneyline1 = rsSchedules("AwayTeamMoneyline")
			thisTeamMoneyline2 = rsSchedules("HomeTeamMoneyline")
			thisTeamSpread1 = rsSchedules("AwayTeamSpread")
			thisTeamSpread2 = rsSchedules("HomeTeamSpread")
			thisOverUnderTotal = rsSchedules("OverUnderTotal")
			thisGameTimeEST = rsSchedules("DateTimeEST")
			thisCurrentTimeEST = rsSchedules("CurrentDateTime")

			thisBoostTeamMoneyline1 = rsSchedules("Boost_AwayTeamMoneyline")
			thisBoostTeamMoneyline2 = rsSchedules("Boost_HomeTeamMoneyline")
			thisBoostTeamSpread1 = rsSchedules("Boost_AwayTeamSpread")
			thisBoostTeamSpread2 = rsSchedules("Boost_HomeTeamSpread")
			thisBoostOverUnderTotal = rsSchedules("Boost_OverUnderTotal")
			thisBoostTeamSpreadMoneyline1 = rsSchedules("Boost_AwayTeamSpreadMoneyline")
			thisBoostTeamSpreadMoneyline2 = rsSchedules("Boost_HomeTeamSpreadMoneyline")
			thisBoostOverTotalMoneyline = rsSchedules("Boost_OverTotalMoneyline")
			thisBoostUnderTotalMoneyline = rsSchedules("Boost_UnderTotalMoneyline")

			thisBoostMoneylineFlag = 0
			thisBoostSpreadFlag = 0
			thisBoostTotalFlag = 0

			If IsNumeric(thisBoostTeamMoneyline1) Or IsNumeric(thisBoostTeamMoneyline2) Then thisBoostMoneylineFlag = 1
			If IsNumeric(thisBoostTeamSpread1) Or IsNumeric(thisBoostTeamSpread2) Or IsNumeric(thisBoostTeamSpreadMoneyline1) Or IsNumeric(thisBoostTeamSpreadMoneyline2) Then thisBoostSpreadFlag = 1
			If IsNumeric(thisBoostOverUnderTotal) Or IsNumeric(thisBoostOverTotalMoneyline) Or IsNumeric(thisBoostUnderTotalMoneyline) Then thisBoostTotalFlag = 1

			thisMatchupURL = "/sportsbook/nfl/" & thisNFLGameID & "/"

			rsSchedules.Close
			Set rsSchedules = Nothing

			pageTitle = "Sportsbook / " & thisTeamName1 & " vs. " & thisTeamName2 & " / " & thisYear & " (Period " & thisPeriod & ") / League of Levels"

		End If

	Else

		sqlGetSchedules = "SELECT MatchupID, Matchups.LevelID, Year, Period, IsPlayoffs, TeamID1, TeamID2, Team1.LevelID AS TeamLevelID1, Team2.LevelID AS TeamLevelID2, Team1.CBSID AS TeamCBSID1, Team2.CBSID AS TeamCBSID2, Team1.TeamName AS TeamName1, Team2.TeamName AS TeamName2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2, Leg, TeamProjected1, TeamProjected2, TeamWinPercentage1, TeamWinPercentage2, TeamMoneyline1, TeamMoneyline2, TeamSpread1, TeamSpread2 FROM Matchups "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team1 ON Team1.TeamID = Matchups.TeamID1 "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team2 ON Team2.TeamID = Matchups.TeamID2 "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN Levels AS Level1 ON Level1.LevelID = Team1.LevelID "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN Levels AS Level2 ON Level2.LevelID = Team2.LevelID "
		sqlGetSchedules = sqlGetSchedules & "WHERE Matchups.MatchupID = " & Session.Contents("SITE_Bet_MatchupID")
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

			thisMatchupURL = "/sportsbook/" & thisMatchupID & "/"

			rsSchedules.Close
			Set rsSchedules = Nothing

			pageTitle = "Sportsbook / " & thisTeamName1 & " vs. " & thisTeamName2 & " / " & thisYear & " (Period " & thisPeriod & ") / League of Levels"

		End If

	End If
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title><%= pageTitle %></title>

		<meta name="description" content="Sportbook details for the <%= thisYear %> Period <%= thisPeriod %> matchup between <%= thisTeamName1 %> and <%= thisTeamName2 %>." />

		<meta property="og:site_name" content="League of Levels" />
		<meta property="og:url" content="https://www.leagueoflevels.com/sportsbook/<%= thisMatchupID %>/" />
		<meta property="og:title" content="<%= pageTitle %>" />
		<meta property="og:description" content="Sportbook details for the <%= thisYear %> Period <%= thisPeriod %> matchup between <%= thisTeamName1 %> and <%= thisTeamName2 %>." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/sportsbook/<%= thisMatchupID %>/" />
		<meta name="twitter:title" content="<%= pageTitle %>" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="<%= pageTitle %>" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/sportsbook/<%= thisMatchupID %>/" />

		<link href="/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/icons.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/style.css?version=3" rel="stylesheet" type="text/css" />

	</head>

	<body>

		<!--#include virtual="/assets/asp/framework/topbar.asp" -->

		<div class="page-wrapper">

			<!--#include virtual="/assets/asp/framework/nav.asp" -->

			<div class="page-content">

				<div class="container-fluid pl-0 pl-lg-2 pr-0 pr-lg-2">

					<div class="row mt-4">
<%
						If Session.Contents("SITE_Bet_Type") = "nfl" Then

							If thisGameTimeEST < thisCurrentTimeEST Then thisFormDisabled = "disabled"

							thisTeamProjected1 = (thisOverUnderTotal / 2) + (CDbl(thisTeamSpread1) / 2)
							thisTeamProjected2 = (thisOverUnderTotal / 2) + (CDbl(thisTeamSpread2) / 2)

							If thisTeamSpread1 Then thisTeamProjected1 = (thisOverUnderTotal / 2) - (CDbl(thisTeamSpread1) / 2)
							If thisTeamSpread2 Then thisTeamProjected2 = (thisOverUnderTotal / 2) - (CDbl(thisTeamSpread2) / 2)

							If thisTeamMoneyline1 > 0 Then thisTeamMoneyline1 = "+" & thisTeamMoneyline1
							If thisTeamMoneyline2 > 0 Then thisTeamMoneyline2 = "+" & thisTeamMoneyline2

							If thisTeamSpread1 > 0 Then thisTeamSpread1 = "+" & thisTeamSpread1
							If thisTeamSpread2 > 0 Then thisTeamSpread2 = "+" & thisTeamSpread2

							If thisBoostTeamMoneyline1 > 0 Then thisBoostTeamMoneyline1 = "+" & thisBoostTeamMoneyline1
							If thisBoostTeamMoneyline2 > 0 Then thisBoostTeamMoneyline2 = "+" & thisBoostTeamMoneyline2

							If thisBoostTeamSpread1 > 0 Then thisBoostTeamSpread1 = "+" & thisBoostTeamSpread1
							If thisBoostTeamSpread2 > 0 Then thisBoostTeamSpread2 = "+" & thisBoostTeamSpread2

							If thisBoostTeamSpreadMoneyline1 > 0 Then thisBoostTeamSpreadMoneyline1 = "+" & thisBoostTeamSpreadMoneyline1
							If thisBoostTeamSpreadMoneyline2 > 0 Then thisBoostTeamSpreadMoneyline2 = "+" & thisBoostTeamSpreadMoneyline2

							If thisBoostOverTotalMoneyline > 0 Then thisBoostOverTotalMoneyline = "+" & thisBoostOverTotalMoneyline

							headerBGcolor = "032B43"
							headerTextColor = "fff"
							headerText = "NFL"
							cardText = "03324F"

						Else

							If thisTeamWinPercentage1 < 0.3 Or thisTeamWinPercentage1 > 0.7 Then thisFormDisabled = "disabled"

							thisTeamWinPercentage1 = (thisTeamWinPercentage1 * 100) & "%"
							thisTeamWinPercentage2 = (thisTeamWinPercentage2 * 100) & "%"

							If thisTeamMoneyline1 > 0 Then thisTeamMoneyline1 = "+" & thisTeamMoneyline1
							If thisTeamMoneyline2 > 0 Then thisTeamMoneyline2 = "+" & thisTeamMoneyline2

							If thisTeamSpread1 > 0 Then thisTeamSpread1 = "+" & thisTeamSpread1
							If thisTeamSpread2 > 0 Then thisTeamSpread2 = "+" & thisTeamSpread2

							If CInt(thisMatchupLevelID) = 0 Then
								headerBGcolor = "D00000"
								headerTextColor = "fff"
								headerText = "CUP"
								cardText = "520000"
							End If
							If CInt(thisMatchupLevelID) = 1 Then
								headerBGcolor = "FFBA08"
								headerTextColor = "fff"
								headerText = "OMEGA"
								cardText = "805C04"
							End If
							If CInt(thisMatchupLevelID) = 2 Then
								headerBGcolor = "136F63"
								headerTextColor = "fff"
								headerText = "SAME LEVEL"
								cardText = "0F574D"
							End If
							If CInt(thisMatchupLevelID) = 3 Then
								headerBGcolor = "032B43"
								headerTextColor = "fff"
								headerText = "FARM LEVEL"
								cardText = "03324F"
							End If

						End If
%>
						<div class="col-12 col-xl-3">
							<a href="<%= thisMatchupURL %>" style="text-decoration: none; display: block;">
								<ul class="list-group mb-4">
<%
									If Session.Contents("SITE_Bet_Type") = "nfl" Then
%>
										<li class="list-group-item p-0"><h4 class="text-left text-white p-3 mt-0 mb-0 rounded-top" style="background-color: #032B43;"><strong><%= headerText %></strong> <%= thisGameTimeEST %></h4></li>
<%
									Else
%>
										<li class="list-group-item p-0"><h4 class="text-left text-white p-3 mt-0 mb-0 rounded-top" style="background-color: #032B43;"><strong><%= headerText %></strong> #<%= thisMatchupID %></h4></li>
<%
									End If
%>
									<li class="list-group-item rounded-0">
										<span class="float-right"><%= thisTeamScore1 %></span>
										<div><b><%= thisTeamName1 %></b></div>
										<div><%= thisTeamProjected1 %> Proj., <% If Session.Contents("SITE_Bet_Type") <> "nfl" Then %><%= thisTeamWinPercentage1 %> Win, <% End If %><%= thisTeamSpread1 %> Spread, <%= thisTeamMoneyline1 %> ML</div>
									</li>
									<li class="list-group-item">
										<span class="float-right"><%= thisTeamScore2 %></span>
										<div><b><%= thisTeamName2 %></b></div>
										<div><%= thisTeamProjected2 %> Proj., <% If Session.Contents("SITE_Bet_Type") <> "nfl" Then %><%= thisTeamWinPercentage2 %> Win, <% End If %><%= thisTeamSpread2 %> Spread, <%= thisTeamMoneyline2 %> ML</div>
									</li>

								</ul>
								<ul class="list-group mb-4">
									<li class="list-group-item">
										<span class="float-right"><%= FormatNumber(thisSchmeckleTotal, 0) %></span>
										<div><b>Available Schmeckles</b></div>
									</li>
									<li class="list-group-item">
										<span id="countdownTimer" class="float-right">60</span>
										<div><b>Refresh Countdown</b></div>
									</li>
								</ul>
							</a>

						</div>

						<div class="col-12 col-xl-3">
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
											If IsNumeric(thisBoostTeamMoneyline1) And thisBoostTeamMoneyline1 > 0 Then
												Response.Write("<input type=""hidden"" id=""inputMoneylineValue1"" name=""inputMoneylineValue1"" value=""" & thisBoostTeamMoneyline1 & """ />")
												BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
											Else
												Response.Write("<input type=""hidden"" id=""inputMoneylineValue1"" name=""inputMoneylineValue1"" value=""" & thisTeamMoneyline1 & """ />")
											End If

											If IsNumeric(thisBoostTeamMoneyline2) And thisBoostTeamMoneyline2 > 0 Then
												Response.Write("<input type=""hidden"" id=""inputMoneylineValue2"" name=""inputMoneylineValue2"" value=""" & thisBoostTeamMoneyline2 & """ />")
												BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
											Else
												Response.Write("<input type=""hidden"" id=""inputMoneylineValue2"" name=""inputMoneylineValue2"" value=""" & thisTeamMoneyline2 & """ />")
											End If
%>
											<input type="hidden" id="inputMoneylineWin" name="inputMoneylineWin" value="" />
											<input type="hidden" id="inputMoneylinePayout" name="inputMoneylinePayout" value="" />

											<label class="form-check-label-lg mt-4" for="inputMoneylineTeam" class="col-form-label"><b>Moneyline</b> <%= BoostText %></label>
											<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg" name="inputMoneylineTeam" id="inputMoneylineTeam" onchange="calculate_moneyline_payout(document.getElementById('inputMoneylineBetAmount').value)" required>
												<option></option>
<%
												If IsNumeric(thisBoostTeamMoneyline1) And thisBoostTeamMoneyline1 > 0 Then
													Response.Write("<option value=""1"">" & thisTeamName1 & " (" & thisBoostTeamMoneyline1 & " ML)</option>")
												Else
													Response.Write("<option value=""1"">" & thisTeamName1 & " (" & thisTeamMoneyline1 & " ML)</option>")
												End If

												If IsNumeric(thisBoostTeamMoneyline2) And thisBoostTeamMoneyline2 > 0 Then
													Response.Write("<option value=""2"">" & thisTeamName2 & " (" & thisBoostTeamMoneyline2 & " ML)</option>")
												Else
													Response.Write("<option value=""2"">" & thisTeamName2 & " (" & thisTeamMoneyline2 & " ML)</option>")
												End If
%>
											</select>

											<label for="inputMoneylineBetAmount" class="col-form-label mt-2"><b>Bet Amount (Schmeckles)</b></label>
											<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= thisSchmeckleTotal %>" id="inputMoneylineBetAmount" name="inputMoneylineBetAmount" onkeyup="calculate_moneyline_payout(this.value)" required>

											<div class="row">
												<div class="col-12 col-md-6">
													<label class="col-form-label mt-3 mb-md-3 mb-sm-0"><b>TO WIN:</b>  <span id="winMoneyline"><span></label>
												</div>
												<div class="col-12 col-md-6">
													<label class="col-form-label mt-3 mb-3"><b>PAYOUT:</b>  <span id="payoutMoneyline"><span></label>
												</div>
											</div>

											<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">Place Bet</button>

										</div>
									</form>

								</div>

							</div>
						</div>

						<div class="col-12 col-xl-3">
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
											If IsNumeric(thisBoostTeamSpreadMoneyline1) And thisBoostTeamSpreadMoneyline1 > 0 Then
												Response.Write("<input type=""hidden"" id=""inputSpreadMoneylineValue1"" name=""inputSpreadMoneylineValue1"" value=""" & thisBoostTeamSpreadMoneyline1 & """ />")
												BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
											Else
												Response.Write("<input type=""hidden"" id=""inputSpreadMoneylineValue1"" name=""inputSpreadMoneylineValue1"" value=""100"" />")
											End If

											If IsNumeric(thisBoostTeamSpreadMoneyline2) And thisBoostTeamSpreadMoneyline2 > 0 Then
												Response.Write("<input type=""hidden"" id=""inputSpreadMoneylineValue2"" name=""inputSpreadMoneylineValue2"" value=""" & thisBoostTeamSpreadMoneyline2 & """ />")
												BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
											Else
												Response.Write("<input type=""hidden"" id=""inputSpreadMoneylineValue2"" name=""inputSpreadMoneylineValue2"" value=""100"" />")
											End If

											If IsNumeric(thisBoostTeamSpread1) And thisBoostTeamSpread1 > 0 Then
												Response.Write("<input type=""hidden"" id=""inputSpreadValue1"" name=""inputSpreadValue1"" value=""" & thisBoostTeamSpread1 & """ />")
												BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
											Else
												Response.Write("<input type=""hidden"" id=""inputSpreadValue1"" name=""inputSpreadValue1"" value=""" & thisTeamSpread1 & """ />")
											End If

											If IsNumeric(thisBoostTeamSpread2) And thisBoostTeamSpread2 > 0 Then
												Response.Write("<input type=""hidden"" id=""inputSpreadValue2"" name=""inputSpreadValue2"" value=""" & thisBoostTeamSpread2 & """ />")
												BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
											Else
												Response.Write("<input type=""hidden"" id=""inputSpreadValue2"" name=""inputSpreadValue2"" value=""" & thisTeamSpread2 & """ />")
											End If
%>
											<input type="hidden" id="inputSpreadWin" name="inputSpreadWin" value="" />
											<input type="hidden" id="inputSpreadPayout" name="inputSpreadPayout" value="" />

											<label class="form-check-label-lg mt-4" for="inputSpreadTeam" class="col-form-label"><b>Point Spread</b> <%= BoostText %></label>
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

											<label for="inputSpreadBetAmount" class="col-form-label mt-2"><b>Bet Amount (Schmeckles)</b></label>
											<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= thisSchmeckleTotal %>" id="inputSpreadBetAmount" name="inputSpreadBetAmount" onkeyup="calculate_spread_payout(this.value)" required>

											<div class="row">
												<div class="col-12 col-md-6">
													<label class="col-form-label mt-3 mb-md-3 mb-sm-0"><b>TO WIN:</b>  <span id="winSpread"><span></label>
												</div>
												<div class="col-12 col-md-6">
													<label class="col-form-label mt-3 mb-3"><b>PAYOUT:</b>  <span id="payoutSpread"><span></label>
												</div>
											</div>

											<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">Place Bet</button>

										</div>
									</form>

								</div>

							</div>
						</div>

						<div class="col-12 col-xl-3">
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

											<label class="form-check-label-lg mt-4" for="inputOverUnderBet" class="col-form-label"><b>Over / Under (Points)</b> <%= BoostText %></label>
											<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg" name="inputOverUnderBet" id="inputOverUnderBet" onchange="calculate_ou_payout(document.getElementById('inputOverUnderBetAmount').value)">
												<option></option>
<%
												If IsNumeric(thisBoostOverUnderTotal) Then

													Response.Write("<option value=""1"">OVER (" & thisBoostOverUnderTotal & ")</option>")

												ElseIf IsNumeric(thisBoostOverTotalMoneyline) Or IsNumeric(thisBoostUnderTotalMoneyline) Then

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

											<label for="inputOverUnderBetAmount" class="col-form-label mt-2"><b>Bet Amount (Schmeckles)</b></label>
											<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= thisSchmeckleTotal %>" id="inputOverUnderBetAmount" name="inputOverUnderBetAmount" onkeyup="calculate_ou_payout(this.value)">

											<div class="row">
												<div class="col-12 col-md-6">
													<label class="col-form-label mt-3 mb-md-3 mb-sm-0"><b>TO WIN:</b>  <span id="winOverUnder"><span></label>
												</div>
												<div class="col-12 col-md-6">
													<label class="col-form-label mt-3 mb-3"><b>PAYOUT:</b>  <span id="payoutOverUnder"><span></label>
												</div>
											</div>

											<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-2">Place Bet</button>

										</div>
									</form>

								</div>

							</div>
						</div>
<%
						sqlGetProps = "SELECT PropQuestions.PropQuestionID, PropQuestions.PropCorrectAnswerID, PropQuestions.MatchupID, PropQuestions.Question FROM PropQuestions WHERE "
						If Session.Contents("SITE_Bet_Type") = "nfl" Then sqlGetProps = sqlGetProps & " NFLGameID = " & thisNFLGameID
						If Session.Contents("SITE_Bet_Type") <> "nfl" Then sqlGetProps = sqlGetProps & " MatchupID = " & thisMatchupID
						Set rsProps = sqlDatabase.Execute(sqlGetProps)

						Do While Not rsProps.Eof

							thisPropQuestionID = rsProps("PropQuestionID")
							thisPropQuestion = rsProps("Question")
%>
							<div class="col-12 col-xl-3">

								<div class="card">

									<div class="card-body pb-0 pt-0">

										<form action="<%= thisMatchupURL %>" method="post">

											<div class="form-group">

												<input type="hidden" id="inputTicketGo" name="inputTicketGo" value="go" />
												<input type="hidden" id="inputTicketType" name="inputTicketType" value="4" />
												<input type="hidden" id="inputMatchupID" name="inputMatchupID" value="<%= thisMatchupID %>" />
												<input type="hidden" id="inputNFLGameID" name="inputNFLGameID" value="<%= thisNFLGameID %>" />
												<input type="hidden" id="inputPropQuestionID" name="inputPropQuestionID" value="<%= thisPropQuestionID %>" />
												<input type="hidden" id="inputPropWin<%= thisPropQuestionID %>" name="inputPropWin<%= thisPropQuestionID %>" value="" />
												<input type="hidden" id="inputPropPayout<%= thisPropQuestionID %>" name="inputPropPayout<%= thisPropQuestionID %>" value="" />
<%
												sqlGetAnswers = "SELECT * FROM PropAnswers WHERE PropQuestionID = " & thisPropQuestionID
												Set rsAnswers = sqlDatabase.Execute(sqlGetAnswers)

												Do While Not rsAnswers.Eof

													Response.Write("<input type=""hidden"" id=""inputPropBetMoneyline" & rsAnswers("PropAnswerID") & """ name=""inputPropBetMoneyline" & rsAnswers("PropAnswerID") & """ value=""" & rsAnswers("Moneyline") & """ />")
													rsAnswers.MoveNext

												Loop

												rsAnswers.MoveFirst
%>
												<label class="form-check-label-lg mt-4" for="inputPropAnswer<%= thisPropQuestionID %>" class="col-form-label"><b><%= thisPropQuestion %></b></label>
												<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg" name="inputPropAnswer<%= thisPropQuestionID %>" id="inputPropAnswer<%= thisPropQuestionID %>" onchange="calculate_prop_payout(<%= thisPropQuestionID %>, document.getElementById('inputPropBetAmount<%= thisPropQuestionID %>').value)">
													<option></option>
<%
													Do While Not rsAnswers.Eof

														thisPropAnswerID = rsAnswers("PropAnswerID")
														thisPropAnswer = rsAnswers("Answer")
														thisPropMoneyline = rsAnswers("Moneyline")

														If CInt(thisPropMoneyline) > 0 Then thisPropMoneyline = "+" & thisPropMoneyline

														Response.Write("<option value=""" & thisPropAnswerID & """>" & thisPropAnswer & " (" & thisPropMoneyline & " ML)</option>")
														rsAnswers.MoveNext

													Loop

													rsAnswers.Close
													Set rsAnswers = Nothing
%>
												</select>

												<label for="inputPropBetAmount<%= thisPropQuestionID %>" class="col-form-label mt-2"><b>Bet Amount (Schmeckles)</b></label>
												<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= thisSchmeckleTotal %>" id="inputPropBetAmount<%= thisPropQuestionID %>" name="inputPropBetAmount<%= thisPropQuestionID %>" onkeyup="calculate_prop_payout(<%= thisPropQuestionID %>, this.value)">

												<div class="row">
													<div class="col-12 col-md-6">
														<label class="col-form-label mt-3 mb-md-3 mb-sm-0"><b>TO WIN:</b>  <span id="winPropBet<%= thisPropQuestionID %>"><span></label>
													</div>
													<div class="col-12 col-md-6">
														<label class="col-form-label mt-3 mb-3"><b>PAYOUT:</b>  <span id="payoutPropBet<%= thisPropQuestionID %>"><span></label>
													</div>
												</div>

												<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success">Place Bet</button>

											</div>

										</form>

									</div>

								</div>

							</div>
<%
							rsProps.MoveNext

						Loop

						rsProps.Close
						Set rsProps = Nothing
%>
					</div>
<%
					ticketsAccountID = ""
					ticketsTypeID = ""
					ticketsNFLGameID = ""
					ticketsMatchupID = ""
					ticketsProcessed = ""

					If Len(thisNFLGameID) > 0 Then ticketsNFLGameID = thisNFLGameID
					If Len(thisMatchupID) > 0 Then ticketsMatchupID = thisMatchupID

					Call TicketRow (ticketsNFLGameID, ticketsMatchupID, ticketsAccountID, ticketsTypeID, ticketsProcessed, 0)
%>
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

		<script>

			function calculate_moneyline_payout(stake) {

				var isPositive = true;
				var payout = 0;
				var betTeam = document.getElementById("inputMoneylineTeam").value;

				if (betTeam == 1) { moneylineValue = document.getElementById("inputMoneylineValue1").value } else { moneylineValue = document.getElementById("inputMoneylineValue2").value }

				if(moneylineValue.toString().search("-") > -1) { isPositive = false; }

				moneylineValue = moneylineValue.replace("+","").replace("-","");

				if(isPositive) {
					document.getElementById("winMoneyline").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
					document.getElementById("payoutMoneyline").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
					document.getElementById("inputMoneylineWin").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
					document.getElementById("inputMoneylinePayout").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
				} else {
					document.getElementById("winMoneyline").innerHTML = numberWithCommas(parseInt(stake / (moneylineValue / 100)));
					document.getElementById("payoutMoneyline").innerHTML = numberWithCommas(parseInt(stake / (moneylineValue / 100)) + parseInt(stake));
					document.getElementById("inputMoneylineWin").value = numberWithCommas(parseInt(stake / (moneylineValue / 100)));
					document.getElementById("inputMoneylinePayout").value = numberWithCommas(parseInt(stake / (moneylineValue / 100)) + parseInt(stake));
				}

				return 0;

			}

			function calculate_spread_payout(stake) {

				var payout = 0;
				moneylineValue = 100;

				document.getElementById("winSpread").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
				document.getElementById("payoutSpread").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
				document.getElementById("inputSpreadWin").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
				document.getElementById("inputSpreadPayout").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));

				return 0;

			}

			function calculate_ou_payout(stake) {

				var payout = 0;
				moneylineValue = 100;

				document.getElementById("winOverUnder").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
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
					document.getElementById("winPropBet" + propID).innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
					document.getElementById("payoutPropBet" + propID).innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
					document.getElementById("inputPropWin" + propID).value = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
					document.getElementById("inputPropPayout" + propID).value = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
				} else {
					document.getElementById("winPropBet" + propID).innerHTML = numberWithCommas(parseInt(stake / (moneylineValue / 100)));
					document.getElementById("payoutPropBet" + propID).innerHTML = numberWithCommas(parseInt(stake / (moneylineValue / 100)) + parseInt(stake));
					document.getElementById("inputPropWin" + propID).value = numberWithCommas(parseInt(stake / (moneylineValue / 100)));
					document.getElementById("inputPropPayout" + propID).value = numberWithCommas(parseInt(stake / (moneylineValue / 100)) + parseInt(stake));
				}

				return 0;

			}

			function numberWithCommas(x) { return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); }

			var countdownTimer = new Date();
			countdownTimer.setSeconds( countdownTimer.getSeconds() + 60 );

			var x = setInterval(function() {

				var now = new Date().getTime();

				var distance = countdownTimer - now;

				var seconds = Math.floor((distance % (1000 * 60)) / 1000);

				document.getElementById("countdownTimer").innerHTML = seconds;

				if (distance <= 0) {
					clearInterval(x);
					window.location.href = "<%= thisMatchupURL %>";
				}

			}, 1000);

		</script>

	</body>

</html>
