//
//  ActivitiesViewController.h
//  JoinMe
//
//  Created by Rodolfo Wilhelmy on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"


@interface ActivitiesViewController : UIViewController <UIWebViewDelegate, ActivitiesMapDelegate, CLLocationManagerDelegate> {
    UIWebView *webView;
    NSMutableArray *activities;
    CLLocationManager *gps;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSMutableArray *activities;

@end
