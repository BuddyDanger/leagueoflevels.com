<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!--#include virtual="/assets/asp/functions/sha256.asp"-->
<%
	MatchupID = Session.Contents("Scores_Matchup_ID")

	sqlGetMatchup = sqlGetMatchup & "SELECT Matchups.MatchupID, Matchups.LevelID, Levels.Title, Matchups.Year, Matchups.Period, Matchups.IsPlayoffs, Matchups.IsCup, Matchups.TeamID1, Matchups.TeamID2, Teams1.CBSID AS TeamCBSID1,Teams2.CBSID AS TeamCBSID2, Accounts1.ProfileImage AS TeamCBSLogo1, Accounts2.ProfileImage AS TeamCBSLogo2, Teams1.TeamName AS TeamName1, Teams2.TeamName AS TeamName2, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.Leg, Teams1.AbbreviatedName AS AbbreviatedName1, Teams2.AbbreviatedName AS AbbreviatedName2, Matchups.TeamOmegaTravel1, Matchups.TeamOmegaTravel2 "
	sqlGetMatchup = sqlGetMatchup & "FROM Matchups "
	sqlGetMatchup = sqlGetMatchup & "LEFT JOIN Levels ON Levels.LevelID = Matchups.LevelID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Teams1.TeamID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Teams2.TeamID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Accounts AS Accounts1 ON Accounts1.AccountID = Link1.AccountID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Accounts AS Accounts2 ON Accounts2.AccountID = Link2.AccountID "
	sqlGetMatchup = sqlGetMatchup & "WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " "
	sqlGetMatchup = sqlGetMatchup & "ORDER BY CASE WHEN Matchups.LevelID = 1 THEN 1 WHEN Matchups.LevelID = 0 THEN 2 WHEN Matchups.LevelID = 2 THEN 3 WHEN Matchups.LevelID = 3 THEN 4 ELSE 5 END;"

	sqlGetSchedules = "SELECT MatchupID, Matchups.LevelID, Year, Period, IsPlayoffs, TeamID1, TeamID2, Team1.LevelID AS TeamLevelID1, Team2.LevelID AS TeamLevelID2, Team1.CBSID AS TeamCBSID1, Team2.CBSID AS TeamCBSID2, Account1.ProfileImage AS ProfileImage1, Account2.ProfileImage AS ProfileImage2, Team1.TeamName AS TeamName1, Team2.TeamName AS TeamName2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2, Leg, TeamProjected1, TeamProjected2, TeamWinPercentage1, TeamWinPercentage2, TeamMoneyline1, TeamMoneyline2, TeamSpread1, TeamSpread2, Matchups.TeamOmegaTravel1, Matchups.TeamOmegaTravel2 FROM Matchups "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team1 ON Team1.TeamID = Matchups.TeamID1 "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team2 ON Team2.TeamID = Matchups.TeamID2 "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Levels AS Level1 ON Level1.LevelID = Team1.LevelID "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Levels AS Level2 ON Level2.LevelID = Team2.LevelID "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Team1.TeamID "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Team2.TeamID "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Accounts AS Account1 ON Account1.AccountID = Link1.AccountID "
	sqlGetSchedules = sqlGetSchedules & "INNER JOIN Accounts AS Account2 ON Account2.AccountID = Link2.AccountID "
	sqlGetSchedules = sqlGetSchedules & "WHERE Matchups.MatchupID = " & MatchupID & ";"

	Set rsMatchup = sqlDatabase.Execute(sqlGetMatchup & sqlGetSchedules)

	arrMatchups = rsMatchup.GetRows()

	Set rsSchedules = rsMatchup.NextRecordset

	If Not rsSchedules.Eof Then

		thisMatchupID = rsSchedules("MatchupID")
		thisMatchupLevelID = rsSchedules("LevelID")
		thisYear = rsSchedules("Year")
		thisPeriod = rsSchedules("Period")
		thisTeamID1 = rsSchedules("TeamID1")
		thisTeamID2 = rsSchedules("TeamID2")
		thisProfileImage1 = rsSchedules("ProfileImage1")
		thisProfileImage2 = rsSchedules("ProfileImage2")
		thisTeamLevelID1 = rsSchedules("TeamLevelID1")
		thisTeamLevelID2 = rsSchedules("TeamLevelID2")
		thisTeamCBSID1 = rsSchedules("TeamCBSID1")
		thisTeamCBSID2 = rsSchedules("TeamCBSID2")
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
		thisLeg = rsSchedules("Leg")
		thisTeamOmegaTravel1 = rsSchedules("TeamOmegaTravel1")
		thisTeamOmegaTravel2 = rsSchedules("TeamOmegaTravel2")
		thisOverUnderTotal = thisTeamProjected1 + thisTeamProjected2

		If thisTeamLevelID1 = 1 Then thisTeamLevelTitle1 = "omega"
		If thisTeamLevelID1 = 2 Then thisTeamLevelTitle1 = "samelevel"
		If thisTeamLevelID1 = 3 Then thisTeamLevelTitle1 = "farmlevel"

		If thisTeamLevelID2 = 1 Then thisTeamLevelTitle2 = "omega"
		If thisTeamLevelID2 = 2 Then thisTeamLevelTitle2 = "samelevel"
		If thisTeamLevelID2 = 3 Then thisTeamLevelTitle2 = "farmlevel"

		thisMatchupURL = "/scores/" & thisMatchupID & "/"

		rsSchedules.Close
		Set rsSchedules = Nothing

	End If


%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title><%= thisTeamName1 %> vs. <%= thisTeamName2 %> / WEEK <%= Session.Contents("CurrentPeriod") %> / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/scores/<%= MatchupID %>/" />
		<meta property="og:title" content="<%= thisTeamName1 %> vs. <%= thisTeamName2 %> / WEEK <%= Session.Contents("CurrentPeriod") %> / League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/scores/<%= MatchupID %>/" />
		<meta name="twitter:title" content="<%= thisTeamName1 %> vs. <%= thisTeamName2 %> / WEEK <%= Session.Contents("CurrentPeriod") %> / League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="<%= thisTeamName1 %> vs. <%= thisTeamName2 %> / WEEK <%= Session.Contents("CurrentPeriod") %> / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/scores/<%= thisMatchupID %>/" />

		<link href="/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/icons.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/style.css?version=3" rel="stylesheet" type="text/css" />

		<style>

			@media (max-width:1200px) {	.gamestats { display: none !important; } }

			@media (max-width:768px) { .page-content { padding: 0 !important; padding-bottom: 2rem !important; } }

			.is-loading {
				background: linear-gradient(to right, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.5) 50%, rgba(255, 255, 255, 0) 100%);
				background-size: 75% 100%;
				animation-duration: 1500ms;
				animation-name: headerShine;
				animation-iteration-count: infinite;
				background-repeat: no-repeat;
				animation-timing-function: ease;
				background-position: 0 0;
				background-color: #166dc1;
				background-blend-mode: overlay;
			}

			.progress-bar-name {
				background-color: #ddd;
				height: 12px;
				width: 30%;
				border-radius: 100px;
			}

			.progress-bar-gameline {
				background-color: #ddd;
				height: 12px;
				width: 70%;
				border-radius: 100px;
			}

			.progress-bar-photo {
				height: 40px;
				width: 40px; height: 40px;
				background-color: #ddd;
				border-radius: 50%;
			}

			.inactive-player { background-color:#fafafa; }

			@keyframes headerShine {
				0% { background-position: -300% 0; }
				100% { background-position: 500% 0; }
			}

		</style>

	</head>

	<body>

		<!--#include virtual="/assets/asp/framework/topbar.asp" -->

		<div class="page-wrapper">

			<!--#include virtual="/assets/asp/framework/nav.asp" -->

			<div class="page-content">

				<div class="container-fluid pl-0 pl-lg-2 pr-0 pr-lg-2">

					<div class="page-content mt-sm-4">

						<div class="row">

							<div class="col-6 col-lg-3 pl-0 pr-0">

								<ul class="list-group" id="team-1-roster" style="margin-bottom: 1rem;">
<%
									Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
									oXML.loadXML(GetScores(thisTeamLevelTitle1, Session.Contents("CurrentPeriod")))

									oXML.setProperty "SelectionLanguage", "XPath"
									Set objTeam = oXML.selectSingleNode(".//team[@id = " & thisTeamCBSID1 & "]")

									TeamLevelTitle1 = LevelTitle
									Set objTeamPlayers1 = objTeam.getElementsByTagName("player")
%>
									<li class="list-group-item team-1-box m-0 p-0 bg-dark" style="color: #fff;border-radius: 0; border-top-left-radius: 5px;">
										<div class="row p-0 py-2 m-0">
											<div class="col-6 col-lg-2 p-0 pt-1">
												<span><img src="https://samelevel.imgix.net/<%= thisProfileImage1 %>?w=40&h=40&fit=crop&crop=focalpoint" width="40" alt="<%= thisTeamName1 %>" class="rounded-circle ml-3 ml-lg-2" /></span>
											</div>
											<div class="col-7 text-center d-none d-lg-block pt-1">
												<div class="py-2 px-2 bg-primary rounded" style="margin-top: 2px;"><b><%= thisTeamName1 %></b><% If thisTeamOmegaTravel1 <> 0 Then %> (<%= thisTeamOmegaTravel1 %>)<% End If %></div>
											</div>
											<div class="col-6 col-lg-3 pr-1 pt-2 text-right">
												<% If thisTeamLevelID1 = 1 Then %>
													<div><span class="badge team-1-score pt-0 text-right" style="font-size: 20px; color: #fff;"><%= FormatNumber(thisTeamScore1 + thisTeamOmegaTravel1, 2) %></span></div>
												<% Else %>
													<div><span class="badge team-1-score pt-0 text-right" style="font-size: 20px; color: #fff;"><%= FormatNumber(thisTeamScore1, 2) %></span></div>
												<% End If %>
												<div><span class="badge team-1-progress pt-0 text-right" style="font-size: 10px; color: #fff;"><%= thisTeamPMR1 %> PMR</span></div>
											</div>
										</div>
									</li>

									<li class="list-group-item d-block d-lg-none py-1 px-3 px-md-2 bg-light">

										<h6><b><%= thisTeamName1 %></b></h6>

									</li>
<%
									HitReserves = 0
									For i = 0 to (objTeamPlayers1.length - 1)

										Set objPlayer = objTeamPlayers1.item(i)

										thisPlayerID = objPlayer.getAttribute("id")

										Set objPlayerStatus = objPlayer.getElementsByTagName("status")
										If objPlayerStatus.Length > 0 Then thisPlayerStatus = objPlayerStatus.item(0).text

										If (thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured") And HitReserves = 0 Then StartReserves = 1
										If thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured" Then HitReserves = 1

										If StartReserves = 1 Then Response.Write("<li class=""list-group-item py-1 px-3 bg-light""><h6><b>BENCH PLAYERS</b></h6></li>")
%>
										<li class="list-group-item team-1-player-<%= thisPlayerID %> pr-3 pt-3 pl-4 pl-md-3">

											<div class="row">

												<div class="col-1 col-lg-2 d-none d-lg-block m-0 p-0">
													<div class="progress-bar-photo can-load is-loading mb-0 team-1-player-<%= thisPlayerID %>-photo-loading"></div>
													<img src="#" class="rounded-circle mt-o p-0 team-1-player-<%= thisPlayerID %>-photo d-none" width="40" alt="<%= thisPlayerName %>" />
												</div>

												<div class="col-12 col-lg-10 p-0 pb-0 m-0 text-left">
													<span class="team-1-player-<%= thisPlayerID %>-points player-points float-right font-weight-bold badge badge-dark">0.00</span>
													<div class="team-1-player-<%= thisPlayerID %>-name player-name"><div class="mt-1 mb-2 progress-bar-name can-load is-loading"></div></div>
													<span class="team-1-player-<%= thisPlayerID %>-gametime player-points float-right font-weight-bold badge badge-info d-none">0.00</span>
													<div class="team-1-player-<%= thisPlayerID %>-gameline"><div class="mt-1 progress-bar-gameline can-load is-loading"></div></div>
													<div class="team-1-player-<%= thisPlayerID %>-stats d-none"></div>
												</div>

											</div>

										</li>
<%
										If StartReserves = 1 Then StartReserves = 0

									Next
%>

								</ul>

							</div>

							<div class="col-6 col-lg-3 pl-0 pr-0">

								<ul class="list-group" id="team-2-roster" style="margin-bottom: 1rem;">
<%
									Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
									oXML.loadXML(GetScores(thisTeamLevelTitle2, Session.Contents("CurrentPeriod")))

									oXML.setProperty "SelectionLanguage", "XPath"
									Set objTeam = oXML.selectSingleNode(".//team[@id = " & thisTeamCBSID2 & "]")

									Set objTeamName2 = objTeam.getElementsByTagName("name")
									Set objTeamScore2 = objTeam.getElementsByTagName("pts")
									Set objTeamPMR2 = objTeam.getElementsByTagName("pmr")
									Set objTeamPlayers2 = objTeam.getElementsByTagName("player")

									TeamLevelTitle2 = LevelTitle
									TeamName2 = objTeamName2.item(0).text
									TeamScore2 = FormatNumber(CDbl(objTeamScore2.item(0).text), 2)
									TeamPMR2 = CInt(objTeamPMR2.item(0).text)
%>
									<li class="list-group-item team-2-box m-0 p-0 bg-dark" style="color: #fff; border-radius: 0; border-top-right-radius: 5px;">
										<div class="row p-0 py-2 m-0">
											<div class="col-6 col-lg-3 pl-1 pt-2 text-left">
												<div><span class="badge team-2-score pt-0 text-left" style="font-size: 20px; color: #fff;"><%= TeamScore2 %></span></div>
												<div><span class="badge team-2-progress pt-0 text-left" style="font-size: 10px; color: #fff;"><%= TeamPMR2 %> PMR</span></div>
											</div>
											<div class="col-7 text-center d-none d-lg-block pt-1">
												<div class="py-2 px-2 bg-primary rounded" style="margin-top: 2px;"><b><%= TeamName2 %></b></div>
											</div>
											<div class="col-6 col-lg-2 p-0 pt-1 text-right">
												<span><img src="https://samelevel.imgix.net/<%= thisProfileImage2 %>?w=40&h=40&fit=crop&crop=focalpoint" width="40" alt="<%= TeamName2 %>" class="rounded-circle mr-3 mr-lg-2" /></span>
											</div>
										</div>
									</li>

									<li class="list-group-item d-block d-lg-none py-1 px-2 pr-3 bg-light text-right">

										<h6><b><%= TeamName2 %></b></h6>

									</li>
<%
									HitReserves = 0
									For i = 0 to (objTeamPlayers2.length - 1)

										Set objPlayer = objTeamPlayers2.item(i)

										thisPlayerID = objPlayer.getAttribute("id")

										Set objPlayerStatus = objPlayer.getElementsByTagName("status")
										If objPlayerStatus.Length > 0 Then thisPlayerStatus = objPlayerStatus.item(0).text

										If (thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured") And HitReserves = 0 Then StartReserves = 1
										If thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured" Then HitReserves = 1

										If StartReserves = 1 Then Response.Write("<li class=""list-group-item py-1 px-3 bg-light text-right""><h6><b>BENCH PLAYERS</b></h6></li>")
%>
										<li class="list-group-item team-2-player-<%= thisPlayerID %> pl-3 pt-3 pr-4 pr-md-3">

											<div class="row">

												<div class="col-12 col-lg-10 p-0 pb-0 m-0 text-right">
													<span class="team-2-player-<%= thisPlayerID %>-points player-points float-left font-weight-bold badge badge-dark">0.00</span>
													<div  class="team-2-player-<%= thisPlayerID %>-name player-name"><div class="mt-1 mb-2 progress-bar-name can-load is-loading float-right"></div></div><div class="clearfix"></div>
													<span class="team-2-player-<%= thisPlayerID %>-gametime player-points float-left font-weight-bold badge badge-info d-none">0.00</span>
													<div  class="team-2-player-<%= thisPlayerID %>-gameline"><div class="mt-1 progress-bar-gameline can-load is-loading float-right"></div></div>
													<div  class="team-2-player-<%= thisPlayerID %>-stats d-none"></div><div class="clearfix"></div>
												</div>

												<div class="col-1 col-lg-2 d-none d-lg-block m-0 p-0 text-right">
													<div class="progress-bar-photo can-load is-loading mb-0 team-2-player-<%= thisPlayerID %>-photo-loading float-right"></div>
													<img src="#" class="rounded-circle mt-o p-0 team-2-player-<%= thisPlayerID %>-photo d-none" width="40" alt="<%= thisPlayerName %>" />
												</div>

											</div>

										</li>
<%
										If StartReserves = 1 Then StartReserves = 0

									Next
%>
								</ul>

							</div>

							<div class="col-12 col-xl-6 pl-0 pr-0 pl-lg-3 pr-lg-0">

								<div class="row">
<%
									If thisTeamWinPercentage1 < 0.3 Or thisTeamWinPercentage1 > 0.7 Then thisFormDisabled = "disabled"

									thisTeamWinPercentage1 = (thisTeamWinPercentage1 * 100) & "%"
									thisTeamWinPercentage2 = (thisTeamWinPercentage2 * 100) & "%"

									If thisTeamMoneyline1 > 0 Then thisTeamMoneyline1 = "+" & thisTeamMoneyline1
									If thisTeamMoneyline2 > 0 Then thisTeamMoneyline2 = "+" & thisTeamMoneyline2

									If thisTeamSpread1 > 0 Then thisTeamSpread1 = "+" & thisTeamSpread1
									If thisTeamSpread2 > 0 Then thisTeamSpread2 = "+" & thisTeamSpread2

									For i = 0 To UBound(arrMatchups, 2)

										oMatchupID = arrMatchups(0, i)
										oLevelID = arrMatchups(1, i)
										oTeamID1 = arrMatchups(7, i)
										oTeamName1 = arrMatchups(13, i)
										oTeamLogo1 = arrMatchups(11, i)
										oTeamCBSID1 = arrMatchups(9, i)
										oTeamID2 = arrMatchups(8, i)
										oTeamName2 = arrMatchups(14, i)
										oTeamLogo2 = arrMatchups(12, i)
										oTeamCBSID2 = arrMatchups(10, i)
										oTeamScore1 = FormatNumber(arrMatchups(15, i), 2)
										oTeamScore2 = FormatNumber(arrMatchups(16, i), 2)
										oTeamAbbreviatedName1 = arrMatchups(18, i)
										oTeamAbbreviatedName2 = arrMatchups(19, i)

										oTeamOmegaTravel1 = arrMatchups(20, i)
										oTeamOmegaTravel2 = arrMatchups(21, i)

										If oLevelID = 0 Then LevelCSS = "cup"
										If oLevelID = 1 Then LevelCSS = "omega"
										If oLevelID = 2 Then LevelCSS = "slffl"
										If oLevelID = 3 Then LevelCSS = "flffl"

										If oLevelID = 1 Then oTeamScore1 = FormatNumber(oTeamScore1 + oTeamOmegaTravel1, 2)
	%>
										<div class="col-6 col-lg-3">
											<a href="/scores/<%= oMatchupID %>/" style="text-decoration: none; display: block;">
												<ul class="list-group matchup-<%= oMatchupID %>" id="matchup-<%= oMatchupID %>" style="margin-bottom: 1rem;">
													<li class="list-group-item team-<%= LevelCSS %>-box-<%= oTeamID1 %>" style="position: relative;">
														<span class="team-<%= LevelCSS %>-score-<%= oTeamID1 %>" style="font-size: 1em; line-height: 1.9rem; background-color: #fff; float: right; padding-top: 0rem;"><%= oTeamScore1 %></span>
														<span style="font-size: 13px; line-height: 1.9rem;  font-weight: bold;"><%= oTeamAbbreviatedName1 %></span>
													</li>
													<li class="list-group-item team-<%= LevelCSS %>-box-<%= oTeamID2 %>">
														<span class="team-<%= LevelCSS %>-score-<%= oTeamID2 %>" style="font-size: 1em; line-height: 1.9rem; background-color: #fff;  float: right; padding-top: 0rem;"><%= oTeamScore2 %></span>
														<span style="font-size: 13px; line-height: 1.9rem;  font-weight: bold;"><%= oTeamAbbreviatedName2 %></span>
													</li>
												</ul>
											</a>
										</div>
	<%
									Next
	%>

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

		<script src="/assets/plugins/countUp/countUp.min.js" type="text/javascript"></script>
		<script src="/assets/plugins/howler/howler.min.js" type="text/javascript"></script>

		<!--#include virtual="/assets/js/matchup.asp"-->

	</body>

</html>
