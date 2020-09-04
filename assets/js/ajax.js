function GetXmlHttpObject (handler) {

	var objXmlHttp = null;

	if (navigator.userAgent.indexOf("MSIE") >= 0) {

		var strName="Msxml2.XMLHTTP";

		if (navigator.appVersion.indexOf("MSIE 5.5")>=0) {
			strName="Microsoft.XMLHTTP";
		}

		try {
			objXmlHttp = new ActiveXObject(strName);
			objXmlHttp.onreadystatechange = handler;
			return objXmlHttp;
		} catch(e) {
			alert("Error. Scripting for ActiveX might be disabled");
			return;
		}

	}

	if (navigator.userAgent.indexOf("Mozilla") >= 0) {
		objXmlHttp = new XMLHttpRequest();
		objXmlHttp.onload = handler;
		objXmlHttp.onerror = handler;
		return objXmlHttp;
	}

}

function getRadioValue(theRadioGroup)
{
    var elements = document.getElementsByName(theRadioGroup);
    for (var i = 0, l = elements.length; i < l; i++)
    {
        if (elements[i].checked)
        {
            return elements[i].value;
        }
    }
}

function AttemptAccountLogin () {

	var email = document.getElementById('email').value;
	var password = document.getElementById('password').value;
	var rememberMe = document.getElementById('remember-me').value;

	var POSTurl = "/assets/data/account-login.asp?email="  + encodeURIComponent(email) + "&password=" + encodeURIComponent(password) + "&rememberme=" + rememberMe;
	xmlHttpAttemptAccountLogin = GetXmlHttpObject(FinalizeAccountLogin);
	xmlHttpAttemptAccountLogin.open("GET", POSTurl , true);
	xmlHttpAttemptAccountLogin.send(null);

}

function FinalizeAccountLogin () {

	if (xmlHttpAttemptAccountLogin.readyState==4 || xmlHttpAttemptAccountLogin.readyState=="complete") {
		if (xmlHttpAttemptAccountLogin.responseText == "GOOD") {
			$.magnificPopup.close();
			document.getElementById('sign-in-button').innerHTML = "<div class=\"user-menu\"><div class=\"user-name\"><span><img src=\"/images/dashboard-avatar.jpg\" alt=\"My Account\"></span>My Account</div><ul><li><a href=\"/account/\"><i class=\"sl sl-icon-settings\"></i> Profile Details</a></li><li><a href=\"/account/reviews/\"><i class=\"sl sl-icon-envelope-open\"></i> My Reviews</a></li><li><a href=\"/account/sign-out/\"><i class=\"sl sl-icon-power\"></i> Sign Out</a></li></ul></div>";
			document.getElementById('footer-sign-in').innerHTML = "<a href=\"/account/\" class=\"sign-in\">Your Account</a>";
		} else {
			document.getElementById('LoginResults').innerHTML = "There was an error with your credentials. Please, try again.<br />";
		}
	} else if (xmlHttpAttemptAccountLogin.readyState==1 || xmlHttpAttemptAccountLogin.readyState=="loading") {
	}

}

function AttemptRatingReview () {

	var AccountID = document.getElementById('AccountID').value;
	var ProviderID = document.getElementById('ProviderID').value;
	var ProviderPhone = document.getElementById('ProviderPhone').value;
	var Rating1 = getRadioValue('rating1');
	var Rating2 = getRadioValue('rating2');
	var Rating3 = getRadioValue('rating3');
	var Rating4 = getRadioValue('rating4');

	var Review = document.getElementById('rating-review').value;

	var POSTurl = "/assets/data/post-review.asp?AccountID=" + AccountID + "&ProviderID=" + ProviderID + "&ProviderPhone=" + ProviderPhone + "&Rating1=" + Rating1 + "&Rating2=" + Rating2 + "&Rating3=" + Rating3 + "&Rating4=" + Rating4 + "&Review=" + encodeURIComponent(Review);

	xmlHttpAttemptRatingReview = GetXmlHttpObject(FinalizeRatingReview);
	xmlHttpAttemptRatingReview.open("GET", POSTurl , true);
	xmlHttpAttemptRatingReview.send(null);

}

function FinalizeRatingReview () {

	if (xmlHttpAttemptRatingReview.readyState==4 || xmlHttpAttemptRatingReview.readyState=="complete") {
		if (xmlHttpAttemptRatingReview.responseText == "GOOD") {
			document.getElementById('add-review').innerHTML = "<h3 class=\"listing-desc-headline margin-bottom-10\">Thank you for your review! Your reviews make Best Catastrophe Pros the most reliable source for claims professionals to find the best service providers across the country.</div>";
		} else {
			document.getElementById('review-errors').innerHTML = "There was an error with your submission. Please, try again.<br />";
		}
	} else if (xmlHttpAttemptRatingReview.readyState==1 || xmlHttpAttemptRatingReview.readyState=="loading") {
	}

}
