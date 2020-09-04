<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!DOCTYPE html>
<html lang="en">
	
	<head>
	
		<meta charset="utf-8" />
		
		<title>The League of Levels</title>
		
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta content="" name="description" />
		<meta content="" name="author" />
		
		<link rel="shortcut icon" href="#">
		
		<link href="/assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/icons.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/style.css?version=2" rel="stylesheet" type="text/css" />
		
		<style>
		
.hero {position:relative; text-align: center; overflow: hidden; color: #fcfcfc; }
.hero h1 {font-family: 'Holtwood One SC', serif;font-weight: normal;font-size: 5.4em;line-height: 1;margin:0 0 20px; text-shadow:0 0 12px rgba(0, 0, 0, 0.5);text-transform: uppercase;letter-spacing:-1px;}
.hero p {font-family: 'Abel', sans-serif;text-transform: uppercase; color: #5CCA87; letter-spacing: 6px;text-shadow:0 0 12px rgba(0, 0, 0, 0.5);font-size: 1.2em;}
.hero-wrap {padding: 3.5em 10px;}
.hero p.intro {font-family: 'Holtwood One SC', serif;text-transform: uppercase;letter-spacing: 1px;font-size: 3em;margin-bottom:10px;}
.hero p.year {color: #fff; letter-spacing: 20px; font-size: 34px; margin: -25px 0 25px;}
.hero p.year i {font-size: 14px;vertical-align: middle;}
#bracket {overflow:hidden;background-color: #edeef0;padding-top: 20px;font-size: 12px;padding: 40px 0;}
.container {max-width: 1440px;margin: 0 auto;display:block;display: -webkit-box;display: -moz-box;display: -ms-flexbox;display: -webkit-flex;display: -webkit-flex;display: flex;-webkit-flex-direction:row;flex-direction: row;}
.split {display:block;display: -webkit-box;display: -moz-box;display: -ms-flexbox;display: -webkit-flex;display:flex;width: 100%;-webkit-flex-direction:row;-moz-flex-direction:row;flex-direction:row;margin: 0 2.5% 0 0;}
.champion {display:block;width: 16%;-webkit-flex-direction:row;flex-direction:row;-webkit-align-self:center;align-self:center;margin-top: -15px;text-align: center;padding: 230px 0\9;} 
.champion i {color: #a0a6a8; font-size: 45px;padding: 10px 0; }
.round {display:block;float:left;display: -webkit-box;display: -moz-box;display: -ms-flexbox;display: -webkit-flex;display:flex;-webkit-flex-direction:column;flex-direction:column;width:95%;width:30.8333%\9;}
.matchup {margin:0;width: 100%;padding: 10px 0;height:60px;-webkit-transition: all 0.2s;transition: all 0.2s;}
.score {font-size: 11px;text-transform: uppercase;float: right;color: #2C7399;font-weight: bold;font-family: 'Roboto Condensed', sans-serif;position: absolute;right: 5px;}
.team {padding: 0 5px;margin: 3px 0;height: 25px; line-height: 25px;white-space: nowrap; overflow: hidden;position: relative;}
.round-details {font-family: 'Roboto Condensed', sans-serif; font-size: 13px; color: #2C7399;text-transform: uppercase;text-align: center;height: 40px;}
.champion li, .round li {background-color: #fff;box-shadow: none; opacity: 0.45;}
.current li {opacity: 1;}
.current li.team {background-color: #fff;box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);opacity: 1;}
.vote-options {display: block;height: 52px;}
.share .container {margin: 0 auto; text-align: center;}
.share-icon {font-size: 24px; color: #fff;padding: 25px;}
.share-wrap {max-width: 1100px; text-align: center; margin: 60px auto;}

.matchup01 { padding-top: 0px; }
.matchup02 { padding-top: 250px; }
.matchup03 { padding-top: 130px; }
.matchup04 { padding-top: 250px; }

.matchup05 { padding-top: 40px; }
.matchup06 { padding-top: 100px; }
.matchup07 { padding-top: 50px; }
.matchup08 { padding-top: 210px; }
.matchup09 { padding-top: 50px; }
.matchup10 { padding-top: 50px; }

.matchup11 { padding-top: 80px; }
.matchup12 { padding-top: 50px; }
.matchup13 { padding-top: 50px; }
.matchup14 { padding-top: 130px; }
.matchup15 { padding-top: 50px; }
.matchup16 { padding-top: 50px; }

.matchup17 { padding-top: 140px; }
.matchup18 { padding-top: 150px; }
.matchup19 { padding-top: 50px; }
.matchup20 { padding-top: 150px; }

.matchup21 { padding-top: 260px; }
.matchup22 { padding-top: 250px; }
.matchup23 { padding-top: 420px; }

@-webkit-keyframes pulse {
0% {
-webkit-transform: scale(1);
transform: scale(1);
}

50% {
-webkit-transform: scale(1.3);
transform: scale(1.3);
}

100% {
-webkit-transform: scale(1);
transform: scale(1);
}
}

@keyframes pulse {
0% {
-webkit-transform: scale(1);
-ms-transform: scale(1);
transform: scale(1);
}

50% {
-webkit-transform: scale(1.3);
-ms-transform: scale(1.3);
transform: scale(1.3);
}

100% {
-webkit-transform: scale(1);
-ms-transform: scale(1);
transform: scale(1);
}
}

.share-icon {color: #fff; opacity: 0.35; }
.share-icon:hover { opacity:1;  -webkit-animation: pulse 0.5s; animation: pulse 0.5s;}
.date {font-size: 10px; letter-spacing: 2px;font-family: 'Istok Web', sans-serif;color:#3F915F;}



@media screen and (min-width: 981px) and (max-width: 1099px) {
.container {margin: 0 1%;}
.champion {width: 14%;}
.hero p.intro {font-size: 28px;}
.hero p.year {margin: 5px 0 10px;}

}

@media screen and (min-width: 401px) and (max-width: 980px) {
.container {-webkit-flex-direction:column;-moz-flex-direction:column;flex-direction:column;}
.split {width: 95%; margin: 35px 5%;border-bottom: 1px solid #b6b6b6; padding-bottom: 20px;}
.hero p.intro {font-size: 24px;}
.hero h1 {font-size: 3em; margin: 15px 0;}
.hero p {font-size: 1em;}
}


@media (min-width: 400px) and (max-width: 980px) {

.split {width: 95%;margin: 25px 2.5%;}
.round {width:21%;}.champion {width: 14%;}
.current {-webkit-flex-grow:1;-moz-flex-grow:1;flex-grow:1;}
.hero h1 {font-size: 2.15em; letter-spacing: 0;margin:0; }
.hero p.intro {font-size: 1.15em;margin-bottom: -10px;}
.round-details {font-size: 90%;}
.hero-wrap {padding: 2.5em;}
.hero p.year {margin: 5px 0 10px; font-size: 18px;}
.matchup { padding-top: 10px; margin-top: 0; padding-bottom: 0px; margin-bottom: 0; }

}
		</style>
		
	</head>
	
	<body>
	
		<!--#include virtual="/assets/asp/framework/topbar.asp" -->
		
		<div class="page-wrapper">
		
			<!--#include virtual="/assets/asp/framework/nav.asp" -->
			
			<div class="page-content">
			
		
			<div class="container">
			
				<div class="split split-one">
					<div class="round round-one current">
						<div class="round-details">Round 1<br/><span class="date">September 5</span></div>
						<ul class="matchup matchup01">
							<li class="team team-top">(20) Woods You Rather?<span class="score"></span></li>
							<li class="team team-bottom">(22) Hanging with Hernandez<span class="score"></span></li>
						</ul>
						<ul class="matchup matchup02">
							<li class="team team-top">(17) München on Bündchen<span class="score"></span></li>
							<li class="team team-bottom">(24) Gridiron Warfare<span class="score"></span></li>
						</ul>
						<ul class="matchup matchup03">
							<li class="team team-top">(23) Sacks in the City<span class="score"></span></li>
							<li class="team team-bottom">(18) Ol Broken Jankles<span class="score"></span></li>
						</ul>
						<ul class="matchup matchup04">
							<li class="team team-top">(21) Big TD'S<span class="score"></span></li>
							<li class="team team-bottom">(19) Fournette Caters<span class="score"></span></li>
						</ul>
					</div>
				</div>
				
				<div class="split split-one">
					<div class="round round-one current">
						<div class="round-details">Round 2<br/><span class="date">September 19</span></div>			
						<ul class="matchup matchup05">
							<li class="team team-top">&nbsp;<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">(16) Talk To The Hand<span class="score">&nbsp;</span></li>
						</ul>	
						<ul class="matchup matchup06">
							<li class="team team-top">(13) Holding Court<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">(12) Smokin Blountz<span class="score">&nbsp;</span></li>
						</ul>
						<ul class="matchup matchup07">
							<li class="team team-top">&nbsp;<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">(10) AOL 4 Life<span class="score">&nbsp;</span></li>
						</ul>
						
						<ul class="matchup matchup08">
							<li class="team team-top">&nbsp;<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">(9) BOOYAAHH<span class="score">&nbsp;</span></li>
						</ul>	
						<ul class="matchup matchup09">
							<li class="team team-top">(11) Terrible Towelie<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">(14) Jackhammer<span class="score">&nbsp;</span></li>
						</ul>
						<ul class="matchup matchup10">
							<li class="team team-top">(15) AnyGivenSundae<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">&nbsp;<span class="score">&nbsp;</span></li>
						</ul>
					</div>
				</div>
				
				<div class="split split-one">
					<div class="round round-one current">
						<div class="round-details">Round 3<br/><span class="date">October 3</span></div>			
						<ul class="matchup matchup11">
							<li class="team team-top">&nbsp;<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">(4) Buddy Danger<span class="score">&nbsp;</span></li>
						</ul>	
						<ul class="matchup matchup12">
							<li class="team team-top"> <span class="score">&nbsp;</span></li>
							<li class="team team-bottom">(5) Connecticut Coheeds<span class="score">&nbsp;</span></li>
						</ul>	
						<ul class="matchup matchup13">
							<li class="team team-top">&nbsp;<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">(8) Ten Foot Midget<span class="score">&nbsp;</span></li>
						</ul>		
						
						<ul class="matchup matchup14">
							<li class="team team-top">(7) Bapes<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">&nbsp;<span class="score">&nbsp;</span></li>
						</ul>	
						<ul class="matchup matchup15">
							<li class="team team-top">(6) High Decibels<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">&nbsp;<span class="score">&nbsp;</span></li>
						</ul>	
						<ul class="matchup matchup16">
							<li class="team team-top">(3) Blitzed<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">&nbsp;<span class="score">&nbsp;</span></li>
						</ul>						
					</div>
				</div>
				
				<div class="split split-one">
					<div class="round round-one current">
						<div class="round-details">Round 4<br/><span class="date">October 17</span></div>			
						<ul class="matchup matchup17">
							<li class="team team-top">&nbsp;<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">&nbsp;<span class="score">&nbsp;</span></li>
						</ul>
						<ul class="matchup matchup18">
							<li class="team team-top">&nbsp;<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">(1) 4th and 9 Inches<span class="score">&nbsp;</span></li>
						</ul>
						<ul class="matchup matchup19">
							<li class="team team-top">(2) Proper Football<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">&nbsp;<span class="score">&nbsp;</span></li>
						</ul>
						<ul class="matchup matchup20">
							<li class="team team-top">&nbsp;<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">&nbsp;<span class="score">&nbsp;</span></li>
						</ul>
					</div>
				</div>
				
				<div class="split split-one">
					<div class="round round-one current">
						<div class="round-details">Round 5<br/><span class="date">October 31</span></div>			
						<ul class="matchup matchup21">
							<li class="team team-top">&nbsp;<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">&nbsp;<span class="score">&nbsp;</span></li>
						</ul>
						<ul class="matchup matchup22">
							<li class="team team-top">&nbsp;<span class="score">&nbsp;</span></li>
							<li class="team team-bottom">&nbsp;<span class="score">&nbsp;</span></li>
						</ul>
					</div>
				</div>
				
				<div class="split split-one">
					<div class="round round-one current">
						<div class="round-details">championship <br/><span class="date">November 14</span></div>		
						<ul class ="matchup matchup23 championship">
							<li class="team team-top">&nbsp;<span class="vote-count">&nbsp;</span></li>
							<li class="team team-bottom">&nbsp;<span class="vote-count">&nbsp;</span></li>
						</ul>
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
		
		
	</body>
	
</html>