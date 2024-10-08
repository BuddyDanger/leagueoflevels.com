<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	If Len(ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))) < 1 Then Session.Contents("SITE_Schmeckles_AccountID") = ""
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Majors / Qualifying & Standings / League of Levels</title>

		<meta name="description" content="Majors represent the top-six teams from each level through the first three weeks, respectively. These teams are then squared off against each other in a four-week round-robin tournament with 10,000 schmeckles up for grabs." />

		<meta property="og:site_name" content="League of Levels" />
		<meta property="og:url" content="https://www.leagueoflevels.com/majors/" />
		<meta property="og:title" content="Majors / Qualifying & Standings / League of Levels" />
		<meta property="og:description" content="Majors represent the top-six teams from each level through the first three weeks, respectively. These teams are then squared off against each other in a four-week round-robin tournament with 10,000 schmeckles up for grabs." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/majors/" />
		<meta name="twitter:title" content="Majors / Qualifying & Standings / League of Levels" />
		<meta name="twitter:description" content="Majors represent the top-six teams from each level through the first three weeks, respectively. These teams are then squared off against each other in a four-week round-robin tournament with 10,000 schmeckles up for grabs." />

		<meta name="title" content="Majors / Qualifying & Standings / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/majors/" />

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
<%
						sqlGetMajors = "SELECT MajorID, Majors.LevelID, Levels.Title, MajorTitle FROM Majors INNER JOIN Levels ON Levels.LevelID = Majors.LevelID WHERE Year = 2024 AND StartPeriod = 4 ORDER BY StartPeriod DESC, LevelID ASC"
						Set rsMajors = sqlDatabase.Execute(sqlGetMajors)

						Do While Not rsMajors.Eof

							thisMajorTitle = UCase(rsMajors("Title") & " " & rsMajors("MajorTitle"))
							thisMajorID = rsMajors("MajorID")
							thisLevelID = rsMajors("LevelID")
%>
							<div class="col-12 col-xxl-4">

								<div class="row mb-3">

									<div class="col-12">

										<div class="card">

											<div class="card-body p-0">

												<table class="table mb-1 rounded">
													<thead>
														<tr>
															<th class="pl-3"><b><%= thisMajorTitle %></b></th>
															<th class="text-center">W-L-T</th>
															<th class="text-center d-none d-sm-table-cell">PF</th>
															<th class="text-center d-none d-sm-table-cell">PA</th>
														</tr>
													</thead>
													<tbody>
<%
														sqlGetStandings = "SELECT MajorID, MajorStandings.LevelID, Year, MajorStandings.TeamID, Accounts.ProfileName, Accounts.ProfileImage, SUM(ActualWins) AS TotalWins, SUM(ActualLosses) AS TotalLosses, SUM(ActualTies) AS TotalTies, SUM(PointsScored) AS TotalPointsScored, SUM(PointsAgainst) AS TotalPointsAllowed "
														sqlGetStandings = sqlGetStandings & "FROM MajorStandings "
														sqlGetStandings = sqlGetStandings & "INNER JOIN Teams ON Teams.TeamID = MajorStandings.TeamID "
														sqlGetStandings = sqlGetStandings & "INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = MajorStandings.TeamID "
														sqlGetStandings = sqlGetStandings & "INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID "
														sqlGetStandings = sqlGetStandings & "WHERE MajorStandings.LevelID = " & thisLevelID & " And MajorStandings.MajorID = " & thisMajorID & " "
														sqlGetStandings = sqlGetStandings & "GROUP BY MajorID, MajorStandings.LevelID, Year, MajorStandings.TeamID, Accounts.ProfileName, Accounts.ProfileImage "
														sqlGetStandings = sqlGetStandings & "ORDER BY TotalWins DESC, TotalPointsScored DESC, TotalLosses ASC"

														Set rsStandings = sqlDatabase.Execute(sqlGetStandings)

														thisPosition = 1
														Do While Not rsStandings.Eof
%>
															<tr style="<%= thisBorderBottom %>">
																<td class="pl-3"><img src="https://samelevel.imgix.net/<%= rsStandings("ProfileImage") %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline mr-2"><b><%= thisPosition %>.</b> &nbsp;<%= rsStandings("ProfileName") %></td>
																<td class="text-center"><%= rsStandings("TotalWins") %>-<%= rsStandings("TotalLosses") %>-<%= rsStandings("TotalTies") %></td>
																<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(rsStandings("TotalPointsScored"), 2) %></td>
																<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(rsStandings("TotalPointsAllowed"), 2) %></td>
															</tr>
<%
															rsStandings.MoveNext
															thisPosition = thisPosition + 1

														Loop

														rsStandings.Close
														Set rsStandings = Nothing
%>
													</tbody>

												</table>

											</div>

										</div>

									</div>
<%
									sqlGetMajorMatchups = "SELECT MatchupID, Matchups.LevelID, Year, Period, A1.ProfileName AS ProfileName1, A2.ProfileName AS ProfileName2, T1.AbbreviatedName AS AbbreviatedName1, T2.AbbreviatedName AS AbbreviatedName2, A1.ProfileImage AS ProfileImage1, A2.ProfileImage AS ProfileImage2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2 "
									sqlGetMajorMatchups = sqlGetMajorMatchups & "FROM Matchups "
									sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN Teams T1 ON T1.TeamID = Matchups.TeamID1 "
									sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN Teams T2 ON T2.TeamID = Matchups.TeamID2 "
									sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN LinkAccountsTeams L1 ON L1.TeamID = T1.TeamID "
									sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN LinkAccountsTeams L2 ON L2.TeamID = T2.TeamID "
									sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN Accounts A1 ON A1.AccountID = L1.AccountID "
									sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN Accounts A2 ON A2.AccountID = L2.AccountID "
									sqlGetMajorMatchups = sqlGetMajorMatchups & "WHERE Year = 2024 AND (Period >= 4 AND Period <= 7) AND (Matchups.LevelID = " & thisLevelID & ") AND IsMajor = 1 "
									sqlGetMajorMatchups = sqlGetMajorMatchups & "ORDER BY Period ASC, LevelID ASC"

									Set rsMajorMatchups = sqlDatabase.Execute(sqlGetMajorMatchups)

									thisRunningPeriod = 0
									Do While Not rsMajorMatchups.Eof

										thisMatchupID = rsMajorMatchups("MatchupID")
										thisLevelID = rsMajorMatchups("LevelID")
										thisYear = rsMajorMatchups("Year")
										thisPeriod = rsMajorMatchups("Period")
										thisProfileName1 = rsMajorMatchups("ProfileName1")
										thisProfileName2 = rsMajorMatchups("ProfileName2")
										thisAbbreviatedName1 = rsMajorMatchups("AbbreviatedName1")
										thisAbbreviatedName2 = rsMajorMatchups("AbbreviatedName2")
										thisProfileImage1 = rsMajorMatchups("ProfileImage1")
										thisProfileImage2 = rsMajorMatchups("ProfileImage2")
										thisTeamScore1 = rsMajorMatchups("TeamScore1")
										thisTeamScore2 = rsMajorMatchups("TeamScore2")
										thisTeamPMR1 = rsMajorMatchups("TeamPMR1")
										thisTeamPMR2 = rsMajorMatchups("TeamPMR2")
%>
										<div class="col-12 col-xxl-6">
											<a href="/scores/<%= thisMatchupID %>/" style="text-decoration: none; display: block;">
												<ul class="list-group mb-2" id="matchup-<%= MatchupID %>">
													<li class="list-group-item team-slffl-box-<%= TeamID1 %>">
														<span class="team-slffl-score-<%= TeamID1 %>" style="float: right; font-weight: bold;"><%= thisTeamScore1 %></span>
														<span><%= thisAbbreviatedName1 %></span>
													</li>
													<li class="list-group-item team-slffl-box-<%= TeamID2 %>">
														<span class="team-slffl-score-<%= TeamID2 %>" style="float: right; font-weight: bold;"><%= thisTeamScore2 %></span>
														<span><%= thisAbbreviatedName2 %></span>
													</li>
												</ul>
											</a>
										</div>
<%
										rsMajorMatchups.MoveNext

									Loop

									rsMajorMatchups.Close
									Set rsMajorMatchups = Nothing
%>
									<div class="col-12 mt-3">

										<div class="card">

											<div class="card-body p-0">

												<table class="table mb-1 rounded">
													<thead>
														<tr>
															<th class="pl-3"><b><%= thisMajorTitle %> QUALIFYING</b></th>
															<th class="text-center">W-L-T</th>
															<th class="text-center d-none d-sm-table-cell">PF</th>
															<th class="text-center d-none d-sm-table-cell">PA</th>
														</tr>
													</thead>
													<tbody>
<%
														sqlGetMajorTwo = "SELECT Levels.Title, Teams.TeamName, SUM([ActualWins]) AS WinTotal, SUM([ActualLosses]) AS LossTotal, SUM([ActualTies]) AS TieTotal, SUM([PointsScored]) AS PointsScored, SUM([PointsAgainst]) AS PointsAgainst, SUM([BreakdownWins]) AS BreakdownWins, SUM([BreakdownLosses]) AS BreakdownLosses, SUM([BreakdownTies]) AS BreakdownTies, CAST(AVG([Position]) AS DECIMAL(10,2)) AS AveragePositionYTD, "
														sqlGetMajorTwo = sqlGetMajorTwo & "(SELECT ProfileImage FROM Accounts WHERE Accounts.AccountID IN (SELECT AccountID FROM LinkAccountsTeams WHERE LinkAccountsTeams.TeamID = Standings.TeamID)) AS ProfileImage FROM Standings "
														sqlGetMajorTwo = sqlGetMajorTwo & "INNER JOIN Teams ON Teams.TeamID = Standings.TeamID "
														sqlGetMajorTwo = sqlGetMajorTwo & "INNER JOIN Levels ON Levels.LevelID = Standings.LevelID "
														sqlGetMajorTwo = sqlGetMajorTwo & "WHERE Levels.LevelID = " & thisLevelID & " "
														sqlGetMajorTwo = sqlGetMajorTwo & "AND Standings.Year = 2024 "
														sqlGetMajorTwo = sqlGetMajorTwo & "AND Standings.Period >= 1 "
														sqlGetMajorTwo = sqlGetMajorTwo & "AND Standings.Period <= 3 "
														sqlGetMajorTwo = sqlGetMajorTwo & "GROUP BY Levels.LevelID, Levels.Title, Teams.TeamName, Standings.TeamID ORDER BY Levels.LevelID ASC, WinTotal DESC, PointsScored DESC; "

														Set rsStandings = sqlDatabase.Execute(sqlGetMajorTwo)

														thisPosition = 1
														Do While Not rsStandings.Eof
															thisTeamName = rsStandings("TeamName")
															If thisTeamName = "The District of Columbia(n) Neckties" Then thisTeamName = "DC Neckties"
%>
															<tr style="<%= thisBorderBottom %>">
																<td class="pl-3"><img src="https://samelevel.imgix.net/<%= rsStandings("ProfileImage") %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline mr-2"><b><%= thisPosition %>.</b> &nbsp;<%= thisTeamName %></td>
																<td class="text-center"><%= rsStandings("WinTotal") %>-<%= rsStandings("LossTotal") %>-<%= rsStandings("TieTotal") %></td>
																<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(rsStandings("PointsScored"), 2) %></td>
																<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(rsStandings("PointsAgainst"), 2) %></td>
															</tr>
<%
															rsStandings.MoveNext
															thisPosition = thisPosition + 1

														Loop

														rsStandings.Close
														Set rsStandings = Nothing
%>
													</tbody>

												</table>

											</div>

										</div>

									</div>

								</div>

							</div>
<%
							rsMajors.MoveNext

						Loop

						rsMajors.Close
						Set rsMajors = Nothing
%>

					</div>

					<div class="row mb-0 pb-0">

						<div class="col-6 pb-0 mb-0">
							<div class="accordion" id="accordion">

								<div class="card-header bg-warning text-white py-2 rounded mb-1" id="heading">
									<a href="#" data-toggle="collapse" data-target="#collapse" aria-expanded="true" aria-controls="collapse">
									<h5 class="mb-0 text-white float-left">MAJOR EVENTS</h5>
									<button class="btn text-white float-right"><span class="dripicons-information"></span></button>
									<div class="clearfix"></div>
									</a>
								</div>

								<div class="card rounded">
									<div id="collapse" class="collapse" aria-labelledby="heading" data-parent="#accordion">
										<div class="card-body text-dark">
											<div class="mb-3">Typical fantasy leagues set a regular-season schedule and simply hope things shake out fairly. LOL allows the season to schedule itself depending on team performance.</div>
											<div class="mb-3">Only weeks <b>01 - 03</b> and <b>08 - 10</b> are set before the season begins and act as qualifying windows for our two Major Events. Qualifying results dynamically set the schedule the following four weeks. The top-six teams qualify for the Major and compete in a round-robin style tournament. Teams that don't qualify are scheduled primarily against each other with some overlap (5/8 in group, 3/8 out) against the top-six.</div>
											<div>Major Champions are awarded <b>10,000 schmeckles</b> and a ticket to the <b>Omega Level</b>.</div>
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
