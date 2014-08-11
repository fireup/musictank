//
//  MTArtistSongTableViewCell.h
//  musictank
//
//  Created by ZBN on 14-8-7.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTArtistSongTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *songNumber;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *songLength;
@property (weak, nonatomic) IBOutlet UILabel *songCreatedTime;
@property (weak, nonatomic) IBOutlet UIImageView *rightAccessory;

@end
