// Global variables
var serverURI;
var currentActivityFeed = [];


// Function for iOS to initialize the screen
$(document).ready(function() {
	// Setting button actions
	$('#addButton').click(toggleNewActivityBox);
	$('#activitySubmitButton').click(pushActivity);
});


function initialize(username) {
    serverURI = "http://joinme.heroku.com/" + username + "/activities.json";
    // Fetch activity feed
	fetchActivityFeed();
}


// Function that asks iOS for the device's current location
function askForCurrentLocation() {
    window.location = '{ "method":"iOS.findMe", "callback":"receiveLocation" }';
}


// Callback function to for iOS to answer with current location
function receiveLocation(latitude, longitude) {
	$('#newActivityForm #activityLocation').val(latitude + "," + longitude);
}


function tweetCallback(status)
{
    // TODO - handle status (boolean)
    toggleNewActivityBox();
}


// Function that toggles between showing and hiding the newActivityBox div
function toggleNewActivityBox() {
	if(!$("#newActivityBox").is(":visible")) {
		askForCurrentLocation();	
	}

	$('#newActivityBox').slideToggle('fast');
}



// Function that displays the activity feed on screen
function willShowFeed() {    
    var feedItems = [];
        
    for (var i = 0; i < currentActivityFeed.length; i++) {
        feedItems[i] = 
            "<li class='activityRow'><div class='avatar'><img src='" + currentActivityFeed[i].activity.avatar + "' /></div>" +
            "<div class='feedInfo'><span class='info-name'>" + currentActivityFeed[i].activity.twitter_user + "</span>" +
            "<span class='info-what'>" + currentActivityFeed[i].activity.what + "</span>" +
            "<span class='info-when'>" + currentActivityFeed[i].activity.when + "</span>" + "</div></li>";            
    }
	
    // If there are no feeds in currentActivityFeed
    if (currentActivityFeed.length > 0) {
        $("ul#activityFeed").append(feedItems.join(''));
    } else {
        $("ul#activityFeed").append("No one is doing anything... :(");
    }
	
}


function willShowMap() {
    return JSON.stringify(currentActivityFeed);
}


// Function that gets current activity feeds from the server
function fetchActivityFeed() {
    window.location = '{"method":"iOS.httpRequest", "callback":"httpRequestCallback", "uri":"' + serverURI + '"}';
}

// Function callback that receives httpRequest response
function httpRequestCallback(response) {
	currentActivityFeed = response;
    willShowFeed();
}


// Callback function that handles errors from iOS
function errorHandler(errorMessage) {
	alert(errorMessage);
}


// Function that sends a new activity to the server
function pushActivity() {
	var newActivity = "#joinMe " + $('#newActivityForm #activityTitle').val();
    newActivity += " #at " + $('#newActivityForm #activityTime').val();
    var coordinates = $('#newActivityForm #activityLocation').val().split(',');
	// newActivity.where = {"lat":coordinates[0],"lon":coordinates[1]};
	
    window.location = '{"method":"iOS.tweet", "callback":"toggleNewActivityBox", "msg":"' + newActivity + '", "lat":"' + coordinates[0] + '", "lon":"' + coordinates[1] + '"}';
}