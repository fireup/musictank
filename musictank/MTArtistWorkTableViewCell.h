//
//  MTArtistWorkTableViewCell.h
//  musictank
//
//  Created by ZBN on 14-8-7.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTArtistWorkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *workNumber;
@property (weak, nonatomic) IBOutlet UILabel *workName;
@property (weak, nonatomic) IBOutlet UILabel *workLiked;
@property (weak, nonatomic) IBOutlet UILabel *workPlayed;

@end
