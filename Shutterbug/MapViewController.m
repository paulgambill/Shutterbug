//
//  MapViewController.m
//  Shutterbug
//
//  Created by Paul Gambill on 6/13/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize photos = _photos;

- (void)updateMapView
{
    if (self.mapView.annotations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    if (self.photos) {
        [self.mapView addAnnotations:self.photos];
    }
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
