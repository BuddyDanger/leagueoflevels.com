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
												<th class="text-center d-none d-md-table-cell">TOTAL POINTS</th>
												<th class="text-center d-none d-sm-table-cell">ACTUAL RECORD</th>
												<th class="text-center d-none d-sm-table-cell">BREAKDOWN RECORD</th>
												<th class="text-center">POWER POINTS</th>
											</tr>
										</thead>
										<tbody>
<%
											sqlGetLeaderboard = "SELECT * FROM PowerRankings ORDER BY PowerRanking ASC"
											Set rsLeaderboard = sqlDatabase.Execute(sqlGetLeaderboard)

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
												thisPowerPoints = rsLeaderboard("PowerPoints_Total")

												thisRecord = thisTotalWins & "-" & thisTotalLosses & "-" & thisTotalTies
												thisBreakdown = thisTotalBreakdownWins & "-" & thisTotalBreakdownLosses & "-" & thisTotalBreakdownTies

												If Len(thisRank) = 1 Then thisRank = "0" & thisRank
%>
												<tr style="<%= thisBorderBottom %>">
													<td class="pl-3"><img src="https://samelevel.imgix.net/<%= rsLeaderboard("ProfileImage") %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline mr-1 pr-1"><b><%= thisRank %>.</b> &nbsp;<%= rsLeaderboard("ProfileName") %></td>
													<td class="text-center d-none d-md-table-cell"><%= FormatNumber(rsLeaderboard("TotalPoints"), 2) %></td>
													<td class="text-center d-none d-sm-table-cell"><%= thisRecord %></td>
													<td class="text-center d-none d-sm-table-cell"><%= thisBreakdown %></td>
													<td class="text-center"><%= thisPowerPoints %></td>
												</tr>
<%
												rsLeaderboard.MoveNext

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
