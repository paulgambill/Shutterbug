//
//  TopPhotosTVC.m
//  Shutterbug
//
//  Created by Paul Gambill on 5/24/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "TopPhotosTVC.h"
#import "FlickrFetcher.h"
#import "FlickrPlaceAnnotation.h"

@interface TopPhotosTVC ()
@end

@implementation TopPhotosTVC
@synthesize topPlaces = _topPlaces;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.topPlaces count]];
    for (NSDictionary *place in self.topPlaces) {
        if ([FlickrPlaceAnnotation annotationForFlickrDictionary:place]) {
            FlickrPlaceAnnotation *annotation = [FlickrPlaceAnnotation annotationForFlickrDictionary:place];
            [annotations addObject:annotation];
        }
    }
    
    return annotations;
}

- (void)viewWillAppear:(BOOL)animated
{
    // set up activity indicator
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.hidesWhenStopped = YES;
    spinner.color = [UIColor blackColor];
    spinner.center = self.view.center;
    [self.view.superview addSubview:spinner];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    dispatch_queue_t downloadPlacesQueue = dispatch_queue_create("download places", NULL);
    dispatch_async(downloadPlacesQueue, ^{
        [spinner startAnimating];
        self.topPlaces = [FlickrFetcher topPlaces];
        //sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.tableView reloadData];
            [super viewWillAppear:animated];
        });
    });
    dispatch_release(downloadPlacesQueue);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    
    // prepare selection info
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    id object = [self.topPlaces objectAtIndex:indexPath.row];
    NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys:
                               indexPath, @"indexPath",
                               object, @"object",
                               nil];
    
    // going to next table view controller
    if ([[segue identifier] isEqualToString:@"placePhotos"]) {
        [destination setValue:selection forKey:@"selection"];
    }
    
    // going to Map view
    if ([[segue identifier] isEqualToString:@"placesMap"]) {
        [destination setValue:[self mapAnnotations] forKey:@"photos"];
        [destination setValue:@"placesMap" forKey:@"whichMap"];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source



// method to extract the location and subtitle location of each top place
- (NSDictionary *)locationAndSublocationAtIndex:(NSInteger)index
{
    NSDictionary *photo = [self.topPlaces objectAtIndex:index];
    
    // parse the location names by commas
    NSArray *components = [[photo objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
    NSString *sublocation = @"";
    
    // put together the 2nd and later location names for the subtitle text
    for (int i=1; i<[components count]; i++) {
        sublocation = [sublocation stringByAppendingString:[components objectAtIndex:i]];
        sublocation = [sublocation stringByAppendingString:@", "];
    }
    
    // remove the trailing comma and space
    if ([sublocation length] > 0) sublocation = [sublocation substringToIndex:[sublocation length] - 2];
    
    NSDictionary *locationAndSublocation = [NSDictionary dictionaryWithObjectsAndKeys:[components objectAtIndex:0], @"location",
                                                                                    sublocation, @"sublocation",
                                                                                    nil];
    
    return locationAndSublocation;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[self locationAndSublocationAtIndex:indexPath.row] objectForKey:@"location"]; //specific city
    cell.detailTextLabel.text = [[self locationAndSublocationAtIndex:indexPath.row] objectForKey:@"sublocation"];; //rest of location information
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
