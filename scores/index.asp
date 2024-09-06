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

		<title>Live Scoring / Week <%= Session.Contents("CurrentPeriod") %> / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/scores/" />
		<meta property="og:title" content="Live Scoring / Week <%= Session.Contents("CurrentPeriod") %> / League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/scores/" />
		<meta name="twitter:title" content="Live Scoring / Week <%= Session.Contents("CurrentPeriod") %> / League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="Live Scoring / Week <%= Session.Contents("CurrentPeriod") %> / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/scores/" />

		<link href="/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/icons.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/style.css?version=3" rel="stylesheet" type="text/css" />
		<style>
			.box-glow { animation-name: glow; animation-duration: .5s; }
			@keyframes glow { 0% { box-shadow: 0px 0px 15px 10px rgba(255, 186, 8, 1); } 100% { box-shadow: 0px 0px 0px 0px rgba(255, 186, 8, 1); } }
		</style>

	</head>

	<body>

		<!--#include virtual="/assets/asp/framework/topbar.asp" -->

		<div class="page-wrapper">

			<!--#include virtual="/assets/asp/framework/nav.asp" -->

			<div class="page-content">

				<div class="container-fluid pl-0 pl-lg-2 pr-0 pr-lg-2">
<%
					If CInt(Session.Contents("CurrentPeriod")) < 18 Then

						'sqlGetSLFFLTotal = "SELECT (sum([TeamScore1]) + sum([TeamScore2]))/2 AS LevelTotal FROM [dbo].[Matchups] WHERE year =2022 and period=6 and levelid=2"
						sqlGetTopScore = "SELECT TOP 1 TeamName, Score FROM (SELECT A.TeamName, A.Score FROM (SELECT TOP 1 TeamScore1 AS Score, TeamID1 AS TeamID, Teams.TeamName FROM Matchups INNER JOIN Teams ON Teams.TeamID = TeamID1 WHERE Year = " & Session.Contents("CurrentYear") & " and Period = " & Session.Contents("CurrentPeriod") & " and Matchups.LevelID <> 1 ORDER BY TeamScore1 DESC) A "
						sqlGetTopScore = sqlGetTopScore & "UNION ALL "
						sqlGetTopScore = sqlGetTopScore & "SELECT B.TeamName, B.Score FROM (SELECT TOP 1 TeamScore2 AS Score, TeamID2 AS TeamID, Teams.TeamName FROM Matchups INNER JOIN Teams ON Teams.TeamID = TeamID2 WHERE Year = " & Session.Contents("CurrentYear") & " and Period = " & Session.Contents("CurrentPeriod") & " and Matchups.LevelID <> 1 ORDER BY TeamScore2 DESC) B) Scores ORDER BY Score DESC; "

						sqlMatchups = sqlGetTopScore & "SELECT Matchups.MatchupID, Matchups.LevelID, Matchups.TeamID1, Teams1.TeamName AS TeamName1, Accounts1.ProfileImage AS Logo1, Teams1.CBSID AS CBSID1, Matchups.TeamID2, Teams2.TeamName, Accounts2.ProfileImage AS Logo2, Teams2.CBSID AS CBSID2, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.TeamPMR1, Matchups.TeamPMR2, Teams1.AbbreviatedName, Teams2.AbbreviatedName, Matchups.TeamOmegaTravel1, Matchups.TeamOmegaTravel2 FROM Matchups INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 INNER JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Teams1.TeamID INNER JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Teams2.TeamID INNER JOIN Accounts AS Accounts1 ON Accounts1.AccountID = Link1.AccountID INNER JOIN Accounts AS Accounts2 ON Accounts2.AccountID = Link2.AccountID WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND Matchups.LevelID = 1 ORDER BY MatchupID;"

						sqlMatchups = sqlMatchups & "SELECT Matchups.MatchupID, Matchups.LevelID, Matchups.TeamID1, Teams1.TeamName AS TeamName1, Accounts1.ProfileImage AS Logo1, Teams1.CBSID AS CBSID1, Matchups.TeamID2, Teams2.TeamName, Accounts2.ProfileImage AS Logo2, Teams2.CBSID, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.TeamPMR1, Matchups.TeamPMR2, Matchups.Leg, Teams1.AbbreviatedName, Teams2.AbbreviatedName FROM Matchups INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 INNER JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Teams1.TeamID INNER JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Teams2.TeamID INNER JOIN Accounts AS Accounts1 ON Accounts1.AccountID = Link1.AccountID INNER JOIN Accounts AS Accounts2 ON Accounts2.AccountID = Link2.AccountID WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND Matchups.LevelID = 0 ORDER BY MatchupID;"

						sqlMatchups = sqlMatchups & "SELECT Matchups.MatchupID, Matchups.LevelID, Matchups.TeamID1, Teams1.TeamName AS TeamName1, Accounts1.ProfileImage AS Logo1, Teams1.CBSID AS CBSID1, Matchups.TeamID2, Teams2.TeamName, Accounts2.ProfileImage AS Logo2, Teams2.CBSID AS CBSID2, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.TeamPMR1, Matchups.TeamPMR2, Matchups.IsPlayoffs, Matchups.IsMajor, Power1.PowerPoints_Total + Power2.PowerPoints_Total AS PowerMatchup, Power1.PowerPoints_Total AS PowerPoints1, Power2.PowerPoints_Total AS PowerPoints2, Teams1.AbbreviatedName, Teams2.AbbreviatedName FROM Matchups INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 LEFT JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Teams1.TeamID LEFT JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Teams2.TeamID INNER JOIN Accounts AS Accounts1 ON Accounts1.AccountID = Link1.AccountID LEFT JOIN Accounts AS Accounts2 ON Accounts2.AccountID = Link2.AccountID LEFT JOIN PowerRankings AS Power1 ON Power1.TeamID = Teams1.TeamID LEFT JOIN PowerRankings AS Power2 ON Power2.TeamID = Teams2.TeamID WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND Matchups.LevelID = 2 ORDER BY (Power1.PowerPoints_Total + Power2.PowerPoints_Total) DESC;"

						sqlMatchups = sqlMatchups & "SELECT Matchups.MatchupID, Matchups.LevelID, Matchups.TeamID1, Teams1.TeamName AS TeamName1, Accounts1.ProfileImage AS Logo1, Teams1.CBSID AS CBSID1, Matchups.TeamID2, Teams2.TeamName, Accounts2.ProfileImage AS Logo2, Teams2.CBSID AS CBSID2, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.TeamPMR1, Matchups.TeamPMR2, Matchups.IsPlayoffs, Matchups.IsMajor, Power1.PowerPoints_Total + Power2.PowerPoints_Total AS PowerMatchup, Power1.PowerPoints_Total AS PowerPoints1, Power2.PowerPoints_Total AS PowerPoints2, Teams1.AbbreviatedName, Teams2.AbbreviatedName FROM Matchups INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 LEFT JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Teams1.TeamID LEFT JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Teams2.TeamID INNER JOIN Accounts AS Accounts1 ON Accounts1.AccountID = Link1.AccountID LEFT JOIN Accounts AS Accounts2 ON Accounts2.AccountID = Link2.AccountID LEFT JOIN PowerRankings AS Power1 ON Power1.TeamID = Teams1.TeamID LEFT JOIN PowerRankings AS Power2 ON Power2.TeamID = Teams2.TeamID WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND Matchups.LevelID = 3 ORDER BY (Power1.PowerPoints_Total + Power2.PowerPoints_Total) DESC;"

						sqlMatchups = sqlMatchups & "SELECT Matchups.MatchupID, Matchups.LevelID, Matchups.TeamID1, Teams1.TeamName AS TeamName1, Accounts1.ProfileImage AS Logo1, Teams1.CBSID AS CBSID1, Matchups.TeamID2, Teams2.TeamName, Accounts2.ProfileImage AS Logo2, Teams2.CBSID AS CBSID2, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.TeamPMR1, Matchups.TeamPMR2, Matchups.IsPlayoffs, Matchups.IsMajor, Power1.PowerPoints_Total + Power2.PowerPoints_Total AS PowerMatchup, Power1.PowerPoints_Total AS PowerPoints1, Power2.PowerPoints_Total AS PowerPoints2, Teams1.AbbreviatedName, Teams2.AbbreviatedName FROM Matchups INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 LEFT JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Teams1.TeamID LEFT JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Teams2.TeamID INNER JOIN Accounts AS Accounts1 ON Accounts1.AccountID = Link1.AccountID LEFT JOIN Accounts AS Accounts2 ON Accounts2.AccountID = Link2.AccountID LEFT JOIN PowerRankings AS Power1 ON Power1.TeamID = Teams1.TeamID LEFT JOIN PowerRankings AS Power2 ON Power2.TeamID = Teams2.TeamID WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND Matchups.LevelID = 4 ORDER BY (Power1.PowerPoints_Total + Power2.PowerPoints_Total) DESC;"

						Set rsMatchups = sqlDatabase.Execute(sqlMatchups)

						If Not rsMatchups.Eof Then arrTopScore = rsMatchups.GetRows()
						Set rsMatchups = rsMatchups.NextRecordset()
						If Not rsMatchups.Eof Then arrOmega = rsMatchups.GetRows()
						Set rsMatchups = rsMatchups.NextRecordset()
						If Not rsMatchups.Eof Then arrCup = rsMatchups.GetRows()
						Set rsMatchups = rsMatchups.NextRecordset()
						If Not rsMatchups.Eof Then arrSLFFL = rsMatchups.GetRows()
						Set rsMatchups = rsMatchups.NextRecordset()
						If Not rsMatchups.Eof Then arrFLFFL = rsMatchups.GetRows()
						Set rsMatchups = rsMatchups.NextRecordset()
						If Not rsMatchups.Eof Then arrBLFFL = rsMatchups.GetRows()

						thisWeeklyMatchups = ""

						Response.Write("<div class=""row mt-3 mt-lg-4"">")

							Response.Write("<div class=""col-12 col-xl-4 col-xxxl-2 mb-3 pl-1 pr-1 pl-lg-3 pr-lg-0"">")
%>
								<div class="text-white bg-dark rounded">

									<div class="card-body pt-2 pb-1">

										<div>
											<h4 style="border-bottom: 1px solid;" class="mb-2 pb-2">LOL Live Scoring<span class="float-right d-none d-lg-inline"><i class="fas fa-football-ball"></i></span></h4>
										</div>
<%
										If arrTopScore(1,0) > 0 Then
%>
											<div style="padding-bottom: 3px;">(Week <%= Session.Contents("CurrentPeriod") %>) Highest Score</div>
											<div class="pb-2"><span><b><%= arrTopScore(0,0) %></b> (<%= arrTopScore(1,0) %>)</span></div>
<%
										Else
%>
											<div style="padding-bottom: 3px;">(Week <%= Session.Contents("CurrentPeriod") %>) Highest Score</div>
											<div class="pb-2"><span><b>TBD</b>&nbsp;</span></div>
<%
										End If
%>
									</div>

								</div>
<%
							Response.Write("</div>")

							If IsArray(arrOmega) Then

								For i = 0 To UBound(arrOmega, 2)

									MatchupID = arrOmega(0, i)
									TeamID1 = arrOmega(2, i)
									TeamName1 = arrOmega(3, i)
									TeamLogo1 = arrOmega(4, i)
									TeamCBSID1 = arrOmega(5, i)
									TeamID2 = arrOmega(6, i)
									TeamName2 = arrOmega(7, i)
									TeamLogo2 = arrOmega(8, i)
									TeamCBSID2 = arrOmega(9, i)
									TeamScore1 = FormatNumber(arrOmega(10, i) + arrOmega(16, i), 2)
									TeamScore2 = FormatNumber(arrOmega(11, i) + arrOmega(17, i), 2)
									TeamPMR1 = arrOmega(12, i)
									TeamPMR2 = arrOmega(13, i)
									TeamAbbreviatedName1 = arrOmega(14, i)
									TeamAbbreviatedName2 = arrOmega(15, i)
									TeamOmegaTravel1 = arrOmega(16, i)
									TeamOmegaTravel2 = arrOmega(17, i)

									thisWeeklyMatchups = thisWeeklyMatchups & MatchupID & ","

									TeamPMRColor1 = "success"
									TeamPMRPercent1 = (TeamPMR1 * 100) / 420
									If TeamPMRPercent1 < 66.66 Then TeamPMRColor1 = "warning"
									If TeamPMRPercent1 < 33.33 Then TeamPMRColor1 = "danger"

									TeamPMRColor2 = "success"
									TeamPMRPercent2 = (TeamPMR2 * 100) / 420
									If TeamPMRPercent2 < 66.66 Then TeamPMRColor2 = "warning"
									If TeamPMRPercent2 < 33.33 Then TeamPMRColor2 = "danger"

									If MatchupID = 4403 Then MatchupTitle = "OMEGA CHAMPIONSHIP"
									If MatchupID = 4404 Then MatchupTitle = "OMEGA 3RD PLACE"
									If MatchupID = 4405 Then MatchupTitle = "OMEGA 5TH PLACE"

									Response.Write("<div class=""col-6 col-xl-4 col-xxxl-2 pl-1 pr-1 pl-lg-3 pr-lg-0"">")
%>
										<a href="/scores/<%= MatchupID %>/" class="matchup-<%= MatchupID %>" style="text-decoration: none; display: block;">
											<ul class="list-group" style="margin-bottom: 1rem;">
												<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #FFBA08; color: #fff;"><strong><%= MatchupTitle %></strong></li>
												<li class="list-group-item px-3 team-omega-box-<%= TeamID1 %>">
													<span class="team-omega-score-<%= TeamID1 %>" style="font-size: 1em; background-color: #fff; color: #805C04; float: right;"><%= TeamScore1 %></span>
													<img src="https://samelevel.imgix.net/<%= TeamLogo1 %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #805C04;"><%= TeamName1 %></span><span class="d-inline d-lg-none" style="font-size: 13px; color: #805C04;"><%= TeamAbbreviatedName1 %></span><% If TeamOmegaTravel1 <> 0 Then %><span style="font-size: 13px; color: #805C04;"> (<%= TeamOmegaTravel1 %>)</span><% End If %>
													<div class="progress team-omega-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
														<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
															<span class="sr-only team-omega-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
														</div>
													</div>
												</li>
												<li class="list-group-item px-3 team-omega-box-<%= TeamID2 %>">
													<span class="team-omega-score-<%= TeamID2 %>" style="font-size: 1em; background-color: #fff; color: #805C04; float: right;"><%= TeamScore2 %></span>
													<img src="https://samelevel.imgix.net/<%= TeamLogo2 %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #805C04;"><%= TeamName2 %></span><span class="d-inline d-lg-none" style="font-size: 13px; color: #805C04;"><%= TeamAbbreviatedName2 %></span>
													<div class="progress team-omega-progress-<%= TeamID2 %>" style="height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;">
														<div class="progress-bar progress-bar-<%= TeamPMRColor2 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent2 %>" aria-valuemin="0" aria-valuemax="<%= TeamPMRPercent2 %>" style="width: <%= TeamPMRPercent2 %>%">
															<span class="sr-only team-omega-progress-sr-<%= TeamID2 %>"><%= TeamPMRPercent2 %>%</span>
														</div>
													</div>
												</li>
											</ul>
										</a>
<%
									Response.Write("</div>")

								Next

							End If

							Response.Write("</div>")

							Response.Write("<div class=""row"">")

							If IsArray(arrCup) Then

								For i = 0 To UBound(arrCup, 2)

									MatchupID = arrCup(0, i)
									TeamID1 = arrCup(2, i)
									TeamName1 = arrCup(3, i)
									TeamLogo1 = arrCup(4, i)
									TeamCBSID1 = arrCup(5, i)
									TeamID2 = arrCup(6, i)
									TeamName2 = arrCup(7, i)
									TeamLogo2 = arrCup(8, i)
									TeamCBSID2 = arrCup(9, i)
									TeamScore1 = FormatNumber(arrCup(10, i), 2)
									TeamScore2 = FormatNumber(arrCup(11, i), 2)
									TeamPMR1 = arrCup(12, i)
									TeamPMR2 = arrCup(13, i)
									Leg = arrCup(14, i)
									TeamAbbreviatedName1 = arrCup(15, i)
									TeamAbbreviatedName2 = arrCup(16, i)
									BaseScore1 = 0
									BaseScore2 = 0

									thisWeeklyMatchups = thisWeeklyMatchups & MatchupID & ","

									If CInt(Leg) = 2 Then

										sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & TeamID1 & " OR TeamID2 = " & TeamID1 & ") AND LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") - 1
										Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

										If CInt(rsLastWeek("TeamID1")) = CInt(TeamID1) Then BaseScore1 = rsLastWeek("TeamScore1")
										If CInt(rsLastWeek("TeamID2")) = CInt(TeamID1) Then BaseScore1 = rsLastWeek("TeamScore2")

										rsLastWeek.Close
										Set rsLastWeek = Nothing

										sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & TeamID2 & " OR TeamID2 = " & TeamID2 & ") AND LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") - 1
										Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

										If CInt(rsLastWeek("TeamID1")) = CInt(TeamID2) Then BaseScore2 = rsLastWeek("TeamScore1")
										If CInt(rsLastWeek("TeamID2")) = CInt(TeamID2) Then BaseScore2 = rsLastWeek("TeamScore2")

										rsLastWeek.Close
										Set rsLastWeek = Nothing


									End If

									If CInt(Leg) = 3 Then

										sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & TeamID1 & " OR TeamID2 = " & TeamID1 & ") AND LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period >= " & Session.Contents("CurrentPeriod") - 2 & " AND Period <= " & Session.Contents("CurrentPeriod") - 1
										Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

										Do While Not rsLastWeek.Eof
											If CInt(rsLastWeek("TeamID1")) = CInt(TeamID1) Then BaseScore1 = BaseScore1 + rsLastWeek("TeamScore1")
											If CInt(rsLastWeek("TeamID2")) = CInt(TeamID1) Then BaseScore1 = BaseScore1 + rsLastWeek("TeamScore2")
											rsLastWeek.MoveNext
										Loop

										rsLastWeek.Close
										Set rsLastWeek = Nothing

										sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & TeamID2 & " OR TeamID2 = " & TeamID2 & ") AND LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period >= " & Session.Contents("CurrentPeriod") - 2 & " AND Period <= " & Session.Contents("CurrentPeriod") - 1
										Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

										Do While Not rsLastWeek.Eof
											If CInt(rsLastWeek("TeamID1")) = CInt(TeamID2) Then BaseScore2 = BaseScore2 + rsLastWeek("TeamScore1")
											If CInt(rsLastWeek("TeamID2")) = CInt(TeamID2) Then BaseScore2 = BaseScore2 + rsLastWeek("TeamScore2")
											rsLastWeek.MoveNext
										Loop

										rsLastWeek.Close
										Set rsLastWeek = Nothing


									End If

									TeamScore1 = FormatNumber(TeamScore1 + BaseScore1, 2)
									TeamScore2 = FormatNumber(TeamScore2 + BaseScore2, 2)

									TeamPMRColor1 = "success"
									TeamPMRPercent1 = (TeamPMR1 * 100) / 420
									If TeamPMRPercent1 < 66.66 Then TeamPMRColor1 = "warning"
									If TeamPMRPercent1 < 33.33 Then TeamPMRColor1 = "danger"

									TeamPMRColor2 = "success"
									TeamPMRPercent2 = (TeamPMR2 * 100) / 420
									If TeamPMRPercent2 < 66.66 Then TeamPMRColor2 = "warning"
									If TeamPMRPercent2 < 33.33 Then TeamPMRColor2 = "danger"

									If TeamID1 = 38 Then TeamName1 = "München"
									If TeamID2 = 38 Then TeamName2 = "München"

									If TeamID1 = 36 Then TeamName1 = "Hanging With Hern"
									If TeamID2 = 36 Then TeamName2 = "Hanging With Hern"

									If TeamID1 = 59 Then TeamName1 = "Filthy Animals"
									If TeamID2 = 59 Then TeamName2 = "Filthy Animals"
%>
									<div class="col-6 col-xl-4 col-xxl-3 col-xxxl-2 pl-1 pr-1 pl-lg-3 pr-lg-0">
										<a href="/scores/<%= MatchupID %>/" class="matchup-<%= MatchupID %>" style="text-decoration: none; display: block;">
											<ul class="list-group" style="margin-bottom: 1rem;">
												<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #D00000; color: #fff;"></li>
												<li class="list-group-item px-3 team-cup-box-<%= TeamID1 %>">
													<span class="team-cup-score-<%= TeamID1 %>" style="font-size: 1em; background-color: #fff; color: #520000; float: right;"><%= TeamScore1 %></span>
													<img src="https://samelevel.imgix.net/<%= TeamLogo1 %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #520000;"><%= TeamAbbreviatedName1 %></span><span class="d-inline d-lg-none" style="font-size: 13px; color: #520000;"><%= TeamAbbreviatedName1 %></span>
													<div class="progress team-cup-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
														<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
															<span class="sr-only team-cup-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
														</div>
													</div>
												</li>
												<li class="list-group-item px-3 team-cup-box-<%= TeamID2 %>">
													<span class="team-cup-score-<%= TeamID2 %>" style="font-size: 1em; background-color: #fff; color: #520000; float: right;"><%= TeamScore2 %></span>
													<img src="https://samelevel.imgix.net/<%= TeamLogo2 %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #520000;"><%= TeamAbbreviatedName2 %></span><span class="d-inline d-lg-none" style="font-size: 13px; color: #520000;"><%= TeamAbbreviatedName2 %></span>
													<div class="progress team-cup-progress-<%= TeamID2 %>" style="height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;">
														<div class="progress-bar progress-bar-<%= TeamPMRColor2 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent2 %>" aria-valuemin="0" aria-valuemax="<%= TeamPMRPercent2 %>" style="width: <%= TeamPMRPercent2 %>%">
															<span class="sr-only team-cup-progress-sr-<%= TeamID2 %>"><%= TeamPMRPercent2 %>%</span>
														</div>
													</div>
												</li>
											</ul>
										</a>
									</div>
<%
								Next

								'Response.Write("<div class=""col-12 col-xl-4 col-xxxl-3 pl-1 pr-1 pl-lg-3 pr-lg-0""></div>")
							End If

						Response.Write("</div>")

									If IsArray(arrSLFFL) Then

										Response.Write("<div class=""row"">")

										For i = 0 To UBound(arrSLFFL, 2)

											MatchupID = arrSLFFL(0, i)
											TeamID1 = arrSLFFL(2, i)
											TeamName1 = arrSLFFL(3, i)
											TeamLogo1 = arrSLFFL(4, i)
											TeamCBSID1 = arrSLFFL(5, i)
											TeamID2 = arrSLFFL(6, i)
											TeamName2 = arrSLFFL(7, i)
											TeamLogo2 = arrSLFFL(8, i)
											TeamCBSID2 = arrSLFFL(9, i)
											TeamScore1 = FormatNumber(arrSLFFL(10, i), 2)
											TeamScore2 = FormatNumber(arrSLFFL(11, i), 2)
											TeamPMR1 = arrSLFFL(12, i)
											TeamPMR2 = arrSLFFL(13, i)
											IsPlayoffs = arrSLFFL(14, i)
											IsMajor = arrSLFFL(15, i)
											MatchupPower = arrSLFFL(16, i)
											TeamAbbreviatedName1 = arrSLFFL(19, i)
											TeamAbbreviatedName2 = arrSLFFL(20, i)

											thisWeeklyMatchups = thisWeeklyMatchups & MatchupID & ","

											TeamPMRColor1 = "success"
											TeamPMRPercent1 = (TeamPMR1 * 100) / 420
											If TeamPMRPercent1 < 66.66 Then TeamPMRColor1 = "warning"
											If TeamPMRPercent1 < 33.33 Then TeamPMRColor1 = "danger"

											TeamPMRColor2 = "success"
											TeamPMRPercent2 = (TeamPMR2 * 100) / 420
											If TeamPMRPercent2 < 66.66 Then TeamPMRColor2 = "warning"
											If TeamPMRPercent2 < 33.33 Then TeamPMRColor2 = "danger"

											If MatchupID = 4406 Then MatchupTitle = "SLFFL CHAMPIONSHIP"
											If MatchupID = 4407 Then MatchupTitle = "SLFFL 3RD PLACE"
											If MatchupID = 4408 Then MatchupTitle = "SLFFL SECOND-CHANCE"
											If MatchupID = 4409 Then MatchupTitle = "SLFFL 7TH PLACE"
											If MatchupID = 4410 Then MatchupTitle = "SLFFL 9TH PLACE"
											If MatchupID = 4411 Then MatchupTitle = "SLFFL AOL FINAL"

											MatchupURL = "/scores/" & MatchupID & "/"

											MajorText = ""
											If IsMajor Then MajorText = "<span class=""badge badge-pill badge-warning"" title=""Major Matchup""><i class=""fa fa-star-of-life p-1""></i></span>"

											Response.Write("<div class=""col-6 col-xl-4 col-xxl-3 col-xxxl-2 pl-1 pr-1 pl-lg-3 pr-lg-0"">")
%>
												<a href="<%= MatchupURL %>" class="matchup-<%= MatchupID %>" style="text-decoration: none; display: block;">
													<ul class="list-group" style="margin-bottom: 1rem;">
														<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #136F63; color: #fff;"><strong><%= MatchupTitle %></strong></li>
														<li class="list-group-item team-slffl-box-<%= TeamID1 %>" style="position: relative;">
															<div style="position: absolute; top: -18px; right: -10px;"><%= MajorText %></div>
															<span class="team-slffl-score-<%= TeamID1 %>" style="font-size: 1em; background-color: #fff; color: #0F574D; float: right;"><%= TeamScore1 %></span>
															<img src="https://samelevel.imgix.net/<%= TeamLogo1 %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #0F574D;"><%= TeamName1 %></span><span class="d-inline d-lg-none" style="font-size: 13px; color: #0F574D;"><%= TeamAbbreviatedName1 %></span>
															<div class="progress team-slffl-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
																<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
																	<span class="sr-only team-slffl-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
																</div>
															</div>
														</li>
														<li class="list-group-item team-slffl-box-<%= TeamID2 %>">
															<span class="team-slffl-score-<%= TeamID2 %>" style="font-size: 1em; background-color: #fff; color: #0F574D; float: right;"><%= TeamScore2 %></span>
<%
															If TeamID2 = 99999 Then
%>
																<img src="https://samelevel.imgix.net/slffl-gold-icon.png?w=16&h=16" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #0F574D;">BYE</span><span class="d-inline d-lg-none" style="font-size: 13px; color: #0F574D;">BYE</span>
<%
															Else
%>
																<img src="https://samelevel.imgix.net/<%= TeamLogo2 %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #0F574D;"><%= TeamName2 %></span><span class="d-inline d-lg-none" style="font-size: 13px; color: #0F574D;"><%= TeamAbbreviatedName2 %></span>
<%
															End If
%>
															<div class="progress team-slffl-progress-<%= TeamID2 %>" style="height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;">
																<div class="progress-bar progress-bar-<%= TeamPMRColor2 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent2 %>" aria-valuemin="0" aria-valuemax="<%= TeamPMRPercent2 %>" style="width: <%= TeamPMRPercent2 %>%">
																	<span class="sr-only team-slffl-progress-sr-<%= TeamID2 %>"><%= TeamPMRPercent2 %>%</span>
																</div>
															</div>
														</li>
													</ul>
												</a>
<%
											Response.Write("</div>")

										Next

										Response.Write("</div>")

									End If


											If IsArray(arrFLFFL) Then
												Response.Write("<div class=""row"">")


												For i = 0 To UBound(arrFLFFL, 2)

													MatchupID = arrFLFFL(0, i)
													TeamID1 = arrFLFFL(2, i)
													TeamName1 = arrFLFFL(3, i)
													TeamLogo1 = arrFLFFL(4, i)
													TeamCBSID1 = arrFLFFL(5, i)
													TeamID2 = arrFLFFL(6, i)
													TeamName2 = arrFLFFL(7, i)
													TeamLogo2 = arrFLFFL(8, i)
													TeamCBSID2 = arrFLFFL(9, i)
													TeamScore1 = FormatNumber(arrFLFFL(10, i), 2)
													TeamScore2 = FormatNumber(arrFLFFL(11, i), 2)
													TeamPMR1 = arrFLFFL(12, i)
													TeamPMR2 = arrFLFFL(13, i)
													IsPlayoffs = arrFLFFL(14, i)
													IsMajor = arrFLFFL(15, i)
													TeamAbbreviatedName1 = arrFLFFL(19, i)
													TeamAbbreviatedName2 = arrFLFFL(20, i)

													thisWeeklyMatchups = thisWeeklyMatchups & MatchupID & ","

													TeamPMRColor1 = "success"
													TeamPMRPercent1 = (TeamPMR1 * 100) / 420
													If TeamPMRPercent1 < 66.66 Then TeamPMRColor1 = "warning"
													If TeamPMRPercent1 < 33.33 Then TeamPMRColor1 = "danger"

													TeamPMRColor2 = "success"
													TeamPMRPercent2 = (TeamPMR2 * 100) / 420
													If TeamPMRPercent2 < 66.66 Then TeamPMRColor2 = "warning"
													If TeamPMRPercent2 < 33.33 Then TeamPMRColor2 = "danger"

													If TeamID1 = 38 Then TeamName1 = "München"
													If TeamID2 = 38 Then TeamName2 = "München"

													If TeamID1 = 36 Then TeamName1 = "Hanging With Hern"
													If TeamID2 = 36 Then TeamName2 = "Hanging With Hern"

													If TeamID1 = 59 Then TeamName1 = "Filthy Animals"
													If TeamID2 = 59 Then TeamName2 = "Filthy Animals"

													MajorText = ""
													If IsMajor Then MajorText = "<span class=""badge badge-pill badge-warning"" title=""Major Matchup""><i class=""fa fa-star-of-life p-1""></i></span>"

													If MatchupID = 4412 Then MatchupTitle = "FARM CHAMPIONSHIP"
													If MatchupID = 4413 Then MatchupTitle = "FARM 3RD PLACE"
													If MatchupID = 4414 Then MatchupTitle = "FARM SECOND-CHANCE"
													If MatchupID = 4415 Then MatchupTitle = "FARM 7TH PLACE"
													If MatchupID = 4416 Then MatchupTitle = "FARM 9TH PLACE"
													If MatchupID = 4417 Then MatchupTitle = "FARM AOL FINAL"

													MatchupURL = "/scores/" & MatchupID & "/"

													Response.Write("<div class=""col-6 col-xl-4 col-xxl-3 col-xxxl-2 pl-1 pr-1 pl-lg-3 pr-lg-0"">")
%>
														<a href="<%= MatchupURL %>" class="matchup-<%= MatchupID %>" style="text-decoration: none; display: block;">
															<ul class="list-group" style="margin-bottom: 1rem;">
																<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #032B43; color: #fff;"><strong><%= MatchupTitle %></strong></li>
																<li class="list-group-item team-flffl-box-<%= TeamID1 %>" style="position: relative;">
																	<div style="position: absolute; top: -18px; right: -10px;"><%= MajorText %></div>
																	<span class="team-flffl-score-<%= TeamID1 %>" style="font-size: 1em; background-color: #fff; color: #0F574D; float: right;"><%= TeamScore1 %></span>
																	<img src="https://samelevel.imgix.net/<%= TeamLogo1 %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #0F574D;"><%= TeamName1 %></span><span class="d-inline d-lg-none" style="font-size: 13px; color: #0F574D;"><%= TeamAbbreviatedName1 %></span>
																	<div class="progress team-flffl-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
																		<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
																			<span class="sr-only team-flffl-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
																		</div>
																	</div>
																</li>
																<li class="list-group-item team-flffl-box-<%= TeamID2 %>">
																	<span class="team-flffl-score-<%= TeamID2 %>" style="font-size: 1em; background-color: #fff; color: #0F574D; float: right;"><%= TeamScore2 %></span>
<%
																	If TeamID2 = 99999 Then
%>
																		<img src="https://samelevel.imgix.net/flffl-logo-icon.png?w=16&h=16" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #0F574D;">BYE</span><span class="d-inline d-lg-none" style="font-size: 13px; color: #0F574D;">BYE</span>
<%
																	Else
%>
																		<img src="https://samelevel.imgix.net/<%= TeamLogo2 %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #0F574D;"><%= TeamName2 %></span><span class="d-inline d-lg-none" style="font-size: 13px; color: #0F574D;"><%= TeamAbbreviatedName2 %></span>
<%
																	End If
%>
																	<div class="progress team-flffl-progress-<%= TeamID2 %>" style="height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;">
																		<div class="progress-bar progress-bar-<%= TeamPMRColor2 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent2 %>" aria-valuemin="0" aria-valuemax="<%= TeamPMRPercent2 %>" style="width: <%= TeamPMRPercent2 %>%">
																			<span class="sr-only team-flffl-progress-sr-<%= TeamID2 %>"><%= TeamPMRPercent2 %>%</span>
																		</div>
																	</div>
																</li>
															</ul>
														</a>
		<%
													Response.Write("</div>")
												Next

												Response.Write("</div>")
											End If

											If IsArray(arrBLFFL) Then
	        Response.Write("<div class=""row"">")
	        For i = 0 To UBound(arrBLFFL, 2)
	            MatchupID = arrBLFFL(0, i)
	            TeamID1 = arrBLFFL(2, i)
	            TeamName1 = arrBLFFL(3, i)
	            TeamLogo1 = arrBLFFL(4, i)
	            TeamCBSID1 = arrBLFFL(5, i)
	            TeamID2 = arrBLFFL(6, i)
	            TeamName2 = arrBLFFL(7, i)
	            TeamLogo2 = arrBLFFL(8, i)
	            TeamCBSID2 = arrBLFFL(9, i)
	            TeamScore1 = FormatNumber(arrBLFFL(10, i), 2)
	            TeamScore2 = FormatNumber(arrBLFFL(11, i), 2)
	            TeamPMR1 = arrBLFFL(12, i)
	            TeamPMR2 = arrBLFFL(13, i)
				IsPlayoffs = arrBLFFL(14, i)
				IsMajor = arrBLFFL(15, i)
				TeamAbbreviatedName1 = arrBLFFL(19, i)
				TeamAbbreviatedName2 = arrBLFFL(20, i)
				MatchupURL = "/scores/" & MatchupID & "/"
	            ' Display matchups for BLFFL
	            Response.Write("<div class=""col-6 col-xl-4 col-xxl-3 col-xxxl-2 pl-1 pr-1 pl-lg-3 pr-lg-0"">")
%>
<a href="<%= MatchupURL %>" class="matchup-<%= MatchupID %>" style="text-decoration: none; display: block;">
<ul class="list-group" style="margin-bottom: 1rem;">
	<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #4A90E2; color: #fff;"><strong><%= MatchupTitle %></strong></li>
	<li class="list-group-item team-blffl-box-<%= TeamID1 %>" style="position: relative;">
		<div style="position: absolute; top: -18px; right: -10px;"><%= MajorText %></div>
		<span class="team-blffl-score-<%= TeamID1 %>" style="font-size: 1em; background-color: #fff; color: #003366; float: right;"><%= TeamScore1 %></span>
		<img src="https://samelevel.imgix.net/<%= TeamLogo1 %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #003366;"><%= TeamAbbreviatedName1 %></span><span class="d-inline d-lg-none" style="font-size: 13px; color: #003366;"><%= TeamAbbreviatedName1 %></span>
		<div class="progress team-blffl-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
			<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
				<span class="sr-only team-blffl-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
			</div>
		</div>
	</li>
	<li class="list-group-item team-blffl-box-<%= TeamID2 %>">
		<span class="team-blffl-score-<%= TeamID2 %>" style="font-size: 1em; background-color: #fff; color: #003366; float: right;"><%= TeamScore2 %></span>
		<%
			If TeamID2 = 99999 Then
		%>
			<img src="https://samelevel.imgix.net/blffl-logo-icon.png?w=16&h=16" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #003366;">BYE</span><span class="d-inline d-lg-none" style="font-size: 13px; color: #003366;">BYE</span>
		<%
			Else
		%>
			<img src="https://samelevel.imgix.net/<%= TeamLogo2 %>?w=16&h=16&fit=crop&crop=focalpoint" class="rounded-circle d-none d-lg-inline mr-2" /><span class="d-none d-lg-inline" style="font-size: 13px; color: #003366;"><%= TeamAbbreviatedName2 %></span><span class="d-inline d-lg-none" style="font-size: 13px; color: #003366;"><%= TeamAbbreviatedName2 %></span>
		<%
			End If
		%>
		<div class="progress team-blffl-progress-<%= TeamID2 %>" style="height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;">
			<div class="progress-bar progress-bar-<%= TeamPMRColor2 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent2 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent2 %>%">
				<span class="sr-only team-blffl-progress-sr-<%= TeamID2 %>"><%= TeamPMRPercent2 %>%</span>
			</div>
		</div>
	</li>
</ul>
</a>

<%
	            Response.Write("</div>")
	        Next
	        Response.Write("</div>")
	    End If

%>

<%
					Else
%>
						<div class="row">

							<div class="col-12">Go home and rest. The season is over.</div>

						</div>
<%
					End If

					If Right(thisWeeklyMatchups, 1) = "," Then thisWeeklyMatchups = Left(thisWeeklyMatchups, Len(thisWeeklyMatchups)-1)
%>
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

		<script src="/assets/plugins/countUp/countUp.min.js" type="text/javascript"></script>
		<script src="/assets/plugins/howler/howler.min.js" type="text/javascript"></script>

		<!--#include virtual="/assets/js/scores.asp"-->

	</body>

</html>
