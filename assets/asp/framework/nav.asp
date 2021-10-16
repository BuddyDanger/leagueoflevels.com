<div class="left-sidenav">

	<div class="main-icon-menu">

		<nav class="nav">

			<a href="#navigation" class="nav-link" data-toggle="tooltip-custom" data-placement="top" title="" data-original-title="NAVIGATION">
				<svg class="nav-svg" xmlns="https://www.w3.org/2000/svg" viewBox="0 0 512 512">
					<path class="svg-primary" d="M256 32C132.288 32 32 132.288 32 256s100.288 224 224 224 224-100.288 224-224S379.712 32 256 32zm135.765 359.765C355.5 428.028 307.285 448 256 448s-99.5-19.972-135.765-56.235C83.972 355.5 64 307.285 64 256s19.972-99.5 56.235-135.765C156.5 83.972 204.715 64 256 64s99.5 19.972 135.765 56.235C428.028 156.5 448 204.715 448 256s-19.972 99.5-56.235 135.765z"/>
					<path d="M200.043 106.067c-40.631 15.171-73.434 46.382-90.717 85.933H256l-55.957-85.933zM412.797 288A160.723 160.723 0 0 0 416 256c0-36.624-12.314-70.367-33.016-97.334L311 288h101.797zM359.973 134.395C332.007 110.461 295.694 96 256 96c-7.966 0-15.794.591-23.448 1.715L310.852 224l49.121-89.605zM99.204 224A160.65 160.65 0 0 0 96 256c0 36.639 12.324 70.394 33.041 97.366L201 224H99.204zM311.959 405.932c40.631-15.171 73.433-46.382 90.715-85.932H256l55.959 85.932zM152.046 377.621C180.009 401.545 216.314 416 256 416c7.969 0 15.799-.592 23.456-1.716L201.164 288l-49.118 89.621z"/>
				</svg>
			</a>

			<a href="#layers" class="nav-link" data-toggle="tooltip-custom" data-placement="top" title="" data-original-title="LAYERS">
				<svg class="nav-svg" xmlns="https://www.w3.org/2000/svg" viewBox="0 0 512 512">
					<path d="M70.7 164.5l169.2 81.7c4.4 2.1 10.3 3.2 16.1 3.2s11.7-1.1 16.1-3.2l169.2-81.7c8.9-4.3 8.9-11.3 0-15.6L272.1 67.2c-4.4-2.1-10.3-3.2-16.1-3.2s-11.7 1.1-16.1 3.2L70.7 148.9c-8.9 4.3-8.9 11.3 0 15.6z"/>
					<path class="svg-primary" d="M441.3 248.2s-30.9-14.9-35-16.9-5.2-1.9-9.5.1S272 291.6 272 291.6c-4.5 2.1-10.3 3.2-16.1 3.2s-11.7-1.1-16.1-3.2c0 0-117.3-56.6-122.8-59.3-6-2.9-7.7-2.9-13.1-.3l-33.4 16.1c-8.9 4.3-8.9 11.3 0 15.6l169.2 81.7c4.4 2.1 10.3 3.2 16.1 3.2s11.7-1.1 16.1-3.2l169.2-81.7c9.1-4.2 9.1-11.2.2-15.5z"/>
					<path d="M441.3 347.5s-30.9-14.9-35-16.9-5.2-1.9-9.5.1S272.1 391 272.1 391c-4.5 2.1-10.3 3.2-16.1 3.2s-11.7-1.1-16.1-3.2c0 0-117.3-56.6-122.8-59.3-6-2.9-7.7-2.9-13.1-.3l-33.4 16.1c-8.9 4.3-8.9 11.3 0 15.6l169.2 81.7c4.4 2.2 10.3 3.2 16.1 3.2s11.7-1.1 16.1-3.2l169.2-81.7c9-4.3 9-11.3.1-15.6z"/>
				</svg>
			</a>

		</nav>

	</div>

	<div class="main-menu-inner">

		<div class="menu-body slimscroll">

			<div id="navigation" class="main-icon-menu-pane">

				<div class="title-box">
					<h6 class="menu-title">NAVIGATION</h6>
				</div>

				<ul class="nav">
					<li class="nav-item"><a class="nav-link" href="/"><i class="dripicons-meter"></i>Dashboard</a></li>
					<!--<li class="nav-item"><a class="nav-link" href="/lottery/"><i class="dripicons-network-3"></i>Lottery</a></li>-->
					<li class="nav-item"><a class="nav-link" href="/sportsbook/"><i class="dripicons-ticket"></i>Sportsbook</a></li>
					<li class="nav-item"><a class="nav-link" href="/scores/"><i class="dripicons-rocket"></i>Live Scoring</a></li>
					<li class="nav-item"><a class="nav-link" href="/standings/"><i class="dripicons-view-list"></i>Standings</a></li>
					<li class="nav-item"><a class="nav-link" href="/majors/"><i class="dripicons-trophy"></i>Majors</a></li>
					<li class="nav-item"><a class="nav-link" href="/schmeckles/"><i class="dripicons-card"></i>Schmeckles</a></li>
					<li class="nav-item"><a class="nav-link" href="/eliminator/"><i class="dripicons-warning"></i>Eliminator</a></li>
					<li class="nav-item"><a class="nav-link" href="/power-rankings/"><i class="dripicons-star"></i>Power Rankings</a></li>
					<!--<li class="nav-item"><a class="nav-link" href="/teams/"><i class="dripicons-user-group"></i>Teams</a></li>-->
					<!--<li class="nav-item"><a class="nav-link" href="/schedule/"><i class="dripicons-calendar"></i>Schedule</a></li>-->

					<li class="nav-item <% If Session.Contents("LoggedIn") = "yes" Then %>d-block<% Else %>d-none<% End If %>"><a class="nav-link" href="/account/"><i class="dripicons-toggles"></i>Account Profile</a></li>
					<li class="nav-item <% If Session.Contents("LoggedIn") <> "yes" Then %>d-block<% Else %>d-none<% End If %>"><a class="nav-link" href="/account/login/"><i class="dripicons-enter"></i>Login</a></li>
					<li class="nav-item <% If Session.Contents("LoggedIn") <> "yes" Then %>d-block<% Else %>d-none<% End If %>"><a class="nav-link" href="/account/register/"><i class="dripicons-user-id"></i>Register</a></li>
					<li class="nav-item <% If Session.Contents("LoggedIn") <> "yes" Then %>d-block<% Else %>d-none<% End If %>"><a class="nav-link" href="/account/reset-password/"><i class="dripicons-retweet"></i>Reset Password</a></li>
				</ul>

			</div>

			<div id="layers" class="main-icon-menu-pane">

				<div class="title-box">
					<h6 class="menu-title">LAYERS</h6>
				</div>

				<ul class="nav">
					<li class="nav-item"><a class="nav-link" href="/podcasts/"><i class="dripicons-headset"></i>Podcasts</a></li>
					<li class="nav-item"><a class="nav-link" href="/blog/"><i class="dripicons-broadcast"></i>Blog</a></li>
					<li class="nav-item"><a class="nav-link" href="https://www.redbubble.com/people/leagueoflevels/shop" target="_blank"><i class="dripicons-cart"></i>Shop</a></li>
				</ul>

			</div>

		</div>

	</div>

</div>
