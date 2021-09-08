StartTime = Now()
WScript.Echo("STARTING..." & vbcrlf)

Function GetToken (League)

	Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

	If League = "SLFFL" Then
		'xmlhttpSLFFL.open "GET", "https://api.cbssports.com/general/oauth/test/access_token?user_id=naptown-&league_id=samelevel&sport=football&response_format=xml", false
		thisToken = "U2FsdGVkX1-nLiU_Ohv2rB2SaenbXwpQylBie1tQNoBTZOnUpFFdLDV5OUgc3vmFrMKwDDYb7m3qQo9ibt3sJJBqwOc_sTeToX5k68OaIN0syDyxnNK55k6p4tHLlggE8RhkO1lg8HrIpytn-fl1iQ"
	ElseIf League = "OMEGA" Then
		'xmlhttpSLFFL.open "GET", "https://api.cbssports.com/general/oauth/test/access_token?user_id=naptown-&league_id=omegalevel&sport=football&response_format=xml", false
		thisToken = "U2FsdGVkX1_qjmv9BNf7THPpaUam02iQhwXpqOpq4shkjBli6JKBx6jTkoLtjr9O-vpLxUlbrMYeG_oYthVZ-LyvmlxbYT2GM60aSUzvZ65ptKQoW5aXQLHypxM4zkS7XVfxPK1QricXvAKx03EPvg"
	Else
		'xmlhttpSLFFL.open "GET", "https://api.cbssports.com/general/oauth/test/access_token?user_id=naptown-&league_id=farmlevel&sport=football&response_format=xml", false
		thisToken = "U2FsdGVkX18SKm91VpVXfO9uNx9RYniWaNBh1gqk-7NPji49ceBLJHbZO4mddgm6ooiVrhSYqxFkEIzIy9mCoE3L_ZyAGA9zPnKWUOIsfF-xSXvnaeKtrEejU-V-OZVSTnQvC9r2N_PdA3E3nE9lYw"
	End If
	'xmlhttpSLFFL.send ""

	'SLFFLAccessResponse = xmlhttpSLFFL.ResponseText

	'Set xmlhttpSLFFL = Nothing

	'If Left(SLFFLAccessToken, 1) = " " Then SLFFLAccessToken = Right(SLFFLAccessToken, Len(SLFFLAccessToken) - 1)

	'Set xmlDoc = CreateObject("Microsoft.XMLDOM")
	'xmlDoc.async = False
	'TokenDoc = xmlDoc.loadxml(SLFFLAccessResponse)

	'Set Node =  xmlDoc.documentElement.selectSingleNode("body/access_token")
	'GetToken = Node.text

	GetToken = thisToken

End Function

Function GetScores (League, thisYear, thisPeriod)

	If UCase(League) = "OMEGA" Then
		liveSLFFL = "https://api.cbssports.com/fantasy/league/history/results?version=3.0&response_format=xml&timeframe=" & thisYear & "&period=" & thisPeriod & "&league_id=omegalevel&access_token=" & GetToken("OMEGA")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "SLFFL" Then
		liveSLFFL = "https://api.cbssports.com/fantasy/league/history/results?version=3.0&response_format=xml&timeframe=" & thisYear & "&period=" & thisPeriod & "&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "FLFFL" Then

		liveSLFFL = "https://api.cbssports.com/fantasy/league/history/results?version=3.0&response_format=xml&timeframe=" & thisYear & "&period=" & thisPeriod & "&league_id=farmlevel&access_token=" & GetToken("FARM")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""

	End If

	GetScores = xmlhttpSLFFL.ResponseText

End Function

Set sqlDatabase = CreateObject("ADODB.Connection")
sqlDatabase.CursorLocation = adUseServer
sqlDatabase.Open "Driver={SQL Server Native Client 11.0};Server=tcp:loldb.database.windows.net,1433;Database=leagueoflevels;Uid=commissioner;Pwd=TheHammer123;Encrypt=yes;Connection Timeout=60;"

sqlGetYearPeriod = "SELECT TOP 1 Year, Period FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC"
Set rsYearPeriod = sqlDatabase.Execute(sqlGetYearPeriod)

If Not rsYearPeriod.Eof Then

	thisCurrentYear = rsYearPeriod("Year")
	'thisCurrentPeriod = rsYearPeriod("Period")
	thisCurrentPeriod = 12

	rsYearPeriod.Close
	Set rsYearPeriod = Nothing

End If

thisYear = 2019

Do While thisYear < 2020

	thisPeriod = 1

	If thisYear < 2011 Then
		thisCurrentPeriod = 18
	Else
		thisCurrentPeriod = 17
	End If

	Do While thisPeriod < thisCurrentPeriod

		sqlGetMatchups = "SELECT MatchupID, LevelID, TeamID1, TeamID2, TeamScore1, TeamScore2 FROM [dbo].[Matchups] WHERE Year = " & thisYear & " AND Period = " & thisPeriod & " AND LevelID = 3 ORDER BY LevelID ASC;"
		Set rsMatchups = sqlDatabase.Execute(sqlGetMatchups)

		arrMatchups = rsMatchups.GetRows()

		rsMatchups.Close
		Set rsMatchups = Nothing

		Set oXMLOmega = CreateObject("MSXML2.DOMDocument.3.0")
		oXMLOmega.loadXML(GetScores("OMEGA", thisYear, thisPeriod))
		oXMLOmega.setProperty "SelectionLanguage", "XPath"

		Set oXMLSLFFL = CreateObject("MSXML2.DOMDocument.3.0")
		oXMLSLFFL.loadXML(GetScores("SLFFL", thisYear, thisPeriod))
		oXMLSLFFL.setProperty "SelectionLanguage", "XPath"

		Set oXMLFLFFL = CreateObject("MSXML2.DOMDocument.3.0")
		oXMLFLFFL.loadXML(GetScores("FLFFL", thisYear, thisPeriod))
		oXMLFLFFL.setProperty "SelectionLanguage", "XPath"

		WScript.Echo(vbcrlf & "CHECKING " & thisYear & " WEEK " & thisPeriod & " MATCHUPS...")

		For i = 0 To UBound(arrMatchups, 2)

			MatchupID = arrMatchups(0, i)
			LevelID = CInt(arrMatchups(1, i))
			TeamID1 = arrMatchups(2, i)
			TeamID2 = arrMatchups(3, i)
			TeamScore1Current = arrMatchups(4, i)
			TeamScore2Current = arrMatchups(5, i)

			TeamScore1 = 0
			TeamScore2 = 0

			'CUP MATCHUP'
			If LevelID = 0 Then

				sqlGetTeams = "SELECT Teams.TeamName, LinkTeamsLevels.LevelID, LinkTeamsLevels.CBSID FROM Teams INNER JOIN LinkTeamsLevels ON LinkTeamsLevels.TeamID = Teams.TeamID WHERE Teams.TeamID = " & TeamID1 & " AND LinkTeamsLevels.Year = " & thisYear & " AND LinkTeamsLevels.LevelID <> 1; SELECT Teams.TeamName, LinkTeamsLevels.LevelID, LinkTeamsLevels.CBSID FROM Teams INNER JOIN LinkTeamsLevels ON LinkTeamsLevels.TeamID = Teams.TeamID WHERE Teams.TeamID = " & TeamID2 & " AND LinkTeamsLevels.Year = " & thisYear & " AND LinkTeamsLevels.LevelID <> 1;"
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
					TeamLevelName1 = "SLFFL"

					Set objYear = oXMLSLFFL.selectSingleNode(".//year[@id = " & thisYear & "]")
					Set objTeam1 = objYear.selectSingleNode(".//home_team[@id = " & TeamCBSID1 & "]")
					If objTeam1 Is Nothing Then Set objTeam1 = objYear.selectSingleNode(".//away_team[@id = " & TeamCBSID1 & "]")

				End If

				If CInt(TeamLevelID1) = 3 Then
					TeamLevelName1 = "FLFFL"

					Set objYear = oXMLFLFFL.selectSingleNode(".//year[@id = " & thisYear & "]")
					Set objTeam1 = objYear.selectSingleNode(".//home_team[@id = " & TeamCBSID1 & "]")
					If objTeam1 Is Nothing Then Set objTeam1 = objYear.selectSingleNode(".//away_team[@id = " & TeamCBSID1 & "]")
				End If

				If CInt(TeamLevelID2) = 2 Then
					TeamLevelName2 = "SLFFL"

					Set objYear = oXMLSLFFL.selectSingleNode(".//year[@id = " & thisYear & "]")
					Set objTeam2 = objYear.selectSingleNode(".//home_team[@id = " & TeamCBSID2 & "]")
					If objTeam2 Is Nothing Then Set objTeam2 = objYear.selectSingleNode(".//away_team[@id = " & TeamCBSID2 & "]")
				End If

				If CInt(TeamLevelID2) = 3 Then
					TeamLevelName2 = "FLFFL"

					Set objYear = oXMLFLFFL.selectSingleNode(".//year[@id = " & thisYear & "]")
					Set objTeam2 = objYear.selectSingleNode(".//home_team[@id = " & TeamCBSID2 & "]")
					If objTeam2 Is Nothing Then Set objTeam2 = objYear.selectSingleNode(".//away_team[@id = " & TeamCBSID2 & "]")
				End If

			Else

				TeamBye1 = 1
				TeamBye2 = 1
				TeamName1 = "BYE"
				TeamName2 = "BYE"
				TeamCBSID1 = 0
				TeamCBSID2 = 0
				TeamLevelID1 = 0
				TeamLevelID2 = 0
				TeamScore1 = 0
				TeamScore2 = 0

				sqlGetTeams = "SELECT Teams.TeamName, LinkTeamsLevels.LevelID, LinkTeamsLevels.CBSID FROM Teams INNER JOIN LinkTeamsLevels ON LinkTeamsLevels.TeamID = Teams.TeamID WHERE Teams.TeamID = " & TeamID1 & " AND LinkTeamsLevels.Year = " & thisYear & "; SELECT Teams.TeamName, LinkTeamsLevels.LevelID, LinkTeamsLevels.CBSID FROM Teams INNER JOIN LinkTeamsLevels ON LinkTeamsLevels.TeamID = Teams.TeamID WHERE Teams.TeamID = " & TeamID2 & " AND LinkTeamsLevels.Year = " & thisYear & ";"
				Set rsTeams = sqlDatabase.Execute(sqlGetTeams)

				If TeamID1 <> 99999 Then
					TeamBye1 = 0
					TeamCBSID1 = rsTeams("CBSID")
					TeamName1 = rsTeams("TeamName")
					TeamLevelID1 = rsTeams("LevelID")
				End If
				Set rsTeams = rsTeams.NextRecordset()
				If TeamID2 <> 99999 Then
					TeamBye2 = 0
					TeamCBSID2 = rsTeams("CBSID")
					TeamName2 = rsTeams("TeamName")
					TeamLevelID2 = rsTeams("LevelID")
				End If

				rsTeams.Close
				Set rsTeams = Nothing

				If TeamBye1 = 1 Then TeamLevelID1 = TeamLevelID2
				If TeamBye2 = 1 Then TeamLevelID2 = TeamLevelID1

				Set objTeam1 = Nothing
				Set objTeam2 = Nothing

				If TeamLevelID1 = 1 Or TeamLevelID2 = 1 Then
					TeamLevelName1 = "OMEGA" : TeamLevelName2 = "OMEGA" : TeamLevelID1 = 1 : TeamLevelID2 = 1

					Set objYear = oXMLOmega.selectSingleNode(".//year[@id = " & thisYear & "]")

					Set objTeam1 = objYear.selectSingleNode(".//home_team[@id = " & TeamCBSID1 & "]")
					Set objTeam2 = objYear.selectSingleNode(".//away_team[@id = " & TeamCBSID2 & "]")

					If (TeamBye1 = 0 And objTeam1 Is Nothing) Or (TeamBye2 = 0 And objTeam2 Is Nothing) Then

						Set objTeam1 = objYear.selectSingleNode(".//away_team[@id = " & TeamCBSID1 & "]")
						Set objTeam2 = objYear.selectSingleNode(".//home_team[@id = " & TeamCBSID2 & "]")

					End If

				End If

				If TeamLevelID1 = 2 Or TeamLevelID2 = 2 Then
					TeamLevelName1 = "SLFFL" : TeamLevelName2 = "SLFFL" : TeamLevelID1 = 2 : TeamLevelID2 = 2

					Set objYear = oXMLSLFFL.selectSingleNode(".//year[@id = " & thisYear & "]")

						Set objTeam1 = objYear.selectSingleNode(".//home_team[@id = " & TeamCBSID1 & "]")
						Set objTeam2 = objYear.selectSingleNode(".//away_team[@id = " & TeamCBSID2 & "]")

						If (TeamBye1 = 0 And objTeam1 Is Nothing) Or (TeamBye2 = 0 And objTeam2 Is Nothing) Then

							Set objTeam1 = objYear.selectSingleNode(".//away_team[@id = " & TeamCBSID1 & "]")
							Set objTeam2 = objYear.selectSingleNode(".//home_team[@id = " & TeamCBSID2 & "]")

						End If

				End If

				If TeamLevelID1 = 3 Or TeamLevelID2 = 3 Then
					TeamLevelName1 = "FLFFL" : TeamLevelName2 = "FLFFL" : TeamLevelID1 = 3 : TeamLevelID2 = 3

					Set objYear = oXMLFLFFL.selectSingleNode(".//year[@id = " & thisYear & "]")

					Set objTeam1 = objYear.selectSingleNode(".//home_team[@id = " & TeamCBSID1 & "]")
					Set objTeam2 = objYear.selectSingleNode(".//away_team[@id = " & TeamCBSID2 & "]")

					If (TeamBye1 = 0 And objTeam1 Is Nothing) Or (TeamBye2 = 0 And objTeam2 Is Nothing) Then

						Set objTeam1 = objYear.selectSingleNode(".//away_team[@id = " & TeamCBSID1 & "]")
						Set objTeam2 = objYear.selectSingleNode(".//home_team[@id = " & TeamCBSID2 & "]")

					End If

				End If

			End If

			If TeamBye1 = 0 Then Set objTeamScore1 = objTeam1.getElementsByTagName("points")
			If TeamBye2 = 0 Then Set objTeamScore2 = objTeam2.getElementsByTagName("points")

			If TeamBye1 = 0 Then TeamScore1 = CDbl(objTeamScore1.item(0).text)
			If TeamBye2 = 0 Then TeamScore2 = CDbl(objTeamScore2.item(0).text)

			If IsNull(TeamScore1Current) Or TeamScore1Current = "NULL" Then TeamScore1Current = 0
			If IsNull(TeamScore2Current) Or TeamScore2Current = "NULL" Then TeamScore2Current = 0

			If (TeamScore1Current <> TeamScore1) Or (TeamScore2Current <> TeamScore2) Then

				'WScript.Echo(vbcrlf & vbcrlf & "WEEK " & thisPeriod & " / LEVEL " & LevelID & " / MATCHUP #" & MatchupID & " ----------")
				WScript.Echo(vbcrlf & TeamName1 & "* (" & TeamScore1 & " / " & TeamScore1Current & ") / " & TeamName2 & " (" & TeamScore2 & " / " & TeamScore2Current & ")")

				sqlUpdate = "UPDATE Matchups SET TeamScore1 = " & TeamScore1 & ", TeamScore2 = " & TeamScore2 & "  WHERE MatchupID = " & MatchupID
				Set rsUpdate = sqlDatabase.Execute(sqlUpdate)

				'WScript.Echo(vbcrlf & sqlUpdate)
			Else

				'WScript.Echo(vbcrlf & vbcrlf & "WEEK " & thisPeriod & " / LEVEL " & LevelID & " / MATCHUP #" & MatchupID & " ----------")
				'WScript.Echo(vbcrlf & TeamName1 & " (" & TeamScore1 & " / " & TeamScore1Current & ") / " & TeamName2 & " (" & TeamScore2 & " / " & TeamScore2Current & ")")

			End If

		Next

		thisPeriod = thisPeriod + 1

	Loop

	thisYear = thisYear + 1

Loop

EndTime = Now()

WScript.Echo(vbcrlf & StartTime)
WScript.Echo(vbcrlf & EndTime)
