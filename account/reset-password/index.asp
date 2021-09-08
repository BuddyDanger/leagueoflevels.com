<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/sha256.asp" -->
<%
	thisAction = Request.Form("action")

	If thisAction = "go" Then

		thisEmail = Request.Form("accountEmail")
		Hash = sha256(thisEmail)

		errorDetails = ""

		Set rsAccount = sqlDatabase.Execute("SELECT * FROM Accounts WHERE Email = '" & thisEmail & "'")
		If rsAccount.Eof Then

			errorDetails = errorDetails & "The e-mail provided is not in our database.|"
			errorEmail = 1

		Else

			thisName = rsAccount("ProfileName")
			rsAccount.Close
			Set rsAccount = Nothing

		End If

		If Len(errorDetails) = 0 Then

			sqlGetEmailTemplate = "SELECT * FROM Emails WHERE EmailID = 2"
			Set rsEmailTemplate = sqlDatabase.Execute(sqlGetEmailTemplate)

			If Not rsEmailTemplate.Eof Then

				thisSubjectLine = rsEmailTemplate("EmailSubject")
				thisEmailBody = rsEmailTemplate("EmailBody")
				FinalEmailBody = thisEmailBody

				rsEmailTemplate.Close
				Set rsEmailTemplate = Nothing

				FinalEmailBody = Replace(FinalEmailBody, "%%HASH%%", Hash)
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

			Session.Contents("AccountResetSent") = 1

		End If

	End If

	If thisAction = "final-reset" Then

		thisPassword1 = Request.Form("accountPassword")
		thisPassword2 = Request.Form("accountPassword2")

		errorPasswords = ""
		If thisPassword1 <> thisPassword2 Then
			errorPasswords = errorPasswords & "The passwords provided do not match.|"
			errorPassword = 1
		End If

		If Len(thisPassword1) < 6 Then
			errorPasswords = errorPasswords & "The password must be at least 6 characters.|"
			errorPassword = 1
		End If

		If Len(errorPasswords) = 0 Then

			'UPDATE ACCOUNT
			encryptPassword = sha256(thisPassword1)
			encryptEmail = sha256(Session.Contents("AccountEmail"))
			sqlModAccount = "UPDATE Accounts SET Password = '" & encryptPassword & "', Hash = '" & encryptEmail & "' WHERE AccountID = " & Session.Contents("AccountID")
			Set rsAccount = sqlDatabase.Execute(sqlModAccount)

			Set rsAccount = sqlDatabase.Execute("SELECT * FROM Accounts WHERE AccountID = " & Session.Contents("AccountID"))

			thisAccountID = rsAccount("AccountID")
			thisEmail = rsAccount("Email")
			thisName = rsAccount("ProfileName")
			thisImage = rsAccount("ProfileImage")

			rsAccount.Close
			Set rsAccount = Nothing

			Response.Cookies("AccountID") = thisAccountID
			Response.Cookies("AccountID").Expires = Date() + 365

			Response.Cookies("AccountHash") = encryptPassword
			Response.Cookies("AccountHash").Expires = Date() + 365

			Session.Contents("LoggedIn") = "yes"
			Session.Contents("AccountID") = thisAccountID
			Session.Contents("AccountHash") = encryptPassword
			Session.Contents("AccountEmail") = thisEmail
			Session.Contents("AccountName") = thisName
			Session.Contents("AccountImage") = thisImage

			Response.Redirect("/")

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
										<li class="breadcrumb-item"><a href="javascript:void(0);">Reset Password</a></li>
										<li class="breadcrumb-item active">Account</li>
									</ol>

								</div>

								<h4 class="page-title">Reset Password</h4>

							</div>

						</div>

					</div>

					<div class="row">

						<div class="col-12 col-lg-6 col-xl-4">
<%
							If Session.Contents("ResetVerified") <> 1 Then
%>
								<div class="card">
	                                <div class="card-body">
	                                    <h4 class="mt-0 header-title">Reset Your LOL Password</h4>
	                                    <p class="text-muted mb-3">We get it. You fucked up. It happens to... some of us. To reset your password, enter the email address (you think) you registered in the box below and we'll send you a secure link.</p>
<%
										If Session.Contents("AccountResetSent") = 1 Then

											Response.Write("<div class=""alert alert-success"" role=""alert"">Email Sent! Check Your Inbox For Instructions.</div>")

											Session.Contents("AccountResetSent") = 0

										End If

										If Len(errorDetails) > 0 Then

											arrErrors = Split(errorDetails, "|")

											For i = 0 To UBound(arrErrors) - 1

												Response.Write("<div class=""alert alert-danger"" role=""alert"">" & arrErrors(i) & "</div>")

											Next

										End If
%>
										<form action="/account/reset-password/" method="post">
											<input type="hidden" name="action" value="go" />
											<div class="form-group">
	                                            <label for="accountEmail">Email address</label>
	                                            <input type="email" class="form-control <% If errorLogin = 1 Then %>is-invalid<% End If %>" id="accountEmail" name="accountEmail" <% If Len(thisEmail) > 0 Then %>value="<%= thisEmail %>"<% End If %> required>
	                                        </div>
											<button type="submit" class="btn btn-primary btn-sm mt-2 mr-2">Reset Password</button>
	                                    </form>
	                                </div>
	                            </div>
<%
							End If

							If Session.Contents("ResetVerified") = 1 Then

								Session.Contents("ResetVerified") = 0
%>
								<div class="card">
									<div class="card-body">
										<h4 class="mt-0 header-title">Reset Your LOL Password</h4>
										<p class="text-muted mb-3">Alright, we're pretty sure you're the right person. Either that or you've infiltrated an opponents email account, in which case, kudos. Now, get in and get out because I'm pretty sure this is a felony of some sort.</p>
<%
										If Len(errorPasswords) > 0 Then

											arrErrors = Split(errorPasswords, "|")

											For i = 0 To UBound(arrErrors) - 1

												Response.Write("<div class=""alert alert-danger"" role=""alert"">" & arrErrors(i) & "</div>")

											Next

										End If
%>
										<form name="update-password" action="/account/reset-password/" method="post">
											<input type="hidden" name="action" value="final-reset" />
											<div class="form-group">
	                                            <label for="accountPassword">New Password</label>
	                                            <input type="password" class="form-control <% If errorPassword = 1 Then %>is-invalid<% End If %>" id="accountPassword" name="accountPassword" required>
	                                        </div>
											<div class="form-group">
	                                            <label for="accountPassword2">Confirm New Password</label>
	                                            <input type="password" class="form-control <% If errorPassword = 1 Then %>is-invalid<% End If %>" id="accountPassword2" name="accountPassword2" required>
	                                        </div>
											<button type="submit" class="btn btn-primary btn-sm mt-2 mr-2">Reset Account Password</button>
	                                    </form>
									</div>
								</div>
<%

							End If
%>
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
