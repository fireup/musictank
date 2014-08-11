//
//  MTCustomSegue.m
//  musictank
//
//  Created by ZBN on 14-8-8.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTCustomSegue.h"

@implementation MTCustomSegue

-(void)perform {
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromLeft;
    transition.duration = 0.5;
    
    [sourceViewController.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
}

@end
