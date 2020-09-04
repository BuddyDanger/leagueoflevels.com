<%
	sqlGetWaitingListPosition = "SELECT A.AccountID, A.DateLinePlacement, (SELECT COUNT(*) FROM WaitingList B WHERE B.DateLinePlacement < A.DateLinePlacement) + 1 AS LinePosition, (SELECT COUNT(*) FROM WaitingList) AS LineTotal FROM WaitingList A WHERE A.AccountID = " & Session.Contents("AccountID")
	Set rsWaitingListPosition = sqlDatabase.Execute(sqlGetWaitingListPosition)

	If Not rsWaitingListPosition.Eof Then

		LinePosition = NumberSuffix(rsWaitingListPosition("LinePosition"))
		LineTotal = rsWaitingListPosition("LineTotal")
		DateLinePlacement = rsWaitingListPosition("DateLinePlacement")

		rsWaitingListPosition.Close
		Set rsWaitingListPosition = Nothing
%>
		<div class="card-body">
			<h4 class="mt-0 header-title">LOL Waiting List</h4>
			<p class="text-muted mb-3">You don't have an LOL team just yet, but you're on the official waiting list. As soon as you're spot reaches the top of the list, we'll contact you to setup your first LOL team. Until then, hold tight.</p>
			<div class="text-center">
				<h1 class="mb-0 pb-0"><%= LinePosition %></h1>
				<span class="badge bg-primary text-white mb-3">Line Position</span>
				<div class="text-muted pb-2"><b>Joined The Line:</b> <%= DateLinePlacement %> UTC</div>
				<div class="text-muted"><b>Total Line Size:</b> <%= LineTotal %></div>
			</div>
		</div>
<%
	Else
%>
		<div class="card-body">
			<h4 class="mt-0 header-title">Join The Waiting List</h4>
			<p class="text-muted mb-3">Your LOL account doesn't have any official teams attached. If you are currently a team owner and need to be assigned to your squad, <a href="/contact/">contact us</a>.</p>
			<p class="text-muted mb-3">If you don't currently have an official LOL team and you want one, join our waiting list by clicking the button below. As farm positions become open or new levels develop, you'll be right there in line ready to claim your spot.</p>
			<form action="/account/wait/" method="post">
				<input type="hidden" name="action" value="go" />
				<button type="submit" class="btn btn-primary btn-sm mt-2 mr-2">Join Waiting List</button>
			</form>
		</div>
<%
	End If
%>
