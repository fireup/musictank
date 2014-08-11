//
//  MTSongPlayViewController.h
//  musictank
//
//  Created by ZBN on 14-8-7.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFSoundManager/AFSoundManager.h>
#import "MTSong.h"
#import "MTArtist.h"

@interface MTSongPlayViewController : UIViewController

@property (copy, nonatomic) NSArray *songs;
@property (nonatomic) NSInteger index;

@end
