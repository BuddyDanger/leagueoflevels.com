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

Function GetScores (League)

	If UCase(League) = "OMEGA" Then
		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=omegalevel&access_token=" & GetToken("OMEGA")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "SLFFL" Then
		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "FLFFL" Then

		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=farmlevel&access_token=" & GetToken("FARM")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""

	End If

	GetScores = xmlhttpSLFFL.ResponseText

End Function

Function GetProjections (League, CBSID)

	If UCase(League) = "OMEGA" Then
		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/preview?version=3.0&response_format=xml&team_id=" & CBSID & "&league_id=omegalevel&access_token=" & GetToken("OMEGA")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "SLFFL" Then
		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/preview?version=3.0&response_format=xml&team_id=" & CBSID & "&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "FLFFL" Then

		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/preview?version=3.0&response_format=xml&team_id=" & CBSID & "&league_id=farmlevel&access_token=" & GetToken("FARM")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""

	End If

	GetProjections = xmlhttpSLFFL.ResponseText

End Function

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

thisYear = 2020
thisPeriod = 1

Set sqlDatabase = CreateObject("ADODB.Connection")
sqlDatabase.CursorLocation = adUseServer
sqlDatabase.Open "Driver={SQL Server Native Client 11.0};Server=tcp:samelevel.database.windows.net,1433;Database=NextLevelDB;Uid=samelevel;Pwd=TheHammer123;Encrypt=yes;Connection Timeout=60;"

sqlGetMatchups = "SELECT MatchupID, LevelID, TeamID1, TeamID2 FROM [dbo].[Matchups] WHERE Year = " & thisYear & " AND Period = " & thisPeriod & " AND LevelID = 1; SELECT MatchupID, LevelID, TeamID1, TeamID2 FROM [dbo].[Matchups] WHERE Year = " & thisYear & " AND Period = " & thisPeriod & " AND LevelID = 0; SELECT MatchupID, LevelID, TeamID1, TeamID2 FROM [dbo].[Matchups] WHERE Year = " & thisYear & " AND Period = " & thisPeriod & " AND LevelID = 2; SELECT MatchupID, LevelID, TeamID1, TeamID2 FROM [dbo].[Matchups] WHERE Year = " & thisYear & " AND Period = " & thisPeriod & " AND LevelID = 3;"
Set rsMatchups = sqlDatabase.Execute(sqlGetMatchups)

arrOmega = rsMatchups.GetRows()
Set rsMatchups = rsMatchups.NextRecordset()
arrCup = rsMatchups.GetRows()
Set rsMatchups = rsMatchups.NextRecordset()
arrSLFFL = rsMatchups.GetRows()
Set rsMatchups = rsMatchups.NextRecordset()
arrFLFFL = rsMatchups.GetRows()

rsMatchups.Close
Set rsMatchups = Nothing

Set oXMLOmega = CreateObject("MSXML2.DOMDocument.3.0")
oXMLOmega.loadXML(GetScores("OMEGA"))
oXMLOmega.setProperty "SelectionLanguage", "XPath"

Set oXMLSLFFL = CreateObject("MSXML2.DOMDocument.3.0")
oXMLSLFFL.loadXML(GetScores("SLFFL"))
oXMLSLFFL.setProperty "SelectionLanguage", "XPath"

Set oXMLFLFFL = CreateObject("MSXML2.DOMDocument.3.0")
oXMLFLFFL.loadXML(GetScores("FLFFL"))
oXMLFLFFL.setProperty "SelectionLanguage", "XPath"

WScript.Echo(vbcrlf & "Matchups Loaded...")

For i = 0 To UBound(arrCup, 2)

	MatchupID = arrCup(0, i)
	TeamID1 = arrCup(2, i)
	TeamID2 = arrCup(3, i)

	TeamProjectedScore1 = 0
	TeamProjectedScore2 = 0
	TeamSpread1Display = ""
	TeamSpread2Display = ""
	TeamScore1 = 0
	TeamScore2 = 0
	TeamWinPercentage1 = 0
	TeamWinPercentage2 = 0

	sqlGetTeams = "SELECT TeamName, LevelID, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID1 & " AND LevelID <> 1;SELECT TeamName, LevelID, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID2 & " AND LevelID <> 1;"
	Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

	TeamCBSID1 = rsTeams("CBSID")
	TeamName1 = rsTeams("TeamName")
	TeamLevelID1 = rsTeams("LevelID")
	Set rsTeams = rsTeams.NextRecordset()
	TeamCBSID2 = rsTeams("CBSID")
	TeamName2 = rsTeams("TeamName")
	TeamLevelID2 = rsTeams("LevelID")

	rsTeams.Close
	Set rsTeams = Nothing

	If CInt(TeamLevelID1) = 2 Then
		Set objTeam1 = oXMLSLFFL.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")
		TeamLevelName1 = "SLFFL"
	End If

	If CInt(TeamLevelID1) = 3 Then
		Set objTeam1 = oXMLFLFFL.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")
		TeamLevelName1 = "FLFFL"
	End If

	If CInt(TeamLevelID2) = 2 Then
		Set objTeam2 = oXMLSLFFL.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")
		TeamLevelName2 = "SLFFL"
	End If

	If CInt(TeamLevelID2) = 3 Then
		Set objTeam2 = oXMLFLFFL.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")
		TeamLevelName2 = "FLFFL"
	End If

	Set objTeamScore1 = objTeam1.getElementsByTagName("pts")
	Set objTeamPMR1 = objTeam1.getElementsByTagName("pmr")

	Set objTeamScore2 = objTeam2.getElementsByTagName("pts")
	Set objTeamPMR2 = objTeam2.getElementsByTagName("pmr")

	TeamScore1 = CDbl(objTeamScore1.item(0).text)
	TeamPMR1 = CInt(objTeamPMR1.item(0).text)

	TeamScore2 = CDbl(objTeamScore2.item(0).text)
	TeamPMR2 = CInt(objTeamPMR2.item(0).text)

	Set projectionsXML1 = CreateObject("MSXML2.DOMDocument.3.0")
	projectionsXML1.loadXML(GetProjections(TeamLevelName1, TeamCBSID1))
	projectionsXML1.setProperty "SelectionLanguage", "XPath"
	Set projectionsTeam1 = projectionsXML1.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]/points")

	Set projectionsXML2 = CreateObject("MSXML2.DOMDocument.3.0")
	projectionsXML2.loadXML(GetProjections(TeamLevelName2, TeamCBSID2))
	projectionsXML2.setProperty "SelectionLanguage", "XPath"
	Set projectionsTeam2 = projectionsXML2.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]/points")

	TeamProjectedScore1 = projectionsTeam1.text
	TeamProjectedScore2 = projectionsTeam2.text

	TeamSpread1 = TeamProjectedScore2 - TeamProjectedScore1
	TeamSpread2 = TeamProjectedScore1 - TeamProjectedScore2

	MatchupWinPercentage = CalculateWinPercentage(TeamPMR1, TeamPMR2, TeamProjectedScore1, TeamProjectedScore2, TeamScore1, TeamScore2)
	arrWinPercentages = Split(MatchupWinPercentage, "/")

	TeamWinPercentage1Display = arrWinPercentages(0)
	TeamWinPercentage2Display = arrWinPercentages(1)

	TeamWinPercentageInt1 = CInt(Replace(TeamWinPercentage1Display, "%", ""))
	TeamWinPercentageInt2 = CInt(Replace(TeamWinPercentage2Display, "%", ""))

	TeamWinPercentage1 = TeamWinPercentageInt1 * 0.01
	TeamWinPercentage2 = TeamWinPercentageInt2 * 0.01

	largerPercentage = TeamWinPercentage1
	smallerPercentage = TeamWinPercentage2
	If TeamWinPercentageInt1 < TeamWinPercentageInt2 Then
		largerPercentage = TeamWinPercentage2
		smallerPercentage = TeamWinPercentage1
	End If

	TeamWinPercentage1 = largerPercentage
	TeamWinPercentage2 = smallerPercentage
	If CInt(TeamProjectedScore1) < CInt(TeamProjectedScore2) Then
		TeamWinPercentage2 = largerPercentage
		TeamWinPercentage1 = smallerPercentage
	End If

	WScript.Echo(MatchupWinPercentage)

	sqlGetMoneylines = "SELECT TOP 1 Moneyline FROM Moneylines WHERE Percentage >= " & TeamWinPercentage1 & " ORDER BY Percentage ASC; SELECT TOP 1 Moneyline FROM Moneylines WHERE Percentage >= " & TeamWinPercentage2 & " ORDER BY Percentage ASC;"
	Set rsMoneylines = sqlDatabase.Execute(sqlGetMoneylines)

	TeamMoneyline1 = rsMoneylines("Moneyline")
	Set rsMoneylines = rsMoneylines.NextRecordset()
	TeamMoneyline2 = rsMoneylines("Moneyline")

	rsMoneylines.Close
	Set rsMoneylines = Nothing

	TeamMoneyline1Display = TeamMoneyline1
	If CInt(TeamMoneyline1) > 0 Then TeamMoneyline1Display = "+" & TeamMoneyline1Display

	TeamMoneyline2Display = TeamMoneyline2
	If CInt(TeamMoneyline2) > 0 Then TeamMoneyline2Display = "+" & TeamMoneyline2Display

	TeamSpread1Display = TeamSpread1
	If TeamSpread1 > 0 Then TeamSpread1Display = "+" & TeamSpread1Display

	TeamSpread2Display = TeamSpread2
	If TeamSpread2 > 0 Then TeamSpread2Display = "+" & TeamSpread2Display

	'CalculateWinPercentage(TeamPMR1, TeamPMR2, TeamProjectedScore1, TeamProjectedScore2, TeamScore1, TeamScore2)'
	WScript.Echo(vbcrlf & vbcrlf & "MATCHUP #" & MatchupID & " (CUP) ----------")
	WScript.Echo(vbcrlf & TeamName1 & " (" & TeamProjectedScore1 & " Proj, " & TeamSpread1Display & " Spread, " & TeamWinPercentage1 * 100 & "% Win, " & TeamMoneyline1Display & " ML)")
	WScript.Echo(vbcrlf & TeamName2 & " (" & TeamProjectedScore2 & " Proj, " & TeamSpread2Display & " Spread, " & TeamWinPercentage2 * 100 & "% Win, " & TeamMoneyline2Display & " ML)")

	sqlUpdate = "UPDATE Matchups SET TeamScore1 = " & TeamScore1 & ", TeamScore2 = " & TeamScore2 & ", TeamPMR1 = " & TeamPMR1 & ", TeamPMR2 = " & TeamPMR2 & ", TeamProjected1 = " &  TeamProjectedScore1 & ", TeamProjected2 = " &  TeamProjectedScore2 & ", TeamWinPercentage1 = " &  TeamWinPercentage1 & ", TeamWinPercentage2 = " &  TeamWinPercentage2 & ", TeamMoneyline1 = " &  TeamMoneyline1 & ", TeamMoneyline2 = " &  TeamMoneyline2 & ", TeamSpread1 = " &  TeamSpread1 & ", TeamSpread2 = " &  TeamSpread2 & "  WHERE MatchupID = " & MatchupID
	Set rsUpdate = sqlDatabase.Execute(sqlUpdate)

Next

For i = 0 To UBound(arrOmega, 2)

	MatchupID = arrOmega(0, i)
	TeamID1 = arrOmega(2, i)
	TeamID2 = arrOmega(3, i)

	TeamProjectedScore1 = 0
	TeamProjectedScore2 = 0
	TeamSpread1Display = ""
	TeamSpread2Display = ""
	TeamScore1 = 0
	TeamScore2 = 0
	TeamWinPercentage1 = 0
	TeamWinPercentage2 = 0

	sqlGetTeams = "SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID1 & " AND LevelID = 1;SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID2 & " AND LevelID = 1;"
	Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

	TeamCBSID1 = rsTeams("CBSID")
	TeamName1 = rsTeams("TeamName")
	Set rsTeams = rsTeams.NextRecordset()
	TeamCBSID2 = rsTeams("CBSID")
	TeamName2 = rsTeams("TeamName")

	rsTeams.Close
	Set rsTeams = Nothing

	Set objTeam1 = oXMLOmega.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")
	Set objTeam2 = oXMLOmega.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")

	Set objTeamScore1 = objTeam1.getElementsByTagName("pts")
	Set objTeamPMR1 = objTeam1.getElementsByTagName("pmr")

	Set objTeamScore2 = objTeam2.getElementsByTagName("pts")
	Set objTeamPMR2 = objTeam2.getElementsByTagName("pmr")

	TeamScore1 = CDbl(objTeamScore1.item(0).text)
	TeamPMR1 = CInt(objTeamPMR1.item(0).text)

	TeamScore2 = CDbl(objTeamScore2.item(0).text)
	TeamPMR2 = CInt(objTeamPMR2.item(0).text)

	Set projectionsXML1 = CreateObject("MSXML2.DOMDocument.3.0")
	projectionsXML1.loadXML(GetProjections("OMEGA", TeamCBSID1))
	projectionsXML1.setProperty "SelectionLanguage", "XPath"
	Set projectionsTeam1 = projectionsXML1.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]/points")

	Set projectionsXML2 = CreateObject("MSXML2.DOMDocument.3.0")
	projectionsXML2.loadXML(GetProjections("OMEGA", TeamCBSID2))
	projectionsXML2.setProperty "SelectionLanguage", "XPath"
	Set projectionsTeam2 = projectionsXML2.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]/points")

	TeamProjectedScore1 = projectionsTeam1.text
	TeamProjectedScore2 = projectionsTeam2.text

	TeamSpread1 = TeamProjectedScore2 - TeamProjectedScore1
	TeamSpread2 = TeamProjectedScore1 - TeamProjectedScore2

	MatchupWinPercentage = CalculateWinPercentage(TeamPMR1, TeamPMR2, TeamProjectedScore1, TeamProjectedScore2, TeamScore1, TeamScore2)
	arrWinPercentages = Split(MatchupWinPercentage, "/")

	TeamWinPercentage1Display = arrWinPercentages(0)
	TeamWinPercentage2Display = arrWinPercentages(1)

	TeamWinPercentageInt1 = CInt(Replace(TeamWinPercentage1Display, "%", ""))
	TeamWinPercentageInt2 = CInt(Replace(TeamWinPercentage2Display, "%", ""))

	TeamWinPercentage1 = TeamWinPercentageInt1 * 0.01
	TeamWinPercentage2 = TeamWinPercentageInt2 * 0.01

	largerPercentage = TeamWinPercentage1
	smallerPercentage = TeamWinPercentage2
	If TeamWinPercentageInt1 < TeamWinPercentageInt2 Then
		largerPercentage = TeamWinPercentage2
		smallerPercentage = TeamWinPercentage1
	End If

	TeamWinPercentage1 = largerPercentage
	TeamWinPercentage2 = smallerPercentage
	If CInt(TeamProjectedScore1) < CInt(TeamProjectedScore2) Then
		TeamWinPercentage2 = largerPercentage
		TeamWinPercentage1 = smallerPercentage
	End If

	sqlGetMoneylines = "SELECT TOP 1 Moneyline FROM Moneylines WHERE Percentage >= " & TeamWinPercentage1 & " ORDER BY Percentage ASC; SELECT TOP 1 Moneyline FROM Moneylines WHERE Percentage >= " & TeamWinPercentage2 & " ORDER BY Percentage ASC;"
	Set rsMoneylines = sqlDatabase.Execute(sqlGetMoneylines)

	TeamMoneyline1 = rsMoneylines("Moneyline")
	Set rsMoneylines = rsMoneylines.NextRecordset()
	TeamMoneyline2 = rsMoneylines("Moneyline")

	rsMoneylines.Close
	Set rsMoneylines = Nothing

	TeamMoneyline1Display = TeamMoneyline1
	If CInt(TeamMoneyline1) > 0 Then TeamMoneyline1Display = "+" & TeamMoneyline1Display

	TeamMoneyline2Display = TeamMoneyline2
	If CInt(TeamMoneyline2) > 0 Then TeamMoneyline2Display = "+" & TeamMoneyline2Display

	TeamSpread1Display = TeamSpread1
	If TeamSpread1 > 0 Then TeamSpread1Display = "+" & TeamSpread1Display

	TeamSpread2Display = TeamSpread2
	If TeamSpread2 > 0 Then TeamSpread2Display = "+" & TeamSpread2Display

	'CalculateWinPercentage(TeamPMR1, TeamPMR2, TeamProjectedScore1, TeamProjectedScore2, TeamScore1, TeamScore2)'
	WScript.Echo(vbcrlf & vbcrlf & "MATCHUP #" & MatchupID & " (OMEGA) ----------")
	WScript.Echo(vbcrlf & TeamName1 & " (" & TeamProjectedScore1 & " Proj, " & TeamSpread1Display & " Spread, " & TeamWinPercentage1 * 100 & "% Win, " & TeamMoneyline1Display & " ML)")
	WScript.Echo(vbcrlf & TeamName2 & " (" & TeamProjectedScore2 & " Proj, " & TeamSpread2Display & " Spread, " & TeamWinPercentage2 * 100 & "% Win, " & TeamMoneyline2Display & " ML)")

	sqlUpdate = "UPDATE Matchups SET TeamScore1 = " & TeamScore1 & ", TeamScore2 = " & TeamScore2 & ", TeamPMR1 = " & TeamPMR1 & ", TeamPMR2 = " & TeamPMR2 & ", TeamProjected1 = " &  TeamProjectedScore1 & ", TeamProjected2 = " &  TeamProjectedScore2 & ", TeamWinPercentage1 = " &  TeamWinPercentage1 & ", TeamWinPercentage2 = " &  TeamWinPercentage2 & ", TeamMoneyline1 = " &  TeamMoneyline1 & ", TeamMoneyline2 = " &  TeamMoneyline2 & ", TeamSpread1 = " &  TeamSpread1 & ", TeamSpread2 = " &  TeamSpread2 & "  WHERE MatchupID = " & MatchupID
	Set rsUpdate = sqlDatabase.Execute(sqlUpdate)

Next


For i = 0 To UBound(arrSLFFL, 2)

	MatchupID = arrSLFFL(0, i)
	TeamID1 = arrSLFFL(2, i)
	TeamID2 = arrSLFFL(3, i)

	TeamProjectedScore1 = 0
	TeamProjectedScore2 = 0
	TeamSpread1Display = ""
	TeamSpread2Display = ""
	TeamScore1 = 0
	TeamScore2 = 0
	TeamWinPercentage1 = 0
	TeamWinPercentage2 = 0

	sqlGetTeams = "SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID1 & " AND LevelID = 2;SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID2 & " AND LevelID = 2;"
	Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

	TeamCBSID1 = rsTeams("CBSID")
	TeamName1 = rsTeams("TeamName")
	Set rsTeams = rsTeams.NextRecordset()
	TeamCBSID2 = rsTeams("CBSID")
	TeamName2 = rsTeams("TeamName")

	rsTeams.Close
	Set rsTeams = Nothing

	Set objTeam1 = oXMLSLFFL.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")
	Set objTeam2 = oXMLSLFFL.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")

	Set objTeamScore1 = objTeam1.getElementsByTagName("pts")
	Set objTeamPMR1 = objTeam1.getElementsByTagName("pmr")

	Set objTeamScore2 = objTeam2.getElementsByTagName("pts")
	Set objTeamPMR2 = objTeam2.getElementsByTagName("pmr")

	TeamScore1 = CDbl(objTeamScore1.item(0).text)
	TeamPMR1 = CInt(objTeamPMR1.item(0).text)

	TeamScore2 = CDbl(objTeamScore2.item(0).text)
	TeamPMR2 = CInt(objTeamPMR2.item(0).text)

	Set projectionsXML1 = CreateObject("MSXML2.DOMDocument.3.0")
	projectionsXML1.loadXML(GetProjections("SLFFL", TeamCBSID1))
	projectionsXML1.setProperty "SelectionLanguage", "XPath"
	Set projectionsTeam1 = projectionsXML1.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]/points")

	Set projectionsXML2 = CreateObject("MSXML2.DOMDocument.3.0")
	projectionsXML2.loadXML(GetProjections("SLFFL", TeamCBSID2))
	projectionsXML2.setProperty "SelectionLanguage", "XPath"
	Set projectionsTeam2 = projectionsXML2.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]/points")

	TeamProjectedScore1 = projectionsTeam1.text
	TeamProjectedScore2 = projectionsTeam2.text

	TeamSpread1 = TeamProjectedScore2 - TeamProjectedScore1
	TeamSpread2 = TeamProjectedScore1 - TeamProjectedScore2

	MatchupWinPercentage = CalculateWinPercentage(TeamPMR1, TeamPMR2, TeamProjectedScore1, TeamProjectedScore2, TeamScore1, TeamScore2)
	arrWinPercentages = Split(MatchupWinPercentage, "/")

	TeamWinPercentage1Display = arrWinPercentages(0)
	TeamWinPercentage2Display = arrWinPercentages(1)

	TeamWinPercentageInt1 = CInt(Replace(TeamWinPercentage1Display, "%", ""))
	TeamWinPercentageInt2 = CInt(Replace(TeamWinPercentage2Display, "%", ""))

	TeamWinPercentage1 = TeamWinPercentageInt1 * 0.01
	TeamWinPercentage2 = TeamWinPercentageInt2 * 0.01

	largerPercentage = TeamWinPercentage1
	smallerPercentage = TeamWinPercentage2
	If TeamWinPercentageInt1 < TeamWinPercentageInt2 Then
		largerPercentage = TeamWinPercentage2
		smallerPercentage = TeamWinPercentage1
	End If

	TeamWinPercentage1 = largerPercentage
	TeamWinPercentage2 = smallerPercentage
	If CInt(TeamProjectedScore1) < CInt(TeamProjectedScore2) Then
		TeamWinPercentage2 = largerPercentage
		TeamWinPercentage1 = smallerPercentage
	End If

	sqlGetMoneylines = "SELECT TOP 1 Moneyline FROM Moneylines WHERE Percentage >= " & TeamWinPercentage1 & " ORDER BY Percentage ASC; SELECT TOP 1 Moneyline FROM Moneylines WHERE Percentage >= " & TeamWinPercentage2 & " ORDER BY Percentage ASC;"
	Set rsMoneylines = sqlDatabase.Execute(sqlGetMoneylines)

	TeamMoneyline1 = rsMoneylines("Moneyline")
	Set rsMoneylines = rsMoneylines.NextRecordset()
	TeamMoneyline2 = rsMoneylines("Moneyline")

	rsMoneylines.Close
	Set rsMoneylines = Nothing

	TeamMoneyline1Display = TeamMoneyline1
	If CInt(TeamMoneyline1) > 0 Then TeamMoneyline1Display = "+" & TeamMoneyline1Display

	TeamMoneyline2Display = TeamMoneyline2
	If CInt(TeamMoneyline2) > 0 Then TeamMoneyline2Display = "+" & TeamMoneyline2Display

	TeamSpread1Display = TeamSpread1
	If TeamSpread1 > 0 Then TeamSpread1Display = "+" & TeamSpread1Display

	TeamSpread2Display = TeamSpread2
	If TeamSpread2 > 0 Then TeamSpread2Display = "+" & TeamSpread2Display

	'CalculateWinPercentage(TeamPMR1, TeamPMR2, TeamProjectedScore1, TeamProjectedScore2, TeamScore1, TeamScore2)'
	WScript.Echo(vbcrlf & vbcrlf & "MATCHUP #" & MatchupID & " (SLFFL) ----------")
	WScript.Echo(vbcrlf & TeamName1 & " (" & TeamProjectedScore1 & " Proj, " & TeamSpread1Display & " Spread, " & TeamWinPercentage1 * 100 & "% Win, " & TeamMoneyline1Display & " ML)")
	WScript.Echo(vbcrlf & TeamName2 & " (" & TeamProjectedScore2 & " Proj, " & TeamSpread2Display & " Spread, " & TeamWinPercentage2 * 100 & "% Win, " & TeamMoneyline2Display & " ML)")

	sqlUpdate = "UPDATE Matchups SET TeamScore1 = " & TeamScore1 & ", TeamScore2 = " & TeamScore2 & ", TeamPMR1 = " & TeamPMR1 & ", TeamPMR2 = " & TeamPMR2 & ", TeamProjected1 = " &  TeamProjectedScore1 & ", TeamProjected2 = " &  TeamProjectedScore2 & ", TeamWinPercentage1 = " &  TeamWinPercentage1 & ", TeamWinPercentage2 = " &  TeamWinPercentage2 & ", TeamMoneyline1 = " &  TeamMoneyline1 & ", TeamMoneyline2 = " &  TeamMoneyline2 & ", TeamSpread1 = " &  TeamSpread1 & ", TeamSpread2 = " &  TeamSpread2 & "  WHERE MatchupID = " & MatchupID
	Set rsUpdate = sqlDatabase.Execute(sqlUpdate)

Next

For i = 0 To UBound(arrFLFFL, 2)

	MatchupID = arrFLFFL(0, i)
	TeamID1 = arrFLFFL(2, i)
	TeamID2 = arrFLFFL(3, i)

	TeamProjectedScore1 = 0
	TeamProjectedScore2 = 0
	TeamSpread1Display = ""
	TeamSpread2Display = ""
	TeamScore1 = 0
	TeamScore2 = 0
	TeamWinPercentage1 = 0
	TeamWinPercentage2 = 0

	sqlGetTeams = "SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID1 & " AND LevelID = 3; SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID2 & " AND LevelID = 3;"
	Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

	TeamCBSID1 = rsTeams("CBSID")
	TeamName1 = rsTeams("TeamName")
	Set rsTeams = rsTeams.NextRecordset()
	TeamCBSID2 = rsTeams("CBSID")
	TeamName2 = rsTeams("TeamName")

	rsTeams.Close
	Set rsTeams = Nothing

	Set objTeam1 = oXMLFLFFL.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")
	Set objTeam2 = oXMLFLFFL.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")

	Set objTeamScore1 = objTeam1.getElementsByTagName("pts")
	Set objTeamPMR1 = objTeam1.getElementsByTagName("pmr")

	Set objTeamScore2 = objTeam2.getElementsByTagName("pts")
	Set objTeamPMR2 = objTeam2.getElementsByTagName("pmr")

	TeamScore1 = CDbl(objTeamScore1.item(0).text)
	TeamPMR1 = CInt(objTeamPMR1.item(0).text)

	TeamScore2 = CDbl(objTeamScore2.item(0).text)
	TeamPMR2 = CInt(objTeamPMR2.item(0).text)

	Set projectionsXML1 = CreateObject("MSXML2.DOMDocument.3.0")
	projectionsXML1.loadXML(GetProjections("FLFFL", TeamCBSID1))
	projectionsXML1.setProperty "SelectionLanguage", "XPath"
	Set projectionsTeam1 = projectionsXML1.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]/points")

	Set projectionsXML2 = CreateObject("MSXML2.DOMDocument.3.0")
	projectionsXML2.loadXML(GetProjections("FLFFL", TeamCBSID2))
	projectionsXML2.setProperty "SelectionLanguage", "XPath"
	Set projectionsTeam2 = projectionsXML2.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]/points")

	TeamProjectedScore1 = projectionsTeam1.text
	TeamProjectedScore2 = projectionsTeam2.text

	TeamSpread1 = TeamProjectedScore2 - TeamProjectedScore1
	TeamSpread2 = TeamProjectedScore1 - TeamProjectedScore2

	MatchupWinPercentage = CalculateWinPercentage(TeamPMR1, TeamPMR2, TeamProjectedScore1, TeamProjectedScore2, TeamScore1, TeamScore2)
	arrWinPercentages = Split(MatchupWinPercentage, "/")

	TeamWinPercentage1Display = arrWinPercentages(0)
	TeamWinPercentage2Display = arrWinPercentages(1)

	TeamWinPercentageInt1 = CInt(Replace(TeamWinPercentage1Display, "%", ""))
	TeamWinPercentageInt2 = CInt(Replace(TeamWinPercentage2Display, "%", ""))

	TeamWinPercentage1 = TeamWinPercentageInt1 * 0.01
	TeamWinPercentage2 = TeamWinPercentageInt2 * 0.01

	largerPercentage = TeamWinPercentage1
	smallerPercentage = TeamWinPercentage2
	If TeamWinPercentageInt1 < TeamWinPercentageInt2 Then
		largerPercentage = TeamWinPercentage2
		smallerPercentage = TeamWinPercentage1
	End If

	TeamWinPercentage1 = largerPercentage
	TeamWinPercentage2 = smallerPercentage
	If CInt(TeamProjectedScore1) < CInt(TeamProjectedScore2) Then
		TeamWinPercentage2 = largerPercentage
		TeamWinPercentage1 = smallerPercentage
	End If

	sqlGetMoneylines = "SELECT TOP 1 Moneyline FROM Moneylines WHERE Percentage >= " & TeamWinPercentage1 & " ORDER BY Percentage ASC; SELECT TOP 1 Moneyline FROM Moneylines WHERE Percentage >= " & TeamWinPercentage2 & " ORDER BY Percentage ASC;"
	Set rsMoneylines = sqlDatabase.Execute(sqlGetMoneylines)

	TeamMoneyline1 = rsMoneylines("Moneyline")
	Set rsMoneylines = rsMoneylines.NextRecordset()
	TeamMoneyline2 = rsMoneylines("Moneyline")

	rsMoneylines.Close
	Set rsMoneylines = Nothing

	TeamMoneyline1Display = TeamMoneyline1
	If CInt(TeamMoneyline1) > 0 Then TeamMoneyline1Display = "+" & TeamMoneyline1Display

	TeamMoneyline2Display = TeamMoneyline2
	If CInt(TeamMoneyline2) > 0 Then TeamMoneyline2Display = "+" & TeamMoneyline2Display

	TeamSpread1Display = TeamSpread1
	If TeamSpread1 > 0 Then TeamSpread1Display = "+" & TeamSpread1Display

	TeamSpread2Display = TeamSpread2
	If TeamSpread2 > 0 Then TeamSpread2Display = "+" & TeamSpread2Display

	'CalculateWinPercentage(TeamPMR1, TeamPMR2, TeamProjectedScore1, TeamProjectedScore2, TeamScore1, TeamScore2)'
	WScript.Echo(vbcrlf & vbcrlf & "MATCHUP #" & MatchupID & " (FLFFL) ----------")
	WScript.Echo(vbcrlf & TeamName1 & " (" & TeamProjectedScore1 & " Proj, " & TeamSpread1Display & " Spread, " & TeamWinPercentage1 * 100 & "% Win, " & TeamMoneyline1Display & " ML)")
	WScript.Echo(vbcrlf & TeamName2 & " (" & TeamProjectedScore2 & " Proj, " & TeamSpread2Display & " Spread, " & TeamWinPercentage2 * 100 & "% Win, " & TeamMoneyline2Display & " ML)")

	sqlUpdate = "UPDATE Matchups SET TeamScore1 = " & TeamScore1 & ", TeamScore2 = " & TeamScore2 & ", TeamPMR1 = " & TeamPMR1 & ", TeamPMR2 = " & TeamPMR2 & ", TeamProjected1 = " &  TeamProjectedScore1 & ", TeamProjected2 = " &  TeamProjectedScore2 & ", TeamWinPercentage1 = " &  TeamWinPercentage1 & ", TeamWinPercentage2 = " &  TeamWinPercentage2 & ", TeamMoneyline1 = " &  TeamMoneyline1 & ", TeamMoneyline2 = " &  TeamMoneyline2 & ", TeamSpread1 = " &  TeamSpread1 & ", TeamSpread2 = " &  TeamSpread2 & "  WHERE MatchupID = " & MatchupID
	Set rsUpdate = sqlDatabase.Execute(sqlUpdate)

Next

EndTime = Now()

WScript.Echo(vbcrlf & StartTime)
WScript.Echo(vbcrlf & EndTime)
