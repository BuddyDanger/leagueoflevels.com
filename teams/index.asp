<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp" -->
<%
	'PULL ALL TEAM DATA'
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

						<% If Session.Contents("LoggedIn") = "yes" Then %>

							<div class="col-12 col-lg-6 col-xl-6 col-xxl-4">

								<!--#include virtual="/assets/asp/dashboard/account.asp" -->

								<!--#include virtual="/assets/asp/dashboard/eliminator.asp" -->

								<!--#include virtual="/assets/asp/dashboard/locks.asp" -->

							</div>

							<div class="col-12 col-lg-6 col-xl-6 col-xxl-4">

								<!--#include virtual="/assets/asp/dashboard/timeline.asp" -->

							</div>

							<div class="col-12 col-lg-6 col-xl-6 col-xxl-3">

								<!--#include virtual="/assets/asp/dashboard/active-tickets.asp" -->

							</div>

							<div class="col-12 col-xxl-1 text-center">

								<div class="mb-3"><a href="https://www.slffl.com" target="_blank" title="The Next Level Cup" class="btn btn-dark rounded-circle"><h1><i class="fas fa-trophy fa-fw"></i></h1></a></div>
								<div class="mb-3"><a href="/schmeckles/<%= Session.Contents("AccountProfileURL") %>/" title="Schmeckles" class="btn btn-dark rounded-circle"><h1><i class="fas fa-credit-card fa-fw"></i></h1></a></div>
								<div class="mb-3"><a href="/eliminator/" title="Eliminator Challenge" class="btn btn-dark rounded-circle"><h1><i class="fas fa-skull fa-fw"></i></h1></a></div>
								<div class="mb-3"><a href="#" title="Locks" class="btn btn-dark rounded-circle"><h1><i class="fas fa-lock fa-fw" style="opacity: 0.5;"></i></h1></a></div>

							</div>

						<% End If %>

						<!--#include virtual="/assets/asp/dashboard/login.asp" -->

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
