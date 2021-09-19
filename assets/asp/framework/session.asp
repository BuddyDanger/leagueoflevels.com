<%
	If Len(Session.Contents("CurrentYear")) = 0 Then

		sqlGetYearPeriod = "SELECT TOP 1 Year, Period FROM YearPeriods WHERE StartDate < GetDate() ORDER BY StartDate DESC"
		Set rsYearPeriod = sqlDatabase.Execute(sqlGetYearPeriod)

		If Not rsYearPeriod.Eof Then

			Session.Contents("CurrentYear") = rsYearPeriod("Year")
			Session.Contents("CurrentPeriod") = rsYearPeriod("Period")

			rsYearPeriod.Close
			Set rsYearPeriod = Nothing

		End If

	End If

	If Len(Session.Contents("EliminatorRound")) = 0 Then

		sqlGetEliminatorRound = "SELECT TOP 1 EliminatorRoundID FROM EliminatorRounds ORDER BY StartDate DESC"
		Set rsEliminatorRound = sqlDatabase.Execute(sqlGetEliminatorRound)

		If Not rsEliminatorRound.Eof Then

			Session.Contents("EliminatorRoundID") = rsEliminatorRound("EliminatorRoundID")

			rsEliminatorRound.Close
			Set rsEliminatorRound = Nothing

		End If

	End If

	If Len(Session.Contents("switchNFL")) = 0 Then Session.Contents("switchNFL") = 1
	If Len(Session.Contents("switchOMEGA")) = 0 Then Session.Contents("switchOMEGA") = 1
	If Len(Session.Contents("switchSLFFL")) = 0 Then Session.Contents("switchSLFFL") = 1
	If Len(Session.Contents("switchFLFFL")) = 0 Then Session.Contents("switchFLFFL") = 1
	If Len(Session.Contents("switchNEXT")) = 0 Then Session.Contents("switchNEXT") = 1

	If Session.Contents("LoggedIn") <> "yes" Then

		Session.Contents("LoggedIn") = "no"

		AccountID = Request.Cookies("AccountID")
		AccountHash = Request.Cookies("AccountHash")

		If InStr(AccountHash, "'") Then AccountHash = Replace(AccountHash, "'", "")
		If InStr(AccountID, "'") Then AccountID = Replace(AccountID, "'", "")

		If (Len(AccountHash) > 5) And IsNumeric(AccountID) Then

			sqlGetAccount = "SELECT * FROM Accounts WHERE AccountID = " & AccountID & " AND Password = '" & AccountHash & "'"
			Set rsAccount = sqlDatabase.Execute(sqlGetAccount)

			If Not rsAccount.Eof Then

				Response.Cookies("AccountID") = rsAccount("AccountID")
				Response.Cookies("AccountID").Expires = Date() + 365

				Response.Cookies("AccountHash") = rsAccount("Password")
				Response.Cookies("AccountHash").Expires = Date() + 365

				Session.Contents("LoggedIn") = "yes"
				Session.Contents("AccountID") = rsAccount("AccountID")
				Session.Contents("AccountHash") = rsAccount("Password")
				Session.Contents("AccountName") = rsAccount("ProfileName")
				Session.Contents("AccountProfileURL") = rsAccount("ProfileURL")
				Session.Contents("AccountImage") = rsAccount("ProfileImage")
				Session.Contents("AccountEmail") = rsAccount("Email")
				Session.Contents("AccountBalls") = rsAccount("Balls")

				rsAccount.Close
				Set rsAccount = Nothing

				sqlCheckTeams = "SELECT Teams.TeamID FROM LinkAccountsTeams INNER JOIN Teams ON Teams.TeamID = LinkAccountsTeams.TeamID WHERE LinkAccountsTeams.AccountID = " & Session.Contents("AccountID")
				Set rsTeams = sqlDatabase.Execute(sqlCheckTeams)

				If Not rsTeams.Eof Then

					Do While Not rsTeams.Eof

						thisTeamString = thisTeamString & rsTeams("TeamID") & ","
						rsTeams.MoveNext

					Loop

					rsTeams.Close
					Set rsTeams = Nothing

				End If

				If Right(thisTeamString, 1) = "," Then thisTeamString = Left(thisTeamString, Len(thisTeamString) - 1)

				Session.Contents("AccountTeams") = thisTeamString

			End If

		End If

	End If
%>
