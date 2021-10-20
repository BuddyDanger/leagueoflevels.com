<div class="card">
<%
	If Len(Session.Contents("AccountID")) > 0 Then

		If CInt(Session.Contents("AccountLocks")) = 0 Then noLocks = 1

		sqlGetFullMatchups = "SELECT MatchupID, Matchups.LevelID, TeamID1, TeamID2, T1.TeamName, T2.TeamName FROM Matchups "
		sqlGetFullMatchups = sqlGetFullMatchups & "INNER JOIN Teams T1 ON T1.TeamID = Matchups.TeamID1 "
		sqlGetFullMatchups = sqlGetFullMatchups & "INNER JOIN Teams T2 ON T2.TeamID = Matchups.TeamID2 "
		sqlGetFullMatchups = sqlGetFullMatchups & "WHERE Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & " AND "
		sqlGetFullMatchups = sqlGetFullMatchups & "((TeamID1 IN (" & Session.Contents("AccountTeams") & ") OR TeamID2 IN (" & Session.Contents("AccountTeams") & ")) AND (TeamPMR1 = 600 AND TeamPMR2 = 600) OR (TeamID1 IN (" & Session.Contents("AccountTeams") & ") OR TeamID2 IN (" & Session.Contents("AccountTeams") & ")) AND (TeamPMR1 = 420 AND TeamPMR2 = 420))"
		Set rsFullMatchups = sqlDatabase.Execute(sqlGetFullMatchups)

		If Not rsFullMatchups.Eof Then

			arrCurrentGames = rsFullMatchups.GetRows()
			thisAvailableOptionCount = UBound(arrCurrentGames, 2) + 1

			selectPlaceholder = "Browse " & thisAvailableOptionCount & " Available Options"
%>
			<div class="card-body pt-2 pb-2">

				<div style="border-bottom: 1px solid #e8ebf3;">
					<h4>Lockchain<span class="float-right"><i class="fas fa-link"></i></span></h4>
				</div>

<%
				If noLocks = 1 Then
%>
					<div class="row bg-light rounded mt-3 mb-2 pb-2 pt-2">
						<div class="col-4 text-center">
							<div><u><b>Locks</b></u></div>
							<div>0</div>
						</div>
						<div class="col-4 text-center">
							<div><u><b>Chain</b></u></div>
							<div>0x</div>
						</div>
						<div class="col-4 text-center">
							<div><u><b>Boost</b></u></div>
							<div>+100ML</div>
						</div>
					</div>
<%
				Else

					currentChain = 1
					currentBoost = 100

					sqlGetLockchain = "SELECT TicketSlipID, IsWinner FROM TicketSlips WHERE TicketTypeID = 5 AND IsWinner IS NOT NULL AND AccountID = " & Session.Contents("AccountID") & " ORDER BY InsertDateTime DESC"
					Set rsLockchain = sqlDatabase.Execute(sqlGetLockchain)

					If Not rsLockchain.Eof Then

						Do While Not rsLockchain.Eof

							thisWinner = rsLockchain("IsWinner")

							If thisWinner Then

								currentChain = currentChain + 1
								currentBoost = currentBoost + 20

							Else

								Exit Do

							End If

							rsLockchain.MoveNext

						Loop

						rsLockchain.Close
						Set rsLockchain = Nothing

					Else


					End If
%>
					<div class="row bg-light rounded mt-3 mb-3 pb-2 pt-2">
						<div class="col-4 text-center">
							<div><u><b>Locks</b></u></div>
							<div><%= Session.Contents("AccountLocks") %></div>
						</div>
						<div class="col-4 text-center">
							<div><u><b>Chain</b></u></div>
							<div><%= currentChain %>x</div>
						</div>
						<div class="col-4 text-center">
							<div><u><b>Boost</b></u></div>
							<div>+<%= currentBoost %>ML</div>
						</div>
					</div>

					<form action="/" method="post">

						<input type="hidden" name="action" value="lock" />
						<input type="hidden" name="inputMoneyline" value="<%= currentBoost %>" />

						<div class="form-group pb-0 mb-3">

							<select class="form-control form-control-lg" id="inputMatchupID" name="inputMatchupID">
								<option><%= selectPlaceholder %></option>
<%
								For i = 0 to UBound(arrCurrentGames, 2)

									sqlGetFullMatchups = "SELECT MatchupID, Matchups.LevelID, TeamID1, TeamID2, T1.TeamName, T2.TeamName FROM Matchups "

									thisMatchupID = arrCurrentGames(0, i)
									thisLevelID = arrCurrentGames(1, i)
									thisTeam1 = arrCurrentGames(4, i)
									thisTeam2 = arrCurrentGames(5, i)

									If thisHome = 1 Then
										opponentDisplay = "vs"
									Else
										opponentDisplay = "@"
									End If

									Response.Write("<option value=""" & thisMatchupID & """>" & thisTeam1 & " vs. " & thisTeam2 & "</option>")

								Next
%>
							</select>

							<button type="submit" class="btn btn-block btn-primary mt-3">Place Lock</button>

						</div>

					</form>
<%
				End If
%>
			</div>
<%
		Else
%>
			<div class="card-body pt-2 pb-2">

				<div style="border-bottom: 1px solid #e8ebf3;">
					<h4>Lockchain<span class="float-right"><i class="fas fa-link"></i></span></h4>
				</div>

				<div class="row bg-light rounded mt-3 mb-2 pb-2 pt-2">
					<div class="col-12 text-left">
						<div><b>OPENS WEDNESDAY</b></div>
					</div>
				</div>

			</div>
<%
		End If

	End If
%>

</div>
