//
//  TopPhotosTVC.m
//  Shutterbug
//
//  Created by Paul Gambill on 5/24/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "TopPhotosTVC.h"
#import "FlickrFetcher.h"

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


- (void)viewWillAppear:(BOOL)animated
{
    // set up activity indicator
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.hidesWhenStopped = YES;
    spinner.color = [UIColor blackColor];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    dispatch_queue_t downloadPlacesQueue = dispatch_queue_create("download places", NULL);
    dispatch_async(downloadPlacesQueue, ^{
        [spinner startAnimating];
        self.topPlaces = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
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
    
    if ([[segue identifier] isEqualToString:@"placePhotos"]) {
        // prepare selection info
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        id object = [self.topPlaces objectAtIndex:indexPath.row];
        NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys:
                                   indexPath, @"indexPath",
                                   object, @"object",
                                   nil];
        [destination setValue:selection forKey:@"selection"];
    }
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
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *photo = [self.topPlaces objectAtIndex:indexPath.row];
    
    // parse the location names by commas
    NSArray *components = [[photo objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
    NSString *location = @"";
    
    // put together the 2nd and later location names for the subtitle text
    for (int i=1; i<[components count]; i++) {
        location = [location stringByAppendingString:[components objectAtIndex:i]];
        location = [location stringByAppendingString:@", "];
    }
    
    // remove the trailing comma and space
    if ([location length] > 0) location = [location substringToIndex:[location length] - 2];
    
    cell.textLabel.text = [components objectAtIndex:0]; //specific city
    cell.detailTextLabel.text = location; //rest of location information
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
