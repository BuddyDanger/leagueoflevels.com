<div class="topbar">

	<div class="topbar-left">

		<a href="/" class="logo">
			<span><img src="/assets/images/logo-sm.png" width="51" alt="logo-small" class="logo-sm"></span>
			<span><img src="/assets/images/logo-dark.png" width="125" alt="logo-large" class="logo-lg"></span>
		</a>

	</div>

	<nav class="navbar-custom">
<%
		If Session.Contents("LoggedIn") = "yes" Then
%>
			<ul class="list-unstyled topbar-nav float-right mb-0">

				<li class="dropdown notification-list">

					<a class="nav-link dropdown-toggle arrow-none waves-light waves-effect" data-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
						<i class="ti-bell noti-icon"></i><!--<span class="badge badge-danger badge-pill noti-icon-badge"></span>-->
					</a>

					<div class="dropdown-menu dropdown-menu-right dropdown-lg pt-0">

						<h6 class="dropdown-item-text font-15 m-0 py-3 bg-primary text-white d-flex justify-content-between align-items-center">Notifications <span class="badge badge-light badge-pill"></span></h6>

						<!--<a href="javascript:void(0);" class="dropdown-item text-center text-primary">View all <i class="fi-arrow-right"></i></a>-->

					</div>

				</li>

				<li class="dropdown">

					<a class="nav-link dropdown-toggle waves-effect waves-light nav-user" data-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
						<img src="https://samelevel.imgix.net/<%= Session.Contents("AccountImage") %>?w=40&h=40&fit=crop&crop=focalpoint" width="40" alt="profile-user" class="rounded-circle" />
						<span class="ml-1 nav-user-name hidden-sm"><%= Session.Contents("AccountName") %> <i class="mdi mdi-chevron-down"></i> </span>
					</a>

					<div class="dropdown-menu dropdown-menu-right">
						<a class="dropdown-item" href="/"><i class="dripicons-meter text-muted mr-2"></i> Dashboard</a>
						<a class="dropdown-item" href="/account/"><i class="dripicons-gear text-muted mr-2"></i> Account Profile</a>
						<div class="dropdown-divider"></div>
						<a class="dropdown-item" href="/account/logout/"><i class="dripicons-exit text-muted mr-2"></i> Logout</a>
					</div>

				</li>

			</ul>
<%
		Else
%>
			<div class="topbar-nav float-right mb-0 mt-3 mr-1">

				<a class="btn btn-secondary mr-2" href="/account/register/">REGISTER</a><a class="btn btn-secondary" href="/account/login/">LOGIN</a>

			</div>
<%
		End If
%>
		<ul class="list-unstyled topbar-nav mb-0">
			<li>
				<button class="main-icon-menu-button button-menu-mobile nav-link"><i class="dripicons-menu nav-icon"></i></button>
			</li>
		</ul>

	</nav>

</div>
