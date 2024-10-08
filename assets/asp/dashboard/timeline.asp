<%
	arrTeams = Split(Session.Contents("AccountTeams"), ",")

	sqlGetRecentHistory = "SELECT TOP 8 M.MatchupID, L.LevelID, L.Title, M.Year, M.Period, M.IsPlayoffs, T1.TeamName AS Team1, M.TeamScore1, M.TeamOmegaTravel1, T2.TeamName AS Team2, M.TeamScore2, M.TeamOmegaTravel2, T1.TeamID AS TeamID1, T2.TeamID AS TeamID2, M.TeamPMR1, M.TeamPMR2 FROM Matchups M "
	sqlGetRecentHistory = sqlGetRecentHistory & "LEFT OUTER JOIN Levels L ON L.LevelID = M.LevelID "
	sqlGetRecentHistory = sqlGetRecentHistory & "INNER JOIN Teams T1 ON T1.TeamID = M.TeamID1 "
	sqlGetRecentHistory = sqlGetRecentHistory & "INNER JOIN Teams T2 ON T2.TeamID = M.TeamID2 "
	sqlGetRecentHistory = sqlGetRecentHistory & "WHERE ("

	For i = 0 To UBound(arrTeams)

		sqlGetRecentHistory = sqlGetRecentHistory & "M.TeamID1 = " & arrTeams(i) & " OR M.TeamID2 = " & arrTeams(i) & " OR "

	Next

	If Right(sqlGetRecentHistory, 3) = "OR " Then sqlGetRecentHistory = Left(sqlGetRecentHistory, Len(sqlGetRecentHistory) - 3)

	sqlGetRecentHistory = sqlGetRecentHistory & ") AND ((Year = " & Session.Contents("CurrentYear") & " AND Period <= " & Session.Contents("CurrentPeriod") & ") OR (Year = " & Session.Contents("CurrentYear") - 1 & "))  ORDER BY M.Year DESC, M.Period DESC, L.LevelID ASC"
	Set rsRecentHistory = sqlDatabase.Execute(sqlGetRecentHistory)

	If Not rsRecentHistory.Eof Then
%>
	<div class="card">
<%
		If Len(Session.Contents("AccountTeams")) > 0 Then
%>
			<div class="card-body pt-2 pb-0">

				<div style="border-bottom: 1px solid #e8ebf3;">
					<h4>My LOL Timeline<span class="float-right"><i class="fas fa-heartbeat"></i></span></h4>
				</div>

				<div class="activity mt-4 pt-3">
<%

					Do While Not rsRecentHistory.Eof

						thisYear = rsRecentHistory("Year")
						thisPeriod = rsRecentHistory("Period")
						thisLevelID = rsRecentHistory("LevelID")
						thisLevel = rsRecentHistory("Title")
						thisTeam1 = rsRecentHistory("Team1")
						thisTeam2 = rsRecentHistory("Team2")
						thisTeamID1 = rsRecentHistory("TeamID1")
						thisTeamID2 = rsRecentHistory("TeamID2")
						thisTeamScore1 = rsRecentHistory("TeamScore1")
						thisTeamScore2 = rsRecentHistory("TeamScore2")
						thisTeamOmegaTravel1 = rsRecentHistory("TeamOmegaTravel1")
						thisTeamOmegaTravel2 = rsRecentHistory("TeamOmegaTravel2")
						thisTeamPMR1 = CInt(rsRecentHistory("TeamPMR1"))
						thisTeamPMR2 = CInt(rsRecentHistory("TeamPMR2"))

						If thisLevelID = 1 And Not IsNull(thisTeamOmegaTravel1) Then
							thisTeamScore1 = thisTeamScore1 + thisTeamOmegaTravel1
							thisTeamScore2 = thisTeamScore2 + thisTeamOmegaTravel2
						End If

						If IsNull(thisLevel) Then thisLevel = "Next Level Cup"

						thisTotalPMR = thisTeamPMR1 + thisTeamPMR2

						winTeam1 = 0
						winTeam2 = 0
						isTeam1 = 0
						isTeam2 = 0
						isWin = 0
						isDone = 0

						If CInt(thisTotalPMR) = 0 And (CInt(thisTeamScore1) + CInt(thisTeamScore2)) > 0 Then isDone = 1

						If thisTeamScore1 > thisTeamScore2 Then winTeam1 = 1
						If thisTeamScore1 < thisTeamScore2 Then winTeam2 = 1

						For i = 0 To UBound(arrTeams)

							If CInt(arrTeams(i)) = CInt(thisTeamID1) Then isTeam1 = 1
							If CInt(arrTeams(i)) = CInt(thisTeamID2) Then isTeam2 = 1

						Next

						If isDone Then

							If isTeam1 And winTeam1 Then isWin = 1
							If isTeam2 And winTeam2 Then isWin = 1

							If isWin Then

								activityIcon = "<i class=""mdi mdi-trophy bg-soft-success""></i>"
								activityHeader = thisLevel & " Matchup Victory"

							Else

								activityIcon = "<i class=""mdi mdi-alert bg-soft-pink""></i>"
								activityHeader = thisLevel & " Matchup Loss"

							End If

						Else

							activityIcon = "<i class=""mdi mdi-football bg-soft-warning""></i>"
							activityHeader = thisLevel & " Matchup In Progress"

						End If

						If isTeam1 Then activityDescription = thisTeam1 & " (" & thisTeamScore1 & ") vs. " & thisTeam2 & " (" & thisTeamScore2 & ")"
						If isTeam2 Then activityDescription = thisTeam2 & " (" & thisTeamScore2 & ") vs. " & thisTeam1 & " (" & thisTeamScore1 & ")"
%>
						<div class="activity-info">
							<div class="icon-info-activity"><%= activityIcon %></div>
							<div class="item-info">
								<div class="d-flex justify-content-between align-items-center w-100">
									<div class="row w-100">
										<div class="col-12 col-xxl-9 pl-0 pr-0 mr-0">
											<h6 class="m-0"><%= activityHeader %></h6>
										</div>
										<div class="col-12 col-xxl-3 pl-0 pr-0 mr-0 text-xxl-right">
											<span class="text-muted d-block"><%= thisYear %> / Week <%= thisPeriod %></span>
										</div>
										<div class="col-12 pl-0 pr-0 mr-0"><p class="text-muted mt-2"><%= activityDescription %></p></div>
									</div>
								</div>
							</div>
						</div>
<%
						rsRecentHistory.MoveNext

					Loop
%>

				</div>

				<!--<button class="btn mt-2 btn-primary btn-sm btn-block">View Full Timeline</button>-->

			</div>
<%
		End If
%>
	</div>
<% End If %>
