<div class="card">
<%
	If Len(Session.Contents("AccountID")) > 0 Then

		sqlGetSchmeckles = "SELECT SUM(TransactionTotal) AS CurrentSchmeckleTotal FROM SchmeckleTransactions WHERE AccountID = " & Session.Contents("AccountID")
		Set rsSchmeckles = sqlDatabase.Execute(sqlGetSchmeckles)

		If Not rsSchmeckles.Eof Then

			thisSchmeckleTotal = rsSchmeckles("CurrentSchmeckleTotal")

			If IsNull(thisSchmeckleTotal) Then thisSchmeckleTotal = 0

			maxBallPurchase = CDbl(thisSchmeckleTotal)
			maxBallPurchase = Int(maxBallPurchase / 500)

			rsSchmeckles.Close
			Set rsSchmeckles = Nothing

		Else

			thisSchmeckleTotal = 0
			maxBallPurchase = 0
			thisFormDisabled = "disabled"

		End If

		thisLevelTotal = 0

		If Len(Session.Contents("AccountTeams")) > 0 Then

			sqlGetTotalLevelBalls = "SELECT SUM(Balls_Omega) AS LevelTotal FROM Accounts"
			Set rsTotalLevelBalls = sqlDatabase.Execute(sqlGetTotalLevelBalls)

			thisLevelTotal = rsTotalLevelBalls("LevelTotal")

		End If

		If Session.Contents("AccountBalls_Omega") > 0 And thisLevelTotal > 0 Then
			thisWinChance = FormatNumber(100 * (Session.Contents("AccountBalls_Omega") / thisLevelTotal), 2)
		Else
			thisWinChance = FormatNumber(0, 2)
		End If

		rsTotalLevelBalls.Close
		Set rsTotalLevelBalls = Nothing
%>
		<h4 class="text-left bg-dark text-white p-3 mt-0 mb-0 rounded-top"><b>Omega Ballsack</b><span class="float-right"><i class="fas fa-weight-hanging"></i></span></h4>
		<div class="card-body pt-2 pb-2">

			<div class="row bg-light rounded mt-3 mb-3 pb-2 pt-2">
				<div class="col-4 text-center">
					<div><u><b>My Balls</b></u></div>
					<div><%= Session.Contents("AccountBalls_Omega") %></div>
				</div>
				<div class="col-4 text-center">
					<div><u><b>Total Balls</b></u></div>
					<div><%= thisLevelTotal %></div>
				</div>
				<div class="col-4 text-center">
					<div><u><b>Win Chance</b></u></div>
					<div><%= thisWinChance %>%</div>
				</div>
			</div>

			<form action="/" method="post">

				<input type="hidden" name="action" value="buy-omega" />

				<div class="form-group">

					<div class="row quantity-input">

						<div class="col-4 mr-0">
							<label class="col-form-label mt-0 pt-0"><b>Omega Balls</b></label>
							<input <%= thisFormDisabled %> type="number" class="form-control form-control-lg" min="0" max="<%= maxBallPurchase %>" value="0" id="inputBallPurchase" name="inputBallPurchase" onchange="calculate_omega_ball_cost(this.value)" required>
						</div>

						<div class="col-2 pl-0 pr-1 pt-3 mt-2"><a class="btn btn-block btn-success text-white quantity-input-up-omega mt-0 pt-2"><i class="fa fa-angle-up"></i></a></div>

						<div class="col-2 pr-0 pl-1 pt-3 mt-2"><a class="btn btn-block btn-danger text-white quantity-input-down-omega mt-0 pt-2"><i class="fa fa-angle-down"></i></a></div>

						<div class="col-4 text-right">
							<label for="inputTotalSchmeckles_Omega" class="col-form-label mt-0 pt-0"><b>Schmeckles</b></label>
							<input type="text" class="form-control form-control-lg text-right" id="inputTotalSchmeckles_Omega" name="inputTotalSchmeckles_Omega" disabled>
						</div>

					</div>

					<button <%= thisFormDisabled %> type="submit" class="btn btn-block btn-primary mt-3 mb-2">Purchase Omega Balls</button>

				</div>

			</form>

		</div>
<%
	End If
%>

</div>
