<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	MatchupID = Session.Contents("Scores_Matchup_ID")

	sqlGetMatchup = "SELECT Matchups.MatchupID, Matchups.LevelID, Levels.Title, Matchups.Year, Matchups.Period, Matchups.IsPlayoffs, Matchups.IsCup, Matchups.TeamID1, Matchups.TeamID2, Teams1.CBSID AS TeamCBSID1,Teams2.CBSID AS TeamCBSID2, Accounts1.ProfileImage AS TeamCBSLogo1, Accounts2.ProfileImage AS TeamCBSLogo2, Teams1.TeamName AS TeamName1, Teams2.TeamName AS TeamName2, Matchups.TeamScore1, Matchups.TeamScore2, Matchups.Leg "
	sqlGetMatchup = sqlGetMatchup & "FROM Matchups "
	sqlGetMatchup = sqlGetMatchup & "LEFT JOIN Levels ON Levels.LevelID = Matchups.LevelID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Teams AS Teams1 ON Teams1.TeamID = Matchups.TeamID1 "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Teams AS Teams2 ON Teams2.TeamID = Matchups.TeamID2 "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN LinkAccountsTeams AS Link1 ON Link1.TeamID = Teams1.TeamID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN LinkAccountsTeams AS Link2 ON Link2.TeamID = Teams2.TeamID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Accounts AS Accounts1 ON Accounts1.AccountID = Link1.AccountID "
	sqlGetMatchup = sqlGetMatchup & "INNER JOIN Accounts AS Accounts2 ON Accounts2.AccountID = Link2.AccountID "
	sqlGetMatchup = sqlGetMatchup & "WHERE MatchupID = " & MatchupID
	Set rsMatchup = sqlDatabase.Execute(sqlGetMatchup)

	If rsMatchup.Eof Then

		'ERROR CATCH

	Else

		MatchupID = rsMatchup("MatchupID")
		MatchupYear = rsMatchup("Year")
		MatchupPeriod = rsMatchup("Period")
		LevelID = rsMatchup("LevelID")
		LevelTitle = rsMatchup("Title")
		IsPlayoffs = rsMatchup("IsPlayoffs")
		IsCup = rsMatchup("IsCup")
		TeamID1 = rsMatchup("TeamID1")
		TeamID2 = rsMatchup("TeamID2")
		TeamCBSID1 = rsMatchup("TeamCBSID1")
		TeamCBSID2 = rsMatchup("TeamCBSID2")
		TeamCBSLogo1 = "https://samelevel.imgix.net/" & rsMatchup("TeamCBSLogo1") & "?w=100&h=100&fit=crop&crop=focalpoint"
		TeamCBSLogo2 = "https://samelevel.imgix.net/" & rsMatchup("TeamCBSLogo2") & "?w=100&h=100&fit=crop&crop=focalpoint"
		TeamName1 = rsMatchup("TeamName1")
		TeamName2 = rsMatchup("TeamName2")
		TeamScore1 = rsMatchup("TeamScore1")
		TeamScore2 = rsMatchup("TeamScore2")
		Leg = rsMatchup("Leg")

		If LevelID = 0 Then
			LevelTitle = "CUP"
			BackgroundColor = "D00000"
		End If
		If LevelID = 1 Then
			LevelTitle = "OMEGA"
			BackgroundColor = "FFBA08"
		End If
		If LevelID = 2 Then
			LevelTitle = "SLFFL"
			BackgroundColor = "136F63"
		End If
		If LevelID = 3 Then
			LevelTitle = "FLFFL"
			BackgroundColor = "032B43"
		End If

		MatchupLevel = LevelTitle

	End If
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title><%= TeamName1 %> vs. <%= TeamName2 %> / <%= MatchupLevel %> WEEK <%= MatchupPeriod %> / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/scores/<%= MatchupID %>/" />
		<meta property="og:title" content="<%= TeamName1 %> vs. <%= TeamName2 %> / <%= MatchupLevel %> WEEK <%= MatchupPeriod %> / League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/scores/<%= MatchupID %>/" />
		<meta name="twitter:title" content="<%= TeamName1 %> vs. <%= TeamName2 %> / <%= MatchupLevel %> WEEK <%= MatchupPeriod %> / League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="<%= TeamName1 %> vs. <%= TeamName2 %> / <%= MatchupLevel %> WEEK <%= MatchupPeriod %> / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/scores/<%= MatchupID %>/" />

		<link href="/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/icons.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/style.css?version=3" rel="stylesheet" type="text/css" />

		<style>

			@media (max-width:1200px) {
				.list-group-item { background-image: none !important; padding-left: 1rem !important;}
				.gamestats { display: none !important; }
				.player-points { font-size: 16px !important; font-weight: bold !important; }
			}

			@media (max-width:768px) {
				.list-group-item { background-image: none !important; padding-left: 0.5rem !important;}
				.team-1-box, .team-2-box { padding-left: 10px !important; }
				.team-1-score, .team-2-score { float: none !important; clear: both; padding-left: 0px !important; padding-right: 0px !important; }
				.team-1-name, .team-2-name { font-size: 16px !important; display: block; line-height: 22px !important; }
				.page-content { padding: 0 !important; padding-bottom: 2rem !important; }
				.player-points { padding-right: 0; margin-right: -1rem; text-align: right; }
			}

		</style>

	</head>

	<body>

		<!--#include virtual="/assets/asp/framework/topbar.asp" -->

		<div class="page-wrapper">

			<!--#include virtual="/assets/asp/framework/nav.asp" -->

			<div class="page-content">

				<div class="container-fluid pl-0 pl-lg-2 pr-0 pr-lg-2">

					<div class="row">

						<div class="col-sm-12">

							<div class="page-title-box">

								<div class="float-right">

									<ol class="breadcrumb" style="padding-bottom: 0.5rem;">
										<li class="breadcrumb-item"><a href="/">Dashboard</a></li>
										<li class="breadcrumb-item"><a href="/scores/">Live Scoring</a></li>
										<li class="breadcrumb-item active"><%= LevelTitle %> Week <%= MatchupPeriod %></li>
									</ol>

								</div>

								<h4 class="page-title hidden-sm"><%= TeamName1 %> vs. <%= TeamName2 %></h4>
								<div class="clearfix"></div>

							</div>

							<div class="page-content">

								<div class="row">

									<div class="col-xxs-12">

										<div class="row">

											<div class="col-xxs-6">

												<ul class="list-group" id="team-1-roster" style="margin-bottom: 1rem;">
<%
													BaseScore1 = 0
													BaseScore2 = 0

													If LevelID = 0 Then

														If CInt(Leg) = 2 Then

															sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & TeamID1 & " OR TeamID2 = " & TeamID1 & ") AND LevelID = 0 AND Year = " & MatchupYear & " AND Period = " & MatchupPeriod - 1
															Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

															If CInt(rsLastWeek("TeamID1")) = CInt(TeamID1) Then BaseScore1 = rsLastWeek("TeamScore1")
															If CInt(rsLastWeek("TeamID2")) = CInt(TeamID1) Then BaseScore1 = rsLastWeek("TeamScore2")

															sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & TeamID2 & " OR TeamID2 = " & TeamID2 & ") AND LevelID = 0 AND Year = " & MatchupYear & " AND Period = " & MatchupPeriod - 1
															Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

															If CInt(rsLastWeek("TeamID1")) = CInt(TeamID2) Then BaseScore2 = rsLastWeek("TeamScore1")
															If CInt(rsLastWeek("TeamID2")) = CInt(TeamID2) Then BaseScore2 = rsLastWeek("TeamScore2")


														End If

														sqlGetLeague = "SELECT LevelID FROM Teams WHERE TeamID = " & TeamID1
														Set rsLeague = sqlDatabase.Execute(sqlGetLeague)

														thisLevelID = CInt(rsLeague("LevelID"))

														If thisLevelID = 2 Then LevelTitle = "SLFFL"
														If thisLevelID = 3 Then LevelTitle = "FLFFL"

														rsLeague.Close
														Set rsLeague = Nothing

													End If

													Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
													oXML.loadXML(GetScores(LevelTitle, Session.Contents("CurrentPeriod")))

													oXML.setProperty "SelectionLanguage", "XPath"
													Set objTeam = oXML.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")

													TeamLevelTitle1 = LevelTitle
													Set objTeamName1 = objTeam.getElementsByTagName("name")
													Set objTeamScore1 = objTeam.getElementsByTagName("pts")
													Set objTeamPMR1 = objTeam.getElementsByTagName("pmr")
													Set objTeamPlayers1 = objTeam.getElementsByTagName("player")

													TeamName1 = objTeamName1.item(0).text
													TeamScore1 = FormatNumber(CDbl(objTeamScore1.item(0).text) + BaseScore1, 2)
													TeamPMR1 = CInt(objTeamPMR1.item(0).text)

													If LevelID = 1 Then

														TeamPMRColor1 = "success"
														If TeamPMR1 < 396 Then TeamPMRColor1 = "warning"
														If TeamPMR1 < 198 Then TeamPMRColor1 = "danger"
														TeamPMRPercent1 = (TeamPMR1 * 100) / 600

													Else

														TeamPMRColor1 = "success"
														If TeamPMR1 < 396 Then TeamPMRColor1 = "warning"
														If TeamPMR1 < 198 Then TeamPMRColor1 = "danger"
														TeamPMRPercent1 = (TeamPMR1 * 100) / 600

													End If

													If CInt(TeamID1) = 38 Then TeamName1 = "München on Bündchen"
%>
													<li class="list-group-item team-1-box" style="padding-left: 70px; background-color: #<%= BackgroundColor %>; color: #fff; background-image: url('<%= TeamCBSLogo1 %>'); background-position: -40px -10px; background-repeat: no-repeat;">
														<span class="team-1-name" style="font-size: 26px"><b><%= TeamName1 %></b></span>
														<span class="badge team-1-score" style="font-size: 32px; color: #fff; float: right; padding-top: 0.75rem;"><%= TeamScore1 %></span>
														<div class="progress team-1-progress" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
															<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
																<span class="sr-only team-1-progress-sr"><%= TeamPMRPercent1 %>%</span>
															</div>
														</div>
													</li>
<%
													HitReserves = 0
													ExtraBorder = 0
													TeamRoster1 = ""
													For i = 0 to (objTeamPlayers1.length - 1)

														Set objPlayer = objTeamPlayers1.item(i)

														thisPlayerID = objPlayer.getAttribute("id")

														thisPlayerName = ""
														thisPlayerPoints = ""
														thisPlayerStatus = ""
														thisPlayerGameTimestamp = ""
														thisPlayerPMR = 0
														thisPlayerHomeGame = 2
														thisPlayerProTeam = ""
														thisPlayerPosition = ""
														thisPlayerOpponent = ""
														thisPlayerQuarter = ""
														thisPlayerQuarterTimeRemaining = ""

														Set objPlayerName = objPlayer.getElementsByTagName("fullname")
														If objPlayerName.Length > 0 Then thisPlayerName = objPlayerName.item(0).text

														Set objPlayerPoints = objPlayer.getElementsByTagName("fpts")
														If objPlayerPoints.Length > 0 Then thisPlayerPoints = objPlayerPoints.item(0).text
														If IsNumeric(thisPlayerPoints) Then thisPlayerPoints = FormatNumber(thisPlayerPoints, 2)

														Set objPlayerStatus = objPlayer.getElementsByTagName("status")
														If objPlayerStatus.Length > 0 Then thisPlayerStatus = objPlayerStatus.item(0).text

														Set objPlayerStats = objPlayer.getElementsByTagName("stats_period")
														If objPlayerStats.Length > 0 Then thisPlayerStats = objPlayerStats.item(0).text

														Set objPlayerGameTimestamp = objPlayer.getElementsByTagName("game_start_timestamp")
														If objPlayerGameTimestamp.Length > 0 Then thisPlayerGameTimestamp = objPlayerGameTimestamp.item(0).text

														Set objPlayerPMR = objPlayer.getElementsByTagName("minutes_remaining")
														If objPlayerPMR.Length > 0 Then thisPlayerPMR = CInt(objPlayerPMR.item(0).text)

														Set objPlayerHomeGame = objPlayer.getElementsByTagName("home_game")
														If objPlayerHomeGame.Length > 0 Then thisPlayerHomeGame = CInt(objPlayerHomeGame.item(0).text)

														Set objPlayerProTeam = objPlayer.getElementsByTagName("pro_team")
														If objPlayerProTeam.Length > 0 Then thisPlayerProTeam = objPlayerProTeam.item(0).text

														Set objPlayerPosition = objPlayer.getElementsByTagName("position")
														If objPlayerPosition.Length > 0 Then thisPlayerPosition = objPlayerPosition.item(0).text

														Set objPlayerOpponent = objPlayer.getElementsByTagName("opponent")
														If objPlayerOpponent.Length > 0 Then thisPlayerOpponent = objPlayerOpponent.item(0).text

														Set objPlayerQuarter = objPlayer.getElementsByTagName("quarter")
														If objPlayerQuarter.Length > 0 Then thisPlayerQuarter = objPlayerQuarter.item(0).text

														Set objPlayerQuarterTimeRemaining = objPlayer.getElementsByTagName("time_remaining")
														If objPlayerQuarterTimeRemaining.Length > 0 Then thisPlayerQuarterTimeRemaining = objPlayerQuarterTimeRemaining.item(0).text

														If thisPlayerHomeGame = 1 Then
															thisGameLine = thisPlayerProTeam & " vs. " & thisPlayerOpponent
														ElseIf thisPlayerHomeGame = 0 Then
															thisGameLine = thisPlayerProTeam & " @ " & thisPlayerOpponent
														Else
															thisGameLine = ""
														End If

														If thisPlayerHomeGame < 2 Then

															TeamRoster1 = TeamRoster1 & thisPlayerID & ","

															thisPlayerGameTimestamp = DateAdd("s", thisPlayerGameTimestamp, DateSerial(1970,1,1))
															thisPlayerGameTimestamp = DateAdd("h", -4, thisPlayerGameTimestamp)

															thisPlayerGameDay = UCase(WeekdayName(Weekday(thisPlayerGameTimestamp),True))
															thisPlayerHour = Hour(thisPlayerGameTimestamp)
															thisPlayerMinute = Minute(thisPlayerGameTimestamp)

															If thisPlayerHour > 12 Then
																AMPM = "PM"
																thisPlayerHour = thisPlayerHour - 12
															Else
																AMPM = "AM"
															End If

															If Len(thisPlayerMinute) = 1 Then thisPlayerMinute = "0" & thisPlayerMinute

														End If

														thisPlayerPMRColor = "success"
														If thisPlayerPMR < 40 Then thisPlayerPMRColor = "warning"
														If thisPlayerPMR < 20 Then thisPlayerPMRColor = "danger"
														thisPlayerPMRPercent = (thisPlayerPMR * 100) / 60

														If thisPlayerPosition = "DST" Then
															thisBackgroundPosition = "-100px 50%"
														Else
															thisBackgroundPosition = "-70px -20px"
														End If

														If (thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured") And HitReserves = 0 Then StartReserves = 1
														If thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured" Then HitReserves = 1

														If StartReserves = 1 Then Response.Write("</ul><hr style=""border-top:1px dotted #ccc;"" /><ul class=""list-group"" id=""team-1-bench"" style=""margin-bottom: 1rem;"">")
%>
														<li class="list-group-item team-1-player-<%= thisPlayerID %>" style="padding-left: 70px; background-image: url('https://sports.cbsimg.net/images/football/nfl/players/170x170/<%= thisPlayerID %>.png'); background-position: <%= thisBackgroundPosition %>; background-repeat: no-repeat;">

															<div class="row">
																<div class="col-xxs-9 col-xl-9" style="line-height: 1.5rem;">
																	<div class="player-name" style="font-size: 16px;"><b><%= thisPlayerName %></b></div>
																	<div class="d-none d-xl-block " style="line-height: 1.5rem;">
																	<%	If thisPlayerHomeGame < 2 Then %>
																		<span class="team-1-player-<%= thisPlayerID %>-gameline"><%= thisGameLine %> - <%= thisPlayerGameDay %>&nbsp;<%= thisPlayerHour %>:<%= thisPlayerMinute %><%= AMPM %></span> &mdash;
																		<span class="team-1-player-<%= thisPlayerID %>-gameposition"><%= thisPlayerQuarter %>Q&nbsp;<%= thisPlayerQuarterTimeRemaining %></span>
																	<% Else %>
																		<span class="team-1-player-<%= thisPlayerID %>-gameline">BYE</span>
																	<% End If %>
																	</div>
																</div>
																<div class="col-xxs-3 col-xl-3 text-right" style="padding-right: 1rem; text-align: right;">
																	<span class="team-1-player-<%= thisPlayerID %>-points player-points" style="font-size: 2em; background-color: #fff;"><%= thisPlayerPoints %></span>
																</div>
															</div>

															<div class="row">
																<div class="col-12 team-1-player-<%= thisPlayerID %>-stats" style="line-height: 1rem;"><%= thisPlayerStats %></div>
															</div>

															<div class="progress team-1-player-<%= thisPlayerID %>-progress" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
																<div class="progress-bar progress-bar-<%= thisPlayerPMRColor %>" role="progressbar" aria-valuenow="<%= thisPlayerPMRPercent %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= thisPlayerPMRPercent %>%; ">
																	<span class="sr-only team-1-progress-sr"><%= thisPlayerPMRPercent %>%</span>
																</div>
															</div>

														</li>
<%
														If StartReserves = 1 Then StartReserves = 0

													Next

													If Right(TeamRoster1, 1) = "," Then TeamRoster1 = Left(TeamRoster1, Len(TeamRoster1)-1)
%>

												</ul>

											</div>

											<div class="col-xxs-6">

												<ul class="list-group" id="team-2-roster" style="margin-bottom: 1rem;">
<%
													If LevelID = 0 Then

														sqlGetLeague = "SELECT LevelID FROM Teams WHERE TeamID = " & TeamID2
														Set rsLeague = sqlDatabase.Execute(sqlGetLeague)

														thisLevelID = CInt(rsLeague("LevelID"))

														If thisLevelID = 2 Then LevelTitle = "SLFFL"
														If thisLevelID = 3 Then LevelTitle = "FLFFL"

														rsLeague.Close
														Set rsLeague = Nothing

													End If

													Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
													oXML.loadXML(GetScores(LevelTitle, Session.Contents("CurrentPeriod")))

													oXML.setProperty "SelectionLanguage", "XPath"
													Set objTeam = oXML.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")

													Set objTeamName2 = objTeam.getElementsByTagName("name")
													Set objTeamScore2 = objTeam.getElementsByTagName("pts")
													Set objTeamPMR2 = objTeam.getElementsByTagName("pmr")
													Set objTeamPlayers2 = objTeam.getElementsByTagName("player")

													TeamLevelTitle2 = LevelTitle
													TeamName2 = objTeamName2.item(0).text
													TeamScore2 = FormatNumber(CDbl(objTeamScore2.item(0).text) + BaseScore2, 2)
													TeamPMR2 = CInt(objTeamPMR2.item(0).text)

													If LevelID = 1 Then

														TeamPMRColor2 = "success"
														If TeamPMR2 < 396 Then TeamPMRColor2 = "warning"
														If TeamPMR2 < 198 Then TeamPMRColor2 = "danger"
														TeamPMRPercent2 = (TeamPMR2 * 100) / 600

													Else

														TeamPMRColor2 = "success"
														If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
														If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"
														TeamPMRPercent2 = (TeamPMR2 * 100) / 420

													End If

													If CInt(TeamID2) = 38 Then TeamName2 = "München on Bündchen"
%>
													<li class="list-group-item team-2-box" style="padding-left: 70px; background-color: #<%= BackgroundColor %>; color: #fff; background-image: url('<%= TeamCBSLogo2 %>'); background-position: -40px -10px; background-repeat: no-repeat;">
														<span class="team-2-name" style="font-size: 26px"><b><%= TeamName2 %></b></span>
														<span class="badge team-2-score" style="font-size: 32px; color: #fff; float: right; padding-top: 0.75rem;"><%= TeamScore2 %></span>
														<div class="progress team-2-progress" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
															<div class="progress-bar progress-bar-<%= TeamPMRColor2 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent2 %>%">
																<span class="sr-only team-2-progress-sr"><%= TeamPMRPercent2 %>%</span>
															</div>
														</div>
													</li>
<%
													HitReserves = 0
													ExtraBorder = 0
													TeamRoster2 = ""
													For i = 0 to (objTeamPlayers2.length - 1)

														Set objPlayer = objTeamPlayers2.item(i)

														thisPlayerID = objPlayer.getAttribute("id")

														thisPlayerName = ""
														thisPlayerPoints = ""
														thisPlayerStatus = ""
														thisPlayerGameTimestamp = ""
														thisPlayerPMR = 0
														thisPlayerHomeGame = 2
														thisPlayerProTeam = ""
														thisPlayerPosition = ""
														thisPlayerOpponent = ""
														thisPlayerQuarter = ""
														thisPlayerQuarterTimeRemaining = ""

														Set objPlayerName = objPlayer.getElementsByTagName("fullname")
														If objPlayerName.Length > 0 Then thisPlayerName = objPlayerName.item(0).text

														Set objPlayerPoints = objPlayer.getElementsByTagName("fpts")
														If objPlayerPoints.Length > 0 Then thisPlayerPoints = objPlayerPoints.item(0).text
														If IsNumeric(thisPlayerPoints) Then thisPlayerPoints = FormatNumber(thisPlayerPoints, 2)

														Set objPlayerStatus = objPlayer.getElementsByTagName("status")
														If objPlayerStatus.Length > 0 Then thisPlayerStatus = objPlayerStatus.item(0).text

														Set objPlayerStats = objPlayer.getElementsByTagName("stats_period")
														If objPlayerStats.Length > 0 Then thisPlayerStats = objPlayerStats.item(0).text

														Set objPlayerGameTimestamp = objPlayer.getElementsByTagName("game_start_timestamp")
														If objPlayerGameTimestamp.Length > 0 Then thisPlayerGameTimestamp = objPlayerGameTimestamp.item(0).text

														Set objPlayerPMR = objPlayer.getElementsByTagName("minutes_remaining")
														If objPlayerPMR.Length > 0 Then thisPlayerPMR = CInt(objPlayerPMR.item(0).text)

														Set objPlayerHomeGame = objPlayer.getElementsByTagName("home_game")
														If objPlayerHomeGame.Length > 0 Then thisPlayerHomeGame = CInt(objPlayerHomeGame.item(0).text)

														Set objPlayerProTeam = objPlayer.getElementsByTagName("pro_team")
														If objPlayerProTeam.Length > 0 Then thisPlayerProTeam = objPlayerProTeam.item(0).text

														Set objPlayerPosition = objPlayer.getElementsByTagName("position")
														If objPlayerPosition.Length > 0 Then thisPlayerPosition = objPlayerPosition.item(0).text

														Set objPlayerOpponent = objPlayer.getElementsByTagName("opponent")
														If objPlayerOpponent.Length > 0 Then thisPlayerOpponent = objPlayerOpponent.item(0).text

														Set objPlayerQuarter = objPlayer.getElementsByTagName("quarter")
														If objPlayerQuarter.Length > 0 Then thisPlayerQuarter = objPlayerQuarter.item(0).text

														Set objPlayerQuarterTimeRemaining = objPlayer.getElementsByTagName("time_remaining")
														If objPlayerQuarterTimeRemaining.Length > 0 Then thisPlayerQuarterTimeRemaining = objPlayerQuarterTimeRemaining.item(0).text

														If thisPlayerHomeGame = 1 Then
															thisGameLine = thisPlayerProTeam & " vs. " & thisPlayerOpponent
														ElseIf thisPlayerHomeGame = 0 Then
															thisGameLine = thisPlayerProTeam & " @ " & thisPlayerOpponent
														Else
															thisGameLine = ""
														End If

														If thisPlayerHomeGame < 2 Then

															TeamRoster2 = TeamRoster2 & thisPlayerID & ","

															thisPlayerGameTimestamp = DateAdd("s", thisPlayerGameTimestamp, DateSerial(1970,1,1))
															thisPlayerGameTimestamp = DateAdd("h", -4, thisPlayerGameTimestamp)

															thisPlayerGameDay = UCase(WeekdayName(Weekday(thisPlayerGameTimestamp),True))
															thisPlayerHour = Hour(thisPlayerGameTimestamp)
															thisPlayerMinute = Minute(thisPlayerGameTimestamp)

															If thisPlayerHour > 12 Then
																AMPM = "PM"
																thisPlayerHour = thisPlayerHour - 12
															Else
																AMPM = "AM"
															End If

															If Len(thisPlayerMinute) = 1 Then thisPlayerMinute = "0" & thisPlayerMinute

														End If

														thisPlayerPMRColor = "success"
														If thisPlayerPMR < 40 Then thisPlayerPMRColor = "warning"
														If thisPlayerPMR < 20 Then thisPlayerPMRColor = "danger"
														thisPlayerPMRPercent = (thisPlayerPMR * 100) / 60

														If thisPlayerPosition = "DST" Then
															thisBackgroundPosition = "-100px 50%"
														Else
															thisBackgroundPosition = "-70px -20px"
														End If

														If (thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured") And HitReserves = 0 Then StartReserves = 1
														If thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured" Then HitReserves = 1

														If StartReserves = 1 Then Response.Write("</ul><hr style=""border-top:1px dotted #ccc;"" /><ul class=""list-group"" id=""team-2-bench"" style=""margin-bottom: 1rem;"">")
%>
														<li class="list-group-item team-2-player-<%= thisPlayerID %>" style="padding-left: 70px; background-image: url('https://sports.cbsimg.net/images/football/nfl/players/170x170/<%= thisPlayerID %>.png'); background-position: <%= thisBackgroundPosition %>; background-repeat: no-repeat;">

															<div class="row">
																<div class="col-xxs-9 col-xl-9" style="line-height: 1.5rem;">
																	<div class="player-name" style="font-size: 16px;"><b><%= thisPlayerName %></b></div>
																	<div class="d-none d-xl-block " style="line-height: 1.5rem;">
																	<%	If thisPlayerHomeGame < 2 Then %>
																		<span class="team-2-player-<%= thisPlayerID %>-gameline"><%= thisGameLine %> - <%= thisPlayerGameDay %>&nbsp;<%= thisPlayerHour %>:<%= thisPlayerMinute %><%= AMPM %></span> &mdash;
																		<span class="team-2-player-<%= thisPlayerID %>-gameposition"><%= thisPlayerQuarter %>Q&nbsp;<%= thisPlayerQuarterTimeRemaining %></span>
																	<% Else %>
																		<span class="team-2-player-<%= thisPlayerID %>-gameline">BYE</span>
																	<% End If %>
																	</div>
																</div>
																<div class="col-xxs-3 col-xl-3 text-right" style="padding-right: 1rem; text-align: right;">
																	<span class="team-2-player-<%= thisPlayerID %>-points player-points" style="font-size: 2em; background-color: #fff;"><%= thisPlayerPoints %></span>
																</div>
															</div>

															<div class="row">
																<div class="col-12 team-2-player-<%= thisPlayerID %>-stats" style="line-height: 1rem;"><%= thisPlayerStats %></div>
															</div>

															<div class="progress team-2-player-<%= thisPlayerID %>-progress" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
																<div class="progress-bar progress-bar-<%= thisPlayerPMRColor %>" role="progressbar" aria-valuenow="<%= thisPlayerPMRPercent %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= thisPlayerPMRPercent %>%; ">
																	<span class="sr-only team-2-progress-sr"><%= thisPlayerPMRPercent %>%</span>
																</div>
															</div>

														</li>
<%
														If StartReserves = 1 Then StartReserves = 0

													Next

													If Right(TeamRoster2, 1) = "," Then TeamRoster2 = Left(TeamRoster2, Len(TeamRoster2)-1)
%>
												</ul>

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

		<script src="/assets/plugins/countUp/countUp.min.js" type="text/javascript"></script>
		<script src="/assets/plugins/howler/howler.min.js" type="text/javascript"></script>

		<!--#include virtual="/assets/js/matchup.asp"-->

	</body>

</html>
