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

					<div class="row mt-4">
<%
						If Request.QueryString("action") = "switch" Then

							Session.Contents("switchSLFFL") = 0
							Session.Contents("switchFLFFL") = 0
							Session.Contents("switchOMEGA") = 0
							Session.Contents("switchBLFFL") = 0

							thisSLFFL = Request.QueryString("SLFFL")
							thisFLFFL = Request.QueryString("FLFFL")
							thisOMEGA = Request.QueryString("OMEGA")
							thisBLFFL = Request.QueryString("BLFFL")

							If thisSLFFL = 1 Then Session.Contents("switchSLFFL") = 1
							If thisFLFFL = 1 Then Session.Contents("switchFLFFL") = 1
							If thisOMEGA = 1 Then Session.Contents("switchOMEGA") = 1
							If thisBLFFL = 1 Then Session.Contents("switchBLFFL") = 1

						End If

						sqlGetTransactionData = "SELECT SUM(CAST(REPLACE([MoveAction], 'Signed for $', '') AS INT)) AS TotalSpent FROM [dbo].[Transactions] WHERE Year = 2024 AND LEFT([MoveAction], 12) = 'Signed for $' AND "
						If Session.Contents("switchOMEGA") = 1 Or Session.Contents("switchSLFFL") = 1 Or Session.Contents("switchFLFFL") = 1 Or Session.Contents("switchBLFFL") = 1 Then
							sqlGetTransactionData = sqlGetTransactionData & "Transactions.LevelID IN ("
							If Session.Contents("switchOMEGA") Then sqlGetTransactionData = sqlGetTransactionData & "1,"
							If Session.Contents("switchSLFFL") Then sqlGetTransactionData = sqlGetTransactionData & "2,"
							If Session.Contents("switchFLFFL") Then sqlGetTransactionData = sqlGetTransactionData & "3,"
							If Session.Contents("switchBLFFL") Then sqlGetTransactionData = sqlGetTransactionData & "4,"
							If Right(sqlGetTransactionData, 1) = "," Then sqlGetTransactionData = Left(sqlGetTransactionData, Len(sqlGetTransactionData)-1)
							sqlGetTransactionData = sqlGetTransactionData & ") AND "
						End If
						sqlGetTransactionData = Left(sqlGetTransactionData, Len(sqlGetTransactionData) - 4) & ";"
						sqlGetTransactionData = sqlGetTransactionData & "SELECT COUNT(COUNT) AS TotalCount FROM (SELECT count(TransactionCBSID) AS COUNT FROM [dbo].[Transactions] WHERE Year = 2024 AND "
						If Session.Contents("switchOMEGA") = 1 Or Session.Contents("switchSLFFL") = 1 Or Session.Contents("switchFLFFL") = 1 Or Session.Contents("switchBLFFL") = 1 Then
							sqlGetTransactionData = sqlGetTransactionData & "Transactions.LevelID IN ("
							If Session.Contents("switchOMEGA") Then sqlGetTransactionData = sqlGetTransactionData & "1,"
							If Session.Contents("switchSLFFL") Then sqlGetTransactionData = sqlGetTransactionData & "2,"
							If Session.Contents("switchFLFFL") Then sqlGetTransactionData = sqlGetTransactionData & "3,"
							If Session.Contents("switchBLFFL") Then sqlGetTransactionData = sqlGetTransactionData & "4,"
							If Right(sqlGetTransactionData, 1) = "," Then sqlGetTransactionData = Left(sqlGetTransactionData, Len(sqlGetTransactionData)-1)
							sqlGetTransactionData = sqlGetTransactionData & ") AND "
						End If
						sqlGetTransactionData = Left(sqlGetTransactionData, Len(sqlGetTransactionData) - 4) & " "
						sqlGetTransactionData = sqlGetTransactionData & "GROUP BY TransactionCBSID) A;"
						Set rsTransactionData = sqlDatabase.Execute(sqlGetTransactionData)

						If Not rsTransactionData.Eof Then

							thisTotalSpentAmount = rsTransactionData("TotalSpent")
							Set rsTransactionData = rsTransactionData.NextRecordset
							thisTotalCount = rsTransactionData("TotalCount")

							If IsNull(thisTotalSpentAmount) Then thisTotalSpentAmount = 0
%>
							<div class="col-xl-4 col-md-6 col-12">
								<a href="#" style="text-decoration: none; display: block;">
									<ul class="list-group mb-4">
										<li class="list-group-item p-0">
											<h4 class="text-left bg-dark text-white p-3 mt-0 mb-0 rounded-top"><b>TRANSACTION STATS</b><span class="float-right dripicons-graph-pie"></i></h4>
										</li>
										<li class="list-group-item">
											<span class="float-right">$<%= FormatNumber(thisTotalSpentAmount, 0) %></span>
											<div><b>TOTAL FAAB SPENT</b></div>
											<div>Across <%= thisTotalCount %> Individual Transactions</div>
										</li>
									</ul>
								</a>
							</div>
<%
							rsTransactionData.Close
							Set rsTransactionData = Nothing

						End If
%>
						<div class="col-lg-6 col-md-6 col-12">

							<form action="/transactions/" method="get" id="filterForm">
								<input type="hidden" name="action" value="switch" />
								<div class="row">
									<div class="col-12">
										<div class="form-check form-check-inline">
											<div class="btn btn-dark mb-3">
												<div class="custom-control custom-switch">
													<input type="checkbox" class="custom-control-input" id="switchOMEGA" name="OMEGA" value="1" onchange="document.getElementById('filterForm').submit();" <% If Session.Contents("switchOMEGA") = 1 Then %>checked<% End If %>>
													<label class="custom-control-label text-white" for="switchOMEGA">OMEGA</label>
												</div>
											</div>
										</div>
										<div class="form-check form-check-inline">
											<div class="btn btn-dark mb-3">
												<div class="custom-control custom-switch">
													<input type="checkbox" class="custom-control-input" id="switchSLFFL" name="SLFFL" value="1" onchange="document.getElementById('filterForm').submit();" <% If Session.Contents("switchSLFFL") = 1 Then %>checked<% End If %>>
													<label class="custom-control-label text-white" for="switchSLFFL">SLFFL</label>
												</div>
											</div>
										</div>
										<div class="form-check form-check-inline">
											<div class="btn btn-dark mb-3">
												<div class="custom-control custom-switch">
													<input type="checkbox" class="custom-control-input" id="switchFLFFL" name="FLFFL" value="1" onchange="document.getElementById('filterForm').submit();" <% If Session.Contents("switchFLFFL") = 1 Then %>checked<% End If %>>
													<label class="custom-control-label text-white" for="switchFLFFL">FLFFL</label>
												</div>
											</div>
										</div>
										<div class="form-check form-check-inline">
											<div class="btn btn-dark mb-3">
												<div class="custom-control custom-switch">
													<input type="checkbox" class="custom-control-input" id="switchBLFFL" name="BLFFL" value="1" onchange="document.getElementById('filterForm').submit();" <% If Session.Contents("switchBLFFL") = 1 Then %>checked<% End If %>>
													<label class="custom-control-label text-white" for="switchBLFFL">BLFFL</label>
												</div>
											</div>
										</div>
									</div>
									
								</div>
                            </form>

						</div>

					</div>

					<div class="row mb-3">



<%
								sqlGetTransactions = "SELECT TransactionID, Transactions.LevelID, TransactionCBSID, TransactionDateTime, Levels.Title AS LevelTitle, Teams.TeamID, Teams.TeamName, Teams.AbbreviatedName, Accounts.ProfileName, Accounts.ProfileImage, Year, EffectivePeriod, MoveType, MoveAction, PlayerID, PlayerName, PlayerTeam, PlayerPosition "
								sqlGetTransactions = sqlGetTransactions & "FROM Transactions "
								sqlGetTransactions = sqlGetTransactions & "INNER JOIN Levels ON Levels.LevelID = Transactions.LevelID "
								sqlGetTransactions = sqlGetTransactions & "INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Transactions.TeamID "
								sqlGetTransactions = sqlGetTransactions & "INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID "
								sqlGetTransactions = sqlGetTransactions & "INNER JOIN Teams ON Teams.TeamID = Transactions.TeamID "
								sqlGetTransactions = sqlGetTransactions & "WHERE 1 = 1 AND Year = " & Session.Contents("CurrentYear") & " AND "
								If Session.Contents("switchOMEGA") = 1 Or Session.Contents("switchSLFFL") = 1 Or Session.Contents("switchFLFFL") = 1 Or Session.Contents("switchBLFFL") = 1 Then
									sqlGetTransactions = sqlGetTransactions & "Transactions.LevelID IN ("
									If Session.Contents("switchOMEGA") Then sqlGetTransactions = sqlGetTransactions & "1,"
									If Session.Contents("switchSLFFL") Then sqlGetTransactions = sqlGetTransactions & "2,"
									If Session.Contents("switchFLFFL") Then sqlGetTransactions = sqlGetTransactions & "3,"
									If Session.Contents("switchBLFFL") Then sqlGetTransactions = sqlGetTransactions & "4,"
									If Right(sqlGetTransactions, 1) = "," Then sqlGetTransactions = Left(sqlGetTransactions, Len(sqlGetTransactions)-1)
									sqlGetTransactions = sqlGetTransactions & ") AND "
								End If
								If Len(Session.Contents("SITE_Transactions_AccountID")) > 0 And IsNumeric(Session.Contents("SITE_Transactions_AccountID")) Then sqlGetTransactions = sqlGetTransactions & "Accounts.AccountID = " & Session.Contents("SITE_Transactions_AccountID") & " AND "
								If Session.Contents("SITE_Transactions_LevelID") > 0 Then sqlGetTransactions = sqlGetTransactions & "Levels.LevelID = " & Session.Contents("SITE_Transactions_LevelID") & " AND Year = " & Session.Contents("CurrentYear")
								sqlGetTransactions = Left(sqlGetTransactions, Len(sqlGetTransactions) - 4)
								sqlGetTransactions = sqlGetTransactions & "ORDER BY TransactionDateTime DESC"

								Set rsTransactions = sqlDatabase.Execute(sqlGetTransactions)

								If rsTransactions.Eof Then
%>

<%
								Else

									Do While Not rsTransactions.Eof

										thisTransactionID = rsTransactions("TransactionID")
										thisLevelID = rsTransactions("LevelID")
										thisTeamID = rsTransactions("TeamID")
										thisTransactionCBSID = rsTransactions("TransactionCBSID")
										thisTransactionDateTime = DateAdd("h", -4, rsTransactions("TransactionDateTime"))
										thisLevelTitle = rsTransactions("LevelTitle")
										thisTeamName = rsTransactions("TeamName")
										thisAbbreviatedName = rsTransactions("AbbreviatedName")
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

										If CInt(thisLevelID) = 1 Then
											headerBGcolor = "FFBA08"
											headerTextColor = "fff"
											cardText = "520000"
											thisLevelLabel = "OMEGA"
										End If
										If CInt(thisLevelID) = 2 Then
											headerBGcolor = "136F63"
											headerTextColor = "fff"
											cardText = "0F574D"
											thisLevelLabel = "SLFFL"
										End If
										If CInt(thisLevelID) = 3 Then
											headerBGcolor = "995D81"
											headerTextColor = "fff"
											cardText = "03324F"
											thisLevelLabel = "FLFFL"
										End If
										If CInt(thisLevelID) = 4 Then
											headerBGcolor = "39A9DB"
											headerTextColor = "fff"
											cardText = "03324F"
											thisLevelLabel = "BLFFL"
										End If

										If Left(thisMoveAction, 6) = "Signed" Then thisMoveIcon = "plus"
										If Left(thisMoveAction, 6) = "Droppe" Then thisMoveIcon = "minus"
										If Left(thisMoveAction, 6) = "Traded" Then thisMoveIcon = "plus"

										arrthisTransactionDateTime = Split(thisTransactionDateTime, " ")
										arrthisTransactionTime = Split(arrthisTransactionDateTime(1), ":")

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

										If thisTeamID = 87 Then thisTeamName = thisAbbreviatedName
%>
										<div class="col-xxxl-3 col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-sm-12 col-xs-12 col-xxs-12">
											<ul class="list-group mb-3">
												<li class="list-group-item py-2" style="background-color: #<%= headerBGcolor %>; color: #<%= headerTextColor %>;">
													<div class="float-right"><small><%= Month(thisTransactionDateTime) %>/<%= Day(thisTransactionDateTime) %>&nbsp;<%= arrthisTransactionTime(0) %>:<%= arrthisTransactionTime(1) %>&nbsp;<%= arrthisTransactionDateTime(2) %></small></div>
													<b><%= thisTeamName %></b>
												</li>
												<li class="list-group-item">
													<div class="my-1"><span class="p-2 badge-light rounded"><small><i class="dripicons-<%= thisMoveIcon %>"></i></small></span> &nbsp;<b><%= thisPlayerName %></b>, <%= thisPlayerPosition %> (<%= thisPlayerTeam %>) &nbsp;<% If thisMoveAction <> "Signed for $0" And thisMoveAction <> "Dropped" Then %><span class="p-2 badge-light rounded"><small><%= thisMoveAction %></small><span><% End If %></div>
												</li>
												<% If Len(pairPlayerName) > 0 Then %>
												<li class="list-group-item">
													<div class="my-1"><span class="p-2 badge-light rounded"><small><i class="dripicons-<%= pairMoveIcon %>"></i></small></span> &nbsp;<b><%= pairPlayerName %></b>, <%= pairPlayerPosition %> (<%= pairPlayerTeam %>) &nbsp;<% If pairMoveAction <> "Dropped" Then %><span class="p-2 badge-light rounded"><small><%= pairMoveAction %></small><span><% End If %></div>
												</li>
												<% End If %>
											</ul>
										</div>

<%
									Loop

									rsTransactions.Close
									Set rsTransactions = Nothing

								End If
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
