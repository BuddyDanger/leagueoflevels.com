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

		<title>Playoffs / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="Playoffs / The League of Levels" />
		<meta property="og:description" content="Up-to-date playoff brackets for both the SLFFL and FLFFL. Updated weekly with the latest standings. Playoffs begin in Week 15." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="Playoffs / The League of Levels" />
		<meta name="twitter:description" content="Up-to-date playoff brackets for both the SLFFL and FLFFL. Updated weekly with the latest standings. Playoffs begin in Week 15." />

		<meta name="title" content="Playoffs / The League of Levels" />
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

				<div class="container-fluid pl-0 pl-lg-2 pr-0 pr-lg-2">
<%
					sqlGetSLFFL = "SELECT TOP 4 Levels.Title, Teams.TeamID, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD, "
					sqlGetSLFFL = sqlGetSLFFL & "(SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings "
					sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
					sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
					sqlGetSLFFL = sqlGetSLFFL & "WHERE Levels.LevelID = 2 AND Standings.Year >= " & Session.Contents("CurrentYear") & " AND Standings.Year <= " & Session.Contents("CurrentYear") & " AND Standings.Period >= 1 AND Standings.Period <= " & Session.Contents("CurrentPeriod") & " "
					sqlGetSLFFL = sqlGetSLFFL & "GROUP BY Levels.LevelID, Teams.TeamID, Levels.Title, Teams.TeamName, Standings.TeamID "
					sqlGetSLFFL = sqlGetSLFFL & "ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

					sqlGetSLFFL = sqlGetSLFFL & "SELECT TOP 2 Levels.Title, Teams.TeamID, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD, "
					sqlGetSLFFL = sqlGetSLFFL & "(SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings "
					sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
					sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
					sqlGetSLFFL = sqlGetSLFFL & "WHERE Levels.LevelID = 2 AND Standings.Year >= " & Session.Contents("CurrentYear") & " AND Standings.Year <= " & Session.Contents("CurrentYear") & " AND Standings.Period >= 1 AND Standings.Period <= " & Session.Contents("CurrentPeriod") & " AND Teams.TeamID NOT IN ( "
						sqlGetSLFFL = sqlGetSLFFL & "SELECT TOP 4 Teams.TeamID FROM Standings "
						sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
						sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
						sqlGetSLFFL = sqlGetSLFFL & "WHERE Levels.LevelID = 2 AND Standings.Year >= " & Session.Contents("CurrentYear") & " AND Standings.Year <= " & Session.Contents("CurrentYear") & " AND Standings.Period >= 1 AND Standings.Period <= " & Session.Contents("CurrentPeriod") & " "
						sqlGetSLFFL = sqlGetSLFFL & "GROUP BY Levels.LevelID, Teams.TeamID, Levels.Title, Teams.TeamName, Standings.TeamID "
						sqlGetSLFFL = sqlGetSLFFL & "ORDER BY SUM([ActualWins]) DESC, SUM([PointsScored]) DESC "
					sqlGetSLFFL = sqlGetSLFFL & ") "
					sqlGetSLFFL = sqlGetSLFFL & "GROUP BY Levels.LevelID, Teams.TeamID, Levels.Title, Teams.TeamName, Standings.TeamID "
					sqlGetSLFFL = sqlGetSLFFL & "ORDER BY Levels.LevelID ASC, BreakdownWins DESC, PointsScored DESC; "

					sqlGetSLFFL = sqlGetSLFFL & "SELECT TOP 6 Levels.Title, Teams.TeamID, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD, "
					sqlGetSLFFL = sqlGetSLFFL & "(SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings "
					sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
					sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
					sqlGetSLFFL = sqlGetSLFFL & "WHERE Levels.LevelID = 2 AND Standings.Year >= " & Session.Contents("CurrentYear") & " AND Standings.Year <= " & Session.Contents("CurrentYear") & " AND Standings.Period >= 1 AND Standings.Period <= " & Session.Contents("CurrentPeriod") & " AND Teams.TeamID NOT IN ( "
						sqlGetSLFFL = sqlGetSLFFL & "SELECT TOP 4 Teams.TeamID FROM Standings "
						sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
						sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
						sqlGetSLFFL = sqlGetSLFFL & "WHERE Levels.LevelID = 2 AND Standings.Year >= " & Session.Contents("CurrentYear") & " AND Standings.Year <= " & Session.Contents("CurrentYear") & " AND Standings.Period >= 1 AND Standings.Period <= " & Session.Contents("CurrentPeriod") & " "
						sqlGetSLFFL = sqlGetSLFFL & "GROUP BY Levels.LevelID, Teams.TeamID, Levels.Title, Teams.TeamName, Standings.TeamID "
						sqlGetSLFFL = sqlGetSLFFL & "ORDER BY SUM([ActualWins]) DESC, SUM([PointsScored]) DESC "
					sqlGetSLFFL = sqlGetSLFFL & ") AND Teams.TeamID NOT IN ( "
						sqlGetSLFFL = sqlGetSLFFL & "SELECT TOP 2 Teams.TeamID FROM Standings "
						sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
						sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
						sqlGetSLFFL = sqlGetSLFFL & "WHERE Levels.LevelID = 2 AND Standings.Year >= " & Session.Contents("CurrentYear") & " AND Standings.Year <= " & Session.Contents("CurrentYear") & " AND Standings.Period >= 1 AND Standings.Period <= " & Session.Contents("CurrentPeriod") & " AND Teams.TeamID NOT IN ( "
							sqlGetSLFFL = sqlGetSLFFL & "SELECT TOP 4 Teams.TeamID FROM Standings "
							sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
							sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
							sqlGetSLFFL = sqlGetSLFFL & "WHERE Levels.LevelID = 2 AND Standings.Year >= " & Session.Contents("CurrentYear") & " AND Standings.Year <= " & Session.Contents("CurrentYear") & " AND Standings.Period >= 1 AND Standings.Period <= " & Session.Contents("CurrentPeriod") & " "
							sqlGetSLFFL = sqlGetSLFFL & "GROUP BY Levels.LevelID, Teams.TeamID, Levels.Title, Teams.TeamName, Standings.TeamID "
							sqlGetSLFFL = sqlGetSLFFL & "ORDER BY SUM([ActualWins]) DESC, SUM([PointsScored]) DESC "
						sqlGetSLFFL = sqlGetSLFFL & ") "
						sqlGetSLFFL = sqlGetSLFFL & "GROUP BY Levels.LevelID, Teams.TeamID, Levels.Title, Teams.TeamName, Standings.TeamID "
						sqlGetSLFFL = sqlGetSLFFL & "ORDER BY Levels.LevelID ASC, SUM([BreakdownWins]) DESC, SUM([PointsScored]) DESC "
					sqlGetSLFFL = sqlGetSLFFL & ") "
					sqlGetSLFFL = sqlGetSLFFL & "GROUP BY Levels.LevelID, Teams.TeamID, Levels.Title, Teams.TeamName, Standings.TeamID "
					sqlGetSLFFL = sqlGetSLFFL & "ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC;"


					sqlGetFLFFL = Replace(sqlGetSLFFL, "LevelID = 2", "LevelID = 3")

					Set rsStandings = sqlDatabase.Execute(sqlGetSLFFL & sqlGetFLFFL)

					If Not rsStandings.Eof Then arrSLFFL1234 = rsStandings.GetRows()
					Set rsStandings = rsStandings.NextRecordset()
					If Not rsStandings.Eof Then arrSLFFL56 = rsStandings.GetRows()
					Set rsStandings = rsStandings.NextRecordset()
					If Not rsStandings.Eof Then arrSLFFL789101112 = rsStandings.GetRows()
					Set rsStandings = rsStandings.NextRecordset()
					If Not rsStandings.Eof Then arrFLFFL1234 = rsStandings.GetRows()
					Set rsStandings = rsStandings.NextRecordset()
					If Not rsStandings.Eof Then arrFLFFL56 = rsStandings.GetRows()
					Set rsStandings = rsStandings.NextRecordset()
					If Not rsStandings.Eof Then arrFLFFL789101112 = rsStandings.GetRows()

					rsStandings.Close
					Set rsStandings = Nothing
%>
					<div class="row mt-3">

						<div class="col-12 p-2">
							<div class="text-white py-1 rounded mb-1" style="height: 3.5rem; background-image: url('https://samelevel.imgix.net/danflashes-sponsorship.jpg?w=1500&h=90&fit=crop&crop=focalpoint')">
								<div class="mt-2 text-white float-xl-left" style="line-height: 2rem; font-size: 1rem;"><b><mark class="rounded-right">&nbsp;&nbsp;THE 2022 SLFFL PLAYOFFS&nbsp;&nbsp;</mark></b></div>
								<div class="mt-xl-2 text-white d-none d-xl-block float-xl-right" style="line-height: 2rem; font-size: 1rem;"><b><mark class="rounded-left">&nbsp;&nbsp;SPONSORED BY DAN FLASHES&nbsp;&nbsp;</mark></b></div>
								<div class="clearfix"></div>
							</div>
						</div>

						<!-- ROUND THREE (RELEGATION) -->
						<div class="col-xl-2 col-12 pb-4 order-6 order-xl-1">

							<div class="bg-danger text-white text-xl-right p-2 mb-2 rounded text-nowrap overflow-hidden"><b>(WEEK 17) SLFFL RELEGATION</b></div>

							<div class="py-xl-5"></div>
							<div class="py-xl-1"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-left bg-white p-3 mt-0 mb-0 rounded-top">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

						<!-- ROUND TWO (RELEGATION) -->
						<div class="col-xl-2 col-12 pb-4 order-5 order-xl-2">

							<div class="bg-danger text-white text-xl-right p-2 mb-2 rounded text-nowrap overflow-hidden"><b>(WEEK 16) SLFFL RELEGATION</b></div>

							<div class="py-xl-4"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-top">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<%= arrSLFFL789101112(2, 5) %> (12)<img src="https://samelevel.imgix.net/<%= arrSLFFL789101112(12, 5) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-2"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-top">
										<%= arrSLFFL789101112(2, 4) %> (11)<img src="https://samelevel.imgix.net/<%= arrSLFFL789101112(12, 4) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-left"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

						<!-- ROUND ONE (RELEGATION) -->
						<div class="col-xl-2 col-12 pb-4 order-4 order-xl-3">

							<div class="bg-danger text-white text-xl-right p-2 mb-2 rounded text-nowrap overflow-hidden"><b>(WEEK 15) SLFFL RELEGATION</b></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<%= arrSLFFL789101112(2, 0) %> (7)<img src="https://samelevel.imgix.net/<%= arrSLFFL789101112(12, 0) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<%= arrSLFFL789101112(2, 3) %> (10)<img src="https://samelevel.imgix.net/<%= arrSLFFL789101112(12, 3) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-4 py-1"></div>
							<div class="py-xl-4"></div>
							<div class="py-xl-2"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-top">
										<%= arrSLFFL789101112(2, 1) %> (8)<img src="https://samelevel.imgix.net/<%= arrSLFFL789101112(12, 1) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<%= arrSLFFL789101112(2, 2) %> (9)<img src="https://samelevel.imgix.net/<%= arrSLFFL789101112(12, 2) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

						<!-- ROUND ONE (CHAMPIONSHIP) -->
						<div class="col-xl-2 col-12 pb-4 order-1 order-xl-4">

							<div class="bg-success text-white p-2 mb-2 rounded text-nowrap overflow-hidden"><b>SLFFL CHAMPIONSHIP (WEEK 15)</b></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<img src="https://samelevel.imgix.net/<%= arrSLFFL1234(12, 3) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(4) <%= arrSLFFL1234(2, 3) %>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/<%= arrSLFFL56(12, 0) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(5) <%= arrSLFFL56(2, 0) %>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-4 py-1"></div>
							<div class="py-xl-4"></div>
							<div class="py-xl-2"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<img src="https://samelevel.imgix.net/<%= arrSLFFL1234(12, 2) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(3) <%= arrSLFFL1234(2, 2) %>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/<%= arrSLFFL56(12, 1) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(6) <%= arrSLFFL56(2, 1) %>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

						<!-- ROUND TWO (CHAMPIONSHIP) -->
						<div class="col-xl-2 col-12 pb-4 order-2 order-xl-5">

							<div class="bg-success text-white p-2 mb-2 rounded text-nowrap overflow-hidden"><b>SLFFL CHAMPIONSHIP (WEEK 16)</b></div>

							<div class="py-xl-4"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/<%= arrSLFFL1234(12, 0) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(1) <%= arrSLFFL1234(2, 0) %>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-2 py-1"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<img src="https://samelevel.imgix.net/<%= arrSLFFL1234(12, 1) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(2) <%= arrSLFFL1234(2, 1) %>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

						<!-- ROUND THREE (CHAMPIONSHIP) -->
						<div class="col-xl-2 col-12 pb-4 order-3 order-xl-6">

							<div class="bg-success text-white p-2 mb-2 rounded text-nowrap overflow-hidden"><b>SLFFL CHAMPIONSHIP (WEEK 17)</b></div>

							<div class="py-xl-5"></div>
							<div class="py-xl-1"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

					</div>


					<div class="row mt-4">

						<div class="col-12 p-2">
							<div class="text-white py-1 rounded mb-1" style="height: 3.5rem; background-image: url('https://samelevel.imgix.net/fentons-sponsorship.jpg?w=1500&h=90&fit=crop&crop=focalpoint')">
								<div class="mt-2 text-white float-xl-left" style="line-height: 2rem; font-size: 1rem;"><b><mark class="rounded-right">&nbsp;&nbsp;THE 2022 FARM PLAYOFFS&nbsp;&nbsp;</mark></b></div>
								<div class="mt-xl-2 text-white d-none d-xl-block float-xl-right" style="line-height: 2rem; font-size: 1rem;"><b><mark class="rounded-left">&nbsp;&nbsp;SPONSORED BY FENTON'S STABLES&nbsp;&nbsp;</mark></b></div>
								<div class="clearfix"></div>
							</div>
						</div>

						<!-- ROUND THREE (RELEGATION) -->
						<div class="col-xl-2 col-12 pb-4 order-6 order-xl-1">

							<div class="bg-danger text-white text-xl-right p-2 mb-2 rounded text-nowrap overflow-hidden"><b>(WEEK 17) FLFFL RELEGATION</b></div>

							<div class="py-xl-5"></div>
							<div class="py-xl-1"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-left bg-white p-3 mt-0 mb-0 rounded-top">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

						<!-- ROUND TWO (RELEGATION) -->
						<div class="col-xl-2 col-12 pb-4 order-5 order-xl-2">

							<div class="bg-danger text-white text-xl-right p-2 mb-2 rounded text-nowrap overflow-hidden"><b>(WEEK 16) FLFFL RELEGATION</b></div>

							<div class="py-xl-4"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-top">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<%= arrFLFFL789101112(2, 5) %> (12)<img src="https://samelevel.imgix.net/<%= arrFLFFL789101112(12, 5) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-2"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-top">
										<%= arrFLFFL789101112(2, 4) %> (11)<img src="https://samelevel.imgix.net/<%= arrFLFFL789101112(12, 4) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-left"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

						<!-- ROUND ONE (RELEGATION) -->
						<div class="col-xl-2 col-12 pb-4 order-4 order-xl-3">

							<div class="bg-danger text-white text-xl-right p-2 mb-2 rounded text-nowrap overflow-hidden"><b>(WEEK 15) FLFFL RELEGATION</b></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<%= arrFLFFL789101112(2, 0) %> (7)<img src="https://samelevel.imgix.net/<%= arrFLFFL789101112(12, 0) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<%= arrFLFFL789101112(2, 3) %> (10)<img src="https://samelevel.imgix.net/<%= arrFLFFL789101112(12, 3) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-4 py-1"></div>
							<div class="py-xl-4"></div>
							<div class="py-xl-2"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-top">
										<%= arrFLFFL789101112(2, 1) %> (8)<img src="https://samelevel.imgix.net/<%= arrFLFFL789101112(12, 1) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<%= arrFLFFL789101112(2, 2) %> (9)<img src="https://samelevel.imgix.net/<%= arrFLFFL789101112(12, 2) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

						<!-- ROUND ONE (CHAMPIONSHIP) -->
						<div class="col-xl-2 col-12 pb-4 order-1 order-xl-4">

							<div class="bg-success text-white p-2 mb-2 rounded text-nowrap overflow-hidden"><b>FLFFL CHAMPIONSHIP (WEEK 15)</b></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<img src="https://samelevel.imgix.net/<%= arrFLFFL1234(12, 3) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(4) <%= arrFLFFL1234(2, 3) %>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/<%= arrFLFFL56(12, 0) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(5) <%= arrFLFFL56(2, 0) %>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-4 py-1"></div>
							<div class="py-xl-4"></div>
							<div class="py-xl-2"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<img src="https://samelevel.imgix.net/<%= arrFLFFL1234(12, 2) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(3) <%= arrFLFFL1234(2, 2) %>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/<%= arrFLFFL56(12, 1) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(6) <%= arrFLFFL56(2, 1) %>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

						<!-- ROUND TWO (CHAMPIONSHIP) -->
						<div class="col-xl-2 col-12 pb-4 order-2 order-xl-5">

							<div class="bg-success text-white p-2 mb-2 rounded text-nowrap overflow-hidden"><b>FLFFL CHAMPIONSHIP (WEEK 16)</b></div>

							<div class="py-xl-4"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/<%= arrFLFFL1234(12, 0) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(1) <%= arrFLFFL1234(2, 0) %>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-2 py-1"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<img src="https://samelevel.imgix.net/<%= arrFLFFL1234(12, 1) %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(2) <%= arrFLFFL1234(2, 1) %>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

						</div>

						<!-- ROUND THREE (CHAMPIONSHIP) -->
						<div class="col-xl-2 col-12 pb-4 order-3 order-xl-6">

							<div class="bg-success text-white p-2 mb-2 rounded text-nowrap overflow-hidden"><b>FLFFL CHAMPIONSHIP (WEEK 17)</b></div>

							<div class="py-xl-5"></div>
							<div class="py-xl-1"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<div style="height: 17px;"></div>
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

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
