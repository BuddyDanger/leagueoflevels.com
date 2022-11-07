<script>

	var MATCHUPS = [0]

	$(function () {

		var TEAM_ID1 = [<%= thisTeamID1 %>]
		var TEAM_ID2 = [<%= thisTeamID2 %>]
		var TEAM_ROSTER_1_RUNS = 0;

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

		loopThroughArray([0], function (arrayElement, loopTime) {

			var team1 = $.param({"version":"3.0","response_format":"json","league_id":"<%= thisTeamLevelTitle1 %>","team_id":"<%= thisTeamCBSID1 %>","period":"<%= Session.Contents("CurrentPeriod") %>","access_token":"<%= GetToken(thisTeamLevelTitle1) %>"});
			var team2 = $.param({"version":"3.0","response_format":"json","league_id":"<%= thisTeamLevelTitle2 %>","team_id":"<%= thisTeamCBSID2 %>","period":"<%= Session.Contents("CurrentPeriod") %>","access_token":"<%= GetToken(thisTeamLevelTitle2) %>"});
			$.ajax({ cache: false, type: "GET", dataType: "json", url: "https://api.cbssports.com/fantasy/league/scoring/live", data: team1, success: function(team1) { setPlayers(team1, 1); } });
			$.ajax({ cache: false, type: "GET", dataType: "json", url: "https://api.cbssports.com/fantasy/league/scoring/live", data: team2, success: function(team2) { setPlayers(team2, 2); } });

		}, 3000);

		function setPlayers (data, team) {

			let body = data["body"];
			let teams = body.live_scoring.teams;
			let players = teams[0].players;
			let pts = teams[0].pts;
			let pmr = teams[0].pmr;
			let weekday = ["SUN","MON","TUE","WED","THU","FRI","SAT"];

			var scoreboardPoints = document.getElementsByClassName('team-' + team + '-score')[0];
			if (parseFloat(scoreboardPoints.innerText).toFixed(2) != parseFloat(pts).toFixed(2)) {
				var scoreAnimation = new CountUp(scoreboardPoints, scoreboardPoints.innerText, parseFloat(pts).toFixed(2), 2, 2);
				scoreAnimation.start();
			}

			for(let i = 0; i < players.length; i++) {

				let player = players[i];

				var scoreboardPlayer = document.getElementsByClassName('team-' + team + '-player-' + player.id)[0];
				var scoreboardPlayerPoints = document.getElementsByClassName('team-' + team + '-player-' + player.id + '-points')[0];
				var scoreboardPlayerStats = document.getElementsByClassName('team-' + team + '-player-' + player.id + '-stats')[0];
				var scoreboardPlayerGameLine = document.getElementsByClassName('team-' + team + '-player-' + player.id + '-gameline')[0];
				var scoreboardPlayerGameTime = document.getElementsByClassName('team-' + team + '-player-' + player.id + '-gametime')[0];
				var scoreboardPlayerPhoto = document.getElementsByClassName('team-' + team + '-player-' + player.id + '-photo')[0];
				var scoreboardPlayerPhotoLoading = document.getElementsByClassName('team-' + team + '-player-' + player.id + '-photo-loading')[0];
				var scoreboardPlayerName = document.getElementsByClassName('team-' + team + '-player-' + player.id + '-name')[0];

				var live_GameInfo_Week = player.game_info.week;
				var live_GameInfo_MinutesRemaining = player.game_info.minutes_remaining;
				var live_Player_Stats = player.stats_period;
				var live_Player_Points = player.fpts;
				var live_Player_Photo = player.photo;
				var live_Player_Position = player.position;
				var live_Player_Team = player.pro_team;
				var live_Player_Name = player.fullname;
				var live_Player_FirstName = player.firstname;
				var live_Player_LastName = player.lastname;
				var live_Player_ID = player.id;

				var live_Player_FirstInitial = Array.from(live_Player_FirstName)[0];
				var live_Player_ShortName = live_Player_FirstInitial + ". " + live_Player_LastName;

				if (live_Player_Position == "DST") { live_Player_ShortName = live_Player_LastName; }

				if (scoreboardPlayerPhoto.classList.contains('d-none')) {

					scoreboardPlayerPhoto.src = live_Player_Photo.replaceAll('http:', 'https:');
					scoreboardPlayerPhotoLoading.classList.add("d-none");
					scoreboardPlayerPhoto.classList.remove("d-none");
					scoreboardPlayerName.innerHTML = '<b>' + live_Player_ShortName + '</b>';

				}

				if (live_GameInfo_Week != null) {

					var live_GameInfo_GameStatus = player.game_info.game_status;
					var live_GameInfo_GameTimestamp = player.game_info.game_start_timestamp;
					var live_GameInfo_GameStartTime = player.game_info.game_start_time.replace(/\s/g, '').toUpperCase();
					var live_GameInfo_HomeGame = player.game_info.home_game;
					var live_GameInfo_Opponent = player.game_info.opponent;
					var live_GameInfo_TimeRemainingQuarter = player.game_info.time_remaining;
					var live_GameInfo_CurrentQuarter = player.game_info.quarter;

					if (live_GameInfo_GameStatus == "P") {
						scoreboardPlayerGameTime.innerHTML = live_GameInfo_CurrentQuarter + 'Q ' + live_GameInfo_TimeRemainingQuarter;
						scoreboardPlayerGameTime.classList.remove("d-none");
						scoreboardPlayerGameLine.classList.add("d-none");

						scoreboardPlayerStats.innerHTML = live_Player_Stats;
						scoreboardPlayerStats.classList.remove("d-none");
						scoreboardPlayerStats.classList.add("d-block");
					} else if (live_GameInfo_GameStatus == "F") {
						scoreboardPlayerGameTime.innerHTML = "FINAL";
						scoreboardPlayerGameTime.classList.remove("d-none");
						scoreboardPlayerStats.classList.remove("d-none");
						scoreboardPlayerGameLine.classList.add("d-none");
						scoreboardPlayer.classList.add("inactive-player");
					}

					live_GameInfo_Matchup = live_Player_Team + ' @ ' + live_GameInfo_Opponent;
					if (live_GameInfo_HomeGame == "1") { live_GameInfo_Matchup = live_Player_Team + ' vs. ' + live_GameInfo_Opponent }

					var live_GameInfo_Gameline = new Date('1970-01-01 00:00:00');
					live_GameInfo_Gameline.setSeconds(live_GameInfo_Gameline.getSeconds() + live_GameInfo_GameTimestamp);
					live_GameInfo_Gameline.setHours(live_GameInfo_Gameline.getHours() - 5);
					let live_GameInfo_Gameday = weekday[live_GameInfo_Gameline.getDay()];

					scoreboardPlayerGameLine.innerHTML = live_GameInfo_Matchup + ' - ' + live_GameInfo_Gameday + ' ' + live_GameInfo_GameStartTime;
					scoreboardPlayerStats.innerHTML = live_Player_Stats;

					if (parseFloat(scoreboardPlayerPoints.innerText).toFixed(2) != parseFloat(player.fpts).toFixed(2)) {
						var scoreAnimation = new CountUp(scoreboardPlayerPoints, parseFloat(scoreboardPlayerPoints.innerText).toFixed(2), parseFloat(player.fpts).toFixed(2), 2, 1);
						scoreAnimation.start();
					}

				} else {

					scoreboardPlayerGameLine.innerHTML = "BYE";
					scoreboardPlayer.classList.add("inactive-player");

				}
			}
		}

		loopThroughArray(MATCHUPS, function (arrayElement, loopTime) {

			$.ajax({
				type: "GET",
				dataType: "json",
				url: "/scores/json/period/",
				success: function(data) {

					let json = data["matchups"];

					for(let i = 0; i < json.length; i++) {

						let obj = json[i];

						var pmrc1, pmrc2; pmrc1 = pmrc2 = 'success';
						var update = 0;
						if (parseFloat(obj.pmrp1) <= 66.6666) { pmrc1 = 'warning' } if (parseFloat(obj.pmrp1) <= 33.3333) { pmrc1 = 'danger' }
						if (parseFloat(obj.pmrp2) <= 66.6666) { pmrc2 = 'warning' } if (parseFloat(obj.pmrp2) <= 33.3333) { pmrc2 = 'danger' }

						var objScore1 = document.getElementsByClassName('team-' + obj.level + '-score-' + obj.id1)[0];
						if (parseFloat(objScore1.innerText).toFixed(2) != parseFloat(obj.score1).toFixed(2)) {
							var scoreAnimation1 = new CountUp(objScore1, parseFloat(objScore1.innerText).toFixed(2), parseFloat(obj.score1).toFixed(2), 2, 1);
							scoreAnimation1.start();
							update = 1;
						}

						var objScore2 = document.getElementsByClassName('team-' + obj.level + '-score-' + obj.id2)[0];
						if (parseFloat(objScore2.innerText).toFixed(2) != parseFloat(obj.score2).toFixed(2)) {
							var scoreAnimation2 = new CountUp(objScore2, parseFloat(objScore2.innerText).toFixed(2), parseFloat(obj.score2), 2, 1);
							scoreAnimation2.start();
							update = 1;
						}

						if (update == 1) {
							var objBox = document.getElementsByClassName('matchup-' + obj.id)[0];
							objBox.classList.add("box-glow");
							console.log(obj.name1 + ' (' + obj.score1 + ') vs. ' + obj.name2 + ' (' + obj.score2 + ')');
						}

					/*	if (obj.level != 'omega' && obj.level != 'cup' && update == 1) {
							var objScore1b = document.getElementsByClassName('team-' + obj.level + '-score-' + obj.id1)[1];
							if (parseFloat(objScore1b.innerText).toFixed(2) != parseFloat(obj.score1).toFixed(2)) {
								var scoreAnimation1b = new CountUp(objScore1b, objScore1b.innerText, obj.score1, 2, 1);
								objScore1b.innerText = obj.score1;
								scoreAnimation1b.start();
							}

							var objScore2b = document.getElementsByClassName('team-' + obj.level + '-score-' + obj.id2)[1];
							if (parseFloat(objScore2b.innerText).toFixed(2) != parseFloat(obj.score2).toFixed(2)) {
								var scoreAnimation2b = new CountUp(objScore2b, objScore2b.innerText, obj.score2, 2, 1);
								objScore2b.innerText = obj.score2;
								scoreAnimation2b.start();
							}
						}
						*/
					}

				}
			});

		}, 10000);

	});
</script>
