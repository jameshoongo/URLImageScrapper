//
//  JGImagesGalleryViewController.m
//  URLImageScrapper
//
//  Created by James Go on 2014-06-18.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import "JGImagesGalleryViewController.h"
#import "JGImageCollectionViewCell.h"
#import "AFHTTPRequestOperation.h"
#import "JGShared.h"
#import "NSString+JGAddition.h"

#import "SVProgressHUD.h"

@interface JGImagesGalleryViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@property (nonatomic, strong) NSMutableArray* listOfImages;
@property (nonatomic, strong) IBOutlet UIWebView * thisWebView;
@property (nonatomic, strong) IBOutlet UICollectionView * thisCollectionView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * flipBtn;
@property (assign) BOOL isCollectionViewVisible;
@end

@implementation JGImagesGalleryViewController

- (IBAction)flipView:(id)sender
{
    if(!self.isCollectionViewVisible)
    {
        [UIView transitionFromView:self.thisWebView toView:self.thisCollectionView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
        self.isCollectionViewVisible = YES;
        [self.flipBtn setTitle:@"Webpage"];
    }
    else
    {
        [UIView transitionFromView:self.thisCollectionView toView:self.thisWebView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            [self.thisWebView setFrame:CGRectMake(self.thisWebView.frame.origin.x, 64, self.thisWebView.frame.size.width, self.collectionView.frame.size.height-44)];
        }];
        self.isCollectionViewVisible = NO;
        [self.flipBtn setTitle:@"Images"];
    }
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        self.title = [self.detailItem description];
        [self.thisWebView loadHTMLString:@"" baseURL:nil];
        if(JGIsDeviceiPad())
            [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD resetOffsetFromCenter];
        [SVProgressHUD showWithStatus:@"Loading Data..."];
        [self.flipBtn setEnabled:NO];
        
        NSURL *URL = [NSURL URLWithString:[self.detailItem description]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        //forcing to load the webpage in mobile version
        [request setValue:JGGetDeviceType() forHTTPHeaderField:@"User-Agent" ];
        //forcing to disable script.. not sure if that works properly for all websites
        [request setValue:@"script-src none" forHTTPHeaderField:@"X-WebKit-CSP" ];
        [request setValue:@"text/html" forHTTPHeaderField:@"Content-type" ];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            self.listOfImages = [string imgSrcAttributesInString];
            [self.thisWebView loadHTMLString:[string scrapeAllImagesFromHTML] baseURL:nil];
            [self.flipBtn setEnabled:YES];
            if([self.listOfImages count] > 0)
            {                
                [self performSegueWithIdentifier:@"downloadImages" sender:self];
            }
            else
            {
                JGDisplayAlert(nil, @"", @"There is no image to download");
                [self flipView:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.flipBtn setEnabled:YES];
            [SVProgressHUD dismiss];
            JGDisplayAlert(self, @"Error", [error localizedDescription]);
        }];
        [op start];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    // Do any additional setup after loading the view.
    [self configureView];
    self.isCollectionViewVisible = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"downloadImages"] && [self.listOfImages count] > 0) {
        return YES;
    }
    return NO;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setTitle:self.title];
    [[segue destinationViewController] setDetailItem:self.listOfImages];
    [[segue destinationViewController] setDelegate:self];
}

#pragma mark - 
#pragma mark JGDownloadImagesListingDelegate
- (void) didFinishDownloadingAllWithImages:(NSMutableArray*)listOfImageObjs
{
    self.listOfImages = listOfImageObjs;
    [self.thisCollectionView reloadData];
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [self.listOfImages count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGImageCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"ImageCell"
                                    forIndexPath:indexPath];
    
    if([[self.listOfImages objectAtIndex:[indexPath row]] isKindOfClass:[UIImage class]])
        myCell.imageView.image = [self.listOfImages objectAtIndex:[indexPath row]];
    
    return myCell;
}


@end
