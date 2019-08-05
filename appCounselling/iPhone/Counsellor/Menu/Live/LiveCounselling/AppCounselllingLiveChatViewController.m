//
//  AppCounselllingLiveChatViewController.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 27/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import "AppCounselllingLiveChatViewController.h"
#import "AppCounsellingRattingViewController.h"
#import "MoodGraphView.h"
#import "BeforeImpactQuestionView.h"
#import "appCounsellingChatParser.h"
#import "appCounsellingLoginParser.h"

#import "CounsellorHomeViewController.h"
#import <Sinch/Sinch.h>
#import "AssessmentFormView.h"
#import "AssessmentForm_VC.h"
#import "LiveViewController.h"
#import "WebServicesClass.h"

@interface AppCounselllingLiveChatViewController ()<SINCallClientDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
//@property (nonatomic) BOOL isReading;
@property NSString *CallName;

@end

@implementation AppCounselllingLiveChatViewController

@synthesize strTitle;
@synthesize dictAppointment;

- (void)clearMemory
{
    if(self.CallVC)
    {
        [self.CallVC decline:nil];
        
        self.CallName = nil;
        self.client.callClient.delegate = nil;
        
        self.CallVC.call = nil;
        self.CallVC = nil;
    }
    
    imgMoodGraph=nil;
    
    [viewMessageDetails clearMemory];
    viewMessageDetails=nil;
    
    txtFieldMessage.delegate=nil;
    txtFieldMessage=nil;
    
    txtFieldMessage.delegate=nil;
    txtFieldMessage = nil;
    
    
    strTitle=nil;
}
- (void)designBeforeImpactQ
{
    BeforeImpactQuestionView *viewBeforeImpactQ = [[BeforeImpactQuestionView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight)];
    viewBeforeImpactQ.backgroundColor  = [UIColor grayColor];
    [self.view addSubview:viewBeforeImpactQ];
    
    //    viewBeforeImpactQ.strUsername = [PFUser currentUser].username;
    viewBeforeImpactQ.strAppointmentId = [dictAppointment objectForKey:@"apntmnt_id"];
    //    viewBeforeImpactQ.strCounsellorId = [objBookedAppointment objectForKey:@"clcnslrun01"];
    
    [appDelegate addChargementLoader];
    [viewBeforeImpactQ getAllQuestionsWebServiceCall];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self designTopBar];
    [self showBackButton];

    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.view.backgroundColor = colorViewBg;

    lblTitle.text = @"Chat";
    lblTitle.frame = CGRectMake(50, 20, appDelegate.screenWidth-100, 30);

    btnBack.hidden = YES;
    
    btnBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 90, 44)];
    [btnBack setTitle:@"Close the Chat" forState:UIControlStateNormal];
    btnBack.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btnBack.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnBack.titleLabel.numberOfLines = 2;
    btnBack.titleLabel.textColor = [UIColor whiteColor];
    btnBack.backgroundColor = [UIColor clearColor];
    //    [btnBack setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(hideMe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    // btnTimeIncreament.hidden = NO;
    btnTimeIncreament = [[UIButton alloc]initWithFrame:CGRectMake(80, 22, 50, 44)];
    [btnTimeIncreament setTitle:@" + 10 minute" forState:UIControlStateNormal];
    btnTimeIncreament.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btnTimeIncreament.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnTimeIncreament.titleLabel.numberOfLines = 2;
    btnTimeIncreament.titleLabel.textColor = [UIColor whiteColor];
    btnTimeIncreament.backgroundColor = [UIColor clearColor];
    //    [btnBack setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [btnTimeIncreament addTarget:self action:@selector(incresTenMinit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTimeIncreament];
    
//    if(dictAppointment!=nil)
//    {
//        [self screenDesigning];
//    }
    
    [appDelegate addChargementLoader];
    
    NSString *strCallingMode = [dictAppointment objectForKey:@"mode"];
    lblTitle.text = strCallingMode;
    strCallingMode = strCallingMode.lowercaseString;

    if([strCallingMode isEqualToString:@"video"] || [strCallingMode isEqualToString:@"audio"])
    {
        self.CallName = @"Counellor";
        self.client.callClient.delegate = self;
        
        UIButton *btnCall = [[UIButton alloc] initWithFrame:CGRectMake(appDelegate.screenWidth-110, 18, 44, 44)];
        btnCall.backgroundColor = [UIColor clearColor];//colorWithRed:41/255.0 green:178.0/255 blue:138/255.0 alpha:1.0];
        //    [btnCall setTitle:@"CALL!" forState:UIControlStateNormal];
        if([strCallingMode isEqualToString:@"video"])
            [btnCall setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                            pathForResource:@"btnVidioCall" ofType:@"png"]] forState:UIControlStateNormal];
        else
            [btnCall setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                            pathForResource:@"btnAudioCall" ofType:@"png"]] forState:UIControlStateNormal];

        [btnCall addTarget:self action:@selector(startCallingToYoungPerson) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnCall];
        btnCall.layer.cornerRadius  =5.0;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTimer) name:@"comeFromBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeAttendanceWithObjectID) name:@"callAccepted" object:nil];
}

- (void)refreshTimer
{
    NSString *strCallingMode = [dictAppointment objectForKey:@"mode"];
    strCallingMode = strCallingMode.lowercaseString;
    
    if([strCallingMode isEqualToString:@"video"] || [strCallingMode isEqualToString:@"audio"])
    {
        viewMessageDetails.seconds = -10;
    }
    else{
//         viewMessageDetails.seconds = -10;
        [self clearMemory];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLive" object:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   // btnTimeIncreament.hidden = NO;

    if(dictAppointment!=nil)
    {
        if(viewMessageDetails==nil)
            [self screenDesigning];
    }
}
- (void)screenDesigning
{
    [self designChattingView];
    
//    NSString *strUserAttendence = [dictAppointment objectForKey:@"userCameAt"];
//    if((dictAppointment && [dictAppointment objectForKey:@"userCameAt"]==nil) || strUserAttendence.length==0)
//        [self markUserAttendanceToYES];
    
}
-(void)incresTenMinit{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Increase time duration" message:@"Do you want to increase 10 minutes more in this session?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //button click event

        NSString *strAppointmentID = [dictAppointment objectForKey:@"apntmnt_id"];
        [appDelegate addChargementLoader];
        NSNumber *numDuration = [self.dictAppointment objectForKey:@"session_duration"];
        NSLog(@"%@", numDuration);
        
        NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: strAppointmentID,numDuration, nil] forKeys:[NSArray arrayWithObjects: @"apntmntId",@"session_duration",nil]];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"updateCousellingDuration", data,  @"true",nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data",@"updatedcounselling_time", nil]];
        
        [dictParameter setValue:parameters forKey:@"requestData"];
        
        NSLog(@"strClcnslrun01=%@", dictParameter);
        
//        NSString *strURL = @"https://www.getcypherapp.com:6006/api/service";
//        [ [WebServicesClass sharedManager]callWebServiceLatlobg:dictParameter withURLString:strURL success:^(NSDictionary *responseDict) {
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [appDelegate removeChargementLoader];
//
//                LiveViewController *objLiveVC = [[LiveViewController alloc] init];
//                objLiveVC.strTitle = @"Live";
//                [appDelegate.navControl pushViewController:objLiveVC animated:NO];
//
////                btnTimeIncreament.hidden = YES;
//                // [[NSNotificationCenter defaultCenter]
//                //  postNotificationName:@"refreshLivepavan" object:nil];
//
//                [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"ForbuttonHide10min"];
//                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                [userDefault setObject:@"yes" forKey:@"pavanRef"];
//                NSLog(@"---pavan true ---");
//
//                //                LiveViewController *objLiveVC = [[LiveViewController alloc] init];
//                //                objLiveVC.strTitle = @"Live";
//                //                [appDelegate.navControl pushViewController:objLiveVC animated:NO];
//                //
//                //                objLiveVC = nil;
//
//            });
//
////
////        }
////                                                        failure:^(NSError *error) {
////                                                            dispatch_async(dispatch_get_main_queue(), ^{
////
////                                                            });}];
////    }
        
        
        [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {

            NSLog(@"neck nice%@", responseDict);

            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate removeChargementLoader];

                                LiveViewController *objLiveVC = [[LiveViewController alloc] init];
                                objLiveVC.strTitle = @"Live";
                                [appDelegate.navControl pushViewController:objLiveVC animated:NO];

               btnTimeIncreament.hidden = YES;
                // [[NSNotificationCenter defaultCenter]
                //  postNotificationName:@"refreshLivepavan" object:nil];

                [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"ForbuttonHide10min"];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:@"yes" forKey:@"pavanRef"];
                NSLog(@"---pavan true ---");

//                LiveViewController *objLiveVC = [[LiveViewController alloc] init];
//                objLiveVC.strTitle = @"Live";
//                [appDelegate.navControl pushViewController:objLiveVC animated:NO];
//
//                objLiveVC = nil;

            });
        } failure:^(NSError *error) {
            NSLog(@"strClcnslrun01=%@", error);

        }];

    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //button click event

    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)designChattingView
{
    NSNumber *numDuration = [self.dictAppointment objectForKey:@"session_duration"];
    
    NSLog(@"pavan %@", numDuration);
    appDelegate.timeDuration = numDuration.intValue;
    
    NSString *pavanRef = [[NSUserDefaults standardUserDefaults] objectForKey:@"pavanRef"];
    
//    if (appDelegate.timeIncressfalse == true){
//        btnTimeIncreament.hidden = YES;
//    }else{
//        btnTimeIncreament.hidden = NO;
//    }
//
    NSString *ForbuttonHide10min = [[NSUserDefaults standardUserDefaults] objectForKey:@"ForbuttonHide10min"];
    
    if ([ForbuttonHide10min isEqualToString:@"false"]){
       btnTimeIncreament.hidden = NO;
    }else if ([ForbuttonHide10min isEqualToString:@"true"]){
         btnTimeIncreament.hidden = YES;
    }
    else{
          btnTimeIncreament.hidden = NO;
    }

    
    viewMessageDetails = [[AppCounsellingChatView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    //viewMessageDetails.dictAppointment = self.dictAppointment;//Counsellorid"];Userid
    viewMessageDetails.dictAppointment = [[NSMutableDictionary alloc] initWithDictionary:self.dictAppointment];
    viewMessageDetails.strMessageUserID = [self.dictAppointment objectForKey:@"clun01"];
    [viewMessageDetails viewDesigning];
    viewMessageDetails.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    viewMessageDetails.backgroundColor = [UIColor colorWithRed:226/255.0f green:230/255.0f blue:220/255.0f alpha:1.0];
    viewMessageDetails.delegate = self;
    [self.view addSubview:viewMessageDetails];
    [viewMessageDetails getMessageWith:viewMessageDetails.strMessageUserID andDate:nil];

//    //Chat History
//    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *arrTemp = [defaultUser objectForKey:viewMessageDetails.strMessageUserID];
//    
//    if(arrTemp && arrTemp.count>0) {
//        [viewMessageDetails getMessageParserFinished:arrTemp];
//    }
//    else {
//        [viewMessageDetails getMessageWith:viewMessageDetails.strMessageUserID andDate:nil];
//    }

    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 20, 70, 35)];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    doneBtn.titleLabel.textColor = [UIColor whiteColor];
    [doneBtn addTarget:viewMessageDetails action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
}

-(void)showAlert:(UIAlertController *)alert
{
    if(alert)
        [self presentViewController:alert animated:YES completion:nil];
}

-(void)hideMe
{
    @synchronized (self)
    {
        for (UIViewController* viewController in self.navigationController.viewControllers) {
            
            //This if condition checks whether the viewController's class is MyGroupViewController
            // if true that means its the MyGroupViewController (which has been pushed at some point)
            if ([viewController isKindOfClass:[CounsellorHomeViewController class]] ) {
                
                // Here viewController is a reference of UIViewController base class of MyGroupViewController
                // but viewController holds MyGroupViewController  object so we can type cast it here
                CounsellorHomeViewController *groupViewController = (CounsellorHomeViewController*)viewController;
                
                [self clearMemory];

                if(self.navigationController)
                    [self.navigationController popToViewController:groupViewController animated:YES];
                else
                    [appDelegate.navControl popToViewController:groupViewController animated:YES];
            }
        }
    }
}

- (void)gotoRattingPage
{
    AppCounsellingRattingViewController *objRattingVC = [[AppCounsellingRattingViewController alloc] init];
    objRattingVC.dictAppointment = self.dictAppointment;
    
    if(self.navigationController)
        [self.navigationController pushViewController:objRattingVC animated:YES];
    else
        [appDelegate.navControl pushViewController:objRattingVC animated:YES];
    objRattingVC = nil;
}

#pragma mark - Chat delegate method

-(void)counsellingTimeOver
{
    BOOL isCounsellorAvailable = NO;
    BOOL isUserAvailable = NO;
    BOOL shouldUploadQuestion = NO;
    
    for (int i=0; i<[viewMessageDetails.arrMessagesAudioVideo count]; i++)
    {
        NSDictionary *objMsg = [viewMessageDetails.arrMessagesAudioVideo objectAtIndex:i];
        NSString *strSender = [objMsg objectForKey:@"sender"];
        
        NSString *strClcnslrun01 = [NSString stringWithFormat:@"%@", [dictAppointment valueForKey:@"clcnslrun01"]];
        NSString *strClun01 = [NSString stringWithFormat:@"%@", [dictAppointment valueForKey:@"clun01"]];

        
        [[NSUserDefaults standardUserDefaults] setValue:strClcnslrun01 forKey:@"clcnslrun01"];
        [[NSUserDefaults standardUserDefaults] setValue:strClun01 forKey:@"clun01"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if([strSender isEqualToString:[dictAppointment objectForKey:@"clcnslrun01"]])
        {
            isCounsellorAvailable = YES;
        }
        if([strSender isEqualToString:[dictAppointment objectForKey:@"clun01"]])
        {
            isUserAvailable = YES;
        }
        if(isUserAvailable && isCounsellorAvailable)
        {
            shouldUploadQuestion = YES;
            break;
        }
    }
    
    if(shouldUploadQuestion==YES)
    {
        if(self.CallVC)
        {
            [self.CallVC decline:nil];
            
            self.CallName = nil;
            self.client.callClient.delegate = nil;
            
            self.CallVC.call = nil;
            self.CallVC = nil;
        }
        // Here we will go to rating and fetch all the question to submit
        [self gotoRattingPage];
        //Crashing
//        [viewMessageDetails clearMemory];
    }
    else{
        [self hideMe];
    }    
}

- (void)shouldShowTheCancelOption
{
    [self hideMe];
}
- (void)uploadRattingQuestions
{
    [self insertRattingQuestions];
}

#pragma mark - Mood Graph
-(void)sendMoodGraphToCounsellor
{
    [txtFieldMessage resignFirstResponder];

    // Show two options Mood Graph and Impact Question
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@"Check Mood Graph and Assessment Form shared by user."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *btnMoodGraph = [UIAlertAction
                                actionWithTitle:@"Mood Graph"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [appDelegate addChargementLoader];
                                    [self getMoodGraphToShare];
                                }];
    [alert addAction:btnMoodGraph];

    UIAlertAction *btnImpactQ = [UIAlertAction
                                   actionWithTitle:@"Impact Questions"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                       [self designBeforeImpactQ];
                                   }];
//    [alert addAction:btnImpactQ];

    UIAlertAction *btnAssessmentForm = [UIAlertAction
                                 actionWithTitle:@"Assessment Form"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     //Handle your yes please button action here
                                     [self getData];
                                 }];
    [alert addAction:btnAssessmentForm];
    
    UIAlertAction *btnCancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     //Handle your yes please button action here

                                 }];
    [alert addAction:btnCancel];

    [appDelegate.navControl.topViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showAssessmentForm
{
    AssessmentFormView *viewAF = [[AssessmentFormView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight)];
    viewAF.backgroundColor = [UIColor whiteColor];
    [viewAF getAllQuestionsWebServiceCall:[self.dictAppointment objectForKey:@"clun01"]];
    [self.view addSubview:viewAF];
}


- (void)getData
{
    //[btnAssessmentForm setUserInteractionEnabled:NO];
    
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
        
        NSString *clun = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"clun01"]];
        NSString *qid = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"qid"]];
        
        NSString *clun1 = [clun stringByReplacingOccurrencesOfString:@"(\n" withString:@""];
        NSString *clun2 = [clun1 stringByReplacingOccurrencesOfString:@"\n)" withString:@""];
        NSString *clun3 = [clun2 stringByReplacingOccurrencesOfString:@"\""withString:@""];
        NSString *strClun01 = [clun3 stringByReplacingOccurrencesOfString:@"    "withString:@""];
        
        NSString *qid1 = [qid stringByReplacingOccurrencesOfString:@"(\n" withString:@""];
        NSString *qid2 = [qid1 stringByReplacingOccurrencesOfString:@"\n)" withString:@""];
        NSString *qid3 = [qid2 stringByReplacingOccurrencesOfString:@"\""withString:@""];
        NSString *strQid = [qid3 stringByReplacingOccurrencesOfString:@"    "withString:@""];
        
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

- (void)getMoodGraphToShare
{
    viewMessageDetails.txtFieldMessage.frame = CGRectMake(56, 7, self.view.frame.size.width-100, 30);
//    viewMessageDetails.btnShareMoodGraph.hidden = YES;
//    [self showMoodVC];
//    [objBookedAppointment setObject:@"true" forKey:@"MoodGraph"];

    
    //{"requestData":{"apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R","requestType":"sendMoodGraph", "appointmentid":"kareena1482992867002"}}
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[dictAppointment objectForKey:@"apntmnt_id"], nil] forKeys:[NSArray arrayWithObjects:@"apntmnt_id", nil]];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getMoodGraph", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:requestData forKey:@"requestData"];

    [appCounsellingChatParser sharedManager].strMethod = @"getMoodGraph";
    [[appCounsellingChatParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict)
     {
         strMoodGraphURL = @"";

         strMoodGraphURL = @"";
         if(responseDict != nil && [responseDict isKindOfClass:[NSString class]]) {
             strMoodGraphURL = (NSString *)responseDict;
         }
         else  {
             [self showAlertMessage:@"MoodGraph is not shared by user."];
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [appDelegate removeChargementLoader];
             [self showMoodGraph];
         });
     } failure:^(NSError *error) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             if(appDelegate.isServerswitched == NO){
                 [appDelegate switchServer];
                 [self getMoodGraphToShare];
             }
             else {
                 [appDelegate removeChargementLoader];
             }
         });
     }];
}

-(void)showMoodGraph{
    
    [txtFieldMessage resignFirstResponder];

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


#pragma mark - Ratting Insert Mthod

- (void)insertRattingQuestions
{
    if(dictAppointment && appDelegate.isNetAvailable)
    {
        AppCounsellingChatBL *objAppCounsellingBL = [[AppCounsellingChatBL alloc] init];
        [objAppCounsellingBL setRattingQuestionsToUpdate:dictAppointment];//APPOINTMENTID
    }
}

#pragma mark - SINCH METHODS
//Chnage By Mahendra
- (id<SINClient>)client {
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] client];
}
//Change By Mahenda
#pragma mark - SINCallClientDelegate

- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call
{
    self.CallVC.call = nil;
    self.CallVC = nil;
    
    if(self.CallVC==nil)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"VideoCall" bundle:nil];
        self.CallVC = (CallViewController *)[sb instantiateViewControllerWithIdentifier:@"CallViewController"];
        self.CallVC.strUserFirstName = [self getDycryptString:[dictAppointment objectForKey:@"user_firstname"]];
        
        self.CallVC.call = call;
        //self.CallVC.delegate = self;
        
    }
    if(self.navigationController)
        [self.navigationController pushViewController:self.CallVC animated:YES];
    else
        [self presentViewController:self.CallVC animated:YES completion:nil];
}

- (SINLocalNotification *)client:(id<SINClient>)client localNotificationForIncomingCall:(id<SINCall>)call {
    SINLocalNotification *notification = [[SINLocalNotification alloc] init];
    notification.alertAction = @"Answer";
    notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", [call remoteUserId]];
    return notification;
}

- (void)startCallingToYoungPerson
{
    //if ([self.CallName length] > 0 && [self.client isStarted]) {
    
    BOOL isStarted = [self.client isStarted];
    if (isStarted)
    {
        self.CallVC.call = nil;
        self.CallVC = nil;
        
        if(self.CallVC==nil)
        {
            [self makeAttendanceWithObjectID];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"VideoCall" bundle:nil];
            self.CallVC = (CallViewController *)[sb instantiateViewControllerWithIdentifier:@"CallViewController"];
            self.CallVC.strUserFirstName = [self getDycryptString:[dictAppointment objectForKey:@"user_firstname"]];
            
            NSString *strUserID = [dictAppointment objectForKey:@"clun01"];
            NSString *strCallingMode = [dictAppointment objectForKey:@"mode"];
            
            id<SINCall> call;
            
            if([strCallingMode.lowercaseString isEqualToString:@"video"])
            {
                self.CallVC.remoteVideoView.hidden = NO;
                call = [self.client.callClient callUserVideoWithId:strUserID];
            }
            else
            {
                self.CallVC.remoteVideoView.hidden = YES;
                call = [self.client.callClient callUserWithId:strUserID];
            }

            self.CallVC.call = call;
            //self.CallVC.delegate = self;
            
        }
        if(self.navigationController)
            [self.navigationController pushViewController:self.CallVC animated:YES];
        else
            [self presentViewController:self.CallVC animated:YES completion:nil];
    }
}

- (void)makeAttendanceWithObjectID
{
    [viewMessageDetails sendMessageForCallingAction];
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
