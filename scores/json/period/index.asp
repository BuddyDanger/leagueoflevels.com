<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp"-->
<!--#include virtual="/assets/asp/framework/session.asp"-->
<!--#include virtual="/assets/asp/functions/master.asp"-->
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
	sqlGetMatchup = sqlGetMatchup & "T1.LevelID AS TeamLevel1, T2.LevelID AS TeamLevel2, "
	sqlGetMatchup = sqlGetMatchup & "T1.CBSID AS TeamCBSID1, T2.CBSID AS TeamCBSID2 "
	sqlGetMatchup = sqlGetMatchup & "FROM Matchups LEFT JOIN Teams T1 ON T1.TeamID = Matchups.TeamID1 LEFT JOIN Teams T2 ON T2.TeamID = Matchups.TeamID2 WHERE Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & ";"

	Set rsMatchup = sqlDatabase.Execute(sqlGetMatchup)

	slackJSON = slackJSON & "{"

		slackJSON = slackJSON & """matchups"":{"

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
				thisTeamCBSID1 = rsMatchup("TeamCBSID1")
				thisTeamCBSID2 = rsMatchup("TeamCBSID2")

				slackJSON = slackJSON & """" & thisMatchupID & """:["

					If thisMatchupLevel = 0 And thisMatchupLeg > 1 Then

						If CInt(thisMatchupLeg) = 2 Then

							sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & thisTeamID1 & " OR TeamID2 = " & thisTeamID1 & ") AND LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") - 1 & ";"
							Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

							If CInt(rsLastWeek("TeamID1")) = CInt(thisTeamID1) Then thisTeamBaseScore1 = rsLastWeek("TeamScore1")
							If CInt(rsLastWeek("TeamID2")) = CInt(thisTeamID1) Then thisTeamBaseScore1 = rsLastWeek("TeamScore2")
							If CInt(rsLastWeek("TeamID1")) = CInt(thisTeamID2) Then thisTeamBaseScore2 = rsLastWeek("TeamScore1")
							If CInt(rsLastWeek("TeamID2")) = CInt(thisTeamID2) Then thisTeamBaseScore2 = rsLastWeek("TeamScore2")

						End If

						If CInt(thisMatchupLeg) = 3 Then

							sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & thisTeamID1 & " OR TeamID2 = " & thisTeamID1 & ") AND LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period >= " & Session.Contents("CurrentPeriod") - 2 & " AND Period <= " & Session.Contents("CurrentPeriod") - 1
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

						thisTeamPMRColor1 = "success"
						If thisTeamPMR1 < 396 Then thisTeamPMRColor1 = "warning"
						If thisTeamPMR1 < 198 Then thisTeamPMRColor1 = "danger"
						thisTeamPMRPercent1 = (thisTeamPMR1 * 100) / 600

						thisTeamPMRColor2 = "success"
						If thisTeamPMR2 < 396 Then thisTeamPMRColor2 = "warning"
						If thisTeamPMR2 < 198 Then thisTeamPMRColor2 = "danger"
						thisTeamPMRPercent2 = (thisTeamPMR2 * 100) / 600

					Else

						thisTeamPMRColor1 = "success"
						If thisTeamPMR1 < 321 Then thisTeamPMRColor1 = "warning"
						If thisTeamPMR1 < 161 Then thisTeamPMRColor1 = "danger"
						thisTeamPMRPercent1 = (thisTeamPMR1 * 100) / 420

						thisTeamPMRColor2 = "success"
						If thisTeamPMR2 < 321 Then thisTeamPMRColor2 = "warning"
						If thisTeamPMR2 < 161 Then thisTeamPMRColor2 = "danger"
						thisTeamPMRPercent2 = (thisTeamPMR2 * 100) / 420

					End If

					If thisMatchupLevel = 0 Then leagueTitle = "cup"
					If thisMatchupLevel = 1 Then leagueTitle = "omega"
					If thisMatchupLevel = 2 Then leagueTitle = "slffl"
					If thisMatchupLevel = 3 Then leagueTitle = "flffl"


					thisTeamProjected1 = rsMatchup("TeamProjected1")
					thisTeamProjected2 = rsMatchup("TeamProjected2")
					thisTeamWinPercentage1 = rsMatchup("TeamWinPercentage1")
					thisTeamWinPercentage2 = rsMatchup("TeamWinPercentage2")
					thisTeamMoneyline1 = rsMatchup("TeamMoneyline1")
					thisTeamMoneyline2 = rsMatchup("TeamMoneyline2")
					thisTeamSpread1 = rsMatchup("TeamSpread1")
					thisTeamSpread2 = rsMatchup("TeamSpread2")
					thisProjectedTotal = rsMatchup("ProjectedTotal")

					slackJSON = slackJSON & "{"

						slackJSON = slackJSON & """level"": """ & leagueTitle & ""","
						slackJSON = slackJSON & """teamid1"": """ & thisTeamID1 & ""","
						slackJSON = slackJSON & """teamname1"": """ & thisTeamName1 & ""","
						slackJSON = slackJSON & """teamscore1"": """ & FormatNumber(thisTeamScore1, 2) & ""","
						slackJSON = slackJSON & """teampmr1"": """ & thisTeamPMR1 & ""","
						slackJSON = slackJSON & """teampmrpercent1"": """ & FormatNumber(thisTeamPMRPercent1, 2) & ""","
						slackJSON = slackJSON & """teampmrcolor1"": """ & thisTeamPMRColor1 & ""","
						slackJSON = slackJSON & """teamprojected1"": """ & FormatNumber(thisTeamProjected1, 2) & ""","
						slackJSON = slackJSON & """teamwinpercentage1"": """ & FormatNumber(thisTeamWinPercentage1, 2) & ""","
						slackJSON = slackJSON & """teammoneyline1"": """ & thisTeamMoneyline1 & ""","
						slackJSON = slackJSON & """teamspread1"": """ & thisTeamSpread1 & ""","
						slackJSON = slackJSON & """teamid2"": """ & thisTeamID2 & ""","
						slackJSON = slackJSON & """teamname2"": """ & thisTeamName2 & ""","
						slackJSON = slackJSON & """teamscore2"": """ & FormatNumber(thisTeamScore2, 2) & ""","
						slackJSON = slackJSON & """teampmr2"": """ & thisTeamPMR2 & ""","
						slackJSON = slackJSON & """teampmrpercent2"": """ & FormatNumber(thisTeamPMRPercent2, 2) & ""","
						slackJSON = slackJSON & """teampmrcolor2"": """ & thisTeamPMRColor2 & ""","
						slackJSON = slackJSON & """teamprojected2"": """ & FormatNumber(thisTeamProjected2, 2) & ""","
						slackJSON = slackJSON & """teamwinpercentage2"": """ & FormatNumber(thisTeamWinPercentage2, 2) & ""","
						slackJSON = slackJSON & """teammoneyline2"": """ & thisTeamMoneyline2 & ""","
						slackJSON = slackJSON & """teamspread2"": """ & thisTeamSpread2 & ""","
						slackJSON = slackJSON & """projectedtotal"": """ & thisProjectedTotal & """"

					slackJSON = slackJSON & "} "

				slackJSON = slackJSON & "], "

				rsMatchup.MoveNext

			Loop

			If Right(slackJSON, 2) = ", " Then slackJSON = Left(slackJSON, Len(slackJSON)-2)

		slackJSON = slackJSON & "} "

	slackJSON = slackJSON & "} "

	rsMatchup.Close
	Set rsMatchup = Nothing

	Response.Write(slackJSON)
%>
