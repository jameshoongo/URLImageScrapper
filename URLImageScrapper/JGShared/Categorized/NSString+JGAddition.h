//
//  NSString+JGAddition.h
//  URLImageScrapper
//
//  Created by James Go on 2014-06-16.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JGAddition)
- (BOOL)isValidURL;
- (NSString*)checkHTTPPrefix;
- (NSMutableArray *)imgSrcAttributesInString;
- (NSString*) scrapeAllImagesFromHTML;
@end
