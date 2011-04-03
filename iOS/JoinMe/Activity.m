//
//  Activity.m
//  JoinMe
//
//  Created by Rodolfo Wilhelmy on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Activity.h"


@implementation Activity

@synthesize user, avatar_url, what, when, latitude, longitude;

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D c;
    c.latitude = self.latitude;
    c.longitude = self.longitude;
    return c;
}

- (NSString *)title
{
    return self.what;
}

- (NSString *)subtitle
{
    if (!self.user) {
        return [NSString stringWithFormat:@"join El Bato at %@", self.when];
    }
    return [NSString stringWithFormat:@"join %@ at %@", self.user, self.when];
}

@end
