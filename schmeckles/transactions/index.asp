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

	thisPageTitle = "Schmeckles / Transactions / "
	If Len(Session.Contents("SITE_Schmeckles_AccountProfileName")) > 0 Then thisPageTitle = thisPageTitle & Session.Contents("SITE_Schmeckles_AccountProfileName") & " / "
	If Len(Session.Contents("SITE_Schmeckles_TypeTitle")) > 0 Then thisPageTitle = thisPageTitle & Session.Contents("SITE_Schmeckles_TypeTitle") & " / "
	thisPageTitle = thisPageTitle & "League of Levels"

	thisPageDescription = "Real-time Schmeckle transaction ledger"
	If Len(Session.Contents("SITE_Schmeckles_AccountProfileName")) > 0 Then thisPageDescription = thisPageDescription & " for " & Session.Contents("SITE_Schmeckles_AccountProfileName")
	If Len(Session.Contents("SITE_Schmeckles_TypeTitle")) > 0 Then thisPageDescription = thisPageDescription & " across all '" & Session.Contents("SITE_Schmeckles_TypeTitle") & "' transaction types"
	If Len(Session.Contents("SITE_Schmeckles_AccountProfileName")) = 0 And Len(Session.Contents("SITE_Schmeckles_TypeTitle")) = 0 Then thisPageDescription = thisPageDescription & " tracking all users and transaction types"
	thisPageDescription = thisPageDescription & "."
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

				<div class="container-fluid pl-0 pl-lg-2 pr-0 pr-lg-2">

					<form method="post" action="/schmeckles/transactions/index.asp">

						<input type="hidden" name="action" value="update" />

						<div class="row mt-4">

							<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-3">

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

							<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-3">

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

							<div class="col-12 col-xl-3">

								<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">UPDATE</button>

							</div>

						</div>

					</form>

					<div class="row mt-2">

						<div class="col-12">

							<ul class="list-group mb-4">
<%
								sqlGetSchmeckles = "SELECT TOP 500 SchmeckleTransactions.TransactionID, DateAdd(hour, -4, SchmeckleTransactions.TransactionDate) AS TransactionDate, SchmeckleTransactions.TransactionTypeID, TransactionTypeTitle, SchmeckleTransactions.TransactionTotal, "
								sqlGetSchmeckles = sqlGetSchmeckles & "SchmeckleTransactions.TransactionHash, SchmeckleTransactions.AccountID, SchmeckleTransactions.TicketSlipID, Accounts.ProfileName, Accounts.ProfileImage, SchmeckleTransactions.TransactionDescription "
								If Len(Session.Contents("SITE_Schmeckles_AccountID")) > 0 And IsNumeric(Session.Contents("SITE_Schmeckles_AccountID")) Then sqlGetSchmeckles = sqlGetSchmeckles & ", (SELECT SUM(TransactionTotal) FROM SchmeckleTransactions S2 WHERE S2.AccountID = " & Session.Contents("SITE_Schmeckles_AccountID") & " AND S2.TransactionID <= SchmeckleTransactions.TransactionID) AS Balance "
								sqlGetSchmeckles = sqlGetSchmeckles & "FROM SchmeckleTransactions "
								sqlGetSchmeckles = sqlGetSchmeckles & "INNER JOIN SchmeckleTransactionTypes ON SchmeckleTransactionTypes.TransactionTypeID = SchmeckleTransactions.TransactionTypeID "
								sqlGetSchmeckles = sqlGetSchmeckles & "LEFT JOIN Accounts ON Accounts.AccountID = SchmeckleTransactions.AccountID "
								sqlGetSchmeckles = sqlGetSchmeckles & "WHERE 1 = 1 AND "
								If Len(Session.Contents("SITE_Schmeckles_AccountID")) > 0 And IsNumeric(Session.Contents("SITE_Schmeckles_AccountID")) Then sqlGetSchmeckles = sqlGetSchmeckles & "SchmeckleTransactions.AccountID = " & Session.Contents("SITE_Schmeckles_AccountID") & " AND "
								If Len(Session.Contents("SITE_Schmeckles_TypeID")) > 0 And IsNumeric(Session.Contents("SITE_Schmeckles_TypeID")) Then sqlGetSchmeckles = sqlGetSchmeckles & "SchmeckleTransactions.TransactionTypeID = " & Session.Contents("SITE_Schmeckles_TypeID") & " AND "
								sqlGetSchmeckles = Left(sqlGetSchmeckles, Len(sqlGetSchmeckles) - 4)
								sqlGetSchmeckles = sqlGetSchmeckles & "ORDER BY TransactionDate DESC"

								Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

								If rsSchmeckles.Eof Then
%>
									<li class="list-group-item list-group-item-action pl-0 pr-0">
										<b>NO TRANSACTIONS FOUND</b>
									</li>
<%
								Else

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
										If Len(Session.Contents("SITE_Schmeckles_AccountID")) > 0 And IsNumeric(Session.Contents("SITE_Schmeckles_AccountID")) Then thisTransactionBalance = FormatNumber(rsSchmeckles("Balance"), 0)
										arrthisTransactionDate = Split(thisTransactionDate, " ")
										If CDbl(thisTransactionTotal) > 0 Then
											thisTransactionDirection = "badge-success"
										Else
											thisTransactionDirection = "badge-danger"
										End If

										If CInt(thisAccountID) = 0 Then
											thisProfileName = "LOL BANK"
											thisProfileImage = "<img src=""/assets/images/logo-sm.png"" width=""40"" class=""rounded-circle float-left"">"
										Else
											thisProfileImage = "<img src=""https://samelevel.imgix.net/" & thisProfileImage & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle float-left"">"
										End If

										thisTransactionTotal = FormatNumber(thisTransactionTotal, 0)
										If thisTransactionTotal > 0 Then thisTransactionTotal = "+" & thisTransactionTotal
%>
										<a href="/schmeckles/transactions/<%= thisTransactionHash %>/" class="list-group-item list-group-item-action pl-2 pr-2">
											<div class="row">
												<div class="col-8 col-lg-3 align-self-center">
													<%= thisProfileImage %>
													<div class="float-left pl-2">
														<div><b><%= thisProfileName %></b></div>
														<div><%= Month(thisTransactionDate) %>/<%= Day(thisTransactionDate) %>/<%= Year(thisTransactionDate) %>&nbsp;<%= arrthisTransactionDate(1) %>&nbsp;<%= arrthisTransactionDate(2) %></div>
													</div>
												</div>
												<div class="col-lg-2 align-self-center text-left d-none d-lg-block">
													<span class="p-2 badge-light rounded"><%= thisTransactionTypeTitle %><span>
												</div>
												<div class="col-lg-4 align-self-center text-left d-none d-lg-block text-truncate">
													<div><i><%= thisTransactionHash %></i></div>
												</div>
												<div class="col-4 col-lg-3 align-self-center text-right"><span class="p-2 <%= thisTransactionDirection %> rounded"><%= thisTransactionTotal %></span><% If Len(Session.Contents("SITE_Schmeckles_AccountID")) > 0 And IsNumeric(Session.Contents("SITE_Schmeckles_AccountID")) Then %>  &nbsp; <span class="p-2 bg-light rounded d-none d-xl-inline-block"><%= thisTransactionBalance %></span><% End If %></div>
											</div>
										</a>
<%
										rsSchmeckles.MoveNext

									Loop

									rsSchmeckles.Close
									Set rsSchmeckles = Nothing

								End If
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
