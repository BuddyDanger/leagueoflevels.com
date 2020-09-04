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
		liveSLFFL = "http://api.cbssports.com/fantasy/league/scoring/live?version=3.0&response_format=xml&league_id=samelevel&access_token=" & GetToken("OMEGA")
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

thisYear = 2019
thisPeriod = 2

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

WScript.Echo(vbcrlf & "Matchups Loaded...")

For i = 0 To UBound(arrOmega, 2)
											
	MatchupID = arrOmega(0, i)
	TeamID1 = arrOmega(2, i)
	TeamID2 = arrOmega(3, i)
	
	sqlGetTeams = "SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID1 & ";SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID2 & ";"
	Set rsTeams = sqlDatabase.Execute(sqlGetTeams)
	
	TeamCBSID1 = rsTeams("CBSID")
	Set rsTeams = rsTeams.NextRecordset()
	TeamCBSID2 = rsTeams("CBSID")
	
	rsTeams.Close
	Set rsTeams = Nothing
	WScript.Echo(vbcrlf & MatchupID & " - " & TeamCBSID1 & " - " & TeamCBSID2)
	Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
	oXML.loadXML(GetScores("OMEGA"))
	
	oXML.setProperty "SelectionLanguage", "XPath"
	Set objTeam1 = oXML.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")
	Set objTeam2 = oXML.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")
	
	Set objTeamScore1 = objTeam1.getElementsByTagName("pts")
	Set objTeamPMR1 = objTeam1.getElementsByTagName("pmr")
	
	Set objTeamScore2 = objTeam2.getElementsByTagName("pts")
	Set objTeamPMR2 = objTeam2.getElementsByTagName("pmr")
	
	TeamScore1 = CDbl(objTeamScore1.item(0).text)
	TeamPMR1 = CInt(objTeamPMR1.item(0).text)
	
	TeamScore2 = CDbl(objTeamScore2.item(0).text)
	TeamPMR2 = CInt(objTeamPMR2.item(0).text)
	
	sqlUpdate = "UPDATE Matchups SET TeamScore1 = " & TeamScore1 & ", TeamScore2 = " & TeamScore2 & ", TeamPMR1 = " & TeamPMR1 & ", TeamPMR2 = " & TeamPMR2 & " WHERE MatchupID = " & MatchupID
	Set rsUpdate = sqlDatabase.Execute(sqlUpdate)
	
Next

For i = 0 To UBound(arrCup, 2)
											
	MatchupID = arrCup(0, i)
	TeamID1 = arrCup(2, i)
	TeamID2 = arrCup(3, i)
	
	sqlGetTeams = "SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID1 & ";SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID2 & ";"
	Set rsTeams = sqlDatabase.Execute(sqlGetTeams)
	
	TeamCBSID1 = rsTeams("CBSID")
	Set rsTeams = rsTeams.NextRecordset()
	TeamCBSID2 = rsTeams("CBSID")
	
	rsTeams.Close
	Set rsTeams = Nothing
	
	Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
	oXML.loadXML(GetScores("CUP"))
	
	oXML.setProperty "SelectionLanguage", "XPath"
	Set objTeam1 = oXML.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")
	Set objTeam2 = oXML.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")
	
	Set objTeamScore1 = objTeam1.getElementsByTagName("pts")
	Set objTeamPMR1 = objTeam1.getElementsByTagName("pmr")
	
	Set objTeamScore2 = objTeam2.getElementsByTagName("pts")
	Set objTeamPMR2 = objTeam2.getElementsByTagName("pmr")
	
	TeamScore1 = CDbl(objTeamScore1.item(0).text)
	TeamPMR1 = CInt(objTeamPMR1.item(0).text)
	
	TeamScore2 = CDbl(objTeamScore2.item(0).text)
	TeamPMR2 = CInt(objTeamPMR2.item(0).text)
	
	sqlUpdate = "UPDATE Matchups SET TeamScore1 = " & TeamScore1 & ", TeamScore2 = " & TeamScore2 & ", TeamPMR1 = " & TeamPMR1 & ", TeamPMR2 = " & TeamPMR2 & " WHERE MatchupID = " & MatchupID
	Set rsUpdate = sqlDatabase.Execute(sqlUpdate)
	
Next

For i = 0 To UBound(arrSLFFL, 2)
											
	MatchupID = arrSLFFL(0, i)
	TeamID1 = arrSLFFL(2, i)
	TeamID2 = arrSLFFL(3, i)
	
	sqlGetTeams = "SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID1 & ";SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID2 & ";"
	Set rsTeams = sqlDatabase.Execute(sqlGetTeams)
	
	TeamCBSID1 = rsTeams("CBSID")
	Set rsTeams = rsTeams.NextRecordset()
	TeamCBSID2 = rsTeams("CBSID")
	
	rsTeams.Close
	Set rsTeams = Nothing
	
	Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
	oXML.loadXML(GetScores("SLFFL"))
	
	oXML.setProperty "SelectionLanguage", "XPath"
	Set objTeam1 = oXML.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")
	Set objTeam2 = oXML.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")
	
	Set objTeamScore1 = objTeam1.getElementsByTagName("pts")
	Set objTeamPMR1 = objTeam1.getElementsByTagName("pmr")
	
	Set objTeamScore2 = objTeam2.getElementsByTagName("pts")
	Set objTeamPMR2 = objTeam2.getElementsByTagName("pmr")
	
	TeamScore1 = CDbl(objTeamScore1.item(0).text)
	TeamPMR1 = CInt(objTeamPMR1.item(0).text)
	
	TeamScore2 = CDbl(objTeamScore2.item(0).text)
	TeamPMR2 = CInt(objTeamPMR2.item(0).text)
	
	sqlUpdate = "UPDATE Matchups SET TeamScore1 = " & TeamScore1 & ", TeamScore2 = " & TeamScore2 & ", TeamPMR1 = " & TeamPMR1 & ", TeamPMR2 = " & TeamPMR2 & " WHERE MatchupID = " & MatchupID
	Set rsUpdate = sqlDatabase.Execute(sqlUpdate)
	
Next

For i = 0 To UBound(arrFLFFL, 2)
											
	MatchupID = arrFLFFL(0, i)
	TeamID1 = arrFLFFL(2, i)
	TeamID2 = arrFLFFL(3, i)
	
	sqlGetTeams = "SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID1 & ";SELECT TeamName, CBSLogo, CBSID FROM Teams WHERE TeamID = " & TeamID2 & ";"
	Set rsTeams = sqlDatabase.Execute(sqlGetTeams)
	
	TeamCBSID1 = rsTeams("CBSID")
	Set rsTeams = rsTeams.NextRecordset()
	TeamCBSID2 = rsTeams("CBSID")
	
	rsTeams.Close
	Set rsTeams = Nothing
	
	Set oXML = CreateObject("MSXML2.DOMDocument.3.0")
	oXML.loadXML(GetScores("FLFFL"))
	
	oXML.setProperty "SelectionLanguage", "XPath"
	Set objTeam1 = oXML.selectSingleNode(".//team[@id = " & TeamCBSID1 & "]")
	Set objTeam2 = oXML.selectSingleNode(".//team[@id = " & TeamCBSID2 & "]")
	
	Set objTeamScore1 = objTeam1.getElementsByTagName("pts")
	Set objTeamPMR1 = objTeam1.getElementsByTagName("pmr")
	
	Set objTeamScore2 = objTeam2.getElementsByTagName("pts")
	Set objTeamPMR2 = objTeam2.getElementsByTagName("pmr")
	
	TeamScore1 = CDbl(objTeamScore1.item(0).text)
	TeamPMR1 = CInt(objTeamPMR1.item(0).text)
	
	TeamScore2 = CDbl(objTeamScore2.item(0).text)
	TeamPMR2 = CInt(objTeamPMR2.item(0).text)
	
	sqlUpdate = "UPDATE Matchups SET TeamScore1 = " & TeamScore1 & ", TeamScore2 = " & TeamScore2 & ", TeamPMR1 = " & TeamPMR1 & ", TeamPMR2 = " & TeamPMR2 & " WHERE MatchupID = " & MatchupID
	Set rsUpdate = sqlDatabase.Execute(sqlUpdate)
	
Next

EndTime = Now()

WScript.Echo(vbcrlf & StartTime)
WScript.Echo(vbcrlf & EndTime)