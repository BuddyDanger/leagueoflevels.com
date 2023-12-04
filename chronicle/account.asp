<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp" -->
<%
	'PULL INDIVIDUAL TEAM DATA'
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Dashboard / League of Levels</title>

		<meta name="description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="The League of Levels" />
		<meta property="og:description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="The League of Levels" />
		<meta name="twitter:description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />

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

						<div class="col-4">

							<a href="#" style="display: block;">
								<ul class="list-group mb-4">
									<li class="list-group-item p-0">
										<h4 class="text-left bg-dark text-white p-3 mt-0 mb-0 rounded-top"><b><%= Session.Contents("AccountName") %></b><span class="float-right dripicons-meter"></i></h4>
									</li>
									<li class="list-group-item rounded-0">
										<span class="float-right"><%= Session.Contents("AccountName") %></span>
										<div><b><i class="fas fa-fw fa-user"></i> &nbsp;ACCOUNT NAME</b></div>
									</li>
									<li class="list-group-item rounded-0">
										<span class="float-right"><%= FormatNumber(thisSchmeckleSackBalance, 0) %></span>
										<div><b><i class="fas fa-fw fa-wallet"></i> &nbsp;SCHMECKLE SACK</b></div>
									</li>
									<li class="list-group-item">
										<span class="float-right"><%= thisCurrentWins %>-<%= thisCurrentLosses %>-<%= thisCurrentTies %></span>
										<div><b><i class="fas fa-fw fa-table"></i> &nbsp;CURRENT RECORD</b></div>
									</li>
									<li class="list-group-item">
										<span class="float-right"><%= FormatNumber(thisCurrentPoints, 2) %></span>
										<div><b><i class="fas fa-fw fa-calculator"></i> &nbsp;POINTS SCORED</b></div>
									</li>
									<li class="list-group-item">
										<span class="float-right"><%= thisCurrentPowerRanking & ordsuffix %> (<%= thisPowerRankPoints %>/96)</span>
										<div><b><i class="fas fa-fw fa-star"></i> &nbsp;POWER RANKING</b></div>
									</li>
								</ul>
							</a>

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
