//
//  MTLatestNewsCell.h
//  musictank
//
//  Created by ZBN on 14-8-9.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTLatestNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsBriefLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsTimeLabel;

@end
