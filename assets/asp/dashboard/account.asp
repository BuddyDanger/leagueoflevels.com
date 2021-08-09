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

					<div class="row">
						<div class="col-6 col-xxl-12">
							<div class="pt-1 pb-2"><img src="https://samelevel.imgix.net/<%= Session.Contents("AccountImage") %>?w=500&h=500&fit=crop&crop=focalpoint" alt="" class="img-fluid rounded" /></div>
						</div>
						<div class="col-6 col-xxl-12">
							<div class="pt-1 pb-2"><a href="/account/" class="btn btn-sm btn-block btn-primary">SETTINGS</a></div>
							<div><a href="/schmeckles/<%= Session.Contents("AccountProfileURL") %>/" class="btn btn-sm btn-block btn-primary">SCHMECKLES</a></div>
						</div>
					</div>

				</div>
				<div class="col-12 col-xxl-8 pl-1 pr-1">

					<div class="row text-white mt-2 mt-xxl-0">
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>SCHMECKLES</b></div>
						<div class="col-6 col-xl-4 text-xl-right"><%= FormatNumber(thisSchmeckleSackBalance, 0) %></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>LOTTERY BALLS</b></div>
						<div class="col-6 col-xl-4 text-xl-right"><%= FormatNumber(Session.Contents("AccountBalls"), 0) %></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>CURRENT RECORD</b></div>
						<div class="col-6 col-xl-4 text-xl-right">0-0-0</div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>POINTS SCORED</b></div>
						<div class="col-6 col-xl-4 text-xl-right">0</div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>CAREER RECORD</b></div>
						<div class="col-6 col-xl-4 text-xl-right"></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>ALL-TIME POINTS</b></div>
						<div class="col-6 col-xl-4 text-xl-right"></div>
						<div class="col-12"><hr class="bg-white mt-2 mb-2"></div>
						<div class="col-6 col-xl-8 text-right text-xl-left"><b>POWER RANKING</b></div>
						<div class="col-6 col-xl-4 text-xl-right">--</div>
					</div>

				</div>
			</div>

		</div>
<%
	End If
%>

</div>
