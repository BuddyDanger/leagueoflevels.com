<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	If Len(ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))) < 1 Then
		Session.Contents("SITE_Tickets_AccountID") = ""
		Session.Contents("SITE_Tickets_AccountProfileName") = ""
		Session.Contents("SITE_Tickets_TypeID") = ""
		Session.Contents("SITE_Tickets_TypeTitle") = ""
	End If

	If Request.Form("action") = "update" Then

		thisAccount = Request.Form("account")
		thisType = Request.Form("type")

		thisRedirect = "/sportsbook/tickets/"
		If Len(thisAccount) > 0 Then thisRedirect = thisRedirect & thisAccount & "/"
		If Len(thisType) > 0 Then thisRedirect = thisRedirect & thisType & "/"

		Response.Redirect(thisRedirect)

	End If

	thisPageTitle = "Sportsbook / Tickets / "
	If Len(Session.Contents("SITE_Tickets_AccountProfileName")) > 0 Then thisPageTitle = thisPageTitle & Session.Contents("SITE_Tickets_AccountProfileName") & " / "
	If Len(Session.Contents("SITE_Tickets_TypeTitle")) > 0 Then thisPageTitle = thisPageTitle & Session.Contents("SITE_Tickets_TypeTitle") & " / "
	thisPageTitle = thisPageTitle & "League of Levels"

	thisPageDescription = "Real-time LOL Sportsbook ticket tracker"
	If Len(Session.Contents("SITE_Tickets_AccountProfileName")) > 0 Then thisPageDescription = thisPageDescription & " for " & Session.Contents("SITE_Tickets_AccountProfileName")
	If Len(Session.Contents("SITE_Tickets_TypeTitle")) > 0 Then thisPageDescription = thisPageDescription & " across all '" & Session.Contents("SITE_Tickets_TypeTitle") & "' ticket types"
	If Len(Session.Contents("SITE_Tickets_AccountProfileName")) = 0 And Len(Session.Contents("SITE_Tickets_TypeTitle")) = 0 Then thisPageDescription = thisPageDescription & " tracking all ticket outcomes and related transactions."
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

				<div class="container-fluid">

					<form method="post" action="/sportsbook/tickets/index.asp">

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
										<option value="<%= rsAccountProfiles("ProfileURL") %>" <% If Session.Contents("SITE_Tickets_AccountID") = rsAccountProfiles("AccountID") Then %>selected<% End If %>><%= rsAccountProfiles("ProfileName") %></option>
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
									sqlGetTypes = "SELECT * FROM TicketTypes ORDER BY TypeTitle ASC"
									Set rsTypes = sqlDatabase.Execute(sqlGetTypes)

									Do While Not rsTypes.Eof
%>
										<option value="<%= FriendlyLinkText(rsTypes("TypeTitle")) %>" <% If Session.Contents("SITE_Tickets_TypeID") = rsTypes("TicketTypeID") Then %>selected<% End If %>><%= rsTypes("TypeTitle") %></option>
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

					<div class="mt-4">
<%
						ticketsAccountID = ""
						ticketsTypeID = ""
						ticketsNFLGameID = ""
						ticketsMatchupID = ""
						ticketsProcessed = ""
						If Len(Session.Contents("SITE_Tickets_AccountID")) > 0 Then ticketsAccountID = Session.Contents("SITE_Tickets_AccountID")
						If Len(Session.Contents("SITE_Tickets_TypeID")) > 0 Then ticketsTypeID = Session.Contents("SITE_Tickets_TypeID")
						If Len(Session.Contents("SITE_Tickets_NFLGameID")) > 0 Then ticketsNFLGameID = Session.Contents("SITE_Tickets_NFLGameID")
						If Len(Session.Contents("SITE_Tickets_MatchupID")) > 0 Then ticketsMatchupID = Session.Contents("SITE_Tickets_MatchupID")
						If Len(Session.Contents("SITE_Tickets_Processed")) > 0 Then ticketsProcessed = Session.Contents("SITE_Tickets_Processed")

						Call TicketRow (ticketsNFLGameID, ticketsMatchupID, ticketsAccountID, ticketsTypeID, ticketsProcessed)
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
