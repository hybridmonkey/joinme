//
//  JoinMeAppDelegate.m
//  JoinMe
//
//  Created by Rodolfo Wilhelmy on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JoinMeAppDelegate.h"
#import "ActivitiesViewController.h"
#import "MapViewController.h"

@implementation JoinMeAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup view controllers
    ActivitiesViewController *activities = [[ActivitiesViewController alloc] init];
    MapViewController *map = [[MapViewController alloc] init];
    // Make activities screen a delegate of map view
    map.delegate = activities;
    
    // Setup tab icons
    UITabBarItem *item;
    // item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
    item = [[UITabBarItem alloc] initWithTitle:@"Friends" image:nil tag:0];    
    activities.tabBarItem = item;
    // item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:0];
    item = [[UITabBarItem alloc] initWithTitle:@"Map" image:nil tag:0];    
    map.tabBarItem = item;
    [item release];
    
    // Setup tab view controller
    UITabBarController *tabs = [[UITabBarController alloc] init];
    tabs.viewControllers = [NSArray arrayWithObjects:activities, map, nil];
    [activities release];
    [map release];
    
    [self.window addSubview:tabs.view]; // NOTE - We will not release tabs
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
