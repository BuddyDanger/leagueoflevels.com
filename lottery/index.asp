<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!--#include virtual="/assets/asp/functions/sha256.asp"-->
<%
	Function QuickReorder (ByVal arrArray)

		iUpper = UBound(arrArray)
		iLower = LBound(arrArray)

		Randomize Timer

		For iLoop = iLower to iUpper

			iSwapPos = Int(Rnd * (iUpper + 1))
			varTmp = arrArray(iLoop)
			arrArray(iLoop) = arrArray(iSwapPos)
			arrArray(iSwapPos) = varTmp

		Next

		QuickReorder = arrArray

	End Function

	thisLevel = Request.QueryString("level")
	thisSelected = Request.QueryString("selected")

	If Len(thisLevel) > 0 Then

		If Len(thisSelected) > 0 Then
			sqlGetTotal = "SELECT LevelID, SUM(Balls) AS TotalBalls FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LevelID = " & thisLevel & " AND Teams.TeamID NOT IN (" & thisSelected & ") GROUP BY LevelID"
		Else
			sqlGetTotal = "SELECT LevelID, SUM(Balls) AS TotalBalls FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LevelID = " & thisLevel & " GROUP BY LevelID"
		End If

		Set rsTotal = sqlDatabase.Execute(sqlGetTotal)

		If Not rsTotal.Eof Then
			thisTotal = rsTotal("TotalBalls")
			rsTotal.Close
			Set rsTotal = Nothing
		Else
			thisTotal = 0
		End If

		If Len(thisSelected) > 0 Then
			sqlGetBalls = "SELECT Teams.TeamID, Teams.TeamName, Balls FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LevelID = " & thisLevel & " AND Teams.TeamID NOT IN (" & thisSelected & ")"
		Else
			sqlGetBalls = "SELECT Teams.TeamID, Teams.TeamName, Balls FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LevelID = " & thisLevel
		End If

		Set rsBalls = sqlDatabase.Execute(sqlGetBalls)

		thisLotteryBallString = ""

		Do While Not rsBalls.Eof

			thisTeamID = rsBalls("TeamID")
			thisTeamName = rsBalls("TeamName")
			thisBallCount = rsBalls("Balls")

			If thisBallCount > 0 Then

				For i = 1 To thisBallCount
					thisLotteryBallString = thisLotteryBallString & thisTeamID & "|" & thisTeamName & ","
				Next

			End If

			thisNewTotal = thisTotal
			If thisTotal = 0 Then

				thisLotteryBallString = thisLotteryBallString & thisTeamID & "|" & thisTeamName & ","
				thisNewTotal = thisNewTotal + 1

			End If

			rsBalls.MoveNext

		Loop

		rsBalls.Close
		Set rsBalls = Nothing

		thisTotal = thisNewTotal

		If Right(thisLotteryBallString, 1) = "," Then thisLotteryBallString = Left(thisLotteryBallString, Len(thisLotteryBallString)-1)
		arrLottery = Split(thisLotteryBallString, ",")
		arrLottery = QuickReorder(arrLottery)

	End If
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Lottery / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="The League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="The League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="The League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/" />

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
						If Len(thisLevel) > 0 Then

							If CInt(thisLevel) = 2 Then thisHeader = "SAME LEVEL"
							If CInt(thisLevel) = 3 Then thisHeader = "FARM LEVEL"
%>
							<div class="col-12 col-xl-4">

								<h4 class="text-left bg-primary text-white p-3 mt-0 mb-0 rounded-top"><b><%= thisHeader %> LOTTERY RESULTS</b><span class="float-right dripicons-trophy"></i></h4>

								<ul class="list-group list-group-flush">
<%
									thisTotalExistingPulls = 0
									If Len(thisSelected) > 0 Then

										sqlGetExistingPulls = "SELECT Teams.TeamID, Teams.TeamName, Accounts.ProfileImage FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND Teams.LevelID = " & thisLevel & " AND Teams.TeamID IN (" & thisSelected & ") ORDER BY CASE Teams.TeamID "

										arrSelected = Split(thisSelected, ",")
										quickCount = 1
										For Each TeamID In arrSelected

											sqlGetExistingPulls = sqlGetExistingPulls & " WHEN " & TeamID & " THEN " & quickCount
											quickCount = quickCount + 1

										Next
										sqlGetExistingPulls = sqlGetExistingPulls & " ELSE " & quickCount & " END, TeamName "
										Set rsExistingPulls = sqlDatabase.Execute(sqlGetExistingPulls)

										Do While Not rsExistingPulls.Eof

											thisDisplayCount = thisTotalExistingPulls + 1
											If Len(thisDisplayCount) = 1 Then thisDisplayCount = "0" & thisDisplayCount
%>
											<li class="list-group-item">
												<b><%= thisDisplayCount %>.)</b> &nbsp; <img src="https://samelevel.imgix.net/<%= rsExistingPulls("ProfileImage") %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle"> &nbsp; <b><%= rsExistingPulls("TeamName") %></b>
											</li>
<%
											rsExistingPulls.MoveNext

											thisTotalExistingPulls = thisTotalExistingPulls + 1

										Loop

										rsExistingPulls.Close
										Set rsExistingPulls = Nothing

									End If

									thisDrawButton = 1

									For i = thisTotalExistingPulls + 1 To 12

										thisDisplayCount = i
										If Len(thisDisplayCount) = 1 Then thisDisplayCount = "0" & thisDisplayCount

										If thisDrawButton = 1 Then
											thisDrawButton = 0
											Randomize
											thisPick = arrLottery(Int((UBound(arrLottery)-0+1)*Rnd+0))
											arrPick = Split(thisPick, "|")
											thisPick = arrPick(0)
											If Len(thisSelected) > 0 Then thisPick = "," & thisPick
%>
											<li class="list-group-item"><b><%= thisDisplayCount %>.)</b> &nbsp; <a href="/lottery/?level=<%= thisLevel %>&selected=<%=thisSelected%><%=thisPick%>" class="btn btn-danger">PULL BALL</a></li>
<%
										Else
%>
											<li class="list-group-item"><b><%= thisDisplayCount %>.)</b> &nbsp; <img src="https://samelevel.imgix.net/user.jpg?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle"> &nbsp; </li>
<%
										End If

									Next
%>
								</ul>

							</div>
<%
							If Len(thisSelected) > 0 Then
								sqlGetChances = "SELECT Teams.TeamID, Teams.TeamName, Accounts.ProfileImage, Balls FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LevelID = " & thisLevel & " AND Teams.TeamID NOT IN (" & thisSelected & ") ORDER BY Balls DESC, TeamName ASC;"
								sqlGetTotal = "SELECT Teams.LevelID, SUM(Accounts.Balls) AS TotalBalls FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LinkAccountsTeams.TeamID NOT IN (" & thisSelected & ") AND LevelID = " & thisLevel & " GROUP BY LevelID;"
								sqlGetTeams = "SELECT COUNT(Teams.TeamID) AS TotalTeams FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LevelID = " & thisLevel & " AND Teams.TeamID NOT IN (" & thisSelected & ");"
							Else
								sqlGetChances = "SELECT Teams.TeamID, Teams.TeamName, Accounts.ProfileImage, Balls FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LevelID = " & thisLevel & " ORDER BY Balls DESC, TeamName ASC;"
								sqlGetTotal = "SELECT Teams.LevelID, SUM(Accounts.Balls) AS TotalBalls FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LevelID = " & thisLevel & " GROUP BY LevelID;"
								sqlGetTeams = "SELECT COUNT(Teams.TeamID) AS TotalTeams FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LevelID = " & thisLevel & ";"
							End If

							Set rsNumbers = sqlDatabase.Execute(sqlGetTeams & sqlGetTotal & sqlGetChances)

							thisTeamsTotal = rsNumbers("TotalTeams")

							Set rsNumbers = rsNumbers.NextRecordset()

							If Not rsNumbers.Eof Then

								thisTotal = rsNumbers("TotalBalls")

								Set rsNumbers = rsNumbers.NextRecordset()
%>
								<div class="col-12 col-xl-4">

									<h4 class="text-left bg-warning text-white p-3 mt-0 mb-0 rounded-top"><b>PERCENTAGE PULL CHANCE</b><span class="float-right dripicons-trophy"></i></h4>

									<ul class="list-group list-group-flush">
<%
										Do While Not rsNumbers.Eof

											thisCount = rsNumbers("Balls")
											If thisTotal = 0 Then
												thisChance = 100 * (1 / thisTeamsTotal)
											Else
												thisChance = (thisCount * 100) / thisTotal
											End If
%>
											<li class="list-group-item">
												<img src="https://samelevel.imgix.net/<%= rsNumbers("ProfileImage") %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle"> &nbsp; <b><%= rsNumbers("TeamName") %> (<%= thisCount %>)</b>
												<span class="float-right pt-2"><%= FormatNumber(thisChance, 2) %>%</span>
											</li>
<%
											rsNumbers.MoveNext

										Loop
%>
									</ul>

								</div>
<%
							End If

						Else

							sqlGetTotals = "SELECT LevelID, SUM(Balls) AS TotalBalls FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE EndYear = 0 AND LevelID > 1 GROUP BY LevelID"
							Set rsTotals = sqlDatabase.Execute(sqlGetTotals)

							If Not rsTotals.Eof Then

								thisSLFFLTotal = rsTotals("TotalBalls")
								rsTotals.MoveNext
								thisFLFFLTotal = rsTotals("TotalBalls")
								rsTotals.Close
								Set rsTotals = Nothing

							End If
%>
							<div class="col-xxxl-4 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12 col-xxs-12">

								<ul class="list-group mb-4">
									<li class="list-group-item p-0">
										<h4 class="text-left bg-primary text-white p-3 mt-0 mb-0 rounded-top"><b>DRAFT LOTTERY SIMULATION</b><span class="float-right dripicons-graph-pie"></i></h4>
									</li>
									<li class="list-group-item rounded-0">

										<span class="float-right"><a href="/lottery/?level=2" class="btn btn-warning" style="text-decoration: none; display: block;">RUN</a></span>
										<div><b>SAME LEVEL — <%= thisSLFFLTotal %> BALLS</b></div>
										<div><%= FormatNumber(thisSLFFLTotal * 2500, 0) %> Schmeckles</div>

									</li>
									<li class="list-group-item rounded-0">

										<span class="float-right"><a href="/lottery/?level=3" class="btn btn-warning" style="text-decoration: none; display: block;">RUN</a></span>
										<div><b>FARM LEVEL — <%= thisFLFFLTotal %> BALLS</b></div>
										<div><%= FormatNumber(thisFLFFLTotal * 2500, 0) %> Schmeckles</div>

									</li>
								</ul>

							</div>
<%
						End If
%>
					</div>

					<footer class="footer text-center text-sm-left">&copy; <%= Year(Now()) %> League of Levels Fantasy <span class="text-muted d-none d-sm-inline-block float-right"></span></footer>

				</div>



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
