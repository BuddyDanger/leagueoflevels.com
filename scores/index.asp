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

	</head>

	<body>

		<!--#include virtual="/assets/asp/framework/topbar.asp" -->

		<div class="page-wrapper">

			<!--#include virtual="/assets/asp/framework/nav.asp" -->

			<div class="page-content">

				<div class="container-fluid">

					<div class="row mt-4">

						<div class="col-sm-12">

							<div class="page-content">
<%
								If CInt(Session.Contents("CurrentPeriod")) < 17 Then

									sqlMatchups = "SELECT Matchups.MatchupID, Matchups.LevelID, Matchups.TeamID1, Teams1.TeamName AS TeamName1, Teams1.CBSLogo AS CBSLogo1, Teams1.CBSID AS CBSID1, Matchups.TeamID2, Teams2.TeamName, Teams2.CBSLogo, Teams2.CBSID, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.TeamPMR1, Matchups.TeamPMR2 FROM Matchups INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 INNER JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND Matchups.LevelID = 1;"
									sqlMatchups = sqlMatchups & "SELECT Matchups.MatchupID, Matchups.LevelID, Matchups.TeamID1, Teams1.TeamName AS TeamName1, Teams1.CBSLogo AS CBSLogo1, Teams1.CBSID AS CBSID1, Matchups.TeamID2, Teams2.TeamName, Teams2.CBSLogo, Teams2.CBSID, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.TeamPMR1, Matchups.TeamPMR2, Matchups.Leg FROM Matchups INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 INNER JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND Matchups.LevelID = 0;"
									sqlMatchups = sqlMatchups & "SELECT Matchups.MatchupID, Matchups.LevelID, Matchups.TeamID1, Teams1.TeamName AS TeamName1, Teams1.CBSLogo AS CBSLogo1, Teams1.CBSID AS CBSID1, Matchups.TeamID2, Teams2.TeamName, Teams2.CBSLogo, Teams2.CBSID, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.TeamPMR1, Matchups.TeamPMR2 FROM Matchups INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 INNER JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND Matchups.LevelID = 2;"
									sqlMatchups = sqlMatchups & "SELECT Matchups.MatchupID, Matchups.LevelID, Matchups.TeamID1, Teams1.TeamName AS TeamName1, Teams1.CBSLogo AS CBSLogo1, Teams1.CBSID AS CBSID1, Matchups.TeamID2, Teams2.TeamName, Teams2.CBSLogo, Teams2.CBSID, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.TeamPMR1, Matchups.TeamPMR2 FROM Matchups INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 INNER JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND Matchups.LevelID = 3;"
									Set rsMatchups = sqlDatabase.Execute(sqlMatchups)

									If Not rsMatchups.Eof Then arrOmega = rsMatchups.GetRows()
									Set rsMatchups = rsMatchups.NextRecordset()
									If Not rsMatchups.Eof Then arrCup = rsMatchups.GetRows()
									Set rsMatchups = rsMatchups.NextRecordset()
									If Not rsMatchups.Eof Then arrSLFFL = rsMatchups.GetRows()
									Set rsMatchups = rsMatchups.NextRecordset()
									If Not rsMatchups.Eof Then arrFLFFL = rsMatchups.GetRows()
%>
									<div class="row">

										<div class="col-12">
<%

											Response.Write("<div class=""row"">")

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
													TeamScore1 = FormatNumber(arrOmega(10, i), 2)
													TeamScore2 = FormatNumber(arrOmega(11, i), 2)
													TeamPMR1 = arrOmega(12, i)
													TeamPMR2 = arrOmega(13, i)

													TeamPMRColor1 = "success"
													If TeamPMR1 < 551 Then TeamPMRColor1 = "warning"
													If TeamPMR1 < 276 Then TeamPMRColor1 = "danger"
													TeamPMRPercent1 = (TeamPMR1 * 100) / 720

													TeamPMRColor2 = "success"
													If TeamPMR2 < 551 Then TeamPMRColor2 = "warning"
													If TeamPMR2 < 276 Then TeamPMRColor2 = "danger"
													TeamPMRPercent2 = (TeamPMR2 * 100) / 720
%>
													<div class="col-xxxl-4 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-12">
														<a href="/scores/<%= MatchupID %>/" style="text-decoration: none; display: block;">
															<ul class="list-group" id="matchup-<%= MatchupID %>" style="margin-bottom: 1rem;">
																<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #FFBA08; color: #fff;"><strong>OMEGA</strong> #<%= MatchupID %></li>
																<li class="list-group-item team-omega-box-<%= TeamID1 %>">
																	<span class="team-omega-score-<%= TeamID1 %>" style="font-size: 1em; background-color: #fff; color: #805C04; float: right;"><%= TeamScore1 %></span>
																	<span style="font-size: 13px; color: #805C04;"><%= TeamName1 %></span>
																	<div class="progress team-omega-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
																		<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
																			<span class="sr-only team-omega-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
																		</div>
																	</div>
																</li>
																<li class="list-group-item team-omega-box-<%= TeamID2 %>">
																	<span class="team-omega-score-<%= TeamID2 %>" style="font-size: 1em; background-color: #fff; color: #805C04; float: right;"><%= TeamScore2 %></span>
																	<span style="font-size: 13px; color: #805C04;"><%= TeamName2 %></span>
																	<div class="progress team-omega-progress-<%= TeamID2 %>" style="height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;">
																		<div class="progress-bar progress-bar-<%= TeamPMRColor2 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent2 %>" aria-valuemin="0" aria-valuemax="<%= TeamPMRPercent2 %>" style="width: <%= TeamPMRPercent2 %>%">
																			<span class="sr-only team-omega-progress-sr-<%= TeamID2 %>"><%= TeamPMRPercent2 %>%</span>
																		</div>
																	</div>
																</li>
															</ul>
														</a>
													</div>

<%
												Next
												End If

											Response.Write("</div>")

%>
										</div>

									</div>

									<div class="row">

										<div class="col-12">
									<%
											Response.Write("<div class=""row"">")

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

													TeamScore1 = FormatNumber(TeamScore1 + BaseScore1, 2)
													TeamScore2 = FormatNumber(TeamScore2 + BaseScore2, 2)

													TeamPMRColor1 = "success"
													If TeamPMR1 < 321 Then TeamPMRColor1 = "warning"
													If TeamPMR1 < 161 Then TeamPMRColor1 = "danger"
													TeamPMRPercent1 = (TeamPMR1 * 100) / 420

													TeamPMRColor2 = "success"
													If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
													If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"
													TeamPMRPercent2 = (TeamPMR2 * 100) / 420

													If TeamID1 = 38 Then TeamName1 = "München"
													If TeamID2 = 38 Then TeamName2 = "München"

													If TeamID1 = 36 Then TeamName1 = "Hanging With Hern"
													If TeamID2 = 36 Then TeamName2 = "Hanging With Hern"

													If TeamID1 = 44 Then TeamName1 = "Overlords"
													If TeamID2 = 44 Then TeamName2 = "Overlords"
									%>
													<div class="col-xxxl-3 col-xxl-3 col-xl-3 col-lg-6 col-md-6 col-sm-12">
														<a href="/scores/<%= MatchupID %>/" style="text-decoration: none; display: block;">
															<ul class="list-group" id="matchup-<%= MatchupID %>" style="margin-bottom: 1rem;">
																<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #D00000; color: #fff;"><strong>NEXT LEVEL CUP</strong> #<%= MatchupID %></li>
																<li class="list-group-item team-cup-box-<%= TeamID1 %>">
																	<span class="team-cup-score-<%= TeamID1 %>" style="font-size: 1em; background-color: #fff; color: #520000; float: right;"><%= TeamScore1 %></span>
																	<span style="font-size: 13px; color: #520000;"><%= TeamName1 %></span>
																	<div class="progress team-cup-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
																		<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
																			<span class="sr-only team-cup-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
																		</div>
																	</div>
																</li>
																<li class="list-group-item team-cup-box-<%= TeamID2 %>">
																	<span class="team-cup-score-<%= TeamID2 %>" style="font-size: 1em; background-color: #fff; color: #520000; float: right;"><%= TeamScore2 %></span>
																	<span style="font-size: 13px; color: #520000;"><%= TeamName2 %></span>
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

											Response.Write("</div>")
									%>
										</div>

									</div>


									<div class="row">

										<div class="col-xl-6 col-lg-12">

											<div class="row">
<%
												If IsArray(arrSLFFL) Then
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

													TeamPMRColor1 = "success"
													If TeamPMR1 < 321 Then TeamPMRColor1 = "warning"
													If TeamPMR1 < 161 Then TeamPMRColor1 = "danger"
													TeamPMRPercent1 = (TeamPMR1 * 100) / 420

													TeamPMRColor2 = "success"
													If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
													If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"
													TeamPMRPercent2 = (TeamPMR2 * 100) / 420
%>
													<div class="col-xxl-6 col-xl-12 col-lg-6 col-md-6 col-sm-12">
														<a href="/scores/<%= MatchupID %>/" style="text-decoration: none; display: block;">
															<ul class="list-group" id="matchup-<%= MatchupID %>" style="margin-bottom: 1rem;">
																<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #136F63; color: #fff;"><strong>SLFFL</strong> #<%= MatchupID %></li>
																<li class="list-group-item team-slffl-box-<%= TeamID1 %>">
																	<span class="team-slffl-score-<%= TeamID1 %>" style="font-size: 1.9rem; line-height: 1.9rem; background-color: #fff; color: #0F574D; float: right; padding-top: 0rem;"><%= TeamScore1 %></span>
																	<img src="<%= TeamLogo1 %>" width="36" height="28" style="padding-right: 0.5rem;" /> <span style="font-size: 15px; line-height: 1.9rem; color: #0F574D;"><b><%= TeamName1 %></b></span>
																	<div class="progress team-slffl-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
																		<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
																			<span class="sr-only team-slffl-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
																		</div>
																	</div>
																</li>
																<li class="list-group-item team-slffl-box-<%= TeamID2 %>">
																	<span class="team-slffl-score-<%= TeamID2 %>" style="font-size: 1.9rem; line-height: 1.9rem; background-color: #fff; color: #0F574D; float: right; padding-top: 0rem;"><%= TeamScore2 %></span>
																	<img src="<%= TeamLogo2 %>" width="36" height="28" style="padding-right: 0.5rem;" /> <span style="font-size: 15px; line-height: 1.9rem; color: #0F574D;"><b><%= TeamName2 %></b></span>
																	<div class="progress team-slffl-progress-<%= TeamID2 %>" style="height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;">
																		<div class="progress-bar progress-bar-<%= TeamPMRColor2 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent2 %>" aria-valuemin="0" aria-valuemax="<%= TeamPMRPercent2 %>" style="width: <%= TeamPMRPercent2 %>%">
																			<span class="sr-only team-slffl-progress-sr-<%= TeamID2 %>"><%= TeamPMRPercent2 %>%</span>
																		</div>
																	</div>
																</li>
															</ul>
														</a>
													</div>
<%
												Next
												End If
%>
											</div>

										</div>

										<div class="col-xl-6 col-lg-12">

											<div class="row">
<%
												If IsArray(arrFLFFL) Then
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

													TeamPMRColor1 = "success"
													If TeamPMR1 < 321 Then TeamPMRColor1 = "warning"
													If TeamPMR1 < 161 Then TeamPMRColor1 = "danger"
													TeamPMRPercent1 = (TeamPMR1 * 100) / 420

													TeamPMRColor2 = "success"
													If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
													If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"
													TeamPMRPercent2 = (TeamPMR2 * 100) / 420

													If TeamID1 = 38 Then TeamName1 = "München"
													If TeamID2 = 38 Then TeamName2 = "München"

													If TeamID1 = 36 Then TeamName1 = "Hanging With Hern"
													If TeamID2 = 36 Then TeamName2 = "Hanging With Hern"
%>
													<div class="col-xxl-6 col-xl-12 col-lg-6 col-md-6 col-sm-12">
														<a href="/scores/<%= MatchupID %>/" style="text-decoration: none; display: block;">
															<ul class="list-group" id="matchup-<%= MatchupID %>" style="margin-bottom: 1rem;">
																<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #032B43; color: #fff;"><strong>FLFFL</strong> #<%= MatchupID %></li>
																<li class="list-group-item team-flffl-box-<%= TeamID1 %>">
																	<span class="team-flffl-score-<%= TeamID1 %>" style="font-size: 1.9rem; line-height: 1.9rem; background-color: #fff; color: #03324F; float: right;"><%= TeamScore1 %></span>
																	<img src="<%= TeamLogo1 %>" width="36" height="28" style="padding-right: 0.5rem;" /> <span style="font-size: 15px; color: #03324F; line-height: 1.9rem;"><b><%= TeamName1 %></b></span>
																	<div class="progress team-flffl-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
																		<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
																			<span class="sr-only team-flffl-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
																		</div>
																	</div>
																</li>
																<li class="list-group-item team-flffl-box-<%= TeamID2 %>">
																	<span class="team-flffl-score-<%= TeamID2 %>" style="font-size: 1.9rem; line-height: 1.9rem; background-color: #fff; color: #03324F; float: right;"><%= TeamScore2 %></span>
																	<img src="<%= TeamLogo2 %>" width="36" height="28" style="padding-right: 0.5rem;" /> <span style="font-size: 15px; color: #03324F; line-height: 1.9rem;"><b><%= TeamName2 %></b></span>
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
												Next
												End If
%>
											</div>

										</div>

									</div>
<%
								Else
%>
									<div class="row">

										<div class="col-12">Go home and rest. The season is over.</div>

									</div>
<%
								End If
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

		<script src="/assets/plugins/countUp/countUp.min.js" type="text/javascript"></script>
		<script src="/assets/plugins/howler/howler.min.js" type="text/javascript"></script>

		<!--#include virtual="/assets/js/scores.asp"-->

	</body>

</html>
