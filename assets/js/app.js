(function ($) {

    'use strict';

    function initSlimscroll() {
        $('.slimscroll').slimscroll({
            height: 'auto',
            position: 'right',
            size: "7px",
            color: '#e0e5f1',
            opacity: 1,
            wheelStep: 5,
            touchScrollStep: 50
        });
    }

    function initMetisMenu() { $("#main_menu_side_nav").metisMenu(); }

    function initLeftMenuCollapse() {
        $('.button-menu-mobile').on('click', function (event) {
        	$("body").toggleClass("enlarge-menu");
            initSlimscroll();
        });
    }

    function initEnlarge() {
        if ($(window).width() < 1025) { $('body').addClass('enlarge-menu'); } else {
            if ($('body').data('keep-enlarged') != true)
                $('body').removeClass('enlarge-menu');
        }
    }

	function initSerach() {
        $('.search-btn').on('click', function () {
            var targetId = $(this).data('target');
            var $searchBar;
            if (targetId) {
                $searchBar = $(targetId);
                $searchBar.toggleClass('open');
            }
        });
    }

	function initMainIconMenu() {
        $('.main-icon-menu .nav-link').on('click', function(e){
            e.preventDefault();
            $(this).addClass('active');
            $(this).siblings().removeClass('active');
            $('.main-menu-inner').addClass('active');
            var targ = $(this).attr('href');
            $(targ).addClass('active');
            $(targ).siblings().removeClass('active');
        });
    }

    function initTooltipPlugin(){
        $.fn.tooltip && $('[data-toggle="tooltip"]').tooltip()
        $('[data-toggle="tooltip-custom"]').tooltip({ template: '<div class="tooltip tooltip-custom" role="tooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>' });
    }


    function initActiveMenu() {

		var pagePath = window.location.pathname;
		var pageTotal = pagePath.split('/');
		var pageCount = pageTotal.length;
		//3=1Level 4=2Levels ...

		var pagePath = window.location.pathname;

		var pageTotal = pagePath.split('/');
		var pageCount = pageTotal.length;
		var pageLink1 = pagePath.split('/')[1];
		var pageLink1Length = pageLink1.length;

		var pageUrl = window.location.protocol + '//' + window.location.hostname  + '/' + pageLink1;

		if (pageCount > 2) { var pageLink2 = pagePath.split('/')[2]; var pageUrl = window.location.protocol + '//' + window.location.hostname + '/' + pageLink1 + '/' + pageLink2; }
		if (pageCount > 3) { var pageLink3 = pagePath.split('/')[3]; var pageUrl = window.location.protocol + '//' + window.location.hostname  + '/' + pageLink1 + '/' + pageLink2 + '/' + pageLink3; }

		$(".left-sidenav a").each(function () {

			//var pageUrl = window.location.protocol + '//' + window.location.hostname;

			//pageUrl = pageUrl + '/';

			if (this.href == pageUrl) {
                $(this).addClass("active");
                $(this).parent().parent().addClass("in");
                $(this).parent().parent().addClass("mm-show");
                $(this).parent().parent().prev().addClass("active");
                $(this).parent().parent().parent().addClass("active");
                $(this).parent().parent().parent().addClass("mm-active");
                $(this).parent().parent().parent().parent().addClass("in");
                $(this).parent().parent().parent().parent().parent().addClass("active");
                $(this).parent().parent().parent().parent().parent().parent().addClass("active");
                var menu =  $(this).closest('.main-icon-menu-pane').attr('id');
                $("a[href='#"+menu+"']").addClass('active');
			}

        });
    }

	function init() {
        initSlimscroll();
        initMetisMenu();
        initLeftMenuCollapse();
        initEnlarge();
        initSerach();
        initMainIconMenu();
        initTooltipPlugin();
        initActiveMenu();
        Waves.init();
    }

    init();

})(jQuery)
