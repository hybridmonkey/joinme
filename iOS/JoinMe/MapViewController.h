//
//  MapViewController.h
//  JoinMe
//
//  Created by Rodolfo Wilhelmy on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol ActivitiesMapDelegate
    - (NSArray *)activitiesToMap:(MapViewController *)requestor;
@end

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
    id <ActivitiesMapDelegate> delegate;
}

@property (assign) id <ActivitiesMapDelegate> delegate;

@end