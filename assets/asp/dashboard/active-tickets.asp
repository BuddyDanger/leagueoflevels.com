<% If Session.Contents("LoggedIn") = "yes" Then %>
<div class="col-12">
<%
	Call TicketRow ()
%>
</div>
<% End If %>
