<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp"-->
<!--#include virtual="/assets/asp/framework/session.asp"-->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	Response.ContentType = "application/json"

	leagueTitle = Request.QueryString("league")
	teamID = Request.QueryString("id")
	BaseScore = 0

	If leagueTitle = "CUP" Then

		Leg = Request.QueryString("leg")
		BaseScore = 0
		If CInt(Leg) = 2 Then

			sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & teamID & " OR TeamID2 = " & teamID & ") AND LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") - 1
			Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

			If CInt(rsLastWeek("TeamID1")) = CInt(teamID) Then BaseScore = rsLastWeek("TeamScore1")

			If CInt(rsLastWeek("TeamID2")) = CInt(teamID) Then BaseScore = rsLastWeek("TeamScore2")


		End If

		If CInt(Leg) = 3 Then

			sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & teamID & " OR TeamID2 = " & teamID & ") AND LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period >= " & Session.Contents("CurrentPeriod") - 2 & " AND Period <= " & Session.Contents("CurrentPeriod") - 1
			Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

			Do While Not rsLastWeek.Eof
				If CInt(rsLastWeek("TeamID1")) = CInt(teamID) Then BaseScore = BaseScore + rsLastWeek("TeamScore1")
				If CInt(rsLastWeek("TeamID2")) = CInt(teamID) Then BaseScore = BaseScore + rsLastWeek("TeamScore2")
				rsLastWeek.MoveNext
			Loop
			rsLastWeek.Close
			Set rsLastWeek = Nothing


		End If

	End If

	sqlGetLeague = "SELECT LevelID, CBSID FROM Teams WHERE TeamID = " & teamID
	Set rsLeague = sqlDatabase.Execute(sqlGetLeague)

	thisLevelID = CInt(rsLeague("LevelID"))
	thisCBSID = rsLeague("CBSID")

	If thisLevelID = 2 Then leagueTitle = "SLFFL"
	If thisLevelID = 3 Then leagueTitle = "FLFFL"
	If thisLevelID = 4 Then leagueTitle = "BLFFL"

	rsLeague.Close
	Set rsLeague = Nothing

	Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
	oXML.loadXML(GetScores(leagueTitle, Session.Contents("CurrentPeriod")))

	oXML.setProperty "SelectionLanguage", "XPath"
	Set objTeam = oXML.selectSingleNode(".//team[@id = " & thisCBSID & "]")

	Set objTeamName = objTeam.getElementsByTagName("name")
	Set objTeamScore = objTeam.getElementsByTagName("pts")
	Set objTeamPMR = objTeam.getElementsByTagName("pmr")

	TeamName1 = objTeamName.item(0).text
	TeamScore1 = CDbl(objTeamScore.item(0).text) + BaseScore
	TeamPMR1 = CInt(objTeamPMR.item(0).text)

	TeamPMRColor1 = "success"
	If TeamPMR1 < 321 Then TeamPMRColor1 = "warning"
	If TeamPMR1 < 161 Then TeamPMRColor1 = "danger"
	TeamPMRPercent1 = (TeamPMR1 * 100) / 420

	If CInt(teamID) = 38 Then TeamName1 = "München on Bündchen"

	slackJSON = slackJSON & "{"

		slackJSON = slackJSON & """teamid"": """ & teamID & ""","
		slackJSON = slackJSON & """teamname"": """ & TeamName1 & ""","
		slackJSON = slackJSON & """teamscore"": """ & FormatNumber(TeamScore1, 2) & ""","
		slackJSON = slackJSON & """teampmr"": """ & TeamPMR1 & ""","
		slackJSON = slackJSON & """teampmrpercent"": """ & TeamPMRPercent1 & ""","
		slackJSON = slackJSON & """teampmrcolor"": """ & TeamPMRColor1 & """"

	slackJSON = slackJSON & "}"

	Response.Write(slackJSON)
%>
