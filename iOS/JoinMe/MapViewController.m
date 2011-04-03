//
//  MapViewController.m
//  JoinMe
//
//  Created by Rodolfo Wilhelmy on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "Activity.h"


@implementation MapViewController

@synthesize delegate;


- (void)dealloc
{
    [mapView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // [[UIScreen mainScreen] applicationFrame]
    mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mapView.mapType = MKMapTypeStandard;
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    
    // Not working - retrieving user's location
    // CLLocation *whereAmI = mapView.userLocation.location;
    // CLLocationCoordinate2D location = whereAmI.coordinate;
    
    // Set initial region
    // Dummy coordinates
    CLLocationCoordinate2D location;
    location.latitude = 25.652978;
    location.longitude = -100.2917;
    // one degree of latitude is approximately 111 kilometers (69 miles)
    // one degree of longitude spans a distance of approximately 111 kilometers (69 miles) at the equator but shrinks to 0 kilometers at the poles
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    mapView.region = MKCoordinateRegionMake(location, span);
    
    // TODO - centrar mapa según coordenadas del user
    
    self.view = mapView;
}


- (void)viewWillAppear:(BOOL)animated 
{
    // Get activities to map
    NSArray *array = [self.delegate activitiesToMap:self];
    [mapView addAnnotations:array];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - MKMapViewDelegate


- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapView mapViewDidFinishLoadingMap");
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"mapView regionDidChangeAnimated");
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"mapView didSelectAnnotationView");

    Activity *selectedActivity = (Activity *)view.annotation;
                                  
    NSURL *url = [NSURL URLWithString:selectedActivity.avatar_url];
    
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)view.leftCalloutAccessoryView;
        dispatch_queue_t downloader = dispatch_queue_create("callout downloader", NULL);
        dispatch_async(downloader, ^{
            UIImage *theImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
            dispatch_async(dispatch_get_main_queue(), ^{ imageView.image = theImage; });
        });
        dispatch_release(downloader);
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSLog(@"mapView viewForAnnotation");
    
    MKAnnotationView *aView = [_mapView dequeueReusableAnnotationViewWithIdentifier:@"Activity"];
    if (!aView) {
        aView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Activity"] autorelease];
		// aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		aView.leftCalloutAccessoryView = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)] autorelease];
		aView.canShowCallout = YES;
    }
    // might be a reuse, so re(set) everything
	((UIImageView *)aView.leftCalloutAccessoryView).image = nil;
    aView.annotation = annotation;
    // maybe load up accessory views and/or title/subtitle here
    // or reset them and wait until mapView:didSelectAnnotationView: to load actual data
    // i.e.  a performance alternative
    return aView;
}


- (void)mapView:(MKMapView *)sender annotationView:(MKAnnotationView *)aView calloutAccessoryControlTapped:(UIControl *)control
{
    // TODO - Podemos implementar una nueva pantalla o una accion de avisar al user de que vamos a unirnos a su actividad
}
 

@end
