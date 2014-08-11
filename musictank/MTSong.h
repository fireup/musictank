//
//  MTSong.h
//  musictank
//
//  Created by ZBN on 14-8-7.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSong : NSObject

@property (strong, nonatomic) NSString *artistID;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *played;
@property (copy, nonatomic) NSString *liked;
@property (copy, nonatomic) NSString *length;
@property (copy, nonatomic) NSString *streamURL;
@property (copy, nonatomic) NSString *lyrics;
@property (copy, nonatomic) NSString *style;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *songID;

@end
