<!--#include virtual="/adovbs.inc"-->
<!--#include virtual="/assets/asp/sql/connection.asp" -->
<!--#include virtual="/assets/asp/functions/master.asp"-->
<!DOCTYPE html>
<html lang="en">

	<head>

		<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
		<meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
		<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

		<title>Podcasts / League of Levels</title>

		<meta name="description" content="" />

		<meta property="og:site_name" content="LeagueOfLevels.com" />
		<meta property="og:url" content="https://www.leagueoflevels.com/" />
		<meta property="og:title" content="Podcasts - The League of Levels" />
		<meta property="og:description" content="" />
		<meta property="og:type" content="article" />

		<meta name="twitter:site" content="samelevel" />
		<meta name="twitter:url" content="https://www.leagueoflevels.com/" />
		<meta name="twitter:title" content="Podcasts - The League of Levels" />
		<meta name="twitter:description" content="" />

		<meta name="title" content="Podcasts - The League of Levels" />
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

				<div class="container-fluid">

					<div class="row">

						<div class="col-sm-12">

							<div class="page-title-box">

								<div class="float-right">

									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="javascript:void(0);">Main</a></li>
										<li class="breadcrumb-item active">Podcasts</li>
									</ol>

								</div>

								<h4 class="page-title">Podcasts</h4>

							</div>

							<div class="page-content">

								<div class="row">
<%
									Set xmlDOM = Server.CreateObject("MSXML2.DOMDocument")
									xmlDOM.async = False
									xmlDOM.setProperty "ServerHTTPRequest", True
									xmlDOM.Load("http://cast.rocks/hosting/13956/feeds/H6L9D.xml")

									Set itemList = XMLDom.SelectNodes("rss/channel/item")

									myCount = 0

									For Each itemAttrib In itemList

										myCount = myCount + 1
										thisTitle = FilterSpecialCharacters(itemAttrib.SelectSingleNode("title").text)
										thisDescription = FilterSpecialCharacters(itemAttrib.SelectSingleNode("description").text)
										thisPubDate = itemAttrib.SelectSingleNode("pubDate").text
										thisLength = itemAttrib.SelectSingleNode("itunes:duration").text
										thisMP3 = itemAttrib.SelectSingleNode("enclosure").GetAttribute("url")

										arrPodDate = Split(thisPubDate, " ")
										PodDate_Day = arrPodDate(1)
										PodDate_MonthAbbr = arrPodDate(2)
										PodDate_Year = arrPodDate(3)
										PodDate_Time = arrPodDate(4)

										If Len(PodDate_Day) = 1 Then PodDate_Day = "0" & PodDate_Day

										If PodDate_MonthAbbr = "Jan" Then PodDate_Month = "01"
										If PodDate_MonthAbbr = "Feb" Then PodDate_Month = "02"
										If PodDate_MonthAbbr = "Mar" Then PodDate_Month = "03"
										If PodDate_MonthAbbr = "Apr" Then PodDate_Month = "04"
										If PodDate_MonthAbbr = "May" Then PodDate_Month = "05"
										If PodDate_MonthAbbr = "Jun" Then PodDate_Month = "06"
										If PodDate_MonthAbbr = "Jul" Then PodDate_Month = "07"
										If PodDate_MonthAbbr = "Aug" Then PodDate_Month = "08"
										If PodDate_MonthAbbr = "Sep" Then PodDate_Month = "09"
										If PodDate_MonthAbbr = "Oct" Then PodDate_Month = "10"
										If PodDate_MonthAbbr = "Nov" Then PodDate_Month = "11"
										If PodDate_MonthAbbr = "Dec" Then PodDate_Month = "12"

										PodDate_FINAL = PodDate_Year & "-" & PodDate_Month & "-" & PodDate_Day & " " & PodDate_Time

										thisPodYear = PodDate_Year
										thisPodMonth = PodDate_Month
										thisPodMonthName = MonthName(PodDate_Month)
										thisPodDay = PodDate_Day

										If Len(thisPodMonth) = 1 Then thisPodMonth = "0" & thisPodMonth
										If Len(thisPodDay) = 1 Then thisPodDay = "0" & thisPodDay

										thisDescription = Replace(thisDescription, vbcrlf, "<br />")
										thisDescription = Replace(thisDescription, chr(10), "<br />")

										URL = "/podcasts/" & PodcastsLink & "/"
%>
										<div class="col-lg-6 col-xl-4">
											<div class="card">
												<div class="card-body">
													<div class="blog-card">
														<h4 class="mt-2 mb-3"><a href="<%= thisMP3 %>"><%= thisTitle %></a></h4>
														<div class="meta-box">
															<ul class="p-0 mt-2 mb-4 list-inline">
																<li class="list-inline-item"><span class="badge badge-secondary px-3"><%= thisPodMonthName %>&nbsp;<%= thisPodDay %>, <%= PodDate_Year %></span>&nbsp;<span class="badge badge-warning px-3"><%= thisLength %></span>&nbsp;<a href="<%= thisMP3 %>"><span class="badge badge-danger px-3">Download</span></a></li>
															</ul>
														</div>
														<p class="text-muted"><%= thisDescription %></p>
														<a href="<%= thisMP3 %>" class="text-secondary">Listen Now <i class="fas fa-long-arrow-alt-right"></i></a>
													</div>
												</div>
											</div>
										</div>
<%
									Next

									Set xmlDOM = Nothing
									Set itemList = Nothing
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
