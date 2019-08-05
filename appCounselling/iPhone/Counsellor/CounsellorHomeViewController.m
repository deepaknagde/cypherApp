//
//  CounsellorHomeViewController.m
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "CounsellorHomeViewController.h"
#import "HDNotificationView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LiveViewController.h"
#import "CalendarViewController.h"
#import "CounsellingViewController.h"
#import "RescheduleViewController.h"
#import "AppCounselllingLiveChatViewController.h"
#import "CounsellorAppointmentViewController.h"
#import "appCounsellingLoginParser.h"
#import "AssessmentForm_VC.h"

@interface CounsellorHomeViewController ()
    {
        NSMutableArray *employeeInfoArray;
        NSString *filePath;
    }
    
    @end

@implementation CounsellorHomeViewController
    
    @synthesize objLiveVC;
    @synthesize objRescheduleVC;
    @synthesize objCounsellingVC;
    @synthesize objCalendarVC;
    
    @synthesize strTag;
    
- (void)clearMemory
    {
        appDelegate.viewMenuPanal.delegate = nil;
        appDelegate.viewMenuPanal = nil;
        
        btnRefresh = nil;
        dictInfo = nil;
        
        objLiveVC = nil;
        objRescheduleVC = nil;
        objCounsellingVC = nil;
        objCalendarVC = nil;
        objOldAppointmentVC = nil;
        
        objLiveVC = nil;
        objRescheduleVC = nil;
        objCounsellingVC = nil;
        objCalendarVC = nil;
        objOldAppointmentVC = nil;
    }
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"--Home screen--");
}
    
-(void)Show_Ass_VC:(NSArray *)Loac_Array {
    
    NSLog(@"-- Loac_Array --%@", Loac_Array);
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"VideoCall" bundle:nil];
    
    AssessmentForm_VC *screen = [sb instantiateViewControllerWithIdentifier:@"AssessmentForm_VC"];
    
    screen.JsonArr = [[NSMutableArray alloc] initWithArray:Loac_Array];
    [self.navigationController pushViewController:screen animated:YES];
}
    
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    [self designTopBar];
    [self showMenuButton];
    
    [self designMenu];
    
    self.view.backgroundColor = colorViewBg;
    
    [self showThePage:@"Live"];
    
    btnRefresh = [[UIButton alloc] init];
    btnRefresh.backgroundColor = [UIColor clearColor];
    btnRefresh.frame = CGRectMake(appDelegate.screenWidth-50, 20, 44, 44);
    [btnRefresh addTarget:self action:@selector(refreshLiveClicked) forControlEvents:UIControlEventTouchUpInside];
    //    [btnHideMenu setTitle:@"=" forState:UIControlStateNormal];
    [btnRefresh setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btnRefresh" ofType:@"png"]] forState:UIControlStateNormal];
    [self.view addSubview:btnRefresh];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *strToken = [userDefault objectForKey:@"Token"];
    NSLog(@"strToken = = %@", strToken);
    if(strToken!=nil)
    {
        [appDelegate saveTokenID:strToken];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushReceived:) name:@"pushReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationTouched) name:@"LocalNotificationTouched" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutNotificationCenter) name:@"logoutCenter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAcceptNotificationCenter) name:@"requestAccept" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTimer) name:@"refreshLive" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLiveClicked) name:@"refreshLivepavan" object:nil];
    
    
    
    NSString *strCounsellorID = [appDelegate.dictProfile objectForKey:@"username"];
    if(strCounsellorID)
    {
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedIn" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginNotification"
                                                            object:nil
                                                          userInfo:@{
                                                                     @"userId" : strCounsellorID
                                                                     }];
    }
    [self notificationAction];
}
    
- (void)notificationAction
    {
        if(appDelegate.isFromNotification)
        {
            appDelegate.isFromNotification = NO;
            NSString *strAlert = appDelegate.strNotificationType;
            if ([strAlert isEqualToString:@"1Hour"] || [strAlert isEqualToString:@"24Hour"] || [strAlert isEqualToString:@"Appoinment Accepted"])
            {
                [appDelegate.objCounsellorHomeVC showThePage:@"Counselling"];
            }
            else if ([strAlert isEqualToString:@"New Appointment"])
            {
                [appDelegate.objCounsellorHomeVC showThePage:@"Counselling"];
                [appDelegate.objCounsellorHomeVC.objCounsellingVC btnAcceptedPendingClicked:appDelegate.objCounsellorHomeVC.objCounsellingVC.btnPending];
            }
            else if ([strAlert isEqualToString:@"Time Suggestion"] || [strAlert isEqualToString:@"SameCounsellor NewAppoinment"])
            {
                [appDelegate.objCounsellorHomeVC showThePage:@"Reschedule"];
            }
        }
    }
    
- (void)refreshTimer
    {
        if([self.lblTitle.text isEqualToString:@"Live"])
        {
            [appDelegate.navControl popToViewController:self animated:NO];
            [self showThePage:@"Live"];
        }
    }
    
- (void)requestAcceptNotificationCenter
    {
        [self showThePage:@"Counselling"];
        [self.objCounsellingVC btnAcceptedPendingClicked:self.objCounsellingVC.btnAccepted];
    }
    
- (void)userLogoutNotificationCenter
    {
        appDelegate.dictProfile = nil;
        
    }
    
- (void)refreshLiveClicked
    {
        if(objLiveVC != nil && objLiveVC.view.superview)
        [objLiveVC refreshlivePage];
        
        
        
        
        //    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"VideoCall" bundle:nil];
        //
        //    AssessmentForm_VC *screen = [sb instantiateViewControllerWithIdentifier:@"AssessmentForm_VC"];
        //
        //    screen.JsonArr = [[NSMutableArray alloc] initWithArray:[[NSArray alloc] init]];
        //
        //    [self.navigationController pushViewController:screen animated:YES];
        
        
        // [self TestAPI];
    }
    
- (void)viewDidAppear:(BOOL)animated
    {
        [super viewDidAppear:animated];
        if(objLiveVC)
        [objLiveVC viewDidAppear:animated];
        if(objRescheduleVC)
        [objRescheduleVC viewDidAppear:animated];
        if(objCounsellingVC)
        [objCounsellingVC viewDidAppear:animated];
        if(objOldAppointmentVC)
        [objOldAppointmentVC viewDidAppear:animated];
    }
    
#pragma mark - MENE
- (void)designMenu
    {
        if(appDelegate.viewMenuPanal==nil)
        {
            appDelegate.viewMenuPanal = [[MenuView alloc] init];
            appDelegate.viewMenuPanal.delegate = self;
            appDelegate.viewMenuPanal.frame = CGRectMake(-appDelegate.screenWidth, 0, appDelegate.screenWidth, appDelegate.screenHeight);
            //        appDelegate.viewMenuPanal.tblMenuPanal.backgroundColor = colorHeader;
            //        if(appDelegate.dictProfile==nil)
            //            [appDelegate.viewMenuPanal callwebServiceForProfileDetails];
            //        else
            //            [appDelegate.viewMenuPanal setProfileParameter];
            
            appDelegate.viewMenuPanal.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
            [self.view addSubview:appDelegate.viewMenuPanal];
            
            UIButton *btnHideMenu = [[UIButton alloc] init];
            btnHideMenu.backgroundColor = [UIColor clearColor];
            btnHideMenu.frame = CGRectMake(190, 20, 44, 44);
            [btnHideMenu addTarget:self action:@selector(hideMenuPanal) forControlEvents:UIControlEventTouchUpInside];
            //    [btnHideMenu setTitle:@"=" forState:UIControlStateNormal];
            [btnHideMenu setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btnMenu" ofType:@"png"]] forState:UIControlStateNormal];
            [appDelegate.viewMenuPanal addSubview:btnHideMenu];
        }
    }
    
- (void)showMenuPanal
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationRepeatCount:0];
        
        [appDelegate.viewMenuPanal removeFromSuperview];
        [self.view addSubview:appDelegate.viewMenuPanal];
        
        appDelegate.viewMenuPanal.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        
        [UIView commitAnimations];
    }
    
- (void)hideMenuPanal
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationRepeatCount:0];
        
        if(appDelegate.viewMenuPanal.frame.origin.x == 0)
        {
            appDelegate.viewMenuPanal.frame = CGRectMake(-appDelegate.screenWidth, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        }
        
        [UIView commitAnimations];
    }
    
- (void)btnMenuClicked
    {
        //    if(self.navigationController)
        //        [appDelegate.navControl popViewControllerAnimated:YES];
        //    else
        //        [self dismissViewControllerAnimated:YES completion:nil];
        [self showMenuPanal];
        
    }
    
#pragma mark - Menu Delegate
    
- (void)showThePage:(NSString *)strPageName
    {
        if([strPageName isEqualToString:@"Delete me"])
        {
            [self hideMenuPanal];

            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"Do you want to Delete ?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self DeleteMeAPI];
                                                                  }];
            UIAlertAction* defaultCancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                  }];
            
            [alert addAction:defaultAction];
            [alert addAction:defaultCancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else
        {
            self.lblTitle.text = strPageName;
            //    [appDelegate.viewMenuPanal removeFromSuperview];
            //    if(![strPageName isEqualToString:@"Logout"])
            //        [self.view addSubview:appDelegate.viewMenuPanal];
            
            btnRefresh.hidden = YES;
            
            if(objLiveVC!=nil)
            [objLiveVC.view removeFromSuperview];
            if(objCalendarVC!=nil)
            [objCalendarVC.view removeFromSuperview];
            if(objCounsellingVC!=nil)
            [objCounsellingVC.view removeFromSuperview];
            if(objRescheduleVC!=nil)
            [objRescheduleVC.view removeFromSuperview];
            if(objOldAppointmentVC!=nil)
            [objOldAppointmentVC.view removeFromSuperview];
            
            if([strPageName isEqualToString:@"Live"])
            {
                [self hideMenuPanal];
                
                btnRefresh.hidden = NO;
                if(objLiveVC==nil)
                {
                    objLiveVC = [[LiveViewController alloc] init];
                }
                else
                {
                    if(objLiveVC.view.superview)
                    {
                        [objLiveVC.view removeFromSuperview];
                    }
                    objLiveVC = nil;
                    
                    objLiveVC = [[LiveViewController alloc] init];
                }
                //    [objLiveVC refreshlivePage];
                
                objLiveVC.view.frame = CGRectMake(0, 64, appDelegate.screenWidth, appDelegate.screenHeight-64);
                objLiveVC.lblTitle.text = strPageName;
                [self.view addSubview:objLiveVC.view];
                //[appDelegate.navControl pushViewController:objLiveVC animated:YES];
            }
            else if([strPageName isEqualToString:@"Calendar"])
            {
                [self hideMenuPanal];
                
                if(objCalendarVC==nil)
                objCalendarVC = [[CalendarViewController alloc] init];
                else
                {
                    if(objCalendarVC.view.superview)
                    {
                        [objCalendarVC.view removeFromSuperview];
                    }
                    objCalendarVC = nil;
                    
                    objCalendarVC = [[CalendarViewController alloc] init];
                }
                //        else
                //            [objCalendarVC setTodayDateToCalender];
                
                objCalendarVC.view.frame = CGRectMake(0, 64, appDelegate.screenWidth, appDelegate.screenHeight-64);
                objCalendarVC.lblTitle.text = strPageName;
                [self.view addSubview:objCalendarVC.view];
                //        [appDelegate.navControl pushViewController:objCalendarVC animated:YES];
            }
            else if([strPageName isEqualToString:@"Counselling"])
            {
                [self hideMenuPanal];
                
                if(objCounsellingVC==nil)
                objCounsellingVC = [[CounsellingViewController alloc] init];
                objCounsellingVC.view.frame = CGRectMake(0, 64, appDelegate.screenWidth, appDelegate.screenHeight-64);
                objCounsellingVC.lblTitle.text = strPageName;
                [self.view addSubview:objCounsellingVC.view];
            }
            else if([strPageName isEqualToString:@"Reschedule"])
            {
                [self hideMenuPanal];
                
                if(objRescheduleVC==nil)
                objRescheduleVC = [[RescheduleViewController alloc] init];
                objRescheduleVC.view.frame = CGRectMake(0, 64, appDelegate.screenWidth, appDelegate.screenHeight-64);
                objRescheduleVC.lblTitle.text = strPageName;
                [self.view addSubview:objRescheduleVC.view];
            }
            else if([strPageName isEqualToString:@"Previous Appointment"])
            {
                [self hideMenuPanal];
                
                if(objOldAppointmentVC==nil)
                objOldAppointmentVC = [[CounsellorAppointmentViewController alloc] init];
                objOldAppointmentVC.view.frame = CGRectMake(0, 64, appDelegate.screenWidth, appDelegate.screenHeight-64);
                objOldAppointmentVC.lblTitle.text = strPageName;
                [self.view addSubview:objOldAppointmentVC.view];
            }
            else if([strPageName isEqualToString:@"Download data"])
            {
                [appDelegate addChargementLoader];
                [self Download_my_dataAPI];
                
            }
            
            else if([strPageName isEqualToString:@"Logout"])
            {
                appDelegate.dictProfile = nil;
                NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
                [defaultUser removeObjectForKey:@"Username"];
                [defaultUser removeObjectForKey:@"Pin"];
                
                [defaultUser removeObjectForKey:@"counsellorid"];
                [defaultUser removeObjectForKey:@"type"];
                [defaultUser removeObjectForKey:@"profile_image"];
                [defaultUser removeObjectForKey:@"email"];
                
                [self clearMemory];
                
                [appDelegate.viewMenuPanal removeFromSuperview];
                [appDelegate.navControl popToRootViewControllerAnimated:YES];
            }
        }
    }
    
    - (void)TestDemo:(NSString *)strpageName {
        NSLog(@"--Test my funcation--");
        [self hideMenuPanal];
        
        [appDelegate addChargementLoader];
        
        [self Download_my_dataAPI];
        
    }
    -(void)DeleteMeAPI {
        [appDelegate addChargementLoader];
        
        NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: [appDelegate.dictProfile objectForKey:@"username"] , nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01",nil]];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"deleteMeCounselor", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
        
        [dictParameter setValue:parameters forKey:@"requestData"];
        
        NSLog(@"strClcnslrun01=%@", dictParameter);
        
        [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate removeChargementLoader];
                
                appDelegate.dictProfile = nil;
                NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
                [defaultUser removeObjectForKey:@"Username"];
                [defaultUser removeObjectForKey:@"Pin"];
                
                [defaultUser removeObjectForKey:@"counsellorid"];
                [defaultUser removeObjectForKey:@"type"];
                [defaultUser removeObjectForKey:@"profile_image"];
                [defaultUser removeObjectForKey:@"email"];
                
                [self clearMemory];
                
                [appDelegate.viewMenuPanal removeFromSuperview];
                [appDelegate.navControl popToRootViewControllerAnimated:YES];
                
                NSLog(@" ---True ---");
            });
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(appDelegate.isServerswitched == NO){
                    [appDelegate switchServer];
                    //                [self getData];
                }
                else {
                    [appDelegate removeChargementLoader];
                }
            });
        }];
    }
    
    //MARK:- DOWNLOAD DATA
    -(void)Download_my_dataAPI {
        NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: [appDelegate.dictProfile objectForKey:@"username"] , nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01",nil]];
        
        //[appDelegate.dictProfile objectForKey:@"username"]
        //uoznUrlJ6eHJJnOZ26HD3A==
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"downloadCounsellorData", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
        
        [dictParameter setValue:parameters forKey:@"requestData"];
        

        NSLog(@"strClcnslrun01=%@", dictParameter);
        
        [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate removeChargementLoader];
                
                NSLog(@"strClcnslrun01=%@", responseDict);
                ////CSV File =====
                
                employeeInfoArray  = [[NSMutableArray alloc] init];
                
                NSMutableArray *Getdata = [[NSMutableArray alloc] initWithArray:[responseDict objectForKey:@"appointments"]];
                
                if(Getdata != nil && Getdata.count>0)
                {
                    for (int i = 0;i<Getdata.count ;i++)
                    {
                        
                        NSMutableDictionary *RDaic = [[NSMutableDictionary alloc] initWithDictionary:[Getdata objectAtIndex:i]];
                        
                        NSString *clun01 = @"";
                        if ([self containsKey:@"clun01" dict:RDaic] &&
                            [RDaic valueForKey:@"clun01"] != nil &&
                            [RDaic valueForKey:@"clun01"] != [NSNull null]) {
                            
                                NSString*clun01_ENC = [NSString stringWithFormat:@"%@", [RDaic valueForKey:@"clun01"]];
                                
                                if ([clun01_ENC length] > 0) {
                                
                                    clun01 = [self getDycryptString:clun01_ENC];
                                    NSLog(@"%@", clun01);
                                }
                        }
                        
                        NSString *apntmnt_date = @"";
                        if ([self containsKey:@"apntmnt_date" dict:RDaic] &&
                            [RDaic valueForKey:@"apntmnt_date"] != nil &&
                            [RDaic valueForKey:@"apntmnt_date"] != [NSNull null]) {
                            
                            apntmnt_date = [NSString stringWithFormat:@"%@", [RDaic valueForKey:@"apntmnt_date"]];
                        }

                        NSString *appointment_day = @"";
                        if ([self containsKey:@"appointment_day" dict:RDaic] &&
                            [RDaic valueForKey:@"appointment_day"] != nil &&
                            [RDaic valueForKey:@"appointment_day"] != [NSNull null]) {
                            
                            appointment_day = [RDaic objectForKey:@"appointment_day"];
                        }

                        
                        NSString *clcnslrun01 = @"";
                        if ([self containsKey:@"clcnslrun01" dict:RDaic] &&
                            [RDaic valueForKey:@"clcnslrun01"] != nil &&
                            [RDaic valueForKey:@"clcnslrun01"] != [NSNull null]) {

                            NSString*clcnslrun01_ENC = [NSString stringWithFormat:@"%@", [RDaic valueForKey:@"clcnslrun01"]];

                            if ([clcnslrun01_ENC length] > 0) {

                                clcnslrun01 = [self getDycryptString:clcnslrun01_ENC];
                            }
                        }

                        NSString *cnslr_ratting_status = @"";
                        if ([self containsKey:@"cnslr_ratting_status" dict:RDaic] &&
                            [RDaic valueForKey:@"cnslr_ratting_status"] != nil &&
                            [RDaic valueForKey:@"cnslr_ratting_status"] != [NSNull null]) {
                            
                            cnslr_ratting_status = [RDaic objectForKey:@"cnslr_ratting_status"];
                        }
                        
                        NSString *lat = @"";
                        if ([self containsKey:@"lat" dict:RDaic] &&
                            [RDaic valueForKey:@"lat"] != nil &&
                            [RDaic valueForKey:@"lat"] != [NSNull null]) {
                            
                            lat =  [NSString stringWithFormat:@"%.04f", [[RDaic valueForKey:@"lat"] floatValue]];
                        }

                        NSString *phone_number = @"";
                        if ([self containsKey:@"phone_number" dict:RDaic] &&
                            [RDaic valueForKey:@"phone_number"] != nil &&
                            [RDaic valueForKey:@"phone_number"] != [NSNull null]) {
                            
                            phone_number = [NSString stringWithFormat:@"%@", [RDaic valueForKey:@"phone_number"]];
                        }

                        NSString *user_firstname = @"";
                        if ([self containsKey:@"user_firstname" dict:RDaic] &&
                            [RDaic valueForKey:@"user_firstname"] != nil &&
                            [RDaic valueForKey:@"user_firstname"] != [NSNull null]) {
                            
                            NSString*user_firstname_ENC = [NSString stringWithFormat:@"%@", [RDaic valueForKey:@"user_firstname"]];
                            
                            if ([user_firstname_ENC length] > 0) {
                                
                                user_firstname = [self getDycryptString:user_firstname_ENC];
                            }
                        }
                        
                        NSString *cnsrl1_assign_time = @"";
                        if ([self containsKey:@"cnsrl1_assign_time" dict:RDaic] &&
                            [RDaic valueForKey:@"cnsrl1_assign_time"] != nil &&
                            [RDaic valueForKey:@"cnsrl1_assign_time"] != [NSNull null]) {
                            
                            cnsrl1_assign_time = [RDaic objectForKey:@"cnsrl1_assign_time"];
                        }
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setValue:[NSString stringWithFormat:@"%@",clun01] forKey:@"clun01"];
                        [dict setValue:[NSString stringWithFormat:@"%@",apntmnt_date] forKey:@"apntmnt_date"];
                        [dict setValue:[NSString stringWithFormat:@"%@",appointment_day] forKey:@"appointment_day"];
                        [dict setValue:[NSString stringWithFormat:@"%@",clcnslrun01] forKey:@"clcnslrun01"];
                        [dict setValue:[NSString stringWithFormat:@"%@",cnslr_ratting_status] forKey:@"cnslr_ratting_status"];
                        [dict setValue:[NSString stringWithFormat:@"%@",@""] forKey:@"counsellor_firstname"];
                        [dict setValue:[NSString stringWithFormat:@"%@",@""] forKey:@"lat"];
                        [dict setValue:[NSString stringWithFormat:@"%@",@""] forKey:@"lng"];
                        [dict setValue:[NSString stringWithFormat:@"%@",phone_number] forKey:@"phone_number"];
                        [dict setValue:[NSString stringWithFormat:@"%@",user_firstname] forKey:@"user_firstname"];
                        [dict setValue:[NSString stringWithFormat:@"%@",cnsrl1_assign_time] forKey:@"cnsrl1_assign_time"];
                        
                        [employeeInfoArray addObject:dict];
                    }
                    
                    [self createCSV];
                }else
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                                   message:@"No data Found."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultCancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {
                                                                          }];
                    
                    [alert addAction:defaultCancel];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
            });
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(appDelegate.isServerswitched == NO){
                    [appDelegate switchServer];
                    //                [self getData];
                }
                else {
                    [appDelegate removeChargementLoader];
                }
            });
        }];
    }

- (BOOL)containsKey: (NSString *)key dict:(NSMutableDictionary *)dict {
    BOOL retVal = 0;
    NSArray *allKeys = [dict allKeys];
    retVal = [allKeys containsObject:key];
    return retVal;
}

    -(void)createCSV
    {
        
        NSMutableString *csvString = [[NSMutableString alloc]initWithCapacity:0];
        [csvString appendString:@"User Name, Appointment Date, Appointment Day,Counsellor Name,Counsellor Ratting Status,Phone Number,User First Name,Counsellor Assign Time,n/a,n/a,n/a\n\n\n\n\n\n\n\n\n\n\n"];
        
        for (NSDictionary *dct in employeeInfoArray)
        {
            [csvString appendString:[NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@\n",[dct valueForKey:@"clun01"],[dct valueForKey:@"apntmnt_date"],[dct valueForKey:@"appointment_day"],[dct valueForKey:@"clcnslrun01"],[dct valueForKey:@"cnslr_ratting_status"],[dct valueForKey:@"phone_number"],[dct valueForKey:@"user_firstname"],[dct valueForKey:@"cnsrl1_assign_time"],[dct valueForKey:@"lat"],[dct valueForKey:@"lng"],[dct valueForKey:@"counsellor_firstname"]]];
        }
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"GDPRRecords.csv"];
        [csvString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        
        [[NSUserDefaults standardUserDefaults]setObject:filePath forKey:@"filePath"];
        [self hideMenuPanal];
        
        NSString * storyboardName = @"VideoCall";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"DownlodedataViewController"];

        [self presentViewController:vc animated:YES completion:nil];
    }
    
    
#pragma mark - PUSH NOTIFICATION
- (void)pushReceived:(NSNotification *) notification
    {
        if ([notification.object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictTemp = (NSMutableDictionary *)[[notification object] objectForKey:@"aps"];
            dictInfo = [[NSMutableDictionary alloc] initWithDictionary:dictTemp];
            
            NSString *strAction = [dictInfo objectForKey:@"alert"];
            NSString *strAlert = [[notification object] objectForKey:@"type"];
            [dictInfo setObject:strAlert forKey:@"type"];
            
            if ([strAlert isEqualToString:@"Minute"] || [strAlert isEqualToString:@"Counselling Start"])
            {
                // Timer
            }
            else if ([strAlert isEqualToString:@"1Hour"] || [strAlert isEqualToString:@"24Hour"] || [strAlert isEqualToString:@"Appoinment Accepted"])
            {
                //Accepted
            }
            else if ([strAlert isEqualToString:@"New Appointment"])
            {
                //Pending
            }
            else if ([strAlert isEqualToString:@"Time Suggestion"] || [strAlert isEqualToString:@"SameCounsellor NewAppoinment"])
            {
                //Reschedule
            }
            
            
            if([strAlert isEqualToString:@"counselling_chat"] == YES){
                
                if (![self.navigationController.topViewController isKindOfClass:[AppCounselllingLiveChatViewController class]]) {
                    
                    AudioServicesPlaySystemSound(1007);
                    [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"180.png"] title:@"appCounselling" message:strAction isAutoHide:YES];
                }
            }
            else {
                
                AudioServicesPlaySystemSound(1007);
                [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"180.png"] title:@"appCounselling" message:strAction isAutoHide:YES];
            }
            
            strAction = nil;
            strAlert = nil;
        }
        else
        {
            NSLog(@"Error, object not recognised.");
        }
    }
    
- (void)localNotificationTouched
    {
        NSLog(@"dictInfo = %@", dictInfo);
        NSString *strAlert = [dictInfo objectForKey:@"type"];
        
        //    strUsernameForPostNotification = [dictInfo objectForKey:@"username"];
        
        if ([strAlert isEqualToString:@"counselling_chat"] || [strAlert isEqualToString:@"Minute"] || [strAlert isEqualToString:@"Counselling Start"])
        {
            // Timer
            [self showThePage:@"Live"];
        }
        else if ([strAlert isEqualToString:@"1Hour"] || [strAlert isEqualToString:@"24Hour"] || [strAlert isEqualToString:@"Appoinment Accepted"])
        {
            //Accepted
            [self showThePage:@"Counselling"];
        }
        else if ([strAlert isEqualToString:@"New Appointment"])
        {
            //Pending
            [self showThePage:@"Counselling"];
            [self.objCounsellingVC btnAcceptedPendingClicked:self.objCounsellingVC.btnPending];
        }
        else if ([strAlert isEqualToString:@"Time Suggestion"] || [strAlert isEqualToString:@"SameCounsellor NewAppoinment"])
        {
            //Reschedule
            [self showThePage:@"Reschedule"];
        }
    }
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
- (IBAction)Btn_Mute:(id)sender {
}
    @end
