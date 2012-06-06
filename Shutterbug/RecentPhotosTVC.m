//
//  RecentPhotosTVC.m
//  Shutterbug
//
//  Created by Paul Gambill on 5/31/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "RecentPhotosTVC.h"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *photo = [[[defaults objectForKey:@"selectedPhotos"] objectAtIndex:indexPath.row] objectForKey:@"photo"];
        NSDictionary *cellText = [[[defaults objectForKey:@"selectedPhotos"] objectAtIndex:indexPath.row] objectForKey:@"cellText"];        
        NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys:
                                   indexPath, @"indexPath",
                                   photo, @"photo",
                                   cellText, @"cellText",
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:@"selectedPhotos"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"place photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *cellText = [[[defaults objectForKey:@"selectedPhotos"] objectAtIndex:indexPath.row] objectForKey:@"cellText"];
    
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
