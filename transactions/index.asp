<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	If Len(ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))) < 1 Then
		Session.Contents("SITE_Transactions_LevelID") = 0
	End If

	If Request.Form("action") = "update" Then

		thisAccount = Request.Form("level")

		thisRedirect = "/transactions/"
		If Len(thisAccount) > 0 Then thisRedirect = thisRedirect & thisAccount & "/"
		If Len(thisType) > 0 Then thisRedirect = thisRedirect & thisType & "/"

		Response.Redirect(thisRedirect)

	End If

	thisPageTitle = "Transactions / "
	If Len(Session.Contents("SITE_Transactions_AccountProfileName")) > 0 Then thisPageTitle = thisPageTitle & Session.Contents("SITE_Transactions_AccountProfileName") & " / "
	If Len(Session.Contents("SITE_Transactions_TypeTitle")) > 0 Then thisPageTitle = thisPageTitle & Session.Contents("SITE_Transactions_TypeTitle") & " / "
	thisPageTitle = thisPageTitle & "League of Levels"

	thisPageDescription = "Real-time roster transaction ledger"
	If Len(Session.Contents("SITE_Transactions_AccountProfileName")) > 0 Then thisPageDescription = thisPageDescription & " for " & Session.Contents("SITE_Transactions_AccountProfileName")
	If Len(Session.Contents("SITE_Transactions_TypeTitle")) > 0 Then thisPageDescription = thisPageDescription & " across all '" & Session.Contents("SITE_Transactions_TypeTitle") & "' transaction types"
	If Len(Session.Contents("SITE_Transactions_AccountProfileName")) = 0 And Len(Session.Contents("SITE_Transactions_TypeTitle")) = 0 Then thisPageDescription = thisPageDescription & " tracking all users and transaction types"
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
		<meta property="og:url" content="https://www.leagueoflevels.com/transactions/" />
		<meta property="og:title" content="<%= thisPageTitle %>" />
		<meta property="og:description" content="<%= thisPageDescription %>" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/transactions/" />
		<meta name="twitter:title" content="<%= thisPageTitle %>" />
		<meta name="twitter:description" content="<%= thisPageDescription %>" />

		<meta name="title" content="<%= thisPageTitle %>" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/transactions/" />

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

					<form method="post" action="/transactions/index.asp">

						<input type="hidden" name="action" value="update" />

						<div class="row mt-4">

							<div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-2">

								<select class="form-control form-control-lg form-check-input-lg mb-3" name="level" id="level">
									<option value="">ALL LEVELS</option>
									<option value="omega-level" <% If Session.Contents("SITE_Transactions_LevelID") = 1 Then %>selected<% End If %>>Omega Level</option>
									<option value="same-level" <% If Session.Contents("SITE_Transactions_LevelID") = 2 Then %>selected<% End If %>>Same Level</option>
									<option value="farm-level" <% If Session.Contents("SITE_Transactions_LevelID") = 3 Then %>selected<% End If %>>Farm Level</option>
								</select>

							</div>

							<div class="col-12 col-xl-2">

								<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-success mb-3">UPDATE</button>

							</div>

						</div>

					</form>

					<div class="row mt-2">

						<div class="col-12">

							<ul class="list-group mb-4">
<%
								sqlGetTransactions = "SELECT TransactionID, TransactionCBSID, TransactionDateTime, Levels.Title AS LevelTitle, Accounts.ProfileName, Accounts.ProfileImage, Year, EffectivePeriod, MoveType, MoveAction, PlayerID, PlayerName, PlayerTeam, PlayerPosition "
								sqlGetTransactions = sqlGetTransactions & "FROM Transactions "
								sqlGetTransactions = sqlGetTransactions & "INNER JOIN Levels ON Levels.LevelID = Transactions.LevelID "
								sqlGetTransactions = sqlGetTransactions & "INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Transactions.TeamID "
								sqlGetTransactions = sqlGetTransactions & "INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID "
								sqlGetTransactions = sqlGetTransactions & "WHERE 1 = 1 AND "
								If Len(Session.Contents("SITE_Transactions_AccountID")) > 0 And IsNumeric(Session.Contents("SITE_Transactions_AccountID")) Then sqlGetTransactions = sqlGetTransactions & "Accounts.AccountID = " & Session.Contents("SITE_Transactions_AccountID") & " AND "
								If Session.Contents("SITE_Transactions_LevelID") > 0 Then sqlGetTransactions = sqlGetTransactions & "Levels.LevelID = " & Session.Contents("SITE_Transactions_LevelID") & " AND "
								sqlGetTransactions = Left(sqlGetTransactions, Len(sqlGetTransactions) - 4)
								sqlGetTransactions = sqlGetTransactions & "ORDER BY TransactionDateTime DESC"

								Set rsTransactions = sqlDatabase.Execute(sqlGetTransactions)

								If rsTransactions.Eof Then
%>
									<li class="list-group-item list-group-item-action pl-0 pr-0">
										<b>NO TRANSACTIONS FOUND</b>
									</li>
<%
								Else

									Do While Not rsTransactions.Eof

										thisTransactionID = rsTransactions("TransactionID")
										thisTransactionCBSID = rsTransactions("TransactionCBSID")
										thisTransactionDateTime = DateAdd("h", -4, rsTransactions("TransactionDateTime"))
										thisLevelTitle = rsTransactions("LevelTitle")
										thisProfileName = rsTransactions("ProfileName")
										thisProfileImage = rsTransactions("ProfileImage")
										thisYear = rsTransactions("Year")
										thisEffectivePeriod = rsTransactions("EffectivePeriod")
										thisMoveType = rsTransactions("MoveType")
										thisMoveAction = rsTransactions("MoveAction")
										thisPlayerID = rsTransactions("PlayerID")
										thisPlayerName = rsTransactions("PlayerName")
										thisPlayerTeam = rsTransactions("PlayerTeam")
										thisPlayerPosition = rsTransactions("PlayerPosition")
										thisProfileImage = "<img src=""https://samelevel.imgix.net/" & thisProfileImage & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle float-left"">"

										If thisLevelTitle = "Omega Level" Then
											thisLevelLabel = "OMEGA"
											thisLevelColor = "FFBA08"
										End If
										If thisLevelTitle = "Same Level" Then
											thisLevelLabel = "SLFFL"
											thisLevelColor = "136F63"
										End If
										If thisLevelTitle = "Farm Level" Then
											thisLevelLabel = "FLFFL"
											thisLevelColor = "032B43"
										End If

										If Left(thisMoveAction, 6) = "Signed" Then thisMoveIcon = "plus"
										If Left(thisMoveAction, 6) = "Droppe" Then thisMoveIcon = "minus"
										If Left(thisMoveAction, 6) = "Traded" Then thisMoveIcon = "plus"

										arrthisTransactionDateTime = Split(thisTransactionDateTime, " ")

										pairMoveType = ""
										pairMoveAction = ""
										pairPlayerID = ""
										pairPlayerName = ""
										pairPlayerTeam = ""
										pairPlayerPosition = ""

										rsTransactions.MoveNext

										If Not rsTransactions.Eof Then

											If rsTransactions("TransactionCBSID") = thisTransactionCBSID And rsTransactions("ProfileName") = thisProfileName Then

												pairMoveType = rsTransactions("MoveType")
												pairMoveAction = rsTransactions("MoveAction")
												pairPlayerID = rsTransactions("PlayerID")
												pairPlayerName = rsTransactions("PlayerName")
												pairPlayerTeam = rsTransactions("PlayerTeam")
												pairPlayerPosition = rsTransactions("PlayerPosition")

												If Left(pairMoveAction, 6) = "Signed" Then pairMoveIcon = "plus"
												If Left(pairMoveAction, 6) = "Droppe" Then pairMoveIcon = "minus"
												If Left(pairMoveAction, 6) = "Traded" Then pairMoveIcon = "plus"

												rsTransactions.MoveNext

											End If

										End If
%>
										<a href="#" class="list-group-item list-group-item-action pl-2 pr-2">
											<div class="row mb-2 mb-lg-0">
												<!-- TEAM INFO -->
												<div class="col-8 col-lg-3 align-self-center order-1">
													<%= thisProfileImage %>
													<div class="float-left pl-2">
														<div><b><%= thisProfileName %></b></div>
														<div><%= Month(thisTransactionDateTime) %>/<%= Day(thisTransactionDateTime) %>&nbsp;<%= arrthisTransactionDateTime(1) %>&nbsp;<%= arrthisTransactionDateTime(2) %></div>
													</div>
												</div>

												<!-- MOVE 1 -->
												<div class="col-12 col-lg-4 align-self-center order-3 order-lg-2 pl-3 pl-lg-2 pt-3 pt-lg-0">
													<div class="pl-1 pl-lg-0"><span class="p-2 badge-light rounded"><small><i class="dripicons-<%= thisMoveIcon %>"></i></small></span> &nbsp;<b><%= thisPlayerName %></b>, <%= thisPlayerPosition %> (<%= thisPlayerTeam %>) &nbsp;<% If thisMoveAction <> "Signed for $0" Then %><span class="p-2 badge-light rounded"><small><%= thisMoveAction %></small><span><% End If %></div>
												</div>

												<!-- MOVE TWO -->
												<div class="col-12 col-lg-4 align-self-center order-4 order-lg-3 <% If Len(pairPlayerName) > 0 Then %>pl-3 pl-lg-2 pt-3 pt-lg-0<% End If %>">
													<% If Len(pairPlayerName) > 0 Then %>
														<div class="pl-1 pl-lg-0"><span class="p-2 badge-light rounded"><small><i class="dripicons-<%= pairMoveIcon %>"></i></small></span> &nbsp;<b><%= pairPlayerName %></b>, <%= pairPlayerPosition %> (<%= pairPlayerTeam %>) &nbsp;<% If pairMoveAction <> "Dropped" Then %><span class="p-2 badge-light rounded"><small><%= pairMoveAction %></small><span><% End If %></div>
													<% End If %>
												</div>

												<div class="col-4 col-lg-1 align-self-center text-right order-2 order-lg-4">
													<span class="p-2 badge-info rounded" style="background-color: #<%= thisLevelColor %>;"><small><%= thisLevelLabel %> (<%= thisEffectivePeriod %>)</small></span>
												</div>

											</div>
										</a>
<%
									Loop

									rsTransactions.Close
									Set rsTransactions = Nothing

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
