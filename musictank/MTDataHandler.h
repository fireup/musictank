//
//  MTDataHandler.h
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MTDataHandler : NSObject

@property (getter = isLogin, nonatomic) BOOL login;
@property (strong, nonatomic) NSString *sessionID;

@property (nonatomic, copy, readonly) NSString *appVersion;
@property (nonatomic, copy, readonly) NSString *appPlatform;

+ (instancetype)sharedData;

@end
