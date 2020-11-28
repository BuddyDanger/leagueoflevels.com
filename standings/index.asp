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

		<title>Standings / League of Levels</title>

		<meta name="description" content="Updated standings across the League of Levels. These standings should accurately represent each individual league account. Next Level Cup matchups are not included in these aggregate numbers for wins, losses, or points." />

		<meta property="og:site_name" content="League of Levels" />
		<meta property="og:url" content="https://www.leagueoflevels.com/standings/" />
		<meta property="og:title" content="Standings / League of Levels" />
		<meta property="og:description" content="Updated standings across the League of Levels. These standings should accurately represent each individual league account. Next Level Cup matchups are not included in these aggregate numbers for wins, losses, or points." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/standings/" />
		<meta name="twitter:title" content="Standings / League of Levels" />
		<meta name="twitter:description" content="Updated standings across the League of Levels. These standings should accurately represent each individual league account. Next Level Cup matchups are not included in these aggregate numbers for wins, losses, or points." />

		<meta name="title" content="Standings / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/standings/standings/" />

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
										<li class="breadcrumb-item active">Standings</li>
									</ol>

								</div>

								<h4 class="page-title">Overall Standings</h4>

							</div>

							<div class="page-content">

								<div class="row">
									<div class="col-12">

<%
										sqlGetSLFFL = "SELECT Levels.Title, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD, (SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings INNER JOIN Teams ON Teams.TeamID = Standings.TeamID INNER JOIN Levels ON Levels.LevelID = Standings.LevelID WHERE Levels.LevelID = 2 GROUP BY Levels.LevelID, Levels.Title, Teams.TeamName, Standings.TeamID ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

										sqlGetFLFFL = "SELECT Levels.Title, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD, (SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings INNER JOIN Teams ON Teams.TeamID = Standings.TeamID INNER JOIN Levels ON Levels.LevelID = Standings.LevelID WHERE Levels.LevelID = 3 GROUP BY Levels.LevelID, Levels.Title, Teams.TeamName, Standings.TeamID ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

										sqlGetOmega = "SELECT Levels.Title, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD, (SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings INNER JOIN Teams ON Teams.TeamID = Standings.TeamID INNER JOIN Levels ON Levels.LevelID = Standings.LevelID WHERE Levels.LevelID = 1 GROUP BY Levels.LevelID, Levels.Title, Teams.TeamName, Standings.TeamID ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

										sqlGetPoints = "SELECT Teams.TeamName, SUM([PointsScored]) AS PointsScored, (SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings INNER JOIN Teams ON Teams.TeamID = Standings.TeamID INNER JOIN Levels ON Levels.LevelID = Standings.LevelID WHERE Levels.LevelID > 1 AND Teams.EndYear = 0 GROUP BY Standings.TeamID, Teams.TeamName ORDER BY PointsScored DESC; "

										Set rsStandings = sqlDatabase.Execute(sqlGetSLFFL & sqlGetFLFFL & sqlGetOmega & sqlGetPoints)

										Response.Write("<div Class=""row"">")

											Response.Write("<div Class=""col-12 col-md-12 col-lg-12 col-xl-6"">")
												Response.Write("<h5 class=""card-subtitle mb-2 text-muted"">SAME LEVEL</h5>")
												Response.Write("<div class=""card"">")

													Response.Write("<div class=""card-body"">")
%>
														<table class="table table-bordered mb-1">
															<thead>
																<tr>
																	<th>TEAM</th>
																	<th class="text-center">W-L-T</th>
																	<th class="text-center d-none d-lg-table-cell">PF</th>
																	<th class="text-center d-none d-lg-table-cell">PA</th>
																	<th class="text-center d-none d-lg-table-cell">BKDN</th>
																</tr>
															</thead>
															<tbody>
<%
																thisPosition = 1
																Do While Not rsStandings.Eof

																	thisTeamName = rsStandings("TeamName")
																	thisWinTotal = rsStandings("WinTotal")
																	thisLossTotal = rsStandings("LossTotal")
																	thisTieTotal = rsStandings("TieTotal")
																	thisPointsScored = rsStandings("PointsScored")
																	thisPointsAgainst = rsStandings("PointsAgainst")
																	thisBreakdownWins = rsStandings("BreakdownWins")
																	thisBreakdownLosses = rsStandings("BreakdownLosses")
																	thisBreakdownTies = rsStandings("BreakdownTies")
																	thisAveragePositionYTD = rsStandings("AveragePositionYTD")

																	thisProfileImage = rsStandings("ProfileImage")
																	If IsNull(thisProfileImage) Then thisProfileImage = "user.jpg"

																	thisBorderBottom = ""
																	If thisPosition = 5 Then thisBorderBottom = "border-bottom: 5px solid #eaf0f7;"
%>
																	<tr style="<%= thisBorderBottom %>">
																		<td><img src="https://samelevel.imgix.net/<%= thisProfileImage %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline mr-1 pr-1"><b><%= thisPosition %>.</b> &nbsp;<%= thisTeamName %></td>
																		<td class="text-center"><%= thisWinTotal %>-<%= thisLossTotal %>-<%= thisTieTotal %></td>
																		<td class="text-center d-none d-lg-table-cell"><%= FormatNumber(thisPointsScored, 2) %></td>
																		<td class="text-center d-none d-lg-table-cell"><%= FormatNumber(thisPointsAgainst, 2) %></td>
																		<td class="text-center d-none d-lg-table-cell"><%= thisBreakdownWins %>-<%= thisBreakdownLosses %>-<%= thisBreakdownTies %></td>
																	</tr>
<%
																	thisPosition = thisPosition + 1
																	rsStandings.MoveNext

																Loop
%>
															</tbody>
														</table>
<%
													Response.Write("</div>")

												Response.Write("</div>")

											Response.Write("</div>")

											Set rsStandings = rsStandings.NextRecordset

											Response.Write("<div Class=""col-12 col-md-12 col-lg-12 col-xl-6"">")

												Response.Write("<h5 class=""card-subtitle mb-2 text-muted"">FARM LEVEL</h5>")
												Response.Write("<div class=""card"">")

													Response.Write("<div class=""card-body"">")
%>
														<table class="table table-bordered mb-1">
															<thead>
																<tr>
																	<th>TEAM</th>
																	<th class="text-center">W-L-T</th>
																	<th class="text-center d-none d-lg-table-cell">PF</th>
																	<th class="text-center d-none d-lg-table-cell">PA</th>
																	<th class="text-center d-none d-lg-table-cell">BKDN</th>
																</tr>
															</thead>
															<tbody>
<%
																thisPosition = 1
																Do While Not rsStandings.Eof

																	thisTeamName = rsStandings("TeamName")
																	thisWinTotal = rsStandings("WinTotal")
																	thisLossTotal = rsStandings("LossTotal")
																	thisTieTotal = rsStandings("TieTotal")
																	thisPointsScored = rsStandings("PointsScored")
																	thisPointsAgainst = rsStandings("PointsAgainst")
																	thisBreakdownWins = rsStandings("BreakdownWins")
																	thisBreakdownLosses = rsStandings("BreakdownLosses")
																	thisBreakdownTies = rsStandings("BreakdownTies")
																	thisAveragePositionYTD = rsStandings("AveragePositionYTD")

																	thisProfileImage = rsStandings("ProfileImage")
																	If IsNull(thisProfileImage) Then thisProfileImage = "user.jpg"

																	thisBorderBottom = ""
																	If thisPosition = 5 Then thisBorderBottom = "border-bottom: 5px solid #eaf0f7;"
%>
																	<tr style="<%= thisBorderBottom %>">
																		<td><img src="https://samelevel.imgix.net/<%= thisProfileImage %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline mr-1 pr-1"><b><%= thisPosition %>.</b> &nbsp;<%= thisTeamName %></td>
																		<td class="text-center"><%= thisWinTotal %>-<%= thisLossTotal %>-<%= thisTieTotal %></td>
																		<td class="text-center d-none d-lg-table-cell"><%= FormatNumber(thisPointsScored, 2) %></td>
																		<td class="text-center d-none d-lg-table-cell"><%= FormatNumber(thisPointsAgainst, 2) %></td>
																		<td class="text-center d-none d-lg-table-cell"><%= thisBreakdownWins %>-<%= thisBreakdownLosses %>-<%= thisBreakdownTies %></td>
																	</tr>
<%
																	thisPosition = thisPosition + 1
																	rsStandings.MoveNext

																Loop
%>
															</tbody>
														</table>
<%
													Response.Write("</div>")

												Response.Write("</div>")

											Response.Write("</div>")

											Set rsStandings = rsStandings.NextRecordset

											Response.Write("<div Class=""col-12 col-md-12 col-lg-12 col-xl-6"">")

												Response.Write("<h5 class=""card-subtitle mb-2 text-muted"">OMEGA LEVEL</h5>")
												Response.Write("<div class=""card"">")

													Response.Write("<div class=""card-body"">")
%>
														<table class="table table-bordered mb-1">
															<thead>
																<tr>
																	<th>TEAM</th>
																	<th class="text-center">W-L-T</th>
																	<th class="text-center d-none d-lg-table-cell">PF</th>
																	<th class="text-center d-none d-lg-table-cell">PA</th>
																	<th class="text-center d-none d-lg-table-cell">BKDN</th>
																</tr>
															</thead>
															<tbody>
<%
																thisPosition = 1
																Do While Not rsStandings.Eof

																	thisTeamName = rsStandings("TeamName")
																	thisWinTotal = rsStandings("WinTotal")
																	thisLossTotal = rsStandings("LossTotal")
																	thisTieTotal = rsStandings("TieTotal")
																	thisPointsScored = rsStandings("PointsScored")
																	thisPointsAgainst = rsStandings("PointsAgainst")
																	thisBreakdownWins = rsStandings("BreakdownWins")
																	thisBreakdownLosses = rsStandings("BreakdownLosses")
																	thisBreakdownTies = rsStandings("BreakdownTies")
																	thisAveragePositionYTD = rsStandings("AveragePositionYTD")

																	thisProfileImage = rsStandings("ProfileImage")
																	If IsNull(thisProfileImage) Then thisProfileImage = "user.jpg"

																	thisBorderBottom = ""
																	If thisPosition = 4 Then thisBorderBottom = "border-bottom: 5px solid #eaf0f7;"
%>
																	<tr style="<%= thisBorderBottom %>">
																		<td><img src="https://samelevel.imgix.net/<%= thisProfileImage %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline mr-1 pr-1"><b><%= thisPosition %>.</b> &nbsp;<%= thisTeamName %></td>
																		<td class="text-center"><%= thisWinTotal %>-<%= thisLossTotal %>-<%= thisTieTotal %></td>
																		<td class="text-center d-none d-lg-table-cell"><%= FormatNumber(thisPointsScored, 2) %></td>
																		<td class="text-center d-none d-lg-table-cell"><%= FormatNumber(thisPointsAgainst, 2) %></td>
																		<td class="text-center d-none d-lg-table-cell"><%= thisBreakdownWins %>-<%= thisBreakdownLosses %>-<%= thisBreakdownTies %></td>
																	</tr>
<%
																	thisPosition = thisPosition + 1
																	rsStandings.MoveNext

																Loop
%>
															</tbody>
														</table>
<%
													Response.Write("</div>")

												Response.Write("</div>")

											Response.Write("</div>")

											Set rsStandings = rsStandings.NextRecordset

											Response.Write("<div Class=""col-12 col-md-12 col-lg-12 col-xl-6"">")

												Response.Write("<h5 class=""card-subtitle mb-2 text-muted"">TOTAL POINTS</h5>")
												Response.Write("<div class=""card"">")

													Response.Write("<div class=""card-body"">")
%>
														<table class="table table-bordered mb-1">
															<thead>
																<tr>
																	<th>TEAM</th>
																	<th class="text-center">PF</th>
																</tr>
															</thead>
															<tbody>
<%
																thisPosition = 1
																Do While Not rsStandings.Eof

																	thisTeamName = rsStandings("TeamName")
																	thisPointsScored = rsStandings("PointsScored")

																	thisProfileImage = rsStandings("ProfileImage")
																	If IsNull(thisProfileImage) Then thisProfileImage = "user.jpg"
%>
																	<tr>
																		<td><img src="https://samelevel.imgix.net/<%= thisProfileImage %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline mr-1 pr-1"><b><%= thisPosition %>.</b> &nbsp;<%= thisTeamName %></td>
																		<td class="text-center"><%= FormatNumber(thisPointsScored, 2) %></td>
																	</tr>
<%
																	thisPosition = thisPosition + 1
																	rsStandings.MoveNext

																Loop
%>
															</tbody>
														</table>
<%
													Response.Write("</div>")

												Response.Write("</div>")

											Response.Write("</div>")

										Response.Write("</div>")

%>
										</tbody>
									</table>

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
