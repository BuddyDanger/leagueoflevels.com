<% If Session.Contents("LoggedIn") = "yes" Then %>
<div class="col-12">

	<div class="card">

		<div class="card-body met-pro-bg rounded">

			<div class="met-profile">

				<div class="row">

					<div class="col-12 col-md-6 mb-3 mb-lg-0">

						<div class="met-profile-main">

							<div class="met-profile-main-pic"><img src="https://samelevel.imgix.net/<%= Session.Contents("AccountImage") %>?w=128&h=128&fit=crop&crop=focalpoint" alt="" class="rounded"></div>

							<div class="met-profile_user-detail">
<%
								thisSchmeckleSackBalance = 0

								sqlGetCurrentSchmeckleSack = "SELECT CurrentBalance FROM SchmeckleSacks WHERE AccountID = " & Session.Contents("AccountID")
								Set rsCurrentSchmeckleSack = sqlDatabase.Execute(sqlGetCurrentSchmeckleSack)

								If Not rsCurrentSchmeckleSack.Eof Then

									thisSchmeckleSackBalance = rsCurrentSchmeckleSack("CurrentBalance")
									rsCurrentSchmeckleSack.Close
									Set rsCurrentSchmeckleSack = Nothing

								End If
%>
								<h5 class="met-user-name"><%= Session.Contents("AccountName") %></h5>
								<p class="mb-0 met-user-name-post"><%= FormatNumber(thisSchmeckleSackBalance, 0) %>&nbsp;Schmeckles</p>

							</div>

						</div>

					</div>

					<div class="col-12 col-md-6 text-left text-md-right ml-auto">

						<div class="button-list">
							<!--<a type="button" href="/locks/<%= Session.Contents("AccountProfileURL") %>/" class="btn btn-md btn-pink btn-circle mr-2"><i class="fas fa-lock"></i> &nbsp;<b>LOCKS</b></a>
							<a type="button" href="/sportsbook/tickets/<%= Session.Contents("AccountProfileURL") %>/" class="btn btn-md btn-pink btn-circle mr-2"><i class="fas fa-ticket-alt"></i> &nbsp;<b>SLIPS</b></a>-->
							<a type="button" href="/schmeckles/<%= Session.Contents("AccountProfileURL") %>/" class="btn btn-md btn-pink btn-circle mr-2"><i class="fas fa-money-bill-wave"></i> &nbsp;<b>SCHMECKS</b></a>
							<a type="button" href="/account/" class="btn btn-md btn-purple btn-circle mr-0"><i class="fas fa-user-cog"></i></a>
						</div>

					</div>

				</div>

			</div>

		</div>

	</div>

</div>
<% End If %>
