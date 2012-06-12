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
    // set up activity indicator
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.hidesWhenStopped = YES;
    spinner.color = [UIColor blackColor];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    dispatch_queue_t downloadPhotosQueue = dispatch_queue_create("download photos", NULL);
    dispatch_async(downloadPhotosQueue, ^{
        [spinner startAnimating];
        self.photosAtPlace = [FlickrFetcher photosInPlace:[self.selection objectForKey:@"object"] maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            [self.tableView reloadData];
            [super viewWillAppear:animated];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // title comes from the tapped cell
    self.title = [self getTitleFromSelection:self.selection];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"photo view"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *photo = [self.photosAtPlace objectAtIndex:indexPath.row];
        NSDictionary *cellText = [self titleAndSubtitleFromPhotoDictionary:photo];
        NSMutableDictionary *selection = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   indexPath, @"indexPath",
                                   photo, @"photo",
                                   cellText, @"cellText",
                                   nil];
        [destination setValue:selection forKey:@"selection"];
        
        // remove non-property list before adding the dictionary to UserDefaults
        [selection removeObjectForKey:@"indexPath"];
        
        //saving photo to NSUserDefaults for use in Recents tab
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *selectedPhotos = nil;
        if ([defaults objectForKey:@"selectedPhotos"]) {
            selectedPhotos = [[defaults objectForKey:@"selectedPhotos"] mutableCopy];
            
            // only add a new recent photo if it's not already stored in recents
            if (![selectedPhotos containsObject:selection]){
            
                // checks how many recent photos are stored. the max is 20. recent photos are inserted at the head of the array.
                if ([selectedPhotos count] < 20) {
                    [selectedPhotos insertObject:selection atIndex:0];
                }
                //else, remove the last object in the array and insert this new one at the head
                else {
                    [selectedPhotos removeLastObject];
                    [selectedPhotos insertObject:selection atIndex:0];
                }
            }
        }
        else {
            selectedPhotos = [NSMutableArray arrayWithObject:selection];
        }
        [defaults setObject:selectedPhotos forKey:@"selectedPhotos"];
        [defaults synchronize];
    }
}

// helper method to get the correct title and subtitle for each cell
- (NSDictionary *)titleAndSubtitleFromPhotoDictionary:(NSDictionary *)photo
{
    NSString *title = [photo valueForKey:FLICKR_PHOTO_TITLE];
    NSString *subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    // if there is a title in the dictionary set the cell title to photo title. If there is also a description, set that as subittle
    // if there is no title, but there is a description, set cell title to description
    // if there is no title or description, set cell title to "Unknown"
    if (![title isEqualToString:@""]) {
        title = [photo valueForKey:FLICKR_PHOTO_TITLE];
        
        if (![subtitle isEqualToString:@""])
            subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    } else if (![subtitle isEqualToString:@""]) {
        title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    } else {
        title = @"Unknown";
    }
    
    NSDictionary *cellText = [NSDictionary dictionaryWithObjectsAndKeys:
                              title, @"title",
                              subtitle, @"subtitle",
                              nil];
    
    return cellText;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photosAtPlace count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"place photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *photo = [self.photosAtPlace objectAtIndex:indexPath.row];
    NSDictionary *cellText = [self titleAndSubtitleFromPhotoDictionary:photo];
    
    // set the cell title labels
    cell.textLabel.text = [cellText objectForKey:@"title"];
    cell.detailTextLabel.text = [cellText objectForKey:@"subtitle"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
