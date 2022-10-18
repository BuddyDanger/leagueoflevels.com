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

		var SLFFL_ID = [<%= SLFFLTeams %>]
		var FLFFL_ID = [<%= FLFFLTeams %>]
		var OMEGA_ID = [<%= OmegaTeams %>]
		var CUP_ID   = [<%= CupTeams %>]

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

		loopThroughArray(OMEGA_ID, function (arrayElement, loopTime) {

			var thisID = arrayElement;
			var data = {"league":"OMEGA", "id":thisID};
			data = $.param(data);

			$.ajax({
				type: "GET",
				dataType: "json",
				url: "/scores/team/json/",
				data: data,
				success: function(data) {

					var scoreBox1 = document.getElementsByClassName('team-omega-score-' + data["teamid"])[0];

					var PMR1 = document.getElementsByClassName('team-omega-progress-' + data["teamid"])[0];
					PMR1.innerHTML = "<div class=\"progress-bar progress-bar-" + data["teampmrcolor"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["teampmrpercent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["teampmrpercent"] + "%\"><span class=\"sr-only\">" + data["teampmrpercent"] + "%</span></div>";

					if (parseFloat(scoreBox1.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation1 = new CountUp(scoreBox1, scoreBox1.innerText, data["teamscore"], 2, 4);
						scoreAnimation1.start();
					}

				}
			});

		}, 3000);

		loopThroughArray(CUP_ID, function (arrayElement, loopTime) {

			var thisID = arrayElement;
			var data = {"league":"CUP", "id":thisID, "leg":"<%= Leg %>"};
			data = $.param(data);

			$.ajax({
				type: "GET",
				dataType: "json",
				url: "/scores/team/json/",
				data: data,
				success: function(data) {

					var scoreBox1 = document.getElementsByClassName('team-cup-score-' + data["teamid"])[0];

					var PMR1 = document.getElementsByClassName('team-cup-progress-' + data["teamid"])[0];

					PMR1.innerHTML = "<div class=\"progress-bar progress-bar-" + data["teampmrcolor"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["teampmrpercent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["teampmrpercent"] + "%\"><span class=\"sr-only\">" + data["teampmrpercent"] + "%</span></div>";

					if (parseFloat(scoreBox1.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation1 = new CountUp(scoreBox1, scoreBox1.innerText, data["teamscore"], 2, 4);
						scoreAnimation1.start();
					}

				}
			});

		}, 3000);

		loopThroughArray(SLFFL_ID, function (arrayElement, loopTime) {

			var thisID = arrayElement;
			var data = {"league":"SLFFL", "id":thisID};
			data = $.param(data);

			$.ajax({
				type: "GET",
				dataType: "json",
				url: "/scores/team/json/",
				data: data,
				success: function(data) {

					var scoreBox1 = document.getElementsByClassName('team-slffl-score-' + data["teamid"])[0];
					var scoreBox2 = document.getElementsByClassName('team-slffl-score-' + data["teamid"])[1];

					var PMR1 = document.getElementsByClassName('team-slffl-progress-' + data["teamid"])[0];
					var PMR2 = document.getElementsByClassName('team-slffl-progress-' + data["teamid"])[1];

					PMR1.innerHTML = "<div class=\"progress-bar progress-bar-" + data["teampmrcolor"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["teampmrpercent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["teampmrpercent"] + "%\"><span class=\"sr-only\">" + data["teampmrpercent"] + "%</span></div>";
					PMR2.innerHTML = "<div class=\"progress-bar progress-bar-" + data["teampmrcolor"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["teampmrpercent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["teampmrpercent"] + "%\"><span class=\"sr-only\">" + data["teampmrpercent"] + "%</span></div>";

					if (parseFloat(scoreBox1.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation1 = new CountUp(scoreBox1, scoreBox1.innerText, data["teamscore"], 2, 4);
						scoreAnimation1.start();
					}

					if (parseFloat(scoreBox2.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation2 = new CountUp(scoreBox2, scoreBox2.innerText, data["teamscore"], 2, 4);
						scoreAnimation2.start();
					}

				}
			});

		}, 3000);

		loopThroughArray(FLFFL_ID, function (arrayElement, loopTime) {

			var thisID = arrayElement;
			var data = {"league":"FLFFL", "id":thisID};
			data = $.param(data);

			$.ajax({
				type: "GET",
				dataType: "json",
				url: "/scores/team/json/",
				data: data,
				success: function(data) {

					var scoreBox1 = document.getElementsByClassName('team-flffl-score-' + data["teamid"])[0];
					var scoreBox2 = document.getElementsByClassName('team-flffl-score-' + data["teamid"])[1];

					var PMR1 = document.getElementsByClassName('team-flffl-progress-' + data["teamid"])[0];
					var PMR2 = document.getElementsByClassName('team-flffl-progress-' + data["teamid"])[1];

					PMR1.innerHTML = "<div class=\"progress-bar progress-bar-" + data["teampmrcolor"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["teampmrpercent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["teampmrpercent"] + "%\"><span class=\"sr-only\">" + data["teampmrpercent"] + "%</span></div>";
					PMR2.innerHTML = "<div class=\"progress-bar progress-bar-" + data["teampmrcolor"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["teampmrpercent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["teampmrpercent"] + "%\"><span class=\"sr-only\">" + data["teampmrpercent"] + "%</span></div>";

					if (parseFloat(scoreBox1.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation1 = new CountUp(scoreBox1, scoreBox1.innerText, data["teamscore"], 2, 4);
						scoreAnimation1.start();
					}

					if (parseFloat(scoreBox2.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation2 = new CountUp(scoreBox2, scoreBox2.innerText, data["teamscore"], 2, 4);
						scoreAnimation2.start();
					}

				}
			});

		}, 3000);

	});
</script>
