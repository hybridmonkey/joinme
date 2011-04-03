// Global variables
var username = "rod_wilhelmy";
var jsonURI = "http://joinme.heroku.com/" + username + "/activities.json";
//var serverURI = userToken + "@" + jsonURI;
var serverURI = jsonURI;

var currentActivityFeed = [];
var screen;
var screenState = {
	LIST : 0,
	MAP : 1
};

$(document).ready(function() {

	// Initial screen state
	screen = screenState.LIST;
	
	// TEMPORARY - delete when tabs are working in iOS
	lastKnownLocation = {"lat":100,"lon":200};
	
	// Setting button actions
	$('#addButton').click(toggleNewActivityBox);
	$('#activitySubmitButton').click(pushActivity);
	
	// Fetch activity feed
	fetchActivityFeed();
	

});




// Callback function to for iOS to set username 
function logInAs(user) {
	username = user;
}


// Function that asks iOS for the device's current location
function askForCurrentLocation(){
	// TODO
}


// Callback function to for iOS to answer with current location
function receiveLocation(latitude, longitude) {
	$('#newActivityForm #activityLocation').val(latitude + "," + longitude);
}



// Function that toggles between showing and hiding the newActivityBox div
function toggleNewActivityBox() {
	if('#newActivityBox') {
		askForCurrentLocation();	
	}

	$('#newActivityBox').slideToggle('fast');
}



// Function that displays the activity feed on screen
function loadActivityFeed() {
	if (screen === screenState.LIST) {	// Load list with current activity feed
		var feedItems = [];
	
		for (var i = 0; i < currentActivityFeed.length; i++) {
			feedItems[i] = 
				"<li class='activityRow'><div class='avatar'><img src='" + currentActivityFeed[i].avatar + "' /></div>" +
				"<div class='feedInfo'><span class='info-name'>" + currentActivityFeed[i].user + "</span>" +
				"<span class='info-what'>" + currentActivityFeed[i].what + "</span>" +
				"<span class='info-when'>" + currentActivityFeed[i].when + "</span>" + "</div></li>";
		}
	
		// If there are no feeds in currentActivityFeed
		if (currentActivityFeed.length > 0) {
			$("ul#activityFeed").append(feedItems.join(''));
		} else {
			$("ul#activityFeed").append("No one is doing anything... :(");
		}
	} else { // Load MAP annotations with current activity feed
		// TODO tell iOS map places
	}

	
}


// Function to be called by iOS and does actions relevant to the tab in question
function changeTab(tabName) {
	if (tabName == "list") {
		screen = screenState.LIST;
	} else if (tabName == "map") {
		screen = screenState.MAP;
	}
	
	loadActivityFeed();
}



/* -------------- HTTP REQUESTS -------------- */


// Function that gets current activity feeds from the server
function fetchActivityFeed() {
	
	//TODO make iOS make the request
	$.getJSON(serverURI, function(data) {
  		httpRequestCallback();
	});
	
}

// Function callback that receives httpRequest response
function httpRequestCallback(response) {
	currentActivityFeed = response;
  	loadActivityFeed();
}



// Function that sends a new activity to the server
function pushActivity() {
	var newActivity = {};
	
	newActivity.what = $('#newActivityForm #activityTitle').val();
	newActivity.when = $('#newActivityForm #activityTime').val();
	newActivity.where = {"lat":lastKnownLocation.lat,"lon":lastKnownLocation.lon};
	
	//TODO make iOS make the request
	$.getJSON(serverURI, newActivity, function(data) {
  		// Close newActivityBox
		$('#newActivityBox').slideToggle('fast');
	});
	
	
}