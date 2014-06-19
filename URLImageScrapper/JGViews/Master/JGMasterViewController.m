//
//  JGMasterViewController.m
//  URLImageScrapper
//
//  Created by James Go on 2014-06-16.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import "JGMasterViewController.h"
#import "NSString+JGAddition.h"
#import "JGShared.h"
#import "JGImagesGalleryViewController.h"

@interface JGMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation JGMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"URL Image Scrapper";
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (JGImagesGalleryViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    JGGetPermissionForPhotoAlbum();
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self shouldPerformSegueWithIdentifier:@"fetchURL" sender:self])
    {
        if(JGIsDeviceiPad())
            [self setDetailItemForiPad:nil];
        else
            [self performSegueWithIdentifier:@"fetchURL" sender:self];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)setDetailItemForiPad:(id)sender
{
    NSString * thisURL = [self.urlField.text checkHTTPPrefix];
    if(![thisURL isValidURL]) {
        JGDisplayAlert(nil, @"Error", @"Invalid URL");
    } else if (!JGIsGalleryAccessible()) {
        JGDisplayAlert(nil, @"Error", @"Please allow the application's access to Photo Album.");
    } else if (!JGIsNetworkConnectionAvailable()) {
        JGDisplayNetworkConnectionError();
    } else {
        NSString * thisURL = [self.urlField.text checkHTTPPrefix];
        [self.view endEditing:YES];
        [self.detailViewController setDetailItem:thisURL];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"fetchURL"]) {
        NSString * thisURL = [self.urlField.text checkHTTPPrefix];
        if(![thisURL isValidURL]) {
            JGDisplayAlert(nil, @"Error", @"Invalid URL");
            return NO;
        } else if (!JGIsGalleryAccessible()) {
            JGDisplayAlert(nil, @"Error", @"Please allow the application's access to Photo Album.");
            return NO;
        } else if (!JGIsNetworkConnectionAvailable()) {
            JGDisplayNetworkConnectionError();
            return NO;
        }
    }
    
    return YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    } else if([[segue identifier] isEqualToString:@"fetchURL"]) {
        NSString * thisURL = [self.urlField.text checkHTTPPrefix];
        [[segue destinationViewController] setDetailItem:thisURL];
    }
}

@end
