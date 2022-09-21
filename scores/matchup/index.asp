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
				.gamestats { display: none !important; }
			}

			@media (max-width:768px) {
				.page-content { padding: 0 !important; padding-bottom: 2rem !important; }

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

							<div class="col-6 col-lg-4 p-0">

								<ul class="list-group" id="team-1-roster" style="margin-bottom: 1rem;">
<%
									BaseScore1 = 0
									BaseScore2 = 0

									'CUP LEVEL'
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
									<li class="list-group-item team-1-box m-0 p-0" style="background-color: #<%= BackgroundColor %>; color: #fff;border-radius: 0; border-top-left-radius: 5px;">
										<div class="row p-0 py-2 m-0">
											<div class="col-6 col-lg-1 mr-0 p-0 pl-3 pt-2">
												<span><img src="<%= TeamCBSLogo1 %>" width="32" alt="<%= TeamName1 %>" class="rounded-circle" /></span>
											</div>
											<div class="col-8 pl-lg-4 d-none d-lg-block"><h4><%= TeamName1 %></h4></div>
											<div class="col-6 col-lg-3 p-0 pt-2 pr-1 text-right">
												<div><span class="badge team-1-score pt-0 text-right" style="font-size: 20px; color: #fff;"><%= TeamScore1 %></span></div>
												<div><span class="badge team-1-score pt-0 text-right" style="font-size: 10px; color: #fff;"><%= TeamPMR1 %> PMR</span></div>
											</div>
										</div>
									</li>

									<li class="list-group-item d-block d-lg-none py-1 px-3 px-md-2 bg-light">

										<h6><b><%= TeamName1 %></b></h6>

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

										thisFirstInitial = Left(thisPlayerName, 1)
										thisLastName = ""
										arrPlayerName = Split(thisPlayerName, " ")

										For x = 0 to UBound(arrPlayerName)
											If x > 0 Then
												thisLastName = thisLastName & " " & arrPlayerName(x)
											End If
										Next

										If (thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured") And HitReserves = 0 Then StartReserves = 1
										If thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured" Then HitReserves = 1

										If StartReserves = 1 Then
%>
											<li class="list-group-item py-1 px-3 bg-light">

												<h6><b>BENCH PLAYERS</b></h6>

											</li>
<%
										End If
%>
										<li class="list-group-item team-1-player-<%= thisPlayerID %> pl-4 pl-md-3 pt-3 pr-3" <% If thisPlayerPMR = 0 Then %>style="background-color:#fafafa;"<% End If %>>

											<div class="row">
												<div class="col-1 d-none d-lg-block m-0 p-0">
													<span><img src="https://sports.cbsimg.net/images/football/nfl/players/170x170/<%= thisPlayerID %>.png" width="40" alt="<%= thisPlayerName %>" class="rounded-circle" /></span>
												</div>
												<div class="col-9 col-lg-9 p-0 pl-lg-3 pb-0 m-0">
													<div class="player-name"><b><% If thisPlayerPosition = "DST" Then %><%= thisPlayerName %><% Else %><%= thisFirstInitial %>. <%= thisLastName %><% End If %></b></div>
													<div class="d-none d-lg-block m-0 p-0">
<%
														If thisPlayerHomeGame < 2 Then

															If thisPlayerQuarter > 1 Then
%>
																<div class="pl-0 pb-1"><% If thisPlayerPMR > 0 Then %><span class="bg-success text-white pl-1 pr-1 ml-1 rounded float-right"><%= thisPlayerQuarter %>Q <%= thisPlayerQuarterTimeRemaining %></span> <% End If %><%= thisPlayerStats %></div>
<%
															Else
%>
																<div class="team-1-player-<%= thisPlayerID %>-gameline pl-0 pb-1"><%= thisGameLine %> - <%= thisPlayerGameDay %>&nbsp;<%= thisPlayerHour %>:<%= thisPlayerMinute %><%= AMPM %></div>
<%
															End If

														Else
%>
															<span class="team-1-player-<%= thisPlayerID %>-gameline">BYE</span>
<%
														End If
%>
													</div>
												</div>
												<div class="col-3 col-lg-2 p-0 m-0 text-right">
													<span class="team-1-player-<%= thisPlayerID %>-points player-points text-right font-weight-bold"><%= thisPlayerPoints %></span>
												</div>

											</div>

											<div class="row d-block d-lg-none pt-0 pb-0 pr-1 pl-0">
												<div class="col-12 p-0 pl-0 pt-1 pb-0 pr-0">
<%
													If thisPlayerHomeGame < 2 Then

														If thisPlayerQuarter > 1 Then
%>
															<div class="pl-0 pb-1"><% If thisPlayerPMR > 0 Then %><span class="bg-success text-white pl-1 pr-1 ml-1 rounded float-right"><%= thisPlayerQuarter %>Q <%= thisPlayerQuarterTimeRemaining %></span> <% End If %><%= thisPlayerStats %></div>
<%
														Else
%>
															<div class="team-1-player-<%= thisPlayerID %>-gameline pl-0 pb-1"><%= thisGameLine %> - <%= thisPlayerGameDay %>&nbsp;<%= thisPlayerHour %>:<%= thisPlayerMinute %><%= AMPM %></div>
<%
														End If

													Else
%>
														<span class="team-1-player-<%= thisPlayerID %>-gameline">BYE</span>
<%
													End If
%>
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

							<div class="col-6 col-lg-4 p-0">

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
									<li class="list-group-item team-2-box m-0 p-0" style="background-color: #<%= BackgroundColor %>; color: #fff;border-radius: 0; border-top-right-radius: 5px;">
										<div class="row p-0 py-2 m-0">
											<div class="col-6 col-lg-3 pl-1 pt-2 text-left">
												<div><span class="badge team-2-score pt-0 text-left" style="font-size: 20px; color: #fff;"><%= TeamScore2 %></span></div>
												<div><span class="badge team-2-score pt-0 text-left" style="font-size: 10px; color: #fff;"><%= TeamPMR2 %> PMR</span></div>
											</div>
											<div class="col-8 text-right d-none d-lg-block"><h4><%= TeamName2 %></h4></div>
											<div class="col-6 col-lg-1 mr-0 p-0 pr-3 pt-2 text-right">
												<span><img src="<%= TeamCBSLogo2 %>" width="32" alt="<%= TeamName2 %>" class="rounded-circle" /></span>
											</div>


										</div>
									</li>

									<li class="list-group-item d-block d-lg-none py-1 px-2 bg-light">

										<h6><b><%= TeamName2 %></b></h6>

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

										thisFirstInitial = Left(thisPlayerName, 1)
										thisLastName = ""
										arrPlayerName = Split(thisPlayerName, " ")

										For x = 0 to UBound(arrPlayerName)
											If x > 0 Then
												thisLastName = thisLastName & " " & arrPlayerName(x)
											End If
										Next

										If (thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured") And HitReserves = 0 Then StartReserves = 1
										If thisPlayerStatus = "Reserve" Or thisPlayerStatus = "Injured" Then HitReserves = 1

										If StartReserves = 1 Then
%>
											<li class="list-group-item py-1 px-2 bg-light">

												<h6><b>BENCH PLAYERS</b></h6>

											</li>
<%
										End If
%>
										<li class="list-group-item team-2-player-<%= thisPlayerID %> pl-3 pt-3" <% If thisPlayerPMR = 0 Then %>style="background-color:#fafafa;"<% End If %>>

											<div class="row">
												<div class="col-1 d-none d-lg-block m-0 p-0">
													<span><img src="https://sports.cbsimg.net/images/football/nfl/players/170x170/<%= thisPlayerID %>.png" width="40" alt="<%= thisPlayerName %>" class="rounded-circle" /></span>
												</div>
												<div class="col-9 col-lg-9 p-0 pl-lg-3 pb-0 m-0">
													<div class="player-name"><b><% If thisPlayerPosition = "DST" Then %><%= thisPlayerName %><% Else %><%= thisFirstInitial %>. <%= thisLastName %><% End If %></b></div>
													<div class="d-none d-lg-block m-0 p-0">
<%
														If thisPlayerHomeGame < 2 Then

															If thisPlayerQuarter > 1 Then
%>
																<div class="pl-0 pb-1"><% If thisPlayerPMR > 0 Then %><span class="bg-success text-white pl-1 pr-1 ml-1 rounded float-right"><%= thisPlayerQuarter %>Q <%= thisPlayerQuarterTimeRemaining %></span> <% End If %><%= thisPlayerStats %></div>
<%
															Else
%>
																<div class="team-2-player-<%= thisPlayerID %>-gameline pl-0 pb-1"><%= thisGameLine %> - <%= thisPlayerGameDay %>&nbsp;<%= thisPlayerHour %>:<%= thisPlayerMinute %><%= AMPM %></div>
<%
															End If

														Else
%>
															<span class="team-2-player-<%= thisPlayerID %>-gameline">BYE</span>
<%
														End If
%>
													</div>
												</div>
												<div class="col-3 col-lg-2 p-0 m-0 text-right">
													<span class="team-2-player-<%= thisPlayerID %>-points player-points text-right font-weight-bold"><%= thisPlayerPoints %></span>
												</div>

											</div>

											<div class="row d-block d-lg-none pt-0 pb-0 pr-1 pl-0">
												<div class="col-12 p-0 pl-0 pt-1 pb-0 pr-0">
<%
													If thisPlayerHomeGame < 2 Then

														If thisPlayerQuarter > 1 Then
%>
															<div class="pl-0 pb-1"><% If thisPlayerPMR > 0 Then %><span class="bg-success text-white pl-1 pr-1 ml-1 rounded float-right"><%= thisPlayerQuarter %>Q <%= thisPlayerQuarterTimeRemaining %></span> <% End If %><%= thisPlayerStats %></div>
<%
														Else
%>
															<div class="team-2-player-<%= thisPlayerID %>-gameline pl-0 pb-1"><%= thisGameLine %> - <%= thisPlayerGameDay %>&nbsp;<%= thisPlayerHour %>:<%= thisPlayerMinute %><%= AMPM %></div>
<%
														End If

													Else
%>
														<span class="team-2-player-<%= thisPlayerID %>-gameline">BYE</span>
<%
													End If
%>
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
