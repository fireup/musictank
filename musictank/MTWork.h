//
//  MTWork.h
//  musictank
//
//  Created by ZBN on 14-8-7.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTArtist.h"

@interface MTWork : NSObject

@property (strong, nonatomic) NSString *artistID;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *liked;
@property (copy, nonatomic) NSString *URL;
@property (copy, nonatomic) NSString *played;
@property (copy, nonatomic) NSString *workID;
@property (copy, nonatomic) NSString *createdTime;

@end
