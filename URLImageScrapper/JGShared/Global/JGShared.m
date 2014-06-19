//
//  JGShared.m
//  URLImageScrapper
//
//  Created by James Go on 2014-06-16.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import "JGShared.h"

#import <AssetsLibrary/AssetsLibrary.h>

void JGDisplayAlert(id obj, NSString *title, NSString *errorMessage)
{
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:title message:errorMessage
                                                     delegate:obj cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[myAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

void JGDisplayNetworkConnectionError()
{
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"An error occurred while connecting to the server."
                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[myAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

BOOL JGIsNetworkConnectionAvailable()
{
    static BOOL _isDataSourceAvailable = NO;
    Boolean success;
    const char *host_name = "google.com";
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);

    return _isDataSourceAvailable;
}

BOOL JGIsDeviceiPad() {
    BOOL flag = NO;
    
#ifdef UI_USER_INTERFACE_IDIOM
    flag = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
	
	return flag;
}

NSString* JGGetDeviceType()
{
    return JGIsDeviceiPad() ? @"iPad" : @"iPhone";
}

BOOL JGIsGalleryAccessible()
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    return status == ALAuthorizationStatusAuthorized;
}

void JGGetPermissionForPhotoAlbum()
{
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
    } failureBlock:^(NSError *error) {
        if (error.code == ALAssetsLibraryAccessUserDeniedError) {
            NSLog(@"user denied access");
        }else{
            NSLog(@"Other error ");
        }
    }];
}