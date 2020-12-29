<% If Session.Contents("LoggedIn") = "yes" Then %>
<div class="row">
<%
	sqlGetTicketSlips = "SELECT TicketSlipID, TicketTypeID, TicketSlips.AccountID, Accounts.ProfileName, TicketSlips.InsertDateTime, Matchups.TeamID1, Matchups.TeamID2, Matchups.TeamScore1, Matchups.TeamScore2, T1.TeamName AS TeamName1, T2.TeamName AS TeamName2, T3.TeamName AS BetTeamName, TicketSlips.TeamID, TicketSlips.Moneyline, TicketSlips.Spread, TicketSlips.OverUnderAmount, OverUnderBet, TicketSlips.BetAmount, TicketSlips.PayoutAmount, TicketSlips.IsWinner FROM TicketSlips "
	sqlGetTicketSlips = sqlGetTicketSlips & "INNER JOIN Accounts ON Accounts.AccountID = TicketSlips.AccountID "
	sqlGetTicketSlips = sqlGetTicketSlips & "INNER JOIN Matchups ON Matchups.MatchupID = TicketSlips.MatchupID "
	sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN Teams T1 ON T1.TeamID = Matchups.TeamID1 "
	sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN Teams T2 ON T2.TeamID = Matchups.TeamID2 "
	sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN Teams T3 ON T3.TeamID = TicketSlips.TeamID "
	sqlGetTicketSlips = sqlGetTicketSlips & "WHERE TicketSlips.AccountID = " & Session.Contents("AccountID") & " AND DateProcessed IS NULL AND IsNFL = 0"
	Set rsTicketSlips = sqlDatabase.Execute(sqlGetTicketSlips)

	Do While Not rsTicketSlips.Eof

		thisTicketSlipID = rsTicketSlips("TicketSlipID")
		thisTicketTypeID = rsTicketSlips("TicketTypeID")
		thisAccountID = rsTicketSlips("AccountID")
		thisProfileName = rsTicketSlips("ProfileName")
		thisInsertDateTime = rsTicketSlips("InsertDateTime")
		thisTeamName1 = rsTicketSlips("TeamName1")
		thisTeamName2 = rsTicketSlips("TeamName2")
		thisTeamScore1 = rsTicketSlips("TeamScore1")
		thisTeamScore2 = rsTicketSlips("TeamScore2")
		thisBetTeamName = rsTicketSlips("BetTeamName")
		thisMoneyline = rsTicketSlips("Moneyline")
		thisSpread = rsTicketSlips("Spread")
		thisOverUnderAmount = rsTicketSlips("OverUnderAmount")
		thisOverUnderBet = rsTicketSlips("OverUnderBet")
		thisBetAmount = rsTicketSlips("BetAmount")
		thisPayoutAmount = rsTicketSlips("PayoutAmount")
		thisIsWinner = rsTicketSlips("IsWinner")

		If CInt(thisTicketTypeID) = 1 Then
			If thisMoneyline > 0 Then thisMoneyline = "+" & thisMoneyline
			thisTicketDetails = thisMoneyline & " ML"
		End If
		If CInt(thisTicketTypeID) = 2 Then
			If thisSpread > 0 Then thisSpread = "+" & thisSpread
			thisTicketDetails = "(" & thisSpread & ")"
		End If
		If CInt(thisTicketTypeID) = 3 Then
			thisTicketDetails = thisOverUnderBet & " (" & thisOverUnderAmount & ")"
		End If
%>
		<div class="col-xxxl-3 col-xxl-3 col-xl-4 col-lg-4 col-md-4 col-sm-12 col-xs-12 col-xxs-12">
			<ul class="list-group" style="margin-bottom: 1rem;">
				<li class="list-group-item text-center">
					<div><b><%= thisBetTeamName %>&nbsp;<%= thisTicketDetails %></b></div>
					<div><i><%= thisInsertDateTime %> (UTC)</i></div>
					<div class="row pt-2">
						<div class="col-6" style="border-right: 1px dashed #edebf1;">
							<div><u>WAGER</u></div>
							<div><%= FormatNumber(thisBetAmount, 0) %></div>
						</div>
						<div class="col-6">
							<div><u>PAYOUT</u></div>
							<div><%= FormatNumber(thisPayoutAmount, 0) %></div>
						</div>
					</div>
				</li>
<%
				If CInt(thisTicketTypeID) = 3 Then
%>
					<li class="list-group-item text-center">
						<div class="row pt-2">
							<div class="col-6" style="border-right: 1px dashed #edebf1;">
								<div><%= thisTeamName1 %></div>
								<div><%= thisTeamScore1 %></div>
							</div>
							<div class="col-6">
								<div><%= thisTeamName2 %></div>
								<div><%= thisTeamScore2 %></div>
							</div>
						</div>
					</li>
<%
				Else
%>
					<li class="list-group-item text-center">
						<div class="row pt-2">
							<div class="col-6" style="border-right: 1px dashed #edebf1;">
								<div><%= thisTeamName1 %></div>
								<div><%= thisTeamScore1 %></div>
							</div>
							<div class="col-6">
								<div><%= thisTeamName2 %></div>
								<div><%= thisTeamScore2 %></div>
							</div>
						</div>
					</li>
<%
				End If
%>
				<li class="list-group-item text-center">
					<div><b>Ticket Owner:</b> <%= thisProfileName %></div>
				</li>
			</ul>
		</div>
<%
		rsTicketSlips.MoveNext

	Loop

	sqlGetTicketSlips = "SELECT TicketSlipID, TicketTypeID, TicketSlips.AccountID, Accounts.ProfileName, DateAdd(hour, -5, TicketSlips.InsertDateTime) AS InsertDateTime, T1.Abbreviation AS AwayAbbr, T2.Abbreviation AS HomeAbbr, NFLGames.AwayTeamID AS TeamID1, NFLGames.HomeTeamID AS TeamID2, T1.City + ' ' + T1.Name AS TeamName1, T2.City + ' ' + T2.Name AS TeamName2, T3.City + ' ' + T3.Name AS BetTeamName, TicketSlips.TeamID, TicketSlips.Moneyline, TicketSlips.Spread, TicketSlips.OverUnderAmount, OverUnderBet, TicketSlips.BetAmount, TicketSlips.PayoutAmount, TicketSlips.IsWinner FROM TicketSlips "
	sqlGetTicketSlips = sqlGetTicketSlips & "INNER JOIN Accounts ON Accounts.AccountID = TicketSlips.AccountID "
	sqlGetTicketSlips = sqlGetTicketSlips & "INNER JOIN NFLGames ON NFLGames.NFLGameID = TicketSlips.MatchupID "
	sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN NFLTeams T1 ON T1.NFLTeamID = NFLGames.AwayTeamID "
	sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN NFLTeams T2 ON T2.NFLTeamID = NFLGames.HomeTeamID "
	sqlGetTicketSlips = sqlGetTicketSlips & "LEFT JOIN NFLTeams T3 ON T3.NFLTeamID = TicketSlips.TeamID "
	sqlGetTicketSlips = sqlGetTicketSlips & "WHERE TicketSlips.AccountID = " & Session.Contents("AccountID") & " AND TicketSlips.DateProcessed IS NULL AND IsNFL = 1"

	Set rsTicketSlips = sqlDatabase.Execute(sqlGetTicketSlips)

	Do While Not rsTicketSlips.Eof

		thisTicketSlipID = rsTicketSlips("TicketSlipID")
		thisTicketTypeID = rsTicketSlips("TicketTypeID")
		thisAccountID = rsTicketSlips("AccountID")
		thisProfileName = rsTicketSlips("ProfileName")
		thisInsertDateTime = rsTicketSlips("InsertDateTime")
		thisTeamAbbr1 = rsTicketSlips("AwayAbbr")
		thisTeamAbbr2 = rsTicketSlips("HomeAbbr")
		thisTeamName1 = rsTicketSlips("TeamName1")
		thisTeamName2 = rsTicketSlips("TeamName2")
		thisBetTeamName = rsTicketSlips("BetTeamName")
		thisMoneyline = rsTicketSlips("Moneyline")
		thisSpread = rsTicketSlips("Spread")
		thisOverUnderAmount = rsTicketSlips("OverUnderAmount")
		thisOverUnderBet = rsTicketSlips("OverUnderBet")
		thisBetAmount = rsTicketSlips("BetAmount")
		thisPayoutAmount = rsTicketSlips("PayoutAmount")
		thisIsWinner = rsTicketSlips("IsWinner")

		If CInt(thisTicketTypeID) = 1 Then
			If thisMoneyline > 0 Then thisMoneyline = "+" & thisMoneyline
			thisTicketDetails = thisMoneyline & " ML"
		End If
		If CInt(thisTicketTypeID) = 2 Then
			If thisSpread > 0 Then thisSpread = "+" & thisSpread
			thisTicketDetails = "(" & thisSpread & ")"
		End If
		If CInt(thisTicketTypeID) = 3 Then
			thisBetTeamName = thisTeamAbbr1 & "@" & thisTeamAbbr2
			thisTicketDetails = thisOverUnderBet & " (" & thisOverUnderAmount & ")"
		End If
%>
		<div class="col-xxxl-3 col-xxl-3 col-xl-4 col-lg-4 col-md-4 col-sm-12 col-xs-12 col-xxs-12">
			<ul class="list-group" style="margin-bottom: 1rem;">
				<li class="list-group-item text-center">
					<div><b><%= thisBetTeamName %>&nbsp;<%= thisTicketDetails %></b></div>
					<div><i><%= thisInsertDateTime %> (EST)</i></div>
					<div class="row pt-2">
						<div class="col-6" style="border-right: 1px dashed #edebf1;">
							<div><u>WAGER</u></div>
							<div><%= FormatNumber(thisBetAmount, 0) %></div>
						</div>
						<div class="col-6">
							<div><u>PAYOUT</u></div>
							<div><%= FormatNumber(thisPayoutAmount, 0) %></div>
						</div>
					</div>
				</li>
				<li class="list-group-item text-center">
					<div><b>Ticket Owner:</b> <%= thisProfileName %></div>
				</li>
			</ul>
		</div>
<%
		rsTicketSlips.MoveNext

	Loop
%>
</div>
<% End If %>
