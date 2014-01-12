//
//  AppDelegate.m
//  iNeedTime
//
//  Created by BirdChiu on 2014/1/8.
//  Copyright (c) 2014年 BirdChiu. All rights reserved.
//

#import "AppDelegate.h"
#import "AVFoundation/AVFoundation.h"

@implementation AppDelegate
@synthesize interval = _interval;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _interval=30;
    isNeedCleanNotification=FALSE;
    NSError *err = nil;
    [[AVAudioSession sharedInstance]setCategory: AVAudioSessionCategoryPlayback error: &err];
    [[AVAudioSession sharedInstance]setActive: YES error: &err];
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(showCustomTimeWithNotification:) userInfo:nil repeats:YES];
        timer=[NSTimer timerWithTimeInterval:_interval target:self selector:@selector(showCustomTimeWithNotification:) userInfo:Nil repeats:YES];
        [timer fire];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        [[NSRunLoop currentRunLoop] run];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [timer invalidate];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - private method

- (void)showCustomTimeWithNotification:(NSTimer *)timer {
    if (isNeedCleanNotification) {
        [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    }

    localNotification = [[UILocalNotification alloc] init];
    
    /*
     NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
     NSLog(@"%@",timeZoneNames);
     */
    
    NSDate *fireDate=[NSDate date];
    
    localNotification.fireDate = fireDate;
    NSString *bodyString=[NSString stringWithFormat:@"Copenhagen: %@",[self convertDateToStrDate:fireDate timeZoneName:@"Europe/Copenhagen"]];
    localNotification.alertBody = bodyString;
    //[self convertDateToStrDate timeZoneName:@"Asia/Taipei"];
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    isNeedCleanNotification=TRUE;
}

-(NSString*)convertDateToStrDate:(NSDate *)date timeZoneName:(NSString*)timeZoneName
{
    NSTimeZone *timeZone=[[NSTimeZone alloc]initWithName:timeZoneName];
    [NSTimeZone setDefaultTimeZone:timeZone];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [formatter stringFromDate:date];
    return strDate;
}


@end
