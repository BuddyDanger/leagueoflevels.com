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

		<title>Schmeckles / League of Levels</title>

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

					<div class="row mt-4">

						<div class="col-12 col-xl-4">

							<h4 class="text-left bg-dark text-white p-3 mt-0 mb-0 rounded-top"><b>SCHMECKLE LEADERBOARD</b><span class="float-right dripicons-trophy"></i></h4>

							<ul class="list-group list-group-flush">
<%
								sqlGetLeaderboard = "SELECT TOP 5 Accounts.ProfileName, Accounts.ProfileURL, Accounts.ProfileImage, SUM([TransactionTotal]) AS TotalSchmeckles FROM SchmeckleTransactions INNER JOIN Accounts ON Accounts.AccountID = SchmeckleTransactions.AccountID WHERE Accounts.Active = 1 GROUP BY Accounts.ProfileName, Accounts.ProfileURL, Accounts.ProfileImage ORDER BY TotalSchmeckles DESC"
								Set rsLeaderboard = sqlDatabase.Execute(sqlGetLeaderboard)

								Do While Not rsLeaderboard.Eof
%>
									<a href="/schmeckles/transactions/<%= rsLeaderboard("ProfileURL") %>/" class="list-group-item list-group-item-action pl-0 pr-0">
										<div class="row p-0 m-0">
											<div class="col-12 align-self-center">
												<img src="https://samelevel.imgix.net/<%= rsLeaderboard("ProfileImage") %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle"> &nbsp; <b><%= rsLeaderboard("ProfileName") %></b>
												<span class="float-right p-2 badge-warning rounded"><%= FormatNumber(rsLeaderboard("TotalSchmeckles"), 0) %></span>
											</div>
										</div>
									</a>
<%
									rsLeaderboard.MoveNext

								Loop

								rsLeaderboard.Close
								Set rsLeaderboard = Nothing
%>
							</ul>

							<a href="/schmeckles/leaderboard/" class="btn btn-light btn-block card-text mb-4">VIEW FULL LEADERBOARD</a>

							<h4 class="text-left bg-dark text-white p-3 mt-0 mb-0 rounded-top"><b>TOP 2024 PAYOUTS</b><span class="float-right dripicons-trophy"></i></h4>

							<ul class="list-group list-group-flush">
<%
								sqlGetLargest = "SELECT TOP (10) TransactionDate, TransactionTotal, TransactionHash, Accounts.ProfileName, Accounts.ProfileImage FROM SchmeckleTransactions INNER JOIN Accounts ON Accounts.AccountID = SchmeckleTransactions.AccountID WHERE TransactionDate >= '9/1/2024' AND TransactionTypeID = 1008 ORDER BY TransactionTotal DESC"
								Set rsLargest = sqlDatabase.Execute(sqlGetLargest)

								Do While Not rsLargest.Eof

									thisTransactionDate = rsLargest("TransactionDate")
									thisTransactionTotal = rsLargest("TransactionTotal")
									thisTransactionHash = rsLargest("TransactionHash")
									thisProfileName = rsLargest("ProfileName")
									thisProfileImage = rsLargest("ProfileImage")
									arrthisTransactionDate = Split(thisTransactionDate, " ")
									If CDbl(thisTransactionTotal) > 0 Then
										thisTransactionDirection = "badge-success"
									Else
										thisTransactionDirection = "badge-danger"
									End If

									thisProfileImage = "<img src=""https://samelevel.imgix.net/" & thisProfileImage & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle float-left"">"

									thisTransactionTotal = FormatNumber(thisTransactionTotal, 0)
									If thisTransactionTotal > 0 Then thisTransactionTotal = "+" & thisTransactionTotal
%>
									<a href="/schmeckles/transactions/<%= thisTransactionHash %>/" class="list-group-item list-group-item-action pl-0 pr-0">
										<div class="row p-0 m-0">
											<div class="col-8 align-self-center">
												<%= thisProfileImage %>
												<div class="float-left pl-2">
													<div><b><%= thisProfileName %></b></div>
													<div><%= Month(thisTransactionDate) %>/<%= Day(thisTransactionDate) %>&nbsp;<%= arrthisTransactionDate(1) %>&nbsp;<%= arrthisTransactionDate(2) %></div>
												</div>
											</div>
											<div class="col-4 align-self-center text-right"><span class="p-2 <%= thisTransactionDirection %> rounded"><%= thisTransactionTotal %></span></div>
										</div>
									</a>
<%
									rsLargest.MoveNext

								Loop

								rsLargest.Close
								Set rsLargest = Nothing
%>
							</ul>

						</div>

						<div class="col-12 col-xl-8">

							<form method="post" action="/schmeckles/transactions/index.asp">

								<input type="hidden" name="action" value="update" />

								<div class="row m-0 p-0 mb-2">

									<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-5 p-0 pr-3">

										<select class="form-control form-control-lg form-check-input-lg mb-3" name="account" id="account">
											<option value="">ALL TEAMS</option>
		<%
											sqlGetAccountProfiles = "SELECT AccountID, ProfileName, ProfileURL FROM Accounts WHERE VerificationDate IS NOT NULL ORDER BY ProfileName ASC"
											Set rsAccountProfiles = sqlDatabase.Execute(sqlGetAccountProfiles)

											Do While Not rsAccountProfiles.Eof
		%>
												<option value="<%= rsAccountProfiles("ProfileURL") %>" <% If Session.Contents("SITE_Schmeckles_AccountID") = rsAccountProfiles("AccountID") Then %>selected<% End If %>><%= rsAccountProfiles("ProfileName") %></option>
		<%
												rsAccountProfiles.MoveNext

											Loop

											rsAccountProfiles.Close
		%>
										</select>

									</div>

									<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-5 p-0 pr-3">

										<select class="form-control form-control-lg form-check-input-lg mb-3" name="type" id="type">
											<option value="">ALL TYPES</option>
		<%
											sqlGetTypes = "SELECT * FROM SchmeckleTransactionTypes ORDER BY TransactionTypeTitle ASC"
											Set rsTypes = sqlDatabase.Execute(sqlGetTypes)

											Do While Not rsTypes.Eof
		%>
												<option value="<%= rsTypes("TransactionTypeSafeTitle") %>" <% If Session.Contents("SITE_Schmeckles_TypeID") = rsTypes("TransactionTypeID") Then %>selected<% End If %>><%= rsTypes("TransactionTypeTitle") %></option>
		<%
												rsTypes.MoveNext

											Loop

											rsTypes.Close
		%>
										</select>

									</div>

									<div class="col-12 col-xl-2 p-0">

										<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">UPDATE</button>

									</div>

								</div>

							</form>

							<ul class="list-group">
<%
								sqlGetSchmeckles = "SELECT TOP 15 SchmeckleTransactions.TransactionID, DATEADD(hour, -5, SchmeckleTransactions.TransactionDate) AS TransactionDate, SchmeckleTransactions.TransactionTypeID, TransactionTypeTitle, SchmeckleTransactions.TransactionTotal, "
								sqlGetSchmeckles = sqlGetSchmeckles & "SchmeckleTransactions.TransactionHash, SchmeckleTransactions.AccountID, SchmeckleTransactions.TicketSlipID, Accounts.ProfileName, Accounts.ProfileImage, SchmeckleTransactions.TransactionDescription "
								sqlGetSchmeckles = sqlGetSchmeckles & "FROM SchmeckleTransactions "
								sqlGetSchmeckles = sqlGetSchmeckles & "INNER JOIN SchmeckleTransactionTypes ON SchmeckleTransactionTypes.TransactionTypeID = SchmeckleTransactions.TransactionTypeID "
								sqlGetSchmeckles = sqlGetSchmeckles & "INNER JOIN Accounts ON Accounts.AccountID = SchmeckleTransactions.AccountID "
								'If Len(Session.Contents("SITE_Schmeckles_AccountID")) > 0 And IsNumeric(Session.Contents("SITE_Schmeckles_AccountID")) Then sqlGetSchmeckles = sqlGetSchmeckles & "WHERE SchmeckleTransactions.AccountID = " & Session.Contents("SITE_Schmeckles_AccountID")
								sqlGetSchmeckles = sqlGetSchmeckles & "ORDER BY TransactionDate DESC"

								Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

								Do While Not rsSchmeckles.Eof

									thisTransactionID = rsSchmeckles("TransactionID")
									thisTransactionDate = rsSchmeckles("TransactionDate")
									thisTransactionTypeID = rsSchmeckles("TransactionTypeID")
									thisTransactionTypeTitle = rsSchmeckles("TransactionTypeTitle")
									thisTransactionTotal = rsSchmeckles("TransactionTotal")
									thisTransactionHash = rsSchmeckles("TransactionHash")
									thisAccountID = rsSchmeckles("AccountID")
									thisTicketSlipID = rsSchmeckles("TicketSlipID")
									thisProfileName = rsSchmeckles("ProfileName")
									thisProfileImage = rsSchmeckles("ProfileImage")
									thisTransactionDescription = rsSchmeckles("TransactionDescription")
									arrthisTransactionDate = Split(thisTransactionDate, " ")
									If CDbl(thisTransactionTotal) > 0 Then
										thisTransactionDirection = "badge-success"
									Else
										thisTransactionDirection = "badge-danger"
									End If

									If CInt(thisAccountID) = 0 Then
										thisProfileName = "LOL BANK"
										thisProfileImage = "<img src=""/assets/images/logo-sm.png"" width=""40"" class=""rounded-circle float-left d-none d-xxl-block"">"
									Else
										thisProfileImage = "<img src=""https://samelevel.imgix.net/" & thisProfileImage & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle float-left d-none d-xxl-block mr-2"">"
									End If

									thisTransactionTotal = FormatNumber(thisTransactionTotal, 0)
									If thisTransactionTotal > 0 Then thisTransactionTotal = "+" & thisTransactionTotal
%>
									<a href="/schmeckles/transactions/<%= thisTransactionHash %>/" class="list-group-item list-group-item-action pl-0 pr-0">
										<div class="row p-0 m-0">
											<div class="col-8 col-lg-4 align-self-center">
												<%= thisProfileImage %>
												<div class="float-left">
													<div><b><%= thisProfileName %></b></div>
													<div><%= Month(thisTransactionDate) %>/<%= Day(thisTransactionDate) %>&nbsp;<%= arrthisTransactionDate(1) %>&nbsp;<%= arrthisTransactionDate(2) %></div>
												</div>
											</div>
											<div class="col-lg-5 align-self-center text-left d-none d-lg-block text-truncate">
												<div><i><%= thisTransactionHash %></i></div>
											</div>
											<div class="col-4 col-lg-3 align-self-center text-right"><span class="p-2 <%= thisTransactionDirection %> rounded"><%= thisTransactionTotal %></span></div>
										</div>
									</a>
<%
									rsSchmeckles.MoveNext

								Loop

								rsSchmeckles.Close
								Set rsSchmeckles = Nothing
%>
							</ul>

							<a href="/schmeckles/transactions/" class="btn btn-light btn-block mb-5">VIEW FULL LEDGER</a>

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
