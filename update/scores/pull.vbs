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

Function GetScores (League, thisPeriod)

	If UCase(League) = "OMEGA" Then
		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&period=" & thisPeriod & "&league_id=omegalevel&access_token=" & GetToken("OMEGA")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "SLFFL" Then
		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&period=" & thisPeriod & "&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "FLFFL" Then

		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&period=" & thisPeriod & "&league_id=farmlevel&access_token=" & GetToken("FARM")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""

	End If

	GetScores = xmlhttpSLFFL.ResponseText

End Function

Function GetProjections (League, CBSID, thisPeriod)

	If UCase(League) = "OMEGA" Then
		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/preview?version=3.0&response_format=xml&period=" & thisPeriod & "&team_id=" & CBSID & "&league_id=omegalevel&access_token=" & GetToken("OMEGA")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "SLFFL" Then
		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/preview?version=3.0&response_format=xml&period=" & thisPeriod & "&team_id=" & CBSID & "&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "FLFFL" Then

		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/preview?version=3.0&response_format=xml&period=" & thisPeriod & "&team_id=" & CBSID & "&league_id=farmlevel&access_token=" & GetToken("FARM")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""

	End If

	GetProjections = xmlhttpSLFFL.ResponseText

End Function

Function GetStats (League, thisYear, thisPeriod, thisPlayerID)

	If UCase(League) = "OMEGA" Then
		liveSLFFL = "http://api.cbssports.com/fantasy/stats?version=3.0&response_format=xml&period=" & thisPeriod & "&timeframe=" & thisYear & "&player_id=" & thisPlayerID & "&league_id=omegalevel&access_token=" & GetToken("OMEGA")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "SLFFL" Then
		liveSLFFL = "http://api.cbssports.com/fantasy/stats?version=3.0&response_format=xml&period=" & thisPeriod & "&timeframe=" & thisYear & "&player_id=" & thisPlayerID & "&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "FLFFL" Then

		liveSLFFL = "http://api.cbssports.com/fantasy/stats?version=3.0&response_format=xml&period=" & thisPeriod & "&timeframe=" & thisYear & "&player_id=" & thisPlayerID & "&league_id=farmlevel&access_token=" & GetToken("FARM")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""

	End If

	GetStats = xmlhttpSLFFL.ResponseText

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

Set sqlDatabase = CreateObject("ADODB.Connection")
sqlDatabase.CursorLocation = adUseServer
sqlDatabase.Open "Driver={SQL Server Native Client 11.0};Server=tcp:samelevel.database.windows.net,1433;Database=NextLevelDB;Uid=samelevel;Pwd=TheHammer123;Encrypt=yes;Connection Timeout=60;"

sqlGetYearPeriod = "SELECT TOP 1 Year, Period FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC"
Set rsYearPeriod = sqlDatabase.Execute(sqlGetYearPeriod)

If Not rsYearPeriod.Eof Then

	thisYear = rsYearPeriod("Year")
	thisPeriod = rsYearPeriod("Period")

	rsYearPeriod.Close
	Set rsYearPeriod = Nothing

End If

sqlGetMatchups = "SELECT MatchupID, LevelID, TeamID1, TeamID2 FROM [dbo].[Matchups] WHERE Year = " & thisYear & " AND Period = " & thisPeriod & " ORDER BY LevelID ASC;"
Set rsMatchups = sqlDatabase.Execute(sqlGetMatchups)

arrMatchups = rsMatchups.GetRows()

rsMatchups.Close
Set rsMatchups = Nothing

Set oXMLOmega = CreateObject("MSXML2.DOMDocument.3.0")
oXMLOmega.loadXML(GetScores("OMEGA", thisPeriod))
oXMLOmega.setProperty "SelectionLanguage", "XPath"

Set oXMLSLFFL = CreateObject("MSXML2.DOMDocument.3.0")
oXMLSLFFL.loadXML(GetScores("SLFFL", thisPeriod))
oXMLSLFFL.setProperty "SelectionLanguage", "XPath"

Set oXMLFLFFL = CreateObject("MSXML2.DOMDocument.3.0")
oXMLFLFFL.loadXML(GetScores("FLFFL", thisPeriod))
oXMLFLFFL.setProperty "SelectionLanguage", "XPath"

WScript.Echo(vbcrlf & "Matchups Loaded...")

For i = 0 To UBound(arrMatchups, 2)

	MatchupID = arrMatchups(0, i)
	LevelID = CInt(arrMatchups(1, i))
	TeamID1 = arrMatchups(2, i)
	TeamID2 = arrMatchups(3, i)

	TeamProjectedScore1 = 0
	TeamProjectedScore2 = 0
	TeamSpread1Display = ""
	TeamSpread2Display = ""
	TeamScore1 = 0
	TeamScore2 = 0
	TeamWinPercentage1 = 0
	TeamWinPercentage2 = 0

	'CUP MATCHUP'
	If LevelID = 0 Then

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

	Else

		sqlGetTeams = "SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID1 & " AND LevelID = " & LevelID & "; SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID2 & " AND LevelID = " & LevelID & ";"
		Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

		TeamCBSID1 = rsTeams("CBSID")
		TeamName1 = rsTeams("TeamName")
		Set rsTeams = rsTeams.NextRecordset()
		TeamCBSID2 = rsTeams("CBSID")
		TeamName2 = rsTeams("TeamName")

		rsTeams.Close
		Set rsTeams = Nothing

		If LevelID = 1 Then TeamLevelName1 = "OMEGA" : TeamLevelName2 = "OMEGA" : TeamLevelID1 = 1 : TeamLevelID2 = 1 : Set objTeam1 = oXMLOmega.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]") : Set objTeam2 = oXMLOmega.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")
		If LevelID = 2 Then	TeamLevelName1 = "SLFFL" : TeamLevelName2 = "SLFFL" : TeamLevelID1 = 2 : TeamLevelID2 = 2 : Set objTeam1 = oXMLSLFFL.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]") : Set objTeam2 = oXMLSLFFL.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")
		If LevelID = 3 Then TeamLevelName1 = "FLFFL" : TeamLevelName2 = "FLFFL" : TeamLevelID1 = 3 : TeamLevelID2 = 3 : Set objTeam1 = oXMLFLFFL.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]") : Set objTeam2 = oXMLFLFFL.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")

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
	projectionsXML1.loadXML(GetProjections(TeamLevelName1, TeamCBSID1, thisPeriod))
	projectionsXML1.setProperty "SelectionLanguage", "XPath"
	Set projectionsTeam1 = projectionsXML1.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]/points")
	Set projectionsTeamPlayers1 = projectionsXML1.selectNodes(".//team[@id = " & TeamCBSID1 & "]/active_players/active_player")

	Set projectionsXML2 = CreateObject("MSXML2.DOMDocument.3.0")
	projectionsXML2.loadXML(GetProjections(TeamLevelName2, TeamCBSID2, thisPeriod))
	projectionsXML2.setProperty "SelectionLanguage", "XPath"
	Set projectionsTeam2 = projectionsXML2.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]/points")
	Set projectionsTeamPlayers2 = projectionsXML2.selectNodes(".//team[@id = " & TeamCBSID2 & "]/active_players/active_player")

	TeamProjectedScore1 = projectionsTeam1.text
	TeamProjectedScore2 = projectionsTeam2.text

	TeamNewProjectedScore1 = 0
	TeamNewProjectedScore2 = 0

	For Each Player In projectionsTeamPlayers1

		thisPlayerID = Player.getAttribute("id")
		Set thisPlayer = Player.getElementsByTagName("points")
		thisPlayerOriginalProjection = CDbl(thisPlayer.item(0).text)
		Set thisPlayerPosition = Player.getElementsByTagName("position")
		thisPlayerPosition = thisPlayerPosition.item(0).text

		If CInt(TeamLevelID1) = 1 Then Set objPlayerLiveProjection = oXMLOMEGA.selectSingleNode(".//player[@id = " & thisPlayerID & "]")
		If CInt(TeamLevelID1) = 2 Then Set objPlayerLiveProjection = oXMLSLFFL.selectSingleNode(".//player[@id = " & thisPlayerID & "]")
		If CInt(TeamLevelID1) = 3 Then Set objPlayerLiveProjection = oXMLFLFFL.selectSingleNode(".//player[@id = " & thisPlayerID & "]")

		Set objPlayerLiveProjectionPoints = objPlayerLiveProjection.getElementsByTagName("fpts")
		thisPlayerLiveProjectionPoints = CDbl(objPlayerLiveProjectionPoints.item(0).text)
		Set objPlayerLiveProjectionPMR = objPlayerLiveProjection.getElementsByTagName("minutes_remaining")
		thisPlayerLiveProjectionPMR = 0
		If objPlayerLiveProjectionPMR.Length > 0 Then thisPlayerLiveProjectionPMR = CDbl(objPlayerLiveProjectionPMR.item(0).text)
		thisPlayerLiveProjectionMinutesPlayed = 60 - thisPlayerLiveProjectionPMR

		If thisPlayerLiveProjectionMinutesPlayed = 60 Then

			thisNewProjection = thisPlayerLiveProjectionPoints

		Else

			If thisPlayerPosition = "DST" Then

				thisDST1_YardsAllowed = 0 : thisDST1_PointsAllowed = 0 : thisDST1_FumblesRecovered = 0 : thisDST1_Touchdowns = 0 : thisDST1_Interceptions = 0 : thisDST1_Sacks = 0 : thisDST1_Safetys = 0 : thisDST1_BlockedFGs = 0 : thisDST1_BlockedPunts = 0 : thisDST1_2PtReturns = 0 : thisDST1_1PtSafetys = 0
				thisPointsFromYards = 0 : thisPointsFromPoints = 0

				If thisPlayerLiveProjectionPMR < 60 Then

					Set objPlayerLiveDST = objPlayerLiveProjection.getElementsByTagName("stats_period")
					thisPlayerLiveDST = objPlayerLiveDST.item(0).text

					Set objPlayerLiveDST_AwayScore = objPlayerLiveProjection.getElementsByTagName("away_score")
					thisPlayerLiveDST_AwayScore = CInt(objPlayerLiveDST_AwayScore.item(0).text)

					Set objPlayerLiveDST_HomeScore = objPlayerLiveProjection.getElementsByTagName("home_score")
					thisPlayerLiveDST_HomeScore = CInt(objPlayerLiveDST_HomeScore.item(0).text)

					Set objPlayerLiveDST_HomeGame = objPlayerLiveProjection.getElementsByTagName("home_game")
					thisPlayerLiveDST_HomeGame = CInt(objPlayerLiveDST_HomeGame.item(0).text)

					If thisPlayerLiveDST_HomeGame = 1 Then
						thisDST1_PointsAllowed = thisPlayerLiveDST_AwayScore
					Else
						thisDST1_PointsAllowed = thisPlayerLiveDST_HomeScore
					End If

					arrDSTStats = Split(thisPlayerLiveDST, ", ")

					For Each DST_Stat In arrDSTStats

						If InStr(DST_Stat, " ") Then

							arrThisStat = Split(DST_Stat, " ")
							thisStatCount = arrThisStat(0)
							thisStatAbbr  = arrThisStat(1)

							If thisStatAbbr = "YDS" Then thisDST1_YardsAllowed = CInt(thisStatCount)
							If thisStatAbbr = "Int" Then thisDST1_Interceptions = CInt(thisStatCount)
							If thisStatAbbr = "SACK" Then thisDST1_Sacks = CInt(thisStatCount)
							If thisStatAbbr = "DFR" Then thisDST1_FumblesRecovered = CInt(thisStatCount)
							If thisStatAbbr = "DTD" Then thisDST1_Touchdowns = CInt(thisStatCount)
							If thisStatAbbr = "STY" Then thisDST1_Safetys = CInt(thisStatCount)
							If thisStatAbbr = "BFB" Then thisDST1_BlockedFGs = CInt(thisStatCount)
							If thisStatAbbr = "BP" Then thisDST1_BlockedPunts = CInt(thisStatCount)
							If thisStatAbbr = "ST2PT" Then thisDST1_2PtReturns = CInt(thisStatCount)
							If thisStatAbbr = "STY1PT" Then thisDST1_1PtSafetys = CInt(thisStatCount)

						Else

							If DST_Stat = "Int" Then thisDST1_Interceptions = 1
							If DST_Stat = "SACK" Then thisDST1_Sacks = 1
							If DST_Stat = "DFR" Then thisDST1_FumblesRecovered = 1
							If DST_Stat = "DTD" Then thisDST1_Touchdowns = 1
							If DST_Stat = "STY" Then thisDST1_Safetys = 1
							If DST_Stat = "BFB" Then thisDST1_BlockedFGs = 1
							If DST_Stat = "BP" Then thisDST1_BlockedPunts = 1
							If DST_Stat = "ST2PT" Then thisDST1_2PtReturns = 1
							If DST_Stat = "STY1PT" Then thisDST1_1PtSafetys = 1

						End If

					Next

					If thisDST1_YardsAllowed >= 50 And thisDST1_YardsAllowed < 100 Then thisPointsFromYards = 10
					If thisDST1_YardsAllowed >= 100 And thisDST1_YardsAllowed < 150 Then thisPointsFromYards = 8
					If thisDST1_YardsAllowed >= 150 And thisDST1_YardsAllowed < 200 Then thisPointsFromYards = 6
					If thisDST1_YardsAllowed >= 200 And thisDST1_YardsAllowed < 250 Then thisPointsFromYards = 4
					If thisDST1_YardsAllowed >= 250 And thisDST1_YardsAllowed < 300 Then thisPointsFromYards = 2

					If thisDST1_PointsAllowed >= 7 And thisDST1_PointsAllowed < 14 Then thisPointsFromPoints = 6
					If thisDST1_PointsAllowed >= 14 And thisDST1_PointsAllowed < 21 Then thisPointsFromPoints = 4
					If thisDST1_PointsAllowed >= 21 And thisDST1_PointsAllowed < 29 Then thisPointsFromPoints = 2

				End If

				thisPointsToLose = thisPointsFromYards + thisPointsFromPoints
				thisPointFloor = (thisDST1_FumblesRecovered * 2) + (thisDST1_Touchdowns * 6) + (thisDST1_Interceptions * 2) + (thisDST1_Sacks) + (thisDST1_Safetys * 2) + (thisDST1_BlockedFGs * 2) + (thisDST1_BlockedPunts * 2) + (thisDST1_2PtReturns * 2) + (thisDST1_1PtSafetys)
				thisCurrentScore = thisPointsToLose + thisPointFloor

				thisPlayerLiveProjectionPoints = thisCurrentScore

				thisOriginalDecline = (thisPlayerOriginalProjection - 20) / 60
				thisLiveDecline = thisOriginalDecline
				If thisPlayerLiveProjectionMinutesPlayed > 0 Then thisLiveDecline = (thisPlayerLiveProjectionPoints - 20) / thisPlayerLiveProjectionMinutesPlayed
				thisAdjustedDecline = (thisOriginalDecline + thisLiveDecline) / 2

				'thisNewProjection = (thisOriginalDecline * thisPlayerLiveProjectionPMR) + thisPlayerLiveProjectionPoints
				thisNewProjection = thisPlayerOriginalProjection

				If thisPlayerLiveProjectionPMR < 30 Then thisNewProjection = (thisAdjustedDecline * thisPlayerLiveProjectionPMR) + thisPlayerLiveProjectionPoints

				If thisNewProjection < thisPointFloor Then thisNewProjection = thisPointFloor

				If thisPlayerLiveProjectionPMR = 60 Then thisNewProjection = thisPlayerOriginalProjection

				thisDST1_Projection = thisNewProjection

			Else

				thisOriginalPPM = thisPlayerOriginalProjection / 60
				thisNewProjection = ((thisPlayerOriginalProjection / 60) * thisPlayerLiveProjectionPMR) + thisPlayerLiveProjectionPoints

			End If

		End If

		TeamNewProjectedScore1 = TeamNewProjectedScore1 + thisNewProjection

	Next

	For Each Player In projectionsTeamPlayers2

		thisPlayerID = Player.getAttribute("id")
		Set thisPlayer = Player.getElementsByTagName("points")
		thisPlayerOriginalProjection = CDbl(thisPlayer.item(0).text)
		Set thisPlayerPosition = Player.getElementsByTagName("position")
		thisPlayerPosition = thisPlayerPosition.item(0).text

		If CInt(TeamLevelID2) = 1 Then Set objPlayerLiveProjection = oXMLOMEGA.selectSingleNode(".//player[@id = " & thisPlayerID & "]")
		If CInt(TeamLevelID2) = 2 Then Set objPlayerLiveProjection = oXMLSLFFL.selectSingleNode(".//player[@id = " & thisPlayerID & "]")
		If CInt(TeamLevelID2) = 3 Then Set objPlayerLiveProjection = oXMLFLFFL.selectSingleNode(".//player[@id = " & thisPlayerID & "]")

		Set objPlayerLiveProjectionPoints = objPlayerLiveProjection.getElementsByTagName("fpts")
		thisPlayerLiveProjectionPoints = CDbl(objPlayerLiveProjectionPoints.item(0).text)
		Set objPlayerLiveProjectionPMR = objPlayerLiveProjection.getElementsByTagName("minutes_remaining")
		thisPlayerLiveProjectionPMR = 0
		If objPlayerLiveProjectionPMR.Length > 0 Then thisPlayerLiveProjectionPMR = CDbl(objPlayerLiveProjectionPMR.item(0).text)
		thisPlayerLiveProjectionMinutesPlayed = 60 - thisPlayerLiveProjectionPMR

		If thisPlayerLiveProjectionMinutesPlayed = 60 Then

			thisNewProjection = thisPlayerLiveProjectionPoints

		Else

			If thisPlayerPosition = "DST" Then

				thisDST2_YardsAllowed = 0 : thisDST2_PointsAllowed = 0 : thisDST2_FumblesRecovered = 0 : thisDST2_Touchdowns = 0 : thisDST2_Interceptions = 0 : thisDST2_Sacks = 0 : thisDST2_Safetys = 0 : thisDST2_BlockedFGs = 0 : thisDST2_BlockedPunts = 0 : thisDST2_2PtReturns = 0 : thisDST2_1PtSafetys = 0
				thisPointsFromYards = 0 : thisPointsFromPoints = 0

				If thisPlayerLiveProjectionPMR < 60 Then

					Set objPlayerLiveDST = objPlayerLiveProjection.getElementsByTagName("stats_period")
					thisPlayerLiveDST = objPlayerLiveDST.item(0).text

					Set objPlayerLiveDST_AwayScore = objPlayerLiveProjection.getElementsByTagName("away_score")
					thisPlayerLiveDST_AwayScore = CInt(objPlayerLiveDST_AwayScore.item(0).text)

					Set objPlayerLiveDST_HomeScore = objPlayerLiveProjection.getElementsByTagName("home_score")
					thisPlayerLiveDST_HomeScore = CInt(objPlayerLiveDST_HomeScore.item(0).text)

					Set objPlayerLiveDST_HomeGame = objPlayerLiveProjection.getElementsByTagName("home_game")
					thisPlayerLiveDST_HomeGame = CInt(objPlayerLiveDST_HomeGame.item(0).text)

					If thisPlayerLiveDST_HomeGame = 1 Then
						thisDST2_PointsAllowed = thisPlayerLiveDST_AwayScore
					Else
						thisDST2_PointsAllowed = thisPlayerLiveDST_HomeScore
					End If

					arrDSTStats = Split(thisPlayerLiveDST, ", ")

					For Each DST_Stat In arrDSTStats

						If InStr(DST_Stat, " ") Then

							arrThisStat = Split(DST_Stat, " ")
							thisStatCount = arrThisStat(0)
							thisStatAbbr  = arrThisStat(1)

							If thisStatAbbr = "YDS" Then thisDST2_YardsAllowed = CInt(thisStatCount)
							If thisStatAbbr = "Int" Then thisDST2_Interceptions = CInt(thisStatCount)
							If thisStatAbbr = "SACK" Then thisDST2_Sacks = CInt(thisStatCount)
							If thisStatAbbr = "DFR" Then thisDST2_FumblesRecovered = CInt(thisStatCount)
							If thisStatAbbr = "DTD" Then thisDST2_Touchdowns = CInt(thisStatCount)
							If thisStatAbbr = "STY" Then thisDST2_Safetys = CInt(thisStatCount)
							If thisStatAbbr = "BFB" Then thisDST2_BlockedFGs = CInt(thisStatCount)
							If thisStatAbbr = "BP" Then thisDST2_BlockedPunts = CInt(thisStatCount)
							If thisStatAbbr = "ST2PT" Then thisDST2_2PtReturns = CInt(thisStatCount)
							If thisStatAbbr = "STY1PT" Then thisDST2_1PtSafetys = CInt(thisStatCount)


						Else

							If DST_Stat = "Int" Then thisDST2_Interceptions = 1
							If DST_Stat = "SACK" Then thisDST2_Sacks = 1
							If DST_Stat = "DFR" Then thisDST2_FumblesRecovered = 1
							If DST_Stat = "DTD" Then thisDST2_Touchdowns = 1
							If DST_Stat = "STY" Then thisDST2_Safetys = 1
							If DST_Stat = "BFB" Then thisDST2_BlockedFGs = 1
							If DST_Stat = "BP" Then thisDST2_BlockedPunts = 1
							If DST_Stat = "ST2PT" Then thisDST2_2PtReturns = 1
							If DST_Stat = "STY1PT" Then thisDST2_1PtSafetys = 1

						End If

					Next

					If thisDST2_YardsAllowed >= 50 And thisDST2_YardsAllowed < 100 Then thisPointsFromYards = 10
					If thisDST2_YardsAllowed >= 100 And thisDST2_YardsAllowed < 150 Then thisPointsFromYards = 8
					If thisDST2_YardsAllowed >= 150 And thisDST2_YardsAllowed < 200 Then thisPointsFromYards = 6
					If thisDST2_YardsAllowed >= 200 And thisDST2_YardsAllowed < 250 Then thisPointsFromYards = 4
					If thisDST2_YardsAllowed >= 250 And thisDST2_YardsAllowed < 300 Then thisPointsFromYards = 2

					If thisDST2_PointsAllowed >= 7 And thisDST2_PointsAllowed < 14 Then thisPointsFromPoints = 6
					If thisDST2_PointsAllowed >= 14 And thisDST2_PointsAllowed < 21 Then thisPointsFromPoints = 4
					If thisDST2_PointsAllowed >= 21 And thisDST2_PointsAllowed < 29 Then thisPointsFromPoints = 2

				End If

				thisPointsToLose = thisPointsFromYards + thisPointsFromPoints
				thisPointFloor = (thisDST2_FumblesRecovered * 2) + (thisDST2_Touchdowns * 6) + (thisDST2_Interceptions * 2) + (thisDST2_Sacks) + (thisDST2_Safetys * 2) + (thisDST2_BlockedFGs * 2) + (thisDST2_BlockedPunts * 2) + (thisDST2_2PtReturns * 2) + (thisDST2_1PtSafetys)
				thisCurrentScore = thisPointsToLose + thisPointFloor

				thisPlayerLiveProjectionPoints = thisCurrentScore

				thisOriginalDecline = (thisPlayerOriginalProjection - 20) / 60
				thisLiveDecline = thisOriginalDecline
				If thisPlayerLiveProjectionMinutesPlayed > 0 Then thisLiveDecline = (thisPlayerLiveProjectionPoints - 20) / thisPlayerLiveProjectionMinutesPlayed
				thisAdjustedDecline = (thisOriginalDecline + thisLiveDecline) / 2

				'thisNewProjection = (thisOriginalDecline * thisPlayerLiveProjectionPMR) + thisPlayerLiveProjectionPoints
				thisNewProjection = thisPlayerOriginalProjection
				If thisPlayerLiveProjectionPMR < 30 Then thisNewProjection = (thisAdjustedDecline * thisPlayerLiveProjectionPMR) + thisPlayerLiveProjectionPoints

				If thisNewProjection < thisPointFloor Then thisNewProjection = thisPointFloor

				If thisPlayerLiveProjectionPMR = 60 Then thisNewProjection = thisPlayerOriginalProjection

				thisDST2_Projection = thisNewProjection

			Else

				thisOriginalPPM = thisPlayerOriginalProjection / 60
				thisNewProjection = ((thisPlayerOriginalProjection / 60) * thisPlayerLiveProjectionPMR) + thisPlayerLiveProjectionPoints

			End If

		End If

		TeamNewProjectedScore2 = TeamNewProjectedScore2 + thisNewProjection

	Next

	TeamNewProjectedScore1 = FormatNumber(TeamNewProjectedScore1, 2)
	TeamNewProjectedScore2 = FormatNumber(TeamNewProjectedScore2, 2)

	TeamSpread1 = CInt(TeamNewProjectedScore2 - TeamNewProjectedScore1)
	TeamSpread2 = CInt(TeamNewProjectedScore1 - TeamNewProjectedScore2)

	If TeamNewProjectedScore1 > 0 And TeamNewProjectedScore2 > 0 Then

		MatchupWinPercentage = CalculateWinPercentage(TeamPMR1, TeamPMR2, TeamNewProjectedScore1, TeamNewProjectedScore2, TeamScore1, TeamScore2)
		arrWinPercentages = Split(MatchupWinPercentage, "/")

		TeamWinPercentage1Display = arrWinPercentages(0)
		TeamWinPercentage2Display = arrWinPercentages(1)

	Else

		TeamWinPercentage1Display = "0%"
		TeamWinPercentage2Display = "0%"

	End If


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
	If CInt(TeamNewProjectedScore1) < CInt(TeamNewProjectedScore2) Then
		TeamWinPercentage2 = largerPercentage
		TeamWinPercentage1 = smallerPercentage
	End If

	TeamMoneyline1 = 100
	TeamMoneyline2 = 100

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

	WScript.Echo(vbcrlf & vbcrlf & "MATCHUP #" & MatchupID & " ----------")
	WScript.Echo(vbcrlf & TeamName1 & " (" & TeamNewProjectedScore1 & " Proj, " & TeamSpread1Display & " Spread, " & TeamWinPercentage1 * 100 & "% Win, " & TeamMoneyline1Display & " ML, " & thisDST1_Projection & " DST Proj., " & thisDST1_YardsAllowed & " DST YDS, " & thisDST1_PointsAllowed & " DST PTS, " & thisDST1_Interceptions & " INT)")
	WScript.Echo(vbcrlf & TeamName2 & " (" & TeamNewProjectedScore2 & " Proj, " & TeamSpread2Display & " Spread, " & TeamWinPercentage2 * 100 & "% Win, " & TeamMoneyline2Display & " ML, " & thisDST2_Projection & " DST Proj., " & thisDST2_YardsAllowed & " DST YDS, " & thisDST2_PointsAllowed & " DST PTS, " & thisDST2_Interceptions & " INT)")

	sqlUpdate = "UPDATE Matchups SET TeamScore1 = " & TeamScore1 & ", TeamScore2 = " & TeamScore2 & ", TeamPMR1 = " & TeamPMR1 & ", TeamPMR2 = " & TeamPMR2 & ", TeamProjected1 = " &  TeamNewProjectedScore1 & ", TeamProjected2 = " &  TeamNewProjectedScore2 & ", TeamWinPercentage1 = " &  TeamWinPercentage1 & ", TeamWinPercentage2 = " &  TeamWinPercentage2 & ", TeamMoneyline1 = " &  TeamMoneyline1 & ", TeamMoneyline2 = " &  TeamMoneyline2 & ", TeamSpread1 = " &  TeamSpread1 & ", TeamSpread2 = " &  TeamSpread2 & "  WHERE MatchupID = " & MatchupID
	Set rsUpdate = sqlDatabase.Execute(sqlUpdate)

Next

EndTime = Now()

WScript.Echo(vbcrlf & StartTime)
WScript.Echo(vbcrlf & EndTime)
