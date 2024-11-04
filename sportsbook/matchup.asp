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

		sqlGetSchedules = "SELECT MatchupID, Matchups.LevelID, Year, Period, IsPlayoffs, TeamID1, TeamID2, Team1.LevelID AS TeamLevelID1, Team2.LevelID AS TeamLevelID2, Team1.CBSID AS TeamCBSID1, Team2.CBSID AS TeamCBSID2, Account1.ProfileImage AS ProfileImage1, Account2.ProfileImage AS ProfileImage2, Team1.TeamName AS TeamName1, Team2.TeamName AS TeamName2, Team1.AbbreviatedName AS AbbreviatedName1, Team2.AbbreviatedName AS AbbreviatedName2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2, Leg, TeamProjected1, TeamProjected2, TeamWinPercentage1, TeamWinPercentage2, TeamMoneyline1, TeamMoneyline2, TeamSpread1, TeamSpread2, Matchups.TeamOmegaTravel1, Matchups.TeamOmegaTravel2 FROM Matchups "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team1 ON Team1.TeamID = Matchups.TeamID1 "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team2 ON Team2.TeamID = Matchups.TeamID2 "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN Levels AS Level1 ON Level1.LevelID = Team1.LevelID "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN Levels AS Level2 ON Level2.LevelID = Team2.LevelID "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Team1.TeamID "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Team2.TeamID "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN Accounts AS Account1 ON Account1.AccountID = Link1.AccountID "
		sqlGetSchedules = sqlGetSchedules & "INNER JOIN Accounts AS Account2 ON Account2.AccountID = Link2.AccountID "
		sqlGetSchedules = sqlGetSchedules & "WHERE Matchups.MatchupID = " & Session.Contents("SITE_Bet_MatchupID") & ";"

		Set rsSchedules = sqlDatabase.Execute(sqlGetSchedules)

		If Not rsSchedules.Eof Then

			thisNFLGameID = ""
			thisMatchupID = rsSchedules("MatchupID")
			thisMatchupLevelID = rsSchedules("LevelID")
			thisYear = rsSchedules("Year")
			thisPeriod = rsSchedules("Period")
			thisTeamID1 = rsSchedules("TeamID1")
			thisTeamID2 = rsSchedules("TeamID2")
			thisProfileImage1 = rsSchedules("ProfileImage1")
			thisProfileImage2 = rsSchedules("ProfileImage2")
			thisTeamLevelID1 = rsSchedules("TeamLevelID1")
			thisTeamLevelID2 = rsSchedules("TeamLevelID2")
			thisTeamCBSID1 = rsSchedules("TeamCBSID1")
			thisTeamCBSID2 = rsSchedules("TeamCBSID2")
			thisTeamName1 = rsSchedules("TeamName1")
			thisTeamName2 = rsSchedules("TeamName2")
			thisAbbreviatedName1 = rsSchedules("AbbreviatedName1")
			thisAbbreviatedName2 = rsSchedules("AbbreviatedName2")
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
			thisLeg = rsSchedules("Leg")
			thisTeamOmegaTravel1 = rsSchedules("TeamOmegaTravel1")
			thisTeamOmegaTravel2 = rsSchedules("TeamOmegaTravel2")
			thisOverUnderTotal = thisTeamProjected1 + thisTeamProjected2

			If thisTeamLevelID1 = 1 Then thisTeamLevelTitle1 = "omega"
			If thisTeamLevelID1 = 2 Then thisTeamLevelTitle1 = "samelevel"
			If thisTeamLevelID1 = 3 Then thisTeamLevelTitle1 = "farmlevel"
			If thisTeamLevelID1 = 4 Then thisTeamLevelTitle1 = "bestlevel"

			If thisTeamLevelID2 = 1 Then thisTeamLevelTitle2 = "omega"
			If thisTeamLevelID2 = 2 Then thisTeamLevelTitle2 = "samelevel"
			If thisTeamLevelID2 = 3 Then thisTeamLevelTitle2 = "farmlevel"
			If thisTeamLevelID2 = 4 Then thisTeamLevelTitle2 = "bestlevel"

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

		<style>

			@media (max-width:1200px) {	.gamestats { display: none !important; } }

			@media (max-width:768px) { .page-content { padding: 0 !important; padding-bottom: 2rem !important; } }

			.is-loading {
				background: linear-gradient(to right, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.5) 50%, rgba(255, 255, 255, 0) 100%);
				background-size: 75% 100%;
				animation-duration: 1500ms;
				animation-name: headerShine;
				animation-iteration-count: infinite;
				background-repeat: no-repeat;
				animation-timing-function: ease;
				background-position: 0 0;
				background-color: #166dc1;
				background-blend-mode: overlay;
			}

			.progress-bar-name {
				background-color: #ddd;
				height: 12px;
				width: 30%;
				border-radius: 100px;
			}

			.progress-bar-gameline {
				background-color: #ddd;
				height: 12px;
				width: 70%;
				border-radius: 100px;
			}

			.progress-bar-photo {
				height: 40px;
				width: 40px; height: 40px;
				background-color: #ddd;
				border-radius: 50%;
			}

			.inactive-player { background-color:#fafafa; }

			@keyframes headerShine {
				0% { background-position: -300% 0; }
				100% { background-position: 500% 0; }
			}

		</style>

	</head>

	<body>

		<!--#include virtual="/assets/asp/framework/topbar.asp" -->

		<div class="page-wrapper">

			<!--#include virtual="/assets/asp/framework/nav.asp" -->

			<div class="page-content">

				<div class="container-fluid pl-0 pl-lg-2 pr-0 pr-lg-2">

					<div class="row mt-0 mt-xl-4">
						<div class="col-12 col-xl-4 pl-0 pl-lg-2 pr-0 pr-lg-2">

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
								headerText = "NEXT LEVEL CUP"
								cardText = "520000"
							End If
							If CInt(thisMatchupLevelID) = 1 Then
								headerBGcolor = "FFBA08"
								headerTextColor = "fff"
								headerText = "OMEGA LEVEL"
								cardText = "520000"
							End If
							If CInt(thisMatchupLevelID) = 2 Then
								headerBGcolor = "136F63"
								headerTextColor = "fff"
								headerText = "SAME LEVEL"
								cardText = "0F574D"
							End If
							If CInt(thisMatchupLevelID) = 3 Then
								headerBGcolor = "995D81"
								headerTextColor = "fff"
								headerText = "FARM LEVEL"
								cardText = "03324F"
							End If
							If CInt(thisMatchupLevelID) = 4 Then
								headerBGcolor = "39A9DB"
								headerTextColor = "fff"
								headerText = "BEST LEVEL"
								cardText = "03324F"
							End If
							If CInt(thisMatchupLevelID) = 5 Then
								headerBGcolor = "CDE7B0"
								headerTextColor = "003985"
								headerText = "TAG TEAM DIVISION"
								cardText = "84DD63"
							End If

						End If
%>
						<div>

							<ul class="list-group mb-4">
<%
								If Session.Contents("SITE_Bet_Type") = "nfl" Then
%>
									<li class="list-group-item p-0"><h4 class="text-left text-white p-3 mt-0 mb-0 rounded-top bg-dark"><strong><%= headerText %></strong> <%= thisGameTimeEST %></h4></li>
<%
								Else
%>
									<li class="list-group-item p-0">
										<h4 class="text-left text-white p-3 mt-0 mb-0 rounded-top bg-dark"><strong><%= headerText %></strong> #<%= thisMatchupID %><span id="countdownTimer" class="float-right badge badge-sm badge-primary py-1">180</span></h4>
									</li>
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

								<a class="list-group-item" href="/schmeckles/<%= Session.Contents("AccountProfileURL") %>/">
									<div class="float-right"><%= FormatNumber(thisSchmeckleTotal, 0) %></div>
									<div><b>Available Schmeckles</b></div>
								</a>
							</ul>

						</div>

						<div class="accordion mb-4" id="bettingOptions">

							<div class="card mb-0" style="border-bottom: 1px solid #fff;">

								<div class="card-header bg-warning text-black-50" id="bettingOptions_Heading1" data-toggle="collapse" data-target="#collapse1" aria-expanded="true" aria-controls="collapse1"><b>MONEYLINE</b> <%= BoostText %></div>

								<div id="collapse1" class="collapse show" aria-labelledby="bettingOptions_Heading1" data-parent="#bettingOptions">

									<div class="card-body pb-0 pt-0">

										<form id="betMoneyline" action="/sportsbook/submit-bet/">
											<div class="form-group pt-3 pb-0 mb-0">

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

												<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg mb-3" name="inputMoneylineTeam" id="inputMoneylineTeam" onchange="calculate_moneyline_payout(document.getElementById('inputMoneylineBetAmount').value)" required>
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

												<div class="row">
													<div class="col-9 px-2 py-0 m-0">
														<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= thisSchmeckleTotal %>" id="inputMoneylineBetAmount" name="inputMoneylineBetAmount" onkeyup="calculate_moneyline_payout(this.value)" required>
													</div>
													<div class="col-3 px-2 py-0 m-0">
														<button id="moneylineButton" <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">Bet</button>
													</div>
												</div>

											</div>
										</form>

									</div>

									<div class="card-footer py-2">
										<div class="row py-0">
											<div class="col-6 py-0">
												<label class="col-form-label"><small><b>TO WIN:</b>  <span id="winMoneyline"></span></small></label>
											</div>
											<div class="col-6 py-0">
												<label class="col-form-label"><small><b>PAYOUT:</b>  <span id="payoutMoneyline"></span></small></label>
											</div>
										</div>
									</div>

								</div>

							</div>

							<div class="card mb-0" style="border-bottom: 1px solid #fff;">

								<div class="card-header bg-warning text-black-50" id="bettingOptions_Heading2" data-toggle="collapse" data-target="#collapse2" aria-expanded="false" aria-controls="collapse2"><b>POINT SPREAD</b> <%= BoostText %></div>

								<div id="collapse2" class="collapse" aria-labelledby="bettingOptions_Heading2" data-parent="#bettingOptions">

									<div class="card-body pb-0 pt-0">

										<form id="betSpread" action="/sportsbook/submit-bet/">
											<div class="form-group pt-3 pb-0 mb-0">

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

												<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg mb-3" name="inputSpreadTeam" id="inputSpreadTeam" onchange="calculate_spread_payout(document.getElementById('inputSpreadBetAmount').value);" required>
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

												<div class="row">
													<div class="col-9 px-2 py-0 m-0">
														<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= thisSchmeckleTotal %>" id="inputSpreadBetAmount" name="inputSpreadBetAmount" onkeyup="calculate_spread_payout(this.value)" required>
													</div>
													<div class="col-3 px-2 py-0 m-0">
														<button id="spreadButton" <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">Bet</button>
													</div>
												</div>

											</div>
										</form>

									</div>

									<div class="card-footer py-2">
										<div class="row py-0">
											<div class="col-6 py-0">
												<label class="col-form-label"><small><b>TO WIN:</b>  <span id="winSpread"></span></small></label>
											</div>
											<div class="col-6 py-0">
												<label class="col-form-label"><small><b>PAYOUT:</b>  <span id="payoutSpread"></span></small></label>
											</div>
										</div>
									</div>

								</div>

							</div>

							<div class="card mb-0">

								<div class="card-header bg-warning text-black-50" id="bettingOptions_Heading3" data-toggle="collapse" data-target="#collapse3" aria-expanded="false" aria-controls="collapse3"><b>POINT TOTAL</b> <%= BoostText %></div>

								<div id="collapse3" class="collapse" aria-labelledby="bettingOptions_Heading3" data-parent="#bettingOptions">

									<div class="card-body pb-0 pt-0">

										<form id="betTotal" action="/sportsbook/submit-bet/">
											<div class="form-group pt-3 pb-0 mb-0">

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

												<select <%= thisFormDisabled %> class="form-control form-control-lg form-check-input-lg mb-3" name="inputOverUnderBet" id="inputOverUnderBet" onchange="calculate_ou_payout(document.getElementById('inputOverUnderBetAmount').value)">
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

												<div class="row">
													<div class="col-9 px-2 py-0 m-0">
														<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= thisSchmeckleTotal %>" id="inputOverUnderBetAmount" name="inputOverUnderBetAmount" onkeyup="calculate_ou_payout(this.value)" required>
													</div>
													<div class="col-3 px-2 py-0 m-0">
														<button id="totalButton" <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">Bet</button>
													</div>
												</div>

											</div>
										</form>

									</div>
									<div class="card-footer py-2">
										<div class="row py-0">
											<div class="col-6 py-0">
												<label class="col-form-label"><small><b>TO WIN:</b>  <span id="winOverUnder"></span></small></label>
											</div>
											<div class="col-6 py-0">
												<label class="col-form-label"><small><b>PAYOUT:</b>  <span id="payoutOverUnder"></span></small></label>
											</div>
										</div>
									</div>

								</div>

							</div>

						</div>
<%
						sqlGetProps = "SELECT PropQuestions.PropQuestionID, PropQuestions.PropCorrectAnswerID, PropQuestions.MatchupID, PropQuestions.Question FROM PropQuestions WHERE PropQuestions.PropCorrectAnswerID IS NULL AND "
						If Session.Contents("SITE_Bet_Type") = "nfl" Then sqlGetProps = sqlGetProps & " NFLGameID = " & thisNFLGameID
						If Session.Contents("SITE_Bet_Type") <> "nfl" Then sqlGetProps = sqlGetProps & " MatchupID = " & thisMatchupID
						Set rsProps = sqlDatabase.Execute(sqlGetProps)

						Do While Not rsProps.Eof

							thisPropQuestionID = rsProps("PropQuestionID")
							thisPropQuestion = rsProps("Question")
%>


								<div class="card">

									<div class="card-body pb-0 pt-0">

										<form id="betProp<%= thisPropQuestionID %>" action="/sportsbook/submit-bet/">

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

												<button id="propButton<%= thisPropQuestionID %>" <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success">Place Bet</button>

											</div>

										</form>

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
					If CInt(thisMatchupLevelID) < 5 And Len(thisNFLGameID) = 0 Then
%>
						<div class="col-6 col-xl-4 pl-0 pl-lg-2 pr-0">

							<ul class="list-group" id="team-1-roster" style="margin-bottom: 1rem;">
<%
								Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
								oXML.loadXML(GetScores(thisTeamLevelTitle1, Session.Contents("CurrentPeriod")))

								oXML.setProperty "SelectionLanguage", "XPath"
								Set objTeam = oXML.selectSingleNode(".//team[@id = " & thisTeamCBSID1 & "]")

								TeamLevelTitle1 = LevelTitle
								Set objTeamPlayers1 = objTeam.getElementsByTagName("player")
%>
								<li class="list-group-item team-1-box m-0 p-0 bg-dark" style="color: #fff;border-radius: 0; border-top-left-radius: 5px;">
									<div class="row p-0 py-2 m-0">
										<div class="col-6 col-lg-2 p-0 pt-1">
											<span><img src="https://samelevel.imgix.net/<%= thisProfileImage1 %>?w=40&h=40&fit=crop&crop=focalpoint" width="40" alt="<%= thisTeamName1 %>" class="rounded-circle ml-3 ml-lg-2" /></span>
										</div>
										<div class="col-7 text-center d-none d-lg-block pt-1">
											<div class="py-2 px-2 bg-primary rounded" style="margin-top: 2px;"><b><%= thisTeamName1 %></b><% If thisTeamOmegaTravel1 <> 0 Then %> (<%= thisTeamOmegaTravel1 %>)<% End If %></div>
										</div>
										<div class="col-6 col-lg-3 pr-1 pt-2 text-right">
											<% If thisTeamLevelID1 = 1 Then %>
												<div><span class="badge team-1-score pt-0 text-right" style="font-size: 20px; color: #fff;"><%= FormatNumber(thisTeamScore1 + thisTeamOmegaTravel1, 2) %></span></div>
											<% Else %>
												<div><span class="badge team-1-score pt-0 text-right" style="font-size: 20px; color: #fff;"><%= FormatNumber(thisTeamScore1, 2) %></span></div>
											<% End If %>
											<div><span class="badge team-1-progress pt-0 text-right" style="font-size: 10px; color: #fff;"><%= thisTeamPMR1 %> PMR</span></div>
										</div>
									</div>
								</li>

								<li class="list-group-item d-block d-lg-none py-1 px-3 px-md-2 bg-light">

									<h6><b><%= thisTeamName1 %></b></h6>

								</li>
<%
								HitReserves = 0
								'For i = 0 to (objTeamPlayers1.length - 1)'
								For i = 0 to (12)

									Set objPlayer = objTeamPlayers1.item(i)

									thisPlayerID = objPlayer.getAttribute("id")

									Set objPlayerStatus = objPlayer.getElementsByTagName("status")
									If objPlayerStatus.Length > 0 Then thisPlayerStatus = objPlayerStatus.item(0).text

									If (thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured") And HitReserves = 0 Then StartReserves = 1
									If thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured" Then HitReserves = 1

									If StartReserves = 1 Then Response.Write("<li class=""list-group-item py-1 px-3 bg-light""><h6> </h6></li>")
%>
									<li class="list-group-item team-1-player-<%= thisPlayerID %> pr-3 pt-3 pl-4 pl-md-3">

										<div class="row">

											<div class="col-1 col-lg-2 d-none d-lg-block m-0 p-0">
												<div class="progress-bar-photo can-load is-loading mb-0 team-1-player-<%= thisPlayerID %>-photo-loading"></div>
												<img src="#" class="rounded-circle mt-o p-0 team-1-player-<%= thisPlayerID %>-photo d-none" width="40" alt="<%= thisPlayerName %>" />
											</div>

											<div class="col-12 col-lg-10 p-0 pb-0 m-0 text-left">
												<span class="team-1-player-<%= thisPlayerID %>-points player-points float-right font-weight-bold badge badge-dark">0.00</span>
												<div class="team-1-player-<%= thisPlayerID %>-name player-name"><div class="mt-1 mb-2 progress-bar-name can-load is-loading"></div></div>
												<span class="team-1-player-<%= thisPlayerID %>-gametime player-points float-right font-weight-bold badge badge-info d-none">0.00</span>
												<div class="team-1-player-<%= thisPlayerID %>-gameline"><div class="mt-1 progress-bar-gameline can-load is-loading"></div></div>
												<div class="team-1-player-<%= thisPlayerID %>-stats d-none"></div>
											</div>

										</div>

									</li>
<%
									If StartReserves = 1 Then StartReserves = 0

								Next
%>

							</ul>

						</div>

						<div class="col-6 col-xl-4 pl-0 pr-0 pr-lg-2">

							<ul class="list-group" id="team-2-roster" style="margin-bottom: 1rem;">
<%
								Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
								oXML.loadXML(GetScores(thisTeamLevelTitle2, Session.Contents("CurrentPeriod")))

								oXML.setProperty "SelectionLanguage", "XPath"
								Set objTeam = oXML.selectSingleNode(".//team[@id = " & thisTeamCBSID2 & "]")

								Set objTeamName2 = objTeam.getElementsByTagName("name")
								Set objTeamScore2 = objTeam.getElementsByTagName("pts")
								Set objTeamPMR2 = objTeam.getElementsByTagName("pmr")
								Set objTeamPlayers2 = objTeam.getElementsByTagName("player")

								TeamLevelTitle2 = LevelTitle
								TeamName2 = objTeamName2.item(0).text
								TeamScore2 = FormatNumber(CDbl(objTeamScore2.item(0).text), 2)
								TeamPMR2 = CInt(objTeamPMR2.item(0).text)
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
											<span><img src="https://samelevel.imgix.net/<%= thisProfileImage2 %>?w=40&h=40&fit=crop&crop=focalpoint" width="40" alt="<%= TeamName2 %>" class="rounded-circle mr-3 mr-lg-2" /></span>
										</div>
									</div>
								</li>

								<li class="list-group-item d-block d-lg-none py-1 px-2 pr-3 bg-light text-right">

									<h6><b><%= TeamName2 %></b></h6>

								</li>
<%
								HitReserves = 0
								'For i = 0 to (objTeamPlayers2.length - 2)
								For i = 0 to (12)

									Set objPlayer = objTeamPlayers2.item(i)

									thisPlayerID = objPlayer.getAttribute("id")

									Set objPlayerStatus = objPlayer.getElementsByTagName("status")
									If objPlayerStatus.Length > 0 Then thisPlayerStatus = objPlayerStatus.item(0).text

									If (thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured") And HitReserves = 0 Then StartReserves = 1
									If thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured" Then HitReserves = 1

									If StartReserves = 1 Then Response.Write("<li class=""list-group-item py-1 px-3 bg-light text-right""><h6> </h6></li>")
%>
									<li class="list-group-item team-2-player-<%= thisPlayerID %> pl-3 pt-3 pr-4 pr-md-3">

										<div class="row">

											<div class="col-12 col-lg-10 p-0 pb-0 m-0 text-right">
												<span class="team-2-player-<%= thisPlayerID %>-points player-points float-left font-weight-bold badge badge-dark">0.00</span>
												<div  class="team-2-player-<%= thisPlayerID %>-name player-name"><div class="mt-1 mb-2 progress-bar-name can-load is-loading float-right"></div></div><div class="clearfix"></div>
												<span class="team-2-player-<%= thisPlayerID %>-gametime player-points float-left font-weight-bold badge badge-info d-none">0.00</span>
												<div  class="team-2-player-<%= thisPlayerID %>-gameline"><div class="mt-1 progress-bar-gameline can-load is-loading float-right"></div></div>
												<div  class="team-2-player-<%= thisPlayerID %>-stats d-none"></div><div class="clearfix"></div>
											</div>

											<div class="col-1 col-lg-2 d-none d-lg-block m-0 p-0 text-right">
												<div class="progress-bar-photo can-load is-loading mb-0 team-2-player-<%= thisPlayerID %>-photo-loading float-right"></div>
												<img src="#" class="rounded-circle mt-o p-0 team-2-player-<%= thisPlayerID %>-photo d-none" width="40" alt="<%= thisPlayerName %>" />
											</div>

										</div>

									</li>
<%
									If StartReserves = 1 Then StartReserves = 0

								Next
%>
							</ul>

						</div>

					</div>
<%
					End If

					ticketsAccountID = ""
					ticketsTypeID = ""
					ticketsNFLGameID = ""
					ticketsMatchupID = ""
					ticketsProcessed = ""

					If Len(thisNFLGameID) > 0 Then ticketsNFLGameID = thisNFLGameID
					If Len(thisMatchupID) > 0 Then ticketsMatchupID = thisMatchupID
					Response.Write("<div class=""col-12 col-xl-8 pb-4"">")
						Call TicketRow (ticketsNFLGameID, ticketsMatchupID, ticketsAccountID, ticketsTypeID, ticketsProcessed, 0)
					Response.Write("</div>")
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

			$("#betMoneyline").submit(function(e) {

				e.preventDefault();
				e.stopImmediatePropagation();
				var form = $(this);
				$(this).find(':submit').attr('disabled','disabled');
				$("#betMoneyline").attr("disabled", true);
				var moneylineButton = document.getElementById('moneylineButton');
				moneylineButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';

				$.ajax({type: "POST", url: form.attr('action'), data: form.serialize(), success: function(data) {
					window.location.reload();
				}});

			});

			$("#betSpread").submit(function(e) {

				e.preventDefault();
				e.stopImmediatePropagation();
				var form = $(this);
				$(this).find(':submit').attr('disabled','disabled');
				$("#betSpread").attr("disabled", true);
				var spreadButton = document.getElementById('spreadButton');
				spreadButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';

				$.ajax({type: "POST", url: form.attr('action'), data: form.serialize(), success: function(data) {
					window.location.reload();
				}});

			});

			$("#betTotal").submit(function(e) {

				e.preventDefault();
				e.stopImmediatePropagation();
				var form = $(this);
				$(this).find(':submit').attr('disabled','disabled');
				$("#betTotal").attr("disabled", true);
				var totalButton = document.getElementById('totalButton');
				totalButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';

				$.ajax({type: "POST", url: form.attr('action'), data: form.serialize(), success: function(data) {
					window.location.reload();
				}});

			});
<%
			sqlGetProps = "SELECT PropQuestions.PropQuestionID, PropQuestions.PropCorrectAnswerID, PropQuestions.MatchupID, PropQuestions.Question FROM PropQuestions WHERE PropQuestions.PropCorrectAnswerID IS NULL AND "
			If Session.Contents("SITE_Bet_Type") = "nfl" Then sqlGetProps = sqlGetProps & " NFLGameID = " & thisNFLGameID
			If Session.Contents("SITE_Bet_Type") <> "nfl" Then sqlGetProps = sqlGetProps & " MatchupID = " & thisMatchupID
			Set rsProps = sqlDatabase.Execute(sqlGetProps)

			Do While Not rsProps.Eof

				thisPropQuestionID = rsProps("PropQuestionID")
%>
				$("#betProp<%= thisPropQuestionID %>").submit(function(e) {

					e.preventDefault();
					e.stopImmediatePropagation();
					var form = $(this);
					$(this).find(':submit').attr('disabled','disabled');
					$("#betProp<%= thisPropQuestionID %>").attr("disabled", true);

					var totalButton = document.getElementById('propButton<%= thisPropQuestionID %>');
					totalButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';

					$.ajax({type: "POST", url: form.attr('action'), data: form.serialize(), success: function(data) {
						window.location.reload();
					}});

				});
<%
				rsProps.MoveNext

			Loop

			rsProps.Close
			Set rsProps = Nothing
%>

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
			countdownTimer.setSeconds( countdownTimer.getSeconds() + 180 );

			var x = setInterval(function() {

				var now = new Date().getTime();

				var distance = countdownTimer - now;

				var seconds = Math.floor((distance % (1000 * 600)) / 1000);

				document.getElementById("countdownTimer").innerHTML = seconds;

				if (distance <= 0) {
					clearInterval(x);
					window.location.href = "<%= thisMatchupURL %>";
				}

			}, 1000);

		</script>

		<script src="/assets/plugins/countUp/countUp.min.js" type="text/javascript"></script>
		<script src="/assets/plugins/howler/howler.min.js" type="text/javascript"></script>

		<!--#include virtual="/assets/js/matchup.asp"-->

	</body>

</html>
