//
//  JGViewController.h
//  URLImageScrapper
//
//  Created by James Go on 2014-06-16.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface JGViewController : UIViewController
- (void) addActivityIndicator:(NSString*)message;
- (void) removeActivityIndicator;
@end
