//
//  ActivitiesViewController.h
//  JoinMe
//
//  Created by Rodolfo Wilhelmy on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "SA_OAuthTwitterController.h"


@class SA_OAuthTwitterEngine;

@interface ActivitiesViewController : UIViewController <UIWebViewDelegate, ActivitiesMapDelegate, CLLocationManagerDelegate, UITextFieldDelegate, SA_OAuthTwitterControllerDelegate> {
    UIWebView *webView;
    NSMutableArray *activities;
    CLLocationManager *gps;
    // UITextField *tweetTextField;
    SA_OAuthTwitterEngine *_engine;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSMutableArray *activities;
// @property (nonatomic, retain) UITextField *tweetTextField;  

// - (void)updateTwitter:(id)sender;   
@end
