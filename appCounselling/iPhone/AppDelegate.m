//
//  AppDelegate.m
//  appCounselling
//
//  Created by MindCrew Technologies on 23/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MenuView.h"
#import <Sinch/Sinch.h>

#import "CounsellorHomeViewController.h"
#import "AgentHomeViewController.h"

#import "LiveViewController.h"
#import "CounsellingViewController.h"
//#import "RescheduleViewController.h"
@import HockeySDK;

@interface AppDelegate ()<SINClientDelegate, SINCallClientDelegate, SINManagedPushDelegate>

    @property (nonatomic, readwrite, strong) id<SINManagedPush> push;
    
@end

@implementation AppDelegate

@synthesize navControl;
@synthesize screenWidth;
@synthesize screenHeight;
@synthesize dictProfile;

@synthesize viewMenuPanal;

@synthesize isNetAvailable;
@synthesize isFromNotification;

@synthesize timeDuration;
@synthesize timeInterval;

@synthesize strServerTime;
@synthesize dateServer;

@synthesize objCounsellorHomeVC;

@synthesize strNotificationType;

@synthesize strServer;
@synthesize strServer1;
@synthesize strServer2;

@synthesize strFirstname;

@synthesize isServerswitched;
@synthesize timeIncressfalse;

@synthesize strUKMainAgencyID;
@synthesize incresSession;

+(id)sharedInstance
{
    return [UIApplication sharedApplication].delegate;
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)switchServer
{
    if(self.strServer == self.strServer1)
    {
        self.strServer = self.strServer2;
    }
    else {
        self.strServer = self.strServer1;
    }
    isServerswitched = YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
[[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"56351ab937724a43827eae9b3b975647"];
    // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];

    incresSession = @"yes";

//    Development
    strUKMainAgencyID = @"055PSosBl8oHRfhPQggS6w==1511763198074";

//1.3 Developement
//    strServer = @"http://ec2-35-176-53-87.eu-west-2.compute.amazonaws.com:6001/api/service";
//    strServer1 = @"http://ec2-35-176-53-87.eu-west-2.compute.amazonaws.com:6001/api/service";
//    strServer2 = @"http://ec2-35-176-53-87.eu-west-2.compute.amazonaws.com:6002/api/service";

    //Live
    strServer = @"https://www.getcypherapp.com:6006/api/service";
    strServer1 = @"https://www.getcypherapp.com:6006/api/service";
    strServer2 = @"https://www.getcypherapp.com:6007/api/service";

    [self updateCurrentTime];

    isFromNotification = NO;
    isFromBackground = NO;
    strNotificationType = nil;
  
    timeDuration = 55;
    timeInterval = 5;
    
    //PUSH NOTIFICATION
    //if (self.dictProfile)
    {
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
    }

    //REACHAbility
    [self checkNetworkStatus];

    CGRect rectScreen  = [[UIScreen mainScreen] bounds];
    screenWidth = rectScreen.size.width;
    screenHeight = rectScreen.size.height;
    
    //LOADER
    _aAnimationView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _alodingLbl=[[UILabel alloc]initWithFrame:CGRectMake(120,250,200,40)];
    _alodingLbl.textAlignment = NSTextAlignmentCenter;
    [self prepareChargementLoader];

    //WINDOW
    self.window = [[UIWindow alloc] initWithFrame:rectScreen];
    
    _rootVC = [[ViewController alloc] init];
    _rootVC.view.backgroundColor = colorViewBg;
    
    navControl = [[UINavigationController alloc] initWithRootViewController:_rootVC];
    
    self.window.rootViewController = navControl;
    [self.window makeKeyAndVisible];
    [self setWindow:_window];
    
    //Change by Mahendra
    [self handleLocalNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]];
    [self requestUserNotificationPermission];
    
    //by mahi
//    [[NSNotificationCenter defaultCenter] addObserverForName:@"UserDidLoginNotification"
//                                                      object:nil
//                                                       queue:nil
//                                                  usingBlock:^(NSNotification *note) {
//                                                      [self initSinchClientWithUserId:note.userInfo[@"userId"]];
//                                                  }];
//
    self.push = [Sinch managedPushWithAPSEnvironment:SINAPSEnvironmentAutomatic];
    self.push.delegate = self;
    [self.push setDesiredPushTypeAutomatically];
    
    void (^onUserDidLogin)(NSString* ) = ^(NSString* userId) {
        [self.push registerUserNotificationSettings];
        [self initSinchClientWithUserId:userId];
    };
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"UserDidLoginNotification"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self initSinchClientWithUserId:note.userInfo[@"userId"]];
                                                  }];
    
    NSLog(@"FINISH LAUNCH");
    return YES;
}

#pragma mark - Push Notification

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler
{
    
    NSLog(@"userInfo = %@", userInfo);
    NSLog(@"didReceiveRemoteNotification");
    
    handler(UIBackgroundFetchResultNewData);
    
    [self.push application:application didReceiveRemoteNotification:userInfo];
    
    if(self.dictProfile==nil)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *Username = [userDefault objectForKey:@"Username"];
        
        if(Username==nil)
            return;
        
        NSString *Pin = [userDefault objectForKey:@"Pin"];
        NSString *counsellorid = [userDefault objectForKey:@"counsellorid"];
        NSString *type = [userDefault objectForKey:@"type"];
        NSString *profile_image = [userDefault objectForKey:@"profile_image"];
        NSString *email = [userDefault objectForKey:@"email"];
        
        //password
        //username
        NSArray *arrObjects = [NSArray arrayWithObjects:Username?Username:@"", Pin?Pin:@"", counsellorid?counsellorid:@"", type?type:@"", profile_image?profile_image:@"", email?email:@"", nil];
        NSArray *arrKeys = [NSArray arrayWithObjects:@"username", @"password", @"counsellorid", @"type", @"profile_image", @"email", nil];
        
        self.dictProfile = [[NSDictionary alloc] initWithObjects:arrObjects forKeys:arrKeys];
    }
    
    NSString *type = [[userInfo objectForKey:@"aps"] objectForKey:@"type"];
    if ([type isEqualToString:@"caution"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNOtificationReceived"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"caution" object:nil];
    }
    
    if (application.applicationState == UIApplicationStateActive)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNOtificationReceived"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushReceived" object:userInfo];
    }
    
    if (application.applicationState != UIApplicationStateActive)
    {
        isFromNotification = YES;
        NSString *strAlert = [[userInfo objectForKey:@"aps"] objectForKey:@"type"];
        
        //GENERAL PUSH NOTIFICATION
        
        if(objCounsellorHomeVC)
        {
            [self.navControl popToViewController:objCounsellorHomeVC animated:NO];
        }
        
        strNotificationType = strAlert;
        
        if ([strAlert isEqualToString:@"Minute"] || [strAlert isEqualToString:@"Counselling Start"] || [strAlert isEqualToString:@"counselling_chat"])
        {
            // Timer
            if(objCounsellorHomeVC)
            {
                [objCounsellorHomeVC.objLiveVC refreshlivePage];
            }
            else
            {
//                objCounsellorHomeVC = [[CounsellorHomeViewController alloc] init];
//                [self.navControl pushViewController:objCounsellorHomeVC animated:YES];
            }
        }
        else if ([strAlert isEqualToString:@"1Hour"] || [strAlert isEqualToString:@"24Hour"] || [strAlert isEqualToString:@"Appoinment Accepted"])
        {
            //Accepted : having issues
            if(objCounsellorHomeVC)
            {
                [objCounsellorHomeVC showThePage:@"Counselling"];
            }
            else
            {
//                objCounsellorHomeVC = [[CounsellorHomeViewController alloc] init];
//                [self.navControl pushViewController:objCounsellorHomeVC animated:YES];
//                [objCounsellorHomeVC showThePage:@"Counselling"];
            }
        }
        else if ([strAlert isEqualToString:@"New Appointment"])
        {
            
            if(objCounsellorHomeVC)
            {
                [objCounsellorHomeVC showThePage:@"Counselling"];
                [objCounsellorHomeVC.objCounsellingVC btnAcceptedPendingClicked:objCounsellorHomeVC.objCounsellingVC.btnPending];
            }
            else
            {
                //Pending
//                objCounsellorHomeVC = [[CounsellorHomeViewController alloc] init];
//                [self.navControl pushViewController:objCounsellorHomeVC animated:YES];
//                [objCounsellorHomeVC showThePage:@"Counselling"];
//                [objCounsellorHomeVC.objCounsellingVC btnAcceptedPendingClicked:objCounsellorHomeVC.objCounsellingVC.btnPending];
            }
        }
        else if ([strAlert isEqualToString:@"Time Suggestion"] || [strAlert isEqualToString:@"SameCounsellor NewAppoinment"])
        {
            NSDictionary *dictData = [[userInfo objectForKey:@"aps"] objectForKey:@"data"];
            NSNumber *numSameCouns = [dictData objectForKey:@"same_cnslr"];
            
            if(objCounsellorHomeVC)
            {
                if(numSameCouns.boolValue == YES){
                    [objCounsellorHomeVC showThePage:@"Reschedule"];
                    
                }
                else {
                    [objCounsellorHomeVC showThePage:@"Counselling"];
                }
            }
            else
            {
                //Reschedule
//                objCounsellorHomeVC = [[CounsellorHomeViewController alloc] init];
//                [self.navControl pushViewController:objCounsellorHomeVC animated:YES];
//                [objCounsellorHomeVC showThePage:@"Reschedule"];
            }
        }
    }
    else//ACTIVE STATE
    {
        strNotificationType = @"";
        isFromNotification = NO;
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Push Notification userInfo = %@", userInfo);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"Token"];
    NSLog(@"Error in registration. Error: %@", token);

    [self.push application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    [self saveTokenID:token];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
    
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), err);
}

#pragma mark - Reachability
- (void)checkNetworkStatus{
    _internetReach = [Reachability reachabilityForInternetConnection];
    [_internetReach startNotifier];
    [self updateInterfaceWithReachability: _internetReach];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
}

- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    [self updateInterfaceWithReachability: curReach];
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
            self.isNetAvailable=NO;
            break;
        }
            
        case ReachableViaWiFi:
        {
            self.isNetAvailable=YES;
            break;
        }
            
        case ReachableViaWWAN:
        {
            self.isNetAvailable=YES;
            NSLog(@"Intenet Type : %@", NSLocalizedString(@"Reachable WWAN", @""));
            break;
        }
    }
}

#pragma mark - Loader
-(void)addChargementLoader
{
    if(!self.aAnimationView.superview)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.window addSubview:self.aAnimationView];
        });
    }
}
-(void)prepareChargementLoader
{
    UIActivityIndicatorView	*progressInd;
    _aAnimationView.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.20];
    progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [progressInd hidesWhenStopped];
    //progressInd.frame = CGRectMake(440, 335, progressInd.frame.size.width, progressInd.frame.size.height);
    progressInd.center = CGPointMake(screenWidth/2.0, screenHeight/2.0);
    [progressInd startAnimating];
    progressInd.tag =10;
    
    _alodingLbl.text=@"Loading...";
    _alodingLbl.textAlignment=NSTextAlignmentLeft;
    _alodingLbl.font=[UIFont fontWithName:@"Helvetica" size:22.0];
    _alodingLbl.backgroundColor=[UIColor clearColor];
    _alodingLbl.textColor= [UIColor whiteColor];
    _alodingLbl.tag =11;
    [_aAnimationView addSubview:progressInd];
    _alodingLbl.frame = CGRectMake(150, 120, 250, 20);
}

-(void)removeChargementLoader
{
//    if(self.aAnimationView.superview)
//        [self.aAnimationView removeFromSuperview];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.aAnimationView.superview)
            [self.aAnimationView removeFromSuperview];
    });
    
//    if(self.aAnimationView.superview)
//        [self.aAnimationView removeFromSuperview];
}

#pragma mark - Application Life Cycle

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
    isFromBackground = YES;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    
    if(isFromBackground)
    {
        isFromBackground = NO;
        [self updateCurrentTime];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"comeFromBackground" object:nil];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    if(_client && _client.isStarted)
    {
        [_client terminate];
    }
    NSLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Change By Mahendra
#pragma mark - SINCH

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([notification sin_isSinchNotification]) {
        [self.client relayLocalNotification:notification];
    }else
    {
    [self handleLocalNotification:notification];
    }
}

- (void)requestUserNotificationPermission {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)initSinchClientWithUserId:(NSString *)userId
{
    if(_client)
    {
        _client.delegate = nil;
        [_client stopListeningOnActiveConnection];
        [_client stop];
        _client = nil;
    }

    if (!_client)
    {
        _client = [Sinch clientWithApplicationKey:@"3596f6bc-11c9-4a68-8e4e-cba4e25fc8d3"
                                applicationSecret:@"/wbSHBIMKEGEkHpxlK0lZQ=="
                                  environmentHost:@"clientapi.sinch.com"
                                           userId:userId];
        
//        _client = [Sinch clientWithApplicationKey:@"819017e7-6e44-45a4-b748-91970d0dafd1"
//                                applicationSecret:@"s/MtbSpB0UKyUZ4qoSmOBA=="
//                                  environmentHost:@"clientapi.sinch.com"
//                                           userId:userId];
        
       // _client.delegate = self;
        
        [_client setSupportCalling:YES];
        
        [_client start];
        [_client startListeningOnActiveConnection];
    }
    NSLog(@"_client = %@", [_client description]);
}

    - (void)handleRemoteNotification:(NSDictionary *)userInfo {
        if (!_client) {
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
            if (userId) {
                [self initSinchClientWithUserId:userId];
            }
        }
        
        id<SINNotificationResult> result = [self.client relayRemotePushNotification:userInfo];
        
        if ([result isCall] && [[result callResult] isCallCanceled]) {
            [self presentMissedCallNotificationWithRemoteUserId:[[result callResult] remoteUserId]];
        }
    }
    
- (void)handleLocalNotification:(UILocalNotification *)notification {
   
    if (notification) {
        id<SINNotificationResult> result = [self.client relayLocalNotification:notification];
        if ([result isCall] && [[result callResult] isTimedOut]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Missed call"
                                  message:[NSString stringWithFormat:@"Missed call from %@", [[result callResult] remoteUserId]]
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}

- (void)stopListeningOnActiveConnection
{
    [_client stopListeningOnActiveConnection];
}

#pragma mark - SINClientDelegate

- (void)clientDidStart:(id<SINClient>)client {
    NSLog(@"Sinch client started successfully (version: %@)", [Sinch version]);
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error {
    NSLog(@"Sinch client error: %@", [error localizedDescription]);
}

- (void)client:(id<SINClient>)client
    logMessage:(NSString *)message
          area:(NSString *)area
      severity:(SINLogSeverity)severity
     timestamp:(NSDate *)timestamp {
    if (severity == SINLogSeverityCritical) {
        NSLog(@"%@", message);
    }
}

#pragma mark - Parsers 

- (void)updateCurrentTime
{
    //        {
    //            "requestData":{
    //                "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //                "requestType":"currentTime"
    //            }
    //        }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"currentTime", nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    [appCounsellingLoginParser sharedManager].strMethod = @"currentTime";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        self.strServerTime = [responseDict objectForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        
        self.dateServer = [dateFormatter dateFromString:self.strServerTime];
        NSLog(@"strServerTime = %@, dateServer = %@", self.strServerTime, self.dateServer);
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.isServerswitched == NO){
                [self switchServer];
                [self updateCurrentTime];
            }
            else {
                [self removeChargementLoader];
            }
        });
    }];
    
}

- (void)saveTokenID:(NSString *)strToken
{
    NSLog(@"saveTokenID = %@", strToken);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:strToken forKey:@"Token"];
    
    if(dictProfile==nil)
        return;
    
    //{
    //    "requestData": {
    //        "apikey": "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //        "requestType": "updateUserToken",
    //        "data":{
    //            "devicetoken": "d8e6cd38674034be4f440bfc6031c0fbf34eb1a7745dd2a627e33e2f5b6a5a25",
    //            "deviceType": "ios",
    //            "counsellorid": "7Z9lhu4fCsxaPovP0rW64UxKxAMsG45ank1NB0g7rt4="
    //        }
    //    }
    //}
    
    
    //apikey, requestType, devicetoken, deviceType, counsellorid
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *dictdata = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: strToken, @"ios", [dictProfile objectForKey:@"username"], nil] forKeys:[NSArray arrayWithObjects:@"devicetoken", @"deviceType", @"counsellorid", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"updateUserToken", dictdata, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    [appCounsellingLoginParser sharedManager].strMethod = @"updateUserToken";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.isServerswitched == NO){
                [self switchServer];
                [self saveTokenID:strToken];
            }
        });
    }];
}
#pragma mark - SINManagedPushDelegate
    
- (void)managedPush:(id<SINManagedPush>)unused
didReceiveIncomingPushWithPayload:(NSDictionary *)payload
            forType:(NSString *)pushType {
    [self handleRemoteNotification:payload];
}
    
#pragma mark - SINCallClientDelegate
    
- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
    // Find MainViewController and present CallViewController from it.
    UIViewController *top = self.window.rootViewController;
    while (top.presentedViewController) {
        top = top.presentedViewController;
    }
    [top performSegueWithIdentifier:@"callView" sender:call];
}
    
- (SINLocalNotification *)client:(id<SINClient>)client localNotificationForIncomingCall:(id<SINCall>)call {
    SINLocalNotification *notification = [[SINLocalNotification alloc] init];
    notification.alertAction = @"Answer";
    notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", [call remoteUserId]];
    return notification;
}
    
#pragma mark - SINClientDelegate
    
    
- (void)presentMissedCallNotificationWithRemoteUserId:(NSString *)remoteUserId {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application applicationState] == UIApplicationStateBackground) {
        UILocalNotification *note = [[UILocalNotification alloc] init];
        note.alertBody = [NSString stringWithFormat:@"Missed call from %@", remoteUserId];
        note.alertTitle = @"Missed call";
        [application presentLocalNotificationNow:note];
    }
}
@end
