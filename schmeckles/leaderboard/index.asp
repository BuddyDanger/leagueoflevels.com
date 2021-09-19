<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	If Len(ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))) < 1 Then
		Session.Contents("SITE_Schmeckles_AccountID") = ""
		Session.Contents("SITE_Schmeckles_TransactionHash") = ""
		Session.Contents("SITE_Schmeckles_AccountID") = ""
		Session.Contents("SITE_Schmeckles_AccountProfileName") = ""
		Session.Contents("SITE_Schmeckles_TypeID") = ""
		Session.Contents("SITE_Schmeckles_TypeTitle") = ""
	End If

	If Request.Form("action") = "update" Then

		thisAccount = Request.Form("account")
		thisType = Request.Form("type")

		thisRedirect = "/schmeckles/transactions/"
		If Len(thisAccount) > 0 Then thisRedirect = thisRedirect & thisAccount & "/"
		If Len(thisType) > 0 Then thisRedirect = thisRedirect & thisType & "/"

		Response.Redirect(thisRedirect)

	End If

	thisPageTitle = "Schmeckles / Leaderboard / League of Levels"

	thisPageDescription = "Schmeckle leaderboard across all levels. This does not include inactive team accounts."
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
		<meta property="og:url" content="https://www.leagueoflevels.com/schmeckles/" />
		<meta property="og:title" content="<%= thisPageTitle %>" />
		<meta property="og:description" content="<%= thisPageDescription %>" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/schmeckles/" />
		<meta name="twitter:title" content="<%= thisPageTitle %>" />
		<meta name="twitter:description" content="<%= thisPageDescription %>" />

		<meta name="title" content="<%= thisPageTitle %>" />
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

				<div class="container-fluid">

					<div class="row mt-4">

						<div class="col-12 col-xl-4">

							<h4 class="text-left bg-dark text-white p-3 mt-0 mb-0 rounded-top"><b>SCHMECKLE LEADERBOARD</b><span class="float-right dripicons-trophy"></i></h4>

							<ul class="list-group list-group-flush mb-4">
<%
								sqlGetLeaderboard = "SELECT Accounts.ProfileName, Accounts.ProfileImage, SUM([TransactionTotal]) AS TotalSchmeckles FROM SchmeckleTransactions INNER JOIN Accounts ON Accounts.AccountID = SchmeckleTransactions.AccountID WHERE Accounts.Active = 1 GROUP BY Accounts.ProfileName, Accounts.ProfileImage ORDER BY TotalSchmeckles DESC"
								Set rsLeaderboard = sqlDatabase.Execute(sqlGetLeaderboard)

								Do While Not rsLeaderboard.Eof
%>
									<li class="list-group-item">
										<img src="https://samelevel.imgix.net/<%= rsLeaderboard("ProfileImage") %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle"> &nbsp; <b><%= rsLeaderboard("ProfileName") %></b>
										<span class="float-right p-2 badge-warning rounded"><%= FormatNumber(rsLeaderboard("TotalSchmeckles"), 0) %></span>
									</li>
<%
									rsLeaderboard.MoveNext

								Loop

								rsLeaderboard.Close
								Set rsLeaderboard = Nothing
%>
							</ul>

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
