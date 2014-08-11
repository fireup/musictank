//
//  MTLoginViewController.m
//  musictank
//
//  Created by ZBN on 14-8-6.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTLoginViewController.h"

@interface MTLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation MTLoginViewController

- (IBAction)loginButtonTapped:(UIButton *)sender
{
//    NSString *username = self.username.text;
//    NSString *password = self.password.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSDictionary *para = @{@"mobile": @"13800138000",
                           @"password" : @"password"};
    
    [manager POST:LOGINURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            
            [MTDataHandler sharedData].login = YES;
            [MTDataHandler sharedData].sessionID = responseObject[@"session_id"];
            [MTDataHandler sharedData].myArtistID = responseObject[@"artist_id"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.presentingViewController dismissViewControllerAnimated:YES completion:self.successBlock];
            });
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



#pragma mark - init

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame = self.username.frame;
    frame.size.height = 60;
    self.username.frame = frame;
    self.username.layer.borderWidth = 0.5;
    self.username.layer.borderColor = [[UIColor redColor] CGColor];
    self.username.delegate = self;
    
    frame = self.password.frame;
    frame.size.height = 60;
    self.password.frame = frame;
    self.password.layer.borderWidth = 0.5;
    self.password.layer.borderColor = [[UIColor redColor] CGColor];
    self.password.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.username]) {
        if ([textField.text isEqualToString:NSLocalizedString(@"USERNAMEPLACEHOLDER",nil)]) {
            textField.text = @"";
        }
    } else if ([textField isEqual:self.password]) {
        if ([textField.text isEqualToString:NSLocalizedString(@"PASSWORDPLACEHOLDER",nil)]) {
            textField.text = @"";
        }
    }
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.username]) {
        if ([textField.text isEqualToString:@""]) {
            textField.text = NSLocalizedString(@"USERNAMEPLACEHOLDER",nil);
        }
    } else if ([textField isEqual:self.password]) {
        if ([textField.text isEqualToString:@""]) {
            textField.text = NSLocalizedString(@"PASSWORDPLACEHOLDER",nil);
        }
    }
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
