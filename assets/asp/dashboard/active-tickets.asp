<% If Session.Contents("LoggedIn") = "yes" Then %>
<%
	ticketsAccountID = ""
	ticketsTypeID = ""
	ticketsNFLGameID = ""
	ticketsMatchupID = ""
	ticketsProcessed = ""

	If Len(Session.Contents("AccountID")) > 0 Then ticketsAccountID = Session.Contents("AccountID")

	Call TicketRow (ticketsNFLGameID, ticketsMatchupID, ticketsAccountID, ticketsTypeID, ticketsProcessed, 1)
%>
<% End If %>
