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
@property (nonatomic, strong) NSArray *photosAtPlace;
@end

@implementation TopPhotosTVC
@synthesize topPlaces = _topPlaces;
@synthesize photosAtPlace = _photosAtPlace;

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
    self.topPlaces = [FlickrFetcher topPlaces];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*Logging flickrfetcher
    
    
    self.topPlaces = [FlickrFetcher topPlaces];
    self.photosAtPlace = [FlickrFetcher photosInPlace:[self.topPlaces objectAtIndex:1] maxResults:3];
    
    NSLog(@"%@", self.photosAtPlace);
     */

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
