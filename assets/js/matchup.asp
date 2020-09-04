<script>

	$(function () {

		var TEAM_ID1 = [<%= TeamID1 %>]
		var TEAM_ID2 = [<%= TeamID2 %>]
		var TEAM_ROSTER_1 = [<%= TeamRoster1 %>]
		var TEAM_ROSTER_2 = [<%= TeamRoster2 %>]

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

		loopThroughArray(TEAM_ID1, function (arrayElement, loopTime) {

			var thisID = arrayElement;
			var data = {"league":"<%= MatchupLevel %>", "id":thisID, "leg":"2"};
			data = $.param(data);

			$.ajax({
				type: "GET",
				dataType: "json",
				url: "/scores/team/json/",
				data: data,
				success: function(data) {

					var scoreBox1 = document.getElementsByClassName('team-1-score')[0];

					var PMR1 = document.getElementsByClassName('team-1-progress')[0];

					PMR1.innerHTML = "<div class=\"progress-bar progress-bar-" + data["teampmrcolor"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["teampmrpercent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["teampmrpercent"] + "%\"><span class=\"sr-only\">" + data["teampmrpercent"] + "%</span></div>";

					if (parseFloat(scoreBox1.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation1 = new CountUp(scoreBox1, scoreBox1.innerText, data["teamscore"], 2, 4);
						scoreAnimation1.start();
					}

				}
			});

		}, 3000);

		loopThroughArray(TEAM_ID2, function (arrayElement, loopTime) {

			var thisID = arrayElement;
			var data = {"league":"<%= MatchupLevel %>", "id":thisID, "leg":"2"};
			data = $.param(data);

			$.ajax({
				type: "GET",
				dataType: "json",
				url: "/scores/team/json/",
				data: data,
				success: function(data) {

					var scoreBox1 = document.getElementsByClassName('team-2-score')[0];

					var PMR1 = document.getElementsByClassName('team-2-progress')[0];

					PMR1.innerHTML = "<div class=\"progress-bar progress-bar-" + data["teampmrcolor"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["teampmrpercent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["teampmrpercent"] + "%\"><span class=\"sr-only\">" + data["teampmrpercent"] + "%</span></div>";

					if (parseFloat(scoreBox1.innerText) != parseFloat(data["teamscore"])) {
						var scoreAnimation1 = new CountUp(scoreBox1, scoreBox1.innerText, data["teamscore"], 2, 4);
						scoreAnimation1.start();
					}

				}
			});

		}, 3000);

		loopThroughArray(TEAM_ROSTER_1, function (arrayElement, loopTime) {

			var thisPlayerID = arrayElement;
			var data = {"league":"<%= TeamLevelTitle1 %>","team":<%= TeamCBSID1 %>,"id":thisPlayerID};
			data = $.param(data);

			$.ajax({
				type: "GET",
				dataType: "json",
				url: "/scores/player/json/",
				data: data,
				success: function(data) {

					var playerPoints = document.getElementsByClassName('team-1-player-' + thisPlayerID + '-points')[0];
					var playerStats = document.getElementsByClassName('team-1-player-' + thisPlayerID + '-stats')[0];
					var playerGameLine = document.getElementsByClassName('team-1-player-' + thisPlayerID + '-gameline')[0];
					var playerGamePosition = document.getElementsByClassName('team-1-player-' + thisPlayerID + '-gameposition')[0];
					var playerPMR = document.getElementsByClassName('team-1-player-' + thisPlayerID + '-progress')[0];

					playerGameLine.innerHTML = data["gameline"];
					playerGamePosition.innerHTML = data["gameposition"];
					playerPMR.innerHTML = "<div class=\"progress-bar progress-bar-" + data["pmrcolor"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["pmrpercent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["pmrpercent"] + "%\"><span class=\"sr-only\">" + data["pmrpercent"] + "%</span></div>";

					if (parseFloat(playerPoints.innerText) != parseFloat(data["points"])) {
						var scoreAnimation = new CountUp(playerPoints, playerPoints.innerText, data["points"], 2, 4);
						scoreAnimation.start();
					}

				}
			});

		}, 3000);

		loopThroughArray(TEAM_ROSTER_2, function (arrayElement, loopTime) {

			var thisPlayerID = arrayElement;
			var data = {"league":"<%= TeamLevelTitle1 %>","team":<%= TeamCBSID2 %>,"id":thisPlayerID};
			data = $.param(data);

			$.ajax({
				type: "GET",
				dataType: "json",
				url: "/scores/player/json/",
				data: data,
				success: function(data) {

					var playerPoints = document.getElementsByClassName('team-2-player-' + thisPlayerID + '-points')[0];
					var playerStats = document.getElementsByClassName('team-2-player-' + thisPlayerID + '-stats')[0];
					var playerGameLine = document.getElementsByClassName('team-2-player-' + thisPlayerID + '-gameline')[0];
					var playerGamePosition = document.getElementsByClassName('team-2-player-' + thisPlayerID + '-gameposition')[0];
					var playerPMR = document.getElementsByClassName('team-2-player-' + thisPlayerID + '-progress')[0];

					playerGameLine.innerHTML = data["gameline"];
					playerGamePosition.innerHTML = data["gameposition"];
					playerPMR.innerHTML = "<div class=\"progress-bar progress-bar-" + data["pmrcolor"] + "\" role=\"progressbar\" aria-valuenow=\"" + data["pmrpercent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + data["pmrpercent"] + "%\"><span class=\"sr-only\">" + data["pmrpercent"] + "%</span></div>";

					if (parseFloat(playerPoints.innerText) != parseFloat(data["points"])) {
						var scoreAnimation = new CountUp(playerPoints, playerPoints.innerText, data["points"], 2, 4);
						scoreAnimation.start();
					}

				}
			});

		}, 3000);

	});
</script>
