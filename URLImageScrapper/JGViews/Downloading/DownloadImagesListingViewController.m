//
//  DownloadImagesListingViewController.m
//  URLImageScrapper
//
//  Created by James Go on 2014-06-17.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import "DownloadImagesListingViewController.h"
#import "DownloadingTableViewCell.h"
#import "JGShared.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface DownloadImagesListingViewController ()
@property (strong, nonatomic) IBOutlet UINavigationBar * navigationBar;
@property (weak, nonatomic) IBOutlet UIProgressView * totalProgressBar;
@property (weak, nonatomic) IBOutlet UILabel * progressLabel;
@property (assign) int downloadedCounter;
@property (assign) int numberOfImages;
@property (nonatomic, strong) NSMutableArray * originalListOfImages;
@property (nonatomic, strong) NSMutableArray * listOfImageObjs;
@end

@implementation DownloadImagesListingViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)setDetailItem:(id)newDetailItem
{
    if (self.listItems != newDetailItem) {
        self.listItems = newDetailItem;
        self.originalListOfImages = [newDetailItem copy];
        self.numberOfImages = (int)[self.listItems count];
        self.listOfImageObjs = [NSMutableArray array];
    }
}

- (void)setDelegate:(id)_delegate
{
    delegate = _delegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.topItem.title = self.title;
    [self.totalProgressBar setProgress:0.0];
    self.downloadedCounter = 0;
    [self.progressLabel setText:[NSString stringWithFormat:@"%d of %lu downloading...", self.downloadedCounter, (unsigned long)[self.listItems count]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelDownloading:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listItems count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DownloadingCell";
    DownloadingTableViewCell * cell = (DownloadingTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[DownloadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.progressView setProgress:0.0];
    cell.cellLabel.text = [self.listItems objectAtIndex:indexPath.row];
    cell.downloadURL = [self.listItems objectAtIndex:indexPath.row];
    cell.thisAlbumName = self.title;
    cell.thisIndexPath = [indexPath copy];
    cell.tag = [self.originalListOfImages indexOfObject:cell.downloadURL] + 1;
    
    return cell;
}

#pragma mark - DownloadingTableViewCellDelegate
- (void) didFinishDownloading:(NSInteger)thisTag withImage:(UIImage*)thisImage
{
    @synchronized(self)
    {
        UITableViewCell * thisCell = (UITableViewCell*)[self.tableView viewWithTag:thisTag];
        NSIndexPath * thisIndexPath = [self.tableView indexPathForCell:thisCell];
        [self.listOfImageObjs addObject:thisImage];
        self.downloadedCounter++;
        [self.totalProgressBar setProgress:((float)self.downloadedCounter/(float)self.numberOfImages)];
        [self.progressLabel setText:[NSString stringWithFormat:@"%d of %d downloading...", self.downloadedCounter, self.numberOfImages]];
        if([self.listItems count] > thisIndexPath.row && thisIndexPath){
            [self.listItems removeObjectAtIndex:thisIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:thisIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        if(self.downloadedCounter == self.numberOfImages)
        {
            [self finishedDownloading];
        }
    }
}

- (void)finishedDownloading
{
    if(delegate && [delegate respondsToSelector:@selector(didFinishDownloadingAllWithImages:)])
        [delegate didFinishDownloadingAllWithImages:self.listOfImageObjs];
    JGDisplayAlert(self, @"", @"Image downloading is completed.");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
