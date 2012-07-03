//
//  PhotosAtPlaceTVC.h
//  Shutterbug
//
//  Created by Paul Gambill on 6/4/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosAtPlaceTVC : UITableViewController

+ (NSDictionary *)titleAndSubtitleFromPhotoDictionary:(NSDictionary *)photo;
+ (void)addSelectedPhotoToRecents:(NSDictionary *)photo;

@end
