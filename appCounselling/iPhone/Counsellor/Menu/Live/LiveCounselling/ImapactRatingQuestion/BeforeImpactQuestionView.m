//
//  BeforeImpactQuestionView.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 21/03/17.
//  Copyright © 2017 iDevz. All rights reserved.
//

#import "BeforeImpactQuestionView.h"
#import "AppDelegate.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"

#define strKeyWebService @"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R"
#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation BeforeImpactQuestionView

@synthesize strUsername;
@synthesize strAppointmentId;
@synthesize strCounsellorId;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alpha = 0.0;
        
        CGFloat screenWidth = frame.size.width;

        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.isServerswitched = NO;
        arrQuestions = [[NSMutableArray alloc] init];
        arrAnswers = [[NSMutableArray alloc] init];
        
        scrlViewBG = [[UIScrollView alloc] initWithFrame:frame];
        [self addSubview:scrlViewBG];
        scrlViewBG.bounces = NO;
        
        if(screenWidth<768)
        {
            scrlViewBG.contentSize = CGSizeMake(screenWidth+180, scrlViewBG.contentSize.height);
            tblQuestions = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth+180, frame.size.height)];
        }
        else
        {
            scrlViewBG.contentSize = CGSizeMake(768, scrlViewBG.contentSize.height);
            tblQuestions = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, frame.size.height)];
        }

        tblQuestions.bounces = NO;
        tblQuestions.delegate = self;
        tblQuestions.dataSource = self;
        [scrlViewBG addSubview:tblQuestions];
        
        UIButton *btnLatter = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 40)];
        btnLatter.backgroundColor = colorHeader;
        [btnLatter setTitle:@"DONE" forState:UIControlStateNormal];
        [self addSubview:btnLatter];
        [btnLatter addTarget:self action:@selector(submitQuestion) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)submitQuestion
{
    [self removeFromSuperview];
}

#pragma mark - delegate

- (void)answerForQuestion:(NSMutableDictionary *)dictAnswer
{
    if(dictAnswer)
    {
        //{"appointmentid":"","counsellorid":"","question":"I’ve felt edgy or nervous","question_id":"1","rating":"","userid":""}
        
        [dictAnswer setObject:strAppointmentId?strAppointmentId:@"102" forKey:@"appointmentid"];
        [dictAnswer setObject:strCounsellorId?strCounsellorId:@"102" forKey:@"counsellorid"];
        [dictAnswer setObject:strUsername?strUsername:@"102" forKey:@"username"];

        if(![arrAnswers containsObject:dictAnswer])
            [arrAnswers addObject:dictAnswer];
    }
    
    
    NSLog(@"arrAnswers = %@", arrAnswers);
}

#pragma mark - Parser

- (void)getAllQuestionsWebServiceCall
{

//    {
//        "requestData": {
//            "apikey": "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "requestType": "getAllImpactRatting",
//            "data":{
//                "appointmentid":"qMTrir5/a7Nota+tQwdxTA\u003d\u003d1493785804878"
//            },
//        }
//    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strAppointmentId, nil] forKeys:[NSArray arrayWithObjects:@"appointmentid", nil]];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"getAllImpactRatting", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:requestData forKey:@"requestData"];
    NSLog(@"arrAnswers = %@", dictParameter);

    //PendingFriendRequest
    [[ImpactQuestionParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        [arrQuestions removeAllObjects];
        
        if([responseDict isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dictData in responseDict)
            {
                [arrQuestions addObject:dictData];
            }
            NSLog(@"Request sent");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(arrQuestions.count>0)
            {
                self.alpha = 1.0;
                [appDelegate removeChargementLoader];
                [tblQuestions reloadData];
            }
            else
            {
                [appDelegate removeChargementLoader];
                [self showAlertMessage:@"User did not fill the Impact Questions"];
                [self removeFromSuperview];
            }
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getAllQuestionsWebServiceCall];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];
}

- (void)showAlertMessage:(NSString *)strMessage
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:strMessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:yesButton];
    [appDelegate.navControl.topViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITAbleView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    viewFooter.backgroundColor = [UIColor clearColor];
    
//    UILabel *lblTitle = [[UILabel alloc] init];
//    lblTitle.frame = CGRectMake(10, 5, 300, 30);
//    lblTitle.font = [UIFont boldSystemFontOfSize:20.0];
//    lblTitle.textAlignment = NSTextAlignmentCenter;
//    lblTitle.text = @"Thankk you for answering these question.";
//    lblTitle.backgroundColor = [UIColor clearColor];
//    lblTitle.textColor = [UIColor whiteColor];
//    [viewFooter addSubview:lblTitle];

    return viewFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewMainHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 110)];
    viewMainHeader.backgroundColor = colorHeader;

    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake((appDelegate.screenWidth-200)/2.0, 20, 200, 30);
    lblTitle.font = [UIFont boldSystemFontOfSize:20.0];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"Impact Questions";
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    [viewMainHeader addSubview:lblTitle];

    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 30, tableView.frame.size.width, 80)];
    viewHeader.backgroundColor = [UIColor clearColor];
    
    CGFloat screenWidth = appDelegate.screenWidth;
    
    if(screenWidth>=768)
        screenWidth = 600;
    
    UILabel *lblDate = [[UILabel alloc] init];
    lblDate.frame = CGRectMake(10, 30, 200, 50);
    lblDate.font = [UIFont boldSystemFontOfSize:20.0];
    lblDate.text = @"Over the last week...";
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textColor = [UIColor whiteColor];
    [viewHeader addSubview:lblDate];
    
    float degrees = -50; //the value in degrees
    
    UILabel *lblRat1 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-100, 20, 80, 40)];
    lblRat1.font = [UIFont systemFontOfSize:14.0];
    lblRat1.numberOfLines = 2;
    lblRat1.text = @"Not at all";
    lblRat1.textColor = [UIColor whiteColor];
    lblRat1.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:lblRat1];
    
    lblRat1.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
    
    UILabel *lblRat2 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-50, 20, 80, 40)];
    lblRat2.font = [UIFont systemFontOfSize:14.0];
    lblRat2.numberOfLines = 2;
    lblRat2.text = @"Only occasionally";
    lblRat2.textColor = [UIColor whiteColor];
    lblRat2.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:lblRat2];
    
    lblRat2.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
    
    UILabel *lblRat3 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth, 20, 80, 40)];
    lblRat3.font = [UIFont systemFontOfSize:14.0];
    lblRat3.numberOfLines = 2;
    lblRat3.text = @"Sometimes";
    lblRat3.textColor = [UIColor whiteColor];
    lblRat3.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:lblRat3];
    
    lblRat3.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
    
    UILabel *lblRat4 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth+50, 20, 80, 40)];
    lblRat4.font = [UIFont systemFontOfSize:14.0];
    lblRat4.numberOfLines = 2;
    lblRat4.text = @"Often";
    lblRat4.textColor = [UIColor whiteColor];
    lblRat4.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:lblRat4];
    
    lblRat4.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
    
    UILabel *lblRat5 = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth+100, 20, 80, 40)];
    lblRat5.font = [UIFont systemFontOfSize:14.0];
    lblRat5.numberOfLines = 2;
    lblRat5.text = @"Most or all of the time";
    lblRat5.textColor = [UIColor whiteColor];
    lblRat5.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:lblRat5];
    
    lblRat5.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
    
    [viewMainHeader addSubview:viewHeader];
    
    return viewMainHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrQuestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictQuestion = [arrQuestions objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [dictQuestion objectForKey:@"objectId"];
    
    BeforeImpactQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = (BeforeImpactQuestionCell *)[[BeforeImpactQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.dictQuestion = [NSMutableDictionary dictionaryWithDictionary:dictQuestion];
    }
    
    NSString *strQ = [dictQuestion objectForKey:@"clque01"];
    strQ = [self getDycryptString:strQ];
    
    cell.lblQuestion.text = [NSString stringWithFormat:@"%i. %@", (int)indexPath.row+1, strQ];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.textColor = colorViewBg;
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    
    [cell setRatingOfTheQuestion];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSString *)getDycryptString:(NSString *)secret  {
    
    NSString *key = [[[StringEncryption alloc] init] sha256:@"newapp17mindcrew" length:32];
    NSString *iv = @"mindcrewnewapp17";
    
    NSData * encryptedData = [NSData dataWithBase64EncodedString:secret];
    
    encryptedData = [[[StringEncryption alloc] init] decrypt:encryptedData key:key iv:iv];
    
    NSString * decryptedText = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    
    return decryptedText;
}
@end
