//
//  AppCounsellingRattingViewController.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 03/10/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import "AppCounsellingRattingViewController.h"
#import "CounsellorHomeViewController.h"
#import "appCounsellingLoginParser.h"

@interface AppCounsellingRattingViewController ()

@end

@implementation AppCounsellingRattingViewController

@synthesize dictAppointment;
@synthesize rateView1;
@synthesize arrRattingQuestions;

@synthesize strClcnslrun01;
@synthesize strClun01;
@synthesize strQid;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alertView.hidden = YES;

    
    intCommentCount = 0;
    // Do any additional setup after loading the view.
    [self designTopBar];
    [self showBackButton];
    self.view.backgroundColor = colorViewBg;

    if(arrRattingQuestions==nil)
        arrRattingQuestions = [[NSMutableArray alloc] init];
    
    objAppCounsellingBL = [[AppCounsellingChatBL alloc] init];
    objAppCounsellingBL.callBack = self;
    
    lblTitle.text = @"RATTING";
    isPopUpShown=NO;
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self screenDesigning];
}

// change by Deepak
- (void)showPopup
{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:@"Would you like to add 2 additional session for this client?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [self getSessionInctement];
                                    
                                }];
    [alert addAction:yesButton];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   if(isRattingPending==NO)
                                   {
                                       [self showPopUpsForComment];
                                   }
                                   else if(isPopUpShown==NO)
                                   {
                                       isPopUpShown=YES;
                                       if(dictAppointment)
                                           [self showAlertMessage:@"Your counselling time is over. Please rate the User."];
                                   }                               }];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];

}

// change by pavan
- (void)getSessionInctement
{
    [appDelegate addChargementLoader];

    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
     NSString *username = [appDelegate.dictProfile objectForKey:@"username"];
    NSLog(@"username=%@", username);
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: strClcnslrun01,strClun01,@"2",strQid, nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01",@"clun01",@"session",@"qid",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"increaseUserSession", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"increaseUserSession = %@", dictParameter);
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        [appDelegate removeChargementLoader];

        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"is_shown_popup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];

            if(isRattingPending==NO)
            {
                [self showPopUpsForComment];
            }
            else if(isPopUpShown==NO)
            {
                isPopUpShown=YES;
                if(dictAppointment)
                    [self showAlertMessage:@"Your counselling time is over. Please rate the User."];
            }
        });

    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getPendingQuestions];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.alertView.hidden = YES;

    if(dictAppointment && (arrRattingQuestions==nil || arrRattingQuestions.count==0))
        [self getRattingQuestions];
    else
        [self showPopUpsForRatting];
}

-(void)screenDesigning
{
    CGFloat yRef = 0.0;
    CGFloat ySpace = 0.0;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, yRef, self.view.frame.size.width, 55)];
    topView.backgroundColor = colorHeader;
    [self.view addSubview:topView];
    
    yRef = 20.0;
    UILabel  *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, yRef, self.view.frame.size.width, 35)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor= [UIColor whiteColor];
    titleLbl.text = @"appCounselling";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLbl];
    
//    [self showBackButtonNoBar];
    
    yRef = 55;
    ySpace = 0.0;
    
    if(self.view.frame.size.height>=568)
    {
        yRef = 80;
        ySpace = 10.0;
    }
    
    UILabel *lblBookingDetail = [[UILabel alloc] initWithFrame:CGRectMake(40, yRef, self.view.frame.size.width-80, 40)];
    lblBookingDetail.numberOfLines = 0;
    lblBookingDetail.font = [UIFont systemFontOfSize:14.0];
    lblBookingDetail.text = @"";//@"Your user will not see these feedback ratings.";
    lblBookingDetail.textAlignment = NSTextAlignmentCenter;
    lblBookingDetail.textColor = colorWhiteOrBlack;
    [self.view addSubview:lblBookingDetail];
    
//    yRef = yRef+lblBookingDetail.frame.size.height+5+ySpace;
}

- (void)hideMe
{
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[CounsellorHomeViewController class]] ) {
            
            CounsellorHomeViewController *groupViewController = (CounsellorHomeViewController*)viewController;
//            groupViewController.objLiveVC.isCommingFromCounselling = NO;
//            groupViewController.objLiveVC.isc = NO;
            if(self.navigationController)
                [self.navigationController popToViewController:groupViewController animated:YES];
            else
                [appDelegate.navControl popToViewController:groupViewController animated:YES];
        }
    }
}

#pragma mark - Show Ratting Views
- (void)showPopUpsForRatting
{
    isRattingPending = NO;
    
    for (int i=0 ; i<arrRattingQuestions.count; i++)
    {
        
        dictCurrQuestion = nil;
        dictCurrQuestion = [arrRattingQuestions objectAtIndex:i];
        //NSString *strStatus = [dictCurrQuestion objectForKey:@"status"];
        NSNumber *numRatCount = [dictCurrQuestion objectForKey:@"rattingcount"];
        
        if(numRatCount.intValue==0)//[strStatus isEqualToString:@"Pending"] &&
        {
            isRattingPending = YES;
            [self showRattingQuestion];
            break;
        }else
        {
            [self showAlertForIncreaseSession];
        }
    }
}

- (void)addNote{
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        NSLog(@"IPAD");
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-300, self.view.frame.size.height/2-200, 600, 400)];
        self.alertView.backgroundColor = [UIColor lightGrayColor];
        self.alertView.layer.cornerRadius = 10;
        
        [self.view addSubview: self.alertView];
        
        
        UILabel *Lbl_Header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.alertView.frame.size.width, 70)];
        Lbl_Header.backgroundColor = [UIColor colorWithRed:00.0f/255.0f
                                                     green:181.0f/255.0f
                                                      blue:170.0f/255.0f
                                                     alpha:1.0f];
        [Lbl_Header setFont:[UIFont systemFontOfSize:24.0]];
        Lbl_Header.text = @"Write note";
        Lbl_Header.textAlignment = UITextAlignmentCenter;
        Lbl_Header.textColor = [UIColor whiteColor];
        [self.alertView addSubview: Lbl_Header];
        
        CGRect textViewFrame = CGRectMake(10.0f, 80.0f, 580.0f, 240.0f);
        self.textView = [[UITextView alloc] initWithFrame:textViewFrame];
        self.textView.returnKeyType = UIReturnKeyDone;
        [self.textView setFont:[UIFont systemFontOfSize:18.0]];
        self.textView.textColor = [UIColor blackColor];
        
        [self.alertView addSubview:self.textView];
        
        Placeholder_LB_TV = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0,_textView.frame.size.width - 10.0, 34.0)];
        
        //[lbl setText:kDescriptionPlaceholder];
        [Placeholder_LB_TV setBackgroundColor:[UIColor clearColor]];
        Placeholder_LB_TV.text = @"Write your note";
        [Placeholder_LB_TV setFont:[UIFont systemFontOfSize:18.0]];
        [Placeholder_LB_TV setTextColor:[UIColor lightGrayColor]];
        [Placeholder_LB_TV setTextAlignment:NSTextAlignmentLeft];
        _textView.delegate = self;
        
        [_textView addSubview:Placeholder_LB_TV];
        
        self.textView.delegate = self;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(addNote_submt)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Submit" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:00.0f/255.0f
                                                 green:181.0f/255.0f
                                                  blue:170.0f/255.0f
                                                 alpha:1.0f];
        button.frame = CGRectMake(0.0, 330.0, 600,70.0);
        button.layer.cornerRadius = 10;
        [button setFont:[UIFont systemFontOfSize:24.0]];

        [self.alertView addSubview:button];
        
        UIButton *butto_Close = [UIButton buttonWithType:UIButtonTypeCustom];
        [butto_Close addTarget:self
                        action:@selector(close)
              forControlEvents:UIControlEventTouchUpInside];
        [butto_Close setTitle:@"" forState:UIControlStateNormal];
        butto_Close.frame = CGRectMake(self.alertView.frame.size.width - 50, 0.0, 50.0,50.0);
        UIImage *btnImage = [UIImage imageNamed:@"close.png"];
        [butto_Close setImage:btnImage forState:UIControlStateNormal];
        
        butto_Close.backgroundColor = [UIColor clearColor];
        [self.alertView addSubview:butto_Close];
    }else{
        NSLog(@"IPHONE");
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-225, 300, 260)];
        self.alertView.backgroundColor = [UIColor lightGrayColor];
        self.alertView.layer.cornerRadius = 10;
        
        [self.view addSubview: self.alertView];
        
        
        UILabel *Lbl_Header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.alertView.frame.size.width, 50)];
        Lbl_Header.backgroundColor = [UIColor colorWithRed:00.0f/255.0f
                                                     green:181.0f/255.0f
                                                      blue:170.0f/255.0f
                                                     alpha:1.0f];
        Lbl_Header.text = @"Write note";
        Lbl_Header.textAlignment = UITextAlignmentCenter;
        Lbl_Header.textColor = [UIColor whiteColor];
        [self.alertView addSubview: Lbl_Header];
        
        CGRect textViewFrame = CGRectMake(10.0f, 60.0f, 280.0f, 140.0f);
        self.textView = [[UITextView alloc] initWithFrame:textViewFrame];
        self.textView.returnKeyType = UIReturnKeyDone;
        //self.textView.text = @"Write your note";
        self.textView.textColor = [UIColor blackColor];
        
        [self.alertView addSubview:self.textView];
        
        Placeholder_LB_TV = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0,_textView.frame.size.width - 10.0, 34.0)];
        
        //[lbl setText:kDescriptionPlaceholder];
        [Placeholder_LB_TV setBackgroundColor:[UIColor clearColor]];
        Placeholder_LB_TV.text = @"Write your note";
        [Placeholder_LB_TV setFont:[UIFont systemFontOfSize:13.0]];
        [Placeholder_LB_TV setTextColor:[UIColor lightGrayColor]];
        [Placeholder_LB_TV setTextAlignment:NSTextAlignmentLeft];
        _textView.delegate = self;
        
        [_textView addSubview:Placeholder_LB_TV];
        
        self.textView.delegate = self;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(addNote_submt)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Submit" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:00.0f/255.0f
                                                 green:181.0f/255.0f
                                                  blue:170.0f/255.0f
                                                 alpha:1.0f];
        button.frame = CGRectMake(0.0, 210.0, 300,50.0);
        button.layer.cornerRadius = 10;
        
        [self.alertView addSubview:button];
        
        UIButton *butto_Close = [UIButton buttonWithType:UIButtonTypeCustom];
        [butto_Close addTarget:self
                        action:@selector(close)
              forControlEvents:UIControlEventTouchUpInside];
        [butto_Close setTitle:@"" forState:UIControlStateNormal];
        butto_Close.frame = CGRectMake(self.alertView.frame.size.width - 50, 0.0, 50.0,50.0);
        UIImage *btnImage = [UIImage imageNamed:@"close.png"];
        [butto_Close setImage:btnImage forState:UIControlStateNormal];
        
        butto_Close.backgroundColor = [UIColor clearColor];
        [self.alertView addSubview:butto_Close];
    }

   
}
- (void)addNote_submt {
    ///self.alertView.hidden = YES;
    if (![self.textView.text  isEqual: @"Write your note"] && self.textView.text.length > 0 )
    {
        NSLog(@"Hello bro");
        [self addNoteAPICall];
    }
    else
    {
        NSLog(@"empty");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"Please enter note."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)close {
    NSLog(@"close");
    self.alertView.hidden = YES;
    [self showPopUpForFeedback];
}

//- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
//    self.textView.text = @"";
//    self.textView.textColor = [UIColor blackColor];
//    return YES;
//}

-(void) textViewDidChange:(UITextView *)textView {
    
    if(self.textView.text.length == 0) {
        
            Placeholder_LB_TV.hidden = NO;
        } else {
            Placeholder_LB_TV.hidden = YES;
        }

//        self.textView.textColor = [UIColor lightGrayColor];
//       // self.textView.text = @"Write your note";
//        [self.textView resignFirstResponder];
    //}
}

//MARK:- add Note

- (void)addNoteAPICall
{
    [appDelegate addChargementLoader];
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSString *username = [appDelegate.dictProfile objectForKey:@"username"];
    NSLog(@"username=%@", username);
    
    NSString *strNote = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *strEncNote = [super getEncryptedString:strNote];
    NSLog(@"Encription = %@", strEncNote);

    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: strClcnslrun01,strClun01,strEncNote, nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01",@"clun01",@"notes",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"addCounsellorNotes", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"addCounsellorNotes = %@", dictParameter);
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        [appDelegate removeChargementLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            
            NSString *str = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"status"]];
            NSLog(@"increaseUserSession = %@", str);

            self.alertView.hidden = YES;
            [self showPopUpForFeedback];
            
        });
        
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

- (void)showAlertForIncreaseSession
{
    [appDelegate addChargementLoader];
    NSString *strAppointmentID = [dictCurrQuestion objectForKey:@"apntmnt_id"];
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: strAppointmentID, nil] forKeys:[NSArray arrayWithObjects: @"apntmnt_id",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAppointmentById", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"getAppointmentById = %@", dictParameter);
    //[appCounsellingLoginParser sharedManager].strMethod = @"getCounsellorQuestions";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        NSLog(@"strClcnslrun01=%@", responseDict);

        NSString *str = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"clcnslrun01"]];
        NSString *clun = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"clun01"]];
        NSString *qid = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"qid"]];
        
        NSString *session_left = [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"session_left"]];
        
        NSString *str1 = [str stringByReplacingOccurrencesOfString:@"(\n" withString:@""];
        NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\n)" withString:@""];
        NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        strClcnslrun01 = [str3 stringByReplacingOccurrencesOfString:@"    "withString:@""];

        NSString *clun1 = [clun stringByReplacingOccurrencesOfString:@"(\n" withString:@""];
        NSString *clun2 = [clun1 stringByReplacingOccurrencesOfString:@"\n)" withString:@""];
        NSString *clun3 = [clun2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        strClun01 = [clun3 stringByReplacingOccurrencesOfString:@"    "withString:@""];

        NSString *qid1 = [qid stringByReplacingOccurrencesOfString:@"(\n" withString:@""];
        NSString *qid2 = [qid1 stringByReplacingOccurrencesOfString:@"\n)" withString:@""];
        NSString *qid3 = [qid2 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        strQid = [qid3 stringByReplacingOccurrencesOfString:@"    "withString:@""];

        NSString *session_left1 = [session_left stringByReplacingOccurrencesOfString:@"(\n" withString:@""];
        NSString *session_left2 = [session_left1 stringByReplacingOccurrencesOfString:@"\n)" withString:@""];
        NSString *session_left3 = [session_left2 stringByReplacingOccurrencesOfString:@"\""withString:@""];
        NSString *session_left4 = [session_left3 stringByReplacingOccurrencesOfString:@" "withString:@""];

        NSLog(@"strClcnslrun01=%@", strClcnslrun01);
        NSLog(@"strClun01=%@", strClun01);
        NSLog(@"strQid=%@", session_left4);
        [appDelegate removeChargementLoader];

        if([session_left4 isEqualToString:@"1"])
        {

            [appDelegate removeChargementLoader];

            if (![[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"is_shown_popup"]] isEqualToString:@"yes"]) {
            
                [self showPopup];
                
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if(isRattingPending==NO)
                    {
                        [self showPopUpsForComment];
                    }
                    else if(isPopUpShown==NO)
                    {
                        isPopUpShown=YES;
                        if(dictAppointment)
                            [self showAlertMessage:@"Your counselling time is over. Please rate the User."];
                    }
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate removeChargementLoader];

                if(isRattingPending==NO)
                {
                    [self showPopUpsForComment];
                }
                else if(isPopUpShown==NO)
                {
                    isPopUpShown=YES;
                    if(dictAppointment)
                        [self showAlertMessage:@"Your counselling time is over. Please rate the User."];
                }
            });
        }
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate removeChargementLoader];
            
            [self showAlertMessage:@"Server not responding"];
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
               // [self getPendingQuestions];
            }
        });
    }];
//    if(isRattingPending==NO)
//    {
//        [self showPopUpsForComment];
//    }
//    else if(isPopUpShown==NO)
//    {
//        isPopUpShown=YES;
//        if(dictAppointment)
//            [self showAlertMessage:@"Your counselling time is over. Please rate the User."];
//    }
}

- (void)showRattingQuestion
{
    self.overlay1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.overlay1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    self.overlay1.alpha = 0.75;
    [self.view addSubview:self.overlay1];
    
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        self.rateView1 = [[RateView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2.0)-100, self.view.frame.size.height/2-50, 202, 100)];
    else
        self.rateView1 = [[RateView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2.0)-200, self.view.frame.size.height/2-50, 400, 110)];
    
    NSString *strQuestion = [dictCurrQuestion objectForKey:@"questiontext"];
    self.rateView1.strQuestionText = [self getDycryptString:strQuestion];
    self.rateView1.delegate = self;
    self.rateView1.layer.cornerRadius = 20.0f;
    self.rateView1.tag = 101;
    self.rateView1.clipsToBounds = NO;
    [self.view addSubview:self.rateView1];
}

- (void)showPopUpsForComment
{
    self.alertView.hidden = NO;
    [self addNote];
}

- (void)showPopUpForFeedback{
    isCommentPending = NO;
    
    for (int i=0 ; i<arrRattingQuestions.count; i++)
    {
        dictCurrQuestion = nil;
        dictCurrQuestion = [arrRattingQuestions objectAtIndex:i];
        NSString *strStatus = [dictCurrQuestion objectForKey:@"status"];
        
        if([strStatus isEqualToString:@"Pending"])
        {
            isCommentPending = YES;
            [self showFeedbackQuestion];
            break;
        }
    }
    
    if(isCommentPending==NO)
    {
        [self hideMe];
    }
}
- (void)showFeedbackQuestion
{
    float yRef = 20;
    
    self.overlayFeedback = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.overlayFeedback.backgroundColor = [UIColor colorWithRed:226/255.0f green:230/255.0f blue:220/255.0f alpha:1.0];
    [self.view addSubview:self.overlayFeedback];
    
    UILabel *lblFeedbackTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, yRef, appDelegate.screenWidth-40, 60)];
    lblFeedbackTitle.text = @"Please give any comment on the questions(if needed/optional)";
    lblFeedbackTitle.numberOfLines = 2;
    lblFeedbackTitle.textAlignment = NSTextAlignmentCenter;
    lblFeedbackTitle.backgroundColor = [UIColor clearColor];
    [self.overlayFeedback addSubview:lblFeedbackTitle];
    
    yRef = yRef + lblFeedbackTitle.frame.size.height;
    
    lblFeedbackTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, yRef, appDelegate.screenWidth-40, 1)];
    lblFeedbackTitle.backgroundColor = [UIColor blackColor];
    [self.overlayFeedback addSubview:lblFeedbackTitle];
    
    float height = 80;
    
    for (int i=0 ; i<arrRattingQuestions.count; i++)
    {
        NSDictionary *diciQ = [arrRattingQuestions objectAtIndex:i];
        NSString *strQuestion = [diciQ objectForKey:@"questiontext"];

        UILabel *lblFeedback1 = [[UILabel alloc] initWithFrame:CGRectMake(20, yRef, appDelegate.screenWidth-40, height)];
        lblFeedback1.text = [self getDycryptString:strQuestion];
        lblFeedback1.font = [UIFont systemFontOfSize:14.0];
        lblFeedback1.numberOfLines = 2;
        lblFeedback1.textColor = [UIColor grayColor];
        lblFeedback1.textAlignment = NSTextAlignmentCenter;
        [self.overlayFeedback addSubview:lblFeedback1];
        
        yRef = yRef + height;
        
        UITextView *txtViewFeedback1 = [[UITextView alloc] init];
        txtViewFeedback1.tag = 100+i;
        txtViewFeedback1.returnKeyType = UIReturnKeyNext;
        txtViewFeedback1.delegate = self;
        txtViewFeedback1.frame = CGRectMake(20, yRef, appDelegate.screenWidth-40, height);
        txtViewFeedback1.backgroundColor = [UIColor whiteColor];
        [self.overlayFeedback addSubview:txtViewFeedback1];

        yRef = yRef + height;
    }
    yRef = yRef+20;
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(20, yRef, appDelegate.screenWidth-40, 35)];
    btnSubmit.layer.cornerRadius = 5.0;
    btnSubmit.backgroundColor = colorHeader;
    btnSubmit.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [btnSubmit addTarget:self action:@selector(btnSubmitClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    [self.overlayFeedback addSubview:btnSubmit];
 
    if(yRef<self.view.frame.size.height)
        self.overlayFeedback.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+300);
    else
        self.overlayFeedback.contentSize = CGSizeMake(self.view.frame.size.width, yRef+300);
    
}

- (void)btnSubmitClicked
{
    self.overlayFeedback.contentOffset = CGPointMake(0, 0);
    //self.overlayFeedback.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.overlayFeedback removeFromSuperview];
    
    for (int i=0 ; i<arrRattingQuestions.count; i++)
    {
        dictCurrQuestion = nil;
        dictCurrQuestion = [arrRattingQuestions objectAtIndex:i];
        NSString *strStatus = [dictCurrQuestion objectForKey:@"status"];
        
        if([strStatus isEqualToString:@"Pending"])
        {
            UITextView *txtViewFeedback = (UITextView *)[self.overlayFeedback viewWithTag:100+i];
            [self commentTheQuestion:dictCurrQuestion withRatting:txtViewFeedback.text];
            break;
        }
    }
}

-(void)hideRate{
    
    [self.overlay1 removeFromSuperview];
    [self.rateView1 removeFromSuperview];
}

- (void)submittClickedForRattingView:(RateView *)viewRate
{
    int rattingCount = [viewRate.rating intValue];
    if(rattingCount>0)
    {
        [self.overlay1 removeFromSuperview];
        [self.rateView1 removeFromSuperview];
        
        [appDelegate addChargementLoader];
        [self rateTheQuestion:dictCurrQuestion withRatting:viewRate.rating];
    }
    else
    {
        [self showAlertMessage:@"Rating can not be blank"];
    }
}

-(void)hideRateView:(NSNumber *)newRating{
    
    //    PFObject *rating = [PFObject objectWithClassName:@"Rating"];
    //    [rating setObject:self.selectedOrg forKey:@"org"];
    //    [rating setObject:[PFUser currentUser] forKey:@"user"];
    //    [rating setObject:newRating forKey:@"stars"];
    //    [rating saveInBackground];
    //
    //    [self.selectedOrg addObject:[PFUser currentUser].objectId forKey:@"usersRated"];
    //    [self.selectedOrg saveInBackground];
    
}
#pragma mark - Ratting Parser

- (void)getPendingQuestions
{
    
    //    {
    //        "requestData": {
    //            "apikey": "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
    //            "data": {
    //                "counsellorid":"rizwan1"
    //            },
    //            "requestType": "getCounsellorQuestions"
    //        }
    //    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], nil] forKeys:[NSArray arrayWithObjects: @"counsellorid",nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getCounsellorQuestions", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    NSLog(@"getCounsellorQuestions = %@", dictParameter);
    [appCounsellingLoginParser sharedManager].strMethod = @"getCounsellorQuestions";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        [arrRattingQuestions removeAllObjects];
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dictData in responseDict)
            {
                [arrRattingQuestions addObject:dictData];
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [appDelegate removeChargementLoader];
            [self showPopUpsForRatting];
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showAlertMessage:@"Data not found"];
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getPendingQuestions];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}
// Need to call when comming through Push Notification
- (void)getRattingQuestions
{
    
  
    [[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:@"ForbuttonHide10min"];
    
    if(dictAppointment && appDelegate.isNetAvailable)
    {
        [appDelegate addChargementLoader];
        [self getPendingQuestions];
//        [objAppCounsellingBL getRattingQuestionsToUpdate:dictAppointment];//APPOINTMENTID
    }
    else
    {
        [appDelegate removeChargementLoader];
    }
}

- (void)getRattingQuestionsToUpdateFinished:(NSArray *)arrQuestion
{
    [appDelegate removeChargementLoader];
    arrRattingQuestions = [[NSMutableArray alloc] initWithArray:arrQuestion];
    [self showPopUpsForRatting];
}

- (void)rateTheQuestion:(NSDictionary *)dictQuestion withRatting:(NSNumber *)rattingCount
{
    [appDelegate addChargementLoader];
    [objAppCounsellingBL rateTheQuestion:dictQuestion withRatting:rattingCount];
}

- (void)rateTheQuestionFinished:(NSNumber *)rattingCount
{
    [appDelegate removeChargementLoader];
    
    if([arrRattingQuestions containsObject:dictCurrQuestion])
    {
        int indexOfObject = [arrRattingQuestions indexOfObject:dictCurrQuestion];
        NSMutableDictionary *dictForComment = [[NSMutableDictionary alloc] initWithDictionary:dictCurrQuestion];
        [dictForComment setObject:rattingCount forKey:@"rattingcount"];
        
        [arrRattingQuestions replaceObjectAtIndex:indexOfObject withObject:dictForComment];
    }
    if(isRattingPending)
    {
        [self showPopUpsForRatting];
    }
}

- (void)commentTheQuestion:(NSDictionary *)dictQuestion withRatting:(NSString *)strComment
{
    [appDelegate addChargementLoader];
    [objAppCounsellingBL commentTheQuestion:dictQuestion withRatting:strComment];
}

- (void)commentTheQuestionFinished:(NSString *)strComment
{
    [appDelegate removeChargementLoader];

    if([arrRattingQuestions containsObject:dictCurrQuestion])
    {
        int indexOfObject = [arrRattingQuestions indexOfObject:dictCurrQuestion];
        NSMutableDictionary *dictForComment = [[NSMutableDictionary alloc] initWithDictionary:dictCurrQuestion];
        [dictForComment setObject:@"Done" forKey:@"status"];
        [dictForComment setObject:strComment forKey:@"comment"];
        
        [arrRattingQuestions replaceObjectAtIndex:indexOfObject withObject:dictForComment];
    }
    
    isCommentPending = NO;
    
    for (int i=0 ; i<arrRattingQuestions.count; i++)
    {
        dictCurrQuestion = [arrRattingQuestions objectAtIndex:i];
        NSString *strStatus = [dictCurrQuestion objectForKey:@"status"];
        
        if([strStatus isEqualToString:@"Pending"])
        {
            isCommentPending = YES;
            UITextView *txtViewFeedback = (UITextView *)[self.overlayFeedback viewWithTag:100+i];
            [self commentTheQuestion:dictCurrQuestion withRatting:txtViewFeedback.text];
            break;
        }
    }

    if(isCommentPending==NO)
        [self hideMe];
}

- (void)errorOccured:(NSError *)error
{
    [appDelegate removeChargementLoader];
}

#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    self.textView.text = @"";
//    self.textView.textColor = [UIColor blackColor];

     Placeholder_LB_TV.hidden = YES;
    
    int intOffset = textView.tag-100;
    self.overlayFeedback.contentOffset = CGPointMake(0, intOffset*120);

    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(self.textView.text.length == 0) {
        Placeholder_LB_TV.hidden = NO;
    } else {
        Placeholder_LB_TV.hidden = YES;
    }
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
#define MAX_LENGTH 200 // Whatever your limit is
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = (textView.text.length - range.length) + text.length;
    
    if(newLength <= MAX_LENGTH)
    {
        if([text isEqualToString:@"\n"])
        {
            int intOffset = textView.tag-100;
            self.overlayFeedback.contentOffset = CGPointMake(0, intOffset*120);
            
            UITextView *txtViewFeedback = (UITextView *)[self.overlayFeedback viewWithTag:textView.tag+1];
            if(txtViewFeedback)
                [txtViewFeedback becomeFirstResponder];
            else
                [txtViewFeedback resignFirstResponder];
        }
    }
    else
    {
        NSUInteger emptySpace = MAX_LENGTH - (textView.text.length - range.length);
        textView.text = [[[textView.text substringToIndex:range.location]
                          stringByAppendingString:[text substringToIndex:emptySpace]]
                         stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
        return NO;
    }
    
    return YES;
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
