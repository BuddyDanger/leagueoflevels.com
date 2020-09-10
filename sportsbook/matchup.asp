<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%

%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Sportsbook / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="Sportsbook - The League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="Sportsbook - The League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="Sportsbook - The League of Levels" />
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

				<div class="container-fluid">

					<div class="row">

						<div class="col-sm-12">

							<div class="page-title-box">

								<div class="float-right">

									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="javascript:void(0);">Main</a></li>
										<li class="breadcrumb-item active">Sportsbook</li>
									</ol>

								</div>

								<h4 class="page-title">Sportsbook / Matchup #<%= Session.Contents("SITE_Bet_MatchupID") %></h4>

							</div>

							<div class="page-content">

								<div class="row">
									<div class="col-12">
										<div class="card">

											<div class="card-body">

												<table class="table table-responsive-sm">
													<tr>
														<td class="border-0" width="5%" style="min-width: 100px;"><b>LEVEL</b></td>
														<td class="border-0" width="45%"><b>MATCHUP</b></td>
														<td class="border-0" width="10%"><b>PMR</b></td>
														<td class="border-0" width="10%"><b>SCORE</b></td>
														<td class="border-0" width="10%"><b>PROJECTED</b></td>
														<td class="border-0" width="5%" nowrap><b>WIN %</b></td>
														<td class="border-0" width="5%"><b><b>ML</b></td>
														<td class="border-0" width="5%"><b>SPREAD</b></td>
													</tr>
												</table>
<%
												sqlGetSchedules = "SELECT MatchupID, Matchups.LevelID, Year, Period, IsPlayoffs, TeamID1, TeamID2, Team1.TeamName AS TeamName1, Team2.TeamName AS TeamName2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2, Leg, TeamProjected1, TeamProjected2, TeamWinPercentage1, TeamWinPercentage2, TeamMoneyline1, TeamMoneyline2, TeamSpread1, TeamSpread2 FROM Matchups "
												sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team1 ON Team1.TeamID = Matchups.TeamID1 "
												sqlGetSchedules = sqlGetSchedules & "INNER JOIN Teams AS Team2 ON Team2.TeamID = Matchups.TeamID2 "
												sqlGetSchedules = sqlGetSchedules & "WHERE Matchups.MatchupID = " & Session.Contents("SITE_Bet_MatchupID") & " "
												sqlGetSchedules = sqlGetSchedules & "ORDER BY CASE WHEN Matchups.LevelID = 1 THEN '1' WHEN Matchups.LevelID = 0 THEN '2' WHEN Matchups.LevelID = 2 THEN '3' WHEN Matchups.LevelID = 3 THEN '4' ELSE Matchups.LevelID END ASC, Matchups.MatchupID DESC"
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

													If CInt(thisLevelID) = 0 Then LevelCell = "<td width=""5%"" rowspan=""2"" class=""text-center"" style=""background-color: #D00000; color: #fff; min-width: 100px;""><b>CUP</b></td>"
													If CInt(thisLevelID) = 1 Then LevelCell = "<td width=""5%"" rowspan=""2"" class=""text-center"" style=""background-color: #FFBA08; color: #fff; min-width: 100px;""><b>OMEGA</b></td>"
													If CInt(thisLevelID) = 2 Then LevelCell = "<td width=""5%"" rowspan=""2"" class=""text-center"" style=""background-color: #136F63; color: #fff; min-width: 100px;""><b>SLFFL</b></td>"
													If CInt(thisLevelID) = 3 Then LevelCell = "<td width=""5%"" rowspan=""2"" class=""text-center"" style=""background-color: #032B43; color: #fff; min-width: 100px;""><b>FLFFL</b></td>"
%>
													<table class="table table-bordered table-responsive-sm">
														<tr>
															<%= LevelCell %>
															<td width="45%"><%= thisTeamName1 %></td>
															<td width="10%"><%= thisTeamPMR1 %></td>
															<td width="10%"><%= thisTeamScore1 %></td>
															<td width="10%"><%= thisTeamProjected1 %></td>
															<td width="5%"><%= thisTeamWinPercentage1 %></td>
															<td width="5%"><%= thisTeamMoneyline1 %></td>
															<td width="5%"><%= thisTeamSpread1 %></td>
														</tr>
														<tr>
															<td width="45%"><%= thisTeamName2 %></td>
															<td width="10%"><%= thisTeamPMR2 %></td>
															<td width="10%"><%= thisTeamScore2 %></td>
															<td width="10%"><%= thisTeamProjected2 %></td>
															<td width="5%"><%= thisTeamWinPercentage2 %></td>
															<td width="5%"><%= thisTeamMoneyline2 %></td>
															<td width="5%"><%= thisTeamSpread2 %></td>
														</tr>
													</table>
<%
													rsSchedules.MoveNext

												Loop

												rsSchedules.Close
												Set rsSchedules = Nothing
%>
											</div>
										</div>
									</div>
								</div>

								<div class="row">

									<div class="col-12 col-lg-4">
										<div class="card">

											<div class="card-body">

												<div style="border-bottom: 1px solid #e8ebf3;"><h4>Moneyline Wager</h4></div>
												<form>
													<div class="form-group">

														<div class="pl-1 mt-2 mb-3">
															<input class="form-check-input-lg ml-0 mt-3 pt-1" type="checkbox" id="teamBetMoneylineID1">
															<label class="form-check-label-lg" for="teamBetMoneylineID1"><%= thisTeamName1 %> (<%= thisTeamMoneyline1 %> ML)</label>
														</div>

														<div class="pl-1 mt-2 mb-2">
															<input class="form-check-input-lg ml-0 mt-1 pt-0" type="checkbox" id="teamBetMoneylineID2">
															<label class="form-check-label-lg" for="teamBetMoneylineID2"><%= thisTeamName2 %> (<%= thisTeamMoneyline2 %> ML)</label>
														</div>

														<label for="formBetAmount" class="col-form-label"><b>Bet Amount ($)</b></label>
														<input type="number" class="form-control form-control-lg mb-3" min="0" max="5000" id="formBetAmount">

														<button type="submit" class="btn btn-block btn-success mb-4">Place Bet</button>

														<div><b>TO WIN:</b> <span id="payoutMoneyline"><i>Enter Value To Calculate Winnings</i><span></div>

													</div>
												</form>

											</div>

										</div>
									</div>

									<div class="col-12 col-lg-4">
										<div class="card">

											<div class="card-body">

												<div style="border-bottom: 1px solid #e8ebf3;"><h4>Point Spread Wager</h4></div>
												<form>
													<div class="form-group">

														<div class="pl-1 mt-2 mb-3">
															<input class="form-check-input-lg ml-0 mt-3 pt-1" type="checkbox" id="teamBetMoneylineID1">
															<label class="form-check-label-lg" for="teamBetMoneylineID1"><%= thisTeamName1 %> (<%= thisTeamSpread1 %>)</label>
														</div>

														<div class="pl-1 mt-2 mb-2">
															<input class="form-check-input-lg ml-0 mt-1 pt-0" type="checkbox" id="teamBetMoneylineID2">
															<label class="form-check-label-lg" for="teamBetMoneylineID2"><%= thisTeamName2 %> (<%= thisTeamSpread2 %>)</label>
														</div>

														<label for="formBetAmount" class="col-form-label"><b>Bet Amount ($)</b></label>
														<input type="number" class="form-control form-control-lg mb-3" min="0" max="5000" id="formBetAmount">

														<button type="submit" class="btn btn-block btn-success mb-4">Place Bet</button>

														<div><b>TO WIN:</b> <i>Enter Value To Calculate Winnings</i></div>

													</div>
												</form>

											</div>

										</div>
									</div>

									<div class="col-12 col-lg-4">
										<div class="card">

											<div class="card-body">

												<div style="border-bottom: 1px solid #e8ebf3;"><h4>Ticket Slips</h4></div>

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

		<script>
		function calculate_moneyline_payout(odds, stake){
			var isPositive = true;

			if(odds.toString().search("-") > -1) { isPositive = false; }

			odds = odds.replace("+","").replace("-","");

			if(isPositive) { return parseInt(stake * (odds / 100)) + parseInt(stake); } else { return parseInt(stake / (odds / 100)) + parseInt(stake); }
		}
		</script>
	</body>

</html>
