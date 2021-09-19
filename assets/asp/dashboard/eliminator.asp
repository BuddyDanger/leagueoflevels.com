<div class="card">
<%
	If Len(Session.Contents("AccountID")) > 0 Then

		sqlGetCorrectPicks = "SELECT COUNT(*) AS TotalCorrectPicks FROM EliminatorPicks WHERE CorrectPick = 1 AND AccountID = " & Session.Contents("AccountID") & " AND EliminatorRoundID = " & Session.Contents("EliminatorRoundID") & " AND Year = " & Session.Contents("CurrentYear")
		Set rsCorrectPicks = sqlDatabase.Execute(sqlGetCorrectPicks)

		thisTotalCorrectPicks = rsCorrectPicks("TotalCorrectPicks")

		If thisTotalCorrectPicks < (Session.Contents("CurrentPeriod") - 1) Then thisAccountEliminated = 1

		rsCorrectPicks.Close
		Set rsCorrectPicks = Nothing

		thisEliminatorRoundID = Session.Contents("EliminatorRoundID")

		sqlGetSurvivors = "SELECT COUNT(*) AS TotalCorrect, AccountID FROM EliminatorPicks WHERE CorrectPick = 1 AND EliminatorRoundID = " & thisEliminatorRoundID & " GROUP BY AccountID"
		Set rsSurvivors = sqlDatabase.Execute(sqlGetSurvivors)

		arrSurvivors = rsSurvivors.GetRows()
		thisSurvivorCount = UBound(arrSurvivors, 2) + 1

		rsSurvivors.Close
		Set rsSurvivors = Nothing

		sqlGetCurrentGames = "SELECT Team.[NFLTeamID] AS thisNFLTeamID, Team.[City] AS thisCity, Team.[Name] AS thisName, Team.[Abbreviation] AS thisAbbr, thisHome = 0, H.[City] AS opponentCity, H.[Name] AS opponentName, H.[Abbreviation] AS opponentAbbr FROM [dbo].[NFLTeams] Team INNER JOIN NFLGames A ON A.AwayTeamID = Team.NFLTeamID INNER JOIN NFLTeams H ON H.NFLTeamID = A.HomeTeamID "
		sqlGetCurrentGames = sqlGetCurrentGames & "WHERE ( A.Year = " & Session.Contents("CurrentYear") & " AND A.Period = " & Session.Contents("CurrentPeriod") & " AND A.DateTimeEST > '" & DateAdd("h", -4, Now()) & "' AND Team.[NFLTeamID] NOT IN (SELECT NFLTeamID FROM EliminatorPicks WHERE AccountID = " & Session.Contents("AccountID") & " AND EliminatorRoundID = " & Session.Contents("EliminatorRoundID") & ")) UNION ALL "
		sqlGetCurrentGames = sqlGetCurrentGames & "SELECT Team.[NFLTeamID] AS thisNFLTeamID, Team.[City] AS thisCity, Team.[Name] AS thisName, Team.[Abbreviation] AS thisAbbr, thisHome = 1, H.[City] AS opponentCity, H.[Name] AS opponentName, H.[Abbreviation] AS opponentAbbr FROM [dbo].[NFLTeams] Team INNER JOIN NFLGames A ON A.HomeTeamID = Team.NFLTeamID INNER JOIN NFLTeams H ON H.NFLTeamID = A.AwayTeamID "
		sqlGetCurrentGames = sqlGetCurrentGames & "WHERE ( A.Year = " & Session.Contents("CurrentYear") & " AND A.Period = " & Session.Contents("CurrentPeriod") & " AND A.DateTimeEST > '" & DateAdd("h", -4, Now()) & "' AND Team.[NFLTeamID] NOT IN (SELECT NFLTeamID FROM EliminatorPicks WHERE AccountID = " & Session.Contents("AccountID") & " AND EliminatorRoundID = " & Session.Contents("EliminatorRoundID") & ")) ORDER BY thisCity"
		Set rsCurrentGames = sqlDatabase.Execute(sqlGetCurrentGames)

		arrCurrentGames = rsCurrentGames.GetRows()
		thisAvailableOptionCount = UBound(arrCurrentGames, 2) + 1

		sqlGetCurrentPick = "SELECT * FROM EliminatorPicks INNER JOIN NFLTeams ON NFLTeams.NFLTeamID = EliminatorPicks.NFLTeamID WHERE AccountID = " & Session.Contents("AccountID") & " AND EliminatorRoundID = " & Session.Contents("EliminatorRoundID") & " AND Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod")
		Set rsCurrentPick = sqlDatabase.Execute(sqlGetCurrentPick)

		If Not rsCurrentPick.Eof Then

			'ALREADY PICKED'
			alreadyPicked = 1
			thisEliminatorPickID = rsCurrentPick("EliminatorPickID")
			thisNFLTeamID = rsCurrentPick("NFLTeamID")
			thisNFLTeamAbbr = rsCurrentPick("Abbreviation")
			thisNFLTeamCity = rsCurrentPick("City")
			thisNFLTeamName = rsCurrentPick("Name")
			thisNFLCurrentPick = thisNFLTeamAbbr
			selectPlaceholder = "Change Your Selection"

			rsCurrentPick.Close
			Set rsCurrentPick = Nothing

		Else

			'READY TO PICK'
			alreadyPicked = 0
			thisNFLTeamID = 0
			thisNFLCurrentPick = "-"
			selectPlaceholder = "Browse " & thisAvailableOptionCount & " Available Options"

		End If
%>
		<div class="card-body pt-2 pb-2">

			<div style="border-bottom: 1px solid #e8ebf3;">
				<h4>Eliminator Challenge<span class="float-right"><i class="fas fa-skull"></i></span></h4>
			</div>

<%
			If thisAccountEliminated = 1 Then
%>
				<div class="row bg-light rounded mt-3 mb-3 pb-2 pt-2">
					<div class="col-4 text-center">
						<div><u><b>Period</b></u></div>
						<div><%= Session.Contents("CurrentPeriod") %></div>
					</div>
					<div class="col-4 text-center">
						<div><u><b>Survivors</b></u></div>
						<div><%= thisSurvivorCount %></div>
					</div>
					<div class="col-4 text-center">
						<div><u><b>My Pick</b></u></div>
						<div>ELIMINATED</div>
					</div>
				</div>
<%
			Else
%>
				<div class="row bg-light rounded mt-3 mb-3 pb-2 pt-2">
					<div class="col-4 text-center">
						<div><u><b>Period</b></u></div>
						<div><%= Session.Contents("CurrentPeriod") %></div>
					</div>
					<div class="col-4 text-center">
						<div><u><b>Survivors</b></u></div>
						<div><%= thisSurvivorCount %></div>
					</div>
					<div class="col-4 text-center">
						<div><u><b>My Pick</b></u></div>
						<div><%= thisNFLCurrentPick %></div>
					</div>
				</div>

				<form action="/" method="post">

					<input type="hidden" name="action" value="pick" />

					<div class="form-group">

						<select class="form-control form-control-lg" id="inputNFLTeamID" name="inputNFLTeamID">
							<option><%= selectPlaceholder %></option>
<%
							For i = 0 to UBound(arrCurrentGames, 2)

								thisNFLTeamID = arrCurrentGames(0, i)
								thisCity = arrCurrentGames(1, i)
								thisName = arrCurrentGames(2, i)
								thisAbbr = arrCurrentGames(3, i)
								thisHome = arrCurrentGames(4, i)
								opponentCity = arrCurrentGames(5, i)
								opponentName = arrCurrentGames(6, i)
								opponentAbbr = arrCurrentGames(7, i)

								If thisHome = 1 Then
									opponentDisplay = "vs"
								Else
									opponentDisplay = "@"
								End If

								Response.Write("<option value=""" & thisNFLTeamID & """>" & thisCity & " " & thisName & " (" & opponentDisplay & " " & opponentAbbr & ")</option>")

							Next
%>
						</select>

						<button type="submit" class="btn btn-block btn-primary mt-3">Submit Eliminator Pick</button>

					</div>

				</form>
<%
			End If
%>
		</div>
<%
	End If
%>

</div>
