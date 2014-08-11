//
//  MTDataHandler.h
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MTArtist.h"

@interface MTDataHandler : NSObject

@property (getter = isLogin, nonatomic) BOOL login;
@property (strong, nonatomic) NSString *sessionID;
@property (strong, nonatomic) NSString *myArtistID;
@property (copy, nonatomic) NSString *userAvatarURL;
@property (strong, nonatomic) UIViewController *currentPlaying;

@property (strong, nonatomic) NSMutableDictionary *artistData;

@property (nonatomic, copy, readonly) NSString *appVersion;
@property (nonatomic, copy, readonly) NSString *appPlatform;

+ (instancetype)sharedData;
+ (void)popArtistFailAlert;
+ (void)popNetworkFailAlert;

@end
