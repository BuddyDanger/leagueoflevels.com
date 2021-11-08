<div class="card">
<%
	If Len(Session.Contents("AccountID")) > 0 Then
%>
		<div class="card-body pt-2 pb-2">

			<div style="border-bottom: 1px solid #e8ebf3;">
				<h4>Schmeckle Sender<span class="float-right"><i class="fas fa-paper-plane"></i></span></h4>
			</div>

			<form action="/" method="post">

				<input type="hidden" name="action" value="send" />

				<div class="form-group pb-0 pt-3 mb-3">

					<select class="form-control form-control-lg mb-3" id="inputRecipientID" name="inputRecipientID" required>
						<option>Select Recipient</option>
<%
						sqlGetAccounts = "SELECT AccountID, ProfileName FROM Accounts WHERE Active = 1 ORDER BY ProfileName"
						Set rsAccounts = sqlDatabase.Execute(sqlGetAccounts)

						Do While Not rsAccounts.Eof

							thisAccountID = rsAccounts("AccountID")
							thisProfileName = rsAccounts("ProfileName")

							Response.Write("<option value=""" & thisAccountID & """>" & thisProfileName & "</option>")
							rsAccounts.MoveNext

						Loop

						rsAccounts.Close
						Set rsAccounts = Nothing
%>
					</select>

					<div class="row m-0 p-0">

						<div class="col-8 pl-0">
							<input type="number" min="1" max="<%= thisSchmeckleSackBalance %>" step="1" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control form-control-lg" id="inputTotalSchmeckles" name="inputTotalSchmeckles" placeholder="Enter Amount" required />
						</div>
						<div class="col-4 pr-0">
							<button type="submit" class="btn btn-block btn-primary">SEND</button>
						</div>

					</div>

				</div>

			</form>

		</div>
<%
	End If
%>

</div>
