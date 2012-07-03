//
//  MapViewController.m
//  Shutterbug
//
//  Created by Paul Gambill on 6/13/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"
#import "FlickrPlaceAnnotation.h"
#import "PhotosAtPlaceTVC.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSDictionary *selection;
@property (nonatomic, strong) NSString *whichMap;
@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize photos = _photos;
@synthesize selection = _selection;

- (void)updateMapView
{
    if (self.mapView.annotations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    if (self.photos) {
        [self.mapView addAnnotations:self.photos];
    }
}

-(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self updateMapView];
}

// build the annotation views
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    aView.annotation = annotation;
    
    return aView;
}

// get the selected pin's place flickrDictionary into a local property for passing in the segue
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    FlickrPhotoAnnotation *selectedAnnotation = view.annotation;
    self.selection = [NSDictionary dictionaryWithObject:[selectedAnnotation flickrDictionary] forKey:@"object"];
}



// action on tapping the disclosure button
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([self.whichMap isEqualToString:@"placesMap"]) {
        [self performSegueWithIdentifier:@"Map to PhotosAtPlace" sender:self];
    }
    else if ([self.whichMap isEqualToString:@"photosMap"]) {
        [self performSegueWithIdentifier:@"map to Photo" sender:self];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    
    // going to photos at place table view controller
    if ([[segue identifier] isEqualToString:@"Map to PhotosAtPlace"]) {
        [destination setValue:self.selection forKey:@"selection"];
    }
    
    // going to photo view controller
    if ([[segue identifier] isEqualToString:@"map to Photo"]) {
        
        NSDictionary *cellText = [PhotosAtPlaceTVC titleAndSubtitleFromPhotoDictionary:[self.selection objectForKey:@"object"]];
        NSDictionary *photoDictionaryToSend = [NSDictionary dictionaryWithObjectsAndKeys:[self.selection objectForKey:@"object"], @"photo",
                                                                                        cellText, @"cellText", nil];
        [PhotosAtPlaceTVC addSelectedPhotoToRecents:self.selection];
        [destination setValue:photoDictionaryToSend forKey:@"selection"];
    }
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
    self.mapView.delegate = self;
    [self updateMapView];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark Map Display Type Segmented Controller

- (IBAction)mapDisplayTypeChanged:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0: // Map standard
            self.mapView.mapType = MKMapTypeStandard;
            break;
            
        case 1: // Satellite
            self.mapView.mapType = MKMapTypeSatellite;
            break;
            
        case 2: // Hybrid
            self.mapView.mapType = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
    
}



@end
