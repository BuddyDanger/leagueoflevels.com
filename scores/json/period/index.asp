<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp"-->
<%
	Response.ContentType = "application/json"

	thisTeamBaseScore1 = 0
	thisTeamBaseScore2 = 0

	sqlGetMatchup = "SELECT MatchupID, Matchups.LevelID AS MatchupLevel, Leg, "
	sqlGetMatchup = sqlGetMatchup & "TeamID1, TeamID2, "
	sqlGetMatchup = sqlGetMatchup & "Matchups.TeamScore1, Matchups.TeamScore2, "
	sqlGetMatchup = sqlGetMatchup & "Matchups.TeamPMR1, Matchups.TeamPMR2, "
	sqlGetMatchup = sqlGetMatchup & "Matchups.TeamProjected1, Matchups.TeamProjected2, "
	sqlGetMatchup = sqlGetMatchup & "Matchups.TeamWinPercentage1, Matchups.TeamWinPercentage2, "
	sqlGetMatchup = sqlGetMatchup & "Matchups.TeamMoneyline1, Matchups.TeamMoneyline2, "
	sqlGetMatchup = sqlGetMatchup & "Matchups.TeamSpread1, Matchups.TeamSpread2, "
	sqlGetMatchup = sqlGetMatchup & "(Matchups.TeamProjected1 + Matchups.TeamProjected2) AS ProjectedTotal, "
	sqlGetMatchup = sqlGetMatchup & "T1.TeamName AS TeamName1, T2.TeamName AS TeamName2, "
	sqlGetMatchup = sqlGetMatchup & "T1.LevelID AS TeamLevel1, T2.LevelID AS TeamLevel2 "
	sqlGetMatchup = sqlGetMatchup & "FROM Matchups LEFT JOIN Teams T1 ON T1.TeamID = Matchups.TeamID1 LEFT JOIN Teams T2 ON T2.TeamID = Matchups.TeamID2 WHERE Year = (SELECT TOP 1 Year FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC) AND Period = (SELECT TOP 1 Period FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC);"

	Set rsMatchup = sqlDatabase.Execute(sqlGetMatchup)

	slackJSON = slackJSON & "{"

		slackJSON = slackJSON & """matchups"":["

			Do While Not rsMatchup.Eof

				thisMatchupID = CInt(rsMatchup("MatchupID"))
				thisMatchupLevel = CInt(rsMatchup("MatchupLevel"))
				thisMatchupLeg = CInt(rsMatchup("Leg"))
				thisTeamID1 = rsMatchup("TeamID1")
				thisTeamID2 = rsMatchup("TeamID2")
				thisTeamScore1 = rsMatchup("TeamScore1")
				thisTeamScore2 = rsMatchup("TeamScore2")
				thisTeamPMR1 = CInt(rsMatchup("TeamPMR1"))
				thisTeamPMR2 = CInt(rsMatchup("TeamPMR2"))
				thisTeamProjected1 = rsMatchup("TeamProjected1")
				thisTeamProjected2 = rsMatchup("TeamProjected2")
				thisTeamWinPercentage1 = rsMatchup("TeamWinPercentage1")
				thisTeamWinPercentage2 = rsMatchup("TeamWinPercentage2")
				thisTeamMoneyline1 = rsMatchup("TeamMoneyline1")
				thisTeamMoneyline2 = rsMatchup("TeamMoneyline2")
				thisTeamSpread1 = rsMatchup("TeamSpread1")
				thisTeamSpread2 = rsMatchup("TeamSpread2")
				thisProjectedTotal = rsMatchup("ProjectedTotal")
				thisTeamName1 = rsMatchup("TeamName1")
				thisTeamName2 = rsMatchup("TeamName2")
				thisTeamLevel1 = rsMatchup("TeamLevel1")
				thisTeamLevel2 = rsMatchup("TeamLevel2")

				slackJSON = slackJSON & "{"

					If thisMatchupLevel = 0 And thisMatchupLeg > 1 Then

						If CInt(thisMatchupLeg) = 2 Then

							sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & thisTeamID1 & " OR TeamID2 = " & thisTeamID1 & ") AND LevelID = 0 AND Year = (SELECT TOP 1 Year FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC) AND Period = (SELECT TOP 1 Period FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC);"
							Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

							If CInt(rsLastWeek("TeamID1")) = CInt(thisTeamID1) Then thisTeamBaseScore1 = rsLastWeek("TeamScore1")
							If CInt(rsLastWeek("TeamID2")) = CInt(thisTeamID1) Then thisTeamBaseScore1 = rsLastWeek("TeamScore2")
							If CInt(rsLastWeek("TeamID1")) = CInt(thisTeamID2) Then thisTeamBaseScore2 = rsLastWeek("TeamScore1")
							If CInt(rsLastWeek("TeamID2")) = CInt(thisTeamID2) Then thisTeamBaseScore2 = rsLastWeek("TeamScore2")

						End If

						If CInt(thisMatchupLeg) = 3 Then

							sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & thisTeamID1 & " OR TeamID2 = " & thisTeamID1 & ") AND LevelID = 0 AND Year = (SELECT TOP 1 Year FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC) AND Period >= (SELECT TOP 1 Period FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC)-2 AND Period <= (SELECT TOP 1 Period FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC)-1"
							Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

							Do While Not rsLastWeek.Eof
								If CInt(rsLastWeek("TeamID1")) = CInt(thisTeamID1) Then thisTeamBaseScore1 = thisTeamBaseScore1 + rsLastWeek("TeamScore1")
								If CInt(rsLastWeek("TeamID2")) = CInt(thisTeamID1) Then thisTeamBaseScore1 = thisTeamBaseScore1 + rsLastWeek("TeamScore2")
								If CInt(rsLastWeek("TeamID1")) = CInt(thisTeamID2) Then thisTeamBaseScore2 = thisTeamBaseScore2 + rsLastWeek("TeamScore1")
								If CInt(rsLastWeek("TeamID2")) = CInt(thisTeamID2) Then thisTeamBaseScore2 = thisTeamBaseScore2 + rsLastWeek("TeamScore2")
								rsLastWeek.MoveNext
							Loop
							rsLastWeek.Close
							Set rsLastWeek = Nothing

						End If

						thisTeamScore1 = FormatNumber(thisTeamScore1 + thisTeamBaseScore1, 2)
						thisTeamScore2 = FormatNumber(thisTeamScore2 + thisTeamBaseScore2, 2)

					End If

					If thisMatchupLevel = 1 Then
						thisTeamPMRPercent1 = (thisTeamPMR1 * 100) / 600
						thisTeamPMRPercent2 = (thisTeamPMR2 * 100) / 600
					Else
						thisTeamPMRPercent1 = (thisTeamPMR1 * 100) / 420
						thisTeamPMRPercent2 = (thisTeamPMR2 * 100) / 420
					End If

					If thisMatchupLevel = 0 Then leagueTitle = "cup"
					If thisMatchupLevel = 1 Then leagueTitle = "omega"
					If thisMatchupLevel = 2 Then leagueTitle = "slffl"
					If thisMatchupLevel = 3 Then leagueTitle = "flffl"
					If thisTeamMoneyline1 > 0 Then thisTeamMoneyline1 = "+" & thisTeamMoneyline1
					If thisTeamMoneyline2 > 0 Then thisTeamMoneyline2 = "+" & thisTeamMoneyline2
					If thisTeamSpread1 > 0 Then thisTeamSpread1 = "+" & thisTeamSpread1
					If thisTeamSpread2 > 0 Then thisTeamSpread2 = "+" & thisTeamSpread2


					slackJSON = slackJSON & """id"":""" & thisMatchupID & ""","
					slackJSON = slackJSON & """level"":""" & leagueTitle & ""","
					slackJSON = slackJSON & """id1"":""" & thisTeamID1 & ""","
					slackJSON = slackJSON & """cbs1"":""" & thisTeamCBSID1 & ""","
					slackJSON = slackJSON & """name1"":""" & thisTeamName1 & ""","
					slackJSON = slackJSON & """score1"":""" & FormatNumber(thisTeamScore1, 2) & ""","
					slackJSON = slackJSON & """pmr1"":""" & thisTeamPMR1 & ""","
					slackJSON = slackJSON & """pmrp1"":""" & FormatNumber(thisTeamPMRPercent1, 2) & ""","
					slackJSON = slackJSON & """proj1"":""" & FormatNumber(thisTeamProjected1, 2) & ""","
					slackJSON = slackJSON & """chance1"":""" & FormatNumber(thisTeamWinPercentage1, 2) & ""","
					slackJSON = slackJSON & """ml1"":""" & thisTeamMoneyline1 & ""","
					slackJSON = slackJSON & """spread1"":""" & thisTeamSpread1 & ""","
					slackJSON = slackJSON & """id2"":""" & thisTeamID2 & ""","
					slackJSON = slackJSON & """cbs2"":""" & thisTeamCBSID2 & ""","
					slackJSON = slackJSON & """name2"":""" & thisTeamName2 & ""","
					slackJSON = slackJSON & """score2"":""" & FormatNumber(thisTeamScore2, 2) & ""","
					slackJSON = slackJSON & """pmr2"":""" & thisTeamPMR2 & ""","
					slackJSON = slackJSON & """pmrp2"":""" & FormatNumber(thisTeamPMRPercent2, 2) & ""","
					slackJSON = slackJSON & """proj2"":""" & FormatNumber(thisTeamProjected2, 2) & ""","
					slackJSON = slackJSON & """chance2"":""" & FormatNumber(thisTeamWinPercentage2, 2) & ""","
					slackJSON = slackJSON & """ml2"":""" & thisTeamMoneyline2 & ""","
					slackJSON = slackJSON & """spread2"":""" & thisTeamSpread2 & ""","
					slackJSON = slackJSON & """projtotal"":""" & thisProjectedTotal & """"

				slackJSON = slackJSON & "},"

				rsMatchup.MoveNext

			Loop

			If Right(slackJSON, 1) = "," Then slackJSON = Left(slackJSON, Len(slackJSON)-1)

		slackJSON = slackJSON & "]"

	slackJSON = slackJSON & "}"

	rsMatchup.Close
	Set rsMatchup = Nothing

	Response.Write(slackJSON)
%>
