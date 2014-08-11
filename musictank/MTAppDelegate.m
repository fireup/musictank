//
//  MTAppDelegate.m
//  musictank
//
//  Created by ZBN on 14-8-5.
//  Copyright (c) 2014年 fireup. All rights reserved.
//

#import "MTAppDelegate.h"
#import "MTLeftViewController.h"
#import "MTArtistHomeViewController.h"

@implementation MTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    UINavigationController *leftNavi = [st instantiateViewControllerWithIdentifier:@"LeftNavi"];
    UINavigationController *centerVC = [st instantiateViewControllerWithIdentifier:@"CenterNavi"];
    MMDrawerController *drawerVC = [[MMDrawerController alloc] initWithCenterViewController:centerVC leftDrawerViewController:leftNavi];
    
    drawerVC.shouldStretchDrawer = NO;
    drawerVC.maximumLeftDrawerWidth = 230;
    drawerVC.showsShadow = NO;
    [drawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningNavigationBar];

    
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    if (![MTDataHandler sharedData].isLogin) {
        UINavigationController *leftNavi = (UINavigationController *)drawerVC.leftDrawerViewController;
        if ([leftNavi.topViewController isKindOfClass:[MTLeftViewController class]]) {
            MTLeftViewController *lvc = (MTLeftViewController *)leftNavi.topViewController;
            [lvc performSelector:@selector(openLoginVC)];
        }
    } else {
//        if ([centerVC.topViewController isKindOfClass:[MTArtistHomeViewController class]]) {
//            MTArtistHomeViewController *homeVC = (MTArtistHomeViewController *)(centerVC.topViewController);
//            homeVC.artistID = [MTDataHandler sharedData].myArtistID;
//        }
    }
    
    self.window.rootViewController = drawerVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
