//
//  JGShared.h
//  URLImageScrapper
//
//  Created by James Go on 2014-06-16.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

void JGDisplayAlert(id obj, NSString *title, NSString *errorMessage);
void JGDisplayNetworkConnectionError();
BOOL JGIsNetworkConnectionAvailable();
BOOL JGIsDeviceiPad();
NSString* JGGetDeviceType();

BOOL JGIsGalleryAccessible();
void JGGetPermissionForPhotoAlbum();