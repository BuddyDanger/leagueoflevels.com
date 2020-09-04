<% If Session.Contents("LoggedIn") <> "yes" Then %>
<div class="col-12 col-lg-6 col-xl-4">

	<div class="card">
		<div class="card-body">
			<h4 class="mt-0 header-title">Login to the League of Levels</h4>
			<p class="text-muted mb-3">In order to get the most out of the site, login to your free account. If you're a current LOL member, you will be automatically attached to your team(s).</p>
			<form action="/account/login/" method="post">
				<input type="hidden" name="action" value="go" />
				<div class="form-group">
					<label for="accountEmail">Email address</label>
					<input type="email" class="form-control" id="accountEmail" name="accountEmail">
				</div>
				<div class="form-group">
					<label for="accountPassword">Password</label>
					<input type="password" class="form-control" id="accountPassword" name="accountPassword">
				</div>
				<div class="form-group form-check mb-2">
					<input type="checkbox" class="form-check-input" id="accountRemember" name="accountRemember">
					<label class="form-check-label" for="accountRemember">Remember Me</label>
				</div>
				<button type="submit" class="btn btn-primary btn-sm mt-2 mr-2">Login</button>
				<button onclick="window.location.href = '/account/register/';" type="button" class="btn btn-secondary btn-sm mt-2 mr-2">Register</button>
				<button onclick="window.location.href = '/account/reset-password/';" type="button" class="btn btn-secondary btn-sm mt-2">Reset Password</button>
			</form>
		</div>
	</div>

</div>
<% End If %>
