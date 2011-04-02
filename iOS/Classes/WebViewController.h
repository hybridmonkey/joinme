//
//  WebViewController.h
//  HybridMonkey
//
//  Created by Rodolfo Wilhelmy on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIWebView *webView;
	UIImagePickerController *picker;
}

@property (nonatomic, retain) UIWebView *webView;
@property (retain) UIImagePickerController *picker;

@end
