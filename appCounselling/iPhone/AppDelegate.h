//
//  AppDelegate.h
//  appCounselling
//
//  Created by MindCrew Technologies on 23/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <Sinch/Sinch.h>

#define formatServer @"MM/dd/yyyy HH:mm"
#define formatToShowWithTime @"dd/MM/yyyy HH:mm"
#define formatToShowWithoutTime @"dd/MM/yyyy"
#define colorHeader [UIColor colorWithRed:50/255.0f green:177/255.0f blue:160/255.0f alpha:1.0]
#define colorViewBg [UIColor colorWithRed:226/255.0f green:230/255.0f blue:220.0f/255.0f alpha:1.0]

@class ViewController;
@class MenuView;
@class CounsellorHomeViewController;
@class AgentHomeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, SINClientDelegate>
{
    BOOL isFromBackground;
    NSString *incresSession;
}

@property (strong, nonatomic) id<SINClient> client;

@property(nonatomic) CGFloat screenHeight;
@property(nonatomic) CGFloat screenWidth;

@property(nonatomic, retain) NSString *incresSession;

@property (strong, nonatomic) MenuView *viewMenuPanal;
@property (strong, nonatomic) ViewController *rootVC;
@property (strong, nonatomic) UINavigationController *navControl;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIView *aAnimationView;
@property (strong, nonatomic) UILabel *alodingLbl;
@property (strong, nonatomic) NSDictionary *dictProfile;

@property(nonatomic) BOOL isNetAvailable;
@property(nonatomic) BOOL isFromNotification;
@property (nonatomic, retain) Reachability *internetReach;

@property (nonatomic) NSInteger timeDuration;
@property (nonatomic) NSInteger timeInterval;

@property (strong, nonatomic) NSString *strServerTime;;
@property (strong, nonatomic) NSDate *dateServer;;

@property (strong, nonatomic) CounsellorHomeViewController *objCounsellorHomeVC;
@property (strong, nonatomic) AgentHomeViewController *objAgentVC;

@property (strong, nonatomic) NSString *strNotificationType;;

@property (strong, nonatomic) NSString *strServer;
@property (strong, nonatomic) NSString *strServer1;;
@property (strong, nonatomic) NSString *strServer2;;

@property (strong, nonatomic) NSString *strFirstname;;

@property (nonatomic) BOOL isServerswitched;
@property (nonatomic) BOOL timeIncressfalse;

@property (strong, nonatomic) NSString *strUKMainAgencyID;

- (void)addChargementLoader;
- (void)removeChargementLoader;
- (void)saveTokenID:(NSString *)strToken;

+(id)sharedInstance;

- (void)stopListeningOnActiveConnection;
- (void)updateCurrentTime;
- (void)switchServer;

@end

