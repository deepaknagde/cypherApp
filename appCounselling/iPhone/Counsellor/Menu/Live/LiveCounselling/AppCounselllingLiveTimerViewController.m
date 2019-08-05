//
//  AppCounselllingLiveTimerViewController.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 27/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import "AppCounselllingLiveTimerViewController.h"
#import "AppDelegate.h"
#import "AppCounselllingLiveChatViewController.h"
#import "MoodGraphView.h"
#import "appCounsellingChatParser.h"
#import "BeforeImpactQuestionView.h"
#import "appCounsellingLoginParser.h"
#import "AssessmentFormView.h"
#import "AssessmentForm_VC.h"

@interface AppCounselllingLiveTimerViewController ()

@end

@implementation AppCounselllingLiveTimerViewController

@synthesize dictAppointment;

- (void)clearMemory
{
    viewTimer=nil;
    lblMins=nil;
    lblSecs=nil;
    if(timer5Mins && [timer5Mins isValid])
    {
        [timer5Mins invalidate];
        timer5Mins=nil;
    }
    
    imgMoodGraph=nil;
}
- (void)designBeforeImpactQ
{
    BeforeImpactQuestionView *viewBeforeImpactQ = [[BeforeImpactQuestionView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight)];
    viewBeforeImpactQ.backgroundColor  = [UIColor grayColor];
    [self.view addSubview:viewBeforeImpactQ];
    
    viewBeforeImpactQ.strAppointmentId = [dictAppointment objectForKey:@"apntmnt_id"];
    
    [appDelegate addChargementLoader];
    [viewBeforeImpactQ getAllQuestionsWebServiceCall];
}

-(void)viewWillAppear:(BOOL)animated {
 
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self designtimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [btnAssessmentForm setUserInteractionEnabled:YES];

    [self designTopBar];
    [self showBackButton];

    lblTitle.text = @"appCounselling";

    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.view.backgroundColor = colorViewBg;
    
//    [self designtimer];
    
    lblImpactQuestionStatus = [[UILabel alloc] init];
    lblImpactQuestionStatus.frame = CGRectMake((self.view.frame.size.width-280)/2.0, self.view.frame.size.height-145, 280, 45);
    lblImpactQuestionStatus.numberOfLines = 0;
//    if(appDelegate.screenWidth<=320)
        lblImpactQuestionStatus.font = [UIFont systemFontOfSize:12.0];
//    else
//        lblImpactQuestionStatus.font = [UIFont systemFontOfSize:14.0];
//    lblImpactQuestionStatus.text = @"Client is filling the impact question, Please wait for client to join the session.";
//    lblImpactQuestionStatus.text =  @"Please wait, client is answering yp core questions";
    lblImpactQuestionStatus.textAlignment = NSTextAlignmentCenter;
    lblImpactQuestionStatus.textColor = colorWhiteOrBlack;
    [self.view addSubview:lblImpactQuestionStatus];

    NSNumber *numCheck = [dictAppointment objectForKey:@"impactQuestion"];
    
    BOOL isAlreadyAnswered = NO;
    
    if(numCheck && ![numCheck isKindOfClass:[NSNull class]])
        isAlreadyAnswered = [numCheck boolValue];
    
    if(isAlreadyAnswered)
    {
        lblImpactQuestionStatus.hidden = YES;
    }
    
    UIButton *btnViewMoodGraph = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-280)/2.0, self.view.frame.size.height-45, 280, 35)];
    btnViewMoodGraph.layer.cornerRadius  =5.0;
    btnViewMoodGraph.backgroundColor = [UIColor colorWithRed:41/255.0 green:178.0/255 blue:138/255.0 alpha:1.0];
    btnViewMoodGraph.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [btnViewMoodGraph addTarget:self action:@selector(btnViewMoodGraphClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnViewMoodGraph setTitle:@"View Mood Graph" forState:UIControlStateNormal];
    [self.view addSubview:btnViewMoodGraph];

    UIButton *btnViewImpactQ = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-280)/2.0, self.view.frame.size.height-90, 280, 35)];
    btnViewImpactQ.layer.cornerRadius  =5.0;
    btnViewImpactQ.backgroundColor = [UIColor colorWithRed:41/255.0 green:178.0/255 blue:138/255.0 alpha:1.0];
    btnViewImpactQ.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [btnViewImpactQ addTarget:self action:@selector(designBeforeImpactQ) forControlEvents:UIControlEventTouchUpInside];
    [btnViewImpactQ setTitle:@"View Impact Question" forState:UIControlStateNormal];
    //[self.view addSubview:btnViewImpactQ];

//    btnAssessmentForm = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-280)/2.0, self.view.frame.size.height-135, 280, 35)];
    
    btnAssessmentForm = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-280)/2.0, self.view.frame.size.height-90, 280, 35)];
    btnAssessmentForm.layer.cornerRadius  =5.0;
    btnAssessmentForm.backgroundColor = [UIColor colorWithRed:41/255.0 green:178.0/255 blue:138/255.0 alpha:1.0];
    btnAssessmentForm.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [btnAssessmentForm addTarget:self action:@selector(getData) forControlEvents:UIControlEventTouchUpInside];
    [btnAssessmentForm setTitle:@"View Assessment Form" forState:UIControlStateNormal];
    [self.view addSubview:btnAssessmentForm];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTimer) name:@"comeFromBackground" object:nil];    
}

- (void)showAssessmentForm
{
    AssessmentFormView *viewAF = [[AssessmentFormView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight)];
    viewAF.backgroundColor = [UIColor whiteColor];
    [viewAF getAllQuestionsWebServiceCall:[self.dictAppointment objectForKey:@"clun01"]];
    [self.view addSubview:viewAF];
}

- (void)refreshTimer
{
    NSString *strCallingMode = [dictAppointment objectForKey:@"mode"];
    strCallingMode = strCallingMode.lowercaseString;
    
    if([strCallingMode isEqualToString:@"video"] || [strCallingMode isEqualToString:@"audio"])
    {
        NSArray *arrVC = self.navigationController.viewControllers;
        if(arrVC != nil && arrVC.count>0)
        {
            UIViewController *currentVC = [arrVC objectAtIndex:arrVC.count-1];
            if ([currentVC isKindOfClass:[AppCounselllingLiveTimerViewController class]] ) {
                
                [self clearMemory];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLive" object:nil];
            }
        }
    }
    else
    {
        [self clearMemory];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLive" object:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [btnAssessmentForm setUserInteractionEnabled:YES];

    if(timer5Mins==nil || ![timer5Mins isValid])
    {
        timer5Mins = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimerText) userInfo:nil repeats:YES];
    }

    if(isFromViewDidLoad==YES)
    {
        isFromViewDidLoad = NO;
    }
}
- (void)btnViewMoodGraphClicked
{
    [appDelegate addChargementLoader];
    [self getMoodGraph];
   
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(timer5Mins && [timer5Mins isValid])
    {
        [timer5Mins invalidate];
        timer5Mins=nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if(timer5Mins && [timer5Mins isValid])
//    {
//        [timer5Mins invalidate];
//        timer5Mins=nil;
//    }
}
- (void)designtimer
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:formatServer];
    
    NSString *strAppointmentDate = [dictAppointment objectForKey:@"apntmnt_date"];

    NSDate *appointmentDate = [dateFormatter dateFromString:strAppointmentDate];

    NSDate *currDate = [NSDate date];
    if(appDelegate.dateServer)
        currDate = appDelegate.dateServer;
    else
        currDate = [NSDate date];

    NSTimeInterval distanceBetweenDates = [appointmentDate timeIntervalSinceDate:currDate];

    long seconds = lroundf(distanceBetweenDates);
    hours = (seconds / 3600);
    int mins = (seconds % 3600) / 60;
    int secs = seconds % 60;
    
    intTimeLeft = secs+(60*mins);
    
    if(hours==0)
    {
        CGFloat width = 220;
        CGFloat height = 180;
        viewTimer = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-width)/2.0, 150, width, height)];
        viewTimer.backgroundColor = [UIColor clearColor];
        viewTimer.layer.borderColor = [UIColor whiteColor].CGColor;
        viewTimer.layer.borderWidth = 10;
        viewTimer.layer.cornerRadius = 10.0;
        [self.view addSubview:viewTimer];
        
        [lblMins removeFromSuperview];
        
        lblMins = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/2.0, height)];
        lblMins.font = [UIFont boldSystemFontOfSize:50.0];
        lblMins.textColor = colorHeader;
        lblMins.textAlignment = NSTextAlignmentRight;
        lblMins.backgroundColor = [UIColor clearColor];
        [viewTimer addSubview:lblMins];
        
        [lblSecs removeFromSuperview];
        
        lblSecs = [[UILabel alloc] initWithFrame:CGRectMake(width/2.0, 0, width/2.0, height)];
        lblSecs.font = [UIFont boldSystemFontOfSize:50.0];
        lblSecs.textColor = colorHeader;
        lblSecs.textAlignment = NSTextAlignmentLeft;
        lblSecs.backgroundColor = [UIColor clearColor];
        [viewTimer addSubview:lblSecs];
        
        [self startTimer];
        
        UILabel *lblBookingDetail = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, self.view.frame.size.width-40, 80)];
        lblBookingDetail.numberOfLines = 0;
        lblBookingDetail.font = [UIFont systemFontOfSize:14.0];
        lblBookingDetail.text = @"Your counselling will start soon, You can view the moodgraph of client here";
        lblBookingDetail.textAlignment = NSTextAlignmentCenter;
        lblBookingDetail.textColor = colorWhiteOrBlack;
        [self.view addSubview:lblBookingDetail];
    }
}

#pragma mark - Timer
- (void)startTimer
{
    if(timer5Mins==nil || ![timer5Mins isValid])
    {
        timer5Mins = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimerText) userInfo:nil repeats:YES];
    }
}

- (void)changeTimerText
{
    int intTimeDuration = (60*appDelegate.timeDuration);
    
    if(intTimeLeft<0 && intTimeLeft>-intTimeDuration && hours==0)
    {
        [timer5Mins invalidate];
        timer5Mins = nil;
        [self gotoCounsellingMode];
    }
    else
    {
        lblMins.text = [NSString stringWithFormat:@"%02i:", intTimeLeft/60];
        lblSecs.text = [NSString stringWithFormat:@"%02i", intTimeLeft%60];
        intTimeLeft--;
    }
    
    if(intTimeLeft%10==0)
    {
        NSNumber *numCheck = [dictAppointment objectForKey:@"impactQuestion"];

        BOOL isAlreadyAnswered = NO;
        if(numCheck && ![numCheck isKindOfClass:[NSNull class]])
            isAlreadyAnswered = [numCheck boolValue];

        if(!isAlreadyAnswered)
        {
            //[self getData];
        }
    }
}

// After Timer finished
- (void)gotoCounsellingMode
{
    NSString *strMode = [dictAppointment objectForKey:@"mode"];
    strMode = strMode.lowercaseString;
    
    if([strMode.lowercaseString isEqualToString:@"chat"])
    {
        AppCounselllingLiveChatViewController *objChatVC = [[AppCounselllingLiveChatViewController alloc] init];
        objChatVC.dictAppointment = dictAppointment;
        [self.navigationController pushViewController:objChatVC animated:NO];
        objChatVC = nil;
    }
    else if([strMode.lowercaseString isEqualToString:@"audio"] || [strMode.lowercaseString isEqualToString:@"video"])
    {
        AppCounselllingLiveChatViewController *objChatVC = [[AppCounselllingLiveChatViewController alloc] init];
        objChatVC.dictAppointment = dictAppointment;
        [self.navigationController pushViewController:objChatVC animated:NO];
        objChatVC = nil;
    }
}

- (void)hideMe
{
    if(self.navigationController)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Parsers

- (void)getMoodGraph
{
//    {
//        "requestData":{
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "data":{
//                "apntmnt_id":"qMTrir5/a7Nota+tQwdxTA\u003d\u003d1493785804878"
//            },
//            "requestType":"getMoodGraph"
//        }
//    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[dictAppointment objectForKey:@"apntmnt_id"], nil] forKeys:[NSArray arrayWithObjects:@"apntmnt_id", nil]];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getMoodGraph", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:requestData forKey:@"requestData"];
    
    [appCounsellingChatParser sharedManager].strMethod = @"getMoodGraph";
    [[appCounsellingChatParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             strMoodGraphURL = @"";
             if(responseDict != nil && [responseDict isKindOfClass:[NSString class]]) {
                 strMoodGraphURL = (NSString *)responseDict;
             }
             else  {
                 [self showAlertMessage:@"MoodGraph is not shared by user."];
             }
             [appDelegate removeChargementLoader];
             [self showMoodGraph];
         });
     } failure:^(NSError *error) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             if(appDelegate.isServerswitched == NO){
                 [appDelegate switchServer];
                 [self getMoodGraph];
             }
             else {
                 [appDelegate removeChargementLoader];
             }
         });
     }];
}

- (void)showMoodGraph
{
    if(viewMoodGraph==nil)
    {
        viewMoodGraph = [[MoodGraphView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight)];
    }
    
    if(strMoodGraphURL && strMoodGraphURL.length>10)
    {
        [self.view addSubview:viewMoodGraph];
        [viewMoodGraph setParameter:dictAppointment];
        [viewMoodGraph showImage:strMoodGraphURL];
    }
    else
        [self showAlertMessage:@"MoodGraph is not shared by user."];
}

- (void)getData
{
    [btnAssessmentForm setUserInteractionEnabled:NO];
    
    [appDelegate addChargementLoader];
    NSString *strAppointmentID = [dictAppointment objectForKey:@"apntmnt_id"];
    NSLog(@"-- strAppointmentID --%@", strAppointmentID);

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: strAppointmentID, nil] forKeys:[NSArray arrayWithObjects: @"apntmnt_id",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointmentById", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"getCounsellorQuestions = %@", dictParameter);
    [appCounsellingLoginParser sharedManager].strMethod = @"getCounsellorQuestions";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        [[NSUserDefaults standardUserDefaults] setValue:responseDict forKey:@"assessmentForm"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"strClcnslrun01=%@", responseDict);
        
        NSString *str = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"clcnslrun01"]];
        NSString *clun = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"clun01"]];
        NSString *qid = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"qid"]];
        
        NSString *session_left = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"session_left"]];
        
        NSString *str1 = [str stringByReplacingOccurrencesOfString:@"(\n" withString:@""];
        NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\n)" withString:@""];
        NSString *strClcnslrun01 = [str2 stringByReplacingOccurrencesOfString:@"\""withString:@""];
        
        NSString *clun1 = [clun stringByReplacingOccurrencesOfString:@"(\n" withString:@""];
        NSString *clun2 = [clun1 stringByReplacingOccurrencesOfString:@"\n)" withString:@""];
        NSString *clun3 = [clun2 stringByReplacingOccurrencesOfString:@"\""withString:@""];
        NSString *strClun01 = [clun3 stringByReplacingOccurrencesOfString:@"    "withString:@""];

        NSString *qid1 = [qid stringByReplacingOccurrencesOfString:@"(\n" withString:@""];
        NSString *qid2 = [qid1 stringByReplacingOccurrencesOfString:@"\n)" withString:@""];
        NSString *qid3 = [qid2 stringByReplacingOccurrencesOfString:@"\""withString:@""];
        NSString *strQid = [qid3 stringByReplacingOccurrencesOfString:@"    "withString:@""];

        NSString *session_left1 = [session_left stringByReplacingOccurrencesOfString:@"(\n" withString:@""];
        NSString *session_left2 = [session_left1 stringByReplacingOccurrencesOfString:@"\n)" withString:@""];
        NSString *session_left3 = [session_left2 stringByReplacingOccurrencesOfString:@"\""withString:@""];
        NSString *session_left4 = [session_left3 stringByReplacingOccurrencesOfString:@" "withString:@""];
        
        //  [appDelegate removeChargementLoader];
        
        NSLog(@"");
        [self getLiveAppointment:strQid clun_01:strClun01];
        
       
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}
- (void)getLiveAppointment:(NSString *)q_id clun_01:(NSString *)clun_01
{
    [appDelegate addChargementLoader];
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: clun_01 , q_id, nil] forKeys:[NSArray arrayWithObjects: @"clun01", @"qid",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAssesmentAnswerCounselling", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setValue:parameters forKey:@"requestData"];
    
    
    NSLog(@"strClcnslrun01=%@", dictParameter);
    
    NSMutableArray *arrAcceptedAppointments = [[NSMutableArray alloc] init];
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        NSLog(@"strClcnslrun01=%@", responseDict);
        
        NSArray *localArray = [[NSArray alloc] initWithArray:[responseDict valueForKey:@"clquestioneranswer01"]];
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dictData in responseDict)
            {
                [arrAcceptedAppointments addObject:dictData];
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            
            [self Show_Ass_VC:localArray];
            //            [self checkIfLiveAppointment:arrAcceptedAppointments];
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

-(void)Show_Ass_VC:(NSArray *)Loac_Array {
    
    NSLog(@"-- Loac_Array --%@", Loac_Array);
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"VideoCall" bundle:nil];
    
    AssessmentForm_VC *screen = [sb instantiateViewControllerWithIdentifier:@"AssessmentForm_VC"];
    
    screen.JsonArr = [[NSMutableArray alloc] initWithArray:Loac_Array];
    [self.navigationController pushViewController:screen animated:YES];
}

- (void)checkIfLiveAppointment:(NSMutableArray *)arrAcceptedAppointments
{
    for (int i=0; i<arrAcceptedAppointments.count; i++)
    {
        NSDictionary *dictAppointmentTemp = [arrAcceptedAppointments objectAtIndex:i];
        
        NSString *strAppointId_1 = [dictAppointment objectForKey:@"apntmnt_id"];
        NSString *strAppointId_2 = [dictAppointmentTemp objectForKey:@"apntmnt_id"];
        
        if([strAppointId_1 isEqualToString:strAppointId_2])
        {
            NSNumber *numCheck = [dictAppointmentTemp objectForKey:@"impactQuestion"];

            BOOL isAlreadyAnswered = NO;
            if(numCheck && ![numCheck isKindOfClass:[NSNull class]])
                isAlreadyAnswered = [numCheck boolValue];

            if(isAlreadyAnswered)
            {
                self.dictAppointment = dictAppointmentTemp;
                lblImpactQuestionStatus.hidden = YES;
            }
            
            break;
        }
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

@end
