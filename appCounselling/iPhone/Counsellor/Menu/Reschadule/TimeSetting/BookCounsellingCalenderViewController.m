//
//  BookCounsellingCalenderViewController.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 15/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import "BookCounsellingCalenderViewController.h"
#import "AppDelegate.h"
#import "TimeSlotView.h"
#import "appCounsellingLoginParser.h"

@interface BookCounsellingCalenderViewController ()

@end

@implementation BookCounsellingCalenderViewController

@synthesize isNewTimeSuggestion;
@synthesize dictAppointment;
@synthesize strCounsellorID;

- (void)clearMemory
{
    viewCalender.delegate=nil;
    viewCalender=nil;
    
    strSelectedDate=nil;
    selectedDate=nil;
    calenderDate=nil;
    btnSameCounsellor=nil;
    btnChat=nil;
    btnAudeo=nil;
    btnVideo=nil;
    viewSelectedIndicator=nil;
    
    lblDate=nil;
    
    btnClose=nil;
    
    arrCounsellorAppointment=nil;
    
    viewTimeSlot.delegate=nil;
    viewTimeSlot=nil;
    viewTimeSlotBG=nil;

    dictAppointment=nil;
    strCounsellorID=nil;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //This is to check if user come in this View Cintroller for new time suggestion.
        isNewTimeSuggestion = YES;
        
        //This is to check if user book appointment without setting a time.
        isTimeSlotSelected = NO;
        
        arrCounsellorAppointment = [[NSMutableArray alloc] init];
        
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        after35Hours = 36;

        if(appDelegate.dateServer)
            selectedDate = [appDelegate.dateServer dateByAddingTimeInterval:(after35Hours*60*60)];
        else
            selectedDate = [[NSDate date] dateByAddingTimeInterval:(after35Hours*60*60)];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self designTopBar];
    [self showBackButton];
    
    self.lblTitle.text = @"Reschedule";
    self.view.backgroundColor = colorViewBg;
    
    isFromViewDidLoad=YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(isFromViewDidLoad==YES)
    {
        isFromViewDidLoad = NO;
        [self screenDesigning];
    }
}
-(void)screenDesigning
{
    CGFloat yRef = 0.0;
    CGFloat ySpace = 0.0;
    
    yRef = 55;
    ySpace = 0.0;
    
    if(self.view.frame.size.height>=568)
    {
        yRef = 80;
        ySpace = 0.0;
    }

//    UILabel *lblBookingDetail = [[UILabel alloc] initWithFrame:CGRectMake(40, yRef, self.view.frame.size.width-80, 40)];
//    lblBookingDetail.numberOfLines = 0;
//    lblBookingDetail.font = [UIFont systemFontOfSize:14.0];
//    //lblBookingDetail.text = @"Welcome to appCounselling. Choose one of these to get support.";
//    lblBookingDetail.textAlignment = NSTextAlignmentCenter;
//    lblBookingDetail.textColor = [UIColor whiteColor];
//    [self.view addSubview:lblBookingDetail];
//
//    yRef = yRef+lblBookingDetail.frame.size.height+5+ySpace;
//    
//    NSLog(@"self.view.frame.size.width=%f", self.view.frame.size.width);
//    
//    float spaceButton = (self.view.frame.size.width-240)/4.0;
//    
//    btnChat = [[UIButton alloc] initWithFrame:CGRectMake(spaceButton, yRef, 80, 30)];
////    btnChat = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-80)/2.0, yRef, 80, 30)];
//    [btnChat setImage:[UIImage imageNamed:@"iconChat.png"] forState:UIControlStateNormal];
//    [btnChat setTitle:@" Chat" forState:UIControlStateNormal];
//    btnChat.backgroundColor = [UIColor clearColor];
//    [btnChat setTitleColor:[UIColor colorWithRed:173/255.0 green:57.0/255 blue:72/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [btnChat addTarget:self action:@selector(counsellingModeChanged:) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:btnChat];
//
//    btnAudeo = [[UIButton alloc] initWithFrame:CGRectMake(spaceButton+80+spaceButton, yRef, 80, 30)];
//    btnAudeo.backgroundColor = [UIColor clearColor];
//    [btnAudeo setTitleColor:[UIColor colorWithRed:31/255.0 green:149.0/255 blue:225/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [btnAudeo setTitle:@" Call" forState:UIControlStateNormal];
//    [btnAudeo setImage:[UIImage imageNamed:@"iconAudio.png"] forState:UIControlStateNormal];
//    [btnAudeo addTarget:self action:@selector(counsellingModeChanged:) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:btnAudeo];
//
//    btnVideo = [[UIButton alloc] initWithFrame:CGRectMake(spaceButton+80+spaceButton+80+spaceButton, yRef, 80, 30)];
//    btnVideo.backgroundColor = [UIColor clearColor];
//    [btnVideo setTitleColor:[UIColor colorWithRed:36/255.0 green:162/255.0 blue:109/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [btnVideo setTitle:@" Video" forState:UIControlStateNormal];
//    [btnVideo setImage:[UIImage imageNamed:@"iconVideo.png"] forState:UIControlStateNormal];
//    [btnVideo addTarget:self action:@selector(counsellingModeChanged:) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:btnVideo];
//
//    viewSelectedIndicator = [[UIView alloc] initWithFrame:CGRectMake(spaceButton, yRef+30, 80, 2)];
//    viewSelectedIndicator.backgroundColor = [UIColor colorWithRed:173/255.0 green:57.0/255 blue:72/255.0 alpha:1.0];
////    [self.view addSubview:viewSelectedIndicator];
//
//    yRef = yRef+btnVideo.frame.size.height+10+ySpace;
    
    UILabel *lblBookingAt = [[UILabel alloc] initWithFrame:CGRectMake(20, yRef-10, self.view.frame.size.width-40, 25)];
    lblBookingAt.font = [UIFont boldSystemFontOfSize:20.0];
    lblBookingAt.text = @"Reschedule appointment at : ";
    lblBookingAt.textColor = [UIColor grayColor];
    [self.view addSubview:lblBookingAt];

    yRef = yRef+lblBookingAt.frame.size.height+ySpace;

    viewCalender = [[SettingCalenderView alloc] init];
    if (isNewTimeSuggestion)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:formatServer];
        viewCalender.lastTimeSuggestedDate = [dateFormatter dateFromString:[dictAppointment objectForKey:@"apntmnt_date"]];
        [self settingForNewTimeSuggestion];
    }
    viewCalender.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    viewCalender.fontOfCalender = [UIFont fontWithName:@"Arial" size:18];

    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if(self.view.frame.size.height>480)
            viewCalender.frame = CGRectMake(20, yRef, self.view.frame.size.width-40, 280);
        else
            viewCalender.frame = CGRectMake(20, yRef, self.view.frame.size.width-40, 260);
    }
    else
    {
        viewCalender.frame = CGRectMake(20, yRef, self.view.frame.size.width-40, 500);
    }
    
    viewCalender.delegate = self;
    [self.view addSubview:viewCalender];

    viewTimeSlotBG = [[UIView alloc] init];
    viewTimeSlotBG.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];//colorHeader;
    viewTimeSlotBG.frame = CGRectMake(self.view.frame.size.width+20, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    [self.view addSubview:viewTimeSlotBG];
    
    lblDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewTimeSlotBG.frame.size.width, 40)];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.font = [UIFont systemFontOfSize:14.0];
    lblDate.adjustsFontSizeToFitWidth = YES;
    lblDate.textColor= [UIColor blackColor];
    lblDate.textAlignment = NSTextAlignmentCenter;
    [viewTimeSlotBG addSubview:lblDate];
    
    btnClose = [[UIButton alloc] initWithFrame:CGRectMake(viewTimeSlotBG.frame.size.width-35, 0, 35, 40)];
    btnClose.titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
    [btnClose setTitle:@"x" forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    btnClose.backgroundColor = [UIColor clearColor];
    [btnClose addTarget:self action:@selector(coloseTimerView) forControlEvents:UIControlEventTouchUpInside];
    [viewTimeSlotBG addSubview:btnClose];
    
    viewTimeSlot = [[TimeSlotView alloc] initWithFrame:CGRectMake(0, 40, viewTimeSlotBG.frame.size.width, viewTimeSlotBG.frame.size.height-100)];
    viewTimeSlot.timeInterval = appDelegate.timeInterval;
    viewTimeSlot.timeDuration = appDelegate.timeDuration;
    viewTimeSlot.delegate = self;
    viewTimeSlot.backgroundColor = [UIColor whiteColor];
    [viewTimeSlotBG addSubview:viewTimeSlot];

//    yRef = yRef+viewCalender.frame.size.height+5;

    UIButton *btnUpdateNewTime = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-280)/2.0, self.view.frame.size.height-45, 280, 35)];
    btnUpdateNewTime.layer.cornerRadius  =5.0;
    btnUpdateNewTime.backgroundColor = [UIColor colorWithRed:41/255.0 green:178.0/255 blue:138/255.0 alpha:1.0];
    btnUpdateNewTime.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [btnUpdateNewTime addTarget:self action:@selector(btnUpdateNewTimeClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnUpdateNewTime setTitle:@"Suggest New Time" forState:UIControlStateNormal];

    [self.view addSubview:btnUpdateNewTime];
}

- (void)settingForNewTimeSuggestion
{
    NSString *strMode = [dictAppointment objectForKey:@"mode"];
    strMode = strMode.lowercaseString;
    
    btnChat.enabled = NO;
    btnAudeo.enabled = NO;
    btnVideo.enabled = NO;

    if([strMode isEqualToString:@"chat"])
    {
        [self counsellingModeChanged:btnChat];
    }
    else if([strMode isEqualToString:@"audio"])
    {
        [self counsellingModeChanged:btnAudeo];
    }
    else if([strMode isEqualToString:@"video"])
    {
        [self counsellingModeChanged:btnVideo];
    }
    
}
#pragma mark - Calener Delegate
-(void)calenderDateChanged:(NSDate *)calDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    calenderDate = calDate;
    selectedDate = calDate;
    
    NSDate *add35Hours;
    if(isNewTimeSuggestion)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:formatServer];
        add35Hours = [dateFormatter dateFromString:[dictAppointment objectForKey:@"apntmnt_date"]];
    }
    else
    {
        add35Hours = [[NSDate date] dateByAddingTimeInterval:(after35Hours*60*60)];
    }
    
    [dateFormatter setDateFormat:@"mm"];
    int intmins = [[dateFormatter stringFromDate:add35Hours] integerValue];
    int intMinsToAdd = appDelegate.timeInterval-(intmins%appDelegate.timeInterval);
    
    add35Hours = [add35Hours dateByAddingTimeInterval:(+intMinsToAdd*60)];
    
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    strSelectedDate =  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:calDate]];

    
    NSDate *enddate = calDate;
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:add35Hours];
    double secondsInMinute = 60;
    NSInteger minsBetweenDates = distanceBetweenDates / secondsInMinute;

    viewTimeSlot.intFrom = intFrom;
    viewTimeSlot.intTo = intTo;
    
    if (minsBetweenDates < 0)
    {
        viewTimeSlot.intMinimumTimeMins = -minsBetweenDates;        
    }
    else
    {
        viewTimeSlot.intMinimumTimeMins = 0;
    }

    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    viewTimeSlot.strKey = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:calDate]];

    
    [dateFormatter setDateFormat:@"EEEE, yyyy"];
    NSString *strSelectedWeekStartdate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:calDate]];
    
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"EEE dd MMM, yyyy hh:mm aa"];
    lblDate.text =  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:selectedDate]];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    
    viewTimeSlotBG.frame = CGRectMake(0, viewTimeSlotBG.frame.origin.y, viewTimeSlotBG.frame.size.width, viewTimeSlotBG.frame.size.height);
    
    [UIView commitAnimations];
    
    dateFormatter = nil;
    
    isTimeSlotSelected = NO;
}

- (void)coloseTimerView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.29];
    
    viewTimeSlotBG.frame = CGRectMake(self.view.frame.size.width+20, viewTimeSlotBG.frame.origin.y, viewTimeSlotBG.frame.size.width, viewTimeSlotBG.frame.size.height);
    
    viewCalender.fontOfCalender = [UIFont fontWithName:@"Arial" size:18];
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if(self.view.frame.size.height>480)
            viewCalender.frame = CGRectMake(20, viewCalender.frame.origin.y, self.view.frame.size.width-40, 280);
        else
            viewCalender.frame = CGRectMake(20, viewCalender.frame.origin.y, self.view.frame.size.width-40, 260);
    }
    else
    {
        viewCalender.frame = CGRectMake(20, viewCalender.frame.origin.y, self.view.frame.size.width-40, 500);
    }
    
    lblDate.frame = CGRectMake(0, 0, viewTimeSlotBG.frame.size.width, 35);
    
    [UIView commitAnimations];
}

#pragma mark - TimeSlotViewDelegate

- (void)timeSelectedInMins:(int)intMins
{
    selectedDate = [calenderDate dateByAddingTimeInterval:(intMins*60)];

    isTimeSlotSelected = YES;
    // handle date changes
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"EEE dd MMM, yyyy hh:mm aa"];
    lblDate.text =  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:selectedDate]];

}

#pragma mark - Parsing

- (void)getAcceptedAppointmentOfCounsellor
{
    //    {
    //        "requestData": {
    //            "apikey": "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //            "requestType": "getAppointment",
    //            "counsellorid": "LxyllWw9Xf",
    //            "status": "All"
    //        }
    //    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], @"Accepted", nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01", @"status", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointment", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    [appCounsellingLoginParser sharedManager].strMethod = @"getAppointment";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            [arrCounsellorAppointment removeAllObjects];
            for (NSDictionary *dictData in responseDict)
            {
                [arrCounsellorAppointment addObject:dictData];
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            viewTimeSlot.dictBlokedSlots = [self getFilteredTimeSlots:[NSMutableArray arrayWithArray:arrCounsellorAppointment]];
//            [self getBlockedTime];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getAcceptedAppointmentOfCounsellor];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (NSMutableDictionary *)getFilteredTimeSlots:(NSMutableArray *)arrAppointments
{
    NSMutableArray *arrTemp;
    NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
    
    for (int i=0; i<[arrAppointments count]; i++)
    {
        NSDictionary *objAppointment = [arrAppointments objectAtIndex:i];
        
        NSString *strAppDate = [objAppointment objectForKey:@"apntmnt_date"];
        NSArray *arrDate = [strAppDate componentsSeparatedByString:@" "];
        
        if(arrDate.count>=2)
        {
            NSString *strKey = [NSString stringWithFormat:@"%@", [arrDate objectAtIndex:0]];
            
            arrTemp = [dictTemp objectForKey:strKey];
            
            if(arrTemp ==nil)
            {
                arrTemp=[[NSMutableArray alloc]init];
                
                [arrTemp addObject:[self getMinutes:[arrDate objectAtIndex:1]]];
                [dictTemp setObject:arrTemp forKey:strKey];
                arrTemp = nil;
//                objAppointment = nil;
            }
            else {
                [arrTemp addObject:[self getMinutes:[arrDate objectAtIndex:1]]];
//                objAppointment = nil;
            }
        }
    }

    return dictTemp;
}

- (NSString *)getMinutes:(NSString *)strTime
{
    NSArray *arrTime = [strTime componentsSeparatedByString:@":"];
    
    int totalMins = 0;
    if(arrTime.count>0)
    {
        int hours = [[arrTime objectAtIndex:0] integerValue];
        int mins = [[arrTime objectAtIndex:1] integerValue];
        totalMins = (hours*60)+mins;
    }
    return [NSString stringWithFormat:@"%i", totalMins];
}

- (void)btnUpdateNewTimeClicked
{
    if(isTimeSlotSelected==NO)
    {
        [self showAlertMessage:@"Please Select a date and a time-slot to suggest new time."];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:@"EEE dd MMM, yyyy hh:mm aa"];
        NSString *strMessageDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:selectedDate]];
        
        NSString *strMessage = [NSString stringWithFormat:@"Are you sure you want to suggest new time for counselling using \"%@\" at \"%@\"?",[dictAppointment objectForKey:@"mode"], strMessageDate];
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Rescheduling"
                                     message:strMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"YES"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        [self suggestNewTimeForCounselling];
                                    }];
        [alert addAction:yesButton];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"NO"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                   }];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)suggestNewTimeForCounselling
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:formatServer];
    NSString *strDateToSend = [dateFormatter stringFromDate:selectedDate];
    
    [dictAppointment setObject:strDateToSend forKey:@"apntmnt_date"];
    

    [dateFormatter setDateFormat:@"EEE"];
    NSString *strDay = [dateFormatter stringFromDate:selectedDate];
    [dictAppointment setObject:strDay forKey:@"appointment_day"];

    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strHour = [dateFormatter stringFromDate:selectedDate];
    [dictAppointment setObject:strHour forKey:@"appointment_hours"];

    if(appDelegate.isNetAvailable)
    {
        NSString *strStatus = [dictAppointment objectForKey:@"status"];
        [appDelegate addChargementLoader];
        
        if([strStatus isEqualToString:@"Accepted"])
            [self callServiceForSuggestNewTimeForAcceptedCounselling];
        else
            [self callServiceForSuggestNewTimeForCounselling];
    }
    else
    {
        [appDelegate removeChargementLoader];
        [self performSelectorOnMainThread:@selector(showInternetErrorMessage) withObject:nil waitUntilDone:NO];
    }
}

- (void)callServiceForSuggestNewTimeForCounselling
{
    //    {
    //        "requestData":{
    //            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //            "data":{
    //                "appointmentid":"test122",
    //                "counsellorid":"rizwan3",
    //                "suggested_by":"Counsellor",
    //                "appointmentdate":"04/22/2017 12:00",
    //                "clun01":"W8hNrRAQQIEPXuBy3FJ0ww=="
    //                "counsellor_firstname":"W8hNrRAQQIEPXuBy3FJ0ww=="
    //            },
    //            "requestType":"suggestionAction"
    //        }
    //    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[dictAppointment objectForKey:@"apntmnt_id"], [dictAppointment objectForKey:@"clcnslrun01"], @"Counsellor", [dictAppointment objectForKey:@"apntmnt_date"], [dictAppointment objectForKey:@"clun01"], appDelegate.strFirstname, [dictAppointment objectForKey:@"appointment_day"], [dictAppointment objectForKey:@"appointment_hours"], nil] forKeys:[NSArray arrayWithObjects: @"appointmentid", @"counsellorid", @"suggested_by", @"appointmentdate", @"clun01", @"counsellor_firstname", @"appointment_day", @"appointment_hours", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"suggestionAction", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    [appCounsellingLoginParser sharedManager].strMethod = @"suggestionAction";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [self goBackToRescheduling];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self callServiceForSuggestNewTimeForCounselling];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)callServiceForSuggestNewTimeForAcceptedCounselling
{
//    {
//        "requestData" :     {
//            "apikey" : "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data" :         {
//                "apntmnt_id" : "W8hNrRAQQIEPXuBy3FJ0ww\u003d\u003d1496836326546",
//                "apntmnt_date" : "06/15/2017 20:20"
//                "counsellor_firstname":"W8hNrRAQQIEPXuBy3FJ0ww=="
//            },
//            "requestType" : "updateAppointmentTime"
//        }
//    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[dictAppointment objectForKey:@"apntmnt_id"], [dictAppointment objectForKey:@"apntmnt_date"], appDelegate.strFirstname, [dictAppointment objectForKey:@"appointment_day"], [dictAppointment objectForKey:@"appointment_hours"], nil] forKeys:[NSArray arrayWithObjects: @"apntmnt_id", @"apntmnt_date", @"counsellor_firstname", @"appointment_day", @"appointment_hours", nil]];


    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"updateAppointmentTime", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    

    [appCounsellingLoginParser sharedManager].strMethod = @"suggestionAction";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            [self goBackToRescheduling];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self callServiceForSuggestNewTimeForAcceptedCounselling];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)goBackToRescheduling
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getBlockedTime
{
//    if(appDelegate.isNetAvailable)
//    {
//        [appDelegate addChargementLoader];
//        [objAppCounsellingBL getBlockedTime];
//    }
//    else
//    {
//        [appDelegate removeChargementLoader];
//        [self performSelectorOnMainThread:@selector(showInternetErrorMessage) withObject:nil waitUntilDone:NO];
//    }
}
- (void)getBlockedTimeFinished:(NSArray *)arrBlocks
{
//    [appDelegate removeChargementLoader];
//    for (int i=0; i<arrBlocks.count; i++)
//    {
//        PFObject *objBlok = [arrBlocks objectAtIndex:i];
//        NSString *strStatus = [objBlok objectForKey:@"isUnavailable"];
//        if([strStatus isEqualToString:@"false"])
//        {
//            //Do nothing
//        }
//        else if([strStatus isEqualToString:@"true"])
//        {
//            NSString *strFrom = [objBlok objectForKey:@"from"];
//            strFrom = [strFrom stringByReplacingOccurrencesOfString:@":00" withString:@""];
//            NSString *strTo = [objBlok objectForKey:@"to"];
//            strTo = [strTo stringByReplacingOccurrencesOfString:@":00" withString:@""];
//            
//            intFrom = [strFrom intValue];
//            intTo = [strTo intValue];
//            
////            if(intFrom==00)
////                intFrom = 23;
////            else
////                intFrom = intFrom-1;
//            
//            viewTimeSlot.intFrom = intFrom;
//            viewTimeSlot.intTo = intTo;
//        }
//    }    
}

- (void)errorOccured:(NSError *)error
{
    [appDelegate removeChargementLoader];
}

#pragma mark - Action Methods

- (void)counsellingModeChanged:(UIButton *)sender
{
    if([sender isEqual:btnChat])
    {
        [dictAppointment setObject:@"Chat" forKey:@"mode"];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.29];
        
        viewSelectedIndicator.backgroundColor = [UIColor colorWithRed:173/255.0 green:57.0/255 blue:72/255.0 alpha:1.0];
        viewSelectedIndicator.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y+30, 80, 2);
        
        [UIView commitAnimations];
    }
    else if([sender isEqual:btnAudeo])
    {
        [dictAppointment setObject:@"Audio" forKey:@"mode"];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.29];
        
        viewSelectedIndicator.backgroundColor = [UIColor colorWithRed:31/255.0 green:149.0/255 blue:225/255.0 alpha:1.0];
        viewSelectedIndicator.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y+30, 80, 2);
        
        [UIView commitAnimations];
    }
    else if([sender isEqual:btnVideo])
    {
        [dictAppointment setObject:@"Video" forKey:@"mode"];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.29];
        
        viewSelectedIndicator.backgroundColor = [UIColor colorWithRed:36/255.0 green:162/255.0 blue:109/255.0 alpha:1.0];
        viewSelectedIndicator.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y+30, 80, 2);
        
        [UIView commitAnimations];
    }
}

- (void)hideMe
{
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
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

@end
