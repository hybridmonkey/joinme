    //
//  WebViewController.m
//  HybridMonkey
//
//  Created by Rodolfo Wilhelmy on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize webView, picker;


- (UIWebView *)webView {
	if (!webView) {
		webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		webView.delegate = self;
	}
	
	return webView;
}


- (void)loadView {
	
	// NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] isDirectory:NO];
	// NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
	// [self.webView loadRequest:request];

	// [self.webView loadHTMLString:@"<b>Hello</b> Randal" baseURL:nil];
	
	self.picker = [[UIImagePickerController alloc] init];
	self.picker.delegate = self;
	// self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
	[self.webView loadData:fileData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
	
	self.view = self.webView;
}


#pragma mark UIWebViewDelegate


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSLog(@"webViewDidFinishLoad");
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"shouldStartLoadWithRequest");
	switch (navigationType) {
		case UIWebViewNavigationTypeLinkClicked:
			NSLog(@"Link clicked to %@", [request.URL absoluteString]);
			break;
		case UIWebViewNavigationTypeReload:
			NSLog(@"Reload");
			break;
		case UIWebViewNavigationTypeOther:
			NSLog(@"Other navigation to %@", [request.URL absoluteString]);
			// Event hijacking
			if ([[request.URL absoluteString] hasSuffix:@"asustame"]) {
				NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:@"boo()"];
				NSLog(@"stringByEvaluatingJavaScriptFromString result = %@", result);
				return NO;
			} else if ([[request.URL absoluteString] hasSuffix:@"foooto_foooto"]) {
				[self presentModalViewController:self.picker animated:YES];
			}
			break;
		default:
			NSLog(@"Unknown");
			break;
	}
	
	
	return YES;
}


#pragma mark UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[_picker dismissModalViewControllerAnimated:YES];
	NSLog(@"%@", info);
}


#pragma mark Housekeeping

			   
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[self.picker release];
	[self.webView release];
    [super dealloc];
}


@end
