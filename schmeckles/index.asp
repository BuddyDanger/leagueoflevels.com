<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	If Len(ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))) < 1 Then

		Session.Contents("SITE_Schmeckles_AccountID") = ""

	End If
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Schmeckles / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="Schmeckles - The League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="Schmeckles - The League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="Schmeckles - The League of Levels" />
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
										<li class="breadcrumb-item active">Schmeckles</li>
									</ol>

								</div>

								<h4 class="page-title">Schmeckles / Transaction Ledger</h4>

							</div>

							<div class="page-content">

								<div class="row">

									<div class="col-12 col-lg-4">

										<div class="card">

											<div class="card-body">

												<table class="table table-bordered">
													<thead>
														<tr>
															<th scope="col">TEAM</th>
															<th class="text-center" scope="col">SCHMECKLES</th>
														</tr>
													</thead>
													<tbody>
<%
														sqlGetLeaderboard = "SELECT Accounts.ProfileName, SUM([TransactionTotal]) AS TotalSchmeckles FROM SchmeckleTransactions INNER JOIN Accounts ON Accounts.AccountID = SchmeckleTransactions.AccountID GROUP BY Accounts.ProfileName ORDER BY TotalSchmeckles DESC"
														Set rsLeaderboard = sqlDatabase.Execute(sqlGetLeaderboard)

														Do While Not rsLeaderboard.Eof
%>
															<tr>
																<td><%= rsLeaderboard("ProfileName") %></td>
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

										<div class="card">

											<div class="card-body">

												<table class="table table-bordered">
													<thead>
														<tr>
															<th>DATE</th>
															<th>TEAM</th>
															<th>TYPE</th>
															<th class="text-right">TOTAL</th>
														</tr>
													</thead>
													<tbody>
<%
													sqlGetSchmeckles = "SELECT SchmeckleTransactions.TransactionID, SchmeckleTransactions.TransactionDate, SchmeckleTransactions.TransactionTypeID, TransactionTypeTitle, SchmeckleTransactions.TransactionTotal, "
													sqlGetSchmeckles = sqlGetSchmeckles & "SchmeckleTransactions.AccountID, SchmeckleTransactions.TicketSlipID, Accounts.ProfileName, Accounts.ProfileImage, SchmeckleTransactions.TransactionDescription "
													sqlGetSchmeckles = sqlGetSchmeckles & "FROM SchmeckleTransactions "
													sqlGetSchmeckles = sqlGetSchmeckles & "INNER JOIN SchmeckleTransactionTypes ON SchmeckleTransactionTypes.TransactionTypeID = SchmeckleTransactions.TransactionTypeID "
													sqlGetSchmeckles = sqlGetSchmeckles & "INNER JOIN Accounts ON Accounts.AccountID = SchmeckleTransactions.AccountID "
													If Len(Session.Contents("SITE_Schmeckles_AccountID")) > 0 And IsNumeric(Session.Contents("SITE_Schmeckles_AccountID")) Then sqlGetSchmeckles = sqlGetSchmeckles & "WHERE SchmeckleTransactions.AccountID = " & Session.Contents("SITE_Schmeckles_AccountID")
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
%>
														<tr>
															<th scope="row"><div><%= arrthisTransactionDate(0) %></div><div class="d-none d-lg-block"><%= arrthisTransactionDate(1) %>&nbsp;<%= arrthisTransactionDate(2) %></div></th>
															<td><img src="https://samelevel.imgix.net/<%= thisProfileImage %>?w=40&h=40&fit=crop&crop=focalpoint" class="rounded-circle hidden d-none d-sm-none d-md-inline"> &nbsp;<%= thisProfileName %></td>
															<td><%= thisTransactionTypeTitle %></div></td>
															<td class="text-right"><%= FormatNumber(thisTransactionTotal, 0) %></td>
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
