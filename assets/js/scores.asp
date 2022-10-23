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
						var objPMR1 = document.getElementsByClassName('team-' + obj.level + '-progress-' + obj.id1)[0];
						objPMR1.innerHTML = "<div class=\"progress-bar progress-bar-" + pmrc1 + "\" role=\"progressbar\" aria-valuenow=\"" + obj.pmrp1 + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + obj.pmrp1 + "%\"><span class=\"sr-only\">" + obj.pmrp1 + "%</span></div>";
						if (parseFloat(objScore1.innerText) != parseFloat(obj.score1)) {
							var scoreAnimation1 = new CountUp(objScore1, objScore1.innerText, obj.score1, 2, 2);
							scoreAnimation1.start();
							update = 1;
						}

						var objScore2 = document.getElementsByClassName('team-' + obj.level + '-score-' + obj.id2)[0];
						var objPMR2 = document.getElementsByClassName('team-' + obj.level + '-progress-' + obj.id2)[0];
						objPMR2.innerHTML = "<div class=\"progress-bar progress-bar-" + pmrc2 + "\" role=\"progressbar\" aria-valuenow=\"" + obj.pmrp2 + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + obj.pmrp2 + "%\"><span class=\"sr-only\">" + obj.pmrp2 + "%</span></div>";
						if (parseFloat(objScore2.innerText) != parseFloat(obj.score2)) {
							var scoreAnimation2 = new CountUp(objScore2, objScore2.innerText, obj.score2, 2, 2);
							scoreAnimation2.start();
							update = 1;
						}

						if (update == 1) {
							var objBox = document.getElementsByClassName('matchup-' + obj.id)[0];
							objBox.classList.add("box-glow");
						}

						if (obj.level != 'omega' && obj.level != 'cup') {
							var objScore1 = document.getElementsByClassName('team-' + obj.level + '-score-' + obj.id1)[1];
							var objPMR1 = document.getElementsByClassName('team-' + obj.level + '-progress-' + obj.id1)[1];
							objPMR1.innerHTML = "<div class=\"progress-bar progress-bar-" + pmrc1 + "\" role=\"progressbar\" aria-valuenow=\"" + obj.pmrp1 + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + obj.pmrp1 + "%\"><span class=\"sr-only\">" + obj.pmrp1 + "%</span></div>";
							if (parseFloat(objScore1.innerText) != parseFloat(obj.score1)) {
								var scoreAnimation1 = new CountUp(objScore1, objScore1.innerText, obj.score1, 2, 2);
								scoreAnimation1.start();
							}

							var objScore2 = document.getElementsByClassName('team-' + obj.level + '-score-' + obj.id2)[1];
							var objPMR2 = document.getElementsByClassName('team-' + obj.level + '-progress-' + obj.id2)[1];
							objPMR2.innerHTML = "<div class=\"progress-bar progress-bar-" + pmrc2 + "\" role=\"progressbar\" aria-valuenow=\"" + obj.pmrp2 + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + obj.pmrp2 + "%\"><span class=\"sr-only\">" + obj.pmrp2 + "%</span></div>";
							if (parseFloat(objScore2.innerText) != parseFloat(obj.score2)) {
								var scoreAnimation2 = new CountUp(objScore2, objScore2.innerText, obj.score2, 2, 2);
								scoreAnimation2.start();
							}
						}

						console.log(obj.name1 + ' (' + obj.score1 + ') vs. ' + obj.name2 + ' (' + obj.score2 + ')');

					}

				}
			});

		}, 5000);

		loopThroughArray(MATCHUPS, function (arrayElement, loopTime) {

			var objBox = document.getElementsByClassName('matchup-' + arrayElement)[0];
			objBox.classList.remove("box-glow");

		}, 3500);

	});
</script>
