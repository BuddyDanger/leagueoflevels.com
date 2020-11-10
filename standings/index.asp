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

		<title>Schedule / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="Schedule - The League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="Schedule - The League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="Schedule - The League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/" />

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

								<h4 class="page-title">Standings / <%= thisYear %> / Period <%= thisPeriod %></h4>

							</div>

							<div class="page-content">

								<ul class="nav nav-pills">
									<li class="nav-item">
										<a class="nav-link" href="#">OMEGA</a>
									</li>
									<li class="nav-item">
										<a class="nav-link" href="#">SLFFL</a>
									</li>
									<li class="nav-item">
										<a class="nav-link" href="#">FLFFL</a>
									</li>
								</ul>

								<div class="row">
									<div class="col-12">

										<div class="card">

											<div class="card-body">

												<table width="100%" class="table table-bordered">
													<thead>
														<tr>
															<th width="5%" style="min-width: 80px;"><b>LEVEL</b></th>
															<th><b>MATCHUP</b></th>
															<th width="10%" style="min-width: 60px;"><b>SCORE</b></th>
															<th width="10%" style="min-width: 60px;"><b>W/L</b></th>
														</tr>
													</thead>
												</table>
<%
													sqlGetSchedules = "SELECT MatchupID, Matchups.LevelID, Year, Period, IsPlayoffs, TeamID1, TeamID2, Team1.TeamName AS TeamName1, Team2.TeamName AS TeamName2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2, Leg, TeamProjected1, TeamProjected2, TeamWinPercentage1, TeamWinPercentage2, TeamMoneyline1, TeamMoneyline2, TeamSpread1, TeamSpread2 FROM Matchups "
													sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team1 ON Team1.TeamID = Matchups.TeamID1 "
													sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team2 ON Team2.TeamID = Matchups.TeamID2 "
													sqlGetSchedules = sqlGetSchedules & "WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " "
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

														If CInt(thisLevelID) = 0 Then LevelCell = "CUP"
														If CInt(thisLevelID) = 1 Then LevelCell = "OMEGA"
														If CInt(thisLevelID) = 2 Then LevelCell = "SLFFL"
														If CInt(thisLevelID) = 3 Then LevelCell = "FLFFL"
	%>
														<table class="table table-bordered">
															<tbody>
																<tr>
																	<td rowspan="2" width="5%" style="min-width: 80px;" align="center"><%= LevelCell %></td>
																	<td><%= thisTeamName1 %></td>
																	<td width="10%" style="min-width: 60px;"><%= thisTeamScore1 %></td>
																	<td width="10%" style="min-width: 40px;"></td>
																</tr>
																<tr>
																	<td><%= thisTeamName2 %></td>
																	<td width="10%" style="min-width: 60px;"><%= thisTeamScore2 %></td>
																	<td width="10%" style="min-width: 40px;"></td>
																</tr>
															</tbody>
														</table>
	<%
														rsSchedules.MoveNext

													Loop

													rsSchedules.Close
													Set rsSchedules = Nothing
%>
													</tbody>
												</table>

											</div>
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
