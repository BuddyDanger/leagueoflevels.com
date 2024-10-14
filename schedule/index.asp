<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	If Len(ParseForAbsolutePath(Right(Request.ServerVariables("QUERY_STRING"), Len(Request.ServerVariables("QUERY_STRING")) - Instr(Request.ServerVariables("QUERY_STRING"),";")))) < 1 Then

		Session.Contents("SITE_Schedule_LevelID") = ""
		Session.Contents("SITE_Schedule_TeamID") = ""
		Session.Contents("SITE_Schedule_Year") = Session.Contents("CurrentYear")
		Session.Contents("SITE_Schedule_Period") = Session.Contents("CurrentPeriod")

	End If

	If Len(Session.Contents("SITE_Schedule_Year")) = 0 Then Session.Contents("SITE_Schedule_Year") = Session.Contents("CurrentYear")
	If Len(Session.Contents("SITE_Schedule_Period")) = 0 Then Session.Contents("SITE_Schedule_Period") = Session.Contents("CurrentPeriod")

	thisTeamID = Session.Contents("SITE_Schedule_Team")
	thisLevel = Session.Contents("SITE_Schedule_Level")
	thisYear = Session.Contents("SITE_Schedule_Year")
	thisPeriod = Session.Contents("SITE_Schedule_Period")

	If Request.Form("action") = "update" Then

		thisTeamID = Request.Form("team")
		thisLevel = Request.Form("level")
		thisYear = Request.Form("year")
		thisPeriod = Request.Form("period")

		If Len(thisLevel) > 0 Then
			If Len(thisYear) > 0 Then
				If Len(thisPeriod) > 0 Then
					Response.Redirect("/schedule/" & thisLevel & "/" & thisYear & "/" & thisPeriod & "/")
				Else
					Response.Redirect("/schedule/" & thisLevel & "/" & thisYear & "/")
				End If
			End If
		Else
			If Len(thisYear) > 0 Then
				If Len(thisPeriod) > 0 Then
					Response.Redirect("/schedule/" & thisYear & "/" & thisPeriod & "/")
				Else
					Response.Redirect("/schedule/" & thisYear & "/")
				End If
			End If
		End If

	End If

	sqlGetSchedule = "SELECT * FROM Schedule WHERE Schedule.Year = " & Session.Contents("SITE_Schedule_Year") & " AND Schedule.Period = " & Session.Contents("SITE_Schedule_Period") & " AND LevelID < 6 ORDER BY YEAR, PERIOD, LEVELID"
	If Len(Session.Contents("SITE_Schedule_LevelID")) > 0 Then sqlGetSchedule = Replace(sqlGetSchedule, "LevelID < 6", "LevelID = " & Session.Contents("SITE_Schedule_LevelID"))
	Set rsSchedule = sqlDatabase.Execute(sqlGetSchedule)

	If CStr(Session.Contents("SITE_Schedule_LevelID")) = "1" Or CStr(Session.Contents("SITE_Schedule_LevelID")) = "2" Or CStr(Session.Contents("SITE_Schedule_LevelID")) = "3" Or CStr(Session.Contents("SITE_Schedule_LevelID")) = "4" Or CStr(Session.Contents("SITE_Schedule_LevelID")) = "5" Then
		If CStr(Session.Contents("SITE_Schedule_LevelID")) = "1" Then PageTitle = "Omega Level "
		If CStr(Session.Contents("SITE_Schedule_LevelID")) = "2" Then PageTitle = "Same Level "
		If CStr(Session.Contents("SITE_Schedule_LevelID")) = "3" Then PageTitle = "Farm Level "
		If CStr(Session.Contents("SITE_Schedule_LevelID")) = "4" Then PageTitle = "Best Level "
		If CStr(Session.Contents("SITE_Schedule_LevelID")) = "5" Then PageTitle = "Tag Team Division "
	End If

	PageTitle = PageTitle & "Schedule / "
	If Len(Session.Contents("SITE_Schedule_LevelID")) > 0 Then PageTitle = PageTitle & Session.Contents("SITE_Schedule_LevelTitle") & " / "
	PageTitle = PageTitle & Session.Contents("SITE_Schedule_Year") & ", Period " & Session.Contents("SITE_Schedule_Period") & " / "
	PageTitle = PageTitle & "League of Levels"

	PageDescription = "Our schedule database includes an official index of every LOL matchup in the history of our league, plus all upcoming matchups."
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title><%= PageTitle %></title>

		<meta name="description" content="<%= PageDescription %>" />

		<meta property="og:site_name" content="League of Levels" />
		<meta property="og:url" content="https://www.leagueoflevels.com/schedule/" />
		<meta property="og:title" content="<%= PageTitle %>" />
		<meta property="og:description" content="<%= PageDescription %>" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/schedule/" />
		<meta name="twitter:title" content="<%= PageTitle %>" />
		<meta name="twitter:description" content="<%= PageDescription %>" />

		<meta name="title" content="<%= PageTitle %>" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/schedule/" />

		<link href="/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/icons.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/style.css?version=3" rel="stylesheet" type="text/css" />

	</head>

	<body>

		<!--#include virtual="/assets/asp/framework/topbar.asp" -->

		<div class="page-wrapper">

			<!--#include virtual="/assets/asp/framework/nav.asp" -->

			<div class="page-content">

				<div class="container-fluid pl-0 pl-lg-2 pr-lg-2">

					<div class="row mt-4">

						<div class="col-12 col-xl-8 px-3">

							<nav aria-label="breadcrumb">
								<a href="/schedule/" class="btn btn-sm btn-light float-left inactive mb-3 mr-2" type="button">Schedule</a>
<%
								If Len(Session.Contents("SITE_Schedule_LevelID")) > 0 Then

									If Session.Contents("SITE_Schedule_LevelID") = 1 Then Response.Write("<a href=""/schedule/omega-level/"" class=""btn btn-sm btn-light float-left inactive mb-3 mr-2"" type=""button"">Omega Level</a>")
									If Session.Contents("SITE_Schedule_LevelID") = 2 Then Response.Write("<a href=""/schedule/same-level/"" class=""btn btn-sm btn-light float-left inactive mb-3 mr-2"" type=""button"">Same Level</a>")
									If Session.Contents("SITE_Schedule_LevelID") = 3 Then Response.Write("<a href=""/schedule/farm-level/"" class=""btn btn-sm btn-light float-left inactive mb-3 mr-2"" type=""button"">Farm Level</a>")
									If Session.Contents("SITE_Schedule_LevelID") = 4 Then Response.Write("<a href=""/schedule/best-level/"" class=""btn btn-sm btn-light float-left inactive mb-3 mr-2"" type=""button"">Best Level</a>")
									If Session.Contents("SITE_Schedule_LevelID") = 5 Then Response.Write("<a href=""/schedule/tag-team-division/"" class=""btn btn-sm btn-light float-left inactive mb-3 mr-2"" type=""button"">Tag Team</a>")

								End If
%>
								<button class="btn btn-sm btn-light float-left inactive mb-3 mr-2" type="button"><%= Session.Contents("SITE_Schedule_Year") %> / Period <%= Session.Contents("SITE_Schedule_Period") %></button>
								<button type="button" class="btn btn-sm btn-primary float-right" data-toggle="collapse" data-target="#filterBar" aria-expanded="false" aria-controls="filterBar">
									Filters
								</button>
							</nav>

						</div>

						<div class="col-12 col-xl-8">

							<form class="form collapse" method="post" action="/schedule/" id="filterBar">

								<div class="row bg-light text-white shadow-sm py-3 mx-1 mb-3 rounded filters" id="filters">

									<input type="hidden" name="action" id="action" value="update" />

									<div class="col-6 col-xl-3 pb-2 pb-xl-0">
										<select class="form-control form-control-lg form-check-input-lg w-100" name="year" id="year" onchange="this.form.submit()">
											<option value="2024" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2024" Then %>selected<% End If %>>2024</option>
											<option value="2023" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2023" Then %>selected<% End If %>>2023</option>
											<option value="2022" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2022" Then %>selected<% End If %>>2022</option>
											<option value="2021" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2021" Then %>selected<% End If %>>2021</option>
											<option value="2020" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2020" Then %>selected<% End If %>>2020</option>
											<option value="2019" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2019" Then %>selected<% End If %>>2019</option>
											<option value="2018" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2018" Then %>selected<% End If %>>2018</option>
											<option value="2017" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2017" Then %>selected<% End If %>>2017</option>
											<option value="2016" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2016" Then %>selected<% End If %>>2016</option>
											<option value="2015" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2015" Then %>selected<% End If %>>2015</option>
											<option value="2014" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2014" Then %>selected<% End If %>>2014</option>
											<option value="2013" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2013" Then %>selected<% End If %>>2013</option>
											<option value="2012" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2012" Then %>selected<% End If %>>2012</option>
											<option value="2011" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2011" Then %>selected<% End If %>>2011</option>
											<option value="2010" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2010" Then %>selected<% End If %>>2010</option>
											<option value="2009" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2009" Then %>selected<% End If %>>2009</option>
											<option value="2008" <% If CStr(Session.Contents("SITE_Schedule_Year")) = "2008" Then %>selected<% End If %>>2008</option>
										</select>
									</div>

									<div class="col-6 col-xl-3 pb-2 pb-xl-0">
										<select class="form-control form-control-lg form-check-input-lg w-100" name="period" id="period" onchange="this.form.submit()">
											<option value="1" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "1" Then %>selected<% End If %>>PERIOD 01</option>
											<option value="2" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "2" Then %>selected<% End If %>>PERIOD 02</option>
											<option value="3" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "3" Then %>selected<% End If %>>PERIOD 03</option>
											<option value="4" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "4" Then %>selected<% End If %>>PERIOD 04</option>
											<option value="5" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "5" Then %>selected<% End If %>>PERIOD 05</option>
											<option value="6" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "6" Then %>selected<% End If %>>PERIOD 06</option>
											<option value="7" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "7" Then %>selected<% End If %>>PERIOD 07</option>
											<option value="8" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "8" Then %>selected<% End If %>>PERIOD 08</option>
											<option value="9" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "9" Then %>selected<% End If %>>PERIOD 09</option>
											<option value="10" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "10" Then %>selected<% End If %>>PERIOD 10</option>
											<option value="11" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "11" Then %>selected<% End If %>>PERIOD 11</option>
											<option value="12" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "12" Then %>selected<% End If %>>PERIOD 12</option>
											<option value="13" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "13" Then %>selected<% End If %>>PERIOD 13</option>
											<option value="14" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "14" Then %>selected<% End If %>>PERIOD 14</option>
											<option value="15" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "15" Then %>selected<% End If %>>PERIOD 15</option>
											<option value="16" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "16" Then %>selected<% End If %>>PERIOD 16</option>
											<option value="17" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "17" Then %>selected<% End If %>>PERIOD 17</option>
											<option value="18" <% If CStr(Session.Contents("SITE_Schedule_Period")) = "18" Then %>selected<% End If %>>PERIOD 18</option>
										</select>
									</div>

									<div class="col-6 col-xl-3">
										<%= Session.Contents("SITE_Schedule_Level") %>
										<select class="form-control form-control-lg form-check-input-lg w-100" name="level" id="level" onchange="this.form.submit()">
											<option value="">ALL LEVELS</option>
											<option value="omega-level" <% If CStr(Session.Contents("SITE_Schedule_LevelID")) = "1" Then %>selected<% End If %>>OMEGA LEVEL</option>
											<option value="same-level" <% If CStr(Session.Contents("SITE_Schedule_LevelID")) = "2" Then %>selected<% End If %>>SAME LEVEL</option>
											<option value="farm-level" <% If CStr(Session.Contents("SITE_Schedule_LevelID")) = "3" Then %>selected<% End If %>>FARM LEVEL</option>
											<option value="best-level" <% If CStr(Session.Contents("SITE_Schedule_LevelID")) = "4" Then %>selected<% End If %>>BEST LEVEL</option>
											<option value="tag-team-division" <% If CStr(Session.Contents("SITE_Schedule_LevelID")) = "5" Then %>selected<% End If %>>TAG TEAM DIVISION</option>
										</select>
									</div>

									<div class="col-6 col-xl-3">
										<select class="form-control form-control-lg form-check-input-lg w-100" name="team" id="team" onchange="this.form.submit()">
											<option value="">ALL TEAMS</option>

										</select>
									</div>

								</div>

							</form>

							<div class="row mb-3">
<%
								Do While Not rsSchedule.Eof

									thisMatchupID = rsSchedule("MatchupID")
									thisLevelID = rsSchedule("LevelID")
									thisLevelTitle = rsSchedule("LevelTitle")
									thisLevelLogo = rsSchedule("LevelLogo")
									thisYear = rsSchedule("Year")
									thisPeriod = rsSchedule("Period")
									thisTeamID1 = rsSchedule("TeamID1")
									thisTeamID2 = rsSchedule("TeamID2")
									thisTeamName1 = rsSchedule("T1_TeamName")
									thisTeamName2 = rsSchedule("T2_TeamName")
									thisAbbreviatedTeamName1 = rsSchedule("T1_AbbreviatedName")
									thisAbbreviatedTeamName2 = rsSchedule("T2_AbbreviatedName")
									thisTeamLogo1 = rsSchedule("T1_Logo")
									thisTeamLogo2 = rsSchedule("T2_Logo")
									thisTeamScore1 = FormatNumber(rsSchedule("TeamScore1"), 2)
									thisTeamScore2 = FormatNumber(rsSchedule("TeamScore2"), 2)
									thisTeamPMR1 = rsSchedule("TeamPMR1")
									thisTeamPMR2 = rsSchedule("TeamPMR2")

									If thisTeamName1 = "The District of Columbia(n) Neckties" Then thisTeamName1 = "DC Neckties"
									If thisTeamName2 = "The District of Columbia(n) Neckties" Then thisTeamName2 = "DC Neckties"

									thisTeamScoreColor1 = "btn-light"
									thisTeamScoreColor2 = "btn-light"
									If CDbl(thisTeamScore1) > CDbl(thisTeamScore2) Then
										thisTeamScoreColor1 = thisTeamScoreColor1 & " font-weight-bold"
									End If

									If CDbl(thisTeamScore2) > CDbl(thisTeamScore1) Then
										thisTeamScoreColor2 = thisTeamScoreColor2 & " font-weight-bold"
									End If

									If thisLevelID = 5 Then

										sqlGetTeam1 = "SELECT Accounts.AccountID, ProfileName, ProfileURL, ProfileImage FROM Accounts INNER JOIN LinkAccountsTeams ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE LinkAccountsTeams.TeamID = " & thisTeamID1 & ";"
										sqlGetTeam2 = "SELECT Accounts.AccountID, ProfileName, ProfileURL, ProfileImage FROM Accounts INNER JOIN LinkAccountsTeams ON Accounts.AccountID = LinkAccountsTeams.AccountID WHERE LinkAccountsTeams.TeamID = " & thisTeamID2 & ";"

										Set rsTeams = sqlDatabase.Execute(sqlGetTeam1 & sqlGetTeam2)
										Team1Partner1_AccountID = rsTeams("AccountID")
										Team1Partner1_ProfileName = rsTeams("ProfileName")
										Team1Partner1_ProfileURL = rsTeams("ProfileURL")
										Team1Partner1_ProfileImage = rsTeams("ProfileImage")
										rsTeams.MoveNext
										Team1Partner2_AccountID = rsTeams("AccountID")
										Team1Partner2_ProfileName = rsTeams("ProfileName")
										Team1Partner2_ProfileURL = rsTeams("ProfileURL")
										Team1Partner2_ProfileImage = rsTeams("ProfileImage")
										Set rsTeams = rsTeams.NextRecordset()
										Team2Partner1_AccountID = rsTeams("AccountID")
										Team2Partner1_ProfileName = rsTeams("ProfileName")
										Team2Partner1_ProfileURL = rsTeams("ProfileURL")
										Team2Partner1_ProfileImage = rsTeams("ProfileImage")
										rsTeams.MoveNext
										Team2Partner2_AccountID = rsTeams("AccountID")
										Team2Partner2_ProfileName = rsTeams("ProfileName")
										Team2Partner2_ProfileURL = rsTeams("ProfileURL")
										Team2Partner2_ProfileImage = rsTeams("ProfileImage")

										rsTeams.Close
										Set rsTeams = Nothing

									End If
%>
									<div class="col-12 col-xl-6">
										<div class="card shadow-sm mb-3">
											<div class="card-body p-2 py-3">
												<div class="row">
													<div class="order-1 col-8 mb-2 pb-2 border-bottom align-middle">
														<% If thisLevelID < 5 Then %>
															<img src="https://samelevel.imgix.net/<%= thisTeamLogo1 %>?w=30&h=30&fit=crop&crop=focalpoint" class="rounded-circle mr-2"><%= thisTeamName1 %>
														<% Else %>
															<img src="https://samelevel.imgix.net/<%= Team1Partner1_ProfileImage %>?w=30&h=30&fit=crop&crop=focalpoint" class="rounded-circle" title="<%= Team1Partner1_ProfileName %>" style="position: relative; z-index: 1; border: 2px solid #fff;" />
															<img src="https://samelevel.imgix.net/<%= Team1Partner2_ProfileImage %>?w=30&h=30&fit=crop&crop=focalpoint" class="rounded-circle" title="<%= Team1Partner2_ProfileName %>" style="position: relative; z-index: 0; border: 2px solid #fff; left: -15px;" /><%= thisTeamName1 %>
														<% End If %>
													</div>
													<div class="order-2 col-4 mb-2 pb-2 border-bottom text-right"><span class="btn btn-xs <%= thisTeamScoreColor1 %> shadow-none"><%= thisTeamScore1 %></span></div>
													<div class="order-4 col-4 pt-1 text-right"><span class="btn btn-xs <%= thisTeamScoreColor2 %> shadow-none"><%= thisTeamScore2 %></span></div>
													<div class="order-3 col-8 pt-1">
														<% If thisLevelID < 5 Then %>
															<img src="https://samelevel.imgix.net/<%= thisTeamLogo2 %>?w=30&h=30&fit=crop&crop=focalpoint" class="rounded-circle mr-2"><%= thisTeamName2 %>
														<% Else %>
															<img src="https://samelevel.imgix.net/<%= Team2Partner1_ProfileImage %>?w=30&h=30&fit=crop&crop=focalpoint" class="rounded-circle" title="<%= Team2Partner1_ProfileName %>" style="position: relative; z-index: 1; border: 2px solid #fff;" />
															<img src="https://samelevel.imgix.net/<%= Team2Partner2_ProfileImage %>?w=30&h=30&fit=crop&crop=focalpoint" class="rounded-circle" title="<%= Team2Partner2_ProfileName %>" style="position: relative; z-index: 0; border: 2px solid #fff; left: -15px;" /><%= thisTeamName2 %>
														<% End If %>
													</div>
												</div>
											</div>
										</div>
									</div>
<%
									thisPosition = thisPosition + 1
									rsSchedule.MoveNext

								Loop
%>
							</div>

						</div>

					</div>

				</div>

				<footer class="footer text-center text-sm-left">&copy; <%= Year(Now()) %> League of Levels Fantasy <span class="text-muted d-none d-sm-inline-block float-right"></span></footer>

			</div>

		</div>

		<script src="/assets/js/jquery.min.js"></script>
		<script src="/assets/js/bootstrap.bundle.min.js"></script>
		<script src="/assets/js/metisMenu.min.js"></script>
		<script src="/assets/js/waves.min.js"></script>
		<script src="/assets/js/jquery.slimscroll.min.js"></script>

		<script src="/assets/js/app.js"></script>

		<!--#include virtual="/assets/asp/framework/google.asp" -->

	</body>

</html>
