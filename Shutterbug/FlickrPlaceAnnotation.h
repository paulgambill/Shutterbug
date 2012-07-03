//
//  FlickrPhotoAnnotation.h
//  Shutterbug
//
//  Created by Paul Gambill on 6/14/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FlickrPlaceAnnotation : NSObject <MKAnnotation>

+ (FlickrPlaceAnnotation *)annotationForFlickrDictionary:(NSDictionary *)photo;

@property (nonatomic, strong) NSDictionary *flickrDictionary;

@end
