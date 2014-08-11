//
//  MTDataHandler.m
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTDataHandler.h"


@implementation MTDataHandler

@synthesize login, sessionID, myArtistID;


- (BOOL)isLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}

- (void)setLogin:(BOOL)loginPassed
{
    [[NSUserDefaults standardUserDefaults] setBool:loginPassed forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)sessionID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"sessionID"];
}

- (void)setSessionID:(NSString *)sessionid
{
    [[NSUserDefaults standardUserDefaults] setObject:sessionid forKey:@"sessionID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)myArtistID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"myArtistID"];
}

- (void)setMyArtistID:(NSString *)myartistid
{
    [[NSUserDefaults standardUserDefaults] setObject:myartistid forKey:@"myArtistID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary *)artistData
{
    if (!_artistData) {
        _artistData = [[NSMutableDictionary alloc] init];
    }
    return _artistData;
}

+ (void)popArtistFailAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ARTISTIDFAILALERTTITLE", nil) message:NSLocalizedString(@"ARTISTIDFAILALERTMESSAGE", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ALERTCANCELBUTTON", nil) otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)popNetworkFailAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NETFAILALERTTITLE", nil) message:NSLocalizedString(@"NETFAILALERTMESSAGE", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ALERTCANCELBUTTON", nil) otherButtonTitles:nil, nil];
    [alert show];
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
