<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp" -->
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Teams / League of Levels</title>

		<meta name="description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="Teams / League of Levels" />
		<meta property="og:description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="Teams / League of Levels" />
		<meta name="twitter:description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />

		<meta name="title" content="Teams / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/teams/" />

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
												<th class="pl-3"><b>ACTIVE TEAM NAME</b></th>
												<th class="text-center d-none d-sm-table-cell">POINTS SCORED</th>
												<th class="text-center d-none d-sm-table-cell">ACTUAL RECORD</th>
												<th class="text-center d-none d-sm-table-cell">ACTUAL WIN %</th>
												<th class="text-center d-none d-md-table-cell">BREAKDOWN RECORD</th>
												<th class="text-center d-none d-md-table-cell">BREAKDOWN WIN %</th>
												<th class="text-center d-none d-sm-table-cell">LUCK RATE</th>
											</tr>
										</thead>
										<tbody>
<%
											sqlGetAccounts = "SELECT * FROM Accounts_Active ORDER BY ProfileName; SELECT * FROM Accounts_Inactive ORDER BY ProfileName;"
											Set rsAccounts = sqlDatabase.Execute(sqlGetAccounts)

											Do While Not rsAccounts.Eof

												thisAccountID = rsAccounts("AccountID")
												thisProfileImage = "<img src=""https://samelevel.imgix.net/" & rsAccounts("ProfileImage") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle d-inline mr-2"">"
%>

												<tr>

													<td class="pl-3">
														<a href="/teams/<%= rsAccounts("ProfileURL") %>/">
														<%= thisProfileImage %>
														<b><%= rsAccounts("ProfileName") %></b>
														</a>
													</td>
													<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(rsAccounts("PointsScored"), 2) %></td>
													<td class="text-center d-none d-sm-table-cell"><%= rsAccounts("ActualWins") %>-<%= rsAccounts("ActualLosses") %>-<%= rsAccounts("ActualTies") %></td>
													<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(CDbl(rsAccounts("ActualWinPercentage"))*100, 2) %>%</td>
													<td class="text-center d-none d-md-table-cell"><%= rsAccounts("BreakdownWins") %>-<%= rsAccounts("BreakdownLosses") %>-<%= rsAccounts("BreakdownTies") %></td>
													<td class="text-center d-none d-md-table-cell"><%= FormatNumber(CDbl(rsAccounts("BreakdownWinPercentage"))*100, 2) %>%</td>
													<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(rsAccounts("LuckRate"), 2) %>%</td>
											
												</tr>

<%
												rsAccounts.MoveNext

											Loop

											Set rsAccounts = rsAccounts.NextRecordset()
%>
										</tbody>
									</table>

								</div>

							</div>

							<div class="card">

								<div class="card-body p-0">

									<table class="table mb-1">
										<thead>
											<tr>
												<th class="pl-3"><b>RETIRED TEAM NAME</b></th>
												<th class="text-center d-none d-sm-table-cell">POINTS SCORED</th>
												<th class="text-center d-none d-sm-table-cell">ACTUAL RECORD</th>
												<th class="text-center d-none d-sm-table-cell">ACTUAL WIN %</th>
												<th class="text-center d-none d-md-table-cell">BREAKDOWN RECORD</th>
												<th class="text-center d-none d-md-table-cell">BREAKDOWN WIN %</th>
												<th class="text-center d-none d-sm-table-cell">LUCK RATE</th>
											</tr>
										</thead>
										<tbody>
<%
											Do While Not rsAccounts.Eof

												thisAccountID = rsAccounts("AccountID")
												thisProfileImage = "<img src=""https://samelevel.imgix.net/" & rsAccounts("ProfileImage") & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle float-left d-none d-xxl-block mr-2"">"
%>
												<tr style="<%= thisBorderBottom %>">

													<td class="pl-3">
														<div><b><%= rsAccounts("ProfileName") %></b></div>
													</td>
													<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(rsAccounts("PointsScored"), 2) %></td>
													<td class="text-center d-none d-sm-table-cell"><%= rsAccounts("ActualWins") %>-<%= rsAccounts("ActualLosses") %>-<%= rsAccounts("ActualTies") %></td>
													<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(CDbl(rsAccounts("ActualWinPercentage"))*100, 2) %>%</td>
													<td class="text-center d-none d-md-table-cell"><%= rsAccounts("BreakdownWins") %>-<%= rsAccounts("BreakdownLosses") %>-<%= rsAccounts("BreakdownTies") %></td>
													<td class="text-center d-none d-md-table-cell"><%= FormatNumber(CDbl(rsAccounts("BreakdownWinPercentage"))*100, 2) %>%</td>
													<td class="text-center d-none d-sm-table-cell"><%= FormatNumber(rsAccounts("LuckRate"), 2) %>%</td>

												</tr>
<%
												rsAccounts.MoveNext

											Loop

											rsAccounts.Close
											Set rsAccounts = Nothing
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
