<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	thisPageTitle = "Power Rankings / League of Levels"

	thisPageDescription = "Using a proprietary algorithm to generate nonsense numbers, we have been able to somewhat adequetly rank teams across levels. Patent pending technology, obviously."
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title><%= thisPageTitle %></title>

		<meta name="description" content="<%= thisPageDescription %>" />

		<meta property="og:site_name" content="League of Levels" />
		<meta property="og:url" content="https://www.leagueoflevels.com/power-rankings/" />
		<meta property="og:title" content="<%= thisPageTitle %>" />
		<meta property="og:description" content="<%= thisPageDescription %>" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/power-rankings/" />
		<meta name="twitter:title" content="<%= thisPageTitle %>" />
		<meta name="twitter:description" content="<%= thisPageDescription %>" />

		<meta name="title" content="<%= thisPageTitle %>" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/power-rankings/" />

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

						<div class="col-12">

							<div class="card">

								<div class="card-body p-0">

									<table class="table mb-1">
										<thead>
											<tr>
												<th class="pl-3"><b>TEAM NAME</b></th>
												<th class="text-right d-none d-md-table-cell">TOTAL POINTS</th>
												<th class="text-right d-none d-sm-table-cell">ACTUAL RECORD</th>
												<th class="text-right d-none d-md-table-cell">LEVEL RECORD</th>
												<th class="text-right d-none d-md-table-cell">LOL RECORD</th>
												<th class="text-right d-none d-sm-table-cell">LUCK RATE</th>
												<th class="text-right pr-4">POWER POINTS</th>
											</tr>
										</thead>
										<tbody>
<%
											thisLastPeriod = Session.Contents("CurrentPeriod") - 1

											sqlGetLeaderboard = "SELECT ROW_NUMBER() OVER (ORDER BY SUM(PowerPoints_Points) + SUM(PowerPoints_Wins) + SUM(PowerPoints_Break) + SUM(PowerPoints_LOLBreak) DESC, SUM(PowerPoints_Points) DESC) AS PowerRanking, "
											sqlGetLeaderboard = sqlGetLeaderboard & "Accounts.ProfileName, SUM(PowerPoints_Points) + SUM(PowerPoints_Wins) + SUM(PowerPoints_Break) + SUM(PowerPoints_LOLBreak) AS PowerPoints_Total, SUM(PowerPoints_Points) AS PowerPoints_Points, "
											sqlGetLeaderboard = sqlGetLeaderboard & "SUM(PowerPoints_Wins) AS PowerPoints_Wins, SUM(PowerPoints_Break) AS PowerPoints_Break, SUM(PowerPoints_LOLBreak) AS PowerPoints_LOLBreak, SUM(TotalPoints) AS TotalPoints, SUM(TotalWins) AS TotalWins, SUM(TotalLosses) AS TotalLosses, SUM(TotalTies) AS TotalTies, "
											sqlGetLeaderboard = sqlGetLeaderboard & "SUM(TotalBreakdownWins) AS TotalBreakdownWins, SUM(TotalBreakdownLosses) AS TotalBreakdownLosses, SUM(TotalBreakdownTies) AS TotalBreakdownTies, "
											sqlGetLeaderboard = sqlGetLeaderboard & "SUM(TotalLOLBreakdownWins) AS TotalLOLBreakdownWins, SUM(TotalLOLBreakdownLosses) AS TotalLOLBreakdownLosses, SUM(TotalLOLBreakdownTies) AS TotalLOLBreakdownTies, "
											sqlGetLeaderboard = sqlGetLeaderboard & "((CAST(SUM(TotalWins) AS DECIMAL) / (CAST(SUM(TotalWins) AS DECIMAL) + CAST(SUM(TotalLosses) AS DECIMAL))) * 100) / ((CAST(SUM(TotalLOLBreakdownWins) AS DECIMAL) / (CAST(SUM(TotalLOLBreakdownWins) AS DECIMAL) + CAST(SUM(TotalLOLBreakdownLosses) AS DECIMAL)))) - 100 AS LuckRate, "
											sqlGetLeaderboard = sqlGetLeaderboard & "A.TeamID, Accounts.AccountID, Accounts.ProfileImage FROM ( "
												sqlGetLeaderboard = sqlGetLeaderboard & "SELECT TeamID, ROW_NUMBER() OVER (ORDER BY SUM(PointsScored), SUM(ActualWins)) AS PowerPoints_Points, NULL AS PowerPoints_Wins, NULL AS PowerPoints_Break, NULL AS PowerPoints_LOLBreak, NULL AS TotalWins, NULL AS TotalLosses, NULL AS TotalTies, SUM(PointsScored) AS TotalPoints, NULL AS TotalBreakdownWins, NULL AS TotalBreakdownLosses, NULL AS TotalBreakdownTies, NULL AS TotalLOLBreakdownWins, NULL AS TotalLOLBreakdownLosses, NULL AS TotalLOLBreakdownTies FROM Standings "
												sqlGetLeaderboard = sqlGetLeaderboard & "WHERE (LevelID = 2 OR LevelID = 3) AND Year = 2022 GROUP BY TeamID UNION ALL "
												sqlGetLeaderboard = sqlGetLeaderboard & "SELECT TeamID, NULL AS PowerPoints_Points, ROW_NUMBER() OVER (ORDER BY SUM(ActualWins), SUM(BreakdownWins), SUM(PointsScored)) AS PowerPoints_Wins, NULL AS PowerPoints_Break, NULL AS PowerPoints_LOLBreak, SUM(ActualWins) AS TotalWins, SUM(ActualLosses) AS TotalLosses, SUM(ActualTies) AS TotalTies, NULL AS TotalPoints, NULL AS TotalBreakdownWins, NULL AS TotalBreakdownLosses, NULL AS TotalBreakdownTies, NULL AS TotalLOLBreakdownWins, NULL AS TotalLOLBreakdownLosses, NULL AS TotalLOLBreakdownTies FROM Standings "
												sqlGetLeaderboard = sqlGetLeaderboard & "WHERE (LevelID = 2 OR LevelID = 3) AND Year = 2022 GROUP BY TeamID UNION ALL "
												sqlGetLeaderboard = sqlGetLeaderboard & "SELECT TeamID, NULL AS PowerPoints_Points, NULL AS PowerPoints_Wins, ROW_NUMBER() OVER (ORDER BY SUM(BreakdownWins), SUM(ActualWins), SUM(PointsScored)) AS PowerPoints_Break, NULL AS PowerPoints_LOLBreak, NULL AS TotalWins, NULL AS TotalLosses, NULL AS TotalTies, NULL AS TotalPoints, SUM(BreakdownWins) AS TotalBreakdownWins, SUM(BreakdownLosses) AS TotalBreakdownLosses, SUM(BreakdownTies) AS TotalBreakdownTies, NULL AS TotalLOLBreakdownWins, NULL AS TotalLOLBreakdownLosses, NULL AS TotalLOLBreakdownTies FROM Standings "
												sqlGetLeaderboard = sqlGetLeaderboard & "WHERE (LevelID = 2 OR LevelID = 3) AND Year = 2022 GROUP BY TeamID UNION ALL "
												sqlGetLeaderboard = sqlGetLeaderboard & "SELECT TeamID, NULL AS PowerPoints_Points, NULL AS PowerPoints_Wins, NULL AS PowerPoints_Break, ROW_NUMBER() OVER (ORDER BY SUM(LOLBreakdownWins), SUM(ActualWins), SUM(PointsScored)) AS PowerPoints_LOLBreak, NULL AS TotalWins, NULL AS TotalLosses, NULL AS TotalTies, NULL AS TotalPoints, NULL AS TotalBreakdownWins, NULL AS TotalBreakdownLosses, NULL AS TotalBreakdownTies, SUM(LOLBreakdownWins) AS TotalLOLBreakdownWins, SUM(LOLBreakdownLosses) AS TotalLOLBreakdownLosses, SUM(LOLBreakdownTies) AS TotalLOLBreakdownTies FROM Standings "
												sqlGetLeaderboard = sqlGetLeaderboard & "WHERE (LevelID = 2 OR LevelID = 3) AND Year = 2022 GROUP BY TeamID "
											sqlGetLeaderboard = sqlGetLeaderboard & ") A "
											sqlGetLeaderboard = sqlGetLeaderboard & "INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = A.TeamID "
											sqlGetLeaderboard = sqlGetLeaderboard & "INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID "
											sqlGetLeaderboard = sqlGetLeaderboard & "WHERE Accounts.Active = 1 GROUP BY A.TeamID, Accounts.AccountID, Accounts.ProfileName, Accounts.ProfileImage ORDER BY PowerRanking ASC"

											sqlGetLastWeek = "SELECT ROW_NUMBER() OVER (ORDER BY SUM(PowerPoints_Points) + SUM(PowerPoints_Wins) + SUM(PowerPoints_Break) DESC, SUM(PowerPoints_Points) DESC) AS PowerRanking, A.TeamID FROM ( "
												sqlGetLastWeek = sqlGetLastWeek & "SELECT TeamID, ROW_NUMBER() OVER (ORDER BY SUM(PointsScored), SUM(ActualWins)) AS PowerPoints_Points, NULL AS PowerPoints_Wins, NULL AS PowerPoints_Break, NULL AS TotalWins, NULL AS TotalLosses, NULL AS TotalTies, SUM(PointsScored) AS TotalPoints, NULL AS TotalBreakdownWins, NULL AS TotalBreakdownLosses, NULL AS TotalBreakdownTies FROM Standings "
												sqlGetLastWeek = sqlGetLastWeek & "WHERE (LevelID = 2 OR LevelID = 3) AND Year = 2022 AND Period <= " & thisLastPeriod & " GROUP BY TeamID UNION ALL "
												sqlGetLastWeek = sqlGetLastWeek & "SELECT TeamID, NULL AS PowerPoints_Points, ROW_NUMBER() OVER (ORDER BY SUM(ActualWins), SUM(BreakdownWins), SUM(PointsScored)) AS PowerPoints_Wins, NULL AS PowerPoints_Break, SUM(ActualWins) AS TotalWins, SUM(ActualLosses) AS TotalLosses, SUM(ActualTies) AS TotalTies, NULL AS TotalPoints, NULL AS TotalBreakdownWins, NULL AS TotalBreakdownLosses, NULL AS TotalBreakdownTies FROM Standings "
												sqlGetLastWeek = sqlGetLastWeek & "WHERE (LevelID = 2 OR LevelID = 3) AND Year = 2022 AND Period <= " & thisLastPeriod & " GROUP BY TeamID UNION ALL "
												sqlGetLastWeek = sqlGetLastWeek & "SELECT TeamID, NULL AS PowerPoints_Points, NULL AS PowerPoints_Wins, ROW_NUMBER() OVER (ORDER BY SUM(BreakdownWins), SUM(ActualWins), SUM(PointsScored)) AS PowerPoints_Break, NULL AS TotalWins, NULL AS TotalLosses, NULL AS TotalTies, NULL AS TotalPoints, SUM(BreakdownWins) AS TotalBreakdownWins, SUM(BreakdownLosses) AS TotalBreakdownLosses, SUM(BreakdownTies) AS TotalBreakdownTies FROM Standings "
												sqlGetLastWeek = sqlGetLastWeek & "WHERE (LevelID = 2 OR LevelID = 3) AND Year = 2022 AND Period <= " & thisLastPeriod & " GROUP BY TeamID "
											sqlGetLastWeek = sqlGetLastWeek & ") A "
											sqlGetLastWeek = sqlGetLastWeek & "INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = A.TeamID "
											sqlGetLastWeek = sqlGetLastWeek & "INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID "
											sqlGetLastWeek = sqlGetLastWeek & "WHERE Accounts.Active = 1 GROUP BY A.TeamID, Accounts.AccountID, Accounts.ProfileName, Accounts.ProfileImage ORDER BY PowerRanking ASC"

											Set rsLeaderboard = sqlDatabase.Execute(sqlGetLeaderboard)
											Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

											arrLastWeek = rsLastWeek.GetRows()
											rsLastWeek.Close
											Set rsLastWeek = Nothing

											Do While Not rsLeaderboard.Eof

												thisRank = rsLeaderboard("PowerRanking")
												thisProfileName = rsLeaderboard("ProfileName")
												thisProfileImage = rsLeaderboard("ProfileImage")
												thisTotalPoints = rsLeaderboard("TotalPoints")
												thisTotalWins = rsLeaderboard("TotalWins")
												thisTotalLosses = rsLeaderboard("TotalLosses")
												thisTotalTies = rsLeaderboard("TotalTies")
												thisTotalBreakdownWins = rsLeaderboard("TotalBreakdownWins")
												thisTotalBreakdownLosses = rsLeaderboard("TotalBreakdownLosses")
												thisTotalBreakdownTies = rsLeaderboard("TotalBreakdownTies")
												thisTotalLOLBreakdownWins = rsLeaderboard("TotalLOLBreakdownWins")
												thisTotalLOLBreakdownLosses = rsLeaderboard("TotalLOLBreakdownLosses")
												thisTotalLOLBreakdownTies = rsLeaderboard("TotalLOLBreakdownTies")
												thisPowerPoints = rsLeaderboard("PowerPoints_Total")
												thisLuckRate = FormatNumber(rsLeaderboard("LuckRate"), 2) & "%"
												'thisLuckRate = rsLeaderboard("LuckRate")
												thisTeamID = rsLeaderboard("TeamID")

												If Left(thisLuckRate, 1) <> "-" Then thisLuckRate = "+" & thisLuckRate

												thisRecord = thisTotalWins & "-" & thisTotalLosses & "-" & thisTotalTies
												thisBreakdown = thisTotalBreakdownWins & "-" & thisTotalBreakdownLosses & "-" & thisTotalBreakdownTies
												thisLOLBreakdown = thisTotalLOLBreakdownWins & "-" & thisTotalLOLBreakdownLosses & "-" & thisTotalLOLBreakdownTies

												thisLastWeekRank = "A"
												For i = 0 To UBound(arrLastWeek, 2) - 1
													If CInt(thisTeamID) = CInt(arrLastWeek(1, i)) Then
														thisLastWeekRank = arrLastWeek(0, i)
														thisRankChange = CInt(thisLastWeekRank) - CInt(thisRank)
													End If
												Next

												thisRankChangeDisplay = "<span class=""badge badge-light"">" & thisRankChange & "</span>"
												If thisRankChange > 0 Then thisRankChangeDisplay = "<span class=""badge badge-success"">+" & thisRankChange & "</span>"
												If thisRankChange < 0 Then thisRankChangeDisplay = "<span class=""badge badge-danger"">" & thisRankChange & "</span>"

												If Len(thisRank) = 1 Then thisRank = "0" & thisRank
%>
												<tr style="<%= thisBorderBottom %>">
													<td class="pl-3"><img src="https://samelevel.imgix.net/<%= rsLeaderboard("ProfileImage") %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline mr-2"><b><%= thisRank %>.</b> &nbsp;<%= rsLeaderboard("ProfileName") %>&nbsp;&nbsp;<%= thisRankChangeDisplay %></td>
													<td class="text-right d-none d-md-table-cell"><%= FormatNumber(rsLeaderboard("TotalPoints"), 2) %></td>
													<td class="text-right d-none d-sm-table-cell"><%= thisRecord %></td>
													<td class="text-right d-none d-md-table-cell"><%= thisBreakdown %></td>
													<td class="text-right d-none d-md-table-cell"><%= thisLOLBreakdown %></td>
													<td class="text-right d-none d-sm-table-cell"><%= thisLuckRate %></td>
													<td class="text-right pr-4"><b><%= thisPowerPoints %></b></td>
												</tr>
<%
												If Not rsLeaderboard.Eof Then rsLeaderboard.MoveNext

											Loop

											rsLeaderboard.Close
											Set rsLeaderboard = Nothing
%>
										</tbody>
									</table>

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
