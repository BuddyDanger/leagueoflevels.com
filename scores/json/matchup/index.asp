<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp"-->
<!--#include virtual="/assets/asp/framework/session.asp"-->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	Response.ContentType = "application/json"

	thisMatchupID = Request.QueryString("id")
	thisTeamBaseScore1 = 0
	thisTeamBaseScore2 = 0

	sqlGetMatchup = "SELECT MatchupID, Matchups.LevelID AS MatchupLevel, Leg, Matchups.TeamPMR1, Matchups.TeamPMR2, Matchups.TeamScore1, Matchups.TeamScore2, TeamID1, T1.TeamName AS TeamName1, T1.LevelID AS TeamLevel1, T1.CBSID AS TeamCBSID1, TeamID2, T2.TeamName AS TeamName2, T2.LevelID AS TeamLevel2, T2.CBSID AS TeamCBSID2 "
	sqlGetMatchup = sqlGetMatchup & "FROM Matchups LEFT JOIN Teams T1 ON T1.TeamID = Matchups.TeamID1 LEFT JOIN Teams T2 ON T2.TeamID = Matchups.TeamID2 WHERE Matchups.MatchupID = " & thisMatchupID

	Set rsMatchup = sqlDatabase.Execute(sqlGetMatchup)

	If Not rsMatchup.Eof Then

		thisMatchupLevel = CInt(rsMatchup("MatchupLevel"))
		thisMatchupLeg = CInt(rsMatchup("Leg"))
		thisTeamPMR1 = CInt(rsMatchup("TeamPMR1"))
		thisTeamPMR2 = CInt(rsMatchup("TeamPMR2"))
		thisTeamScore1 = rsMatchup("TeamScore1")
		thisTeamScore2 = rsMatchup("TeamScore2")
		thisTeamID1 = rsMatchup("TeamID1")
		thisTeamName1 = rsMatchup("TeamName1")
		thisTeamLevel1 = rsMatchup("TeamLevel1")
		thisTeamCBSID1 = rsMatchup("TeamCBSID1")
		thisTeamID2 = rsMatchup("TeamID2")
		thisTeamName2 = rsMatchup("TeamName2")
		thisTeamLevel2 = rsMatchup("TeamLevel2")
		thisTeamCBSID2 = rsMatchup("TeamCBSID2")

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

	End If

	If thisMatchupLevel = 0 Then leagueTitle = "cup"
	If thisMatchupLevel = 1 Then leagueTitle = "omega"
	If thisMatchupLevel = 2 Then leagueTitle = "slffl"
	If thisMatchupLevel = 3 Then leagueTitle = "flffl"
	If thisMatchupLevel = 4 Then leagueTitle = "blffl"

	slackJSON = slackJSON & "{"

		slackJSON = slackJSON & """level"": """ & leagueTitle & ""","
		slackJSON = slackJSON & """teamid1"": """ & thisTeamID1 & ""","
		slackJSON = slackJSON & """teamname1"": """ & thisTeamName1 & ""","
		slackJSON = slackJSON & """teamscore1"": """ & FormatNumber(thisTeamScore1, 2) & ""","
		slackJSON = slackJSON & """teampmr1"": """ & thisTeamPMR1 & ""","
		slackJSON = slackJSON & """teampmrpercent1"": """ & thisTeamPMRPercent1 & ""","
		slackJSON = slackJSON & """teampmrcolor1"": """ & thisTeamPMRColor1 & ""","
		slackJSON = slackJSON & """teamid2"": """ & thisTeamID2 & ""","
		slackJSON = slackJSON & """teamname2"": """ & thisTeamName2 & ""","
		slackJSON = slackJSON & """teamscore2"": """ & FormatNumber(thisTeamScore2, 2) & ""","
		slackJSON = slackJSON & """teampmr2"": """ & thisTeamPMR2 & ""","
		slackJSON = slackJSON & """teampmrpercent2"": """ & thisTeamPMRPercent2 & ""","
		slackJSON = slackJSON & """teampmrcolor2"": """ & thisTeamPMRColor2 & """"

	slackJSON = slackJSON & "}"

	Response.Write(slackJSON)
%>
