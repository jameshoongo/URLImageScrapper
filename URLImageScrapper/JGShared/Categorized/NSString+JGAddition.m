//
//  NSString+JGAddition.m
//  URLImageScrapper
//
//  Created by James Go on 2014-06-16.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import "NSString+JGAddition.h"
#import "HTMLParser.h"
#import "HTMLNode.h"

@implementation NSString (JGAddition)

- (BOOL)isValidURL
{
    NSString *urlRegEx = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:self];
}

- (NSString*)checkHTTPPrefix
{
    if([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"])
        return [NSString stringWithFormat:@"%@", self];
    else
        return [NSString stringWithFormat:@"http://%@", self];
}

- (NSMutableArray *)imgSrcAttributesInString
{
    NSMutableArray *results = [NSMutableArray array];
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:self error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    } else {
        HTMLNode *bodyNode = [parser body];
        NSArray *imgNodes = [bodyNode findChildTags:@"img"];
        
        for (HTMLNode *imgNode in imgNodes) {
            //check if src is already in the array
            if(![results containsObject:[imgNode getAttributeNamed:@"src"]] && [[imgNode getAttributeNamed:@"src"] isValidURL])
                [results addObject:[imgNode getAttributeNamed:@"src"]];
        }
    }
    
    return results;
}

- (NSString*) scrapeAllImagesFromHTML
{
    NSMutableArray *results = [NSMutableArray array];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    [regex enumerateMatchesInString:self
                            options:0
                              range:NSMakeRange(0, [self length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             //check if the tag is already in the array
                             if(![results containsObject:[self substringWithRange:[result rangeAtIndex:1]]])
                                 [results addObject:[self substringWithRange:[result rangeAtIndex:1]]];
                         }];
    NSString * thisHTML = [self copy];
    
    //replace with small image file
    for(NSString * thisTag in results)
        thisHTML = [thisHTML stringByReplacingOccurrencesOfString:thisTag withString:@"<img src='data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='>"];
    
    return thisHTML;
}
@end
