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

		<title>Major One / Qualifying & Standings / League of Levels</title>

		<meta name="description" content="Major One represents the top-six teams from each level through the first three weeks, respectively. These teams are then squared off against each other in a four-week round-robin tournament with 10,000 schmeckles up for grabs." />

		<meta property="og:site_name" content="League of Levels" />
		<meta property="og:url" content="https://www.leagueoflevels.com/majors/" />
		<meta property="og:title" content="Major One / Qualifying & Standings / League of Levels" />
		<meta property="og:description" content="Major One represents the top-six teams from each level through the first three weeks, respectively. These teams are then squared off against each other in a four-week round-robin tournament with 10,000 schmeckles up for grabs." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/majors/" />
		<meta name="twitter:title" content="Major One / Qualifying & Standings / League of Levels" />
		<meta name="twitter:description" content="Major One represents the top-six teams from each level through the first three weeks, respectively. These teams are then squared off against each other in a four-week round-robin tournament with 10,000 schmeckles up for grabs." />

		<meta name="title" content="Major One / Qualifying & Standings / League of Levels" />
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

				<div class="container-fluid">

					<div class="row mt-4">

						<div class="col-12 col-xl-4">
<%
							sqlGetMajors = "SELECT MajorID, Majors.LevelID, Levels.Title, MajorTitle FROM Majors INNER JOIN Levels ON Levels.LevelID = Majors.LevelID WHERE StartPeriod >= 4 ORDER BY LevelID ASC"
							Set rsMajors = sqlDatabase.Execute(sqlGetMajors)

							Do While Not rsMajors.Eof

								thisMajorTitle = UCase(rsMajors("Title") & " " & rsMajors("MajorTitle"))
								thisMajorID = rsMajors("MajorID")
								thisLevelID = rsMajors("LevelID")
%>
								<div class="card">

									<div class="card-body p-0">

										<table class="table mb-1">
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
												sqlGetStandings = "SELECT MajorStandingsID, MajorID, MajorStandings.LevelID, Year, MajorStandings.TeamID, Accounts.ProfileName, Accounts.ProfileImage, SUM(ActualWins) AS TotalWins, SUM(ActualLosses) AS TotalLosses, SUM(ActualTies) AS TotalTies, SUM(PointsScored) AS TotalPointsScored, SUM(PointsAgainst) AS TotalPointsAllowed "
												sqlGetStandings = sqlGetStandings & "FROM MajorStandings "
												sqlGetStandings = sqlGetStandings & "INNER JOIN Teams ON Teams.TeamID = MajorStandings.TeamID "
												sqlGetStandings = sqlGetStandings & "INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = MajorStandings.TeamID "
												sqlGetStandings = sqlGetStandings & "INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID "
												sqlGetStandings = sqlGetStandings & "WHERE MajorStandings.LevelID = " & thisLevelID & " And MajorStandings.MajorID = " & thisMajorID & " "
												sqlGetStandings = sqlGetStandings & "GROUP BY MajorStandingsID, MajorID, MajorStandings.LevelID, Year, MajorStandings.TeamID, Accounts.ProfileName, Accounts.ProfileImage "
												sqlGetStandings = sqlGetStandings & "ORDER BY TotalWins DESC, TotalPointsScored DESC, TotalLosses ASC"
												Set rsStandings = sqlDatabase.Execute(sqlGetStandings)

												thisPosition = 1
												Do While Not rsStandings.Eof
%>
													<tr style="<%= thisBorderBottom %>">
														<td class="pl-3"><img src="https://samelevel.imgix.net/<%= rsStandings("ProfileImage") %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline mr-1 pr-1"><b><%= thisPosition %>.</b> &nbsp;<%= rsStandings("ProfileName") %></td>
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
<%
								rsMajors.MoveNext

							Loop

							rsMajors.Close
							Set rsMajors = Nothing
%>
						</div>

						<div class="col-12 col-xl-8">

							<div class="row">
<%
								sqlGetMajorMatchups = "SELECT MatchupID, Matchups.LevelID, Year, Period, A1.ProfileName AS ProfileName1, A2.ProfileName AS ProfileName2, A1.ProfileImage AS ProfileImage1, A2.ProfileImage AS ProfileImage2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2 "
								sqlGetMajorMatchups = sqlGetMajorMatchups & "FROM Matchups "
								sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN Teams T1 ON T1.TeamID = Matchups.TeamID1 "
								sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN Teams T2 ON T2.TeamID = Matchups.TeamID2 "
								sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN LinkAccountsTeams L1 ON L1.TeamID = T1.TeamID "
								sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN LinkAccountsTeams L2 ON L2.TeamID = T2.TeamID "
								sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN Accounts A1 ON A1.AccountID = L1.AccountID "
								sqlGetMajorMatchups = sqlGetMajorMatchups & "INNER JOIN Accounts A2 ON A2.AccountID = L2.AccountID "
								sqlGetMajorMatchups = sqlGetMajorMatchups & "WHERE Year = 2021 AND (Period >= 4 AND Period <= 7) AND (Matchups.LevelID = 2 OR Matchups.LevelID = 3) AND IsMajor = 1 "
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
									thisProfileImage1 = rsMajorMatchups("ProfileImage1")
									thisProfileImage2 = rsMajorMatchups("ProfileImage2")
									thisTeamScore1 = rsMajorMatchups("TeamScore1")
									thisTeamScore2 = rsMajorMatchups("TeamScore2")
									thisTeamPMR1 = rsMajorMatchups("TeamPMR1")
									thisTeamPMR2 = rsMajorMatchups("TeamPMR2")

									TeamPMRColor1 = "success"
									If thisTeamPMR1 < 321 Then TeamPMRColor1 = "warning"
									If thisTeamPMR1 < 161 Then TeamPMRColor1 = "danger"
									TeamPMRPercent1 = (thisTeamPMR1 * 100) / 420

									TeamPMRColor2 = "success"
									If thisTeamPMR2 < 321 Then TeamPMRColor2 = "warning"
									If thisTeamPMR2 < 161 Then TeamPMRColor2 = "danger"
									TeamPMRPercent2 = (thisTeamPMR2 * 100) / 420

									If CInt(thisRunningPeriod) <> CInt(thisPeriod) Then
										thisRunningPeriod = thisPeriod
%>
										<div class="col-12">
											<ul class="list-group mb-3">
												<li class="list-group-item p-0">
													<h5 class="text-left text-white p-3 mt-0 mb-0 rounded" style="background-color: #032B43;"><b>PERIOD <%= thisRunningPeriod %> MAJOR MATCHUPS</b></h5>
												</li>
											</ul>
										</div>
<%
									End If
%>
									<div class="col-xxl-6 col-xl-12 col-lg-6 col-md-6 col-sm-12">
										<a style="text-decoration: none; display: block;">
											<ul class="list-group" id="matchup-<%= MatchupID %>" style="margin-bottom: 1rem;">
												<li class="list-group-item team-flffl-box-<%= TeamID1 %>" style="position: relative;">
													<span class="team-flffl-score-<%= TeamID1 %>" style="font-size: 1.25rem; line-height: 1.9rem; background-color: #fff; color: #03324F; float: right;"><%= thisTeamScore1 %></span>
													<img src="https://samelevel.imgix.net/<%= thisProfileImage1 %>?w=28&h=28&fit=crop&crop=focalpoint" width="28" height="28" style="margin-right: 0.2rem;" /> <span style="font-size: 15px; color: #03324F; line-height: 1.9rem;"><b><%= thisProfileName1 %></b></span>
													<div class="progress team-flffl-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
														<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
															<span class="sr-only team-flffl-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
														</div>
													</div>
												</li>
												<li class="list-group-item team-flffl-box-<%= TeamID2 %>">
													<span class="team-flffl-score-<%= TeamID2 %>" style="font-size: 1.25rem; line-height: 1.9rem; background-color: #fff; color: #03324F; float: right;"><%= thisTeamScore2 %></span>
													<img src="https://samelevel.imgix.net/<%= thisProfileImage2 %>?w=28&h=28&fit=crop&crop=focalpoint" width="28" height="28" style="margin-right: 0.2rem;" /> <span style="font-size: 15px; color: #03324F; line-height: 1.9rem;"><b><%= thisProfileName2 %></b></span>
													<div class="progress team-flffl-progress-<%= TeamID2 %>" style="height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;">
														<div class="progress-bar progress-bar-<%= TeamPMRColor2 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent2 %>" aria-valuemin="0" aria-valuemax="<%= TeamPMRPercent2 %>" style="width: <%= TeamPMRPercent2 %>%">
															<span class="sr-only team-flffl-progress-sr-<%= TeamID2 %>"><%= TeamPMRPercent2 %>%</span>
														</div>
													</div>
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
