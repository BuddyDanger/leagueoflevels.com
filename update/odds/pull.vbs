StartTime = Now()
WScript.Echo("STARTING..." & vbcrlf)

Function CalculateWinPercentage (TeamPMR1, TeamPMR2, TeamProjected1, TeamProjected2, TeamScore1, TeamScore2)

	homePlayerMinutesRemaining = TeamPMR1
	awayPlayerMinutesRemaining = TeamPMR2
	homeLiveProjectedFPTS = TeamProjected1
	awayLiveProjectedFPTS = TeamProjected2
	homeActualScore = TeamScore1
	awayActualScore = TeamScore2

	homePointProgress = Exp(homeActualScore / homeLiveProjectedFPTS)
	awayPointProgress = Exp(awayActualScore / awayLiveProjectedFPTS)

	homeProjectedRange = Abs(homeLiveProjectedFPTS - homeActualScore) * homePointProgress * 0.5
	awayProjectedRange = Abs(awayLiveProjectedFPTS - awayActualScore) * awayPointProgress * 0.5

	homeProjectedWindowLower = homeLiveProjectedFPTS - homeProjectedRange
	homeProjectedWindowUpper = homeLiveProjectedFPTS + homeProjectedRange

	awayProjectedWindowLower = awayLiveProjectedFPTS - awayProjectedRange
	awayProjectedWindowUpper = awayLiveProjectedFPTS + awayProjectedRange

	If homeProjectedWindowLower < awayProjectedWindowLower Then
		overallLowestLow = homeProjectedWindowLower
	Else
		overallLowestLow = awayProjectedWindowLower
	End If

	If homeProjectedWindowUpper > awayProjectedWindowUpper Then
		overallHighestHigh = homeProjectedWindowUpper
	Else
		overallHighestHigh = awayProjectedWindowUpper
	End If

	overallSpreadLarge = overallHighestHigh - overallLowestLow

	If homeProjectedWindowLower > awayProjectedWindowLower Then
		overallHighestLow = homeProjectedWindowLower
	Else
		overallHighestLow = awayProjectedWindowLower
	End If

	If homeProjectedWindowUpper < awayProjectedWindowUpper Then
		overallLowestHigh = homeProjectedWindowUpper
	Else
		overallLowestHigh = awayProjectedWindowUpper
	End If

	overallSpreadSmall = overallLowestHigh - overallHighestLow

	tieWin = overallSpreadSmall / 2

	If homeProjectedWindowLower > awayProjectedWindowLower Then
		homeWindowDifference = homeProjectedWindowLower - awayProjectedWindowLower
	Else
		homeWindowDifference = 0
	End If

	If homeProjectedWindowUpper > awayProjectedWindowUpper Then homeWindowDifference = homeWindowDifference + (homeProjectedWindowUpper - awayProjectedWindowUpper)

	If (homeLiveProjectedFPTS = 0 And awayLiveProjectedFPTS > 0) Then
		homeWinProbability = 0
		awayWinProbability = 100
	Else
		If (awayLiveProjectedFPTS = 0 And homeLiveProjectedFPTS > 0) Then
			homeWinProbability = 100
			awayWinProbability = 0
		Else
			If (awayPlayerMinutesRemaining = 0 And awayActualScore < homeActualScore And awayLiveProjectedFPTS < homeLiveProjectedFPTS) Then
				awayWinProbability = 0
				homeWinProbability = 100
			Else
				If (homePlayerMinutesRemaining = 0 And homeActualScore < awayActualScore And homeLiveProjectedFPTS < awayLiveProjectedFPTS) Then
					homeWinProbability = 0
					awayWinProbability = 100
				Else
					If (awayPlayerMinutesRemaining = 0 And homePlayerMinutesRemaining = 0) Then
						If (homeLiveProjectedFPTS > awayLiveProjectedFPTS) Then
							homeWinProbability = 100
							awayWinProbability = 0
						Else
							If (awayLiveProjectedFPTS > homeLiveProjectedFPTS) Then
								homeWinProbability = 0
								awayWinProbability = 100
							Else
								homeWinProbability = 0
								awayWinProbability = 0
							End If
						End If
					Else
						If (homeProjectedWindowUpper < awayProjectedWindowLower) Then
							homeWinProbability = 1
							awayWinProbability = 99
						Else
							If (awayProjectedWindowUpper < homeProjectedWindowLower) Then
								homeWinProbability = 99
								awayWinProbability = 1
							Else
								homeWinProbability = FormatNumber((tieWin + homeWindowDifference) / overallSpreadLarge * 100, 0)
								awayWinProbability = 100 - homeWinProbability
							End If
						End If
					End If
				End If
			End If
		End If
	End If

	CalculateWinPercentage = homeWinProbability & "/" & awayWinProbability

End Function

Set sqlDatabase = CreateObject("ADODB.Connection")
sqlDatabase.CursorLocation = adUseServer
sqlDatabase.Open "Driver={SQL Server Native Client 11.0};Server=tcp:loldb.database.windows.net,1433;Database=leagueoflevels;Uid=commissioner;Pwd=TheHammer123;Encrypt=yes;Connection Timeout=60;"

sqlGetYearPeriod = "SELECT TOP 1 Year, Period FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC"
Set rsYearPeriod = sqlDatabase.Execute(sqlGetYearPeriod)

If Not rsYearPeriod.Eof Then

	thisYear = rsYearPeriod("Year")
	thisPeriod = rsYearPeriod("Period")

	rsYearPeriod.Close
	Set rsYearPeriod = Nothing

End If

Set xmlhttpOdds = CreateObject("Microsoft.XMLHTTP")
xmlhttpOdds.open "GET", "http://fanduel.dimedata.net/api/xml/odds/v3/900/fanduel/football/nfl/all?api-key=8d21abf1b4283c4698223160acf78d0e", false
xmlhttpOdds.send ""

Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
oXML.loadXML(xmlhttpOdds.ResponseText)

Set Root = oXML.documentElement
Set NodeList = Root.getElementsByTagName("game")

sqlGetGames = "SELECT [NFLGameID], [Year], [Period], CAST([DateTimeEST] AS date) AS Gameday, [DateTimeEST], A.City + ' ' + A.Name AS AwayTeam, H.City + ' ' + H.Name AS HomeTeam FROM [dbo].[NFLGames] INNER JOIN NFLTeams A ON A.NFLTeamID = NFLGames.AwayTeamID INNER JOIN NFLTeams H ON H.NFLTeamID = NFLGames.HomeTeamID WHERE Year = 2021 AND Period = 1"
Set rsGames = sqlDatabase.Execute(sqlGetGames)

Do While Not rsGames.Eof

	thisNFLGameID = rsGames("NFLGameID")
	thisNFLGameYear = rsGames("Year")
	thisNFLGamePeriod = rsGames("Period")
	thisNFLGameDay = rsGames("Gameday")
	thisNFLGameDateTimeEST = rsGames("DateTimeEST")
	thisNFLAwayTeam = rsGames("AwayTeam")
	thisNFLHomeTeam = rsGames("HomeTeam")

	For i = 0 to NodeList.length -1

		Set gameTime = oXML.getElementsByTagName("startDate")(i)
		thisGameTimeUTC = Replace(Replace(gameTime.text, "Z", ""), "T", " ")
		thisGameTimeEST = DateAdd("h", -4, thisGameTimeUTC)

		arrGameDay = Split(thisGameTimeEST, " ")
		thisGameDay = arrGameDay(0)

		If CDate(thisGameDay) = CDate(thisNFLGameDay) Then

			Set awayTeam = oXML.getElementsByTagName("awayTeam")(i)
			thisAwayTeam = awayTeam.text

			If thisAwayTeam = thisNFLAwayTeam Then

				Set homeTeam = oXML.getElementsByTagName("homeTeam")(i)
				Set betType = oXML.getElementsByTagName("betType")(i)
				Set betName = oXML.getElementsByTagName("betName")(i)
				Set betPrice = oXML.getElementsByTagName("betPrice")(i)

				If UCase(betType.text) = "TOTAL POINTS" Then

					arrBetName = Split(betName.text, " ")
					TotalPoints = arrBetName(1)

				End If

				If UCase(betType.text) = "POINT SPREAD" Then

					If InStr(betName.text, "-") Then
						arrBetName = Split(betName.text, "-")
						BetTeam = Left(arrBetName(0), Len(arrBetName(0))-1)
						BetSpread = "-" & arrBetName(1)
					End If

					If InStr(betName.text, "+") Then
						arrBetName = Split(betName.text, "+")
						BetTeam = Left(arrBetName(0), Len(arrBetName(0))-1)
						BetSpread = arrBetName(1)
					End If

					If BetTeam = thisAwayTeam Then
						AwayTeamSpread = BetSpread
						If InStr(AwayTeamSpread, "+") Then AwayTeamSpread = Replace(AwayTeamSpread, "+", "")
					Else
						HomeTeamSpread = BetSpread
						If InStr(HomeTeamSpread, "+") Then HomeTeamSpread = Replace(HomeTeamSpread, "+", "")
					End If

				End If

				If UCase(betType.text) = "MONEYLINE" Then

					If betName.text = thisAwayTeam Then
						AwayTeamMoneyline = betPrice.text
						If InStr(AwayTeamMoneyline, "+") Then AwayTeamMoneyline = Replace(AwayTeamMoneyline, "+", "")
					Else
						HomeTeamMoneyline = betPrice.text
						If InStr(HomeTeamMoneyline, "+") Then HomeTeamMoneyline = Replace(HomeTeamMoneyline, "+", "")
					End If

				End If

			End If

		End If

	Next

	WScript.Echo(vbcrlf & thisNFLGameDateTimeEST)
	WScript.Echo(vbcrlf & thisNFLAwayTeam & " @ " & thisNFLHomeTeam)
	WScript.Echo(vbcrlf & "TOTAL POINTS: " & TotalPoints)
	WScript.Echo(vbcrlf & "AWAY SPREAD: " & AwayTeamSpread)
	WScript.Echo(vbcrlf & "HOME SPREAD: " & HomeTeamSpread)
	WScript.Echo(vbcrlf & "AWAY MONEYLINE: " & AwayTeamMoneyline)
	WScript.Echo(vbcrlf & "HOME MONEYLINE: " & HomeTeamMoneyline)
	WScript.Echo(vbcrlf & "**********************************")

	sqlUpdateOdds = "UPDATE NFLGames SET "
	sqlUpdateOdds = sqlUpdateOdds & "AwayTeamMoneyline = " & AwayTeamMoneyline & ", "
	sqlUpdateOdds = sqlUpdateOdds & "HomeTeamMoneyline = " & HomeTeamMoneyline & ", "
	sqlUpdateOdds = sqlUpdateOdds & "AwayTeamSpread = " & AwayTeamSpread & ", "
	sqlUpdateOdds = sqlUpdateOdds & "HomeTeamSpread = " & HomeTeamSpread & ", "
	sqlUpdateOdds = sqlUpdateOdds & "OverUnderTotal = " & TotalPoints & " "
	sqlUpdateOdds = sqlUpdateOdds & "WHERE NFLGameID = " & thisNFLGameID
	Set rsUpdateOdds = sqlDatabase.Execute(sqlUpdateOdds)

	rsGames.MoveNext

Loop


EndTime = Now()

WScript.Echo(vbcrlf & StartTime)
WScript.Echo(vbcrlf & EndTime)
