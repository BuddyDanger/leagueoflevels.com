StartTime = Now()
WScript.Echo("STARTING..." & vbcrlf)

Set sqlDatabase = CreateObject("ADODB.Connection")
sqlDatabase.CursorLocation = adUseServer
sqlDatabase.Open "Driver={SQL Server Native Client 11.0};Server=tcp:samelevel.database.windows.net,1433;Database=NextLevelDB;Uid=samelevel;Pwd=TheHammer123;Encrypt=yes;Connection Timeout=60;"

thisYear = 2020
thisPeriod = 1

sqlGetYearPeriod = "SELECT TOP 1 Year, Period FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC"
Set rsYearPeriod = sqlDatabase.Execute(sqlGetYearPeriod)

If Not rsYearPeriod.Eof Then

	thisCurrentYear = rsYearPeriod("Year")
	thisCurrentPeriod = rsYearPeriod("Period")

	rsYearPeriod.Close
	Set rsYearPeriod = Nothing

End If

thisCurrentPeriod = 7

thisYear = thisCurrentYear
thisPeriod = 6

Do While thisPeriod < thisCurrentPeriod

	sqlGetTeams = "SELECT TeamID, LevelID, TeamName FROM Teams WHERE EndYear = 0 ORDER BY LevelID"
	Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

	If Not rsTeams.Eof Then

		WScript.Echo(vbcrlf & "WEEK " & thisPeriod & " IS LOADED..." & vbcrlf & vbcrlf)

		Do While Not rsTeams.Eof

			thisLevelID = rsTeams("LevelID")
			thisTeamID = rsTeams("TeamID")
			thisTeamName = rsTeams("TeamName")

			sqlGetMatchups = "SELECT * FROM Matchups WHERE Year = " & thisYear & " AND Period = " & thisPeriod & " AND LevelID = " & thisLevelID & " AND (TeamID1 = " & thisTeamID & " OR TeamID2 = " & thisTeamID & ") ORDER BY Year, Period"
			Set rsMatchups = sqlDatabase.Execute(sqlGetMatchups)

			If Not rsMatchups.Eof Then

				thisTeamWins = 0
				thisTeamLosses = 0
				thisTeamTies = 0
				thisTeamPointsScored = 0
				thisTeamPointsAgainst = 0

				Do While Not rsMatchups.Eof

					thisTeamID1 = rsMatchups("TeamID1")
					thisTeamID2 = rsMatchups("TeamID2")
					thisTeamScore1 = rsMatchups("TeamScore1")
					thisTeamScore2 = rsMatchups("TeamScore2")

					If thisTeamID = thisTeamID1	Then

						If thisTeamScore1 > thisTeamScore2 Then thisTeamWins = thisTeamWins + 1
						If thisTeamScore1 < thisTeamScore2 Then thisTeamLosses = thisTeamLosses + 1
						If thisTeamScore1 = thisTeamScore2 Then thisTeamTies = thisTeamTies + 1
						thisTeamPointsScored = thisTeamPointsScored + thisTeamScore1
						thisTeamPointsAgainst = thisTeamPointsAgainst + thisTeamScore2

					Else

						If thisTeamScore2 > thisTeamScore1 Then thisTeamWins = thisTeamWins + 1
						If thisTeamScore2 < thisTeamScore1 Then thisTeamLosses = thisTeamLosses + 1
						If thisTeamScore2 = thisTeamScore1 Then thisTeamTies = thisTeamTies + 1
						thisTeamPointsScored = thisTeamPointsScored + thisTeamScore2
						thisTeamPointsAgainst = thisTeamPointsAgainst + thisTeamScore1

					End If

					rsMatchups.MoveNext

				Loop

				rsMatchups.Close
				Set rsMatchups = Nothing

				WScript.Echo(thisTeamWins & "-" & thisTeamLosses & "-" & thisTeamTies & " (" & thisTeamPointsScored & " / " & thisTeamPointsAgainst & ")" & vbcrlf)

				sqlInsertTeamStandings = "INSERT INTO Standings (LevelID, Year, Period, TeamID, ActualWins, ActualLosses, ActualTies, PointsScored, PointsAgainst) VALUES (" & thisLevelID & ", " & thisYear & ", " & thisPeriod & ", " & thisTeamID & ", " & thisTeamWins & ", " & thisTeamLosses & ", " & thisTeamTies & ", " & thisTeamPointsScored & ", " & thisTeamPointsAgainst & ")"
				Set rsTeamStandings = sqlDatabase.Execute(sqlInsertTeamStandings)

			End If

			rsTeams.MoveNext

		Loop

		rsTeams.Close
		Set rsTeams = Nothing

	End If

	sqlGetTeams = "SELECT TeamID, LevelID, TeamName FROM Teams WHERE EndYear = 0 ORDER BY LevelID"
	Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

	If Not rsTeams.Eof Then

		WScript.Echo(vbcrlf & "TEAMS ARE FUCKING LOADED AGAIN..." & vbcrlf & vbcrlf)

		Do While Not rsTeams.Eof

			thisLevelID = rsTeams("LevelID")
			thisTeamID = rsTeams("TeamID")
			thisTeamName = rsTeams("TeamName")
			thisTeamBreakdownWins = 0
			thisTeamBreakdownLosses = 0
			thisTeamBreakdownTies = 0
			thisTeamPosition = 0

			sqlGetThisScore = "SELECT PointsScored FROM Standings WHERE Year = " & thisYear & " AND Period = " & thisPeriod & " AND TeamID = " & thisTeamID
			Set rsThisScore = sqlDatabase.Execute(sqlGetThisScore)

			thisTeamScore = rsThisScore("PointsScored")

			rsThisScore.Close
			Set rsThisScore = Nothing

			sqlGetOpposingTeams = "SELECT * FROM Standings WHERE LevelID = " & thisLevelID & " AND Year = " & thisYear & " AND Period = " & thisPeriod & " AND TeamID <> " & thisTeamID
			Set rsOpposingTeams = sqlDatabase.Execute(sqlGetOpposingTeams)

			Do While Not rsOpposingTeams.Eof

				If thisTeamScore > rsOpposingTeams("PointsScored") Then thisTeamBreakdownWins = thisTeamBreakdownWins + 1
				If thisTeamScore < rsOpposingTeams("PointsScored") Then thisTeamBreakdownLosses = thisTeamBreakdownLosses + 1
				If thisTeamScore = rsOpposingTeams("PointsScored") Then thisTeamBreakdownTies = thisTeamBreakdownTies + 1

				rsOpposingTeams.MoveNext

			Loop

			sqlGetPositions = "SELECT TeamID, SUM(ActualWins) AS TotalWins, SUM(ActualLosses) AS TotalLosses, SUM(ActualTies) AS TotalTies, SUM(PointsScored) AS TotalPointsScored, SUM(PointsAgainst) AS TotalPointsAgainst FROM Standings WHERE LevelID = " & thisLevelID & " AND Period <= " & thisPeriod & " GROUP BY Year, TeamID ORDER BY TotalWins DESC, TotalPointsScored DESC"
			Set rsPositions = sqlDatabase.Execute(sqlGetPositions)

			thisPositionCheck = 1
			Do While Not rsPositions.Eof

				If CInt(rsPositions("TeamID")) = CInt(thisTeamID) Then thisTeamPosition = thisPositionCheck

				thisPositionCheck = thisPositionCheck + 1

				rsPositions.MoveNext

			Loop

			rsPositions.Close
			Set rsPositions = Nothing

			sqlUpdateStandings = "UPDATE Standings SET BreakdownWins = " & thisTeamBreakdownWins & ", BreakdownLosses = " & thisTeamBreakdownLosses & ", BreakdownTies = " & thisTeamBreakdownTies & ", Position = " & thisTeamPosition & " WHERE LevelID = " & thisLevelID & " AND Year = " & thisYear & " AND Period = " & thisPeriod & " AND TeamID = " & thisTeamID
			Set rsUpdate = sqlDatabase.Execute(sqlUpdateStandings)

			WScript.Echo(thisTeamName & " POSITION AND BREAKDOWN COMPLETE" & vbcrlf)

			rsTeams.MoveNext

		Loop

		rsTeams.Close
		Set rsTeams = Nothing

	End If

	thisPeriod = thisPeriod + 1

Loop

EndTime = Now()
