//
//  MTDataHandler.m
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTDataHandler.h"

@implementation MTDataHandler

@synthesize login;

- (BOOL)isLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}

- (void)setLogin:(BOOL)loginPassed
{
    [[NSUserDefaults standardUserDefaults] setBool:loginPassed forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - init

+ (instancetype)sharedData
{
    static MTDataHandler *sharedData = nil;
    if (!sharedData) {
        sharedData = [[self alloc] initPrivate];
    }
    return sharedData;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"singleton" reason:@"use [MTDataHandler sharedData]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    return self;
}


@end
