//
//  MTLeftViewController.h
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "UIViewController+MMDrawerController.h"
#import "MTImageHandler.h"
#import "MTLoginViewController.h"
#import "MTArtistHomeViewController.h"
#import "MTLatestSongsVC.h"
#import "MTLatestWorksVC.h"

@interface MTLeftViewController : UITableViewController <MTArtistImageDelegate>

- (IBAction)loginButtonTapped:(UIButton *)sender;
- (void)openLoginVC;

@end
