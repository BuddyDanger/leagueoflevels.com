<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/sha256.asp" -->
<%
	thisAction = Request.Form("action")

	If thisAction = "go" Then

		thisEmail = Request.Form("accountEmail")
		thisPassword = Request.Form("accountPassword")
		thisRemember = Request.Form("accountRemember")
		SecretHashPassword = sha256(thisPassword)

		errorDetails = ""

		Set rsAccount = sqlDatabase.Execute("SELECT * FROM Accounts WHERE Email = '" & thisEmail & "' AND Password = '" & SecretHashPassword & "' AND VerificationDate IS NOT NULL")
		If rsAccount.Eof Then

			errorDetails = errorDetails & "The e-mail and password provided do not match our records.|"
			errorLogin = 1

		Else

			thisAccountID = rsAccount("AccountID")
			thisName = rsAccount("ProfileName")
			thisImage = rsAccount("ProfileImage")
			thisProfileURL = rsAccount("ProfileURL")
			thisBalls = rsAccount("Balls")

			rsAccount.Close
			Set rsAccount = Nothing

		End If

		If Len(errorDetails) = 0 Then

			If thisRemember = "on" Then

				Response.Cookies("AccountID") = thisAccountID
				Response.Cookies("AccountID").Expires = Date() + 365

				Response.Cookies("AccountHash") = SecretHashPassword
				Response.Cookies("AccountHash").Expires = Date() + 365

			End If

			Session.Contents("LoggedIn") = "yes"
			Session.Contents("AccountID") = thisAccountID
			Session.Contents("AccountHash") = SecretHashPassword
			Session.Contents("AccountEmail") = thisEmail
			Session.Contents("AccountName") = thisName
			Session.Contents("AccountImage") = thisImage
			Session.Contents("AccountProfileURL") = thisProfileURL
			Session.Contents("AccountBalls") = thisBalls

			sqlCheckTeams = "SELECT Teams.TeamID FROM LinkAccountsTeams INNER JOIN Teams ON Teams.TeamID = LinkAccountsTeams.TeamID WHERE LinkAccountsTeams.AccountID = " & Session.Contents("AccountID")
			Set rsTeams = sqlDatabase.Execute(sqlCheckTeams)

			If Not rsTeams.Eof Then

				Do While Not rsTeams.Eof

					thisTeamString = thisTeamString & rsTeams("TeamID") & ","
					rsTeams.MoveNext

				Loop

				rsTeams.Close
				Set rsTeams = Nothing

			End If

			If Right(thisTeamString, 1) = "," Then thisTeamString = Left(thisTeamString, Len(thisTeamString) - 1)

			Session.Contents("AccountTeams") = thisTeamString

			blockSuccess = ""
			blockLogin = "d-none"

		End If

	End If

	blockSuccess = "d-none"
	blockLogin = ""

	If Session.Contents("LoggedIn") = "yes" And Session.Contents("AccountVerified") <> 1 Then

		blockSuccess = ""
		blockLogin = "d-none"

	End If
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Account Registration / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="The League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="The League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="The League of Levels" />
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
										<li class="breadcrumb-item"><a href="javascript:void(0);">Login</a></li>
										<li class="breadcrumb-item active">Account</li>
									</ol>

								</div>

								<h4 class="page-title">Account Login</h4>

							</div>

						</div>

					</div>

					<div class="row">

						<div class="col-12 col-lg-6 col-xl-4">

							<div class="card <%= blockLogin %>">
                                <div class="card-body">
                                    <h4 class="mt-0 header-title">Login to the League of Levels</h4>
                                    <p class="text-muted mb-3">In order to get the most out of the site, login to your free account. If you're a current LOL member, you will be automatically attached to your team(s).</p>
<%
									If Session.Contents("AccountVerified") = 1 Then

										Response.Write("<div class=""alert alert-success"" role=""alert"">Account Successfully Verified. Eat Butt.</div>")

										Session.Contents("AccountVerified") = 0

									End If

									If Len(errorDetails) > 0 Then

										arrErrors = Split(errorDetails, "|")

										For i = 0 To UBound(arrErrors) - 1

											Response.Write("<div class=""alert alert-danger"" role=""alert"">" & arrErrors(i) & "</div>")

										Next

									End If
%>
									<form action="/account/login/" method="post">
										<input type="hidden" name="action" value="go" />
										<div class="form-group">
                                            <label for="accountEmail">Email address</label>
                                            <input type="email" class="form-control <% If errorLogin = 1 Then %>is-invalid<% End If %>" id="accountEmail" name="accountEmail" <% If Len(thisEmail) > 0 Then %>value="<%= thisEmail %>"<% End If %> required>
                                        </div>
										<div class="form-group">
                                            <label for="accountPassword">Password</label>
                                            <input type="password" class="form-control <% If errorLogin = 1 Then %>is-invalid<% End If %>" id="accountPassword" name="accountPassword" required>
                                        </div>
										<div class="form-group form-check mb-2">
											<input type="checkbox" class="form-check-input" id="accountRemember" name="accountRemember">
											<label class="form-check-label" for="accountRemember" value="1">Remember Me</label>
										</div>
										<button type="submit" class="btn btn-primary btn-sm mt-2 mr-2">Login</button>
										<button onclick="window.location.href = '/account/register/';" type="button" class="btn btn-secondary btn-sm mt-2 mr-2">Register</button>
										<button onclick="window.location.href = '/account/reset-password/';" type="button" class="btn btn-secondary btn-sm mt-2">Reset Password</button>
                                    </form>
                                </div>
                            </div>

							<div class="card <%= blockSuccess %>">
                                <div class="card-body">
                                    <h4 class="mt-0 header-title">Holy Shit? It Worked!</h4>
                                    <p class="text-muted mb-3">You have somehow managed to login and this is a quick note dedicated to just how cute you are with these computers. Just click the button below, you god damn magician.</p>
									<button onclick="window.location.href = '/';" type="button" class="btn btn-primary btn-sm mr-2">Back to Dashboard</button>
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
