<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp" -->
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Chronicle / League of Levels</title>

		<meta name="description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="Teams / League of Levels" />
		<meta property="og:description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="Teams / League of Levels" />
		<meta name="twitter:description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />

		<meta name="title" content="Teams / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/teams/" />

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

						<div class="col-12 col-xl-5">

							<div class="card">

								<div class="card-body p-0">

									<table class="table mb-1 ROUNDED">
										<thead>
											<tr>
												<th class="pl-3"><b>BROWSE LEVELS</b></th>
												<th class="text-right d-none d-sm-table-cell" style="width: 15%">GAMES</th>
												<th class="text-right d-none d-sm-table-cell" style="width: 15%">POINTS</th>
												<th class="text-right d-sm-table-cell" style="width: 15%">ORIGIN</th>
											</tr>
										</thead>
										<tbody>
<%
											sqlGetLevels = "SELECT AGG.LevelID, AGG.Rank, AGG.Title, AGG.Abbreviation, AGG.StartYear, SUM(AGG.TotalPoints) AS TotalPoints, SUM(AGG.TotalMatchups) AS TotalMatchups, SUM(AGG.TotalTeams) AS TotalTeams, AGG.Logo FROM ( "
											sqlGetLevels = sqlGetLevels & "SELECT Levels.LevelID, Levels.Rank, Levels.Title, Levels.Abbreviation, Levels.Logo, Levels.StartYear, ROUND(SUM([TeamScore1]) + SUM([TeamScore2]), 2) AS TotalPoints, COUNT(MatchupID) AS TotalMatchups, null AS TotalTeams "
											sqlGetLevels = sqlGetLevels & "FROM Matchups "
											sqlGetLevels = sqlGetLevels & "INNER JOIN Levels ON Levels.LevelID = Matchups.LevelID "
											sqlGetLevels = sqlGetLevels & "WHERE Levels.LevelID > 0 "
											sqlGetLevels = sqlGetLevels & "GROUP BY Levels.LevelID, Levels.Rank, Levels.Title, Levels.Abbreviation, Levels.Logo, Levels.StartYear "
											sqlGetLevels = sqlGetLevels & "UNION ALL "
											sqlGetLevels = sqlGetLevels & "SELECT Levels.LevelID, Levels.Rank, Levels.Title, Levels.Abbreviation, Levels.Logo, Levels.StartYear, NULL, NULL, COUNT(DISTINCT([TeamID])) AS TotalTeams "
											sqlGetLevels = sqlGetLevels & "FROM LinkTeamsLevels "
											sqlGetLevels = sqlGetLevels & "INNER JOIN Levels ON Levels.LevelID = LinkTeamsLevels.LevelID "
											sqlGetLevels = sqlGetLevels & "GROUP BY Levels.LevelID, Levels.Rank, Levels.Title, Levels.Abbreviation, Levels.Logo, Levels.StartYear "
											sqlGetLevels = sqlGetLevels & ") AGG "
											sqlGetLevels = sqlGetLevels & "GROUP BY AGG.LevelID, AGG.Rank, AGG.Title, AGG.Abbreviation, AGG.Logo, AGG.StartYear "
											Set rsLevels = sqlDatabase.Execute(sqlGetLevels)

											Do While Not rsLevels.Eof

												thisLevelID = rsLevels("LevelID")
												thisLevelLogo = "<img src=""https://samelevel.imgix.net/" & rsLevels("Logo") & "?w=40&h=40"" class=""d-inline mr-2"">"
%>
												<tr>

													<td class="pl-3">
														<a href="/chronicle/<%= LCase(rsLevels("Abbreviation")) %>/">
															<%= thisLevelLogo %>
															<b><%= UCase(rsLevels("Title")) %></b>
														</a>
													</td>
													<td class="text-right d-none d-sm-table-cell"><%= FormatNumber(rsLevels("TotalMatchups"), 0) %></td>
													<td class="text-right d-none d-sm-table-cell"><%= FormatNumber(rsLevels("TotalPoints"), 0) %></td>
													<td class="text-right d-sm-table-cell"><%= rsLevels("StartYear") %></td>

												</tr>
<%
												rsLevels.MoveNext

											Loop

											rsLevels.Close
											Set rsLevels = Nothing
%>
										</tbody>
									</table>

								</div>

							</div>

							<div class="card">

								<div class="card-body p-0">

									<table class="table mb-1 rounded">
										<thead>
											<tr>
												<th class="pl-3"><b>TOP SCORES</b></th>
												<th class="text-right d-none d-sm-table-cell" style="width: 15%">YEAR</th>
												<th class="text-right d-none d-sm-table-cell" style="width: 15%">PERIOD</th>
												<th class="text-right d-sm-table-cell" style="width: 15%">SCORE</th>
											</tr>
										</thead>
										<tbody>
<%
											sqlGetTopScores = "SELECT TOP 3 Abbreviation, Logo, Year, Period, ProfileName, ProfileImage, ProfileURL, PointsScored, WeeklyGames, PointsScored/WeeklyGames AS WeeklyScore FROM ( "
											sqlGetTopScores = sqlGetTopScores & "SELECT Levels.LevelID, Levels.Abbreviation, Levels.Logo, Year, Period, Accounts.ProfileName, Accounts.ProfileImage, Accounts.ProfileURL, ([PointsScored]),([ActualWins]+[ActualLosses]+[ActualTies]) AS WeeklyGames "
											sqlGetTopScores = sqlGetTopScores & "FROM Standings "
											sqlGetTopScores = sqlGetTopScores & "INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Standings.TeamID "
											sqlGetTopScores = sqlGetTopScores & "INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID "
											sqlGetTopScores = sqlGetTopScores & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
											sqlGetTopScores = sqlGetTopScores & "WHERE ([ActualWins]+[ActualLosses]+[ActualTies]) > 0 "
											sqlGetTopScores = sqlGetTopScores & ") A "
											sqlGetTopScores = sqlGetTopScores & "WHERE LevelID > 1 "
											sqlGetTopScores = sqlGetTopScores & "ORDER BY WeeklyScore DESC"
											Set rsTopScores = sqlDatabase.Execute(sqlGetTopScores)

											Do While Not rsTopScores.Eof

												thisLevelLogo = "<img src=""https://samelevel.imgix.net/" & rsTopScores("Logo") & "?w=40&h=40"" class=""d-inline mr-2"">"
												thisProfileLogo = "<img src=""https://samelevel.imgix.net/" & rsTopScores("ProfileImage") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle d-inline mr-2"">"
%>
												<tr>

													<td class="pl-3">
														<a href="/chronicle/<%= LCase(rsTopScores("ProfileURL")) %>/">
															<%= thisProfileLogo %>
															<b><%= rsTopScores("ProfileName") %></b>
														</a>
													</td>
													<td class="text-right d-none d-sm-table-cell"><%= rsTopScores("Year") %></td>
													<td class="text-right d-none d-sm-table-cell"><%= rsTopScores("Period") %></td>
													<td class="text-right d-sm-table-cell"><%= FormatNumber(rsTopScores("WeeklyScore"), 2) %></td>

												</tr>
<%
												rsTopScores.MoveNext

											Loop

											rsTopScores.Close
											Set rsTopScores = Nothing
%>
										</tbody>
									</table>

								</div>

							</div>

							<div class="card">

								<div class="card-body p-0">

									<table class="table mb-1 rounded">
										<thead>
											<tr>
												<th class="pl-3"><b>NEXT LEVEL CUP</b></th>
												<th class="text-right d-none d-sm-table-cell" style="width: 15%">WINS</th>
												<th class="text-right d-none d-sm-table-cell" style="width: 15%">LOSSES</th>
												<th class="text-right d-sm-table-cell" style="width: 15%">ROUNDS</th>
											</tr>
										</thead>
										<tbody>
<%
											sqlGetCupRecords = "SELECT TOP 3 * FROM CupRecords ORDER BY TotalWins DESC"
											Set rsCupRecords = sqlDatabase.Execute(sqlGetCupRecords)

											Do While Not rsCupRecords.Eof

												thisProfileLogo = "<img src=""https://samelevel.imgix.net/" & rsCupRecords("ProfileImage") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle d-inline mr-2"">"
%>
												<tr>

													<td class="pl-3">
														<a href="/chronicle/<%= LCase(rsCupRecords("ProfileURL")) %>/">
															<%= thisProfileLogo %>
															<b><%= rsCupRecords("ProfileName") %></b>
														</a>
													</td>
													<td class="text-right d-none d-sm-table-cell"><%= rsCupRecords("TotalWins") %></td>
													<td class="text-right d-none d-sm-table-cell"><%= rsCupRecords("TotalLosses") %></td>
													<td class="text-right d-none d-sm-table-cell"><%= rsCupRecords("TotalWins") + rsCupRecords("TotalLosses") %></td>
													<td class="text-right d-sm-none"><%= rsCupRecords("TotalWins") %>-<%= rsCupRecords("TotalLosses") %></td>

												</tr>
<%
												rsCupRecords.MoveNext

											Loop

											rsCupRecords.Close
											Set rsCupRecords = Nothing
%>
										</tbody>
									</table>

								</div>

							</div>

							<div class="card">

								<div class="card-body p-0">

									<table class="table mb-1 rounded">
										<thead>
											<tr>
												<th class="pl-3"><b>CLOSEST WINNERS</b></th>
												<th class="d-none d-table-cell" style="width: 35%"></th>
												<th class="d-none text-right d-table-cell" style="width: 15%">LEVEL</th>
												<th class="text-right d-table-cell" style="width: 15%">DIFF</th>
											</tr>
										</thead>
										<tbody>
<%
											sqlGetClosest = "SELECT TOP 3 * FROM MatchupDifferentials ORDER BY CAST(ABS(TeamScore1 - TeamScore2) AS DECIMAL(5, 2)) ASC, (TeamScore1 + TeamScore2) DESC"
											Set rsClosest = sqlDatabase.Execute(sqlGetClosest)

											Do While Not rsClosest.Eof

												thisTeamScore1 = rsClosest("TeamScore1")
												thisTeamScore2 = rsClosest("TeamScore2")
												thisTeamName1 = rsClosest("TeamName1")
												thisTeamName2 = rsClosest("TeamName2")
												thisTeamURL1 = rsClosest("TeamURL1")
												thisTeamURL2 = rsClosest("TeamURL2")
												thisProfileLogo1 = "<img src=""https://samelevel.imgix.net/" & rsClosest("TeamLogo1") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle d-inline mr-2 float-left"">"
												thisProfileLogo2 = "<img src=""https://samelevel.imgix.net/" & rsClosest("TeamLogo2") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle d-inline mr-2 float-left"">"

												thisLevelLogo = "<img src=""https://samelevel.imgix.net/" & rsClosest("Logo") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle d-inline mr-2"">"
												thisLevelAbbreviation = rsClosest("Abbreviation")
												thisYear = rsClosest("Year")
												thisPeriod = rsClosest("Period")
												thisDifferential = rsClosest("Differential")

												If thisTeamScore1 > thisTeamScore2 Then

													thisScoreWin = thisTeamScore1
													thisNameWin = thisTeamName1
													thisURLWin = thisTeamURL1
													thisLogoWin = thisProfileLogo1

													thisScoreLoss = thisTeamScore2
													thisNameLoss = thisTeamName2
													thisURLLoss = thisTeamURL2
													thisLogoLoss = thisProfileLogo2

												Else

													thisScoreWin = thisTeamScore2
													thisNameWin = thisTeamName2
													thisURLWin = thisTeamURL2
													thisLogoWin = thisProfileLogo2

													thisScoreLoss = thisTeamScore1
													thisNameLoss = thisTeamName1
													thisURLLoss = thisTeamURL1
													thisLogoLoss = thisProfileLogo1

												End If
%>
												<tr>

													<td class="pl-3">
														<a href="/chronicle/<%= LCase(rsClosest("TeamURL1")) %>/">
															<%= thisLogoWin %>
															<div><b><%= thisNameWin %></b></div>
															<div>(<%= thisScoreWin %>)</div>
														</a>
													</td>
													<td>
														<a href="/chronicle/<%= LCase(rsClosest("TeamURL2")) %>/">
															<%= thisLogoLoss %>
															<div><b><%= thisNameLoss %></b></div>
															<div>(<%= thisScoreLoss %>)</div>
														</a>
													</td>
													<td class="text-right d-sm-table-cell">
														<b><%= thisLevelAbbreviation %></b>
														<div><%= thisYear %> (<%= thisPeriod %>)</div>
													</td>
													<td class="text-right d-sm-table-cell"><%= thisDifferential %></td>

												</tr>
<%
												rsClosest.MoveNext

											Loop

											rsClosest.Close
											Set rsClosest = Nothing
%>
										</tbody>
									</table>

								</div>

							</div>

							<div class="card">

								<div class="card-body p-0">

									<table class="table mb-1 rounded">
										<thead>
											<tr>
												<th class="pl-3"><b>BIGGEST WINNERS</b></th>
												<th class="d-none d-table-cell" style="width: 35%"></th>
												<th class="d-none text-right d-table-cell" style="width: 15%">LEVEL</th>
												<th class="text-right d-table-cell" style="width: 15%">DIFF</th>
											</tr>
										</thead>
										<tbody>
<%
											sqlGetClosest = "SELECT TOP 3 * FROM MatchupDifferentials ORDER BY CAST(ABS(TeamScore1 - TeamScore2) AS DECIMAL(5, 2)) DESC, (TeamScore1 + TeamScore2) DESC"
											Set rsClosest = sqlDatabase.Execute(sqlGetClosest)

											Do While Not rsClosest.Eof

												thisTeamScore1 = rsClosest("TeamScore1")
												thisTeamScore2 = rsClosest("TeamScore2")
												thisTeamName1 = rsClosest("TeamName1")
												thisTeamName2 = rsClosest("TeamName2")
												thisTeamURL1 = rsClosest("TeamURL1")
												thisTeamURL2 = rsClosest("TeamURL2")
												thisProfileLogo1 = "<img src=""https://samelevel.imgix.net/" & rsClosest("TeamLogo1") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle d-inline mr-2 float-left"">"
												thisProfileLogo2 = "<img src=""https://samelevel.imgix.net/" & rsClosest("TeamLogo2") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle d-inline mr-2 float-left"">"

												thisLevelLogo = "<img src=""https://samelevel.imgix.net/" & rsClosest("Logo") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle d-inline mr-2"">"
												thisLevelAbbreviation = rsClosest("Abbreviation")
												thisYear = rsClosest("Year")
												thisPeriod = rsClosest("Period")
												thisDifferential = rsClosest("Differential")

												If thisTeamScore1 > thisTeamScore2 Then

													thisScoreWin = thisTeamScore1
													thisNameWin = thisTeamName1
													thisURLWin = thisTeamURL1
													thisLogoWin = thisProfileLogo1

													thisScoreLoss = thisTeamScore2
													thisNameLoss = thisTeamName2
													thisURLLoss = thisTeamURL2
													thisLogoLoss = thisProfileLogo2

												Else

													thisScoreWin = thisTeamScore2
													thisNameWin = thisTeamName2
													thisURLWin = thisTeamURL2
													thisLogoWin = thisProfileLogo2

													thisScoreLoss = thisTeamScore1
													thisNameLoss = thisTeamName1
													thisURLLoss = thisTeamURL1
													thisLogoLoss = thisProfileLogo1

												End If
%>
												<tr>

													<td class="pl-3">
														<a href="/chronicle/<%= LCase(rsClosest("TeamURL1")) %>/">
															<%= thisLogoWin %>
															<div><b><%= thisNameWin %></b></div>
															<div>(<%= thisScoreWin %>)</div>
														</a>
													</td>
													<td>
														<a href="/chronicle/<%= LCase(rsClosest("TeamURL2")) %>/">
															<%= thisLogoLoss %>
															<div><b><%= thisNameLoss %></b></div>
															<div>(<%= thisScoreLoss %>)</div>
														</a>
													</td>
													<td class="text-right d-sm-table-cell">
														<b><%= thisLevelAbbreviation %></b>
														<div><%= thisYear %> (<%= thisPeriod %>)</div>
													</td>
													<td class="text-right d-sm-table-cell"><%= thisDifferential %></td>

												</tr>
<%
												rsClosest.MoveNext

											Loop

											rsClosest.Close
											Set rsClosest = Nothing
%>
										</tbody>
									</table>

								</div>

							</div>

						</div>

						<div class="col-12 col-xl-7">

							<div class="card">

								<div class="card-body p-0">

									<table class="table mb-1">
										<thead>
											<tr>
												<th class="pl-3"><b>ACTIVE ACCOUNTS</b></th>
												<th class="text-right d-none d-sm-table-cell">POINTS SCORED</th>
												<th class="text-right d-none d-sm-table-cell">ACTUAL RECORD</th>
												<th class="text-right d-none d-sm-table-cell">ACTUAL WIN %</th>
											</tr>
										</thead>
										<tbody>
<%
											sqlGetAccounts = "SELECT * FROM Accounts_Active ORDER BY ProfileName; SELECT * FROM Accounts_Inactive ORDER BY ProfileName;"
											Set rsAccounts = sqlDatabase.Execute(sqlGetAccounts)

											Do While Not rsAccounts.Eof

												thisAccountID = rsAccounts("AccountID")
												thisProfileImage = "<img src=""https://samelevel.imgix.net/" & rsAccounts("ProfileImage") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle d-inline mr-2"">"
%>
												<tr>

													<td class="pl-3">
														<a href="/teams/<%= rsAccounts("ProfileURL") %>/">
														<%= thisProfileImage %>
														<b><%= rsAccounts("ProfileName") %></b>
														</a>
													</td>
													<td class="text-right d-none d-sm-table-cell"><%= FormatNumber(rsAccounts("PointsScored"), 2) %></td>
													<td class="text-right d-none d-sm-table-cell"><%= rsAccounts("ActualWins") %>-<%= rsAccounts("ActualLosses") %>-<%= rsAccounts("ActualTies") %></td>
													<td class="text-right d-none d-sm-table-cell"><%= FormatNumber(CDbl(rsAccounts("ActualWinPercentage"))*100, 2) %>%</td>

												</tr>

<%
												rsAccounts.MoveNext

											Loop

											Set rsAccounts = rsAccounts.NextRecordset()
%>
										</tbody>
									</table>

								</div>

							</div>

							<div class="card">

								<div class="card-body p-0">

									<table class="table mb-1">
										<thead>
											<tr>
												<th class="pl-3"><b>RETIRED TEAM NAME</b></th>
												<th class="text-right d-none d-sm-table-cell">POINTS SCORED</th>
												<th class="text-right d-none d-sm-table-cell">ACTUAL RECORD</th>
												<th class="text-right d-none d-sm-table-cell">ACTUAL WIN %</th>
											</tr>
										</thead>
										<tbody>
<%
											Do While Not rsAccounts.Eof

												thisAccountID = rsAccounts("AccountID")
												thisProfileImage = "<img src=""https://samelevel.imgix.net/" & rsAccounts("ProfileImage") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle float-left d-none d-xxl-block mr-2"">"
%>
												<tr style="<%= thisBorderBottom %>">

													<td class="pl-3">
														<div><b><%= rsAccounts("ProfileName") %></b></div>
													</td>
													<td class="text-right d-none d-sm-table-cell"><%= FormatNumber(rsAccounts("PointsScored"), 2) %></td>
													<td class="text-right d-none d-sm-table-cell"><%= rsAccounts("ActualWins") %>-<%= rsAccounts("ActualLosses") %>-<%= rsAccounts("ActualTies") %></td>
													<td class="text-right d-none d-sm-table-cell"><%= FormatNumber(CDbl(rsAccounts("ActualWinPercentage"))*100, 2) %>%</td>

												</tr>
<%
												rsAccounts.MoveNext

											Loop

											rsAccounts.Close
											Set rsAccounts = Nothing
%>
										</tbody>
									</table>

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
