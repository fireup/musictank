//
//  MTLeftViewController.m
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTLeftViewController.h"

@interface MTLeftViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation MTLeftViewController

- (IBAction)loginButtonTapped:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"LoginSegue" sender:sender];
}


#pragma mark - Table view Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *identifier = cell.reuseIdentifier;
    if ([identifier isEqualToString:@"LatestWorksCell"]) {
        UINavigationController *centerNavi = (UINavigationController *)self.mm_drawerController.centerViewController;
        [centerNavi popViewControllerAnimated:YES];
        UIViewController *VCB = [self.storyboard instantiateViewControllerWithIdentifier:@"VCB"];
        [centerNavi setViewControllers:@[VCB]];
        
        [self.mm_drawerController setCenterViewController:centerNavi withFullCloseAnimation:YES completion:nil];
    }
    return path;
}

#pragma mark - init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.loginButton.layer.borderColor = [[UIColor redColor] CGColor];
    self.loginButton.layer.borderWidth = 2.0;
    self.signupButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.signupButton.layer.borderWidth = 2.0;
    self.logoutButton.layer.borderColor = [[UIColor redColor] CGColor];
    self.logoutButton.layer.borderWidth = 2.0;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mm_drawerController.maximumLeftDrawerWidth = 230;
    
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([MTDataHandler sharedData].isLogin) {
        self.loginButton.hidden = YES;
        self.signupButton.hidden = YES;
        self.logoutButton.hidden = NO;
        self.nameLabel.hidden = NO;
        
    } else {
        self.loginButton.hidden = NO;
        self.signupButton.hidden = NO;
        self.logoutButton.hidden = YES;
        self.nameLabel.hidden = YES;
        
        self.avatarView.image = [MTImageHandler getDefaultAvatarForFrame:self.avatarView.bounds];
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.mm_drawerController.maximumLeftDrawerWidth = [UIScreen mainScreen].bounds.size.width;
//    [self.mm_drawerController closeDrawerAnimated:NO completion:nil];
    
}


@end
