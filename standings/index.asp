<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	If Len(ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))) < 1 Then

		Session.Contents("SITE_Standings_LevelID") = ""
		Session.Contents("SITE_Standings_Start_Year") = "2020"
		Session.Contents("SITE_Standings_End_Year") = "2020"
		Session.Contents("SITE_Standings_Start_Period") = "1"
		Session.Contents("SITE_Standings_End_Period") = "17"

	End If

	If Request.Form("action") = "update" Then

		thisLevel = Request.Form("level")
		thisStartYear = Request.Form("years_start")
		thisEndYear = Request.Form("years_end")
		thisStartPeriod = Request.Form("periods_start")
		thisEndPeriod = Request.Form("periods_end")

		If CInt(thisStartYear) = CInt(thisEndYear) Then
			thisYearString = thisStartYear
		Else
			thisYearString = thisStartYear & "-" & thisEndYear
		End If

		If CInt(thisStartPeriod) = CInt(thisEndPeriod) Then
			thisPeriodString = thisStartPeriod
		Else
			thisPeriodString = thisStartPeriod & "-" & thisEndPeriod
		End If

		If Len(thisLevel) > 0 Then

			Response.Redirect("/standings/" & thisLevel & "/" & thisYearString & "/" & thisPeriodString & "/")

		Else

			Response.Redirect("/standings/" & thisYearString & "/" & thisPeriodString & "/")

		End If

	End If

	sqlGetSLFFL = "SELECT Levels.Title, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD, "
	sqlGetSLFFL = sqlGetSLFFL & "(SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings "
	sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
	sqlGetSLFFL = sqlGetSLFFL & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
	sqlGetSLFFL = sqlGetSLFFL & "WHERE Levels.LevelID = 2 "
	sqlGetSLFFL = sqlGetSLFFL & "AND Standings.Year >= " & Session.Contents("SITE_Standings_Start_Year") & " "
	sqlGetSLFFL = sqlGetSLFFL & "AND Standings.Year <= " & Session.Contents("SITE_Standings_End_Year") & " "
	sqlGetSLFFL = sqlGetSLFFL & "AND Standings.Period >= " & Session.Contents("SITE_Standings_Start_Period") & " "
	sqlGetSLFFL = sqlGetSLFFL & "AND Standings.Period <= " & Session.Contents("SITE_Standings_End_Period") & " "
	sqlGetSLFFL = sqlGetSLFFL & "GROUP BY Levels.LevelID, Levels.Title, Teams.TeamName, Standings.TeamID ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

	sqlGetFLFFL = "SELECT Levels.Title, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD, "
	sqlGetFLFFL = sqlGetFLFFL & "(SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings "
	sqlGetFLFFL = sqlGetFLFFL & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
	sqlGetFLFFL = sqlGetFLFFL & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
	sqlGetFLFFL = sqlGetFLFFL & "WHERE Levels.LevelID = 3 "
	sqlGetFLFFL = sqlGetFLFFL & "AND Standings.Year >= " & Session.Contents("SITE_Standings_Start_Year") & " "
	sqlGetFLFFL = sqlGetFLFFL & "AND Standings.Year <= " & Session.Contents("SITE_Standings_End_Year") & " "
	sqlGetFLFFL = sqlGetFLFFL & "AND Standings.Period >= " & Session.Contents("SITE_Standings_Start_Period") & " "
	sqlGetFLFFL = sqlGetFLFFL & "AND Standings.Period <= " & Session.Contents("SITE_Standings_End_Period") & " "
	sqlGetFLFFL = sqlGetFLFFL & "GROUP BY Levels.LevelID, Levels.Title, Teams.TeamName, Standings.TeamID ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

	sqlGetOmega = "SELECT Levels.Title, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD, "
	sqlGetOmega = sqlGetOmega & "(SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings "
	sqlGetOmega = sqlGetOmega & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
	sqlGetOmega = sqlGetOmega & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
	sqlGetOmega = sqlGetOmega & "WHERE Levels.LevelID = 1 "
	sqlGetOmega = sqlGetOmega & "AND Standings.Year >= " & Session.Contents("SITE_Standings_Start_Year") & " "
	sqlGetOmega = sqlGetOmega & "AND Standings.Year <= " & Session.Contents("SITE_Standings_End_Year") & " "
	sqlGetOmega = sqlGetOmega & "AND Standings.Period >= " & Session.Contents("SITE_Standings_Start_Period") & " "
	sqlGetOmega = sqlGetOmega & "AND Standings.Period <= " & Session.Contents("SITE_Standings_End_Period") & " "
	sqlGetOmega = sqlGetOmega & "GROUP BY Levels.LevelID, Levels.Title, Teams.TeamName, Standings.TeamID ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

	sqlGetPoints = "SELECT Teams.TeamName, SUM([PointsScored]) AS PointsScored, (SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings "
	sqlGetPoints = sqlGetPoints & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
	sqlGetPoints = sqlGetPoints & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "

	If Len(Session.Contents("SITE_Standings_LevelID")) > 0 Then
		sqlGetPoints = sqlGetPoints & "WHERE Levels.LevelID = " & Session.Contents("SITE_Standings_LevelID") & " AND Teams.EndYear = 0 "
	Else
		sqlGetPoints = sqlGetPoints & "WHERE Levels.LevelID > 1 AND Teams.EndYear = 0 "
	End If

	sqlGetPoints = sqlGetPoints & "AND Standings.Year >= " & Session.Contents("SITE_Standings_Start_Year") & " "
	sqlGetPoints = sqlGetPoints & "AND Standings.Year <= " & Session.Contents("SITE_Standings_End_Year") & " "
	sqlGetPoints = sqlGetPoints & "AND Standings.Period >= " & Session.Contents("SITE_Standings_Start_Period") & " "
	sqlGetPoints = sqlGetPoints & "AND Standings.Period <= " & Session.Contents("SITE_Standings_End_Period") & " "
	sqlGetPoints = sqlGetPoints & "GROUP BY Standings.TeamID, Teams.TeamName ORDER BY PointsScored DESC; "

	Set rsStandings = sqlDatabase.Execute(sqlGetSLFFL & sqlGetFLFFL & sqlGetOmega & sqlGetPoints)

	If CStr(Session.Contents("SITE_Standings_LevelID")) = "1" Or CStr(Session.Contents("SITE_Standings_LevelID")) = "2" Or CStr(Session.Contents("SITE_Standings_LevelID")) = "3" Then
		If CStr(Session.Contents("SITE_Standings_LevelID")) = "1" Then PageTitle = "Omega Level "
		If CStr(Session.Contents("SITE_Standings_LevelID")) = "2" Then PageTitle = "Same Level "
		If CStr(Session.Contents("SITE_Standings_LevelID")) = "3" Then PageTitle = "Farm Level "
	End If

	PageTitle = PageTitle & "Standings / " & Session.Contents("SITE_Standings_Start_Year") & " "
	If Session.Contents("SITE_Standings_End_Year") <> Session.Contents("SITE_Standings_Start_Year") Then PageTitle = PageTitle & "- " & Session.Contents("SITE_Standings_End_Year") & ", "
	PageTitle = PageTitle & "/ Periods " & Session.Contents("SITE_Standings_Start_Period") & " "
	If Session.Contents("SITE_Standings_End_Period") <> Session.Contents("SITE_Standings_Start_Period") Then PageTitle = PageTitle & "- " & Session.Contents("SITE_Standings_End_Period") & " "
	PageTitle = PageTitle & "/ League of Levels"

	PageDescription = "Updated standings across the League of Levels. These standings should accurately represent each individual league account. Next Level Cup matchups are not included in these aggregate numbers for wins, losses, or points."


%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title><%= PageTitle %></title>

		<meta name="description" content="Updated standings across the League of Levels. These standings should accurately represent each individual league account. Next Level Cup matchups are not included in these aggregate numbers for wins, losses, or points." />

		<meta property="og:site_name" content="League of Levels" />
		<meta property="og:url" content="https://www.leagueoflevels.com/standings/" />
		<meta property="og:title" content="<%= PageTitle %>" />
		<meta property="og:description" content="Updated standings across the League of Levels. These standings should accurately represent each individual league account. Next Level Cup matchups are not included in these aggregate numbers for wins, losses, or points." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/standings/" />
		<meta name="twitter:title" content="<%= PageTitle %>" />
		<meta name="twitter:description" content="Updated standings across the League of Levels. These standings should accurately represent each individual league account. Next Level Cup matchups are not included in these aggregate numbers for wins, losses, or points." />

		<meta name="title" content="<%= PageTitle %>" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/standings/standings/" />

		<link href="/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/icons.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/style.css?version=3" rel="stylesheet" type="text/css" />

		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.1/css/ion.rangeSlider.min.css"/>

	</head>

	<body>

		<!--#include virtual="/assets/asp/framework/topbar.asp" -->

		<div class="page-wrapper">

			<!--#include virtual="/assets/asp/framework/nav.asp" -->

			<div class="page-content">

				<div class="container-fluid">

					<form class="mt-4" method="post" action="/standings/index.asp">

						<input type="hidden" name="action" value="update" />
						<input type="hidden" class="years_start" name="years_start" value="<%= Session.Contents("SITE_Standings_Start_Year") %>" />
						<input type="hidden" class="years_end" name="years_end" value="<%= Session.Contents("SITE_Standings_End_Year") %>" />
						<input type="hidden" class="periods_start" name="periods_start" value="<%= Session.Contents("SITE_Standings_Start_Period") %>" />
						<input type="hidden" class="periods_end" name="periods_end" value="<%= Session.Contents("SITE_Standings_End_Period") %>" />

						<div class="row">

							<div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-5">

								<div class="form-group pb-xl-0">

									<div class="col-form-label text-left bg-warning text-white p-2 mb-0 rounded-top"><b>SELECT YEAR RANGE</b></div>
									<div class="bg-white pt-3 pb-3 pl-4 pr-4 mb-2 rounded-bottom">
										<input type="text" class="standings_year" name="years" value="" data-from="<%= Session.Contents("SITE_Standings_Start_Year") %>" data-to="<%= Session.Contents("SITE_Standings_End_Year") %>" />
									</div>

								</div>

							</div>

							<div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-5">

								<div class="form-group pb-xl-0">

									<div class="col-form-label text-left bg-warning text-white p-2 mb-0 rounded-top"><b>SELECT PERIOD RANGE</b></div>
									<div class="bg-white pt-3 pb-3 pl-4 pr-4 mb-2 rounded-bottom">
										<input type="text" class="standings_period" name="periods" value="" data-from="<%= Session.Contents("SITE_Standings_Start_Period") %>" data-to="<%= Session.Contents("SITE_Standings_End_Period") %>" />
									</div>

								</div>

							</div>

							<div class="col-12 col-xl-2">

								<select class="form-control form-control-lg form-check-input-lg mb-3" name="level" id="level">
									<option value="">ALL LEVELS</option>
									<option value="omega-level" <% If CStr(Session.Contents("SITE_Standings_LevelID")) = "1" Then %>selected<% End If %>>OMEGA LEVEL</option>
									<option value="same-level" <% If CStr(Session.Contents("SITE_Standings_LevelID")) = "2" Then %>selected<% End If %>>SAME LEVEL</option>
									<option value="farm-level" <% If CStr(Session.Contents("SITE_Standings_LevelID")) = "3" Then %>selected<% End If %>>FARM LEVEL</option>
								</select>

								<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-4">UPDATE</button>

							</div>

						</div>

					</form>


					<div class="row">
<%
						If Len(Session.Contents("SITE_Standings_LevelID")) = 0 Or CStr(Session.Contents("SITE_Standings_LevelID")) = "2" Then
%>
							<div Class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-6">

								<h4 class="text-left bg-info text-white p-3 mt-0 mb-0 rounded-top"><b>SAME LEVEL</b><span class="float-right dripicons-trophy"></i></h4>
								<div class="card">

									<div class="card-body p-0">

										<table class="table mb-1">
											<thead>
												<tr>
													<th class="pl-3">TEAM</th>
													<th class="text-center">W-L-T</th>
													<th class="text-center d-none d-sm-table-cell">PF</th>
													<th class="text-center d-none d-sm-table-cell">PA</th>
													<th class="text-center d-none d-md-table-cell">BKDN</th>
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
														<td class="pl-3"><img src="https://samelevel.imgix.net/<%= thisProfileImage %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline mr-1 pr-1"><b><%= thisPosition %>.</b> &nbsp;<%= thisTeamName %></td>
														<td class="text-center"><%= thisWinTotal %>-<%= thisLossTotal %>-<%= thisTieTotal %></td>
														<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(thisPointsScored, 2) %></td>
														<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(thisPointsAgainst, 2) %></td>
														<td class="text-center d-none d-md-table-cell"><%= thisBreakdownWins %>-<%= thisBreakdownLosses %>-<%= thisBreakdownTies %></td>
													</tr>
<%
													thisPosition = thisPosition + 1
													rsStandings.MoveNext

												Loop
%>
											</tbody>
										</table>

									</div>

								</div>

							</div>
<%
						End If

						Set rsStandings = rsStandings.NextRecordset

						If Len(Session.Contents("SITE_Standings_LevelID")) = 0 Or CStr(Session.Contents("SITE_Standings_LevelID")) = "3" Then
%>
							<div Class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-6">

								<h4 class="text-left bg-info text-white p-3 mt-0 mb-0 rounded-top"><b>FARM LEVEL</b><span class="float-right dripicons-trophy"></i></h4>
								<div class="card">

									<div class="card-body p-0">

										<table class="table mb-1">
											<thead>
												<tr>
													<th>TEAM</th>
													<th class="text-center">W-L-T</th>
													<th class="text-center d-none d-sm-table-cell">PF</th>
													<th class="text-center d-none d-sm-table-cell">PA</th>
													<th class="text-center d-none d-md-table-cell">BKDN</th>
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
														<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(thisPointsScored, 2) %></td>
														<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(thisPointsAgainst, 2) %></td>
														<td class="text-center d-none d-md-table-cell"><%= thisBreakdownWins %>-<%= thisBreakdownLosses %>-<%= thisBreakdownTies %></td>
													</tr>
<%
													thisPosition = thisPosition + 1
													rsStandings.MoveNext

												Loop
%>
											</tbody>
										</table>

									</div>

								</div>

							</div>
<%
						End If

						Set rsStandings = rsStandings.NextRecordset

						If Len(Session.Contents("SITE_Standings_LevelID")) = 0 Or CStr(Session.Contents("SITE_Standings_LevelID")) = "1" Then
%>
							<div Class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-6">

								<h4 class="text-left bg-info text-white p-3 mt-0 mb-0 rounded-top"><b>OMEGA LEVEL</b><span class="float-right dripicons-trophy"></i></h4>
								<div class="card">

									<div class="card-body p-0">

										<table class="table mb-1">
											<thead>
												<tr>
													<th>TEAM</th>
													<th class="text-center">W-L-T</th>
													<th class="text-center d-none d-sm-table-cell">PF</th>
													<th class="text-center d-none d-sm-table-cell">PA</th>
													<th class="text-center d-none d-md-table-cell">BKDN</th>
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
														<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(thisPointsScored, 2) %></td>
														<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(thisPointsAgainst, 2) %></td>
														<td class="text-center d-none d-md-table-cell"><%= thisBreakdownWins %>-<%= thisBreakdownLosses %>-<%= thisBreakdownTies %></td>
													</tr>
<%
													thisPosition = thisPosition + 1
													rsStandings.MoveNext

												Loop
%>
											</tbody>
										</table>

									</div>

								</div>

							</div>
<%
						End If

						Set rsStandings = rsStandings.NextRecordset
%>
						<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-6">

							<h4 class="text-left bg-info text-white p-3 mt-0 mb-0 rounded-top"><b>TOTAL POINTS</b><span class="float-right dripicons-trophy"></i></h4>
							<div class="card">

								<div class="card-body p-0">

									<table class="table mb-1">
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

		<script src="https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.1/js/ion.rangeSlider.min.js"></script>
        <script src="/assets/js/standings.js"></script>

		<!--#include virtual="/assets/asp/framework/google.asp" -->

	</body>

</html>
