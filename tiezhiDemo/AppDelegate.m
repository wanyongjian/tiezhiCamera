//
//  AppDelegate.m
//  tiezhiDemo
//
//  Created by wanyongjian on 2017/12/12.
//  Copyright © 2017年 wan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PasterImageController.h"
#import "CameraController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = [[ViewController alloc]init];
//    UINavigationController *con = [[UINavigationController alloc]initWithRootViewController:[[CameraController alloc]init]];
    self.window.rootViewController = [[CameraController alloc]init];
    [self.window makeKeyAndVisible];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        //无权限 做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"kindly reminder" message:@"Please allow APP to access your camera -> Settings -> privacy -> camera." delegate:self cancelButtonTitle:@"confirm" otherButtonTitles:nil, nil]; [alart show];
    } else {
        //调用相机的代码写在这里
    }
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
