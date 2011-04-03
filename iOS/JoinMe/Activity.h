//
//  Activity.h
//  JoinMe
//
//  Created by Rodolfo Wilhelmy on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface Activity : NSObject <MKAnnotation> {
    NSString *user;
    NSString *avatar_url;
    NSString *what;
    NSString *when;
    double latitude;
    double longitude;
}

@property (retain) NSString *user;
@property (retain) NSString *avatar_url;
@property (retain) NSString *what;
@property (retain) NSString *when;
@property double latitude;
@property double longitude;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (readonly) NSString *title;
@property (readonly) NSString *subtitle;

@end
