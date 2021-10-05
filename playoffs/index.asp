<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	If Len(ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))) < 1 Then Session.Contents("SITE_Schmeckles_AccountID") = ""
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Playoffs / League of Levels</title>

		<meta name="description" content="Real-time Schmeckle transaction ledger and leaderboard. Schmeckles represent the league's currency system. Teams can earn Schmeckles through multiple side games and used to purchase items like draft lottery balls." />

		<meta property="og:site_name" content="League of Levels" />
		<meta property="og:url" content="https://www.leagueoflevels.com/schmeckles/" />
		<meta property="og:title" content="Schmeckles / League of Levels" />
		<meta property="og:description" content="Real-time Schmeckle transaction ledger and leaderboard. Schmeckles represent the league's currency system. Teams can earn Schmeckles through multiple side games and used to purchase items like draft lottery balls." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/schmeckles/" />
		<meta name="twitter:title" content="Schmeckles / League of Levels" />
		<meta name="twitter:description" content="Real-time Schmeckle transaction ledger and leaderboard. Schmeckles represent the league's currency system. Teams can earn Schmeckles through multiple side games and used to purchase items like draft lottery balls." />

		<meta name="title" content="Schmeckles / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/schmeckles/" />

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

					<div class="row">

						<div class="col-sm-12">

							<div class="page-title-box">

								<div class="float-right">

									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="/">Main</a></li>
										<li class="breadcrumb-item active">Playoffs</li>
									</ol>

								</div>

								<h4 class="page-title">Playoffs</h4>

							</div>

							<div class="page-content">

								<div class="row">

									<div class="p-0 col-12 col-xl-3">

										<div style="height: 80px; margin-bottom: 80px;" class="bg-secondary border-top border-bottom border-right">1</div>
										<div style="height: 80px; margin-bottom: 80px;" class="bg-secondary border-top border-bottom border-right">1</div>
										<div style="height: 80px; margin-bottom: 80px;" class="bg-secondary border-top border-bottom border-right">1</div>
										<div style="height: 80px; margin-bottom: 80px;" class="bg-secondary border-top border-bottom border-right">1</div>

									</div>

									<div class="p-0 col-12 col-xl-3">

										<div style="height: 160px; margin-top: 40px; margin-bottom: 160px;" class="bg-secondary border-top border-bottom border-right">1</div>
										<div style="height: 160px;" class="bg-secondary border-top border-bottom border-right">1</div>

									</div>

									<div class="p-0 col-12 col-xl-3">

										<div style="height: 320px; margin-top: 120px; margin-bottom: 160px;" class="bg-secondary border-top border-bottom border-right">1</div>

									</div>

									<div class="p-0 col-12 col-xl-3">

										<div style="height: 40px; margin-top: 260px; margin-bottom: 160px;" class="bg-secondary border-top border-bottom border-right"></div>

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

	</body>

</html>
