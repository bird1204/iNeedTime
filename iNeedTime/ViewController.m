//
//  ViewController.m
//  iNeedTime
//
//  Created by BirdChiu on 2014/1/8.
//  Copyright (c) 2014年 BirdChiu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
     [self setupLocalNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    /*
    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
    NSLog(@"%@",timeZoneNames);
    */
    
    // current time plus 10 secs
    NSDate *now = [NSDate date];
    NSDate *dateToFire = [now dateByAddingTimeInterval:0];
    [self convertDateToStrDate:now timeZoneName:@"Europe/Copenhagen"];
    //[self convertDateToStrDate timeZoneName:@"Asia/Taipei"];
    
    //NSLog(@"now time: %@", [self convertDateToDate:now timeZoneName:@"Asia/Taipei"]);
    
    
    localNotification.fireDate = dateToFire;
    localNotification.alertBody = [self convertDateToStrDate:now timeZoneName:@"Europe/Copenhagen"];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1; // increment
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Object 1", @"Key 1", @"Object 2", @"Key 2", nil];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(NSString*)convertDateToStrDate:(NSDate *)date timeZoneName:(NSString*)timeZoneName
{

    NSTimeZone *timeZone=[[NSTimeZone alloc]initWithName:timeZoneName];
    [NSTimeZone setDefaultTimeZone:timeZone];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [formatter stringFromDate:date];
    NSLog(@"%@",strDate);
    return strDate;
}

@end
