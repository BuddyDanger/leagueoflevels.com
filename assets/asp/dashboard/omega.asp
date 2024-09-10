<%
	sqlCheckOmega = "SELECT Teams.TeamID, TeamName, OmegaLocations.OmegaLocationID, OmegaLocations.LocationTitle AS OmegaLocationTitle, OmegaLocations.LocationSafeTitle AS OmegaLocationSafeTitle FROM Teams INNER JOIN LinkAccountsTeams ON LinkAccountsTeams.TeamID = Teams.TeamID INNER JOIN Accounts ON Accounts.AccountID = LinkAccountsTeams.AccountID INNER JOIN OmegaLinkLocationsTeams ON OmegaLinkLocationsTeams.TeamID = Teams.TeamID INNER JOIN OmegaLocations ON OmegaLocations.OmegaLocationID = OmegaLinkLocationsTeams.LocationID WHERE LevelID = 1 AND EndYear = 0 AND Accounts.AccountID = " & Session.Contents("AccountID")
	Set rsOmega = sqlDatabase.Execute(sqlCheckOmega)

	If Not rsOmega.Eof Then
%>
		<div class="card">
<%
			If Len(Session.Contents("AccountID")) > 0 Then

				Session.Contents("Account_OmegaTeamID") = rsOmega("TeamID")
				Session.Contents("Account_OmegaTeamName") = rsOmega("TeamName")
				Session.Contents("Account_OmegaHomeLocationID") = rsOmega("OmegaLocationID")
				Session.Contents("Account_OmegaHomeLocationTitle") = rsOmega("OmegaLocationTitle")
				Session.Contents("Account_OmegaHomeLocationSafeTitle") = rsOmega("OmegaLocationSafeTitle")
				rsOmega.Close
				Set rsOmega = Nothing

				sqlCheckPreviousWeek = "SELECT MatchupID, TeamID1, TeamID2, TeamScore1, TeamScore2, (CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID1 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID2 ELSE NULL END) AS WinnerID, (CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID2 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID1 ELSE NULL END) AS LoserID FROM Matchups WHERE LEVELID = 1 AND YEAR = 2024 AND PERIOD = " & Session.Contents("CurrentPeriod") - 1 & " AND ((CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID1 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID2 ELSE NULL END) = " & Session.Contents("Account_OmegaTeamID") & " OR (CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID2 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID1 ELSE NULL END) = " & Session.Contents("Account_OmegaTeamID") & ")"
				Set rsPreviousWeek = sqlDatabase.Execute(sqlCheckPreviousWeek)

				Session.Contents("Account_PreviousOutcome") = ""

				If Not rsPreviousWeek.Eof Then

					Session.Contents("Account_PreviousLocationID") = rsPreviousWeek("TeamID2")
					If Session.Contents("Account_OmegaTeamID") = rsPreviousWeek("WinnerID") Then Session.Contents("Account_PreviousOutcome") = "W"
					If Session.Contents("Account_OmegaTeamID") = rsPreviousWeek("LoserID") Then Session.Contents("Account_PreviousOutcome") = "L"

					rsPreviousWeek.Close
					Set rsPreviousWeek = Nothing

				End If

				sqlCheckThisWeek = "SELECT MatchupID, TeamID1, TeamID2, TeamScore1, TeamScore2, (CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID1 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID2 ELSE NULL END) AS WinnerID, (CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID2 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID1 ELSE NULL END) AS LoserID FROM Matchups WHERE LEVELID = 1 AND YEAR = 2024 AND PERIOD = " & Session.Contents("CurrentPeriod") & " AND ((CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID1 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID2 ELSE NULL END) = " & Session.Contents("Account_OmegaTeamID") & " OR (CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID2 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID1 ELSE NULL END) = " & Session.Contents("Account_OmegaTeamID") & ")"
				Set rsThisWeek = sqlDatabase.Execute(sqlCheckThisWeek)

				Session.Contents("Account_ThisOutcome") = ""

				If Not rsThisWeek.Eof Then

					If Session.Contents("Account_OmegaTeamID") = rsThisWeek("WinnerID") Then Session.Contents("Account_ThisOutcome") = "W"
					If Session.Contents("Account_OmegaTeamID") = rsThisWeek("LoserID") Then Session.Contents("Account_ThisOutcome") = "L"

					rsThisWeek.Close
					Set rsThisWeek = Nothing

				Else
					Session.Contents("Account_ThisOutcome") = "B"
				End If

				sqlGetCurrentLocation = "SELECT OmegaLocations.OmegaLocationID AS CurrentLocationID, OmegaLocations.LocationTitle AS CurrentLocationTitle, OmegaLocations.LocationSafeTitle AS CurrentLocationSafeTitle FROM OmegaMoves INNER JOIN OmegaLocations ON OmegaLocations.OmegaLocationID = EndingLocationID WHERE Year = " & Session.Contents("CurrentYear") & " AND TEAMID = " & Session.Contents("Account_OmegaTeamID") & " ORDER BY OmegaMoveID DESC"
				Set rsCurrentLocation = sqlDatabase.Execute(sqlGetCurrentLocation)

				If Not rsCurrentLocation.Eof Then

					Session.Contents("Account_OmegaCurrentLocationID") = rsCurrentLocation("CurrentLocationID")
					Session.Contents("Account_OmegaCurrentLocationTitle") = rsCurrentLocation("CurrentLocationTitle")
					Session.Contents("Account_OmegaCurrentLocationSafeTitle") = rsCurrentLocation("CurrentLocationSafeTitle")

					rsCurrentLocation.Close
					Set rsCurrentLocation = Nothing

				End If

				thisDateTime_EST = DateAdd("h", -4, Now())
				thisWinnersSelect_EST = DateAdd("h", -4, Session.Contents("OmegaSelectionsOpening"))
				thissWinnersSelectCloses_EST = DateAdd("d", 1, thisWinnersSelect_EST)
				thisNextOpenSelect_EST = DateAdd("h", -4, DateAdd("d", 7, Session.Contents("CurrentPeriodStart")))
				thisOpenSelect_EST = DateAdd("h", -4, Session.Contents("CurrentPeriodStart"))
				thisOpenSelectCloses_EST = DateAdd("d", 1, thisOpenSelect_EST)
%>
				<div class="card-body pt-2 pb-2">

					<div style="border-bottom: 1px solid #e8ebf3;">
						<h4>Omega Battleworld<span class="float-right"><i class="fas fa-globe"></i></span></h4>
					</div>

					<div class="row bg-light rounded mt-3 mb-2 pb-2 pt-2">
						<div class="col-4 text-center">
							<div><u><b>Hometown</b></u></div>
							<div><%= Session.Contents("Account_OmegaHomeLocationTitle") %></div>
						</div>
						<div class="col-4 text-center">
							<div><u><b>Current Location</b></u></div>
							<div><%= Session.Contents("Account_OmegaCurrentLocationTitle") %></div>
						</div>
						<div class="col-4 text-center">
							<div><u><b>Last Week</b></u></div>
							<div><%= Session.Contents("Account_ThisOutcome") %></div>
						</div>
					</div>

					<!--
					<div>Now: <%= thisDateTime_EST %></div>
					<div>Winners: <%= thisWinnersSelect_EST %></div>
					<div>Winners Close: <%= thissWinnersSelectCloses_EST %></div>
					<div>Next Open: <%= thisNextOpenSelect_EST %></div>
					<div>Open: <%= thisOpenSelect_EST %></div>
					<div>Close: <%= thisOpenSelectCloses_EST %></div>
					-->
<%
					If (thisDateTime_EST >  thisOpenSelect_EST) And (thisDateTime_EST < thisOpenSelectCloses_EST) Then

						'OPEN SELECT FOR THIS PERIOD'
						'WEDNESDAY 930 - THURSDAY 930'

						'CHECK IF ALREADY PICKED'
						sqlGetNextWeek = "SELECT * FROM Matchups WHERE Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & " AND (TeamID1 = " & Session.Contents("Account_OmegaTeamID") & " OR TeamID2 = " & Session.Contents("Account_OmegaTeamID") & ")"
						Set rsNextWeek = sqlDatabase.Execute(sqlGetNextWeek)

						If rsNextWeek.Eof Then

							'BUILD LIST OF UNSELECTED TEAMS'
							sqlGetUnselected = "SELECT OmegaLocationID, OmegaPaths.OmegaPathID, Teams.TeamID, Teams.TeamName, OmegaPaths.StartingLocationID, OmegaPaths.EndingLocationID, OmegaPaths.LandDistance, OmegaPaths.WaterDistance, OmegaPaths.LandDistance, OmegaPaths.TotalDistance, OmegaPaths.TravelPenalty FROM OmegaLocations "
							sqlGetUnselected = sqlGetUnselected & "INNER JOIN OmegaLinkLocationsTeams ON OmegaLinkLocationsTeams.LocationID = OmegaLocations.OmegaLocationID "
							sqlGetUnselected = sqlGetUnselected & "INNER JOIN Teams ON Teams.TeamID = OmegaLinkLocationsTeams.TeamID "
							sqlGetUnselected = sqlGetUnselected & "INNER JOIN OmegaPaths ON OmegaPaths.EndingLocationID = OmegaLinkLocationsTeams.LocationID "
							sqlGetUnselected = sqlGetUnselected & "WHERE OmegaPaths.StartingLocationID = " & Session.Contents("Account_OmegaCurrentLocationID") & " AND "
							sqlGetUnselected = sqlGetUnselected & "Teams.TeamID NOT IN (SELECT [TeamID1] FROM [dbo].[Matchups] WHERE YEAR = " & Session.Contents("CurrentYear") & " AND PERIOD = " & Session.Contents("CurrentPeriod") & " AND LEVELID = 1) AND "
							sqlGetUnselected = sqlGetUnselected & "Teams.TeamID NOT IN (SELECT [TeamID2] FROM [dbo].[Matchups] WHERE YEAR = " & Session.Contents("CurrentYear") & " AND PERIOD = " & Session.Contents("CurrentPeriod") & " AND LEVELID = 1) AND "
							sqlGetUnselected = sqlGetUnselected & "Teams.TeamID NOT IN (" & Session.Contents("Account_OmegaTeamID") & ")"

							Set rsUnselected = sqlDatabase.Execute(sqlGetUnselected)
%>
							<form action="/" method="post">

								<input type="hidden" name="action" value="omega" />
								<input type="hidden" name="inputPeriod" value="<%= Session.Contents("CurrentPeriod") %>" />
								<div class="form-group pb-0 mb-3">

									<select class="form-control form-control-lg" id="inputOmegaPathID" name="inputOmegaPathID" <% If alreadyPlayed Then %>disabled<% End If %>>
										<option></option>
<%
										Do While Not rsUnselected.Eof

											Response.Write("<option value=""" & rsUnselected("OmegaPathID") & """>" & rsUnselected("TeamName") & " (" & rsUnselected("TravelPenalty") & " Penalty)</option>")

											rsUnselected.MoveNext

										Loop

										rsUnselected.Close
										Set rsUnselected = Nothing
%>
									</select>

									<button type="submit" class="btn btn-block btn-primary mt-3">Set Destination</button>

								</div>

							</form>
<%
						Else
%>
							<div class="form-group pb-0 mb-2 text-center"><b>ALREADY FIGHTING WEEK <%= Session.Contents("CurrentPeriod") %> OPPONENT</b></div>
<%
							rsNextWeek.Close
							Set rsNextWeek = Nothing

						End If

					ElseIf (thisDateTime_EST >  thisWinnersSelect_EST) And (thisDateTime_EST <  thissWinnersSelectCloses_EST) And (Session.Contents("Account_ThisOutcome") = "W" OR Session.Contents("Account_ThisOutcome") = "B") Then

						'WINNERS SELECT FOR NEXT PERIOD'
						'TUESDAY 930 - WEDNESDAY 930'

						'CHECK IF ALREADY PICKED'
						sqlGetNextWeek = "SELECT * FROM Matchups WHERE Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") + 1 & " AND TeamID1 = " & Session.Contents("Account_OmegaTeamID")
						Set rsNextWeek = sqlDatabase.Execute(sqlGetNextWeek)

						If rsNextWeek.Eof Then

							'BUILD LIST OF UNSELECTED CURRENT PERIOD LOSERS'
							sqlUnselectedLosers = "SELECT OmegaLocationID, OmegaPaths.OmegaPathID, Teams.TeamID, Teams.TeamName, OmegaPaths.StartingLocationID, OmegaPaths.EndingLocationID, OmegaPaths.LandDistance, OmegaPaths.WaterDistance, OmegaPaths.LandDistance, OmegaPaths.TotalDistance, OmegaPaths.TravelPenalty FROM OmegaLocations "
							sqlUnselectedLosers = sqlUnselectedLosers & "INNER JOIN OmegaLinkLocationsTeams ON OmegaLinkLocationsTeams.LocationID = OmegaLocations.OmegaLocationID "
							sqlUnselectedLosers = sqlUnselectedLosers & "INNER JOIN Teams ON Teams.TeamID = OmegaLinkLocationsTeams.TeamID "
							sqlUnselectedLosers = sqlUnselectedLosers & "INNER JOIN OmegaPaths ON OmegaPaths.EndingLocationID = OmegaLinkLocationsTeams.LocationID "
							sqlUnselectedLosers = sqlUnselectedLosers & "WHERE OmegaPaths.StartingLocationID = " & Session.Contents("Account_OmegaCurrentLocationID") & " AND Teams.TeamID IN ( "
							sqlUnselectedLosers = sqlUnselectedLosers & "SELECT (CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID2 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID1 WHEN TeamID2 = 99999 THEN TeamID1 ELSE TeamID1 END) AS LoserID FROM Matchups "
							sqlUnselectedLosers = sqlUnselectedLosers & "WHERE LEVELID = 1 AND YEAR = " & Session.Contents("CurrentYear") & " AND PERIOD = " & Session.Contents("CurrentPeriod") & " AND (CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID2 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID1 WHEN TeamID2 = 99999 THEN TeamID1 ELSE NULL END) NOT IN (SELECT [TeamID2] FROM [dbo].[Matchups] WHERE YEAR = " & Session.Contents("CurrentYear") & " AND PERIOD = " & Session.Contents("CurrentPeriod") + 1 & " AND LEVELID = 1) AND (CASE WHEN (TeamScore1 + TeamOmegaTravel1) > TeamScore2 THEN TeamID2 WHEN TeamScore2 > (TeamScore1 + TeamOmegaTravel1) THEN TeamID1 WHEN TeamID2 = 99999 THEN TeamID1 ELSE NULL END) NOT IN (" & Session.Contents("Account_OmegaTeamID") & "))"

							Set rsUnselectedLosers = sqlDatabase.Execute(sqlUnselectedLosers)
%>
							<form action="/" method="post">

								<input type="hidden" name="action" value="omega" />
								<input type="hidden" name="inputPeriod" value="<%= Session.Contents("CurrentPeriod") + 1 %>" />
								<div class="form-group pb-0 mb-3">

									<select class="form-control form-control-lg" id="inputOmegaPathID" name="inputOmegaPathID" <% If alreadyPlayed Then %>disabled<% End If %>>
										<option></option>
<%
										Do While Not rsUnselectedLosers.Eof

											Response.Write("<option value=""" & rsUnselectedLosers("OmegaPathID") & """>" & rsUnselectedLosers("TeamName") & " (" & rsUnselectedLosers("TravelPenalty") & " Penalty)</option>")

											rsUnselectedLosers.MoveNext

										Loop

										rsUnselectedLosers.Close
										Set rsUnselectedLosers = Nothing
%>
									</select>

									<button type="submit" class="btn btn-block btn-primary mt-3">Set Destination</button>

								</div>

							</form>
<%
						Else
%>
							<div class="form-group pb-0 mb-2 text-center"><b>ALREADY SELECTED WEEK <%= Session.Contents("CurrentPeriod") + 1 %> OPPONENT</b></div>
<%
							rsNextWeek.Close
							Set rsNextWeek = Nothing

						End If

					Else

						'LOCKED FOR WEEK'
						'THURSDAY 930 - TUESDAY 930'
%>
						<div class="row bg-light rounded mt-3 mb-2 pb-2 pt-2">
							<div class="col-12 text-left">
								<div><b>OPENS <%= thisNextOpenSelect_EST %></b></div>
							</div>
						</div>
<%
					End If
%>
					<div class="row bg-light rounded py-3 px-1">
						<div class="col-12">
							<a href="https://samelevel.imgix.net/omega-battleworld.jpg" target="_blank"><img src="https://samelevel.imgix.net/omega-battleworld.jpg?fm=webp&auto=format&w=500&h=auto" class="img-fluid rounded" /></a>
						</div>
					</div>

				</div>
<%
			End If
%>

		</div>
<%
	End If
%>
