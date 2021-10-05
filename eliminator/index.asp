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

		<title>Eliminator Challenge / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="Eliminator Challenge - The League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="Eliminator Challenge - The League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="Eliminator Challenge - The League of Levels" />
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

					<div class="row mb-2">
<%
					sqlGetPicks = "SELECT EliminatorPickID, EliminatorRoundID, EliminatorPicks.AccountID, Accounts.ProfileName, Accounts.ProfileImage, EliminatorPicks.NFLTeamID, NFLTeams.City, Year, Period, CorrectPick FROM EliminatorPicks INNER JOIN Accounts ON Accounts.AccountID = EliminatorPicks.AccountID INNER JOIN NFLTeams ON NFLTeams.NFLTeamID = EliminatorPicks.NFLTeamID WHERE EliminatorRoundID = 1000 ORDER BY Period DESC"
					Set rsPicks = sqlDatabase.Execute(sqlGetPicks)

					currentPeriod = 0

					Do While Not rsPicks.Eof

						thisProfileName = rsPicks("ProfileName")
						thisProfileImage = rsPicks("ProfileImage")
						thisCity = rsPicks("City")
						thisYear = rsPicks("Year")
						thisPeriod = rsPicks("Period")
						thisCorrectPick = rsPicks("CorrectPick")

						btnClass = "btn-warning"
						If thisCorrectPick Then btnClass = "btn-success"
						If Not thisCorrectPick Then btnClass = "btn-danger"



						If thisPeriod <> currentPeriod Then

							currentPeriod = thisPeriod
%>
							<div class="col-12 mt-4">
								<ul class="list-group mb-2">
									<li class="list-group-item p-0">
										<h5 class="text-left text-white bg-dark p-3 mt-0 mb-0 rounded"><b>WEEK <%= currentPeriod %></b></h5>
									</li>
								</ul>
							</div>
<%
						End If
%>
						<div class="col-xxl-4 col-xl-6 col-lg-6 col-md-6 col-sm-12 pb-2">

							<ul class="list-group">
								<li class="list-group-item">
									<span class="btn-sm <%= btnClass %>" style="float: right;"><%= thisCity %></span>
									<img src="https://samelevel.imgix.net/<%= thisProfileImage %>?w=28&h=28&fit=crop&crop=focalpoint" width="28" height="28" style="margin-right: 0.5rem;" /> <b><%= thisProfileName %></b>
								</li>
							</ul>

						</div>
<%
						rsPicks.MoveNext

					Loop

					rsPicks.Close
					Set rsPicks = Nothing
%>
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
