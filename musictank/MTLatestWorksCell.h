//
//  MTLatestWorksCell.h
//  musictank
//
//  Created by ZBN on 14-8-8.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTLatestWorksCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *artistAvatar;
@property (weak, nonatomic) IBOutlet UILabel *workName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *workLength;
@property (weak, nonatomic) IBOutlet UILabel *workLiked;


@end
