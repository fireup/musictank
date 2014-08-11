//
//  MTWorkShowVC.m
//  musictank
//
//  Created by ZBN on 14-8-8.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTWorkShowVC.h"
#import "MTWork.h"

@interface MTWorkShowVC () <MTImageHandlerDelegate> {
    UIActivityIndicatorView *_iView;
    MTImageHandler *_imageHandler;
    NSInteger _currentIndex;
}
@property (weak, nonatomic) IBOutlet UIImageView *workImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likedLabel;

@end

@implementation MTWorkShowVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentIndex = self.index;
    [self updateWorkDisplay];

}

- (void)updateWorkDisplay
{
    MTWork *work = (MTWork *)[self.works objectAtIndex:self.index];
    
    self.nameLabel.text = work.name;
    self.likedLabel.text = work.liked;
    
    _iView = [[UIActivityIndicatorView alloc] init];
    _iView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_iView startAnimating];
    [self.workImageView addSubview:_iView];
    
    _imageHandler = [[MTImageHandler alloc] init];
    _imageHandler.delegate = self;
    [_imageHandler downloadImageForURL:work.URL];

}

- (void)didDownloadImage:(UIImage *)image forURL:(NSString *)URLString
{
    MTWork *work = self.works[_currentIndex];
    if ([URLString isEqualToString:work.URL]) {
        _imageHandler = nil;
        [_iView removeFromSuperview];
        _iView = nil;
        self.workImageView.image = [MTImageHandler resizeImageFromImage:image forFrame:self.workImageView.bounds];
    }
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
