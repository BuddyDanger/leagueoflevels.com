<script>

    $(function () {

        var MATCHUPS = [<%= thisWeeklyMatchups %>];

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
                success: function (data) {

                    let json = data["matchups"];

                    for (let i = 0; i < json.length; i++) {

                        let obj = json[i];
                        let pmrc1 = 'success', pmrc2 = 'success';
                        let update = 0;

                        if (parseFloat(obj.pmrp1) <= 66.6666) pmrc1 = 'warning';
                        if (parseFloat(obj.pmrp1) <= 33.3333) pmrc1 = 'danger';
                        if (parseFloat(obj.pmrp2) <= 66.6666) pmrc2 = 'warning';
                        if (parseFloat(obj.pmrp2) <= 33.3333) pmrc2 = 'danger';

                        const matchIdSuffix = `-${obj.id}`;

                        let objScore1 = document.querySelector(`.team-${obj.level}-score-${obj.id1}${matchIdSuffix}`);
                        let objPMR1 = document.querySelector(`.team-${obj.level}-progress-${obj.id1}${matchIdSuffix}`);
                        if (objPMR1) {
                            objPMR1.innerHTML = `<div class="progress-bar progress-bar-${pmrc1}" role="progressbar" aria-valuenow="${obj.pmrp1}" aria-valuemin="0" aria-valuemax="100" style="width: ${obj.pmrp1}%"><span class="sr-only">${obj.pmrp1}%</span></div>`;
                        }
                        if (objScore1 && parseFloat(objScore1.innerText).toFixed(2) != parseFloat(obj.score1).toFixed(2)) {
                            var scoreAnimation1 = new CountUp(objScore1, parseFloat(objScore1.innerText).toFixed(2), parseFloat(obj.score1).toFixed(2), 1, 2);
                            scoreAnimation1.start();
                            update = 1;
                        }

                        let objScore2 = document.querySelector(`.team-${obj.level}-score-${obj.id2}${matchIdSuffix}`);
                        let objPMR2 = document.querySelector(`.team-${obj.level}-progress-${obj.id2}${matchIdSuffix}`);
                        if (objPMR2) {
                            objPMR2.innerHTML = `<div class="progress-bar progress-bar-${pmrc2}" role="progressbar" aria-valuenow="${obj.pmrp2}" aria-valuemin="0" aria-valuemax="100" style="width: ${obj.pmrp2}%"><span class="sr-only">${obj.pmrp2}%</span></div>`;
                        }
                        if (objScore2 && parseFloat(objScore2.innerText).toFixed(2) != parseFloat(obj.score2).toFixed(2)) {
                            var scoreAnimation2 = new CountUp(objScore2, parseFloat(objScore2.innerText).toFixed(2), parseFloat(obj.score2).toFixed(2), 1, 2);
                            scoreAnimation2.start();
                            update = 1;
                        }

                        if (update == 1) {
                            let objBox = document.querySelector(`.matchup-${obj.id}`);
                            if (objBox) {
                                objBox.classList.add("box-glow");
                            }
                            console.log(`${obj.name1} (${obj.score1}) vs. ${obj.name2} (${obj.score2})`);
                        }

                    }

                }
            });

        }, 7000);

        loopThroughArray(MATCHUPS, function (arrayElement, loopTime) {

            let objBox = document.querySelector(`.matchup-${arrayElement}`);
            if (objBox) {
                objBox.classList.remove("box-glow");
            }

        }, 5000);

    });

</script>
