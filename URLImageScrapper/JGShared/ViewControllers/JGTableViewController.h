//
//  JGTableViewController.h
//  URLImageScrapper
//
//  Created by James Go on 2014-06-16.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGViewController.h"

@interface JGTableViewController : JGViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *tableView;
    NSMutableArray  *listItems;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (atomic, strong) NSMutableArray *listItems;
@end
