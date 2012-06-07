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


//calculates the correct zoomScale to be used based off the current view frame size vs the image size
- (double)getZoomScale
{
    double comparedHeight = self.view.frame.size.height / self.imageView.image.size.height;
    double comparedWidth = self.view.frame.size.width / self.imageView.image.size.width;
    
    if (comparedHeight > comparedWidth) {
        return comparedHeight;        
    }
    else {
        return comparedWidth;
    }
}

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
}

- (void)viewWillAppear:(BOOL)animated
{
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("photo downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSDictionary *photo = [self.selection objectForKey:@"photo"];
        NSURL *photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
        self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //set the zoomScale to 1 if we're returning from another view so that contentSize can be adjusted
            self.scrollView.zoomScale = 1;
            
            // set scrolling area equal to size of image
            self.scrollView.contentSize = self.imageView.image.size;
            
            //set the image frame to the size of the image
            self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
            
            //get the correct minimum zoomScale and set the actual zoom to that
            self.scrollView.minimumZoomScale = [self getZoomScale];
            self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
            
            /* uncomment to log sizing and zoomScale
            NSLog(@"image width is: %f", self.imageView.image.size.width);
            NSLog(@"image height is: %f", self.imageView.image.size.height);
            NSLog(@"view size is: %@",  NSStringFromCGSize(self.view.frame.size));
            NSLog(@"comparedHeight is: %f", comparedHeight);
            NSLog(@"comparedWidth is: %f", comparedWidth);
            NSLog(@"zoomScale is: %f", self.scrollView.zoomScale);
            NSLog(@"minimum is: %f", self.scrollView.minimumZoomScale);
            */
        });
    });
    dispatch_release(downloadQueue);
}

- (void)viewDidAppear:(BOOL)animated
{
    // need to flash the scroll bars when initially viewing the image
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
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //reset zoomScale back to 1 so that contentSize can be modified correctly
    self.scrollView.zoomScale = 1;
    
    // reset scrolling area equal to size of image
    self.scrollView.contentSize = self.imageView.image.size;
    
    //reset the image frame to the size of the image
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
    //get the correct minimum zoomScale and set the actual zoom to that
    self.scrollView.minimumZoomScale = [self getZoomScale];
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
}

@end
