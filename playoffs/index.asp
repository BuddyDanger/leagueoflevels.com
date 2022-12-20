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
										BOOYAAHH (10)<img src="https://samelevel.imgix.net/icon-booyaahh.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										Bapes (12)<img src="https://samelevel.imgix.net/icon-ecbca3a708e649f570d9ba624841e19cefb4d74cc2df9f7bf3011282ab980d57.JPG?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-2 py-1"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-top">
										AOL 4 Life (11)<img src="https://samelevel.imgix.net/icon-f5a662fa05a36b423d1747c9c1d98b75fcf1505bba5fd5aa3d9c32b1efea04a7.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-left"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										Proper Football (9)<img src="https://samelevel.imgix.net/icon-proper.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
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
										<strike style="color: #1ecab8;">Terrible Towelie (7)</strike><img src="https://samelevel.imgix.net/icon-3f3d785d2583e8c2d88ef1ad7e4a9a464fd6f19ddfa1d17c528d85e164320094.jpeg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<span style="color: #f1646c;">BOOYAAHH (10)</span><img src="https://samelevel.imgix.net/icon-booyaahh.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
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
										<strike style="color: #1ecab8;">Blitzed (8)</strike><img src="https://samelevel.imgix.net/icon-b8294734ebb85e4802c52047a51ec241626a97bdfe46e0f43d6bb565d165a568.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<span style="color: #f1646c;">Proper Football (9)</span><img src="https://samelevel.imgix.net/icon-proper.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
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
										<img src="https://samelevel.imgix.net/icon-smokinblountz.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2"><strike style="color: #f1646c;">(4) Smokin' Blountz</strike>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/gdeep.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2"><span style="color: #1ecab8;">(5) Gone Deep</span>
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
										<img src="https://samelevel.imgix.net/tfm.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2"><span style="color: #1ecab8;">(3) Ten Foot Midget</span>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/icon-f5d3ff0ce4469468a958cd0d4b88aa78ea703eb69545d1a13917c80699d28bc9.PNG?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2"><strike style="color: #f1646c;">(6) 4th and 9 Inches</strike>
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
										<img src="https://samelevel.imgix.net/gdeep.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(5) Gone Deep
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/icon-6e5505b514c25680f5f712b79c908ed28fee241cfa943bb4d6ce42189b79ee53.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(1) High Decibels
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-2 py-1"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<img src="https://samelevel.imgix.net/icon-munchen.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(2) Munchen on Bundchen
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/tfm.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(3) Ten Foot Midget
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
										Fournette Caters (7)<img src="https://samelevel.imgix.net/icon-caters.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										Holding Court (12)<img src="https://samelevel.imgix.net/icon-8efe9b8e038ecc474a00fe1ddb9bdeeb90d99b943ef13acee63cfc06ec882b0c.jpeg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-left"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-2 py-1"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-top">
										Coheeds (11)<img src="https://samelevel.imgix.net/icon-4733557fd47f6eac9130ad27db36e6bca5590b8df4cd05458265e3746cc92548.jpeg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-left"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										Sacks in the City (8)<img src="https://samelevel.imgix.net/icon-9aad698267bff349d84ee940906149280f61c71c745848f1749a13336a331d0b.png?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
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
										<span style="color: #f1646c;">Fournette Caters (7)</span><img src="https://samelevel.imgix.net/icon-caters.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<strike style="color: #1ecab8;">Nuke' Em (10)</strike><img src="https://samelevel.imgix.net/nukeem.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
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
										<span style="color: #f1646c;">Sacks in the City (8)</span><img src="https://samelevel.imgix.net/icon-9aad698267bff349d84ee940906149280f61c71c745848f1749a13336a331d0b.png?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-xl-right bg-white p-3 mt-0 mb-0 rounded-bottom">
										<strike style="color: #1ecab8;">Smokin' Jay Cutlers (9)</strike><img src="https://samelevel.imgix.net/smokin-jay.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline ml-2">
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
										<img src="https://samelevel.imgix.net/icon-31327d645150ef09d795efd3799aa41fb66791cbac553f8de61e75b82b6ae6fa.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2"><span style="color: #1ecab8;">(4) Buddy Danger</span>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/icon-76a925038547e7e1ccea4686a9465048ae0514838a750cebc86802039c6988ca.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2"><strike style="color: #f1646c;">(5) Filthy Animals</strike>
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
										<img src="https://samelevel.imgix.net/bigballers.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2"><span style="color: #1ecab8;">(3) Big Ballers</span>
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/icon-be218a04554de8af12cdd4581d73eb5266684d2daa95739adee7c7e2b3b22ff0.jpeg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2"><strike style="color: #f1646c;">(6) Hanging with Hernandez</strike>
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
										<img src="https://samelevel.imgix.net/icon-31327d645150ef09d795efd3799aa41fb66791cbac553f8de61e75b82b6ae6fa.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(4) Buddy Danger
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/icon-499cdf64521a9eb639138ef715d3b76ee8f04c98538b2bac44c4dea0f9d3892d.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(1) Big TD's
										<div class="float-right"></div>
									</h6>
								</li>
							</ul>

							<div class="py-xl-2 py-1"></div>

							<ul class="list-group list-flush">
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-top">
										<img src="https://samelevel.imgix.net/danger.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(2) DangercrazyDC
										<div class="float-right"></div>
									</h6>
								</li>
								<li class="list-group-item p-0 text-nowrap overflow-hidden">
									<h6 class="text-left bg-white p-3 mt-0 mb-0 rounded-bottom">
										<img src="https://samelevel.imgix.net/bigballers.jpg?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-inline mr-2">(3) Big Ballers
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
