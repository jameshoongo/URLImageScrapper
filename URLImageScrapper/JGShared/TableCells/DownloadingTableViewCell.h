//
//  DownloadingTableViewCell.h
//  URLImageScrapper
//
//  Created by James Go on 2014-06-17.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGDownloadingImageCellDelegate
- (void) didFinishDownloading:(NSInteger)thisTag withImage:(UIImage*)thisImage;
@end;

@interface DownloadingTableViewCell : UITableViewCell
{
    id __weak delegate;
}
@property (nonatomic, weak) id delegate;

@property (nonatomic, weak) IBOutlet UIProgressView * progressView;
@property (nonatomic, weak) IBOutlet UILabel * cellLabel;
@property (nonatomic, strong) NSString *downloadURL;
@property (nonatomic, weak) NSString * thisAlbumName;
@property (nonatomic, strong) NSIndexPath * thisIndexPath;
@end
