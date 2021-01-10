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

				<div class="container-fluid">

					<div class="row">

						<div class="col-sm-12">

							<div class="page-title-box">

								<div class="float-right">

									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="/">Main</a></li>
										<li class="breadcrumb-item active">Schmeckles</li>
									</ol>

								</div>

								<h4 class="page-title">Schmeckles</h4>

							</div>

							<div class="page-content">

								<div class="row">

									<div class="col-12 col-lg-4">

										<h4>LEADERBOARD</h4>
										<div class="card">

											<div class="card-body">

												<table class="table table-bordered mb-1">
													<thead>
														<tr>
															<th scope="col">TEAM</th>
															<th class="text-center" scope="col">SCHMECKLES</th>
														</tr>
													</thead>
													<tbody>
<%
														sqlGetLeaderboard = "SELECT Accounts.ProfileName, Accounts.ProfileImage, SUM([TransactionTotal]) AS TotalSchmeckles FROM SchmeckleTransactions INNER JOIN Accounts ON Accounts.AccountID = SchmeckleTransactions.AccountID GROUP BY Accounts.ProfileName, Accounts.ProfileImage ORDER BY TotalSchmeckles DESC"
														Set rsLeaderboard = sqlDatabase.Execute(sqlGetLeaderboard)

														Do While Not rsLeaderboard.Eof
%>
															<tr>
																<td><img src="https://samelevel.imgix.net/<%= rsLeaderboard("ProfileImage") %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-xl-inline"> &nbsp;<%= rsLeaderboard("ProfileName") %></td>
																<td class="text-center" width="40%"><%= FormatNumber(rsLeaderboard("TotalSchmeckles"), 0) %></td>
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

									<div class="col-12 col-lg-8">

										<h4>TRANSACTION LEDGER</h4>
										<div class="card">

											<div class="card-body">

												<table class="table table-bordered mb-1">
													<thead>
														<tr>
															<th>DATE</th>
															<th>TEAM</th>
															<th class="d-none d-lg-table-cell">TYPE</th>
															<th class="text-right">TOTAL</th>
														</tr>
													</thead>
													<tbody>
<%
													sqlGetSchmeckles = "SELECT SchmeckleTransactions.TransactionID, DateAdd(hour, -5, SchmeckleTransactions.TransactionDate) AS TransactionDate, SchmeckleTransactions.TransactionTypeID, TransactionTypeTitle, SchmeckleTransactions.TransactionTotal, "
													sqlGetSchmeckles = sqlGetSchmeckles & "SchmeckleTransactions.AccountID, SchmeckleTransactions.TicketSlipID, Accounts.ProfileName, Accounts.ProfileImage, SchmeckleTransactions.TransactionDescription "
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
														thisAccountID = rsSchmeckles("AccountID")
														thisTicketSlipID = rsSchmeckles("TicketSlipID")
														thisProfileName = rsSchmeckles("ProfileName")
														thisProfileImage = rsSchmeckles("ProfileImage")
														thisTransactionDescription = rsSchmeckles("TransactionDescription")
														arrthisTransactionDate = Split(thisTransactionDate, " ")
														If CDbl(thisTransactionTotal) > 0 Then
															thisTransactionDirection = "text-success"
														Else
															thisTransactionDirection = "text-danger"
														End If

														thisTransactionTotal = FormatNumber(thisTransactionTotal, 0)
														If thisTransactionTotal > 0 Then thisTransactionTotal = "+" & thisTransactionTotal

%>
														<tr>
															<th scope="row">
																<div class="d-none d-lg-table-cell"><div><%= arrthisTransactionDate(0) %></div><div><%= arrthisTransactionDate(1) %>&nbsp;<%= arrthisTransactionDate(2) %> (EST)</div></div>
																<div class="d-block d-lg-none"><%= Month(arrthisTransactionDate(0)) & "/" & Day(arrthisTransactionDate(0)) %></div></div>
															</th>
															<td><img src="https://samelevel.imgix.net/<%= thisProfileImage %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline"> &nbsp;<%= thisProfileName %></td>
															<td class="d-none d-lg-table-cell"><%= thisTransactionTypeTitle %></td>
															<td class="text-right <%= thisTransactionDirection %>"><%= thisTransactionTotal %></td>
														</tr>
<%
														rsSchmeckles.MoveNext

													Loop

													rsSchmeckles.Close
													Set rsSchmeckles = Nothing
%>
													</tbody>
												</table>

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

	</body>

</html>
