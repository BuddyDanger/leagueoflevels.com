<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp" -->
<!--#include virtual="/assets/asp/functions/sha256.asp"-->
<%
	If Request.Form("action") = "omega" Then

		thisOmegaPathID = Request.Form("inputOmegaPathID")
		thisPeriod = Request.Form("inputPeriod")

		sqlGetPathDetails = "SELECT OmegaPathID, StartingLocationID, EndingLocationID, LandDistance, WaterDistance, TotalDistance, TravelPenalty, PathLocationID1, PathLocationID2, PathLocationID3, Teams.TeamID AS OpponentID, Teams.TeamName AS OpponentName FROM OmegaPaths "
		sqlGetPathDetails = sqlGetPathDetails & "INNER JOIN OmegaLinkLocationsTeams ON OmegaLinkLocationsTeams.LocationID = OmegaPaths.EndingLocationID "
		sqlGetPathDetails = sqlGetPathDetails & "INNER JOIN Teams ON Teams.TeamID = OmegaLinkLocationsTeams.TeamID "
		sqlGetPathDetails = sqlGetPathDetails & "WHERE OmegaPathID = " & thisOmegaPathID

		Set rsPathDetails = sqlDatabase.Execute(sqlGetPathDetails)

		If Not rsPathDetails.Eof Then

			thisOmegaPathID = rsPathDetails("OmegaPathID")
			thisStartingLocationID = rsPathDetails("StartingLocationID")
			thisEndingLocationID = rsPathDetails("EndingLocationID")
			thisLandDistance = rsPathDetails("LandDistance")
			thisWaterDistance = rsPathDetails("WaterDistance")
			thisTotalDistance = rsPathDetails("TotalDistance")
			thisTravelPenalty = rsPathDetails("TravelPenalty")
			thisPathLocationID1 = rsPathDetails("PathLocationID1")
			thisPathLocationID2 = rsPathDetails("PathLocationID2")
			thisPathLocationID3 = rsPathDetails("PathLocationID3")
			thisOpponentID = rsPathDetails("OpponentID")
			thisOpponentName = rsPathDetails("OpponentName")

			sqlInsertMove = "INSERT INTO OmegaMoves (Year, Period, TeamID, OmegaPathID, EndingLocationID) "
			sqlInsertMove = sqlInsertMove & "VALUES (" & Session.Contents("CurrentYear") & ", " & thisPeriod & ", " & Session.Contents("Account_OmegaTeamID") & ", " & thisOmegaPathID & ", " & thisEndingLocationID & ")"

			Set rsInsertMove = sqlDatabase.Execute(sqlInsertMove)

		End If

		If thisOpponentID > 0 Then

			sqlInsertMatchup = "INSERT INTO Matchups (LevelID, Year, Period, IsPlayoffs, IsCup, IsMajor, TeamID1, TeamID2, TeamScore1, TeamScore2, TeamPMR1, TeamPMR2, Leg, TeamOmegaTravel1, TeamOmegaTravel2) "
			sqlInsertMatchup = sqlInsertMatchup & "VALUES (1, " & Session.Contents("CurrentYear") & ", " & thisPeriod & ", 0, 0, 0, " & Session.Contents("Account_OmegaTeamID") & ", " & thisOpponentID & ", 0, 0, 420, 420, 1, " & thisTravelPenalty & ", 0)"

			Set rsInsertMatchup = sqlDatabase.Execute(sqlInsertMatchup)

		End If

		sqlGetMatchup = "SELECT MatchupID FROM Matchups WHERE Matchups.Year = " & Session.Contents("CurrentYear") & " AND Matchups.TeamID1 = " & Session.Contents("Account_OmegaTeamID") & " AND Matchups.TeamID2 = " & thisOpponentID & " ORDER BY MatchupID DESC"
		Set rsMatchup = sqlDatabase.Execute(sqlGetMatchup)

		If Not rsMatchup.Eof Then

			thisSlackNotificationStatus = Slack_OmegaAttack (rsMatchup("MatchupID"), 1)
			rsMatchup.Close
			Set rsMatchup = Nothing

		End If

		Response.Redirect("/")

	End If

	If Request.Form("action") = "lock" Then

		thisMatchupID = Request.Form("inputMatchupID")

		If CInt(Session.Contents("AccountLocks")) > 0 Then

			thisTicketType = 5
			thisMatchupID = Request.Form("inputMatchupID")
			thisMoneyline = Request.Form("inputMoneyline")
			thisPayout = CInt(2500 * (thisMoneyline / 100)) + 2500

			sqlGetMatchup = "SELECT * FROM Matchups WHERE MatchupID = " & thisMatchupID
			Set rsMatchup = sqlDatabase.Execute(sqlGetMatchup)

			If Not rsMatchup.Eof Then

				thisTeamID1 = rsMatchup("TeamID1")
				thisTeamID2 = rsMatchup("TeamID2")
				thisBetTeamID = 0

				sqlCheckTeams = "SELECT Teams.TeamID FROM LinkAccountsTeams INNER JOIN Teams ON Teams.TeamID = LinkAccountsTeams.TeamID WHERE LinkAccountsTeams.AccountID = " & Session.Contents("AccountID")
				Set rsTeams = sqlDatabase.Execute(sqlCheckTeams)

				If Not rsTeams.Eof Then

					Do While Not rsTeams.Eof

						If CInt(rsTeams("TeamID")) = CInt(thisTeamID1) Then thisBetTeamID = thisTeamID1
						If CInt(rsTeams("TeamID")) = CInt(thisTeamID2) Then thisBetTeamID = thisTeamID2

						rsTeams.MoveNext

					Loop

					rsTeams.Close
					Set rsTeams = Nothing

				End If

				If thisBetTeamID <> 0 Then

					Set rsInsert = Server.CreateObject("ADODB.RecordSet")
					rsInsert.CursorType = adOpenKeySet
					rsInsert.LockType = adLockOptimistic
					rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
					rsInsert.AddNew

					rsInsert("TicketTypeID") = 5
					rsInsert("AccountID") = Session.Contents("AccountID")
					rsInsert("MatchupID") = thisMatchupID
					rsInsert("TeamID") = thisBetTeamID
					rsInsert("Moneyline") = thisMoneyline
					rsInsert("BetAmount") = 2500
					rsInsert("PayoutAmount") = thisPayout

					rsInsert.Update
					Set rsInsert = Nothing

					sqlUpdateLockCount = "UPDATE Accounts SET Locks = " & Session.Contents("AccountLocks") - 1 & " WHERE AccountID = " & Session.Contents("AccountID")
					Set rsUpdateLocks  = sqlDatabase.Execute(sqlUpdateLockCount)

					Session.Contents("AccountLocks") = Session.Contents("AccountLocks") - 1

				End If

			End If

			Response.Redirect("/")

		End If

	End If

	If Request.Form("action") = "send" Then

		thisRecipientID = Request.Form("inputRecipientID")
		thisTotalSchmeckles = Request.Form("inputTotalSchmeckles")
		thisMemo = Request.Form("inputMemo")

		If thisTotalSchmeckles > 0 Then

			sqlGetSchmeckles = "SELECT SUM(TransactionTotal) AS CurrentSchmeckleTotal FROM SchmeckleTransactions WHERE AccountID = " & Session.Contents("AccountID")
			Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

			thisCurrentSchmeckleTotal = rsSchmeckles("CurrentSchmeckleTotal")

			If CDbl(thisCurrentSchmeckleTotal) >= CDbl(thisTotalSchmeckles) Then

				thisTransactionTypeID = 1015
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisTotalSchmeckles * -1
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, NULL, thisTransactionTotal, thisMemo)

				thisTransactionTypeID = 1015
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisTotalSchmeckles
				thisAccountID = thisRecipientID
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, NULL, thisTransactionTotal, NULL)

				thisSlackNotificationStatus = Slack_SendSchmeckles(thisAccountID, thisRecipientID, thisTransactionTotal, thisMemo, 1)

			End If

			Response.Redirect("/")

		End If

	End If

	If Request.Form("action") = "buy-standard" Then

		thisBallPurchase = Request.Form("inputBallPurchase")

		If thisBallPurchase > 0 Then

			sqlGetSchmeckles = "SELECT SUM(TransactionTotal) AS CurrentSchmeckleTotal FROM SchmeckleTransactions WHERE AccountID = " & Session.Contents("AccountID")
			Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

			thisCurrentSchmeckleTotal = rsSchmeckles("CurrentSchmeckleTotal")

			If CDbl(thisCurrentSchmeckleTotal) >= CDbl(thisBallPurchase * 2500) Then

				'UPDATE BALL TOTAL ON ACCOUNT'
				Session.Contents("AccountBalls_Standard") = Session.Contents("AccountBalls_Standard") + thisBallPurchase
				sqlUpdateBalls = "UPDATE Accounts SET Balls_Standard = " & Session.Contents("AccountBalls_Standard") & " WHERE AccountID = " & Session.Contents("AccountID")
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

	If Request.Form("action") = "buy-omega" Then

		thisBallPurchase = Request.Form("inputBallPurchase")

		If thisBallPurchase > 0 Then

			sqlGetSchmeckles = "SELECT SUM(TransactionTotal) AS CurrentSchmeckleTotal FROM SchmeckleTransactions WHERE AccountID = " & Session.Contents("AccountID")
			Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

			thisCurrentSchmeckleTotal = rsSchmeckles("CurrentSchmeckleTotal")

			If CDbl(thisCurrentSchmeckleTotal) >= CDbl(thisBallPurchase * 500) Then

				'UPDATE BALL TOTAL ON ACCOUNT'
				Session.Contents("AccountBalls_Omega") = Session.Contents("AccountBalls_Omega") + thisBallPurchase
				sqlUpdateBalls = "UPDATE Accounts SET Balls_Omega = " & Session.Contents("AccountBalls_Omega") & " WHERE AccountID = " & Session.Contents("AccountID")
				Set rsUpdate   = sqlDatabase.Execute(sqlUpdateBalls)

				thisTransactionTypeID = 1001
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisBallPurchase * -500
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

		<meta name="description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="The League of Levels" />
		<meta property="og:description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="The League of Levels" />
		<meta name="twitter:description" content="The League of Levels is the world's first multi-league fantasy football system completely powered by greed, democracy, and a love for gambling." />

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

				<div class="container-fluid pl-0 pl-lg-2 pr-0 pr-lg-2">

					<% If Session.Contents("LoggedIn") = "yes" Then %>
						<div class="row mt-4">

							<div class="col-12 col-lg-6 col-xl-5">

								<!--#include virtual="/assets/asp/dashboard/account.asp" -->

								<!--#include virtual="/assets/asp/dashboard/eliminator.asp" -->

								<!--#include virtual="/assets/asp/dashboard/locks.asp" -->

								<!--#include virtual="/assets/asp/dashboard/sender.asp" -->

							</div>

							<div class="col-12 col-lg-6 col-xl-7 col-xxl-5">

								<!--#include virtual="/assets/asp/dashboard/timeline.asp" -->

							</div>

						</div>
					<% Else %>
						<div class="row mt-4">
							<!--#include virtual="/assets/asp/dashboard/login.asp" -->
						</div>
					<% End If %>

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

			function calculate_omega_ball_cost(balls) {

				document.getElementById("inputTotalSchmeckles_Omega").value = numberWithCommas(parseInt(balls * 500));
				return 0;

			}

			function calculate_standard_ball_cost(balls) {

				document.getElementById("inputTotalSchmeckles_Standard").value = numberWithCommas(parseInt(balls * 2500));
				return 0;

			}

			$(function(){
				$(".quantity-input-up-omega").click(function(){
					var inpt = $(this).parents(".quantity-input").find("[name=inputBallPurchase]");
					var val = parseInt(inpt.val());
					if ( val < 0 ) inpt.val(val=0);
					if (val+1 <= <%= maxBallPurchase %>) {
						inpt.val(val+1);
						calculate_omega_ball_cost(val+1);
					}
				});
				$(".quantity-input-down-omega").click(function(){
					var inpt = $(this).parents(".quantity-input").find("[name=inputBallPurchase]");
					var val = parseInt(inpt.val());
					if ( val < 0 ) inpt.val(val=0);
					if ( val == 0 ) return;
					if (val-1 >= 0) {
						inpt.val(val-1);
						calculate_omega_ball_cost(val-1);
					}
				});
				$(".quantity-input-up-standard").click(function(){
					var inpt = $(this).parents(".quantity-input").find("[name=inputBallPurchase]");
					var val = parseInt(inpt.val());
					if ( val < 0 ) inpt.val(val=0);
					if (val+1 <= <%= maxBallPurchase %>) {
						inpt.val(val+1);
						calculate_standard_ball_cost(val+1);
					}
				});
				$(".quantity-input-down-standard").click(function(){
					var inpt = $(this).parents(".quantity-input").find("[name=inputBallPurchase]");
					var val = parseInt(inpt.val());
					if ( val < 0 ) inpt.val(val=0);
					if ( val == 0 ) return;
					if (val-1 >= 0) {
						inpt.val(val-1);
						calculate_standard_ball_cost(val-1);
					}
				});
			});
		</script>

	</body>

</html>
