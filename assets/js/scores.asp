<%
	sqlGetOmegaTeams = "SELECT DISTINCT TeamID FROM (SELECT Distinct TeamID1 AS TeamID FROM Matchups WHERE LevelID = 1 and Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & " UNION ALL SELECT DISTINCT TeamID2 AS TeamID FROM Matchups WHERE LevelID = 1 and Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & ") AS ActiveTeams;"
	sqlGetCupTeams = "SELECT DISTINCT TeamID FROM (SELECT Distinct TeamID1 AS TeamID FROM Matchups WHERE LevelID = 0 and Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & " UNION ALL SELECT DISTINCT TeamID2 AS TeamID FROM Matchups WHERE LevelID = 0 and Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & ") AS ActiveTeams;"
	sqlGetSLFFLTeams = "SELECT DISTINCT TeamID FROM (SELECT Distinct TeamID1 AS TeamID FROM Matchups WHERE LevelID = 2 and Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & " UNION ALL SELECT DISTINCT TeamID2 AS TeamID FROM Matchups WHERE LevelID = 2 and Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & ") AS ActiveTeams;"
	sqlGetFLFFLTeams = "SELECT DISTINCT TeamID FROM (SELECT Distinct TeamID1 AS TeamID FROM Matchups WHERE LevelID = 3 and Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & " UNION ALL SELECT DISTINCT TeamID2 AS TeamID FROM Matchups WHERE LevelID = 3 and Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & ") AS ActiveTeams;"
	sqlGetLeg = "SELECT TOP 1 Leg FROM Matchups WHERE LevelID = 0 AND Year = " & Session.Contents("CurrentYear") & " AND Period = " & Session.Contents("CurrentPeriod") & ";"
	Set rsTeams = sqlDatabase.Execute(sqlGetOmegaTeams & sqlGetCupTeams & sqlGetSLFFLTeams & sqlGetFLFFLTeams & sqlGetLeg)

	OmegaTeams = ""
	CupTeams = ""
	SLFFLTeams = ""
	FLFFLTeams = ""

	Do While Not rsTeams.Eof
		OmegaTeams = OmegaTeams & rsTeams("TeamID") & ","
		rsTeams.MoveNext
	Loop

	Set rsTeams = rsTeams.NextRecordset

	Do While Not rsTeams.Eof
		CupTeams = CupTeams & rsTeams("TeamID") & ","
		rsTeams.MoveNext
	Loop

	Set rsTeams = rsTeams.NextRecordset

	Do While Not rsTeams.Eof
		SLFFLTeams = SLFFLTeams & rsTeams("TeamID") & ","
		rsTeams.MoveNext
	Loop

	Set rsTeams = rsTeams.NextRecordset

	Do While Not rsTeams.Eof
		FLFFLTeams = FLFFLTeams & rsTeams("TeamID") & ","
		rsTeams.MoveNext
	Loop

	Set rsTeams = rsTeams.NextRecordset

	Do While Not rsTeams.Eof
		Leg = rsTeams("Leg")
		rsTeams.MoveNext
	Loop

	rsTeams.Close
	Set rsTeams = Nothing

	If Right(OmegaTeams, 1) = "," Then OmegaTeams = Left(OmegaTeams, Len(OmegaTeams) - 1)
	If Right(CupTeams, 1) = "," Then CupTeams = Left(CupTeams, Len(CupTeams) - 1)
	If Right(SLFFLTeams, 1) = "," Then SLFFLTeams = Left(SLFFLTeams, Len(SLFFLTeams) - 1)
	If Right(FLFFLTeams, 1) = "," Then FLFFLTeams = Left(FLFFLTeams, Len(FLFFLTeams) - 1)
%>
<script>

	$(function () {

		var MATCHUPS = [<%= thisWeeklyMatchups %>]

		function loopThroughArray(array, callback, interval) {

			var newLoopTimer = new LoopTimer(function (time) {
				var element = array.shift();
				callback(element, time - start);
				array.push(element);
			}, interval);

			var start = newLoopTimer.start();

		};

		function LoopTimer(render, interval) {

			var timeout;
			var lastTime;
			this.start = startLoop;
			this.stop = stopLoop;

			function startLoop() {
				timeout = setTimeout(createLoop, 0);
				lastTime = Date.now();
				return lastTime;
			}

			function stopLoop() {
				clearTimeout(timeout);
				return lastTime;
			}

			function createLoop() {
				var thisTime = Date.now();
				var loopTime = thisTime - lastTime;
				var delay = Math.max(interval - loopTime, 0);
				timeout = setTimeout(createLoop, delay);
				lastTime = thisTime + delay;
				render(thisTime);
			}

		}

		loopThroughArray(MATCHUPS, function (arrayElement, loopTime) {

			var thisID = arrayElement;
			var data = {"id":thisID};
			data = $.param(data);

			$.ajax({
				type: "GET",
				dataType: "json",
				url: "/scores/json/matchup/",
				data: data,
				success: function(data) {

					//alert('team-' + data["level"] + '-progress-' + data["teamid1"]);
					var objScore1 = document.getElementsByClassName('team-' + data["level"] + '-score-' + data["teamid1"])[0];
					var objPMR1 = document.getElementsByClassName('team-' + data["level"] + '-progress-' + data["teamid1"])[0];
					objPMR1.innerHTML = "<div class=\"progress-bar progress-bar-" + data["teampmrcolor1"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["teampmrpercent1"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["teampmrpercent1"] + "%\"><span class=\"sr-only\">" + data["teampmrpercent1"] + "%</span></div>";
					if (parseFloat(objScore1.innerText) != parseFloat(data["teamscore1"])) { var scoreAnimation1 = new CountUp(objScore1, objScore1.innerText, data["teamscore1"], 2, 4); scoreAnimation1.start(); }

					var objScore2 = document.getElementsByClassName('team-' + data["level"] + '-score-' + data["teamid2"])[0];
					var objPMR2 = document.getElementsByClassName('team-' + data["level"] + '-progress-' + data["teamid2"])[0];
					objPMR2.innerHTML = "<div class=\"progress-bar progress-bar-" + data["teampmrcolor2"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["teampmrpercent2"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["teampmrpercent2"] + "%\"><span class=\"sr-only\">" + data["teampmrpercent2"] + "%</span></div>";
					if (parseFloat(objScore2.innerText) != parseFloat(data["teamscore2"])) { var scoreAnimation2 = new CountUp(objScore1, objScore2.innerText, data["teamscore2"], 2, 4); scoreAnimation2.start(); }

				}
			});

		}, 500);

	});
</script>
