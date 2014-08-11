//
//  MTImageHandler.h
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

@protocol MTImageHandlerDelegate;

@interface MTImageHandler : NSObject

+ (UIImage *)getDefaultAvatarForFrame:(CGRect)frame;
//+ (UIImage *)getUserAvatarForFrame:(CGRect)frame;

+ (UIImage *)getAvatarFromImage:(UIImage *)image forFrame:(CGRect)frame;
+ (UIImage *)resizeImageFromImage:(UIImage *)image forFrame:(CGRect)frame;
+ (instancetype)sharedHandler;

- (void)downloadImageForURL:(NSString *)URLString;

@property (weak, nonatomic) id <MTImageHandlerDelegate> delegate;

@end

@protocol MTImageHandlerDelegate <NSObject>

- (void)didDownloadImage:(UIImage *)image forURL:(NSString *)URLString;

@optional
- (void)didFailDownloadImageForURL:(NSString *)URLString;

@end
