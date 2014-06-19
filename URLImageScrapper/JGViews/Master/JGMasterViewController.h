//
//  JGMasterViewController.h
//  URLImageScrapper
//
//  Created by James Go on 2014-06-16.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGTableViewController.h"
#import "JGImagesGalleryViewController.h"

@class JGDetailViewController;

@interface JGMasterViewController : JGTableViewController <UITextFieldDelegate>

@property (strong, nonatomic) JGImagesGalleryViewController *detailViewController;
@property (nonatomic, weak) IBOutlet UITextField *urlField;

@end
