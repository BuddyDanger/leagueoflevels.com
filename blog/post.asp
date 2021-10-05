<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<%
	sqlGetBlog = "SELECT PostDate, MainImage, BlogLink, FullTitle, Teaser, BlogHTML FROM Blogs WHERE BlogID = " & Session.Contents("SITE_BlogID")
	Set rsBlog = sqlDatabase.Execute(sqlGetBlog)

	If Not rsBlog.Eof Then

		BlogDate = rsBlog("PostDate")
		BlogImage = rsBlog("MainImage")
		BlogLink = rsBlog("BlogLink")
		BlogTeaser = FilterSpecialCharacters(rsBlog("Teaser"))
		BlogTitle = FilterSpecialCharacters(rsBlog("FullTitle"))
		BlogHTML = FilterSpecialCharacters(rsBlog("BlogHTML"))
		BlogYear = Year(BlogDate)
		BlogMonth = Month(BlogDate)
		BlogMonthName = MonthName(BlogMonth)
		BlogDay = Day(BlogDate)

		If Len(BlogMonth) = 1 Then BlogMonth = "0" & BlogMonth
		If Len(BlogDay) = 1 Then BlogDay = "0" & BlogDay

		URL = "/blog/" & BlogLink & "/"

		If InStr(BlogTeaser, "&#146;") Then BlogTeaser = Replace(BlogTeaser, "&#146;", "'")

	End If
%>
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title><%= BlogTitle %> / Blog / League of Levels</title>

		<meta name="description" content="<%= BlogTeaser %>" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/blog/<%= BlogLink %>/" />
		<meta property="og:title" content="<%= rsBlog("FullTitle") %>" />
		<meta property="og:description" content="<%= BlogTeaser %>" />
		<meta property="og:image" content="/assets/images/uploads/<%= BlogImage %>" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/blog/<%= BlogLink %>/" />
		<meta name="twitter:title" content="<%= rsBlog("FullTitle") %>" />
		<meta name="twitter:description" content="<%= BlogTeaser %>" />
		<meta name="twitter:card" content="summary_large_image" />

		<meta name="title" content="<%= rsBlog("FullTitle") %>" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/blog/<%= BlogLink %>/" />

		<link href="/assets/css/bootstrap.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/icons.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
		<link href="/assets/css/style.css?version=3" rel="stylesheet" type="text/css" />

	</head>

	<body>

		<!--#include virtual="/assets/asp/framework/topbar.asp" -->

		<div class="page-wrapper">

			<!--#include virtual="/assets/asp/framework/nav.asp" -->

			<div class="page-content">

				<div class="container-fluid pl-0 pl-lg-2 pr-0 pr-lg-2">

					<div class="row">

						<div class="col-sm-12">

							<div class="page-title-box">

								<div class="float-right">

									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="javascript:void(0);">Main</a></li>
										<li class="breadcrumb-item active">Blog</li>
									</ol>

								</div>

								<h4 class="page-title">Blog</h4>

							</div>

							<div class="page-content">

								<div class="row">

										<div class="col-xxl-7 col-xl-8 col-lg-8 col-md-12">
											<div class="card">
												<div class="card-body">

														<a href="<%= URL %>"><img src="/assets/images/uploads/<%= BlogImage %>" alt="" class="img-fluid" border="0" /></a>
														<h2 class="mt-4 mb-3"><a href="<%= URL %>"><%= BlogTitle %></a></h2>
														<div style="color: #212529; line-height: 1.7rem; font-size: 1.0rem; font-family: 'Roboto Slab', serif;"><%= BlogHTML %></div>

												</div>
											</div>
										</div>

								</div>

							</div>

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

		<!--#include virtual="/assets/asp/framework/google.asp" -->

	</body>

</html>
