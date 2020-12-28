<div class="row">

	<div class="col-12">
<%
		Response.Write("<div class=""row"">")

			For i = 0 To UBound(arrCup, 2)

				MatchupID = arrCup(0, i)
				TeamID1 = arrCup(2, i)
				TeamName1 = arrCup(3, i)
				TeamLogo1 = arrCup(4, i)
				TeamCBSID1 = arrCup(5, i)
				TeamID2 = arrCup(6, i)
				TeamName2 = arrCup(7, i)
				TeamLogo2 = arrCup(8, i)
				TeamCBSID2 = arrCup(9, i)
				TeamScore1 = FormatNumber(arrCup(10, i), 2)
				TeamScore2 = FormatNumber(arrCup(11, i), 2)
				TeamPMR1 = arrCup(12, i)
				TeamPMR2 = arrCup(13, i)
				Leg = arrCup(14, i)

				If CInt(Leg) = 2 Then

					sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & TeamID1 & " OR TeamID2 = " & TeamID1 & ") AND LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") - 1
					Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

					If CInt(rsLastWeek("TeamID1")) = CInt(TeamID1) Then BaseScore1 = rsLastWeek("TeamScore1")
					If CInt(rsLastWeek("TeamID2")) = CInt(TeamID1) Then BaseScore1 = rsLastWeek("TeamScore2")

					rsLastWeek.Close
					Set rsLastWeek = Nothing

					sqlGetLastWeek = "SELECT * FROM Matchups WHERE (TeamID1 = " & TeamID2 & " OR TeamID2 = " & TeamID2 & ") AND LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") - 1
					Set rsLastWeek = sqlDatabase.Execute(sqlGetLastWeek)

					If CInt(rsLastWeek("TeamID1")) = CInt(TeamID2) Then BaseScore2 = rsLastWeek("TeamScore1")
					If CInt(rsLastWeek("TeamID2")) = CInt(TeamID2) Then BaseScore2 = rsLastWeek("TeamScore2")

					rsLastWeek.Close
					Set rsLastWeek = Nothing


				End If

				TeamScore1 = FormatNumber(TeamScore1 + BaseScore1, 2)
				TeamScore2 = FormatNumber(TeamScore2 + BaseScore2, 2)

				TeamPMRColor1 = "success"
				If TeamPMR1 < 321 Then TeamPMRColor1 = "warning"
				If TeamPMR1 < 161 Then TeamPMRColor1 = "danger"
				TeamPMRPercent1 = (TeamPMR1 * 100) / 420

				TeamPMRColor2 = "success"
				If TeamPMR2 < 321 Then TeamPMRColor2 = "warning"
				If TeamPMR2 < 161 Then TeamPMRColor2 = "danger"
				TeamPMRPercent2 = (TeamPMR2 * 100) / 420

				If TeamID1 = 38 Then TeamName1 = "München"
				If TeamID2 = 38 Then TeamName2 = "München"

				If TeamID1 = 36 Then TeamName1 = "Hanging With Hern"
				If TeamID2 = 36 Then TeamName2 = "Hanging With Hern"

				If TeamID1 = 44 Then TeamName1 = "Overlords"
				If TeamID2 = 44 Then TeamName2 = "Overlords"
%>
				<div class="col-xxxl-3 col-xxl-3 col-xl-3 col-lg-6 col-md-6 col-sm-12">
					<a href="/scores/<%= MatchupID %>/" style="text-decoration: none; display: block;">
						<ul class="list-group" id="matchup-<%= MatchupID %>" style="margin-bottom: 1rem;">
							<li class="list-group-item" style="padding-top: 0.25rem; padding-bottom: 0.25rem; font-size: 0.75rem; text-align: center; background-color: #D00000; color: #fff;"><strong>NEXT LEVEL CUP</strong> #<%= MatchupID %></li>
							<li class="list-group-item team-cup-box-<%= TeamID1 %>">
								<span class="team-cup-score-<%= TeamID1 %>" style="font-size: 1em; background-color: #fff; color: #520000; float: right;"><%= TeamScore1 %></span>
								<span style="font-size: 13px; color: #520000;"><%= TeamName1 %></span>
								<div class="progress team-cup-progress-<%= TeamID1 %>" style="height: 1px; margin-top: 6px; margin-bottom: 0; padding-bottom: 0;">
									<div class="progress-bar progress-bar-<%= TeamPMRColor1 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent1 %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= TeamPMRPercent1 %>%">
										<span class="sr-only team-cup-progress-sr-<%= TeamID1 %>"><%= TeamPMRPercent1 %>%</span>
									</div>
								</div>
							</li>
							<li class="list-group-item team-cup-box-<%= TeamID2 %>">
								<span class="team-cup-score-<%= TeamID2 %>" style="font-size: 1em; background-color: #fff; color: #520000; float: right;"><%= TeamScore2 %></span>
								<span style="font-size: 13px; color: #520000;"><%= TeamName2 %></span>
								<div class="progress team-cup-progress-<%= TeamID2 %>" style="height: 1px; margin-top: 4px; margin-bottom: 0; padding-bottom: 0;">
									<div class="progress-bar progress-bar-<%= TeamPMRColor2 %>" role="progressbar" aria-valuenow="<%= TeamPMRPercent2 %>" aria-valuemin="0" aria-valuemax="<%= TeamPMRPercent2 %>" style="width: <%= TeamPMRPercent2 %>%">
										<span class="sr-only team-cup-progress-sr-<%= TeamID2 %>"><%= TeamPMRPercent2 %>%</span>
									</div>
								</div>
							</li>
						</ul>
					</a>
				</div>
<%
			Next

		Response.Write("</div>")
%>
	</div>

</div>
