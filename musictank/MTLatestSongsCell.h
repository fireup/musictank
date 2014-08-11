//
//  MTLatestSongsCell.h
//  musictank
//
//  Created by ZBN on 14-8-8.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTLatestSongsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artistAvatar;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *songLength;
@property (weak, nonatomic) IBOutlet UILabel *songLiked;

@end
