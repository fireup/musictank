//
//  MTLoginViewController.h
//  musictank
//
//  Created by ZBN on 14-8-6.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface MTLoginViewController : UIViewController

@property (strong, nonatomic) void (^successBlock) (void);
@property (strong, nonatomic) void (^cancelBlock) (void);

@end
