<div class="card">
<%
	If Len(Session.Contents("AccountID")) > 0 Then

		thisSchmeckleSackBalance = 0

		sqlGetCurrentSchmeckleSack = "SELECT CurrentBalance FROM SchmeckleSacks WHERE AccountID = " & Session.Contents("AccountID")
		Set rsCurrentSchmeckleSack = sqlDatabase.Execute(sqlGetCurrentSchmeckleSack)

		If Not rsCurrentSchmeckleSack.Eof Then

			thisSchmeckleSackBalance = rsCurrentSchmeckleSack("CurrentBalance")
			rsCurrentSchmeckleSack.Close
			Set rsCurrentSchmeckleSack = Nothing

		End If

		sqlGetCurrentRecord = "SELECT TeamID, SUM(ActualWins) AS Wins, SUM(ActualLosses) AS Losses, SUM(ActualTies) AS Ties, SUM(PointsScored) AS Points FROM Standings WHERE (LevelID = 2 OR LevelID = 3) AND Year = " & Session.Contents("CurrentYear") & " AND TeamID IN (" & Session.Contents("AccountTeams") & ") GROUP BY TeamID"
		Set rsCurrentRecord = sqlDatabase.Execute(sqlGetCurrentRecord)

		If Not rsCurrentRecord.Eof Then

			thisCurrentWins = rsCurrentRecord("Wins")
			thisCurrentLosses = rsCurrentRecord("Losses")
			thisCurrentTies = rsCurrentRecord("Ties")
			thisCurrentPoints = rsCurrentRecord("Points")
			rsCurrentRecord.Close
			Set rsCurrentRecord = Nothing

		End If

		sqlGetAllTimeRecord = "SELECT TeamID, SUM(ActualWins) AS Wins, SUM(ActualLosses) AS Losses, SUM(ActualTies) AS Ties, SUM(PointsScored) AS Points FROM Standings WHERE (LevelID = 2 OR LevelID = 3) AND TeamID IN (" & Session.Contents("AccountTeams") & ") GROUP BY TeamID"
		Set rsAllTimeRecord = sqlDatabase.Execute(sqlGetAllTimeRecord)

		If Not rsAllTimeRecord.Eof Then

			thisAllTimeWins = rsAllTimeRecord("Wins")
			thisAllTimeLosses = rsAllTimeRecord("Losses")
			thisAllTimeTies = rsAllTimeRecord("Ties")
			thisAllTimePoints = rsAllTimeRecord("Points")
			rsAllTimeRecord.Close
			Set rsAllTimeRecord = Nothing

		End If

		sqlGetPowerRanking = "SELECT * FROM PowerRankings WHERE TeamID IN (" & Session.Contents("AccountTeams") & ")"
		Set rsPowerRanking = sqlDatabase.Execute(sqlGetPowerRanking)

		If Not rsPowerRanking.Eof Then

			thisCurrentPowerRanking = rsPowerRanking("PowerRanking")
			thisPowerRankPoints = rsPowerRanking("PowerRankPoints")
			Select Case CInt(thisCurrentPowerRanking)
				Case 1,21
				ordsuffix = "st"
				Case 2,22
				ordsuffix = "nd"
				Case 3,23
				ordsuffix = "rd"
				Case else
				ordsuffix = "th"
			End select
			rsPowerRanking.Close
			Set rsPowerRanking = Nothing

		End If
%>
		<div class="card-body rounded bg-dark pt-2 pb-2">

			<div style="border-bottom: 1px solid #e8ebf3;">
				<h4 class="text-white"><%= Session.Contents("AccountName") %><span class="float-right"><i class="fas fa-list-alt"></i></span></h4>
			</div>

			<div class="row mt-2 pb-2">
				<div class="col-12 col-xxl-4">

					<div class="row">
						<div class="col-6 col-xxl-12">
							<div class="pt-1 pb-2"><img src="https://samelevel.imgix.net/<%= Session.Contents("AccountImage") %>?w=500&h=500&fit=crop&crop=focalpoint" alt="" class="img-fluid rounded" /></div>
						</div>
						<div class="col-6 col-xxl-12">
							<div class="pt-1 pb-2"><a href="/account/" class="btn btn-sm btn-block btn-primary">SETTINGS</a></div>
						</div>
					</div>

				</div>
				<div class="col-12 col-xxl-8 pl-1 pr-1">

					<div class="row text-white mt-2 mt-xxl-0">
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>SCHMECKLES</b></div>
						<div class="col-6 col-xl-4 text-xl-right"><%= FormatNumber(thisSchmeckleSackBalance, 0) %></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>CURRENT RECORD</b></div>
						<div class="col-6 col-xl-4 text-xl-right"><%= thisCurrentWins %>-<%= thisCurrentLosses %>-<%= thisCurrentTies %></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>POINTS SCORED</b></div>
						<div class="col-6 col-xl-4 text-xl-right"><%= FormatNumber(thisCurrentPoints, 2) %></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>CAREER RECORD</b></div>
						<div class="col-6 col-xl-4 text-xl-right"><%= thisAllTimeWins %>-<%= thisAllTimeLosses %>-<%= thisAllTimeTies %></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>ALL-TIME POINTS</b></div>
						<div class="col-6 col-xl-4 text-xl-right"><%= FormatNumber(thisAllTimePoints, 2) %></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-7 text-right text-xl-left"><b>POWER RANKING</b></div>
						<div class="col-6 col-xl-5 text-xl-right"><%= thisCurrentPowerRanking & ordsuffix %> (<%= thisPowerRankPoints %>/72)</div>
					</div>

				</div>
			</div>

		</div>
<%
	End If
%>

</div>
