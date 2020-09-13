<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/sha256.asp" -->
<%
	thisAction = Request.Form("action")
	blockProfileDetailsSuccess = "d-none"
	blockAccountLogoSuccess = "d-none"
	blockPasswordSuccess = "d-none"
	blockProfileDetails = ""
	blockAccountLogo = ""
	blockPassword = ""

	If thisAction = "update-profile" Then

		thisEmail = Request.Form("accountEmail")
		thisName = Request.Form("accountName")

		If InStr(thisName, "'") Then thisName = Replace(thisName, "'", "''")

		errorDetails = ""
		Set rsEmails = sqlDatabase.Execute("SELECT Email FROM Accounts WHERE Email = '" & thisEmail & "' AND AccountID <> " & Session.Contents("AccountID"))
		If Not rsEmails.Eof Then
			errorDetails = errorDetails & "The e-mail address provided is already in use.|"
			errorEmail = 1
			rsEmails.Close
			Set rsEmails = Nothing
		End If

		If Len(errorDetails) = 0 Then

			'UPDATE ACCOUNT
			sqlModAccount = "UPDATE Accounts SET Email = '" & thisEmail & "', ProfileName = '" & thisName & "', Hash = '" & sha256(thisEmail) & "' WHERE AccountID = " & Session.Contents("AccountID")
			Set rsAccount = sqlDatabase.Execute(sqlModAccount)

			blockProfileDetailsSuccess = ""
			blockProfileDetails = "d-none"

			Session.Contents("AccountEmail") = thisEmail
			Session.Contents("AccountName") = thisName

		End If

	End If

	If thisAction = "update-password" Then

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
			sqlModAccount = "UPDATE Accounts SET Password = '" & encryptPassword & "' WHERE AccountID = " & Session.Contents("AccountID")
			Set rsAccount = sqlDatabase.Execute(sqlModAccount)

			blockPasswordSuccess = ""
			blockPassword = "d-none"

			Response.Cookies("AccountHash") = encryptPassword
			Session.Contents("AccountHash") = encryptPassword

		End If

	End If

	sqlGetDetails = "SELECT * FROM Accounts WHERE AccountID = " & Session.Contents("AccountID")
	Set rsDetails = sqlDatabase.Execute(sqlGetDetails)

	thisEmail = rsDetails("Email")
	thisName = rsDetails("ProfileName")
	thisImage = rsDetails("ProfileImage")
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Account Profile / League of Levels</title>

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
		<link href="/assets/plugins/dropify/css/dropify.min.css" rel="stylesheet" type="text/css" />

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
										<li class="breadcrumb-item"><a href="javascript:void(0);">Profile</a></li>
										<li class="breadcrumb-item active">Account</li>
									</ol>

								</div>

								<h4 class="page-title">Account Profile</h4>

							</div>

						</div>

					</div>

					<div class="row">

						<div class="col-12 col-lg-6 col-xl-4">

							<div class="card">
                                <div class="card-body">

									<div class="<%= blockProfileDetails %>">
										<h4 class="mt-0 header-title pb-3 mb-4 border-bottom border-info">Update Your LOL Account Profile</h4>
                                    </div>

									<div class="<%= blockProfileDetailsSuccess %> pb-4 mb-4 border-bottom border-success">
										<h4 class="mt-0 header-title text-success">Congrats! You Did It!</h4>
                                    	<p class="pb-2">Alright, cool, you updated your information. Just remember, you'll need to remember which email address your using as that is how you'll login to your account. I know you're probably using burner accounts like Kevin Durant.</p>
										<button onclick="window.location.href = '/';" type="button" class="btn btn-success btn-sm mr-2">Back to Dashboard</button>
									</div>
<%
									If Len(errorDetails) > 0 Then

										arrErrors = Split(errorDetails, "|")

										For i = 0 To UBound(arrErrors) - 1

											Response.Write("<div class=""alert alert-danger"" role=""alert"">" & arrErrors(i) & "</div>")

										Next

									End If
%>
									<form name="update-profile" action="/account/" method="post">
										<input type="hidden" name="action" value="update-profile" />
										<div class="form-group">
                                            <label for="accountEmail">Email address</label>
                                            <input type="email" class="form-control <% If errorEmail = 1 Then %>is-invalid<% End If %>" id="accountEmail" name="accountEmail" <% If Len(thisEmail) > 0 Then %>value="<%= thisEmail %>"<% End If %> required>
                                        </div>
										<div class="form-group">
                                            <label for="accountName">Profile Name</label>
                                            <input type="text" class="form-control" id="accountName" name="accountName" <% If Len(thisName) > 0 Then %>value="<%= thisName %>"<% End If %> required>
                                        </div>
										<button type="submit" class="btn btn-primary btn-sm mt-2 mr-2">Update Profile Details</button>
                                    </form>
                                </div>
                            </div>

						</div>

						<div class="col-12 col-lg-6 col-xl-4">

							<div class="card">
                                <div class="card-body">

									<div class="<%= blockAccountLogo %>">
										<h4 class="mt-0 header-title pb-3 mb-4 border-bottom border-info">Modify Your LOL Logo</h4>
                                    </div>
<%
									If Len(errorLogo) > 0 Then

										arrErrors = Split(errorLogo, "|")

										For i = 0 To UBound(arrErrors) - 1

											Response.Write("<div class=""alert alert-danger"" role=""alert"">" & arrErrors(i) & "</div>")

										Next

									End If
%>
									<form name="update-logo" action="/account/logo/" method="post" enctype="multipart/form-data">
										<div class="form-group">
											<input type="file" id="AccountImage" name="AccountImage" class="dropify" />
                                        </div>
										<button type="submit" class="btn btn-primary btn-sm mt-2 mr-2 mb-4">Upload New Logo</button>
                                    </form>

									<div><img src="https://samelevel.imgix.net/<%= Session.Contents("AccountImage") %>" class="img-fluid" /></div>

                                </div>
                            </div>

						</div>

						<div class="col-12 col-lg-6 col-xl-4">

							<div class="card">
                                <div class="card-body">

									<div class="<%= blockPassword %>">
										<h4 class="mt-0 header-title pb-3 mb-4 border-bottom border-info">Reset Your Password</h4>
                                    </div>

									<div class="<%= blockPasswordSuccess %> pb-4 mb-4 border-bottom border-success">
										<h4 class="mt-0 header-title text-success">Congrats! You Did It!</h4>
                                    	<p class="pb-2">Alright, cool, you reset your password. You should probably write it down on a post-it note and stick it to your monitor, grandma.</p>
										<button onclick="window.location.href = '/';" type="button" class="btn btn-success btn-sm mr-2">Back to Dashboard</button>
									</div>
<%
									If Len(errorPasswords) > 0 Then

										arrErrors = Split(errorPasswords, "|")

										For i = 0 To UBound(arrErrors) - 1

											Response.Write("<div class=""alert alert-danger"" role=""alert"">" & arrErrors(i) & "</div>")

										Next

									End If
%>
									<form name="update-password" action="/account/" method="post">
										<input type="hidden" name="action" value="update-password" />
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
		<script src="/assets/plugins/dropify/js/dropify.min.js"></script>
		<script src="/assets/js/app.js"></script>
		<script>
            $(document).ready(function(){
                // Basic
                $('.dropify').dropify();

                var drEvent = $('#AccountImage').dropify();

                drEvent.on('dropify.beforeClear', function(event, element){
                    return confirm("Do you really want to delete \"" + element.file.name + "\" ?");
                });

                drEvent.on('dropify.afterClear', function(event, element){
                    alert('File deleted');
                });

                drEvent.on('dropify.errors', function(event, element){
                    console.log('Has Errors');
                });


            });
        </script>

		<!--#include virtual="/assets/asp/framework/google.asp" -->

	</body>

</html>
