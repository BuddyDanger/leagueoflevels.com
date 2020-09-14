<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	thisSchmeckleTotal = 0

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

			If CInt(thisSchmeckleTotal) >= CInt(thisMoneylineBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				rsInsert("MatchupID") = thisMatchupID
				rsInsert("TeamID") = betTeamID
				rsInsert("Moneyline") = betMoneylineValue
				rsInsert("BetAmount") = thisMoneylineBetAmount
				rsInsert("PayoutAmount") = thisMoneylinePayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "SchmeckleTransactions", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TransactionTypeID") = 1008
				rsInsert("TransactionTotal") = thisMoneylineBetAmount * -1
				rsInsert("AccountID") = Session.Contents("AccountID")
				rsInsert("TicketSlipID") = thisTicketSlipID

				rsInsert.Update
				Set rsInsert = Nothing

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

			If CInt(thisSchmeckleTotal) >= CInt(thisSpreadBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				rsInsert("MatchupID") = thisMatchupID
				rsInsert("TeamID") = betTeamID
				rsInsert("Spread") = betSpreadValue
				rsInsert("BetAmount") = thisSpreadBetAmount
				rsInsert("PayoutAmount") = thisSpreadPayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "SchmeckleTransactions", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TransactionTypeID") = 1008
				rsInsert("TransactionTotal") = thisSpreadBetAmount * -1
				rsInsert("AccountID") = Session.Contents("AccountID")
				rsInsert("TicketSlipID") = thisTicketSlipID

				rsInsert.Update
				Set rsInsert = Nothing

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

			If CInt(thisSchmeckleTotal) >= CInt(thisOverUnderBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				rsInsert("MatchupID") = thisMatchupID
				rsInsert("TeamID") = 0
				rsInsert("OverUnderAmount") = thisOverUnderAmount
				rsInsert("OverUnderBet") = thisOverUnderBet
				rsInsert("BetAmount") = thisOverUnderBetAmount
				rsInsert("PayoutAmount") = thisOverUnderPayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "SchmeckleTransactions", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TransactionTypeID") = 1008
				rsInsert("TransactionTotal") = thisOverUnderBetAmount * -1
				rsInsert("AccountID") = Session.Contents("AccountID")
				rsInsert("TicketSlipID") = thisTicketSlipID

				rsInsert.Update
				Set rsInsert = Nothing

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

	sqlGetSchedules = "SELECT MatchupID, Matchups.LevelID, Year, Period, IsPlayoffs, TeamID1, TeamID2, Team1.TeamName AS TeamName1, Team2.TeamName AS TeamName2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2, Leg, TeamProjected1, TeamProjected2, TeamWinPercentage1, TeamWinPercentage2, TeamMoneyline1, TeamMoneyline2, TeamSpread1, TeamSpread2 FROM Matchups "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team1 ON Team1.TeamID = Matchups.TeamID1 "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team2 ON Team2.TeamID = Matchups.TeamID2 "
	sqlGetSchedules = sqlGetSchedules & "WHERE Matchups.MatchupID = " & Session.Contents("SITE_Bet_MatchupID") & " "
	sqlGetSchedules = sqlGetSchedules & "ORDER BY CASE WHEN Matchups.LevelID = 1 THEN '1' WHEN Matchups.LevelID = 0 THEN '2' WHEN Matchups.LevelID = 2 THEN '3' WHEN Matchups.LevelID = 3 THEN '4' ELSE Matchups.LevelID END ASC, Matchups.MatchupID DESC"
	Set rsSchedules = sqlDatabase.Execute(sqlGetSchedules)

	If Not rsSchedules.Eof Then

		thisMatchupID = rsSchedules("MatchupID")
		thisLevelID = rsSchedules("LevelID")
		thisYear = rsSchedules("Year")
		thisPeriod = rsSchedules("Period")
		thisTeamID1 = rsSchedules("TeamID1")
		thisTeamID2 = rsSchedules("TeamID2")
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

		rsSchedules.Close
		Set rsSchedules = Nothing

		pageTitle = "Sportsbook / " & thisTeamName1 & " vs. " & thisTeamName2 & " / " & thisYear & " (Period " & thisPeriod & ") / League of Levels"

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

				<div class="container-fluid">

					<div class="row">

						<div class="col-sm-12">

							<div class="page-title-box">

								<div class="float-right">

									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="/">Main</a></li>
										<li class="breadcrumb-item active"><a href="/sportsbook/">Sportsbook</a></li>
									</ol>

								</div>

								<h4 class="page-title"><a href="/sportsbook/">Sportsbook</a> / Matchup #<%= Session.Contents("SITE_Bet_MatchupID") %></h4>

							</div>

							<div class="page-content">

								<div class="row">
<%
									If thisTeamWinPercentage1 < 0.2 Or thisTeamWinPercentage1 > 0.8 Then thisFormDisabled = "disabled"

									thisTeamWinPercentage1 = (thisTeamWinPercentage1 * 100) & "%"
									thisTeamWinPercentage2 = (thisTeamWinPercentage2 * 100) & "%"

									If thisTeamMoneyline1 > 0 Then thisTeamMoneyline1 = "+" & thisTeamMoneyline1
									If thisTeamMoneyline2 > 0 Then thisTeamMoneyline2 = "+" & thisTeamMoneyline2

									If thisTeamSpread1 > 0 Then thisTeamSpread1 = "+" & thisTeamSpread1
									If thisTeamSpread2 > 0 Then thisTeamSpread2 = "+" & thisTeamSpread2

									If CInt(thisLevelID) = 0 Then
										headerBGcolor = "D00000"
										headerTextColor = "fff"
										headerText = "CUP"
										cardText = "520000"
									End If
									If CInt(thisLevelID) = 1 Then
										headerBGcolor = "FFBA08"
										headerTextColor = "fff"
										headerText = "OMEGA"
										cardText = "805C04"
									End If
									If CInt(thisLevelID) = 2 Then
										headerBGcolor = "136F63"
										headerTextColor = "fff"
										headerText = "SAME LEVEL"
										cardText = "0F574D"
									End If
									If CInt(thisLevelID) = 3 Then
										headerBGcolor = "032B43"
										headerTextColor = "fff"
										headerText = "FARM LEVEL"
										cardText = "03324F"
									End If
%>
									<div class="col-xxxl-4 col-xxl-4 col-xl-4 col-lg-12 col-md-12 col-sm-12 col-xs-12 col-xxs-12">
										<a href="/sportsbook/<%= thisMatchupID %>/" style="text-decoration: none; display: block;">
											<ul class="list-group" style="margin-bottom: 1rem;">
												<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #<%= headerBGcolor %>; color: #<%= headerTextColor %>;"><strong><%= headerText %></strong> #<%= thisMatchupID %></li>
												<li class="list-group-item">
													<span style="font-size: 1em; background-color: #fff; color: #<%= cardText %>; float: right;"><%= thisTeamScore1 %></span>
													<div style="font-size: 13px; color: #<%= cardText %>;"><b><%= thisTeamName1 %></b></div>
													<div style="font-size: 13px; color: #<%= cardText %>;"><%= thisTeamProjected1 %> Proj., <%= thisTeamWinPercentage1 %> Win, <%= thisTeamSpread1 %> Spread, <%= thisTeamMoneyline1 %> ML</div>
												</li>
												<li class="list-group-item">
													<span style="font-size: 1em; background-color: #fff; color: #<%= cardText %>; float: right;"><%= thisTeamScore2 %></span>
													<div style="font-size: 13px; color: #<%= cardText %>;"><b><%= thisTeamName2 %></b></div>
													<div style="font-size: 13px; color: #<%= cardText %>;"><%= thisTeamProjected2 %> Proj., <%= thisTeamWinPercentage2 %> Win, <%= thisTeamSpread2 %> Spread, <%= thisTeamMoneyline2 %> ML</div>
												</li>
											</ul>
										</a>
									</div>

									<div class="col-xxxl-4 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-6 col-xs-6 col-xxs-6">
										<ul class="list-group" style="margin-bottom: 1rem;">
											<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #<%= headerBGcolor %>; color: #<%= headerTextColor %>;"><strong>YOUR SCHMECKLE TOTAL</strong></li>
											<li class="list-group-item text-center" style="color: #<%= cardText %>;">
												<h1 class="mb-0 mt-2 pt-2"><%= FormatNumber(thisSchmeckleTotal, 0) %></h1>
												<div class="mb-3 pb-1">SCHMECKLES</div>
											</li>
										</ul>
									</div>

									<div class="col-xxxl-4 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-6 col-xs-6 col-xxs-6">
										<ul class="list-group" style="margin-bottom: 1rem;">
											<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #<%= headerBGcolor %>; color: #<%= headerTextColor %>;"><strong>REFRESH COUNTDOWN</strong></li>
											<li class="list-group-item text-center" style="color: #<%= cardText %>;">
												<h1 class="mb-0 mt-2 pt-2" id="countdownTimer">59</h1>
												<div class="mb-3 pb-1">SECONDS</div>
											</li>
										</ul>
									</div>

								</div>

								<div class="row">

									<div class="col-12 col-xl-4 col-lg-6">
										<div class="card">

											<div class="card-body">

												<div style="border-bottom: 1px solid #e8ebf3;"><h4>Moneyline Wager</h4></div>

												<form action="/sportsbook/<%= thisMatchupID %>/" method="post">
													<div class="form-group">

														<input type="hidden" id="inputTicketGo" name="inputTicketGo" value="go" />
														<input type="hidden" id="inputTicketType" name="inputTicketType" value="1" />
														<input type="hidden" id="inputMatchupID" name="inputMatchupID" value="<%= thisMatchupID %>" />
														<input type="hidden" id="inputTeamID1" name="inputTeamID1" value="<%= thisTeamID1 %>" />
														<input type="hidden" id="inputTeamID2" name="inputTeamID2" value="<%= thisTeamID2 %>" />
														<input type="hidden" id="inputMoneylineValue1" name="inputMoneylineValue1" value="<%= thisTeamMoneyline1 %>" />
														<input type="hidden" id="inputMoneylineValue2" name="inputMoneylineValue2" value="<%= thisTeamMoneyline2 %>" />
														<input type="hidden" id="inputMoneylineWin" name="inputMoneylineWin" value="" />
														<input type="hidden" id="inputMoneylinePayout" name="inputMoneylinePayout" value="" />

														<label class="form-check-label-lg mt-4" for="inputMoneylineTeam" class="col-form-label"><b>Team (ML)</b></label>
														<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg" name="inputMoneylineTeam" id="inputMoneylineTeam" onchange="calculate_moneyline_payout(document.getElementById('inputMoneylineBetAmount').value)" required>
															<option></option>
															<option value="1"><%= thisTeamName1 %> (<%= thisTeamMoneyline1 %> ML)</option>
															<option value="2"><%= thisTeamName2 %> (<%= thisTeamMoneyline2 %> ML)</option>
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

									<div class="col-12 col-xl-4 col-lg-6">
										<div class="card">

											<div class="card-body">

												<div style="border-bottom: 1px solid #e8ebf3;"><h4>Point Spread Wager</h4></div>

												<form action="/sportsbook/<%= thisMatchupID %>/" method="post">
													<div class="form-group">

														<input type="hidden" id="inputTicketGo" name="inputTicketGo" value="go" />
														<input type="hidden" id="inputTicketType" name="inputTicketType" value="2" />
														<input type="hidden" id="inputMatchupID" name="inputMatchupID" value="<%= thisMatchupID %>" />
														<input type="hidden" id="inputTeamID1" name="inputTeamID1" value="<%= thisTeamID1 %>" />
														<input type="hidden" id="inputTeamID2" name="inputTeamID2" value="<%= thisTeamID2 %>" />
														<input type="hidden" id="inputSpreadValue1" name="inputSpreadValue1" value="<%= thisTeamSpread1 %>" />
														<input type="hidden" id="inputSpreadValue2" name="inputSpreadValue2" value="<%= thisTeamSpread2 %>" />
														<input type="hidden" id="inputSpreadWin" name="inputSpreadWin" value="" />
														<input type="hidden" id="inputSpreadPayout" name="inputSpreadPayout" value="" />

														<label class="form-check-label-lg mt-4" for="inputSpreadTeam" class="col-form-label"><b>Team (Spread)</b></label>
														<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg" name="inputSpreadTeam" id="inputSpreadTeam" onchange="calculate_spread_payout('document.getElementById('inputSpreadBetAmount').value')" required>
															<option></option>
															<option value="1"><%= thisTeamName1 %> (<%= thisTeamSpread1 %>)</option>
															<option value="2"><%= thisTeamName2 %> (<%= thisTeamSpread2 %>)</option>
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

									<div class="col-12 col-xl-4 col-lg-6">
										<div class="card">

											<div class="card-body">

												<div style="border-bottom: 1px solid #e8ebf3;"><h4>Over / Under Wager</h4></div>

												<form action="/sportsbook/<%= thisMatchupID %>/" method="post">
													<div class="form-group">

														<input type="hidden" id="inputTicketGo" name="inputTicketGo" value="go" />
														<input type="hidden" id="inputTicketType" name="inputTicketType" value="3" />
														<input type="hidden" id="inputMatchupID" name="inputMatchupID" value="<%= thisMatchupID %>" />
														<input type="hidden" id="inputOverUnderAmount" name="inputOverUnderAmount" value="<%= thisTeamProjected1 + thisTeamProjected2 %>" />
														<input type="hidden" id="inputOverUnderWin" name="inputOverUnderWin" value="" />
														<input type="hidden" id="inputOverUnderPayout" name="inputOverUnderPayout" value="" />

														<label class="form-check-label-lg mt-4" for="inputOverUnderBet" class="col-form-label"><b>Over / Under (Points)</b></label>
														<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg" name="inputOverUnderBet" id="inputOverUnderBet" onchange="calculate_ou_payout(document.getElementById('inputOverUnderBetAmount').value)">
															<option></option>
															<option value="1">OVER (<%= thisTeamProjected1 + thisTeamProjected2 %>)</option>
															<option value="2">UNDER (<%= thisTeamProjected1 + thisTeamProjected2 %>)</option>
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

														<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">Place Bet</button>

													</div>
												</form>

											</div>

										</div>
									</div>

								</div>

								<div class="row">
<%
									sqlGetTicketSlips = "SELECT TicketSlipID, TicketTypeID, TicketSlips.AccountID, Accounts.ProfileName, TicketSlips.InsertDateTime, Matchups.TeamID1, Matchups.TeamID2, T1.TeamName AS TeamName1, T2.TeamName AS TeamName2, T3.TeamName AS BetTeamName, TicketSlips.TeamID, TicketSlips.Moneyline, TicketSlips.Spread, TicketSlips.OverUnderAmount, OverUnderBet, TicketSlips.BetAmount, TicketSlips.PayoutAmount, TicketSlips.IsWinner FROM TicketSlips "
									sqlGetTicketSlips = sqlGetTicketSlips & "INNER JOIN Accounts ON Accounts.AccountID = TicketSlips.AccountID "
									sqlGetTicketSlips = sqlGetTicketSlips & "INNER JOIN Matchups ON Matchups.MatchupID = TicketSlips.MatchupID "
									sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN Teams T1 ON T1.TeamID = Matchups.TeamID1 "
									sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN Teams T2 ON T2.TeamID = Matchups.TeamID2 "
									sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN Teams T3 ON T3.TeamID = TicketSlips.TeamID "
									sqlGetTicketSlips = sqlGetTicketSlips & "WHERE TicketSlips.MatchupID = " & thisMatchupID
									Set rsTicketSlips = sqlDatabase.Execute(sqlGetTicketSlips)

									Do While Not rsTicketSlips.Eof

										thisTicketSlipID = rsTicketSlips("TicketSlipID")
										thisTicketTypeID = rsTicketSlips("TicketTypeID")
										thisAccountID = rsTicketSlips("AccountID")
										thisProfileName = rsTicketSlips("ProfileName")
										thisInsertDateTime = rsTicketSlips("InsertDateTime")
										thisTeamName1 = rsTicketSlips("TeamName1")
										thisTeamName2 = rsTicketSlips("TeamName2")
										thisBetTeamName = rsTicketSlips("BetTeamName")
										thisMoneyline = rsTicketSlips("Moneyline")
										thisSpread = rsTicketSlips("Spread")
										thisOverUnderAmount = rsTicketSlips("OverUnderAmount")
										thisOverUnderBet = rsTicketSlips("OverUnderBet")
										thisBetAmount = rsTicketSlips("BetAmount")
										thisPayoutAmount = rsTicketSlips("PayoutAmount")
										thisIsWinner = rsTicketSlips("IsWinner")

										If CInt(thisTicketTypeID) = 1 Then
											If thisMoneyline > 0 Then thisMoneyline = "+" & thisMoneyline
											thisTicketDetails = thisMoneyline & " ML"
										End If
										If CInt(thisTicketTypeID) = 2 Then
											If thisSpread > 0 Then thisSpread = "+" & thisSpread
											thisTicketDetails = "(" & thisSpread & ")"
										End If
										If CInt(thisTicketTypeID) = 3 Then
											thisTicketDetails = thisOverUnderBet & " (" & thisOverUnderAmount & ")"
										End If
%>
										<div class="col-xxxl-3 col-xxl-3 col-xl-4 col-lg-4 col-md-4 col-sm-12 col-xs-12 col-xxs-12">
											<ul class="list-group" style="margin-bottom: 1rem;">
												<li class="list-group-item text-center">
													<div><b><%= thisBetTeamName %>&nbsp;<%= thisTicketDetails %></b></div>
													<div><i><%= thisInsertDateTime %> (UTC)</i></div>
													<div class="row pt-2">
														<div class="col-6" style="border-right: 1px dashed #edebf1;">
															<div><u>WAGER</u></div>
															<div><%= FormatNumber(thisBetAmount, 0) %></div>
														</div>
														<div class="col-6">
															<div><u>PAYOUT</u></div>
															<div><%= FormatNumber(thisPayoutAmount, 0) %></div>
														</div>
													</div>
												</li>
												<li class="list-group-item text-center">
													<div><b>Ticket Owner:</b> <%= thisProfileName %></div>
												</li>
											</ul>
										</div>
<%
										rsTicketSlips.MoveNext

									Loop
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

		<script>

			function calculate_moneyline_payout(stake){

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

			function calculate_spread_payout(stake){

				var payout = 0;
				moneylineValue = 100;

				document.getElementById("winSpread").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
				document.getElementById("payoutSpread").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
				document.getElementById("inputSpreadWin").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
				document.getElementById("inputSpreadPayout").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));

				return 0;

			}

			function calculate_ou_payout(stake){

				var payout = 0;
				moneylineValue = 100;

				document.getElementById("winOverUnder").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
				document.getElementById("payoutOverUnder").innerHTML = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));
				document.getElementById("inputOverUnderWin").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)));
				document.getElementById("inputOverUnderPayout").value = numberWithCommas(parseInt(stake * (moneylineValue / 100)) + parseInt(stake));

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
					window.location.href = "/sportsbook/<%= thisMatchupID %>/";
				}

			}, 1000);

		</script>

	</body>

</html>
