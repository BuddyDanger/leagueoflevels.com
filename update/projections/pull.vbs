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

Function GetScores (League, thisPeriod)

	If UCase(League) = "OMEGA" Then
		liveSLFFL = "https://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&period=" & thisPeriod & "&league_id=omegalevel&access_token=" & GetToken("OMEGA")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "SLFFL" Then
		liveSLFFL = "https://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&period=" & thisPeriod & "&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "FLFFL" Then

		liveSLFFL = "https://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&period=" & thisPeriod & "&league_id=farmlevel&access_token=" & GetToken("FARM")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""

	End If

	GetScores = xmlhttpSLFFL.ResponseText

End Function

Function GetProjections (League, CBSID, thisPeriod)

	If UCase(League) = "OMEGA" Then
		liveSLFFL = "https://api.cbssports.com/fantasy/league/scoring/preview?version=3.0&response_format=xml&period=" & thisPeriod & "&team_id=" & CBSID & "&league_id=omegalevel&access_token=" & GetToken("OMEGA")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "SLFFL" Then
		liveSLFFL = "https://api.cbssports.com/fantasy/league/scoring/preview?version=3.0&response_format=xml&period=" & thisPeriod & "&team_id=" & CBSID & "&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "FLFFL" Then

		liveSLFFL = "https://api.cbssports.com/fantasy/league/scoring/preview?version=3.0&response_format=xml&period=" & thisPeriod & "&team_id=" & CBSID & "&league_id=farmlevel&access_token=" & GetToken("FARM")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""

	End If

	GetProjections = xmlhttpSLFFL.ResponseText

End Function

Function GetStats (League, thisYear, thisPeriod, thisPlayerID)

	If UCase(League) = "OMEGA" Then
		liveSLFFL = "https://api.cbssports.com/fantasy/stats?version=3.0&response_format=xml&period=" & thisPeriod & "&timeframe=" & thisYear & "&player_id=" & thisPlayerID & "&league_id=omegalevel&access_token=" & GetToken("OMEGA")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "SLFFL" Then
		liveSLFFL = "https://api.cbssports.com/fantasy/stats?version=3.0&response_format=xml&period=" & thisPeriod & "&timeframe=" & thisYear & "&player_id=" & thisPlayerID & "&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""
	End If

	If UCase(League) = "FLFFL" Then

		liveSLFFL = "https://api.cbssports.com/fantasy/stats?version=3.0&response_format=xml&period=" & thisPeriod & "&timeframe=" & thisYear & "&player_id=" & thisPlayerID & "&league_id=farmlevel&access_token=" & GetToken("FARM")
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


MatchupWinPercentage = CalculateWinPercentage(420, 420, 86, 93, 0, 0)

WScript.Echo(MatchupWinPercentage)
