StartTime = Now()
WScript.Echo("STARTING..." & vbcrlf)

Set sqlDatabase = CreateObject("ADODB.Connection")
sqlDatabase.CursorLocation = adUseServer
sqlDatabase.Open "Driver={SQL Server Native Client 11.0};Server=tcp:samelevel.database.windows.net,1433;Database=NextLevelDB;Uid=samelevel;Pwd=TheHammer123;Encrypt=yes;Connection Timeout=60;"

sqlGetTickets = "SELECT TicketSlips.TicketSlipID, TicketSlips.TicketTypeID, TicketSlips.InsertDateTime, TicketSlips.AccountID, Accounts.ProfileName, TicketSlips.MatchupID, "
sqlGetTickets = sqlGetTickets & "Matchups.TeamID1 AS MatchupTeamID1, Matchups.TeamID2 AS MatchupTeamID2, T1.TeamName AS MatchupTeamName1, T2.TeamName AS MatchupTeamName2, Matchups.TeamScore1, Matchups.TeamScore2, (Matchups.TeamScore1 + Matchups.TeamScore2) AS MatchupTotalScore, Matchups.TeamPMR1, Matchups.TeamPMR2, "
sqlGetTickets = sqlGetTickets & "TicketSlips.BetAmount, TicketSlips.PayoutAmount, TicketSlips.TeamID AS TicketSlipTeamID, T3.TeamName AS TicketSlipTeamName, TicketSlips.Moneyline, TicketSlips.Spread, TicketSlips.OverUnderAmount, TicketSlips.OverUnderBet "
sqlGetTickets = sqlGetTickets & "FROM TicketSlips "
sqlGetTickets = sqlGetTickets & "INNER JOIN Matchups ON Matchups.MatchupID = TicketSlips.MatchupID "
sqlGetTickets = sqlGetTickets & "INNER JOIN Accounts ON Accounts.AccountID = TicketSlips.AccountID "
sqlGetTickets = sqlGetTickets & "LEFT JOIN Teams T1 ON T1.TeamID = Matchups.TeamID1 "
sqlGetTickets = sqlGetTickets & "LEFT JOIN Teams T2 ON T2.TeamID = Matchups.TeamID2 "
sqlGetTickets = sqlGetTickets & "LEFT JOIN Teams T3 ON T3.TeamID = TicketSlips.TeamID "
sqlGetTickets = sqlGetTickets & "WHERE TicketSlips.DateProcessed IS NULL AND Matchups.TeamPMR1 = 0 AND Matchups.TeamPMR2 = 0 AND TicketSlips.IsNFL = 0"
Set rsTickets = sqlDatabase.Execute(sqlGetTickets)

If Not rsTickets.Eof Then

	sportsbookIN  = 0
	sportsbookOUT = 0
	totalWinners  = 0
	totalLosers   = 0

	WScript.Echo(vbcrlf & "LOL TICKETS SLIPS ARE FUCKING LOADED..." & vbcrlf & vbcrlf)

	WScript.Echo("SLIP" & vbTab & "BETTOR" & vbTab & "RESULT" & vbTab & "SELECTION" & vbTab & "WAGER" & vbTab & "PAYS" & vbTab & "MATH" & vbcrlf)

	Do While Not rsTickets.Eof

		thisTicketSlipID = rsTickets("TicketSlipID")
		thisTicketTypeID = rsTickets("TicketTypeID")
		thisInsertDateTime = rsTickets("InsertDateTime")
		thisAccountID = rsTickets("AccountID")
		thisProfileName = LEFT(rsTickets("ProfileName"), 6)
		thisMatchupID = rsTickets("MatchupID")
		thisMatchupTeamID1 = rsTickets("MatchupTeamID1")
		thisMatchupTeamID2 = rsTickets("MatchupTeamID2")
		thisMatchupTeamName1 = LEFT(rsTickets("MatchupTeamName1"), 6)
		thisMatchupTeamName2 = LEFT(rsTickets("MatchupTeamName2"), 6)
		thisTeamScore1 = rsTickets("TeamScore1")
		thisTeamScore2 = rsTickets("TeamScore2")
		thisMatchupTotalScore = rsTickets("MatchupTotalScore")
		thisTeamPMR1 = rsTickets("TeamPMR1")
		thisTeamPMR2 = rsTickets("TeamPMR2")
		thisBetAmount = rsTickets("BetAmount")
		thisPayoutAmount = rsTickets("PayoutAmount")
		thisTicketSlipTeamID = rsTickets("TicketSlipTeamID")
		thisTicketSlipTeamName = rsTickets("TicketSlipTeamName")
		thisMoneyline = rsTickets("Moneyline")
		thisSpread = rsTickets("Spread")
		thisOverUnderAmount = rsTickets("OverUnderAmount")
		thisOverUnderBet = rsTickets("OverUnderBet")

		If thisMoneyline > 0 Then thisMoneyline = "+" & thisMoneyline

		If CInt(thisTicketTypeID) = 1 Then

			'MONEYLINE'
			thisIsWinner = 0
			thisBetTeam = 1

			If CInt(thisTicketSlipTeamID) = CInt(thisMatchupTeamID2) Then thisBetTeam = 2

			If thisBetTeam = 1 Then
				If CDbl(thisTeamScore1) > CDbl(thisTeamScore2) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & thisMatchupTeamName1 & " (" & thisMoneyline & "ML)" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & thisTeamScore1 & " > " & thisTeamScore2)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & thisMatchupTeamName1 & " (" & thisMoneyline & "ML)" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & thisTeamScore1 & " < " & thisTeamScore2)
				End If
			ElseIf thisBetTeam = 2 Then
				If CDbl(thisTeamScore2) > CDbl(thisTeamScore1) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & thisMatchupTeamName2 & " (" & thisMoneyline & "ML)" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & thisTeamScore2 & " > " & thisTeamScore1)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & thisMatchupTeamName2 & " (" & thisMoneyline & "ML)" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & thisTeamScore2 & " < " & thisTeamScore1)
				End If
			End If

		ElseIf CInt(thisTicketTypeID) = 2 Then

			'SPREAD'
			thisIsWinner = 0
			thisBetTeam = 1

			If CInt(thisTicketSlipTeamID) = CInt(thisMatchupTeamID2) Then thisBetTeam = 2

			If thisBetTeam = 1 Then
				If (CDbl(thisTeamScore1) + thisSpread) > CDbl(thisTeamScore2) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & thisMatchupTeamName1 & " (" & thisSpread & ")" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & (CDbl(thisTeamScore1) + thisSpread) & " > " & thisTeamScore2)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & thisMatchupTeamName1 & " (" & thisSpread & ")" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & (CDbl(thisTeamScore1) + thisSpread) & " < " & thisTeamScore2)
				End If
			ElseIf thisBetTeam = 2 Then
				If (CDbl(thisTeamScore2) + thisSpread) > CDbl(thisTeamScore1) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & thisMatchupTeamName2 & " (" & thisSpread & ")" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & (CDbl(thisTeamScore2) + thisSpread) & " > " & thisTeamScore1)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & thisMatchupTeamName2 & " (" & thisSpread & ")" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & (CDbl(thisTeamScore2) + thisSpread) & " < " & thisTeamScore1)
				End If
			End If

		ElseIf CInt(thisTicketTypeID) = 3 Then

			'OVER / UNDER'
			thisIsWinner = 0

			If thisOverUnderBet = "OVER" Then
				If CDbl(thisMatchupTotalScore) > CDbl(thisOverUnderAmount) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & "#" & thisMatchupID & "  (O " & thisOverUnderAmount & ")" & vbTab & "$" & thisBetAmount & vbTab &  "$" & thisPayoutAmount & vbTab & CDbl(thisMatchupTotalScore) & " > " & thisOverUnderAmount)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & "#" & thisMatchupID & "  (O " & thisOverUnderAmount & ")" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & CDbl(thisMatchupTotalScore) & " < " & thisOverUnderAmount)
				End If
			ElseIf thisOverUnderBet = "UNDER" Then
				If CDbl(thisMatchupTotalScore) < CDbl(thisOverUnderAmount) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & "#" & thisMatchupID & "  (U " & thisOverUnderAmount & ")" & vbTab & "$" & thisBetAmount & vbTab &  "$" & thisPayoutAmount & vbTab & CDbl(thisMatchupTotalScore) & " < " & thisOverUnderAmount)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & "#" & thisMatchupID & "  (U " & thisOverUnderAmount & ")" & vbTab & "$" & thisBetAmount & vbTab &  "$" & thisPayoutAmount & vbTab & CDbl(thisMatchupTotalScore) & " > " & thisOverUnderAmount)
				End If
			End If

		End If

		If thisIsWinner = 1 Then

			sportsbookOUT = sportsbookOUT + (CDbl(thisPayoutAmount) - CDbl(thisBetAmount))
			totalWinners = totalWinners + 1

			sqlSchmeckleTransaction = "INSERT INTO SchmeckleTransactions (TransactionTypeID, TransactionTotal, AccountID, TicketSlipID) VALUES (1008, " & thisPayoutAmount & ", " & thisAccountID & ", " & thisTicketSlipID & ")"
			Set rsInsertMatchup = sqlDatabase.Execute(sqlSchmeckleTransaction)

		Else

			sportsbookIN = sportsbookIN + CInt(thisBetAmount)
			totalLosers = totalLosers + 1

		End If

		'PROCESS & ARCHIVE TICKET SLIP'
		sqlProcessTicketSlip = "UPDATE TicketSlips SET IsWinner = " & thisIsWinner & ", DateProcessed = '" & Now() & "' WHERE TicketSlipID = " & thisTicketSlipID
		Set rsTicketSlip = sqlDatabase.Execute(sqlProcessTicketSlip)

		rsTickets.MoveNext

	Loop

	rsTickets.Close
	Set rsTickets = Nothing

	WScript.Echo(vbcrlf & "SPORTBOOK IN: " & sportsbookIN & vbcrlf)
	WScript.Echo("TOTAL WINNERS: " & totalWinners & vbcrlf)
	WScript.Echo("TOTAL LOSERS: " & totalLosers & vbcrlf)
	WScript.Echo("SPORTBOOK OUT: " & sportsbookOUT & vbcrlf)

Else

	WScript.Echo(vbcrlf & "No Completed Tickets.")

End If

sqlGetTickets = "SELECT TicketSlips.TicketSlipID, TicketSlips.TicketTypeID, TicketSlips.InsertDateTime, TicketSlips.AccountID, Accounts.ProfileName, TicketSlips.MatchupID, "
sqlGetTickets = sqlGetTickets & "NFLGames.AwayTeamID AS MatchupTeamID1, NFLGames.HomeTeamID AS MatchupTeamID2, T1.City + ' ' + T1.Name AS MatchupTeamName1, T2.City + ' ' + T2.Name AS MatchupTeamName2, NFLGames.AwayTeamScore AS TeamScore1, NFLGames.HomeTeamScore AS TeamScore2, (NFLGames.AwayTeamScore + NFLGames.HomeTeamScore) AS MatchupTotalScore, "
sqlGetTickets = sqlGetTickets & "TicketSlips.BetAmount, TicketSlips.PayoutAmount, TicketSlips.TeamID AS TicketSlipTeamID, T3.City + ' ' + T3.Name AS TicketSlipTeamName, TicketSlips.Moneyline, TicketSlips.Spread, TicketSlips.OverUnderAmount, TicketSlips.OverUnderBet "
sqlGetTickets = sqlGetTickets & "FROM TicketSlips "
sqlGetTickets = sqlGetTickets & "INNER JOIN NFLGames ON NFLGames.NFLGameID = TicketSlips.MatchupID "
sqlGetTickets = sqlGetTickets & "INNER JOIN Accounts ON Accounts.AccountID = TicketSlips.AccountID "
sqlGetTickets = sqlGetTickets & "LEFT JOIN NFLTeams T1 ON T1.NFLTeamID = NFLGames.AwayTeamID "
sqlGetTickets = sqlGetTickets & "LEFT JOIN NFLTeams T2 ON T2.NFLTeamID = NFLGames.HomeTeamID "
sqlGetTickets = sqlGetTickets & "LEFT JOIN NFLTeams T3 ON T3.NFLTeamID = TicketSlips.TeamID "
sqlGetTickets = sqlGetTickets & "WHERE TicketSlips.DateProcessed IS NULL AND TicketSlips.IsNFL = 1 AND NFLGames.IsComplete = 1"
Set rsTickets = sqlDatabase.Execute(sqlGetTickets)

If Not rsTickets.Eof Then

	sportsbookIN  = 0
	sportsbookOUT = 0
	totalWinners  = 0
	totalLosers   = 0

	WScript.Echo(vbcrlf & "NFL TICKETS SLIPS ARE FUCKING LOADED..." & vbcrlf & vbcrlf)

	WScript.Echo("SLIP" & vbTab & "BETTOR" & vbTab & "RESULT" & vbTab & "SELECTION" & vbTab & "WAGER" & vbTab & "PAYS" & vbTab & "MATH" & vbcrlf)

	Do While Not rsTickets.Eof

		thisTicketSlipID = rsTickets("TicketSlipID")
		thisTicketTypeID = rsTickets("TicketTypeID")
		thisInsertDateTime = rsTickets("InsertDateTime")
		thisAccountID = rsTickets("AccountID")
		thisProfileName = LEFT(rsTickets("ProfileName"), 6)
		thisMatchupID = rsTickets("MatchupID")
		thisMatchupTeamID1 = rsTickets("MatchupTeamID1")
		thisMatchupTeamID2 = rsTickets("MatchupTeamID2")
		thisMatchupTeamName1 = LEFT(rsTickets("MatchupTeamName1"), 6)
		thisMatchupTeamName2 = LEFT(rsTickets("MatchupTeamName2"), 6)
		thisTeamScore1 = rsTickets("TeamScore1")
		thisTeamScore2 = rsTickets("TeamScore2")
		thisMatchupTotalScore = rsTickets("MatchupTotalScore")
		thisBetAmount = rsTickets("BetAmount")
		thisPayoutAmount = rsTickets("PayoutAmount")
		thisTicketSlipTeamID = rsTickets("TicketSlipTeamID")
		thisTicketSlipTeamName = rsTickets("TicketSlipTeamName")
		thisMoneyline = rsTickets("Moneyline")
		thisSpread = rsTickets("Spread")
		thisOverUnderAmount = rsTickets("OverUnderAmount")
		thisOverUnderBet = rsTickets("OverUnderBet")

		If thisMoneyline > 0 Then thisMoneyline = "+" & thisMoneyline

		If CInt(thisTicketTypeID) = 1 Then

			'MONEYLINE'
			thisIsWinner = 0
			thisBetTeam = 1

			If CInt(thisTicketSlipTeamID) = CInt(thisMatchupTeamID2) Then thisBetTeam = 2

			If thisBetTeam = 1 Then
				If CDbl(thisTeamScore1) > CDbl(thisTeamScore2) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & thisMatchupTeamName1 & " (" & thisMoneyline & "ML)" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & thisTeamScore1 & " > " & thisTeamScore2)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & thisMatchupTeamName1 & " (" & thisMoneyline & "ML)" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & thisTeamScore1 & " < " & thisTeamScore2)
				End If
			ElseIf thisBetTeam = 2 Then
				If CDbl(thisTeamScore2) > CDbl(thisTeamScore1) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & thisMatchupTeamName2 & " (" & thisMoneyline & "ML)" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & thisTeamScore2 & " > " & thisTeamScore1)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & thisMatchupTeamName2 & " (" & thisMoneyline & "ML)" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & thisTeamScore2 & " < " & thisTeamScore1)
				End If
			End If

		ElseIf CInt(thisTicketTypeID) = 2 Then

			'SPREAD'
			thisIsWinner = 0
			thisBetTeam = 1

			If CInt(thisTicketSlipTeamID) = CInt(thisMatchupTeamID2) Then thisBetTeam = 2

			If thisBetTeam = 1 Then
				If (CDbl(thisTeamScore1) + thisSpread) > CDbl(thisTeamScore2) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & thisMatchupTeamName1 & " (" & thisSpread & ")" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & (CDbl(thisTeamScore1) + thisSpread) & " > " & thisTeamScore2)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & thisMatchupTeamName1 & " (" & thisSpread & ")" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & (CDbl(thisTeamScore1) + thisSpread) & " < " & thisTeamScore2)
				End If
			ElseIf thisBetTeam = 2 Then
				If (CDbl(thisTeamScore2) + thisSpread) > CDbl(thisTeamScore1) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & thisMatchupTeamName2 & " (" & thisSpread & ")" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & (CDbl(thisTeamScore2) + thisSpread) & " > " & thisTeamScore1)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & thisMatchupTeamName2 & " (" & thisSpread & ")" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & (CDbl(thisTeamScore2) + thisSpread) & " < " & thisTeamScore1)
				End If
			End If

		ElseIf CInt(thisTicketTypeID) = 3 Then

			'OVER / UNDER'
			thisIsWinner = 0

			If thisOverUnderBet = "OVER" Then
				If CDbl(thisMatchupTotalScore) > CDbl(thisOverUnderAmount) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & "#" & thisMatchupID & "  (O " & thisOverUnderAmount & ")" & vbTab & "$" & thisBetAmount & vbTab &  "$" & thisPayoutAmount & vbTab & CDbl(thisMatchupTotalScore) & " > " & thisOverUnderAmount)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & "#" & thisMatchupID & "  (O " & thisOverUnderAmount & ")" & vbTab & "$" & thisBetAmount & vbTab & "$" & thisPayoutAmount & vbTab & CDbl(thisMatchupTotalScore) & " < " & thisOverUnderAmount)
				End If
			ElseIf thisOverUnderBet = "UNDER" Then
				If CDbl(thisMatchupTotalScore) < CDbl(thisOverUnderAmount) Then
					thisIsWinner = 1
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "WINNER" & vbTab & "#" & thisMatchupID & "  (U " & thisOverUnderAmount & ")" & vbTab & "$" & thisBetAmount & vbTab &  "$" & thisPayoutAmount & vbTab & CDbl(thisMatchupTotalScore) & " < " & thisOverUnderAmount)
				Else
					thisPayoutAmount = 0
					WScript.Echo("#" & thisTicketSlipID & vbTab & thisProfileName & vbTab & "LOSER" & vbTab & "#" & thisMatchupID & "  (U " & thisOverUnderAmount & ")" & vbTab & "$" & thisBetAmount & vbTab &  "$" & thisPayoutAmount & vbTab & CDbl(thisMatchupTotalScore) & " > " & thisOverUnderAmount)
				End If
			End If

		End If

		If thisIsWinner = 1 Then

			sportsbookOUT = sportsbookOUT + (CInt(thisPayoutAmount) - CInt(thisBetAmount))
			totalWinners = totalWinners + 1

			sqlSchmeckleTransaction = "INSERT INTO SchmeckleTransactions (TransactionTypeID, TransactionTotal, AccountID, TicketSlipID) VALUES (1008, " & thisPayoutAmount & ", " & thisAccountID & ", " & thisTicketSlipID & ")"
			Set rsInsertMatchup = sqlDatabase.Execute(sqlSchmeckleTransaction)

		Else

			sportsbookIN = sportsbookIN + CInt(thisBetAmount)
			totalLosers = totalLosers + 1

		End If

		'PROCESS & ARCHIVE TICKET SLIP'
		sqlProcessTicketSlip = "UPDATE TicketSlips SET IsWinner = " & thisIsWinner & ", DateProcessed = '" & Now() & "' WHERE TicketSlipID = " & thisTicketSlipID
		Set rsTicketSlip = sqlDatabase.Execute(sqlProcessTicketSlip)

		rsTickets.MoveNext

	Loop

	rsTickets.Close
	Set rsTickets = Nothing

	WScript.Echo(vbcrlf & "SPORTBOOK IN: " & sportsbookIN & vbcrlf)
	WScript.Echo("TOTAL WINNERS: " & totalWinners & vbcrlf)
	WScript.Echo("TOTAL LOSERS: " & totalLosers & vbcrlf)
	WScript.Echo("SPORTBOOK OUT: " & sportsbookOUT & vbcrlf)

Else

	WScript.Echo(vbcrlf & "No Completed Tickets.")

End If

EndTime = Now()
