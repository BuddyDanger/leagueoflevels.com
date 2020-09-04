<% If Session.Contents("LoggedIn") = "yes" Then %>
<div class="col-12 col-lg-6 col-xl-4">

	<div class="card">
<%
		If Len(Session.Contents("AccountID")) > 0 Then
%>
			<div class="card-body">

				<h4 class="mt-0 header-title">My Schmeckle Sack</h4>
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
				<div class="w-100 pb-2 text-center">
                    <h2 class="mt-0 mb-2 font-weight-semibold"><%= FormatNumber(thisSchmeckleSackBalance, 0) %></h2>
					<span class="badge badge-soft-success font-11"><i class="fas fa-arrow-up"></i> 8.6%</span>
                </div>

				<button class="btn mt-2 btn-primary btn-sm btn-block">View Sack Activity</button>

			</div>
<%
		End If
%>

	</div>

</div>
<% End If %>
