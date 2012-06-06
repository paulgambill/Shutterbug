//
//  PhotoViewController.m
//  Shutterbug
//
//  Created by Paul Gambill on 6/4/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController () <UIScrollViewDelegate>
@property (nonatomic, copy) NSDictionary *selection;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewController
@synthesize selection = _selection;
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//this method is necessary for the scrollview delegate. the delegate is set as self in viewDidLoad
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    // title comes from the tapped cell
    self.title = [[self.selection objectForKey:@"cellText"] valueForKey:@"title"];
    //self.view.backgroundColor = [UIColor redColor];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDictionary *photo = [self.selection objectForKey:@"photo"];
    NSURL *photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
   
    // set scrolling area equal to size of image
    self.scrollView.contentSize = self.imageView.image.size;
    
    //set the image frame to the size of the image
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    // need to flash the scroll bars
   [self.scrollView flashScrollIndicators];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
