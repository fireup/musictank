//
//  MTSong.h
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTArtist.h"

@interface MTSong : NSObject

@property (strong, nonatomic) MTArtist *artist;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *liked;
@property (copy, nonatomic) NSString *length;
@property (copy, nonatomic) NSString *streamURL;

@end
