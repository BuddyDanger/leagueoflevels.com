StartTime = Now()
WScript.Echo("STARTING..." & vbcrlf)

Set sqlDatabase = CreateObject("ADODB.Connection")
sqlDatabase.CursorLocation = adUseServer
sqlDatabase.Open "Driver={SQL Server Native Client 11.0};Server=tcp:samelevel.database.windows.net,1433;Database=NextLevelDB;Uid=samelevel;Pwd=TheHammer123;Encrypt=yes;Connection Timeout=60;"

'WScript.Echo("CLEARING STANDINGS..." & vbcrlf)

'sqlClearStandings    = "DELETE FROM Standings"
'Set rsClearStandings = sqlDatabase.Execute(sqlClearStandings)

WScript.Echo("SETTING CURRENT PERIOD..." & vbcrlf)

sqlGetYearPeriod = "SELECT TOP 1 Year, Period FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC"
Set rsYearPeriod = sqlDatabase.Execute(sqlGetYearPeriod)

If Not rsYearPeriod.Eof Then

	thisCurrentYear = rsYearPeriod("Year")
	thisCurrentPeriod = 16

	rsYearPeriod.Close
	Set rsYearPeriod = Nothing

End If

thisYear = 2020
thisPeriod = 15

Do While thisYear < 2021

	Do While thisPeriod < thisCurrentPeriod

		sqlGetTeams = "SELECT TeamID, LevelID, TeamName FROM Teams WHERE EndYear = 0 OR EndYear >= " & thisYear & " ORDER BY LevelID"
		Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

		If Not rsTeams.Eof Then

			WScript.Echo(vbcrlf & "WEEK " & thisPeriod & " IS LOADED..." & vbcrlf & vbcrlf)

			sqlInsertTeamStandings = ""

			Do While Not rsTeams.Eof

				thisTeamID = rsTeams("TeamID")
				thisTeamName = rsTeams("TeamName")

				sqlGetMatchups = "SELECT * FROM Matchups WHERE Year = " & thisYear & " AND Period = " & thisPeriod & " AND (TeamID1 = " & thisTeamID & " OR TeamID2 = " & thisTeamID & ") AND Matchups.LevelID > 0 ORDER BY Year, Period"
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
						thisLevelID = rsMatchups("LevelID")

						If IsNull(thisTeamScore1) Then thisTeamScore1 = 0
						If IsNull(thisTeamScore2) Then thisTeamScore2 = 0

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

					WScript.Echo(thisLevelID & ", " & thisYear & ", " & thisPeriod & ", " & thisTeamID & ", " & thisTeamWins & ", " & thisTeamLosses & ", " & thisTeamTies & ", " & thisTeamPointsScored & ", " & thisTeamPointsAgainst & vbcrlf)

					sqlInsertTeamStandings = sqlInsertTeamStandings & "INSERT INTO Standings (LevelID, Year, Period, TeamID, ActualWins, ActualLosses, ActualTies, PointsScored, PointsAgainst) VALUES (" & thisLevelID & ", " & thisYear & ", " & thisPeriod & ", " & thisTeamID & ", " & thisTeamWins & ", " & thisTeamLosses & ", " & thisTeamTies & ", " & thisTeamPointsScored & ", " & thisTeamPointsAgainst & "); "

				End If

				rsTeams.MoveNext

			Loop

			rsTeams.Close
			Set rsTeams = Nothing

			WScript.Echo("INSERTING STANDINGS..." & vbcrlf)
			Set rsTeamStandings = sqlDatabase.Execute(sqlInsertTeamStandings)

		End If

		sqlGetTeams = "SELECT TeamID, LevelID, TeamName FROM Teams ORDER BY LevelID"
		Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

		If Not rsTeams.Eof Then

			WScript.Echo(vbcrlf & "TEAMS ARE FUCKING LOADED AGAIN..." & vbcrlf & vbcrlf)

			sqlUpdateStandings = ""

			Do While Not rsTeams.Eof

				thisTeamID = rsTeams("TeamID")
				thisTeamName = rsTeams("TeamName")
				thisTeamBreakdownWins = 0
				thisTeamBreakdownLosses = 0
				thisTeamBreakdownTies = 0
				thisTeamPosition = 0

				sqlGetThisScore = "SELECT LevelID, PointsScored FROM Standings WHERE Year = " & thisYear & " AND Period = " & thisPeriod & " AND TeamID = " & thisTeamID
				Set rsThisScore = sqlDatabase.Execute(sqlGetThisScore)

				If Not rsThisScore.Eof Then

					thisTeamScore = rsThisScore("PointsScored")
					thisLevelID = rsThisScore("LevelID")

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

					sqlUpdateStandings = sqlUpdateStandings & "UPDATE Standings SET BreakdownWins = " & thisTeamBreakdownWins & ", BreakdownLosses = " & thisTeamBreakdownLosses & ", BreakdownTies = " & thisTeamBreakdownTies & ", Position = " & thisTeamPosition & " WHERE LevelID = " & thisLevelID & " AND Year = " & thisYear & " AND Period = " & thisPeriod & " AND TeamID = " & thisTeamID & "; "

					WScript.Echo(thisTeamName & " POSITION AND BREAKDOWN COMPLETE" & vbcrlf)

				End If

				rsTeams.MoveNext

			Loop

			rsTeams.Close
			Set rsTeams = Nothing

			WScript.Echo("UPDATING BREAKDOWN..." & vbcrlf)
			Set rsUpdate = sqlDatabase.Execute(sqlUpdateStandings)

		End If

		thisPeriod = thisPeriod + 1

	Loop

	thisYear = thisYear + 1

Loop

EndTime = Now()
