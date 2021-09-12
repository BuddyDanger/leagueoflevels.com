<div class="card">
<%
	If Len(Session.Contents("AccountID")) > 0 Then

		thisEliminatorRoundID = Session.Contents("EliminatorRoundID")
		'CHECK FOR INCORRECT ANSWER THIS ROUND'


		sqlGetCurrentPick = "SELECT * FROM EliminatorPicks INNER JOIN NFLTeams ON NFLTeams.NFLTeamID = EliminatorPicks.NFLTeamID WHERE AccountID = " & Session.Contents("AccountID") & " AND EliminatorRoundID = " & Session.Contents("EliminatorRoundID")
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
			selectPlaceholder = "Browse Available Options"

		End If

		sqlGetCurrentGames = "SELECT Team.[NFLTeamID] AS thisNFLTeamID, Team.[City] AS thisCity, Team.[Name] AS thisName, Team.[Abbreviation] AS thisAbbr, thisHome = 0, H.[City] AS opponentCity, H.[Name] AS opponentName, H.[Abbreviation] AS opponentAbbr FROM [dbo].[NFLTeams] Team INNER JOIN NFLGames A ON A.AwayTeamID = Team.NFLTeamID INNER JOIN NFLTeams H ON H.NFLTeamID = A.HomeTeamID "
		sqlGetCurrentGames = sqlGetCurrentGames & "WHERE ( A.Year = " & Session.Contents("CurrentYear") & " AND A.Period = " & Session.Contents("CurrentPeriod") & " AND A.DateTimeEST > '" & Now() & "') UNION ALL "
		sqlGetCurrentGames = sqlGetCurrentGames & "SELECT Team.[NFLTeamID] AS thisNFLTeamID, Team.[City] AS thisCity, Team.[Name] AS thisName, Team.[Abbreviation] AS thisAbbr, thisHome = 1, H.[City] AS opponentCity, H.[Name] AS opponentName, H.[Abbreviation] AS opponentAbbr FROM [dbo].[NFLTeams] Team INNER JOIN NFLGames A ON A.HomeTeamID = Team.NFLTeamID INNER JOIN NFLTeams H ON H.NFLTeamID = A.AwayTeamID "
		sqlGetCurrentGames = sqlGetCurrentGames & "WHERE ( A.Year = " & Session.Contents("CurrentYear") & " AND A.Period = " & Session.Contents("CurrentPeriod") & " AND A.DateTimeEST > DATEADD(hour, -4,'" & Now() & "')) ORDER BY thisCity"
		Set rsCurrentGames = sqlDatabase.Execute(sqlGetCurrentGames)
%>
		<div class="card-body pt-2 pb-2">

			<div style="border-bottom: 1px solid #e8ebf3;">
				<h4>Eliminator Challenge<span class="float-right"><i class="fas fa-skull"></i></span></h4>
			</div>

			<div class="row bg-light rounded mt-3 mb-3 pb-2 pt-2">
				<div class="col-4 text-center">
					<div><u><b>Period</b></u></div>
					<div><%= Session.Contents("CurrentPeriod") %></div>
				</div>
				<div class="col-4 text-center">
					<div><u><b>Survivors</b></u></div>
					<div>24</div>
				</div>
				<div class="col-4 text-center">
					<div><u><b>My Pick</b></u></div>
					<div><%= thisNFLCurrentPick %></div>
				</div>
			</div>

			<form action="/" method="post">

				<input type="hidden" name="action" value="pick" />

				<div class="form-group">

					<label class="col-form-label mt-0 pt-0"><b>32 Available Options</b></label>
					<select class="form-control form-control-lg" id="inputNFLTeamID" name="inputNFLTeamID">
						<option><%= selectPlaceholder %></option>
<%
						Do While Not rsCurrentGames.Eof

							thisHome = rsCurrentGames("thisHome")
							If thisHome = 1 Then
								opponentDisplay = "vs"
							Else
								opponentDisplay = "@"
							End If

							Response.Write("<option value=""" & rsCurrentGames("thisNFLTeamID") & """>" & rsCurrentGames("thisCity") & " " & rsCurrentGames("thisName") & " (" & opponentDisplay & " " & rsCurrentGames("opponentAbbr") & ")</option>")

							rsCurrentGames.MoveNext

						Loop
%>
					</select>

					<button type="submit" class="btn btn-block btn-primary mt-3">Submit Eliminator Pick</button>

				</div>

			</form>

		</div>
<%
	End If
%>

</div>
