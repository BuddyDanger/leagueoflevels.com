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
							<a type="button" href="#" class="btn btn-lg btn-blue btn-circle"><i class="fab fa-facebook-f"></i></a>
							<button type="button" class="btn btn-lg btn-secondary btn-circle ml-2"><i class="fab fa-twitter"></i></button>
							<button type="button" class="btn btn-lg btn-pink btn-circle ml-2"><i class="fab fa-instagram"></i></button>
							<button type="button" class="btn btn-lg btn-purple btn-circle ml-2 mr-0"><i class="fas fa-at"></i></button>
						</div>

					</div>

				</div>

			</div>

		</div>

	</div>

</div>
<% End If %>
