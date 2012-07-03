//
//  FlickrPhotoAnnotation.m
//  Shutterbug
//
//  Created by Paul Gambill on 7/3/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"
#import "PhotosAtPlaceTVC.h"

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
    NSDictionary *titleAndSubtitle = [PhotosAtPlaceTVC titleAndSubtitleFromPhotoDictionary:self.flickrDictionary];
    return [titleAndSubtitle objectForKey:@"title"];
}

- (NSString *)subtitle
{
    NSDictionary *titleAndSubtitle = [PhotosAtPlaceTVC titleAndSubtitleFromPhotoDictionary:self.flickrDictionary];
    
    if ([titleAndSubtitle objectForKey:@"subtitle"]) {
        return [titleAndSubtitle objectForKey:@"subtitle"];
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
