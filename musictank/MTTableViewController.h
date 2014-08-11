//
//  MTTableViewController.h
//  musictank
//
//  Created by ZBN on 14-8-11.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *dataToDisplay;
@property (strong, nonatomic, readonly) NSArray *dataDownloaded;
@property (strong, nonatomic) NSString *url;
//收取的数据的标识；例如，works,songs等
@property (strong, nonatomic) NSString *responseTitle;

//将获得的NSDictionary数据转换为要显示的object。
- (void)translateDownloadToDisplay;

- (void)loadOneMorePage;

@end
