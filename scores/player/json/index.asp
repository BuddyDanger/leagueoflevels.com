<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp"-->
<!--#include virtual="/assets/asp/framework/session.asp"-->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	Response.ContentType = "application/json"

	leagueTitle = Request.QueryString("league")
	thisCBSID = Request.QueryString("team")
	thisPlayerID = Request.QueryString("id")

	Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
	oXML.loadXML(GetScores(leagueTitle, Session.Contents("CurrentPeriod")))

	oXML.setProperty "SelectionLanguage", "XPath"
	Set objPlayer = oXML.selectSingleNode(".//player[@id = " & thisPlayerID & "]")

	Set objPlayerName = objPlayer.getElementsByTagName("fullname")
	thisPlayerName = objPlayerName.item(0).text

	Set objPlayerPoints = objPlayer.getElementsByTagName("fpts")
	thisPlayerPoints = objPlayerPoints.item(0).text

	Set objPlayerStatus = objPlayer.getElementsByTagName("status")
	thisPlayerStatus = objPlayerStatus.item(0).text

	Set objPlayerStats = objPlayer.getElementsByTagName("stats_period")
	thisPlayerStats = objPlayerStats.item(0).text

	Set objPlayerGameTimestamp = objPlayer.getElementsByTagName("game_start_timestamp")
	thisPlayerGameTimestamp = objPlayerGameTimestamp.item(0).text

	Set objPlayerPMR = objPlayer.getElementsByTagName("minutes_remaining")
	thisPlayerPMR = CInt(objPlayerPMR.item(0).text)

	Set objPlayerHomeGame = objPlayer.getElementsByTagName("home_game")
	thisPlayerHomeGame = CInt(objPlayerHomeGame.item(0).text)

	Set objPlayerProTeam = objPlayer.getElementsByTagName("pro_team")
	thisPlayerProTeam = objPlayerProTeam.item(0).text

	Set objPlayerPosition = objPlayer.getElementsByTagName("position")
	thisPlayerPosition = objPlayerPosition.item(0).text

	Set objPlayerOpponent = objPlayer.getElementsByTagName("opponent")
	thisPlayerOpponent = objPlayerOpponent.item(0).text

	Set objPlayerQuarter = objPlayer.getElementsByTagName("quarter")
	thisPlayerQuarter = objPlayerQuarter.item(0).text

	Set objPlayerQuarterTimeRemaining = objPlayer.getElementsByTagName("time_remaining")
	thisPlayerQuarterTimeRemaining = objPlayerQuarterTimeRemaining.item(0).text

	If thisPlayerHomeGame = 1 Then
		thisGameLine = thisPlayerProTeam & " vs. " & thisPlayerOpponent
	Else
		thisGameLine = thisPlayerProTeam & " @ " & thisPlayerOpponent
	End If

	thisPlayerGameTimestamp = DateAdd("s", thisPlayerGameTimestamp, DateSerial(1970,1,1))
	thisPlayerGameTimestamp = DateAdd("h", -5, thisPlayerGameTimestamp)

	thisPlayerGameDay = UCase(WeekdayName(Weekday(thisPlayerGameTimestamp),True))
	thisPlayerHour = Hour(thisPlayerGameTimestamp)
	thisPlayerMinute = Minute(thisPlayerGameTimestamp)

	If thisPlayerHour > 12 Then
		AMPM = "PM"
		thisPlayerHour = thisPlayerHour - 12
	Else
		AMPM = "AM"
	End If

	If Len(thisPlayerMinute) = 1 Then thisPlayerMinute = "0" & thisPlayerMinute

	If CInt(thisPlayerQuarter) = 4 And thisPlayerQuarterTimeRemaining = "0:00" Then
		thisGamePosition = "FINAL"
	Else
		thisGamePosition = thisPlayerQuarter & "Q " & thisPlayerQuarterTimeRemaining
	End If

	thisPlayerPMRColor = "success"
	If thisPlayerPMR < 40 Then thisPlayerPMRColor = "warning"
	If thisPlayerPMR < 20 Then thisPlayerPMRColor = "danger"
	thisPlayerPMRPercent = (thisPlayerPMR * 100) / 60

	thisGameLine = thisGameLine & " - " & thisPlayerGameDay & "&nbsp;" & thisPlayerHour & ":" & thisPlayerMinute & AMPM

	slackJSON = slackJSON & "{"

		slackJSON = slackJSON & """points"": """ & FormatNumber(thisPlayerPoints, 2) & ""","
		slackJSON = slackJSON & """stats"": """ & thisPlayerStats & ""","
		slackJSON = slackJSON & """gameline"": """ & thisGameLine & ""","
		slackJSON = slackJSON & """gameposition"": """ & thisGamePosition & ""","
		slackJSON = slackJSON & """pmr"": """ & thisPlayerPMR & ""","
		slackJSON = slackJSON & """pmrpercent"": """ & thisPlayerPMRPercent & ""","
		slackJSON = slackJSON & """pmrcolor"": """ & thisPlayerPMRColor & """"

	slackJSON = slackJSON & "}"

	Response.Write(slackJSON)
%>
