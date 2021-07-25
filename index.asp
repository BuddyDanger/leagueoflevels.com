<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp" -->
<!--#include virtual="/assets/asp/functions/sha256.asp"-->
<%
	If Request.Form("action") = "buy" Then

		thisBallPurchase = Request.Form("inputBallPurchase")

		If thisBallPurchase > 0 Then

			sqlGetSchmeckles = "SELECT SUM(TransactionTotal) AS CurrentSchmeckleTotal FROM SchmeckleTransactions WHERE AccountID = " & Session.Contents("AccountID")
			Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

			thisCurrentSchmeckleTotal = rsSchmeckles("CurrentSchmeckleTotal")

			If CDbl(thisCurrentSchmeckleTotal) >= CDbl(thisBallPurchase * 2500) Then

				'UPDATE BALL TOTAL ON ACCOUNT'
				Session.Contents("AccountBalls") = Session.Contents("AccountBalls") + thisBallPurchase
				sqlUpdateBalls = "UPDATE Accounts SET Balls = " & Session.Contents("AccountBalls") & " WHERE AccountID = " & Session.Contents("AccountID")
				Set rsUpdate   = sqlDatabase.Execute(sqlUpdateBalls)

				thisTransactionTypeID = 1001
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisBallPurchase * -2500
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, NULL, thisTransactionTotal, thisTransactionDescription)

			End If

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

		<title>Dashboard / League of Levels</title>

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

					<div class="row mt-4">

						<!--#include virtual="/assets/asp/dashboard/header.asp" -->

						<% If Session.Contents("LoggedIn") = "yes" Then %>
							<div class="col-12 col-xl-4 px-2">

								<div class="row">

									<div class="col-12 col-xl-12">
										<!--#include virtual="/assets/asp/dashboard/balls.asp" -->
									</div>

								</div>

							</div>
						<% End If %>

						<!--#include virtual="/assets/asp/dashboard/timeline.asp" -->

						<!-- LOGGED OUT -->
						<!--#include virtual="/assets/asp/dashboard/login.asp" -->

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

		<script>

			function numberWithCommas(x) { return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); }

			function calculate_ball_cost(balls) {

				document.getElementById("inputTotalSchmeckles").value = numberWithCommas(parseInt(balls * 2500));
				return 0;

			}

			$(function(){
				$(".quantity-input-up").click(function(){
					var inpt = $(this).parents(".quantity-input").find("[name=inputBallPurchase]");
					var val = parseInt(inpt.val());
					if ( val < 0 ) inpt.val(val=0);
					if (val+1 <= <%= maxBallPurchase %>) {
						inpt.val(val+1);
						calculate_ball_cost(val+1);
					}
				});
				$(".quantity-input-down").click(function(){
					var inpt = $(this).parents(".quantity-input").find("[name=inputBallPurchase]");
					var val = parseInt(inpt.val());
					if ( val < 0 ) inpt.val(val=0);
					if ( val == 0 ) return;
					if (val-1 >= 0) {
						inpt.val(val-1);
						calculate_ball_cost(val-1);
					}
				});
			});
		</script>

	</body>

</html>
