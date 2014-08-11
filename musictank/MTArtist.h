//
//  MTArtist.h
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTImageHandler.h"

@protocol MTArtistImageDelegate, MTArtistProfileDelegate;

@interface MTArtist : NSObject

@property (copy, nonatomic) NSString *artistID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *intro;
@property (copy, nonatomic) NSString *totalPlayedTimes;
@property (copy, nonatomic) NSString *totalLikeFromArtist;
@property (copy, nonatomic) NSString *totalLikeFromProducer;
@property (copy, nonatomic) NSArray *sliderImageURLs;
@property (copy, nonatomic) NSArray *works;
@property (copy, nonatomic) NSArray *songs;

@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *avatarImage;

@property (weak, nonatomic) id <MTArtistImageDelegate> imageDelegate;
@property (weak, nonatomic) id <MTArtistProfileDelegate> profileDelegate;

- (void)downloadProfile;

@end

@protocol MTArtistProfileDelegate <NSObject>

- (void)didDownloadProfileForArtist:(NSString *)artistID;
- (void)failedDownloadProfileForArtist:(NSString *)artistID;

@end

//下载头像成功后的通知。在下载profile之后执行。
@protocol MTArtistImageDelegate <NSObject>

- (void)didDownloadAvatarImageForArtist:(NSString *)artistID;

@end