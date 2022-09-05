<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	If Len(ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))) < 1 Then Session.Contents("SITE_Schmeckles_AccountID") = ""

	If Len(Session.Contents("SITE_Schmeckles_RedemptionID")) > 0 And IsNumeric(Session.Contents("SITE_Schmeckles_RedemptionID")) Then

		sqlCheckRedemption = "SELECT * FROM SchmeckleRedemptions WHERE RedemptionID = '" & Session.Contents("SITE_Schmeckles_RedemptionID") & "' AND RedemptionDate IS NULL"
		Set rsRedemption = sqlDatabase.Execute(sqlCheckRedemption)

		If Not rsRedemption.Eof Then

			thisRedemptionID = rsRedemption("RedemptionID")
			thisRedemptionTotal = rsRedemption("RedemptionTotal")

			If Session.Contents("LoggedIn") = "yes" Then

				thisTransactionTypeID = 1017
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisRedemptionTotal
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, NULL, thisTransactionTotal, thisTransactionDescription)

				Set rsTransactionID = sqlDatabase.Execute("SELECT TOP 1 TransactionID FROM SchmeckleTransactions WHERE AccountID = " & thisAccountID & " ORDER BY TransactionID DESC")
				thisTransactionID = rsTransactionID("TransactionID")
				rsTransactionID.Close
				Set rsTransactionID = Nothing

				sqlUpdateRedeemCode = "UPDATE SchmeckleRedemptions SET AccountID = " & thisAccountID & ", RedemptionDate = '" & Now() & "', TransactionID = " & thisTransactionID & " WHERE RedemptionID = " & Session.Contents("SITE_Schmeckles_RedemptionID")
				Set rsUpdateRedeem  = sqlDatabase.Execute(sqlUpdateRedeemCode)

			Else

				Response.Redirect("/account/login/")

			End If

		Else

			Response.Redirect("/")

		End If

	Else

		Response.Redirect("/")

	End If
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Schmeckle Redemption / League of Levels</title>

		<meta name="description" content="In order to redeem your schmeckle payout, simply follow the instructions below and the funds will be deposited automatically." />

		<meta property="og:site_name" content="League of Levels" />
		<meta property="og:url" content="https://www.leagueoflevels.com/schmeckles/" />
		<meta property="og:title" content="Schmeckle Redemption / League of Levels" />
		<meta property="og:description" content="In order to redeem your schmeckle payout, simply follow the instructions below and the funds will be deposited automatically." />
		<meta property="og:type" content="article" />

		<meta name="title" content="Schmeckle Redemption / League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/schmeckles/redeem/" />

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

						<div class="col-12 col-lg-6 col-xl-4">

							<div class="card">

                                <div class="card-body">
                                    <h4 class="mt-0 header-title">Schmeckle Redemption Successful</h4>
                                    <p class="text-muted mb-3">Your account was just awarded <%= thisRedemptionTotal %> schmeckles. If you're holding a physical QR code, it will now self-destruct.</p>
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
