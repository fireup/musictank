//
//  MTNewsDetailVC.m
//  musictank
//
//  Created by ZBN on 14-8-9.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTNewsDetailVC.h"

@interface MTNewsDetailVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageLarge;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageSmallLeft;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageSmallRight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dividerLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;

@property (strong, nonatomic) UIView *cover;
@property (strong, nonatomic) UIActivityIndicatorView *iView;

@end

@implementation MTNewsDetailVC

- (void)updateNewsDetail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *para = @{@"session_id": [MTDataHandler sharedData].sessionID,
                           @"news_id": self.news[@"id"]};
    [manager POST:NEWSDETAILURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dividerLabel.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.3];
    
    [self updateNewsDetail];
}


- (UIView *)cover
{
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:self.view.bounds];
        _cover.backgroundColor = [UIColor grayColor];
    }
    return _cover;
}

- (UIActivityIndicatorView *)iView
{
    if (!_iView) {
        _iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_iView startAnimating];
    }
    return _iView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
