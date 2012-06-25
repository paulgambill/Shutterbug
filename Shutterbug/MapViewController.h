//
//  MapViewController.h
//  Shutterbug
//
//  Created by Paul Gambill on 6/13/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations; // of id <MKAnnotation>
@end
