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

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="Standings - The League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="Standings - The League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="Standings - The League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/standings/" />

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
										<li class="breadcrumb-item active">Schedule</li>
									</ol>

								</div>

								<h4 class="page-title">Standings</h4>

							</div>

							<div class="page-content">

								<div class="row">
									<div class="col-12">

<%
										sqlGetOmega = "SELECT Levels.Title, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD FROM Standings INNER JOIN Teams ON Teams.TeamID = Standings.TeamID INNER JOIN Levels ON Levels.LevelID = Standings.LevelID WHERE Levels.LevelID = 1 GROUP BY Levels.LevelID, Levels.Title, Teams.TeamName ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

										sqlGetSLFFL = "SELECT Levels.Title, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD FROM Standings INNER JOIN Teams ON Teams.TeamID = Standings.TeamID INNER JOIN Levels ON Levels.LevelID = Standings.LevelID WHERE Levels.LevelID = 2 GROUP BY Levels.LevelID, Levels.Title, Teams.TeamName ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

										sqlGetFLFFL = "SELECT Levels.Title, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD FROM Standings INNER JOIN Teams ON Teams.TeamID = Standings.TeamID INNER JOIN Levels ON Levels.LevelID = Standings.LevelID WHERE Levels.LevelID = 3 GROUP BY Levels.LevelID, Levels.Title, Teams.TeamName ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

										Set rsStandings = sqlDatabase.Execute(sqlGetOmega & sqlGetSLFFL & sqlGetFLFFL)

										Response.Write("<div Class=""row"">")

											Response.Write("<div Class=""col-12 col-md-12 col-lg-12 col-xl-4"">")

												Response.Write("<h4>OMEGA LEVEL</h4>")
												Response.Write("<div class=""card"">")

													Response.Write("<div class=""card-body"">")
%>
														<table class="table-borderless">
															<tr>
																<td><b>TEAM</b></td>
																<td class="text-center" width="10%" style="min-width: 70px;"><b>W-L-T</b></td>
																<td class="text-center" width="10%" style="min-width: 75px;"><b>PF</b></td>
																<td class="text-center" width="10%" style="min-width: 75px;"><b>PA</b></td>
															</tr>
														</table>

														<table class="table table-bordered">
															<tbody>
<%
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
%>
																	<tr>
																		<td><%= thisTeamName %></td>
																		<td class="text-center" width="10%" style="min-width: 70px;"><%= thisWinTotal %>-<%= thisLossTotal %>-<%= thisTieTotal %></td>
																		<td class="text-center"width="10%" style="min-width: 75px;"><%= FormatNumber(thisPointsScored, 2) %></td>
																		<td class="text-center" width="10%" style="min-width: 75px;"><%= FormatNumber(thisPointsAgainst, 2) %></td>
																	</tr>
<%
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

											Response.Write("<div Class=""col-12 col-md-12 col-lg-12 col-xl-4"">")

												Response.Write("<h4>SAME LEVEL</h4>")
												Response.Write("<div class=""card"">")

													Response.Write("<div class=""card-body"">")
%>
														<table class="table-borderless">
															<tr>
																<td><b>TEAM</b></td>
																<td class="text-center" width="10%" style="min-width: 70px;"><b>W-L-T</b></td>
																<td class="text-center" width="10%" style="min-width: 75px;"><b>PF</b></td>
																<td class="text-center" width="10%" style="min-width: 75px;"><b>PA</b></td>
															</tr>
														</table>

														<table class="table table-bordered">
															<tbody>
<%
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
%>
																	<tr>
																		<td><%= thisTeamName %></td>
																		<td class="text-center" width="10%" style="min-width: 70px;"><%= thisWinTotal %>-<%= thisLossTotal %>-<%= thisTieTotal %></td>
																		<td class="text-center"width="10%" style="min-width: 75px;"><%= FormatNumber(thisPointsScored, 2) %></td>
																		<td class="text-center" width="10%" style="min-width: 75px;"><%= FormatNumber(thisPointsAgainst, 2) %></td>
																	</tr>
<%
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

											Response.Write("<div Class=""col-12 col-md-12 col-lg-12 col-xl-4"">")

												Response.Write("<h4>FARM LEVEL</h4>")
												Response.Write("<div class=""card"">")

													Response.Write("<div class=""card-body"">")
%>
														<table class="table-borderless">
															<tr>
																<td><b>TEAM</b></td>
																<td class="text-center" width="10%" style="min-width: 70px;"><b>W-L-T</b></td>
																<td class="text-center" width="10%" style="min-width: 75px;"><b>PF</b></td>
																<td class="text-center" width="10%" style="min-width: 75px;"><b>PA</b></td>
															</tr>
														</table>

														<table class="table table-bordered">
															<tbody>
<%
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
%>
																	<tr>
																		<td><%= thisTeamName %></td>
																		<td class="text-center" width="10%" style="min-width: 70px;"><%= thisWinTotal %>-<%= thisLossTotal %>-<%= thisTieTotal %></td>
																		<td class="text-center"width="10%" style="min-width: 75px;"><%= FormatNumber(thisPointsScored, 2) %></td>
																		<td class="text-center" width="10%" style="min-width: 75px;"><%= FormatNumber(thisPointsAgainst, 2) %></td>
																	</tr>
<%
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
