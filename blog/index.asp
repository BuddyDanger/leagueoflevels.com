<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/framework/session.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Blog / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="Blog - The League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="Blog - The League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="Blog - The League of Levels" />
		<meta name="medium" content="article" />

		<link rel="shortcut icon" href="/favicon.ico" />
		<link rel="canonical" href="https://www.leagueoflevels.com/" />

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
<%
									sqlGetBlogs = "SELECT * FROM Blogs WHERE IsActive = 1 ORDER BY PostDate DESC"
									Set rsBlogs = sqlDatabase.Execute(sqlGetBlogs)

									Do While Not rsBlogs.Eof

										BlogDate = rsBlogs("PostDate")
										BlogLink = rsBlogs("BlogLink")
										BlogTitle = FilterSpecialCharacters(rsBlogs("FullTitle"))
										BlogTeaser = FilterSpecialCharacters(rsBlogs("Teaser"))
										BlogYear = Year(BlogDate)
										BlogMonth = Month(BlogDate)
										BlogMonthName = MonthName(BlogMonth)
										BlogDay = Day(BlogDate)

										If Len(BlogMonth) = 1 Then BlogMonth = "0" & BlogMonth
										If Len(BlogDay) = 1 Then BlogDay = "0" & BlogDay

										URL = "/blog/" & BlogLink & "/"
%>
										<div class="col-lg-4">
											<div class="card">
												<div class="card-body">
													<div class="blog-card">
														<a href="<%= URL %>"><img src="/assets/images/uploads/<%= rsBlogs("MainImage") %>" alt="<%= rsBlogs("FullTitle") %>" class="img-fluid" border="0" /></a>
														<h4 class="mt-4 mb-3"><a href="<%= URL %>"><%= BlogTitle %></a></h4>
														<p class="text-muted"><%= BlogTeaser %></p>
														<a href="<%= URL %>" class="text-secondary">Continue Reading <i class="fas fa-long-arrow-alt-right"></i></a>
													</div>
												</div>
											</div>
										</div>
<%
										rsBlogs.MoveNext

									Loop

									rsBlogs.Close
									Set rsBlogs = Nothing
%>
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
