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
%>
		<div class="card-body rounded bg-dark pt-2 pb-2">

			<div style="border-bottom: 1px solid #e8ebf3;">
				<h4 class="text-white"><%= Session.Contents("AccountName") %><span class="float-right"><i class="fas fa-list-alt"></i></span></h4>
			</div>

			<div class="row mt-2 pb-2">
				<div class="col-12 col-xxl-4">
					<div class="pt-1 pb-2"><img src="https://samelevel.imgix.net/<%= Session.Contents("AccountImage") %>?w=500&h=500&fit=crop&crop=focalpoint" alt="" class="img-fluid rounded" /></div>
					<div class="pb-2"><a href="/account/" class="btn btn-sm btn-block btn-primary">SETTINGS</a></div>
					<div><a href="/schmeckles/<%= Session.Contents("AccountProfileURL") %>/" class="btn btn-sm btn-block btn-success">SCHMECKLES</a></div>
				</div>
				<div class="col-12 col-xxl-8 pl-1 pr-1">

					<div class="row text-white">
						<div class="col-6 text-right"><b>SCHMECKLES</b></div>
						<div class="col-6 text-right"><%= FormatNumber(thisSchmeckleSackBalance, 0) %></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 text-right"><b>LOTTERY BALLS</b></div>
						<div class="col-6 text-right"><%= FormatNumber(Session.Contents("AccountBalls"), 0) %></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 text-right"><b>CURRENT RECORD</b></div>
						<div class="col-6 text-right">0-0-0</div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 text-right"><b>POINTS SCORED</b></div>
						<div class="col-6 text-right">0</div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 text-right"><b>CAREER BREAKDOWN</b></div>
						<div class="col-6 text-right"></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 text-right"><b>ALL-TIME POINTS</b></div>
						<div class="col-6 text-right"></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 text-right"><b>POWER RANKING</b></div>
						<div class="col-6 text-right">--</div>
					</div>

				</div>
			</div>

		</div>
<%
	End If
%>

</div>
