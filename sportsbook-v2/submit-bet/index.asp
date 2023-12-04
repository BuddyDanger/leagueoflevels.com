<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!--#include virtual="/assets/asp/functions/sha256.asp"-->
<%
	checkSportsbookStatus = 0
	checkNFLGameTime = 0
	checkLOLPMR = 0
	checkLOLWinPercentage = 0
	checkSchmeckleBalance = 0

	slackIsNFL = 0
	If Session.Contents("SITE_Bet_Type") = "nfl" Then slackIsNFL = 1

	sqlGetStatus = "SELECT * FROM Switchboard WHERE SwitchboardID = 1"
	Set rsStatus = sqlDatabase.Execute(sqlGetStatus)

	If Not rsStatus.Eof Then

		thisSportsbookStatus = rsStatus("Sportsbook")
		If thisSportsbookStatus = False Then checkSportsbookStatus = 1
		rsStatus.Close
		Set rsStatus = Nothing

	End If

	If Request.Form("inputTicketGo") = "go" Then

		sqlGetSchmeckles = "SELECT SUM(TransactionTotal) AS CurrentSchmeckleTotal FROM SchmeckleTransactions WHERE AccountID = " & Session.Contents("AccountID")
		Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

		thisSchmeckleTotal = 0
		If Not rsSchmeckles.Eof Then

			thisSchmeckleTotal = rsSchmeckles("CurrentSchmeckleTotal")

			rsSchmeckles.Close
			Set rsSchmeckles = Nothing

		End If

		betTypeMoneyline = 0
		betTypeSpread = 0
		betTypeTotal = 0

		thisTicketType = Request.Form("inputTicketType")
		thisMatchupID = Request.Form("inputMatchupID")
		thisNFLGameID = Request.Form("inputNFLGameID")
		thisTeamID1 = Request.Form("inputTeamID1")
		thisTeamID2 = Request.Form("inputTeamID2")

		If thisTicketType = "1" Then

			thisMoneylineValue1 = Request.Form("inputMoneylineValue1")
			thisMoneylineValue2 = Request.Form("inputMoneylineValue2")
			thisMoneylineTeam = Request.Form("inputMoneylineTeam")
			thisMoneylineBetAmount = Request.Form("inputMoneylineBetAmount")
			thisMoneylineWin = Request.Form("inputMoneylineWin")
			thisMoneylinePayout = Request.Form("inputMoneylinePayout")

			If CInt(thisMoneylineTeam) = 1 Then
				betTeamID = thisTeamID1
				betMoneylineValue = thisMoneylineValue1
			Else
				betTeamID = thisTeamID2
				betMoneylineValue = thisMoneylineValue2
			End If

			If CDbl(thisSchmeckleTotal) >= CDbl(thisMoneylineBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				If Session.Contents("SITE_Bet_Type") = "nfl" Then rsInsert("NFLGameID") = thisNFLGameID
				If Session.Contents("SITE_Bet_Type") <> "nfl" Then rsInsert("MatchupID") = thisMatchupID
				rsInsert("TeamID") = betTeamID
				rsInsert("Moneyline") = betMoneylineValue
				rsInsert("BetAmount") = thisMoneylineBetAmount
				rsInsert("PayoutAmount") = thisMoneylinePayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				thisTransactionTypeID = 1008
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisMoneylineBetAmount * -1
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, thisTicketSlipID, thisTransactionTotal, thisTransactionDescription)

				betTypeMoneyline = 1

			End If

		ElseIf CInt(thisTicketType) = 2 Then

			thisSpreadValue1 = Request.Form("inputSpreadValue1")
			thisSpreadValue2 = Request.Form("inputSpreadValue2")
			thisSpreadTeam = Request.Form("inputSpreadTeam")
			thisSpreadBetAmount = Request.Form("inputSpreadBetAmount")
			thisSpreadWin = Request.Form("inputSpreadWin")
			thisSpreadPayout = Request.Form("inputSpreadPayout")

			If CInt(thisSpreadTeam) = 1 Then
				betTeamID = thisTeamID1
				betSpreadValue = thisSpreadValue1
			Else
				betTeamID = thisTeamID2
				betSpreadValue = thisSpreadValue2
			End If

			If CDbl(thisSchmeckleTotal) >= CDbl(thisSpreadBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				If Session.Contents("SITE_Bet_Type") = "nfl" Then rsInsert("NFLGameID") = thisNFLGameID
				If Session.Contents("SITE_Bet_Type") <> "nfl" Then rsInsert("MatchupID") = thisMatchupID
				rsInsert("TeamID") = betTeamID
				rsInsert("Spread") = betSpreadValue
				rsInsert("BetAmount") = thisSpreadBetAmount
				rsInsert("PayoutAmount") = thisSpreadPayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				thisTransactionTypeID = 1008
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisSpreadBetAmount * -1
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, thisTicketSlipID, thisTransactionTotal, thisTransactionDescription)

				betTypeSpread = 1

			End If

		ElseIf CInt(thisTicketType) = 3 Then

			thisOverUnderAmount = Request.Form("inputOverUnderAmount")
			thisOverUnderWin = Request.Form("inputOverUnderWin")
			thisOverUnderPayout = Request.Form("inputOverUnderPayout")
			thisOverUnderBet = Request.Form("inputOverUnderBet")
			thisOverUnderBetAmount = Request.Form("inputOverUnderBetAmount")

			If CInt(thisOverUnderBet) = 1 Then
				thisOverUnderBet = "OVER"
			Else
				thisOverUnderBet = "UNDER"
			End If

			If CDbl(thisSchmeckleTotal) >= CDbl(thisOverUnderBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				If Session.Contents("SITE_Bet_Type") = "nfl" Then rsInsert("NFLGameID") = thisNFLGameID
				If Session.Contents("SITE_Bet_Type") <> "nfl" Then rsInsert("MatchupID") = thisMatchupID
				rsInsert("TeamID") = 0
				rsInsert("OverUnderAmount") = thisOverUnderAmount
				rsInsert("OverUnderBet") = thisOverUnderBet
				rsInsert("BetAmount") = thisOverUnderBetAmount
				rsInsert("PayoutAmount") = thisOverUnderPayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				thisTransactionTypeID = 1008
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisOverUnderBetAmount * -1
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, thisTicketSlipID, thisTransactionTotal, thisTransactionDescription)

				betTypeTotal = 1

			End If

		ElseIf thisTicketType = "4" Then

			thisPropQuestionID = Request.Form("inputPropQuestionID")
			thisPropAnswerID = Request.Form("inputPropAnswer" & thisPropQuestionID)
			betMoneylineValue = Request.Form("inputPropBetMoneyline" & thisPropAnswerID)
			thisMoneylineBetAmount = Request.Form("inputPropBetAmount" & thisPropQuestionID)
			thisMoneylineWin = Request.Form("inputPropWin" & thisPropQuestionID)
			thisMoneylinePayout = Request.Form("inputPropPayout" & thisPropQuestionID)

			If CDbl(thisSchmeckleTotal) >= CDbl(thisMoneylineBetAmount) Then

				Set rsInsert = Server.CreateObject("ADODB.RecordSet")
				rsInsert.CursorType = adOpenKeySet
				rsInsert.LockType = adLockOptimistic
				rsInsert.Open "TicketSlips", sqlDatabase, , , adCmdTable
				rsInsert.AddNew

				rsInsert("TicketTypeID") = thisTicketType
				rsInsert("AccountID") = Session.Contents("AccountID")
				If Session.Contents("SITE_Bet_Type") = "nfl" Then rsInsert("NFLGameID") = thisNFLGameID
				If Session.Contents("SITE_Bet_Type") <> "nfl" Then rsInsert("MatchupID") = thisMatchupID
				rsInsert("PropQuestionID") = thisPropQuestionID
				rsInsert("PropAnswerID") = thisPropAnswerID
				rsInsert("TeamID") = 0
				rsInsert("Moneyline") = betMoneylineValue
				rsInsert("BetAmount") = thisMoneylineBetAmount
				rsInsert("PayoutAmount") = thisMoneylinePayout

				rsInsert.Update

				thisTicketSlipID = rsInsert("TicketSlipID")

				Set rsInsert = Nothing

				thisTransactionTypeID = 1008
				thisTransactionDateTime = Now()
				thisTransactionTotal = thisMoneylineBetAmount * -1
				thisAccountID = Session.Contents("AccountID")
				thisTransactionDescription = ""

				thisTransactionStatus = SchmeckleTransaction(thisAccountID, thisTransactionTypeID, thisTicketSlipID, thisTransactionTotal, thisTransactionDescription)

			End If

		End If

		thisSlackNotificationStatus = Slack_SportsbookBet(thisTicketSlipID, 2, slackIsNFL)

	End If

	If Len(thisTicketSlipID) > 0 Then Response.Write("Bet placed successfully. (" & thisTicketSlipID & ")")
%>
