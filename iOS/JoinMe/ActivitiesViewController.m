//
//  ActivitiesViewController.m
//  JoinMe
//
//  Created by Rodolfo Wilhelmy on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "Activity.h"
#import "SBJsonParser.h"
#import <CoreLocation/CoreLocation.h>


@implementation ActivitiesViewController

@synthesize webView, activities;


- (UIWebView *)webView
{
	if (!webView) {
		webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		webView.delegate = self;
	}
	
	return webView;
}


- (NSArray *)activities
{
    if (!activities) 
        activities = [[NSMutableArray alloc] init];
    return activities;
}


- (void)dealloc
{
    [self.webView release];
    [self.activities release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


- (void)loadView
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
	[self.webView loadData:fileData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
	    
	self.view = self.webView;
}


- (void)viewDidLoad
{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initialize('rod_wilhelmy')"]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark UIWebViewDelegate


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSLog(@"webViewDidFinishLoad");
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
    NSLog(@"shouldStartLoadWithRequest request=%@ navigationType=%d", [request.URL absoluteString], navigationType);
	switch (navigationType) {
		case UIWebViewNavigationTypeLinkClicked:
			NSLog(@"Link clicked to %@", [request.URL absoluteString]);
			break;
		case UIWebViewNavigationTypeOther:
			NSLog(@"Other navigation to %@", [request.URL absoluteString]);
            
            // Catch request
            NSString *jsEvent = [request.URL absoluteString];
            // Remove url encoding
            jsEvent = [jsEvent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];            
            // Validate jsEvent
            if (![jsEvent hasSuffix:@"}"]) break;

            NSRange range = [jsEvent rangeOfString:@"{"];
            jsEvent = [jsEvent substringFromIndex:(range.location)];
            
            

			// JavaScript hijacking
            
            // JSON parsing
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            id json = [parser objectWithString:jsEvent];
            if (!json) break;
            if (![json isKindOfClass:[NSDictionary class]]) break;
            [parser release];
            
            NSString *method = (NSString *)[json valueForKey:@"method"];
            NSString *callback = (NSString *)[json valueForKey:@"callback"];

			if ([method isEqualToString:@"iOS.httpRequest"]) {
                // { "method":"iOS.httpRequest", "uri":"http://heroku.com", "callback":"handleServerResponse" }
                NSString *uri = (NSString *)[json valueForKey:@"uri"];
                NSString *server_response = [NSString stringWithContentsOfURL:[NSURL URLWithString:uri] encoding:NSUTF8StringEncoding error:nil];
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@)", callback, server_response]];
                
                return NO;
			} else if ([method isEqualToString:@"iOS.findMe"]) {
                // { "method":"iOS.findMe", "callback":"receiveLocation" }
                
                if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
                    // App is not authorized to use location services.
                    // The user can deny location services for a specific application.
                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"errorHandler(%@)", @"Location services not allowed."]];
                    break;
                }
                
                if (![CLLocationManager locationServicesEnabled]) {
                    // Device has location services disabled.
                    // The user can disable location services in the Settings application.
                    // The device might be in Airplane mode and unable to power up the necessary hardware.
                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"errorHandler(%@)", @"Location services are disabled."]];
                    break;
                }
                
                gps = [[CLLocationManager alloc] init];
                gps.delegate = self;
                gps.desiredAccuracy = kCLLocationAccuracyHundredMeters;
                gps.purpose = @"We need your location in order to publish where are your activity taking place";
                gps.distanceFilter = 500;
                [gps startUpdatingLocation];
                
                return NO;
            }

            
            // { method:tweet, msg:"texto a postear", callback:"tweeted" }

			break;
		default:
			NSLog(@"Unknown web request");
			break;
	}
	
	// Forbid requests
	return YES;
}


#pragma mark UIWebViewDelegate


- (NSArray *)activitiesToMap:(MapViewController *)requestor
{
    NSLog(@"activitiesToMap");
    
    NSString *activitiesString = [self.webView stringByEvaluatingJavaScriptFromString:@"willShowMap()"];
    NSLog(@"%@", activitiesString);
    
    // JSON parsing
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id activitiesJSON = [parser objectWithString:activitiesString];
    if (!activitiesJSON) return nil;
    if (![activitiesJSON isKindOfClass:[NSArray class]]) return nil;
    [parser release];
    if (![[activitiesJSON lastObject] isKindOfClass:[NSDictionary class]]) return nil;
    
    [self.activities removeAllObjects];
    
    Activity *a;
    NSDictionary *where;
    
    for (NSDictionary *obj in activitiesJSON) {
        obj = (NSDictionary *)[obj valueForKey:@"activity"];
        
        a = [[Activity alloc] init];
        where = nil;
        
        a.user = [obj valueForKey:@"user"];
        a.avatar_url = [obj valueForKey:@"avatar"];
        a.what = [obj valueForKey:@"what"];
        a.when = [obj valueForKey:@"when"];
        where = (NSDictionary *)[obj valueForKey:@"where"];
        
        // Only add activities having coordinates
        if (![where isKindOfClass:[NSNull class]]) {
            a.latitude = [[where valueForKey:@"lat"] doubleValue];
            a.longitude = [[where valueForKey:@"lon"] doubleValue];
            [self.activities addObject:a];
            
        }
    }
    
    [a release];
    [where release];
    
    return self.activities;
}


#pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    double lon = newLocation.coordinate.longitude;
    double lat = newLocation.coordinate.latitude;
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"receiveLocation(%g, %g)", lon, lat]];
    [gps stopUpdatingLocation];
    gps.delegate = nil;
    [gps release];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"errorHandler(%@)", [error localizedDescription]]];
}


@end
