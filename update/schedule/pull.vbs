StartTime = Now()
WScript.Echo("STARTING..." & vbcrlf)

Function GetToken (League)

	Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

	If League = "SLFFL" Then
		xmlhttpSLFFL.open "GET", "https://api.cbssports.com/general/oauth/test/access_token?user_id=naptown-&league_id=samelevel&sport=football&response_format=xml", false
	ElseIf League = "OMEGA" Then
		xmlhttpSLFFL.open "GET", "https://api.cbssports.com/general/oauth/test/access_token?user_id=naptown-&league_id=omegalevel&sport=football&response_format=xml", false
	Else
		xmlhttpSLFFL.open "GET", "https://api.cbssports.com/general/oauth/test/access_token?user_id=naptown-&league_id=farmlevel&sport=football&response_format=xml", false
	End If
	xmlhttpSLFFL.send ""

	SLFFLAccessResponse = xmlhttpSLFFL.ResponseText

	Set xmlhttpSLFFL = Nothing

	If Left(SLFFLAccessToken, 1) = " " Then SLFFLAccessToken = Right(SLFFLAccessToken, Len(SLFFLAccessToken) - 1)

	Set xmlDoc = CreateObject("Microsoft.XMLDOM")
	xmlDoc.async = False
	TokenDoc = xmlDoc.loadxml(SLFFLAccessResponse)

	Set Node =  xmlDoc.documentElement.selectSingleNode("body/access_token")
	GetToken = Node.text

End Function

Function GetSchedule (League)

	If UCase(League) = "OMEGA" Then
		liveSLFFL = "https://api.cbssports.com/fantasy/league/schedules/?version=3.0&response_format=xml&period=all&league_id=omegalevel&access_token=" & GetToken("OMEGA")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "SLFFL" Then
		liveSLFFL = "https://api.cbssports.com/fantasy/league/schedules/?version=3.0&response_format=xml&period=all&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "FLFFL" Then

		liveSLFFL = "https://api.cbssports.com/fantasy/league/schedules/?version=3.0&response_format=xml&period=all&league_id=farmlevel&access_token=" & GetToken("FARM")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""

	End If

	GetSchedule = xmlhttpSLFFL.ResponseText

End Function

Set sqlDatabase = CreateObject("ADODB.Connection")
sqlDatabase.CursorLocation = adUseServer
sqlDatabase.Open "Driver={SQL Server Native Client 11.0};Server=tcp:loldb.database.windows.net,1433;Database=leagueoflevels;Uid=commissioner;Pwd=TheHammer123;Encrypt=yes;Connection Timeout=60;"

Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
oXML.loadXML(GetSchedule("FLFFL"))

thisLevel = 3
thisYear = 2020
thisWeek = 1

Do While thisWeek < 14

	oXML.setProperty "SelectionLanguage", "XPath"
	Set objPeriod = oXML.selectSingleNode(".//period[@id=" & thisWeek & "]")
	Set objMatchups = oXML.selectSingleNode(".//period[@id=" & thisWeek & "]/matchups")

	Set objPeriodType = objPeriod.getElementsByTagName("type")
	Set objPeriodLabel = objPeriod.getElementsByTagName("label")
	Set objPeriodStart = objPeriod.getElementsByTagName("start")
	Set objPeriodEnd = objPeriod.getElementsByTagName("end")

	thisPeriodType = objPeriodType.item(0).text
	thisPeriodLabel = objPeriodLabel.item(0).text
	thisPeriodStart = objPeriodStart.item(0).text
	thisPeriodEnd = objPeriodEnd.item(0).text

	WScript.Echo(vbcrlf & thisPeriodType & " - " & thisPeriodLabel & " - " & thisPeriodStart & " - " & thisPeriodEnd)

	Set nodePeriodMatchups = objMatchups.getElementsByTagName("matchup")

	For Each objMatchup In nodePeriodMatchups

		Set objAwayTeam = objMatchup.getElementsByTagName("away_team")
		Set objHomeTeam = objMatchup.getElementsByTagName("home_team")

		objAwayTeamID = objAwayTeam(0).getAttribute("id")
		objHomeTeamID = objHomeTeam(0).getAttribute("id")

		Set objAwayTeamName = objAwayTeam(0).getElementsByTagName("name")
		Set objHomeTeamName = objHomeTeam(0).getElementsByTagName("name")

		thisAwayTeamName = objAwayTeamName.item(0).text
		thisHomeTeamName = objHomeTeamName.item(0).text

		sqlGetLOLID = "SELECT TeamID, TeamName FROM Teams WHERE CBSID = " & objAwayTeamID & " AND LevelID = " & thisLevel & " AND EndYear = 0; SELECT TeamID, TeamName FROM Teams WHERE CBSID = " & objHomeTeamID & " AND LevelID = " & thisLevel & " AND EndYear = 0;"
		Set rsLOLID = sqlDatabase.Execute(sqlGetLOLID)

		Team1LOLID = rsLOLID("TeamID")
		Team1LOLName = rsLOLID("TeamName")

		Set rsLOLID = rsLOLID.NextRecordset

		Team2LOLID = rsLOLID("TeamID")
		Team2LOLName = rsLOLID("TeamName")

		rsLOLID.Close
		Set rsLOLID = Nothing

		sqlInsertMatchup = "INSERT INTO Matchups (LevelID, Year, Period, TeamID1, TeamID2, TeamScore1, TeamScore2) VALUES (" & thisLevel & ", " & thisYear & ", " & thisWeek & ", " & Team1LOLID & ", " & Team2LOLID & ", 0, 0)"
		Set rsInsertMatchup = sqlDatabase.Execute(sqlInsertMatchup)

		WScript.Echo(vbcrlf & Team1LOLName & " (" & Team1LOLID & ") @ " & Team2LOLName & " (" & Team2LOLID & ")")

	Next

	WScript.Echo(vbcrlf)

	thisWeek = thisWeek + 1

Loop

EndTime = Now()

WScript.Echo(vbcrlf & StartTime)
WScript.Echo(vbcrlf & EndTime)
