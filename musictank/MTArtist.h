//
//  MTArtist.h
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTImageHandler.h"

@protocol MTArtistDelegate;

@interface MTArtist : NSObject

@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *avatar;

@end

@protocol MTArtistDelegate <NSObject>

- (void)didDownloadAvatarForArtist:(MTArtist *)artist;

@end