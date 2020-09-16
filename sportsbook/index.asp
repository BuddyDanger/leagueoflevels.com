<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Sportsbook / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/sportsbook/" />
		<meta property="og:title" content="Sportsbook - The League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/sportsbook/" />
		<meta name="twitter:title" content="Sportsbook - The League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="Sportsbook - The League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/sportsbook/" />

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
										<li class="breadcrumb-item"><a href="javascript:void(0);">Main</a></li>
										<li class="breadcrumb-item active">Sportsbook</li>
									</ol>

								</div>

								<h4 class="page-title">Sportsbook / Active Matchups</h4>

							</div>

							<div class="page-content">

								<div class="row">
									<div class="col-12">

										<div class="row">
<%
											sqlGetSportsbookData = "SELECT SUM(BetAmount) AS TotalActiveBetAmount, SUM(PayoutAmount) AS TotalPotentialPayout, COUNT(TicketSlipID) AS TotalActiveTickets, COUNT(DISTINCT AccountID) AS TotalBettingUsers FROM TicketSlips WHERE IsWinner IS NULL"
											Set rsSportsbookData = sqlDatabase.Execute(sqlGetSportsbookData)

											If Not rsSportsbookData.Eof Then

												thisTotalActiveBetAmount = rsSportsbookData("TotalActiveBetAmount")
												thisTotalPotentialPayout = rsSportsbookData("TotalPotentialPayout")
												thisTotalActiveTickets = rsSportsbookData("TotalActiveTickets")
												thisTotalBettingUsers = rsSportsbookData("TotalBettingUsers")

												If Not IsNumeric(thisTotalActiveBetAmount) Then thisTotalActiveBetAmount = 0
												If Not IsNumeric(thisTotalPotentialPayout) Then thisTotalPotentialPayout = 0
%>
												<div class="col-xxxl-4 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12 col-xxs-12">
													<a href="/sportsbook/tickets/" style="text-decoration: none; display: block;">
														<ul class="list-group" style="margin-bottom: 1rem;">
															<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #4d79f6; color: #fff;"><strong>ACTIVE STATS</strong></li>
															<li class="list-group-item">
																<span style="font-size: 1em; background-color: #fff; color: #03324F; float: right;"><%= FormatNumber(thisTotalActiveBetAmount, 0) %></span>
																<div style="font-size: 13px; color: #03324F;"><b>TOTAL SCHMECKLES BET</b></div>
																<div style="font-size: 13px; color: #03324F;">Across <%= thisTotalActiveTickets %> Individual Active Ticket Slips</div>
															</li>
															<li class="list-group-item">
																<span style="font-size: 1em; background-color: #fff; color: #03324F; float: right;"><%= FormatNumber(thisTotalPotentialPayout, 0) %></span>
																<div style="font-size: 13px; color: #03324F;"><b>TOTAL POTENTIAL PAYOUT</b></div>
																<div style="font-size: 13px; color: #03324F;">Across <%= thisTotalBettingUsers %> LOL Owner Accounts</div>
															</li>
														</ul>
													</a>
												</div>
<%
												rsSportsbookData.Close
												Set rsSportsbookData = Nothing

											End If

											sqlGetSchedules = "SELECT MatchupID, Matchups.LevelID, Year, Period, IsPlayoffs, TeamID1, TeamID2, Team1.TeamName AS TeamName1, Team2.TeamName AS TeamName2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2, Leg, TeamProjected1, TeamProjected2, TeamWinPercentage1, TeamWinPercentage2, TeamMoneyline1, TeamMoneyline2, TeamSpread1, TeamSpread2 FROM Matchups "
											sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team1 ON Team1.TeamID = Matchups.TeamID1 "
											sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team2 ON Team2.TeamID = Matchups.TeamID2 "
											sqlGetSchedules = sqlGetSchedules & "WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND (TeamPMR1 > 0 OR TeamPMR2 > 0) AND (TeamWinPercentage1 >= 0.20 AND TeamWinPercentage1 <= 0.80)  AND (TeamWinPercentage2 >= 0.20 AND TeamWinPercentage2 <= 0.80) "
											sqlGetSchedules = sqlGetSchedules & "ORDER BY CASE WHEN Matchups.LevelID = 1 THEN '1' WHEN Matchups.LevelID = 0 THEN '2' WHEN Matchups.LevelID = 2 THEN '3' WHEN Matchups.LevelID = 3 THEN '4' ELSE Matchups.LevelID END ASC, Matchups.MatchupID DESC"
											Set rsSchedules = sqlDatabase.Execute(sqlGetSchedules)

											Do While Not rsSchedules.Eof

												thisMatchupID = rsSchedules("MatchupID")
												thisLevelID = rsSchedules("LevelID")
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
												<div class="col-xxxl-4 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12 col-xxs-12">
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
<%
												rsSchedules.MoveNext

											Loop

											rsSchedules.Close
											Set rsSchedules = Nothing
%>
										</div>
									</div>
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

	</body>

</html>
