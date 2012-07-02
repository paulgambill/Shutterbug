//
//  MapViewController.h
//  Shutterbug
//
//  Created by Paul Gambill on 6/13/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define MAP MKMapTypeStandard
#define SATELLITE MKMapTypeSatellite
#define HYBRID MKMapTypeHybrid

@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray *photos; // of id <MKAnnotation>
@end
