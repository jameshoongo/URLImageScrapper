//
//  DownloadImagesListingViewController.h
//  URLImageScrapper
//
//  Created by James Go on 2014-06-17.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import "JGTableViewController.h"
#import "DownloadingTableViewCell.h"
@protocol JGDownloadingImagesDelegate
- (void) didFinishDownloadingAllWithImages:(NSMutableArray*)listOfImageObjs;
@end;

@interface DownloadImagesListingViewController : JGTableViewController <JGDownloadingImageCellDelegate>
{
    id __weak delegate;
}
@property (nonatomic, weak) id delegate;
@end
