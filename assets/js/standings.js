$(document).ready(function () {

	function updateYears (data) {
		from = data.from;
	    to = data.to;
	    $(".years_start").prop("value", from);
	    $(".years_end").prop("value", to);
	}

	function updatePeriods (data) {
		from = data.from;
	    to = data.to;
	    $(".periods_start").prop("value", from);
	    $(".periods_end").prop("value", to);
	}

	$(".standings_year").ionRangeSlider({
        type: "double",
        min: 2008,
        max: 2020,
        grid: true,
		prettify_enabled: false,
		onChange: updateYears
    });

	$(".standings_period").ionRangeSlider({
        type: "double",
        min: 1,
        max: 17,
        grid: true,
		prettify_enabled: false,
		onChange: updatePeriods
    });

});
