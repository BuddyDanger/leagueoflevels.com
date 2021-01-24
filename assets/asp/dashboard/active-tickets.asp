<% If Session.Contents("LoggedIn") = "yes" Then %>
<div class="col-12">
<%
	thisAccountID = Session.Contents("AccountID")
	Call TicketRow ()
%>
</div>
<% End If %>
