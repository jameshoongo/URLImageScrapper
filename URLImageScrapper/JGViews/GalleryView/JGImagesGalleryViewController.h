//
//  JGImagesGalleryViewController.h
//  URLImageScrapper
//
//  Created by James Go on 2014-06-18.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadImagesListingViewController.h"

@interface JGImagesGalleryViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate, JGDownloadingImagesDelegate>
@property (strong, nonatomic) id detailItem;
@end
