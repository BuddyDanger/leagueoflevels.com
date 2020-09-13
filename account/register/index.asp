<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/sha256.asp" -->
<%
	thisAction = Request.Form("action")
	blockSuccess = "d-none"
	blockRegister = ""

	If thisAction = "go" Then

		thisEmail = Request.Form("accountEmail")
		thisPassword = Request.Form("accountPassword")
		thisName = Request.Form("accountName")
		thisImage = "user.jpg"
		SecretHashPassword = sha256(thisPassword)

		If InStr(thisEmail, "'") Then thisEmail = Replace(thisEmail, "'", "")

		errorDetails = ""
		Set rsEmails = sqlDatabase.Execute("SELECT Email FROM Accounts WHERE Email = '" & thisEmail & "'")
		If Not rsEmails.Eof Then
			errorDetails = errorDetails & "The e-mail address provided is already in use.|"
			errorEmail = 1
			rsEmails.Close
			Set rsEmails = Nothing
		End If

		If Len(errorDetails) = 0 Then

			'REGISTER ACCOUNT
			Set rsInsert = Server.CreateObject("ADODB.RecordSet")
			rsInsert.CursorType = adOpenKeySet
			rsInsert.LockType = adLockOptimistic
			rsInsert.Open "Accounts", sqlDatabase, , , adCmdTable
			rsInsert.AddNew

			rsInsert("ProfileName") = thisName
			rsInsert("ProfileImage") = thisImage
			rsInsert("Email") = thisEmail
			rsInsert("Password") = SecretHashPassword

			rsInsert.Update

			thisAccountID = rsInsert("AccountID")

			Set rsInsert = Nothing

			blockSuccess = ""
			blockRegister = "d-none"

			sqlGetEmailTemplate = "SELECT * FROM Emails WHERE EmailID = 1"
			Set rsEmailTemplate = sqlDatabase.Execute(sqlGetEmailTemplate)

			If Not rsEmailTemplate.Eof Then

				thisSubjectLine = rsEmailTemplate("EmailSubject")
				thisEmailBody = rsEmailTemplate("EmailBody")
				FinalEmailBody = thisEmailBody

				rsEmailTemplate.Close
				Set rsEmailTemplate = Nothing

				FinalEmailBody = Replace(FinalEmailBody, "%%HASH%%", SecretHashPassword)
				FinalEmailBody = Replace(FinalEmailBody, "%%DATE%%", Now() & " UTC")
				FinalEmailBody = Replace(FinalEmailBody, "%%EMAIL%%", thisEmail)
				FinalEmailBody = Replace(FinalEmailBody, "%%NAME%%", thisName)

			End If

			Set objMail = CreateObject("CDO.Message")
			Set objConfig = CreateObject("CDO.Configuration")
			objConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
			objConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
			objConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465
			objConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
			objConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
			objConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "info@leagueoflevels.com"
			objConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "TheHammer123"
			objConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True

			objConfig.Fields.Update
			Set objMail.Configuration = objConfig
			objMail.To = thisEmail

			objMail.From = """LOL Team"" <info@leagueoflevels.com>"
			objMail.ReplyTo = """LOL Team"" <info@leagueoflevels.com>"
			objMail.Subject = thisSubjectLine
			objMail.HTMLbody = FinalEmailBody

			On Error Resume Next
			objMail.Send

			Set objMail = Nothing
			Set objConfig = Nothing

		End If

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
										<li class="breadcrumb-item"><a href="javascript:void(0);">Register</a></li>
										<li class="breadcrumb-item active">Account</li>
									</ol>

								</div>

								<h4 class="page-title">Account Registration</h4>

							</div>

						</div>

					</div>

					<div class="row">

						<div class="col-12 col-lg-6 col-xl-4">

							<div class="card <%= blockRegister %>">
                                <div class="card-body">
                                    <h4 class="mt-0 header-title">Register for the League of Levels</h4>
                                    <p class="text-muted mb-3">In order to get the most out of the site, register your free account. If you're a current LOL member, you will be automatically attached to your team(s).</p>
<%
									If Len(errorDetails) > 0 Then

										arrErrors = Split(errorDetails, "|")

										For i = 0 To UBound(arrErrors) - 1

											Response.Write("<div class=""alert alert-danger"" role=""alert"">" & arrErrors(i) & "</div>")

										Next

									End If
%>
									<form action="/account/register/" method="post">
										<input type="hidden" name="action" value="go" />
										<div class="form-group">
                                            <label for="accountEmail">Email address</label>
                                            <input type="email" class="form-control <% If errorEmail = 1 Then %>is-invalid<% End If %>" id="accountEmail" name="accountEmail" <% If Len(thisEmail) > 0 Then %>value="<%= thisEmail %>"<% End If %> required>
                                        </div>
										<div class="form-group">
                                            <label for="accountPassword">Password</label>
                                            <input type="password" class="form-control" id="accountPassword" name="accountPassword" required>
                                        </div>
										<div class="form-group">
                                            <label for="accountName">Profile Name</label>
                                            <input type="text" class="form-control" id="accountName" name="accountName" <% If Len(thisName) > 0 Then %>value="<%= thisName %>"<% End If %>>
                                        </div>
										<button type="submit" class="btn btn-primary btn-sm mt-2 mr-2">Register</button>
										<button onclick="window.location.href = '/account/reset-password/';" type="button" class="btn btn-secondary btn-sm mt-2">Reset Password</button>
                                    </form>
                                </div>
                            </div>

							<div class="card <%= blockSuccess %>">
                                <div class="card-body">
                                    <h4 class="mt-0 header-title">Go Check Your Email, Scumbag</h4>
                                    <p class="text-muted mb-3">Alright, well done, but cool your damn jets. We need you to verify the email address you just used. I also need you to wire me some cash, but we'll worry about that later. Check your email.</p>
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
