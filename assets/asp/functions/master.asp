<%
	Function ParseForAbsolutePath (sRawURI)

		On Error Resume Next
		iStringStart = InStr(1, sRawURI, "//", 1)
		If iStringStart > 0 Then
			iStringStart = InStr(iStringStart+2, sRawURI, "/", 1)
			sFinalPath = Mid(sRawURI, iStringStart)
		End If
		If Err.Number <> 0 Then sFinalPath = ""
		On Error Goto 0
		ParseForAbsolutePath = sFinalPath

	End Function

	Function GetToken (League)

		Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")

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

		Set xmlDoc = Server.CreateObject("Microsoft.XMLDOM")
		xmlDoc.async = False
		TokenDoc = xmlDoc.loadxml(SLFFLAccessResponse)

		Set Node =  xmlDoc.documentElement.selectSingleNode("body/access_token")
		GetToken = Node.text

	End Function

	Function GetMatchups (League, Period)

		If UCase(League) = "SLFFL" Then LeagueID = "samelevel"
		If UCase(League) = "FLFFL" Then LeagueID = "farmlevel"
		If UCase(League) = "OLFFL" Then LeagueID = "omegalevel"

		liveMatchups = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=" & LeagueID & "&period=" & Period & "&access_token=" & GetToken(League)
		Set xmlhttpMatchups = Server.CreateObject("Microsoft.XMLHTTP")

		xmlhttpMatchups.open "GET", liveMatchups, false
		xmlhttpMatchups.send ""

		GetMatchups = xmlhttpMatchups.ResponseText

	End Function

	Function GetScores (League, Period)

		If UCase(League) = "OMEGA" Then
			liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=omegalevel&period=" & Period & "&access_token=" & GetToken("OMEGA")
			Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")

			xmlhttpSLFFL.open "GET", liveSLFFL, false
			xmlhttpSLFFL.send ""
		End If

		If UCase(League) = "SLFFL" Then
			liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=samelevel&period=" & Period & "&access_token=" & GetToken("SLFFL")
			Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")

			xmlhttpSLFFL.open "GET", liveSLFFL, false
			xmlhttpSLFFL.send ""
		End If

		If UCase(League) = "FLFFL" Then

			liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=farmlevel&period=" & Period & "&access_token=" & GetToken("FARM")
			Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")

			xmlhttpSLFFL.open "GET", liveSLFFL, false
			xmlhttpSLFFL.send ""

		End If

		GetScores = xmlhttpSLFFL.ResponseText

	End Function

	Function GetWeek ()

		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=samelevel&access_token=" & GetToken("SLFFL")
		Set xmlhttpSLFFL = Server.CreateObject("Microsoft.XMLHTTP")

		xmlhttpSLFFL.open "GET", liveSLFFL, false
		xmlhttpSLFFL.send ""

		Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
		oXML.loadXML(xmlhttpSLFFL.ResponseText)

		Set objTeams = oXML.getElementsByTagName("period")
		Set objTeam = objTeams.item(0)
		GetWeek = objTeam.text

	End Function

	Sub InitializeScoreboard (League)

		Response.Write("<div class=""row"">")

			Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
			oXML.async = "false"
			oXML.loadXML(GetScores(League, Session.Contents("CurrentPeriod")))

			Set objTeams = oXML.getElementsByTagName("team")

			MatchupTrail = "0,"
			If League = "OMEGA" Then
				OMEGATeamTrailID = ""
				OMEGATeamTrailScore = ""
			End If
			If League = "SLFFL" Then
				SLFFLTeamTrailID = ""
				SLFFLTeamTrailScore = ""
			End If
			If League = "FARM" Then
				FARMTeamTrailID = ""
				FARMTeamTrailScore = ""
			End If

			For i = 0 to (objTeams.length - 1)

				Set objTeam = objTeams.item(i)

				Set objTeamName = objTeam.getElementsByTagName("name")
				thisTeamName = objTeamName.item(0).text

				thisTeamID = objTeam.getAttribute("id")
				'thisTeamName = objTeam.childNodes(13).text
				thisTeamScore = objTeam.childNodes(19).text
				thisTeamLogo = objTeam.childNodes(17).text
				thisTeamPMR = objTeam.childNodes(20).text

				Set objMatchups = objTeam.getElementsByTagName("matchups")

				Set objMatchup1 = objMatchups.item(0)
				Set objMatchup2 = objMatchups.item(1)

				Opponent1ID = objMatchup1.childNodes(3).text
				Opponent1Score = objMatchup1.childNodes(0).text
				Opponent1Name  = objMatchup1.childNodes(4).text
				Opponent2ID = objMatchup2.childNodes(3).text
				Opponent2Score = objMatchup2.childNodes(0).text
				Opponent2Name  = objMatchup2.childNodes(4).text
				MatchupID1 = objMatchup1.GetAttribute("id")
				MatchupID2 = objMatchup2.GetAttribute("id")

				TeamDetails = TeamDetails & thisTeamID & "|" & thisTeamName & "|" & thisTeamLogo & "|" & thisTeamPMR & "+"

				useTeam = 1

				If League = "OMEGA" Then
					If InStr(OMEGATeamTrailID, ",") Then

						arTeams = Split(OMEGATeamTrailID, ",")
						For Each Team In arTeams
							If Team = thisTeamID Then useTeam = 0
						Next

						If useTeam = 1 Then
							OMEGATeamTrailID = OMEGATeamTrailID & thisTeamID & ","
							OMEGATeamTrailScore = OMEGATeamTrailScore & thisTeamScore & ","
						End If

					Else

						OMEGATeamTrailID = thisTeamID & ","
						OMEGATeamTrailScore = OMEGATeamTrailScore & thisTeamScore & ","

					End If
				End If

				If League = "SLFFL" Then
					If InStr(SLFFLTeamTrailID, ",") Then

						arTeams = Split(SLFFLTeamTrailID, ",")
						For Each Team In arTeams
							If Team = thisTeamID Then useTeam = 0
						Next

						If useTeam = 1 Then
							SLFFLTeamTrailID = SLFFLTeamTrailID & thisTeamID & ","
							SLFFLTeamTrailScore = SLFFLTeamTrailScore & thisTeamScore & ","
						End If

					Else

						SLFFLTeamTrailID = thisTeamID & ","
						SLFFLTeamTrailScore = SLFFLTeamTrailScore & thisTeamScore & ","

					End If
				End If

				If League = "FARM" Then
					If InStr(FARMTeamTrailID, ",") Then

						arTeams = Split(FARMTeamTrailID, ",")
						For Each Team In arTeams
							If Team = thisTeamID Then useTeam = 0
						Next

						If useTeam = 1 Then
							FARMTeamTrailID = FARMTeamTrailID & thisTeamID & ","
							FARMTeamTrailScore = FARMTeamTrailScore & thisTeamScore & ","
						End If

					Else

						FARMTeamTrailID = thisTeamID & ","
						FARMTeamTrailScore = FARMTeamTrailScore & thisTeamScore & ","

					End If
				End If

				useMatchup1 = 1
				useMatchup2 = 1
				arMatchupTrail = Split(MatchupTrail, ",")
				For Each Matchup In arMatchupTrail
					If Matchup = MatchupID1 Then useMatchup1 = 0
					If Matchup = MatchupID2 Then useMatchup2 = 0
				Next

				If useMatchup1 Then
					MatchupString = MatchupString & MatchupID1 & "|" & thisTeamID & "|" & thisTeamScore & "|" & Opponent1ID & "|" & Opponent1Score & "+"
					MatchupTrail = MatchupTrail & MatchupID1 & ","
				End If

				If useMatchup2 Then
					MatchupString = MatchupString & MatchupID2 & "|" & thisTeamID & "|" & thisTeamScore & "|" & Opponent2ID & "|" & Opponent2Score & "+"
					MatchupTrail = MatchupTrail & MatchupID2 & ","
				End If

			Next

			TOTAL_Points_SLFFL = 0
			TOTAL_PMR_SLFFL = 0

			TOTAL_Points_OMEGA = 0
			TOTAL_PMR_OMEGA = 0

			If Right(OMEGATeamTrailID, 1) = "," Then OMEGATeamTrailID = Left(OMEGATeamTrailID, Len(OMEGATeamTrailID)-1)
			If Right(OMEGATeamTrailScore, 1) = "," Then OMEGATeamTrailScore = Left(OMEGATeamTrailScore, Len(OMEGATeamTrailScore)-1)
			If Right(SLFFLTeamTrailID, 1) = "," Then SLFFLTeamTrailID = Left(SLFFLTeamTrailID, Len(SLFFLTeamTrailID)-1)
			If Right(SLFFLTeamTrailScore, 1) = "," Then SLFFLTeamTrailScore = Left(SLFFLTeamTrailScore, Len(SLFFLTeamTrailScore)-1)
			If Right(FARMTeamTrailID, 1) = "," Then FARMTeamTrailID = Left(FARMTeamTrailID, Len(FARMTeamTrailID)-1)
			If Right(FARMTeamTrailScore, 1) = "," Then FARMTeamTrailScore = Left(FARMTeamTrailScore, Len(FARMTeamTrailScore)-1)
			If Right(MatchupString, 1) = "+" Then MatchupString = Left(MatchupString, Len(MatchupString) - 1)
			If Right(TeamDetails, 1) = "+" Then TeamDetails = Left(TeamDetails, Len(TeamDetails) - 1)


			arMatchups = Split(MatchupString, "+")
			arTeams = Split(TeamDetails, "+")

			For Each Matchup In arMatchups

				arMatchup = Split(Matchup, "|")
				MatchupID = arMatchup(0)
				TeamID1 = arMatchup(1)
				TeamID2 = arMatchup(3)
				TeamScore1 = arMatchup(2)
				TeamScore2 = arMatchup(4)

				For Each Team In arTeams

					arTeam = Split(Team, "|")

					If arTeam(0) = TeamID1 Then
						TeamName1 = arTeam(1)
						TeamLogo1 = arTeam(2)
						TeamPMR1  = arTeam(3)
					End If

					If arTeam(0) = TeamID2 Then
						TeamName2 = arTeam(1)
						TeamLogo2 = arTeam(2)
						TeamPMR2  = arTeam(3)
					End If

				Next

				TeamPMRColor1 = "success"
				If TeamPMR1 < 321 Then TeamPMRColor1 = "warning"
				If TeamPMR1 < 161 Then TeamPMRColor1 = "danger"

				TeamPMRColor2 = "success"
				If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
				If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"

				TeamPMRPercent1 = (TeamPMR1 * 100) / 420
				TeamPMRPercent2 = (TeamPMR2 * 100) / 420

				TOTAL_Points_SLFFL = TOTAL_Points_SLFFL + TeamScore1 + TeamScore2
				TOTAL_PMR_SLFFL = TOTAL_PMR_SLFFL + TeamPMR1 + TeamPMR2

				Response.Write("<div class=""col-sm-6"">")
					Response.Write("<ul class=""list-group"">")
						Response.Write("<li class=""list-group-item team-slffl-box-" & TeamID1 & """>")
							Response.Write("<span class=""badge team-slffl-score-" & TeamID1 & """ style=""font-size: 1.9em; background-color: #fff; color: #444444;"">" & TeamScore1 & "</span>")
							Response.Write("<img src=""" & TeamLogo1 & """ width=""29"" /> <span style=""font-size: 15px""><b>" & TeamName1 & "</b></span>")
							Response.Write("<div class=""progress"" style=""height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;"">")
								Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColor1 & " team-slffl-progress-" & TeamID1 & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercent1 & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercent1 & "%"">")
									Response.Write("<span class=""sr-only team-slffl-progress-sr-" & TeamID1 & """>" & TeamPMRPercent1 & "%</span>")
								Response.Write("</div>")
							Response.Write("</div>")
						Response.Write("</li>")
						Response.Write("<li class=""list-group-item team-slffl-box-" & TeamID2 & """>")
							Response.Write("<span class=""badge team-slffl-score-" & TeamID2 & """ style=""font-size: 1.9em; background-color: #fff; color: #444444;"">" & TeamScore2 & "</span>")
							Response.Write("<img src=""" & TeamLogo2 & """ width=""29"" /> <span style=""font-size: 15px""><b>" & TeamName2 & "</b></span>")
							Response.Write("<div class=""progress"" style=""height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;"">")
								Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColor2 & " team-slffl-progress-" & TeamID2 & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercent2 & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercent2 & "%"">")
									Response.Write("<span class=""sr-only team-slffl-progress-sr-" & TeamID2 & """>" & TeamPMRPercent2 & "%</span>")
								Response.Write("</div>")
							Response.Write("</div>")
						Response.Write("</li>")
					Response.Write("</ul>")
				Response.Write("</div>")

			Next

		Response.Write("</div>")

		MatchupString = ""
		TeamDetails = ""
		MatchupTrail = "0,"

	End Sub

	Sub InitializeLeague ()

		Response.Write("<div class=""row"">")

			TOTAL_Points_FARM = TOTAL_Points_FARM / 2
			TOTAL_PMR_FARM = TOTAL_PMR_FARM / 2
			TOTAL_Points_SLFFL = TOTAL_Points_SLFFL / 2
			TOTAL_PMR_SLFFL = TOTAL_PMR_SLFFL / 2

			TeamPMRColorSLFFL = "success"
			If TOTAL_PMR_SLFFL < 3852 Then TeamPMRColorSLFFL = "warning"
			If TOTAL_PMR_SLFFL < 1932 Then TeamPMRColorSLFFL = "danger"

			TeamPMRColorFARM = "success"
			If TOTAL_PMR_FARM < 3852 Then TeamPMRColorFARM = "warning"
			If TOTAL_PMR_FARM < 1932 Then TeamPMRColorFARM = "danger"

			TeamPMRPercentSLFFL = (TOTAL_PMR_SLFFL * 100) / 5760
			TeamPMRPercentFARM  = (TOTAL_PMR_FARM * 100) / 5760

			arSLFFLScores = Split(SLFFLTeamTrailScore, ",")
			arFARMScores = Split(FARMTeamTrailScore, ",")

			'medianSLFFL = Median(arSLFFLScores)
			'medianFARM = Median(arFARMScores)

			averageSLFFL = Average(arSLFFLScores)
			averageFARM = Average(arFARMScores)

			Response.Write("<div class=""col-sm-6"">")
				Response.Write("<ul class=""list-group"">")
					Response.Write("<li class=""list-group-item"">")
						Response.Write("<span class=""badge"" style=""font-size: 3em; background-color: #fff; color: #444444;"">" & TOTAL_Points_SLFFL & "</span>")
						Response.Write("<img src=""http://data.samelevel.net/assets/images/icons/slffl.jpg"" style=""float: left; padding-right: 20px;"" />")
						Response.Write("<div style=""font-size: 16px""><b>" & medianSLFFL & "</b> <span style=""font-size: 14px;""><i>Median</i></span></div>")
						Response.Write("<div style=""font-size: 16px""><b>" & averageSLFFL & "</b> <span style=""font-size: 14px;""><i>Average</i></span></div>")
						Response.Write("<div class=""clearfix""></div>")
						Response.Write("<div class=""progress"" style=""height: 2px; margin-top: 5px; margin-bottom: 0; padding-bottom: 0;"">")
							Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColorSLFFL & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercentSLFFL & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercentSLFFL & "%"">")
								Response.Write("<span class=""sr-only"">" & TeamPMRPercentSLFFL & "%</span>")
							Response.Write("</div>")
						Response.Write("</div>")
					Response.Write("</li>")
				Response.Write("</ul>")
			Response.Write("</div>")
			Response.Write("<div class=""col-sm-6"">")
				Response.Write("<ul class=""list-group"">")
					Response.Write("<li class=""list-group-item"">")
						Response.Write("<span class=""badge"" style=""font-size: 3em; background-color: #fff; color: #444444;"">" & TOTAL_Points_FARM & "</span>")
						Response.Write("<img src=""http://data.samelevel.net/assets/images/icons/farm.jpg"" style=""float: left; padding-right: 20px;"" />")
						Response.Write("<div style=""font-size: 16px""><b>" & medianFARM & "</b> <span style=""font-size: 14px;""><i>Median</i></span></div>")
						Response.Write("<div style=""font-size: 16px""><b>" & averageFARM & "</b> <span style=""font-size: 14px;""><i>Average</i></span></div>")
						Response.Write("<div class=""clearfix""></div>")
						Response.Write("<div class=""progress"" style=""height: 2px; margin-top: 5px; margin-bottom: 0; padding-bottom: 0;"">")
							Response.Write("<div class=""progress-bar progress-bar-" & TeamPMRColorFARM & """ role=""progressbar"" aria-valuenow=""" & TeamPMRPercentFARM & """ aria-valuemin=""0"" aria-valuemax=""100"" style=""width: " & TeamPMRPercentFARM & "%"">")
								Response.Write("<span class=""sr-only"">" & TeamPMRPercentFARM & "%</span>")
							Response.Write("</div>")
						Response.Write("</div>")
					Response.Write("</li>")
				Response.Write("</ul>")
			Response.Write("</div>")

		Response.Write("</div>")

	End Sub

	Function Median (ByVal NumericArray)

		arrLngAns = BubbleSortArray(NumericArray)

		If Not IsArray(arrLngAns) Then
			Err.Raise 30000, , "Invalid Data Passed to function"
			Exit Function
		End If

		lngElementCount = (UBound(arrLngAns) - LBound(arrLngAns)) + 1
		If UBound(arrLngAns) Mod 2 = 0 Then
			lngElement1 = CDbl(UBound(arrLngAns) / 2) + CDbl(LBound(arrLngAns) / 2)
		Else
			lngElement1 = CDbl(UBound(arrLngAns) / 2) + CDbl(LBound(arrLngAns) / 2) + 1
		End If

		If lngElementCount Mod 2 <> 0 Then
			dblAns = arrLngAns(lngElement1)
		Else
			lngElement2 = lngElement1 + 1
			dblSum = CDbl(arrLngAns(lngElement1)) + CDbl(arrLngAns(lngElement2))
			'Response.Write(dblSum)
			dblAns = dblSum / 2
		End If

		Median = dblAns

	End Function

	Function Average (ByVal NumericArray)

		Total = 0
		For Each TotalScore In NumericArray
			Total = Total + TotalScore
		Next

		Average = FormatNumber((Total / 12), 2)

	End Function

	Function BubbleSortArray (ByVal NumericArray)

		vAns = NumericArray

		If Not IsArray(vAns) Then
			BubbleSortArray = vbEmpty
			Exit Function
		End If

		lStart = LBound(vAns)
		lCount = UBound(vAns)
		bSorted = False

		Do While Not bSorted
			bSorted = True

			For lCtr = lCount - 1 To lStart Step -1
				If vAns(lCtr + 1) < vAns(lCtr) Then
					bSorted = False
					vTemp = vAns(lCtr)
					vAns(lCtr) = vAns(lCtr + 1)
					vAns(lCtr + 1) = vTemp
				End If
			Next
		Loop

		BubbleSortArray = vAns

	End Function

	Function FilterSpecialCharacters (OriginalText)

		EncodedText = OriginalText

		sqlGetSpecialCharacters = "SELECT * FROM SpecialCharacters"
		Set rsSpecialCharacters = sqlDatabase.Execute(sqlGetSpecialCharacters)

		Do While Not rsSpecialCharacters.Eof

			If InStr(EncodedText, rsSpecialCharacters("ActualCharacter")) Then EncodedText = Replace(EncodedText, rsSpecialCharacters("ActualCharacter"), rsSpecialCharacters("NumericCode"))

			rsSpecialCharacters.MoveNext

		Loop

		rsSpecialCharacters.Close
		Set rsSpecialCharacters = Nothing

		Do While (Right(EncodedText, 6) = "<br />")

			If Right(EncodedText, 6) = "<br />" Then EncodedText = Left(EncodedText, Len(EncodedText)-6)

		Loop

		FilterSpecialCharacters = EncodedText

	End Function

	Function NumberSuffix(thisNumber)

		NewNumber = thisNumber

		If Right(thisNumber, 2) = "11" Or Right(thisNumber, 2) = "12" Or Right(thisNumber, 2) = "13" Then

			NewNumber = NewNumber & "th"

		Else

			thisNumber = right(thisNumber, 1)

			Select Case thisNumber
				Case "1"
					NewNumber = NewNumber & "st"
				Case "2"
					NewNumber = NewNumber & "nd"
				Case "3"
					NewNumber = NewNumber & "rd"
				Case ""
					NewNumber = "error"
				Case Else
					NewNumber = NewNumber & "th"
			End Select

		End If

		NumberSuffix = NewNumber

	End Function
%>
