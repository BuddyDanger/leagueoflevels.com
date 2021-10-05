<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!--#include virtual="/assets/asp/functions/sha256.asp"-->
<%
	If Len(ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))) < 1 Then Session.Contents("SITE_Schmeckles_AccountID") = ""

	If Request.Form("action") = "update" Then

		thisAccount = Request.Form("account")
		thisType = Request.Form("type")

		thisRedirect = "/schmeckles/transactions/"
		If Len(thisAccount) > 0 Then thisRedirect = thisRedirect & thisAccount & "/"
		If Len(thisType) > 0 Then thisRedirect = thisRedirect & thisType & "/"

		Response.Redirect(thisRedirect)

	End If

	sqlGetSchmeckles = "SELECT SchmeckleTransactions.TransactionID, DateAdd(hour, -4, SchmeckleTransactions.TransactionDate) AS TransactionDate, SchmeckleTransactions.TransactionTypeID, TransactionTypeTitle, SchmeckleTransactions.TransactionTotal, "
	sqlGetSchmeckles = sqlGetSchmeckles & "SchmeckleTransactions.TransactionHash, TransactionLastHash, TransactionNextHash, SchmeckleTransactions.AccountID, SchmeckleTransactions.TicketSlipID, Accounts.ProfileName, Accounts.ProfileImage, SchmeckleTransactions.TransactionDescription "
	sqlGetSchmeckles = sqlGetSchmeckles & "FROM SchmeckleTransactions "
	sqlGetSchmeckles = sqlGetSchmeckles & "INNER JOIN SchmeckleTransactionTypes ON SchmeckleTransactionTypes.TransactionTypeID = SchmeckleTransactions.TransactionTypeID "
	sqlGetSchmeckles = sqlGetSchmeckles & "LEFT JOIN Accounts ON Accounts.AccountID = SchmeckleTransactions.AccountID "
	If Len(Session.Contents("SITE_Schmeckles_TransactionHash")) > 0 Then sqlGetSchmeckles = sqlGetSchmeckles & "WHERE SchmeckleTransactions.TransactionHash = '" & Session.Contents("SITE_Schmeckles_TransactionHash") & "' "

	Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

	If Not rsSchmeckles.Eof Then

		thisTransactionID = rsSchmeckles("TransactionID")
		thisTransactionDate = rsSchmeckles("TransactionDate")
		thisTransactionTypeID = rsSchmeckles("TransactionTypeID")
		thisTransactionTypeTitle = rsSchmeckles("TransactionTypeTitle")
		thisTransactionTotal = rsSchmeckles("TransactionTotal")
		thisTransactionHash = rsSchmeckles("TransactionHash")
		thisTransactionLastHash = rsSchmeckles("TransactionLastHash")
		thisTransactionNextHash = rsSchmeckles("TransactionNextHash")
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
			thisProfileImage = "<img src=""http://leagueoflevels/assets/images/logo-sm.png"" width=""40"" class=""rounded-circle float-left"">"
		Else
			thisProfileImage = "<img src=""https://samelevel.imgix.net/" & thisProfileImage & "?w=40&h=40&fit=crop&crop=focalpoint"" class=""rounded-circle float-left"">"
		End If

		thisTransactionTotal = FormatNumber(thisTransactionTotal, 0)
		If thisTransactionTotal > 0 Then thisTransactionTotal = "+" & thisTransactionTotal

		thisPageTitle = "Transaction Details / " & thisProfileName & " / " & thisTransactionDate & " / League of Levels"
		thisPageDescription = "Detailed information on the Schmeckle transaction made " & thisTransactionDate & " by " & thisProfileName & "."

	Else

		Response.Redirect("/schmeckles/transactions/")

	End If
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

					<div class="row mt-4">

						<div class="col-12">

							<h4 class="text-left bg-info text-white p-3 mt-0 mb-0 rounded-top"><b>TRANSACTION DETAILS</b><span class="float-right dripicons-list"></i></h4>
							<ul class="list-group list-group-flush mb-4">
<%
								sqlGetSchmeckles = "SELECT SchmeckleTransactions.TransactionID, DateAdd(hour, -4, SchmeckleTransactions.TransactionDate) AS TransactionDate, SchmeckleTransactions.TransactionTypeID, TransactionTypeTitle, SchmeckleTransactions.TransactionTotal, "
								sqlGetSchmeckles = sqlGetSchmeckles & "SchmeckleTransactions.TransactionHash, TransactionLastHash, TransactionNextHash, SchmeckleTransactions.AccountID, SchmeckleTransactions.TicketSlipID, Accounts.ProfileName, Accounts.ProfileImage, SchmeckleTransactions.TransactionDescription "
								sqlGetSchmeckles = sqlGetSchmeckles & "FROM SchmeckleTransactions "
								sqlGetSchmeckles = sqlGetSchmeckles & "INNER JOIN SchmeckleTransactionTypes ON SchmeckleTransactionTypes.TransactionTypeID = SchmeckleTransactions.TransactionTypeID "
								sqlGetSchmeckles = sqlGetSchmeckles & "LEFT JOIN Accounts ON Accounts.AccountID = SchmeckleTransactions.AccountID "
								If Len(Session.Contents("SITE_Schmeckles_TransactionHash")) > 0 Then sqlGetSchmeckles = sqlGetSchmeckles & "WHERE SchmeckleTransactions.TransactionHash = '" & Session.Contents("SITE_Schmeckles_TransactionHash") & "' "

								Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

								If Not rsSchmeckles.Eof Then
%>
									<li href="/schmeckles/transactions/<%= thisTransactionHash %>/" class="list-group-item list-group-item-action rounded-bottom">
										<div class="row">
											<div class="col-8 col-lg-3 align-self-center">
												<%= thisProfileImage %>
												<div class="float-left pl-2">
													<div><b><%= thisProfileName %></b></div>
													<div><%= Month(thisTransactionDate) %>/<%= Day(thisTransactionDate) %>&nbsp;<%= arrthisTransactionDate(1) %>&nbsp;<%= arrthisTransactionDate(2) %></div>
												</div>
											</div>
											<div class="col-lg-2 align-self-center text-left d-none d-lg-block">
												<span class="p-2 badge-light rounded"><%= thisTransactionTypeTitle %><span>
											</div>
											<div class="col-lg-4 align-self-center text-left d-none d-lg-block text-truncate">
												<div class="d-inline-block text-truncate"><i><%= thisTransactionHash %></i></div>
											</div>
											<div class="col-4 col-lg-3 align-self-center text-right"><span class="p-2 <%= thisTransactionDirection %> rounded"><%= thisTransactionTotal %></span></div>
										</div>
									</li>
<%
									rsSchmeckles.Close
									Set rsSchmeckles = Nothing

								End If
%>
							</ul>

						</div>

					</div>

					<div class="row row-eq-height">

						<div class="col-12 col-xl-2">

							<div class="bg-white mb-4 rounded">
								<div id="transaction_hash"></div>
							</div>

						</div>

						<div class="col-12 col-xl-10">

							<ul class="list-group list-group-flush mb-4">
								<li class="list-group-item list-group-item-action rounded-top p-0">
									<h4 class="text-left bg-info text-white p-3 mt-0 mb-0 rounded-top"><b>RELATED TICKETS</b><span class="float-right dripicons-jewel"></span></h4>
								</li>
<%
								If IsNumeric(thisTicketSlipID) Then

									sqlCheckType = "SELECT NFLGameID FROM TicketSlips WHERE TicketSlipID = " & thisTicketSlipID
									Set rsTicketType = sqlDatabase.Execute(sqlCheckType)

									If Not rsTicketType.Eof Then

										thisTicketType = rsTicketType("NFLGameID")
										rsTicketType.Close
										Set rsTicketType = Nothing
										
										If Not IsNull(thisTicketType) Then

											sqlGetTicketSlips = "SELECT TicketSlipID, TicketTypeID, TicketSlips.AccountID, Accounts.ProfileName, DateAdd(hour, -4, TicketSlips.InsertDateTime) AS InsertDateTime, T1.Abbreviation AS AwayAbbr, T2.Abbreviation AS HomeAbbr, NFLGames.AwayTeamID AS TeamID1, NFLGames.HomeTeamID AS TeamID2, T1.City + ' ' + T1.Name AS TeamName1, T2.City + ' ' + T2.Name AS TeamName2, T3.City + ' ' + T3.Name AS BetTeamName, TicketSlips.TeamID, TicketSlips.Moneyline, TicketSlips.Spread, TicketSlips.OverUnderAmount, OverUnderBet, TicketSlips.BetAmount, TicketSlips.PayoutAmount, TicketSlips.IsWinner FROM TicketSlips "
											sqlGetTicketSlips = sqlGetTicketSlips & "INNER JOIN Accounts ON Accounts.AccountID = TicketSlips.AccountID "
											sqlGetTicketSlips = sqlGetTicketSlips & "INNER JOIN NFLGames ON NFLGames.NFLGameID = TicketSlips.NFLGameID "
											sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN NFLTeams T1 ON T1.NFLTeamID = NFLGames.AwayTeamID "
											sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN NFLTeams T2 ON T2.NFLTeamID = NFLGames.HomeTeamID "
											sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN NFLTeams T3 ON T3.NFLTeamID = TicketSlips.TeamID "
											sqlGetTicketSlips = sqlGetTicketSlips & "WHERE TicketSlipID = " & thisTicketSlipID

											Set rsTicketSlips = sqlDatabase.Execute(sqlGetTicketSlips)
											If Not rsTicketSlips.Eof Then

												thisTicketSlipID = rsTicketSlips("TicketSlipID")
												thisTicketTypeID = rsTicketSlips("TicketTypeID")
												thisAccountID = rsTicketSlips("AccountID")
												thisProfileName = rsTicketSlips("ProfileName")
												thisInsertDateTime = rsTicketSlips("InsertDateTime")
												thisTeamAbbr1 = rsTicketSlips("AwayAbbr")
												thisTeamAbbr2 = rsTicketSlips("HomeAbbr")
												thisTeamName1 = rsTicketSlips("TeamName1")
												thisTeamName2 = rsTicketSlips("TeamName2")
												thisBetTeamName = rsTicketSlips("BetTeamName")
												thisMoneyline = rsTicketSlips("Moneyline")
												thisSpread = rsTicketSlips("Spread")
												thisOverUnderAmount = rsTicketSlips("OverUnderAmount")
												thisOverUnderBet = rsTicketSlips("OverUnderBet")
												thisBetAmount = rsTicketSlips("BetAmount")
												thisPayoutAmount = rsTicketSlips("PayoutAmount")
												thisIsWinner = rsTicketSlips("IsWinner")

												If IsNumeric(thisIsWinner) Then
													If thisIsWinner Then
														thisTicketStatus = "WINNER"
														thisTicketDirection = "bg-success"
													Else
														thisTicketStatus = "LOSER"
														thisTicketDirection = "bg-danger"
													End If
												Else
													thisTicketStatus = "IN PROGRESS"
													thisTicketDirection = "bg-light"
												End If

												arrthisTicketDate = Split(thisInsertDateTime, " ")

												If CInt(thisTicketTypeID) = 1 Then
													If thisMoneyline > 0 Then thisMoneyline = "+" & thisMoneyline
													thisTicketDetails = thisMoneyline & " ML"
												End If
												If CInt(thisTicketTypeID) = 2 Then
													If thisSpread > 0 Then thisSpread = "+" & thisSpread
													thisTicketDetails = "(" & thisSpread & ")"
												End If
												If CInt(thisTicketTypeID) = 3 Then
													thisBetTeamName = thisTeamAbbr1 & "@" & thisTeamAbbr2
													thisTicketDetails = thisOverUnderBet & " (" & thisOverUnderAmount & ")"
												End If
%>
												<a href="#" class="list-group-item list-group-item-action rounded-bottom">
													<div class="row">
														<div class="col-6 col-lg-3 align-self-center">
															<div class="float-left pl-2">
																<div><%= thisTeamAbbr1 %> @ <%= thisTeamAbbr2 %></div>
																<div><%= Month(thisInsertDateTime) %>/<%= Day(thisInsertDateTime) %>&nbsp;<%= arrthisTicketDate(1) %>&nbsp;<%= arrthisTicketDate(2) %></div>
															</div>
														</div>
														<div class="col-lg-6 align-self-center text-center d-none d-lg-block">
															<span class="p-2 badge-light rounded"><%= thisBetTeamName %>&nbsp;<%= thisTicketDetails %><span>
														</div>
														<div class="col-6 col-lg-3 align-self-center text-right"><span class="p-2 <%= thisTicketDirection %> rounded"><%= thisTicketStatus %></span></div>
													</div>
												</a>
<%
											End If

										Else

											sqlGetTicketSlips = "SELECT TicketSlipID, TicketTypeID, TicketSlips.AccountID, Accounts.ProfileName, DateAdd(hour, -4, TicketSlips.InsertDateTime) AS InsertDateTime, Matchups.TeamID1, Matchups.TeamID2, Matchups.TeamScore1, Matchups.TeamScore2, T1.TeamName AS TeamName1, T2.TeamName AS TeamName2, T3.TeamName AS BetTeamName, TicketSlips.TeamID, TicketSlips.Moneyline, TicketSlips.Spread, TicketSlips.OverUnderAmount, OverUnderBet, TicketSlips.BetAmount, TicketSlips.PayoutAmount, TicketSlips.IsWinner FROM TicketSlips "
											sqlGetTicketSlips = sqlGetTicketSlips & "INNER JOIN Accounts ON Accounts.AccountID = TicketSlips.AccountID "
											sqlGetTicketSlips = sqlGetTicketSlips & "INNER JOIN Matchups ON Matchups.MatchupID = TicketSlips.MatchupID "
											sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN Teams T1 ON T1.TeamID = Matchups.TeamID1 "
											sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN Teams T2 ON T2.TeamID = Matchups.TeamID2 "
											sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN Teams T3 ON T3.TeamID = TicketSlips.TeamID "
											sqlGetTicketSlips = sqlGetTicketSlips & "WHERE TicketSlipID = " & thisTicketSlipID

											Set rsTicketSlips = sqlDatabase.Execute(sqlGetTicketSlips)
											If Not rsTicketSlips.Eof Then

												thisTicketSlipID = rsTicketSlips("TicketSlipID")
												thisTicketTypeID = rsTicketSlips("TicketTypeID")
												thisAccountID = rsTicketSlips("AccountID")
												thisProfileName = rsTicketSlips("ProfileName")
												thisInsertDateTime = rsTicketSlips("InsertDateTime")
												thisTeamName1 = rsTicketSlips("TeamName1")
												thisTeamName2 = rsTicketSlips("TeamName2")
												thisBetTeamName = rsTicketSlips("BetTeamName")
												thisMoneyline = rsTicketSlips("Moneyline")
												thisSpread = rsTicketSlips("Spread")
												thisOverUnderAmount = rsTicketSlips("OverUnderAmount")
												thisOverUnderBet = rsTicketSlips("OverUnderBet")
												thisBetAmount = rsTicketSlips("BetAmount")
												thisPayoutAmount = rsTicketSlips("PayoutAmount")
												thisIsWinner = rsTicketSlips("IsWinner")

												If IsNumeric(thisIsWinner) Then
													If thisIsWinner Then
														thisTicketStatus = "WINNER"
														thisTicketDirection = "bg-success text-white"
													Else
														thisTicketStatus = "LOSER"
														thisTicketDirection = "bg-danger"
													End If
												Else
													thisTicketStatus = "IN PROGRESS"
													thisTicketDirection = "bg-light"
												End If

												arrthisTicketDate = Split(thisInsertDateTime, " ")

												If CInt(thisTicketTypeID) = 1 Then
													If thisMoneyline > 0 Then thisMoneyline = "+" & thisMoneyline
													thisTicketDetails = thisMoneyline & " ML"
												End If
												If CInt(thisTicketTypeID) = 2 Then
													If thisSpread > 0 Then thisSpread = "+" & thisSpread
													thisTicketDetails = "(" & thisSpread & ")"
												End If
												If CInt(thisTicketTypeID) = 3 Then
													thisBetTeamName = thisTeamAbbr1 & "@" & thisTeamAbbr2
													thisTicketDetails = thisOverUnderBet & " (" & thisOverUnderAmount & ")"
												End If
%>
												<a href="#" class="list-group-item list-group-item-action rounded-bottom">
													<div class="row">
														<div class="col-6 col-lg-3 align-self-center">
															<div class="float-left pl-2">
																<div><%= thisTeamName1 %> @ <%= thisTeamName2 %></div>
																<div><%= Month(thisInsertDateTime) %>/<%= Day(thisInsertDateTime) %>&nbsp;<%= arrthisTicketDate(1) %>&nbsp;<%= arrthisTicketDate(2) %></div>
															</div>
														</div>
														<div class="col-lg-6 align-self-center text-center d-none d-lg-block">
															<span class="p-2 badge-light rounded"><%= thisBetTeamName %>&nbsp;<%= thisTicketDetails %><span>
														</div>
														<div class="col-6 col-lg-3 align-self-center text-right"><span class="p-2 <%= thisTicketDirection %> rounded"><%= thisTicketStatus %></span></div>
													</div>
												</a>
<%
											End If

										End If

									Else
										Response.Write("<li class=""list-group-item rounded-bottom"">NO TICKETS ASSOCIATED</li>")
									End If

								Else
									Response.Write("<li class=""list-group-item rounded-bottom"">NO TICKETS ASSOCIATED</li>")
								End If
%>
							</ul>

							<ul class="list-group list-group-flush mb-4">
								<li class="list-group-item list-group-item-action rounded-top p-0">
									<h4 class="text-left bg-info text-white p-3 mt-0 mb-0 rounded-top"><b>VERIFICATION</b><span class="float-right dripicons-link"></i></h4>
								</li>
<%
								If Len(thisTransactionNextHash) > 0 Then
%>
									<li class="list-group-item text-truncate"><a href="/schmeckles/transactions/<%= thisTransactionNextHash %>/"><span class="mdi mdi-check-circle-outline text-success"></span> <span class="text-info">NEXT</span> <%= thisTransactionNextHash %></a></li>
<%
								Else
%>
									<li class="list-group-item text-truncate"><span class="mdi mdi-dots-horizontal text-info"></span> <span class="text-info">N/A</span></li>
<%
								End If
%>
								<li class="list-group-item text-success text-truncate"><span class="mdi mdi-check-decagram"></span> <span class="text-success">HASH</span> <b><%= thisTransactionHash %></b></li>
								<li class="list-group-item text-truncate"><a href="/schmeckles/transactions/<%= thisTransactionLastHash %>/"><span class="mdi mdi-check-circle-outline text-success"></span> <span class="text-info">LAST</span> <%= thisTransactionLastHash %></a></li>
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
		<script src="https://unpkg.com/qrjs2@0.1.7/js/qrjs2.js"></script>

		<script src="/assets/js/app.js"></script>

		<script>

			var svgElement = document.getElementById("transaction_hash"),
			u = "https://www.leagueoflevels.com/schmeckles/transactions/<%= thisTransactionHash %>/",
			s = QRCode.generateSVG(u, {ecclevel: "M", fillcolor: "#FFFFFF", textcolor: "#373737", margin: 0, modulesize: 1});
			svgElement.appendChild(s);

		</script>

		<!--#include virtual="/assets/asp/framework/google.asp" -->

	</body>

</html>
