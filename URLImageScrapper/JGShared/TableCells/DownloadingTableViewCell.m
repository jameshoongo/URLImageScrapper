//
//  DownloadingTableViewCell.m
//  URLImageScrapper
//
//  Created by James Go on 2014-06-17.
//  Copyright (c) 2014 JG Software Solutions. All rights reserved.
//

#import "DownloadingTableViewCell.h"
#import "NSString+JGAddition.h"
#import "UIProgressView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface DownloadingTableViewCell ()
@property (assign, atomic) BOOL isDownloaded;
@end

@implementation DownloadingTableViewCell
@synthesize delegate;

- (void)awakeFromNib
{
    // Initialization code
    self.isDownloaded = NO;
}

@synthesize downloadURL;

-(void)setDownloadURL:(NSString *)_downloadURL
{
    if(downloadURL != _downloadURL)
    {
        downloadURL = _downloadURL;
        
        if([_downloadURL isValidURL])
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_downloadURL] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:100.0f];
            
            AFHTTPRequestOperation * _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            _operation.responseSerializer = [AFImageResponseSerializer serializer];
            [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
                [libraryFolder saveImage:responseObject toAlbum:self.thisAlbumName withCompletionBlock:^(NSError *error) {
                    if(delegate && [delegate respondsToSelector:@selector(didFinishDownloading:withImage:)])
                        [delegate didFinishDownloading:self.tag withImage:responseObject];
                }];
//                NSLog(@"success block : %@", _downloadURL);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //                NSLog(@"failure block : %@", _downloadURL);
                if(delegate && [delegate respondsToSelector:@selector(didFinishDownloading:withImage:)])
                    [delegate didFinishDownloading:self.tag withImage:nil];
            }];
            [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                [self.progressView setProgress:((float)totalBytesRead/totalBytesExpectedToRead) animated:YES];
            }];
            
            [_operation start];
        }
        else
        {
            NSLog(@"it's not valid url : %@", _downloadURL);
            if(delegate && [delegate respondsToSelector:@selector(didFinishDownloading:withImage:)])
                [delegate didFinishDownloading:self.tag withImage:nil];
        }
        
    }
}
-(NSString*)downloadURL
{
    return downloadURL;
}
//-(void)setDownloadURL:(NSString *)thisDownloadURL
//{
//    NSLog(@"url is set : %@", thisDownloadURL);
//        if(_downloadURL == nil)
//        {
//            _downloadURL = thisDownloadURL;
//            
//            NSLog(@"start downloading: %@", thisDownloadURL);
//            if([thisDownloadURL isValidURL])
//            {
//                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:thisDownloadURL] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:100.0f];
//                
//                AFHTTPRequestOperation * _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//                _operation.responseSerializer = [AFImageResponseSerializer serializer];
//                [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
//                    [libraryFolder saveImage:responseObject toAlbum:self.thisAlbumName withCompletionBlock:^(NSError *error) {
//                        if(delegate && [delegate respondsToSelector:@selector(didFinishDownloading:)])
//                            [delegate didFinishDownloading:self.thisIndexPath];
//                    }];
//                    NSLog(@"success block : %@", thisDownloadURL);
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    NSLog(@"failure block : %@", thisDownloadURL);
//                    if(delegate && [delegate respondsToSelector:@selector(didFinishDownloading:)])
//                        [delegate didFinishDownloading:self.thisIndexPath];
//                }];
//                [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//                    [self.progressView setProgress:((float)totalBytesRead/totalBytesExpectedToRead) animated:YES];
//                }];
//                
//                [_operation start];
//            }
//            else
//            {
//                NSLog(@"it's not valid url : %@", thisDownloadURL);
//                if(delegate && [delegate respondsToSelector:@selector(didFinishDownloading:)])
//                    [delegate didFinishDownloading:self.thisIndexPath];
//            }
//        }
//    //    if(!self.isDownloaded)
////    {
////        self.isDownloaded = YES;
////        NSLog(@"start downloading: %@", downloadURL);
////        
////        if([downloadURL isValidURL])
////        {
////            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadURL] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:100.0f];
////            
////            AFHTTPRequestOperation * _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
////            _operation.responseSerializer = [AFImageResponseSerializer serializer];
////            [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
////                ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
////                [libraryFolder saveImage:responseObject toAlbum:self.thisAlbumName withCompletionBlock:^(NSError *error) {
////                    if(delegate && [delegate respondsToSelector:@selector(didFinishDownloading:)])
////                        [delegate didFinishDownloading:self.thisIndexPath];
////                }];
////                NSLog(@"success block : %@", downloadURL);
////            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////                NSLog(@"failure block : %@", downloadURL);
////                if(delegate && [delegate respondsToSelector:@selector(didFinishDownloading:)])
////                    [delegate didFinishDownloading:self.thisIndexPath];
////            }];
////            [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
////                [self.progressView setProgress:((float)totalBytesRead/totalBytesExpectedToRead) animated:YES];
////            }];
////            
////            [_operation start];
////        }
////        else
////        {
////            NSLog(@"it's not valid url : %@", downloadURL);
////            if(delegate && [delegate respondsToSelector:@selector(didFinishDownloading:)])
////                [delegate didFinishDownloading:self.thisIndexPath];            
////        }
////    }
//}

@end
