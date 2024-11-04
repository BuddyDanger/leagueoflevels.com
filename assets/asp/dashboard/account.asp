
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

		sqlGetPowerRanking = "SELECT * FROM PowerRankings WHERE AccountID = " & Session.Contents("AccountID")
		Set rsPowerRanking = sqlDatabase.Execute(sqlGetPowerRanking)

		If Not rsPowerRanking.Eof Then

			thisCurrentPowerRanking = rsPowerRanking("PowerRanking")
			thisPowerRankPoints = rsPowerRanking("PowerPoints_Total")
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

			<ul class="list-group mb-4">
				<li class="list-group-item p-0">
					<h4 class="text-left bg-dark text-white p-3 mt-0 mb-0 rounded-top"><b>DASHBOARD</b><span class="float-right dripicons-meter"></i></h4>
				</li>
				<a class="list-group-item" href="/account/">
					<span class="float-right"><%= Session.Contents("AccountName") %></span>
					<div><b><i class="fas fa-fw fa-user"></i> &nbsp;ACCOUNT NAME</b></div>
				</a>
				<a class="list-group-item" href="/schmeckles/<%= Session.Contents("AccountProfileURL") %>/">
					<span class="float-right"><%= FormatNumber(thisSchmeckleSackBalance, 0) %></span>
					<div><b><i class="fas fa-fw fa-wallet"></i> &nbsp;SCHMECKLE SACK</b></div>
				</a>
				<!--
				<li class="list-group-item rounded-0">
					<span class="float-right"><%= Session.Contents("AccountBalls_Standard") %></span>
					<div><b><i class="fas fa-fw fa-wallet"></i> &nbsp;STANDARD BALLS</b></div>
				</li>
				<li class="list-group-item rounded-0">
					<span class="float-right"><%= Session.Contents("AccountBalls_Omega") %></span>
					<div><b><i class="fas fa-fw fa-wallet"></i> &nbsp;OMEGA BALLS</b></div>
				</li>
				-->
				<a class="list-group-item" href="/standings/">
					<span class="float-right"><%= thisCurrentWins %>-<%= thisCurrentLosses %>-<%= thisCurrentTies %></span>
					<div><b><i class="fas fa-fw fa-table"></i> &nbsp;CURRENT RECORD</b></div>
				</a>
				<a class="list-group-item" href="/standings/">
					<span class="float-right"><%= FormatNumber(thisCurrentPoints, 2) %></span>
					<div><b><i class="fas fa-fw fa-calculator"></i> &nbsp;POINTS SCORED</b></div>
				</a>
				<a class="list-group-item" href="/power-rankings/">
					<span class="float-right"><%= thisCurrentPowerRanking & ordsuffix %> (<%= thisPowerRankPoints %>/96)</span>
					<div><b><i class="fas fa-fw fa-star"></i> &nbsp;POWER RANKING</b></div>
				</a>
			</ul>

<%
	End If
%>
