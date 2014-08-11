//
//  MTLeftViewController.m
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTLeftViewController.h"

@interface MTLeftViewController ()

@property (strong, nonatomic) MTArtist *artist;

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation MTLeftViewController

- (void)openLoginVC
{
    [self centerAreaChangeVCWithSegue:@"SegueToLoginVC"];
}

- (IBAction)loginButtonTapped:(UIButton *)sender
{
    [self openLoginVC];
}

- (IBAction)logoutButtonTapped:(UIButton *)sender
{
    UIActivityIndicatorView *iView = [[UIActivityIndicatorView alloc] initWithFrame:self.avatarView.bounds];
    iView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.avatarView addSubview:iView];
    [iView startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *para = @{@"session_id": [MTDataHandler sharedData].sessionID};
    [manager POST:LOGOUTURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [iView stopAnimating];
        [iView removeFromSuperview];
        [MTDataHandler sharedData].login = NO;
        [MTDataHandler sharedData].myArtistID = @"";
        [MTDataHandler sharedData].sessionID = @"";
        [self reloadUserInfo];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [iView stopAnimating];
        [iView removeFromSuperview];
        [MTDataHandler sharedData].login = NO;
        [MTDataHandler sharedData].myArtistID = @"";
        [MTDataHandler sharedData].sessionID = @"";
        [self reloadUserInfo];
    }];
    
}

- (void)centerAreaChangeVCWithSegue:(NSString *)segueIdentifier
{
    UINavigationController *centerNavi = (UINavigationController *)self.mm_drawerController.centerViewController;
    if (![centerNavi.topViewController isKindOfClass:[MTLatestSongsVC class]]) {
        [centerNavi popToRootViewControllerAnimated:YES];
    }
    MTLatestSongsVC *lsvc = centerNavi.viewControllers[0];

    [self.mm_drawerController setCenterViewController:centerNavi withFullCloseAnimation:YES completion:^(BOOL finished) {
        [lsvc performSegueWithIdentifier:segueIdentifier sender:lsvc];
    }];
}

#pragma mark - Table view Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *identifier = cell.reuseIdentifier;
    NSString *segueIdentifier;
    
    if ([identifier isEqualToString:@"LoginCell"]) {
        if (![MTDataHandler sharedData].isLogin) { return nil; }
        segueIdentifier = @"SegueToArtistHome";
        
    } else if ([identifier isEqualToString:@"LatestWorksCell"]) {
        segueIdentifier = @"SegueToLastestWorksVC";
        
    } else if ([identifier isEqualToString:@"ArtistsIntroCell"]) {
        segueIdentifier = @"SegueToArtistsIntroVC";
        
    } else if ([identifier isEqualToString:@"LatestNewsCell"]) {
        segueIdentifier = @"SegueToLatestNewsVC";
    
    } else if ([identifier isEqualToString:@"TopListCell"]) {
        segueIdentifier = @"SegueToTopListVC";
    }
    
    [self centerAreaChangeVCWithSegue:segueIdentifier];
    
    return path;
}

#pragma mark - init

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.loginButton.layer.borderColor = [[UIColor redColor] CGColor];
    self.loginButton.layer.borderWidth = 1.0;
    self.signupButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.signupButton.layer.borderWidth = 1.0;
    self.logoutButton.layer.borderColor = [[UIColor redColor] CGColor];
    self.logoutButton.layer.borderWidth = 1.0;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mm_drawerController.maximumLeftDrawerWidth = 230;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self reloadUserInfo];
    
}

- (void)reloadUserInfo
{
    if ([MTDataHandler sharedData].isLogin) {

        self.loginButton.hidden = YES;
        self.signupButton.hidden = YES;
        self.logoutButton.hidden = NO;
        self.nameLabel.hidden = NO;

        NSString *myArtistID = [MTDataHandler sharedData].myArtistID;
        if (myArtistID) {

            MTArtist *artist = (MTArtist *)(([MTDataHandler sharedData].artistData)[myArtistID]);
            NSLog(@"%@:%@", NSStringFromSelector(_cmd),artist );

            if (artist.avatarImage) {
                self.avatarView.image = [MTImageHandler getAvatarFromImage:artist.avatarImage forFrame:self.avatarView.bounds];
                NSLog(@"%@", NSStringFromSelector(_cmd) );

            } else {
                self.avatarView.image = [MTImageHandler getDefaultAvatarForFrame:self.avatarView.bounds];
                self.artist.artistID = myArtistID;
                self.artist.imageDelegate = self;
                [self.artist downloadProfile];
            }
        }
    } else {
        self.loginButton.hidden = NO;
        self.signupButton.hidden = NO;
        self.logoutButton.hidden = YES;
        self.nameLabel.hidden = YES;
        self.avatarView.image = [MTImageHandler getDefaultAvatarForFrame:self.avatarView.bounds];
    }
}

- (MTArtist *)artist
{
    if (!_artist) {
        _artist = [[MTArtist alloc] init];
    }
    return _artist;
}

#pragma mark - MTArtistImageDelegate

- (void)didDownloadAvatarImageForArtist:(NSString *)artistID
{
    if ([artistID isEqualToString:self.artist.artistID]) {
        ([MTDataHandler sharedData].artistData)[artistID] = self.artist;
        [self reloadUserInfo];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.mm_drawerController.maximumLeftDrawerWidth = [UIScreen mainScreen].bounds.size.width;
    
//    if ([sender isEqual:self.loginButton]) {
//        if ([segue.destinationViewController isKindOfClass:[MTLoginViewController class]]) {
//            MTLoginViewController *lvc = (MTLoginViewController *)segue.destinationViewController;
//            lvc.successBlock = ^{
//              NSLog(@"%@", NSStringFromSelector(_cmd) );
//            };
//        }
//    }
}


@end
