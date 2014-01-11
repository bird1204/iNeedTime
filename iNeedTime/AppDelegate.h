//
//  AppDelegate.h
//  iNeedTime
//
//  Created by BirdChiu on 2014/1/8.
//  Copyright (c) 2014年 BirdChiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIBackgroundTaskIdentifier backgroundTask;
    UILocalNotification *localNotification;
    NSTimer *timer;
    BOOL isNeedCleanNotification;
}

@property (strong, nonatomic) UIWindow *window;

@end
