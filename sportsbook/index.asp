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

					sqlGetSchedules = "SELECT MatchupID, Matchups.LevelID, Year, Period, IsPlayoffs, TeamID1, TeamID2, Team1.TeamName AS TeamName1, Team2.TeamName AS TeamName2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2, Leg, TeamProjected1, TeamProjected2, TeamWinPercentage1, TeamWinPercentage2, TeamMoneyline1, TeamMoneyline2, TeamSpread1, TeamSpread2 FROM Matchups "
					sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team1 ON Team1.TeamID = Matchups.TeamID1 "
					sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team2 ON Team2.TeamID = Matchups.TeamID2 "
					sqlGetSchedules = sqlGetSchedules & "WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.Period = " & Session.Contents("CurrentPeriod") & " AND (TeamPMR1 > 0 OR TeamPMR2 > 0) AND (TeamWinPercentage1 >= 0.30 AND TeamWinPercentage1 <= 0.70)  AND (TeamWinPercentage2 >= 0.30 AND TeamWinPercentage2 <= 0.70) AND "

					If Session.Contents("switchOMEGA") = 1 Or Session.Contents("switchNEXT") = 1 Or Session.Contents("switchSLFFL") = 1 Or Session.Contents("switchFLFFL") = 1 Then

						sqlGetSchedules = sqlGetSchedules & "Matchups.LevelID IN ("
						If Session.Contents("switchOMEGA") Then sqlGetSchedules = sqlGetSchedules & "1,"
						If Session.Contents("switchNEXT") Then sqlGetSchedules = sqlGetSchedules & "0,"
						If Session.Contents("switchSLFFL") Then sqlGetSchedules = sqlGetSchedules & "2,"
						If Session.Contents("switchFLFFL") Then sqlGetSchedules = sqlGetSchedules & "3,"
						If Right(sqlGetSchedules, 1) = "," Then sqlGetSchedules = Left(sqlGetSchedules, Len(sqlGetSchedules)-1)
						sqlGetSchedules = sqlGetSchedules & ")"

					Else

						sqlGetSchedules = sqlGetSchedules & " 1 = 0 "

					End If

					sqlGetSchedules = sqlGetSchedules & "ORDER BY CASE WHEN Matchups.LevelID = 1 THEN '1' WHEN Matchups.LevelID = 0 THEN '2' WHEN Matchups.LevelID = 2 THEN '3' WHEN Matchups.LevelID = 3 THEN '4' ELSE Matchups.LevelID END ASC, Matchups.MatchupID ASC"
					Set rsSchedules = sqlDatabase.Execute(sqlGetSchedules)

					Do While Not rsSchedules.Eof

						thisMatchupID = rsSchedules("MatchupID")
						thisLevelID = rsSchedules("LevelID")
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

						thisTeamWinPercentage1 = (thisTeamWinPercentage1 * 100) & "%"
						thisTeamWinPercentage2 = (thisTeamWinPercentage2 * 100) & "%"

						If thisTeamMoneyline1 > 0 Then thisTeamMoneyline1 = "+" & thisTeamMoneyline1
						If thisTeamMoneyline2 > 0 Then thisTeamMoneyline2 = "+" & thisTeamMoneyline2

						If thisTeamSpread1 > 0 Then thisTeamSpread1 = "+" & thisTeamSpread1
						If thisTeamSpread2 > 0 Then thisTeamSpread2 = "+" & thisTeamSpread2

						If CInt(thisLevelID) <> currentLevel Then

							currentLevel = thisLevelID

							If CInt(thisLevelID) = 0 Then
								headerBGcolor = "D00000"
								headerTextColor = "fff"
								headerText = "NEXT LEVEL CUP"
								cardText = "520000"
							End If
							If CInt(thisLevelID) = 1 Then
								headerBGcolor = "FFBA08"
								headerTextColor = "fff"
								headerText = "OMEGA LEVEL"
								cardText = "805C04"
							End If
							If CInt(thisLevelID) = 2 Then
								headerBGcolor = "136F63"
								headerTextColor = "fff"
								headerText = "SAME LEVEL"
								cardText = "0F574D"
							End If
							If CInt(thisLevelID) = 3 Then
								headerBGcolor = "032B43"
								headerTextColor = "fff"
								headerText = "FARM LEVEL"
								cardText = "03324F"
							End If

						End If
%>
						<div class="col-xxxl-3 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12 col-xxs-12">
							<a href="/sportsbook/<%= thisMatchupID %>/" style="text-decoration: none; display: block;">
								<ul class="list-group mb-3">
									<li class="list-group-item pt-1 pb-1" style="background-color: #<%= headerBGcolor %>; color: #<%= headerTextColor %>;"><small><b><%= headerText %> #<%= thisMatchupID %></b></small></li>
									<li class="list-group-item">
										<span class="float-right"><%= thisTeamScore1 %></span>
										<div><b><%= thisTeamName1 %></b></div>
										<div><%= thisTeamProjected1 %> Proj., <%= thisTeamWinPercentage1 %> Win, <%= thisTeamSpread1 %> Spread, <%= thisTeamMoneyline1 %> ML</div>
									</li>
									<li class="list-group-item">
										<span class="float-right"><%= thisTeamScore2 %></span>
										<div><b><%= thisTeamName2 %></b></div>
										<div><%= thisTeamProjected2 %> Proj., <%= thisTeamWinPercentage2 %> Win, <%= thisTeamSpread2 %> Spread, <%= thisTeamMoneyline2 %> ML</div>
									</li>
								</ul>
							</a>
						</div>
<%
						rsSchedules.MoveNext

					Loop

					rsSchedules.Close
					Set rsSchedules = Nothing

					If Session.Contents("switchNFL") = 1 Then

						sqlGetNFLGames = "SELECT NFLGameID, Year, Period, DateTimeEST, AwayTeamID, HomeTeamID, A.City + ' ' + A.Name AS AwayTeam, B.City + ' ' + B.Name AS HomeTeam, AwayTeamMoneyline, HomeTeamMoneyline, AwayTeamSpread, HomeTeamSpread, OverUnderTotal, Boost_AwayTeamMoneyline, Boost_HomeTeamMoneyline, Boost_AwayTeamSpread, Boost_HomeTeamSpread, Boost_AwayTeamSpreadMoneyline, Boost_HomeTeamSpreadMoneyline, Boost_OverUnderTotal, Boost_OverTotalMoneyline, Boost_UnderTotalMoneyline FROM NFLGames "
						sqlGetNFLGames = sqlGetNFLGames & "INNER JOIN NFLTeams A ON A.NFLTeamID = NFLGames.AwayTeamID "
						sqlGetNFLGames = sqlGetNFLGames & "INNER JOIN NFLTeams B ON B.NFLTeamID = NFLGames.HomeTeamID "
						sqlGetNFLGames = sqlGetNFLGames & "WHERE NFLGames.Year = " & Session.Contents("CurrentYear") & " AND NFLGames.Period = " & Session.Contents("CurrentPeriod") & " AND NFLGames.DateTimeEST > '" & DateAdd("h", -4, Now()) & "' "
						sqlGetNFLGames = sqlGetNFLGames & "ORDER BY NFLGames.DateTimeEST ASC"
						Set rsSchedules = sqlDatabase.Execute(sqlGetNFLGames)

						Do While Not rsSchedules.Eof

							thisMatchupID = rsSchedules("NFLGameID")
							thisDateTimeEST = rsSchedules("DateTimeEST")
							thisTeamName1 = rsSchedules("AwayTeam")
							thisTeamName2 = rsSchedules("HomeTeam")
							thisTeamMoneyline1 = rsSchedules("AwayTeamMoneyline")
							thisTeamMoneyline2 = rsSchedules("HomeTeamMoneyline")
							thisTeamSpread1 = rsSchedules("AwayTeamSpread")
							thisTeamSpread2 = rsSchedules("HomeTeamSpread")
							thisOverUnderTotal = rsSchedules("OverUnderTotal")

							thisBoostTeamMoneyline1 = rsSchedules("Boost_AwayTeamMoneyline")
							thisBoostTeamMoneyline2 = rsSchedules("Boost_HomeTeamMoneyline")
							thisBoostTeamSpread1 = rsSchedules("Boost_AwayTeamSpread")
							thisBoostTeamSpread2 = rsSchedules("Boost_HomeTeamSpread")
							thisBoostOverUnderTotal = rsSchedules("Boost_OverUnderTotal")

							thisBoostTeamSpreadMoneyline1 = rsSchedules("Boost_AwayTeamSpreadMoneyline")
							thisBoostTeamSpreadMoneyline2 = rsSchedules("Boost_HomeTeamSpreadMoneyline")
							thisBoostOverTotalMoneyline = rsSchedules("Boost_OverTotalMoneyline")
							thisBoostUnderTotalMoneyline = rsSchedules("Boost_UnderTotalMoneyline")

							thisTeamProjected1 = (thisOverUnderTotal / 2) + (CDbl(thisTeamSpread1) / 2)
							thisTeamProjected2 = (thisOverUnderTotal / 2) + (CDbl(thisTeamSpread2) / 2)

							'thisCalculateWinPercentage = homeWinProbability & "/" & awayWinProbability
							thisCalculateWinPercentage = CalculateWinPercentage(100, 100, thisTeamProjected1, thisTeamProjected2, 0, 0)
							arrWinPercentages = Split(thisCalculateWinPercentage, "/")
							thisTeamWinPercentage2 = arrWinPercentages(0) & "%"
							thisTeamWinPercentage1 = arrWinPercentages(1) & "%"

							If thisTeamMoneyline1 > 0 Then thisTeamMoneyline1 = "+" & thisTeamMoneyline1
							If thisTeamMoneyline2 > 0 Then thisTeamMoneyline2 = "+" & thisTeamMoneyline2

							If thisTeamSpread1 Then thisTeamProjected1 = (thisOverUnderTotal / 2) - (CDbl(thisTeamSpread1) / 2)
							If thisTeamSpread2 Then thisTeamProjected2 = (thisOverUnderTotal / 2) - (CDbl(thisTeamSpread2) / 2)

							If thisTeamSpread1 > 0 Then thisTeamSpread1 = "+" & thisTeamSpread1
							If thisTeamSpread2 > 0 Then thisTeamSpread2 = "+" & thisTeamSpread2

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
							headerText = "NFL"
							cardText = "03324F"

							thisBoostTeamMoneyline1 = rsSchedules("Boost_AwayTeamMoneyline")
							thisBoostTeamMoneyline2 = rsSchedules("Boost_HomeTeamMoneyline")
							thisBoostTeamSpread1 = rsSchedules("Boost_AwayTeamSpread")
							thisBoostTeamSpread2 = rsSchedules("Boost_HomeTeamSpread")
							thisBoostOverUnderTotal = rsSchedules("Boost_OverUnderTotal")

							thisBoostTeamSpreadMoneyline1 = rsSchedules("Boost_AwayTeamSpreadMoneyline")
							thisBoostTeamSpreadMoneyline2 = rsSchedules("Boost_HomeTeamSpreadMoneyline")
							thisBoostOverTotalMoneyline = rsSchedules("Boost_OverTotalMoneyline")
							thisBoostUnderTotalMoneyline = rsSchedules("Boost_UnderTotalMoneyline")


							BoostText = ""
							If IsNumeric(thisBoostTeamMoneyline1) Or IsNumeric(thisBoostTeamMoneyline2) Or IsNumeric(thisBoostTeamSpread1) Or IsNumeric(thisBoostTeamSpread2) Or IsNumeric(thisBoostOverUnderTotal) Or IsNumeric(thisBoostOverTotalMoneyline) Or IsNumeric(thisBoostUnderTotalMoneyline) Or IsNumeric(thisBoostTeamSpreadMoneyline1) Or IsNumeric(thisBoostTeamSpreadMoneyline2) Then BoostText = "<span class=""badge badge-pill badge-warning"" title=""Boosted"">BOOSTED</span>"
%>
							<div class="col-xxxl-3 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12 col-xxs-12">
								<a href="/sportsbook/nfl/<%= thisMatchupID %>/" style="text-decoration: none; display: block;">

									<ul class="list-group mb-3">
										<li class="list-group-item pt-1 pb-1" style="background-color: #<%= headerBGcolor %>; color: #<%= headerTextColor %>; position: relative;">
											<div style="position: absolute; top: -10px; right: -10px;"><%= BoostText %></div>
											<small><b><%= thisWeekday %>,&nbsp;<%= thisMonthName %>&nbsp;<%= thisDay & thisDayExt %> @ <%= thisHour %>:<%= thisMinute %>&nbsp;<%= thisAMPM %></b></small>
										</li>
										<li class="list-group-item rounded-0">
											<div><b><%= thisTeamName1 %></b></div>
											<div><%= thisTeamProjected1 %> Proj., <%= thisTeamWinPercentage1 %> Win, <%= thisTeamSpread1 %> Spread, <%= thisTeamMoneyline1 %> ML</div>
										</li>
										<li class="list-group-item">
											<div><b><%= thisTeamName2 %></b></div>
											<div><%= thisTeamProjected2 %> Proj., <%= thisTeamWinPercentage2 %> Win, <%= thisTeamSpread2 %> Spread, <%= thisTeamMoneyline2 %> ML</div>
										</li>
									</ul>
								</a>
							</div>
<%
							rsSchedules.MoveNext

						Loop

						rsSchedules.Close
						Set rsSchedules = Nothing

					End If
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
