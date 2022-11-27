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

		<title>Sportsbook / League of Levels</title>

		<meta name="description" content="Active matchups available for gambling. Wager options include moneyline, point spread, and over/under totals. Schmeckles are the primary currency used in the Sportsbook and matchups consist of active LOL games within the 70/30 probability window." />

		<meta property="og:site_name" content="League of Levels" />
		<meta property="og:url" content="https://www.leagueoflevels.com/sportsbook/" />
		<meta property="og:title" content="Sportsbook / League of Levels" />
		<meta property="og:description" content="Active matchups available for gambling. Wager options include moneyline, point spread, and over/under totals. Schmeckles are the primary currency used in the Sportsbook and matchups consist of active LOL games within the 70/30 probability window." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/sportsbook/" />
		<meta name="twitter:title" content="Sportsbook / League of Levels" />
		<meta name="twitter:description" content="Active matchups available for gambling. Wager options include moneyline, point spread, and over/under totals. Schmeckles are the primary currency used in the Sportsbook and matchups consist of active LOL games within the 70/30 probability window." />

		<meta name="title" content="Sportsbook / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/sportsbook/" />

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
						sqlGetSportsbookData = "SELECT SUM(BetAmount) AS TotalActiveBetAmount, SUM(PayoutAmount) AS TotalPotentialPayout, COUNT(TicketSlipID) AS TotalActiveTickets, COUNT(DISTINCT AccountID) AS TotalBettingUsers FROM TicketSlips WHERE IsWinner IS NULL"
						Set rsSportsbookData = sqlDatabase.Execute(sqlGetSportsbookData)

						If Not rsSportsbookData.Eof Then

							thisTotalActiveBetAmount = rsSportsbookData("TotalActiveBetAmount")
							thisTotalPotentialPayout = rsSportsbookData("TotalPotentialPayout")
							thisTotalActiveTickets = rsSportsbookData("TotalActiveTickets")
							thisTotalBettingUsers = rsSportsbookData("TotalBettingUsers")

							If IsNull(thisTotalActiveBetAmount) Then thisTotalActiveBetAmount = 0
							If IsNull(thisTotalPotentialPayout) Then thisTotalPotentialPayout = 0
%>
							<div class="col-xxxl-4 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12 col-xxs-12">
								<a href="/sportsbook/tickets/" style="text-decoration: none; display: block;">
									<ul class="list-group mb-4">
										<li class="list-group-item p-0">
											<h4 class="text-left bg-dark text-white p-3 mt-0 mb-0 rounded-top"><b>ACTIVE BOOK STATS</b><span class="float-right dripicons-graph-pie"></i></h4>
										</li>
										<li class="list-group-item rounded-0">
											<span class="float-right"><%= FormatNumber(thisTotalActiveBetAmount, 0) %></span>
											<div><b>TOTAL SCHMECKLES BET</b></div>
											<div>Across <%= thisTotalActiveTickets %> Individual Active Ticket Slips</div>
										</li>
										<li class="list-group-item">
											<span class="float-right"><%= FormatNumber(thisTotalPotentialPayout, 0) %></span>
											<div><b>TOTAL POTENTIAL PAYOUT</b></div>
											<div>Across <%= thisTotalBettingUsers %> LOL Owner Accounts</div>
										</li>
									</ul>
								</a>
							</div>
<%
							rsSportsbookData.Close
							Set rsSportsbookData = Nothing

						End If
%>
						<div class="col-xxxl-4 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12 col-xxs-12">
<%
							If Request.QueryString("action") = "switch" Then

								Session.Contents("switchNFL") = 0
								Session.Contents("switchOMEGA") = 0
								Session.Contents("switchSLFFL") = 0
								Session.Contents("switchFLFFL") = 0
								Session.Contents("switchNEXT") = 0

								thisNFL = Request.QueryString("NFL")
								thisOMEGA = Request.QueryString("OMEGA")
								thisSLFFL = Request.QueryString("SLFFL")
								thisFLFFL = Request.QueryString("FLFFL")
								thisNEXT = Request.QueryString("NEXT")

								If thisNFL = 1 Then Session.Contents("switchNFL") = 1
								If thisOMEGA = 1 Then Session.Contents("switchOMEGA") = 1
								If thisSLFFL = 1 Then Session.Contents("switchSLFFL") = 1
								If thisFLFFL = 1 Then Session.Contents("switchFLFFL") = 1
								If thisNEXT = 1 Then Session.Contents("switchNEXT") = 1

							End If
%>
							<form action="/sportsbook/" method="get">
								<input type="hidden" name="action" value="switch" />
								<div class="form-check form-check-inline">
									<div class="btn btn-dark mb-3">
										<div class="custom-control custom-switch">
											<input type="checkbox" class="custom-control-input" id="switchNFL" name="NFL" value="1" <% If Session.Contents("switchNFL") = 1 Then %>checked<% End If %>>
											<label class="custom-control-label text-white" for="switchNFL">NFL LEVEL</label>
										</div>
									</div>
								</div>
								<div class="form-check form-check-inline">
									<div class="btn btn-dark mb-3">
										<div class="custom-control custom-switch">
											<input type="checkbox" class="custom-control-input" id="switchOMEGA" name="OMEGA" value="1" <% If Session.Contents("switchOMEGA") = 1 Then %>checked<% End If %>>
											<label class="custom-control-label text-white" for="switchOMEGA">OMEGA LEVEL</label>
										</div>
									</div>
								</div>
								<div class="form-check form-check-inline">
									<div class="btn btn-dark mb-3">
										<div class="custom-control custom-switch">
											<input type="checkbox" class="custom-control-input" id="switchSLFFL" name="SLFFL" value="1" <% If Session.Contents("switchSLFFL") = 1 Then %>checked<% End If %>>
											<label class="custom-control-label text-white" for="switchSLFFL">SAME LEVEL</label>
										</div>
									</div>
								</div>
								<div class="form-check form-check-inline">
									<div class="btn btn-dark mb-3">
										<div class="custom-control custom-switch">
											<input type="checkbox" class="custom-control-input" id="switchFLFFL" name="FLFFL" value="1" <% If Session.Contents("switchFLFFL") = 1 Then %>checked<% End If %>>
											<label class="custom-control-label text-white" for="switchFLFFL">FARM LEVEL</label>
										</div>
									</div>
								</div>
								<div class="form-check form-check-inline">
									<div class="btn btn-dark mb-4">
										<div class="custom-control custom-switch">
											<input type="checkbox" class="custom-control-input" id="switchNEXT" name="NEXT" value="1" <% If Session.Contents("switchNEXT") = 1 Then %>checked<% End If %>>
											<label class="custom-control-label text-white" for="switchNEXT">NEXT LEVEL CUP</label>
										</div>
									</div>
								</div>
								<button class="btn btn-info">UPDATE</button>
                            </form>

						</div>

					</div>

					<div class="row mb-3">
<%
					currentLevel = -1

					sqlGetWeek = "SELECT * FROM ( "
						sqlGetWeek = sqlGetWeek & "SELECT MatchupID AS LOLMatchupID, NULL AS NFLGameID, Matchups.LevelID, Year, Period, NULL AS DateTimeEST, TeamID2 AS AwayTeamID, TeamID1 AS HomeTeamID, Team2.TeamName AS AwayTeam, Team1.TeamName AS HomeTeam, TeamScore2 AS AwayScore, TeamScore1 AS HomeScore, TeamPMR2 AS AwayPMR, TeamPMR1 AS HomePMR, Leg, TeamProjected2 AS AwayProjection, TeamProjected1 AS HomeProjection, TeamWinPercentage2 AS AwayPercentage, TeamWinPercentage1 AS HomePercentage, TeamMoneyline2 AS AwayMoneyline, TeamMoneyline1 AS HomeMoneyline, TeamSpread2 AS AwaySpread, TeamSpread1 AS HomeSpread, TeamProjected1 + TeamProjected2 AS OverUnderTotal, NULL AS Boost_AwayTeamMoneyline, NULL AS Boost_HomeTeamMoneyline, NULL AS Boost_AwayTeamSpread, NULL AS Boost_HomeTeamSpread, NULL AS Boost_AwayTeamSpreadMoneyline, NULL AS Boost_HomeTeamSpreadMoneyline, NULL AS Boost_OverUnderTotal, NULL AS Boost_OverTotalMoneyline, NULL AS Boost_UnderTotalMoneyline "
						sqlGetWeek = sqlGetWeek & "FROM Matchups "
						sqlGetWeek = sqlGetWeek & "INNER JOIN Teams AS Team1 ON Team1.TeamID = Matchups.TeamID1 "
						sqlGetWeek = sqlGetWeek & "INNER JOIN Teams AS Team2 ON Team2.TeamID = Matchups.TeamID2 "
						sqlGetWeek = sqlGetWeek & "UNION ALL "
						sqlGetWeek = sqlGetWeek & "SELECT NULL AS LOLMatchupID, NFLGameID, -1 AS LevelID, Year, Period, DateTimeEST, AwayTeamID, HomeTeamID, A.City + ' ' + A.Name AS AwayTeam, B.City + ' ' + B.Name AS HomeTeam, AwayTeamScore AS AwayScore, HomeTeamScore AS HomeScore, NULL AS HomePMR, NULL AS AwayPMR, NULL AS Leg, ((OverUnderTotal / 2) + (HomeTeamSpread / 2)) AS AwayProjection, ((OverUnderTotal / 2) + (AwayTeamSpread / 2)) AS HomeProjection, NULL AS AwayPercentage, NULL AS HomePercentage, AwayTeamMoneyline AS AwayMoneyline, HomeTeamMoneyline AS HomeMoneyline, AwayTeamSpread AS AwaySpread, HomeTeamSpread AS HomeSpread, OverUnderTotal, Boost_AwayTeamMoneyline, Boost_HomeTeamMoneyline, Boost_AwayTeamSpread, Boost_HomeTeamSpread, Boost_AwayTeamSpreadMoneyline, Boost_HomeTeamSpreadMoneyline, Boost_OverUnderTotal, Boost_OverTotalMoneyline, Boost_UnderTotalMoneyline "
						sqlGetWeek = sqlGetWeek & "FROM NFLGames "
						sqlGetWeek = sqlGetWeek & "INNER JOIN NFLTeams A ON A.NFLTeamID = NFLGames.AwayTeamID "
						sqlGetWeek = sqlGetWeek & "INNER JOIN NFLTeams B ON B.NFLTeamID = NFLGames.HomeTeamID "
					sqlGetWeek = sqlGetWeek & ") SportsbookWeek "
					sqlGetWeek = sqlGetWeek & "WHERE Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & " "
					If Session.Contents("switchNFL") = 1 Or Session.Contents("switchOMEGA") = 1 Or Session.Contents("switchNEXT") = 1 Or Session.Contents("switchSLFFL") = 1 Or Session.Contents("switchFLFFL") = 1 Then
						sqlGetWeek = sqlGetWeek & "AND LevelID IN ("
						If Session.Contents("switchNFL") Then sqlGetWeek = sqlGetWeek & "-1,"
						If Session.Contents("switchOMEGA") Then sqlGetWeek = sqlGetWeek & "1,"
						If Session.Contents("switchNEXT") Then sqlGetWeek = sqlGetWeek & "0,"
						If Session.Contents("switchSLFFL") Then sqlGetWeek = sqlGetWeek & "2,"
						If Session.Contents("switchFLFFL") Then sqlGetWeek = sqlGetWeek & "3,"
						If Right(sqlGetWeek, 1) = "," Then sqlGetWeek = Left(sqlGetWeek, Len(sqlGetWeek)-1)
						sqlGetWeek = sqlGetWeek & ")"
					End If
					sqlGetWeek = sqlGetWeek & "ORDER BY LevelID, DateTimeEST"
					Set rsWeek = sqlDatabase.Execute(sqlGetWeek)

					Do While Not rsWeek.Eof

						thisLOLMatchupID = rsWeek("LOLMatchupID")
						thisNFLGameID = rsWeek("NFLGameID")
						thisLevelID = rsWeek("LevelID")
						thisYear = rsWeek("Year")
						thisPeriod = rsWeek("Period")
						thisDateTimeEST = rsWeek("DateTimeEST")
						thisAwayTeamID = rsWeek("AwayTeamID")
						thisHomeTeamID = rsWeek("HomeTeamID")
						thisAwayTeam = rsWeek("AwayTeam")
						thisHomeTeam = rsWeek("HomeTeam")
						thisAwayScore = rsWeek("AwayScore")
						thisHomeScore = rsWeek("HomeScore")
						thisAwayPMR = rsWeek("AwayPMR")
						thisHomePMR = rsWeek("HomePMR")
						thisLeg = rsWeek("Leg")
						thisAwayProjection = rsWeek("AwayProjection")
						thisHomeProjection = rsWeek("HomeProjection")
						thisAwayPercentage = rsWeek("AwayPercentage")
						thisHomePercentage = rsWeek("HomePercentage")
						thisAwayMoneyline = rsWeek("AwayMoneyline")
						thisHomeMoneyline = rsWeek("HomeMoneyline")
						thisAwaySpread = rsWeek("AwaySpread")
						thisHomeSpread = rsWeek("HomeSpread")
						thisOverUnderTotal = rsWeek("OverUnderTotal")
						thisBoost_AwayTeamMoneyline = rsWeek("Boost_AwayTeamMoneyline")
						thisBoost_HomeTeamMoneyline = rsWeek("Boost_HomeTeamMoneyline")
						thisBoost_AwayTeamSpread = rsWeek("Boost_AwayTeamSpread")
						thisBoost_HomeTeamSpread = rsWeek("Boost_HomeTeamSpread")
						thisBoost_AwayTeamSpreadMoneyline = rsWeek("Boost_AwayTeamSpreadMoneyline")
						thisBoost_HomeTeamSpreadMoneyline = rsWeek("Boost_HomeTeamSpreadMoneyline")
						thisBoost_OverUnderTotal = rsWeek("Boost_OverUnderTotal")
						thisBoost_OverTotalMoneyline = rsWeek("Boost_OverTotalMoneyline")
						thisBoost_UnderTotalMoneyline = rsWeek("Boost_UnderTotalMoneyline")

						If thisHomeMoneyline > 0 Then thisHomeMoneyline = "+" & thisHomeMoneyline
						If thisAwayMoneyline > 0 Then thisAwayMoneyline = "+" & thisAwayMoneyline

						If thisHomeSpread > 0 Then thisHomeSpread = "+" & thisHomeSpread
						If thisAwaySpread > 0 Then thisAwaySpread = "+" & thisAwaySpread

						thisMatchupLink = "/sportsbook/" & thisLOLMatchupID & "/"

						If CInt(thisLevelID) = 0 Then
							headerBGcolor = "D00000"
							headerTextColor = "fff"
							headerText = "NEXT LEVEL CUP #" & thisLOLMatchupID
							cardText = "520000"
						End If
						If CInt(thisLevelID) = 1 Then
							headerBGcolor = "FFBA08"
							headerTextColor = "fff"
							headerText = "OMEGA LEVEL #" & thisLOLMatchupID
							cardText = "805C04"
						End If
						If CInt(thisLevelID) = 2 Then
							headerBGcolor = "136F63"
							headerTextColor = "fff"
							headerText = "SAME LEVEL #" & thisLOLMatchupID
							cardText = "0F574D"
						End If
						If CInt(thisLevelID) = 3 Then
							headerBGcolor = "032B43"
							headerTextColor = "fff"
							headerText = "FARM LEVEL #" & thisLOLMatchupID
							cardText = "03324F"
						End If

						If CInt(thisLevelID) = -1 Then

							thisWeekday = WeekdayName(Weekday(CDate(thisDateTimeEST)))
							arrThisDateTime = Split(thisDateTimeEST, " ")
							thisDate = arrThisDateTime(0)
							thisTime = arrThisDateTime(1)
							thisAMPM = arrThisDateTime(2)

							arrThisDate = Split(thisDate, "/")
							thisMonth = arrThisDate(0)
							thisMonthName = MonthName(thisMonth)
							thisDay = CInt(arrThisDate(1))

							Select Case thisDay
							Case 1,21,31
								thisDayExt = "st"
							Case 2,22
								thisDayExt = "nd"
							Case 3,23
								thisDayExt = "rd"
							Case Else
								thisDayExt = "th"
							End Select

							arrThisTime = Split(thisTime, ":")
							thisHour = arrThisTime(0)
							thisMinute = arrThisTime(1)

							headerBGcolor = "2f4686"
							headerTextColor = "fff"
							headerText = thisWeekday & ",&nbsp;" & thisMonthName & "&nbsp;" & thisDay & thisDayExt & " @ " & thisHour & ":" & thisMinute & "&nbsp;" & thisAMPM & " (EST)"
							cardText = "03324F"

							thisCalculateWinPercentage = CalculateWinPercentage(100, 100, thisAwayProjection, thisHomeProjection, 0, 0)
							arrWinPercentages = Split(thisCalculateWinPercentage, "/")
							thisHomePercentage = arrWinPercentages(1) & "%"
							thisAwayPercentage = arrWinPercentages(0) & "%"

							'thisAwayProjection = FormatNumber(thisAwayProjection, 1)
							'thisHomeProjection = FormatNumber(thisHomeProjection, 1)

							thisMatchupLink = "/sportsbook/nfl/" & thisNFLGameID & "/"

						Else

							thisAwayPercentage = (thisAwayPercentage * 100) & "%"
							thisHomePercentage = (thisHomePercentage * 100) & "%"

						End If

						BoostText = ""
						If IsNumeric(thisBoost_AwayTeamMoneyline) Or IsNumeric(thisBoost_HomeTeamMoneyline) Or IsNumeric(thisBoost_AwayTeamSpread) Or IsNumeric(thisBoost_HomeTeamSpread) Or IsNumeric(thisBoost_AwayTeamSpreadMoneyline) Or IsNumeric(thisBoost_HomeTeamSpreadMoneyline) Or IsNumeric(thisBoost_OverUnderTotal) Or IsNumeric(thisBoost_OverTotalMoneyline) Or IsNumeric(thisBoost_UnderTotalMoneyline) Then
							BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
						End If
%>
						<div class="col-xxxl-3 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12 col-xxs-12">
							<a href="<%= thisMatchupLink %>" style="text-decoration: none; display: block;">
								<ul class="list-group mb-3">
									<li class="list-group-item pt-1 pb-1" style="background-color: #<%= headerBGcolor %>; color: #<%= headerTextColor %>;">
										<div style="position: absolute; top: -10px; right: -10px;"><%= BoostText %></div>
										<small><b><%= headerText %></b></small>
									</li>
									<li class="list-group-item">
										<span class="float-right"><%= thisTeamScore1 %></span>
										<div><b><%= thisAwayTeam %></b></div>
										<div><%= thisAwayProjection %> Proj., <%= thisAwayPercentage %> Win, <%= thisAwaySpread %> Spread, <%= thisAwayMoneyline %> ML</div>
									</li>
									<li class="list-group-item">
										<span class="float-right"><%= thisTeamScore2 %></span>
										<div><b><%= thisHomeTeam %></b></div>
										<div><%= thisHomeProjection %> Proj., <%= thisHomePercentage %> Win, <%= thisHomeSpread %> Spread, <%= thisHomeMoneyline %> ML</div>
									</li>
								</ul>
							</a>
						</div>
<%
						rsWeek.MoveNext

					Loop

					rsWeek.Close
					Set rsWeek = Nothing
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

	</body>

</html>
