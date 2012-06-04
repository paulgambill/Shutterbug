//
//  PhotosAtPlaceTVC.m
//  Shutterbug
//
//  Created by Paul Gambill on 6/4/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "PhotosAtPlaceTVC.h"
#import "FlickrFetcher.h"

@interface PhotosAtPlaceTVC ()
@property (nonatomic, copy) NSDictionary *selection;
@property (nonatomic, strong) NSArray *photosAtPlace;
@end

@implementation PhotosAtPlaceTVC
@synthesize selection = _selection;
@synthesize photosAtPlace = _photosAtPlace;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)getTitleFromSelection:(NSDictionary *)selection
{
    NSArray *components = [[[selection objectForKey:@"object"] valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
    return [components objectAtIndex:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.photosAtPlace = [FlickrFetcher photosInPlace:[self.selection objectForKey:@"object"] maxResults:50];
    NSLog(@"%i", [self.photosAtPlace count]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self getTitleFromSelection:self.selection];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
