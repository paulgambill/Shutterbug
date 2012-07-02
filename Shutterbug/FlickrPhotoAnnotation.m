//
//  FlickrPhotoAnnotation.m
//  Shutterbug
//
//  Created by Paul Gambill on 6/14/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotoAnnotation
@synthesize flickrDictionary = _flickrDictionary;

+ (FlickrPhotoAnnotation *)annotationForFlickrDictionary:(NSDictionary *)flickrDictionary
{
    FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc] init];
    annotation.flickrDictionary = flickrDictionary;
    return annotation;
}

- (NSString *)title
{
    if ([self.flickrDictionary objectForKey:FLICKR_PLACE_NAME]) {
        return [self.flickrDictionary objectForKey:FLICKR_PLACE_NAME];
    }
    else {
        return nil;
    }
    
}

- (NSString *)subtitle
{
    if ([self.flickrDictionary objectForKey:FLICKR_PLACE_NAME]) {
        return nil;
    }
    else {
        return nil;
    }
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.flickrDictionary objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.flickrDictionary objectForKey:FLICKR_LONGITUDE] doubleValue];
    
    return coordinate;
}

@end
