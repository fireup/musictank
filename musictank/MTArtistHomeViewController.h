//
//  MTArtistHomeViewController.h
//  musictank
//
//  Created by ZBN on 14-8-6.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <QuartzCore/QuartzCore.h>
#import "ASScroll.h"

@interface MTArtistHomeViewController : UIViewController <MTArtistProfileDelegate>

@property (strong, nonatomic) NSString *artistID;

@end
