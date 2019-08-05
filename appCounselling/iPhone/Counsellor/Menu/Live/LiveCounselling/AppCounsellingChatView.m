//
//  AppCounsellingChatView.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 30/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import "AppCounsellingChatView.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"

@implementation AppCounsellingChatView

@synthesize seconds;
@synthesize isQuestionUploaded;
@synthesize shouldUploadQuestion;

@synthesize dictAppointment;
@synthesize strMessageUserID;
@synthesize btnShareMoodGraph;
@synthesize txtFieldMessage;

- (void)clearMemory
{
    objChatBL.callBack=nil;
    objChatBL=nil;
    
    if(timer && [timer isValid])
    {
        [timer invalidate];
        timer=nil;
    }
    lblTitle=nil;
    
    if(self.arrMessages)
    {
        [self.arrMessages removeAllObjects];
        self.arrMessages=nil;
    }
    if(self.arrMessagesAudioVideo)
    {
        [self.arrMessagesAudioVideo removeAllObjects];
        self.arrMessagesAudioVideo=nil;
    }
    
    if(scrlViewMessage)
    {
//        for (UIView *view in scrlViewMessage.subviews) {
//            
//            if([view superview]!=nil){
//                [view removeFromSuperview];
//            }
//        }
            scrlViewMessage=nil;
    }

    txtFieldMessage.delegate=nil;
    txtFieldMessage=nil;
    btnSend=nil;
    imgLoggedInUser=nil;
    _imgChatWith=nil;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        objChatBL = [[AppCounsellingChatBL alloc] init];
        objChatBL.callBack = self;
        
        shouldUploadQuestion = NO;
        isQuestionUploaded = NO;
        isFromRefresh = NO;
        isParseCalled = NO;
        
        yRefM = 20.0;
        self.arrMessages = [[NSMutableArray alloc] init];
        self.arrMessagesAudioVideo = [[NSMutableArray alloc] init];
        seconds = -1;
    }
    return self;
}

//- (void)refreshTimer
//{
//    seconds = -1;
//}

- (void)viewDesigning
{
    scrlViewMessage = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-55)];
    scrlViewMessage.alpha = 0.8;
    scrlViewMessage.backgroundColor = [UIColor clearColor];
    [self addSubview:scrlViewMessage];

    lbl10MinsHeight = [[UILabel alloc] init];
    lbl10MinsHeight.frame = CGRectMake(0, 0, appDelegate.screenWidth, 40);
    lbl10MinsHeight.textColor = [UIColor whiteColor];
    lbl10MinsHeight.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    lbl10MinsHeight.numberOfLines=2;
    lbl10MinsHeight.font = [UIFont systemFontOfSize:15.0];
    lbl10MinsHeight.textAlignment = NSTextAlignmentCenter;
    lbl10MinsHeight.text = @"10 minutes remaining";
    [self addSubview:lbl10MinsHeight];
    lbl10MinsHeight.hidden = YES;
    
    
    lblWaterMark = [[UILabel alloc] init];
    lblWaterMark.frame = CGRectMake(10, 200, appDelegate.screenWidth-20, 50);
    lblWaterMark.textColor = [UIColor lightGrayColor];
    lblWaterMark.numberOfLines=2;
    lblWaterMark.font = [UIFont systemFontOfSize:15.0];
    lblWaterMark.textAlignment = NSTextAlignmentCenter;
    lblWaterMark.text = @"Post some text to confirm your attendance";
    [self addSubview:lblWaterMark];

//    NSString *strCounsellorAttendance = [self.dictAppointment objectForKey:@"counsellorCameAt"];
//    if(strCounsellorAttendance && strCounsellorAttendance.length>4)
//        lblWaterMark.hidden = YES;
//    else
//        lblWaterMark.hidden = NO;
    
    
    viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-44, self.frame.size.width, 44)];
    viewFooter.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    [self addSubview:viewFooter];
    
    txtFieldMessage = [[UITextView alloc] initWithFrame:CGRectMake(56, 7, self.frame.size.width-100, 30)];
    txtFieldMessage.frame = CGRectMake(56, 7, self.frame.size.width-110, 30);
    txtFieldMessage.delegate = self;
    txtFieldMessage.backgroundColor = [UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1.0];
    txtFieldMessage.textColor = [UIColor colorWithRed:170.0/255 green:180.0/255 blue:190.0/255 alpha:1.0];
    txtFieldMessage.textColor = [UIColor colorWithRed:60.0/255.0 green:166.0/255.0 blue:137.0/255.0 alpha:1.0];
    txtFieldMessage.font = [UIFont systemFontOfSize:15.0f];
    txtFieldMessage.layer.cornerRadius = 10.0;
    [viewFooter addSubview:txtFieldMessage];
    
    btnSend = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-54, 0, 54, 44)];
    btnSend.backgroundColor = [UIColor clearColor];
    btnSend.titleLabel.textColor = [UIColor whiteColor];
    //        [btnSend setTitle:@"Send" forState:UIControlStateNormal];
    [btnSend setImage:[UIImage imageNamed:@"ic_send.png"] forState:UIControlStateNormal];
    btnSend.layer.cornerRadius = 10.0;
    [btnSend addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchDown];
    [viewFooter addSubview:btnSend];
    
    btnShareMoodGraph = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 44)];
    [btnShareMoodGraph setImage:[UIImage imageNamed:@"scared.png"] forState:UIControlStateNormal];
    [btnShareMoodGraph addTarget:self action:@selector(sendMoodGraphToCounsellor) forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:btnShareMoodGraph];
    
    arrEmosions = [NSArray arrayWithObjects:@"scared",@"fml",@"sad",@"lol",@"lonely",@"happy",@"grateful",@"frustrated",@"love",@"angry",@"ashamed",@"anxious", nil];
    
    [self showTimerView];
}
- (void)showTimerView
{
    CGFloat width = 70;
    CGFloat height = 18;
    
    viewTimer = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-width)/2.0, -20, width, height)];
    viewTimer.backgroundColor = [UIColor clearColor];
    viewTimer.layer.borderColor = [UIColor whiteColor].CGColor;
    viewTimer.layer.borderWidth = 2;
    viewTimer.layer.cornerRadius = 10.0;
    [self addSubview:viewTimer];
    
    lblMins = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/2.0, height)];
    lblMins.font = [UIFont boldSystemFontOfSize:14.0];
    lblMins.textColor = [UIColor whiteColor];
    lblMins.textAlignment = NSTextAlignmentRight;
    lblMins.backgroundColor = [UIColor clearColor];
    [viewTimer addSubview:lblMins];
    
    lblSecs = [[UILabel alloc] initWithFrame:CGRectMake(width/2.0, 0, width/2.0, height)];
    lblSecs.font = [UIFont boldSystemFontOfSize:14.0];
    lblSecs.textColor = [UIColor whiteColor];
    lblSecs.textAlignment = NSTextAlignmentLeft;
    lblSecs.backgroundColor = [UIColor clearColor];
    [viewTimer addSubview:lblSecs];
}

- (void)changeTimerText
{
    lblMins.text = [NSString stringWithFormat:@"%02i:", intTimeLeft/60];
    lblSecs.text = [NSString stringWithFormat:@"%02i", intTimeLeft%60];
    intTimeLeft--;
    
    if(intTimeLeft<600 && intTimeLeft>540){
        lbl10MinsHeight.hidden = NO;
        lbl10MinsHeight.text = @"10 minutes remaining";
    }
    else if(intTimeLeft<300)
    {
        lbl10MinsHeight.hidden = NO;
        lbl10MinsHeight.text = @"Please remind the client to book their next appointment from their screen";
        lbl10MinsHeight.numberOfLines = 2;
    }
    else {
        
        NSNumber *numImpact = [self.dictAppointment objectForKey:@"impact_question"];
        
        if(numImpact.boolValue == true){
            lbl10MinsHeight.hidden = NO;
            lbl10MinsHeight.text =  @"Please wait, client is answering yp core questions";
        }
        else{
            lbl10MinsHeight.hidden = YES;
        }
    }
}

-(void)sendMoodGraphToCounsellor
{
    [self hideKeyboard];
    if(self.delegate && [self.delegate respondsToSelector:@selector(sendMoodGraphToCounsellor)])
    {
        txtFieldMessage.frame = CGRectMake(56, 7, self.frame.size.width-110, 30);
        [self.delegate sendMoodGraphToCounsellor];
    }
}

- (void)hideKeyboard
{
    [txtFieldMessage resignFirstResponder];
}

#pragma mark - Action Methods

- (BOOL)isiOS8OrAbove {
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0"
                                                                       options: NSNumericSearch];
    return (order == NSOrderedSame || order == NSOrderedDescending);
}

- (void)sendButtonClicked
{
    NSLog(@"sendButtonClicked");
    //edited for testing
    txtFieldMessage.text = [txtFieldMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([txtFieldMessage.text length]>0)
    {
        NSString *strMessage = [self getEncryptedString:txtFieldMessage.text];

        [objChatBL sendMessage:[dictAppointment objectForKey:@"clcnslrun01"] messageUerID:strMessageUserID andMessage:strMessage forAppointment:[dictAppointment objectForKey:@"apntmnt_id"]];
        txtFieldMessage.text = @"";
    }
    else
    {
        NSLog(@"ELSE ");
//        UIAlertController * alert = [UIAlertController
//                                     alertControllerWithTitle:@""
//                                     message:@"Please enter message."
//                                     preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* yesButton = [UIAlertAction
//                                    actionWithTitle:@"OK"
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action) {
//                                        //Handle your yes please button action here
//                                    }];
//        
//        [alert addAction:yesButton];
//        
//        if(self.delegate && [self.delegate respondsToSelector:@selector(showAlert:)])
//            [self.delegate showAlert:alert];
    }
}


- (void)sendMessageInBackground
{
    NSString *strMessage = [dictAppointment objectForKey:@"clcnslrun01"];

    strMessage = [self getEncryptedString:strMessage];
    
    [objChatBL sendMessage:[dictAppointment objectForKey:@"clcnslrun01"] messageUerID:strMessageUserID andMessage:txtFieldMessage.text forAppointment:[dictAppointment objectForKey:@"apntmnt_id"]];
    txtFieldMessage.text = @"";

}
#pragma mark - UITextfield

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing");
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        scrlViewMessage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-55-254);
        viewFooter.frame = CGRectMake(0, self.frame.size.height-60-254, self.frame.size.width, 60);
        txtFieldMessage.frame = CGRectMake(56, 5, txtFieldMessage.frame.size.width, 50);
    }
    else
    {
        scrlViewMessage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-55-300);
        viewFooter.frame = CGRectMake(0, self.frame.size.height-60-300, self.frame.size.width, 60);
        txtFieldMessage.frame = CGRectMake(56, 5, txtFieldMessage.frame.size.width, 50);
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing");
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        scrlViewMessage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-45);
        viewFooter.frame = CGRectMake(0, self.frame.size.height-44, self.frame.size.width, 44);
        txtFieldMessage.frame = CGRectMake(56, 7, txtFieldMessage.frame.size.width, 30);
    }
    else
    {
        scrlViewMessage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-61);
        viewFooter.frame = CGRectMake(0, self.frame.size.height-60, self.frame.size.width, 60);
        txtFieldMessage.frame = CGRectMake(56, 5, txtFieldMessage.frame.size.width, 50);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(NSDate *)convertGMTtoLocal:(NSString *)gmtDateStr
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSTimeZone *gmt = [NSTimeZone systemTimeZone];
    
    [formatter setTimeZone:gmt];
    
    NSDate *GMTTime = [formatter dateFromString:gmtDateStr];
    
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSLog(@"%@",tz);
    NSInteger seconds = [tz secondsFromGMTForDate: GMTTime];
    NSLog(@"%ld",(long)seconds);
    NSLog(@"%@",[NSDate dateWithTimeInterval: seconds sinceDate: GMTTime]);
    return [NSDate dateWithTimeInterval: seconds sinceDate: GMTTime];
    
}

#pragma mark -Parser

- (void)addLastMessage:(NSDictionary *)objMsg
{
    NSString *strMessage = [objMsg objectForKey:@"message"];
    strMessage = [self getDycryptString:strMessage];
    
    NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSString *strMessageDate = [objMsg objectForKey:@"created_at"];
    
    
    NSDate *dateMessage = [self convertGMTtoLocal:strMessageDate];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    strMessageDate = [dateFormatter stringFromDate:dateMessage];

    NSLog(@"strMessageDate = %@", strMessageDate);
    
    if([[dictAppointment objectForKey:@"clcnslrun01"] isEqualToString:[objMsg objectForKey:@"sender"]])
    {
        float scrlWidth = scrlViewMessage.frame.size.width;
        
        UIImageView *imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(scrlWidth-10, 10+yRefM, 11, 22)];
        imgArrow.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rightChatArrow" ofType:@"png"]];
        imgArrow.backgroundColor = [UIColor clearColor];
        [scrlViewMessage addSubview:imgArrow];
        
        UIView *viewSender = [[UIView alloc] initWithFrame:CGRectMake(60, yRefM, scrlWidth-60, 50)];
        viewSender.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0];
        viewSender.backgroundColor = [UIColor whiteColor];
        viewSender.layer.cornerRadius = 10.0;
        viewSender.layer.cornerRadius = 10.0;
        [scrlViewMessage addSubview:viewSender];
        
        
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 50)];
        lblMessage.numberOfLines = 0;
        lblMessage.text = strMessage;
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.textColor = [UIColor colorWithRed:60.0/255.0 green:166.0/255.0 blue:137.0/255.0 alpha:1.0];
        [viewSender addSubview:lblMessage];
        
        UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 50)];
        lblTime.textAlignment = NSTextAlignmentRight;
        lblTime.text = strMessageDate;
        lblTime.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblTime.adjustsFontSizeToFitWidth = YES;
        lblTime.backgroundColor = [UIColor clearColor];
        lblTime.textColor = [UIColor colorWithRed:60.0/255.0 green:166.0/255.0 blue:137.0/255.0 alpha:1.0];
        [viewSender addSubview:lblTime];
        
        CGSize size = [strMessage sizeWithFont:lblMessage.font constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByCharWrapping];

        if ([self validateUrlString:strMessage])
        {
            lblMessage.text = @"";
            size = [@"view mood graph" sizeWithFont:lblMessage.font constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByCharWrapping];

            UIButton *btnLink = [[UIButton alloc] initWithFrame:CGRectMake(00, 0, size.width+10, 50)];
            [btnLink setTitle:strMessage forState:UIControlStateSelected];
            [btnLink setTitle:@"view mood graph" forState:UIControlStateNormal];
            [btnLink setTitle:@"view mood graph" forState:UIControlStateHighlighted];
            [btnLink setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
            [btnLink setTitleColor:[UIColor colorWithRed:60.0/255.0 green:166.0/255.0 blue:137.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [btnLink addTarget:self action:@selector(gotoYouTube:) forControlEvents:UIControlEventTouchUpInside];
            btnLink.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0];
            btnLink.backgroundColor = [UIColor clearColor];
            btnLink.layer.cornerRadius = 10.0;
            btnLink.titleLabel.font = lblMessage.font;
            [viewSender addSubview:btnLink];
            
            lblMessage.frame = CGRectMake(10, size.height<60?0:10, size.width, size.height<60?60:size.height+20);
            viewSender.frame = CGRectMake(scrlWidth-(size.width<60?90:size.width+30), yRefM, size.width<60?80:size.width+20, size.height<60?60:size.height+50);

        }
        else
        {
            lblMessage.frame = CGRectMake(10, size.height<60?0:10, size.width, size.height<60?60:size.height+20);
            viewSender.frame = CGRectMake(scrlWidth-(size.width<60?90:size.width+30), yRefM, size.width<60?80:size.width+20, size.height<60?60:size.height+50);
        }
        
        if(size.height<30)
        {
            lblTime.frame = CGRectMake(10, viewSender.frame.size.height-20, viewSender.frame.size.width-20, 20);
        }
        else if(size.height<60)
        {
            lblTime.frame = CGRectMake(10, viewSender.frame.size.height-15, viewSender.frame.size.width-20, 20);
            viewSender.frame = CGRectMake(viewSender.frame.origin.x, viewSender.frame.origin.y, viewSender.frame.size.width, viewSender.frame.size.height+5);
            lblMessage.frame = CGRectMake(10, lblMessage.frame.origin.y, lblMessage.frame.size.width, lblMessage.frame.size.height-10);
        }
        else
        {
            lblTime.frame = CGRectMake(10, viewSender.frame.size.height-20, viewSender.frame.size.width-20, 20);
        }
        yRefM += viewSender.frame.size.height+10;
    }
    else
    {
        float scrlWidth = scrlViewMessage.frame.size.width;
        
        UIImageView *imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10+yRefM, 11, 22)];
        imgArrow.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"leftChatArrow" ofType:@"png"]];
        imgArrow.backgroundColor = [UIColor clearColor];
        [scrlViewMessage addSubview:imgArrow];
        
        UIView *viewSender = [[UIView alloc] initWithFrame:CGRectMake(80, yRefM, 280, 50)];
        viewSender.backgroundColor = [UIColor whiteColor];
        viewSender.layer.cornerRadius = 10.0;
        viewSender.layer.cornerRadius = 10.0;
        [scrlViewMessage addSubview:viewSender];
        
        
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 50)];
        lblMessage.numberOfLines = 0;
        lblMessage.text = strMessage;
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.textColor = [UIColor colorWithRed:23.0/255.0 green:105.0/255.0 blue:235.0/255.0 alpha:1.0];
        [viewSender addSubview:lblMessage];
        
        UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 50)];
        lblTime.textAlignment = NSTextAlignmentRight;
        lblTime.text = strMessageDate;
        lblTime.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        lblTime.adjustsFontSizeToFitWidth = YES;
        lblTime.backgroundColor = [UIColor clearColor];
        lblTime.textColor = [UIColor colorWithRed:23.0/255.0 green:105.0/255.0 blue:235.0/255.0 alpha:1.0];
        [viewSender addSubview:lblTime];
        
        CGSize size = [strMessage sizeWithFont:lblMessage.font constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        
        if ([self validateUrlString:strMessage])
        {
            lblMessage.text = @"";
            size = [@"view mood graph" sizeWithFont:lblMessage.font constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByCharWrapping];
            
            UIButton *btnLink = [[UIButton alloc] initWithFrame:CGRectMake(00, 0, size.width+10, 50)];
            [btnLink setTitle:strMessage forState:UIControlStateSelected];
            [btnLink setTitle:@"view mood graph" forState:UIControlStateNormal];
            [btnLink setTitle:@"view mood graph" forState:UIControlStateHighlighted];
            [btnLink setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
            [btnLink setTitleColor:[UIColor colorWithRed:23.0/255.0 green:105.0/255.0 blue:235.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [btnLink addTarget:self action:@selector(gotoYouTube:) forControlEvents:UIControlEventTouchUpInside];
            btnLink.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0];
            btnLink.backgroundColor = [UIColor clearColor];
            btnLink.layer.cornerRadius = 10.0;
            btnLink.titleLabel.font = lblMessage.font;
            [viewSender addSubview:btnLink];
            
            lblMessage.frame = CGRectMake(10, size.height<60?0:10, size.width, size.height<60?60:size.height+20+20);
            viewSender.frame = CGRectMake(scrlWidth-(size.width<60?90:size.width+30), yRefM, size.width<60?80:size.width+20, size.height<60?60:size.height+50+20);
        }
        else
        {
            lblMessage.frame = CGRectMake(10, size.height<60?0:10, size.width, size.height<60?60:size.height+20+20);
            viewSender.frame = CGRectMake(10, yRefM, size.width<60?80:size.width+20, size.height<60?60:size.height+50+20);
        }
        
        
        if(size.height<30)
        {
            lblTime.frame = CGRectMake(10, viewSender.frame.size.height-20, viewSender.frame.size.width-20, 20);
        }
        else if(size.height<60)
        {
            viewSender.frame = CGRectMake(viewSender.frame.origin.x, viewSender.frame.origin.y, viewSender.frame.size.width, viewSender.frame.size.height+5);
            lblMessage.frame = CGRectMake(10, lblMessage.frame.origin.y, lblMessage.frame.size.width, lblMessage.frame.size.height-10);
            lblTime.frame = CGRectMake(10, viewSender.frame.size.height-15, viewSender.frame.size.width-20, 20);
        }
        else
        {
            lblTime.frame = CGRectMake(10, viewSender.frame.size.height-20, viewSender.frame.size.width-20, 20);
        }
        
        yRefM += viewSender.frame.size.height+30;
    }
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        scrlViewMessage.contentSize = CGSizeMake(scrlViewMessage.frame.size.width, yRefM);
        scrlViewMessage.contentOffset = CGPointMake(scrlViewMessage.contentOffset.x, scrlViewMessage.contentSize.height-scrlViewMessage.frame.size.height);
    }
    else
    {
        scrlViewMessage.contentSize = CGSizeMake(scrlViewMessage.frame.size.width, yRefM+50);
        scrlViewMessage.contentOffset = CGPointMake(scrlViewMessage.contentOffset.x, scrlViewMessage.contentSize.height-scrlViewMessage.frame.size.height);
    }
        
    dateFormatter = nil;
}

- (void)showMessageDetails:(NSMutableArray *)arrMessageFrom
{
    //return;
//    if(isFromRefresh==NO)
//    {
//        //[self.arrMessages removeAllObjects];
//        if(arrMessageFrom)
//        {
//            for (int i=0; i<[arrMessageFrom count]; i++)
//            {
//                NSDictionary *objMsg = [arrMessageFrom objectAtIndex:i];
//                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id contains[C] %@", [objMsg objectForKey:@"unique_id"]];
//                if([[self.arrMessages filteredArrayUsingPredicate:predicate] count]==0)
//                {
//                    [self.arrMessages addObject:objMsg];
//                }
//            }
//            
////            [self.arrMessages addObjectsFromArray:arrMessageFrom];
//            [self designMessages];
//        }
//    }
//    else// Refresh
    {
        isFromRefresh = NO;
        if(arrMessageFrom)
        {
            BOOL shouldUpdate = NO;
            for (int i=0; i<[arrMessageFrom count]; i++)
            {
                NSDictionary *objMsg = [arrMessageFrom objectAtIndex:i];
                NSString *strMessageEncrypted = [objMsg objectForKey:@"message"];
                NSString *strMessage = [self getDycryptString:strMessageEncrypted];

                NSString *strSender = [objMsg objectForKey:@"sender"];
                NSString *strReceiver = [objMsg objectForKey:@"receiver"];
                NSString *strImpactRating = [self getEncryptedString:@"ImpactRatingDone"];
                
                if(![strMessageEncrypted containsString:strImpactRating] && ![strMessageEncrypted containsString:strSender] && ![strMessageEncrypted containsString:strReceiver])
                {
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id contains[C] %@", [objMsg objectForKey:@"unique_id"]];
                    
                    NSArray *filteredArray = [self.arrMessages filteredArrayUsingPredicate:predicate];

                    if([filteredArray count]==0)
                    {
                        [self.arrMessages addObject:objMsg];
                        //[self addLastMessage:objMsg];
                        shouldUpdate = YES;
                    }
                    else {

                        NSDictionary *objOldMsg = [filteredArray objectAtIndex:0];
                        
                        int index =  (int)[self.arrMessages indexOfObject:objOldMsg];
                        [self.arrMessages replaceObjectAtIndex:index withObject:objMsg];
                        
                        NSString *strTempDate = [objMsg objectForKey:@"updated_at"];
                        
                        NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc]init];
                        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                        lastUpdateDate = [dateFormatter dateFromString:strTempDate];
                        
                        //index
                        if([[dictAppointment objectForKey:@"clcnslrun01"] isEqualToString:[objMsg objectForKey:@"sender"]])
                        {
                            UIView *viewSender = [scrlViewMessage viewWithTag:index];
                            if(viewSender != nil)
                            {
                                UIImageView *imgViewTick = [viewSender viewWithTag:5000+index];
                                
                                NSString *strRead = [objMsg objectForKey:@"read"];
                                
                                if([strRead isEqualToString:@"true"]){
                                    imgViewTick.image = [UIImage imageNamed:@"ticked.png"];
                                }
                                else {
                                    imgViewTick.image = [UIImage imageNamed:@"tick.png"];
                                }
                            }
                        }
                    }
                }
                else if([strMessageEncrypted containsString:strImpactRating])
                {
                    NSNumber *numImpact = [NSNumber numberWithBool:true];
                    [self.dictAppointment setValue:numImpact forKey:@"impact_question"];
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id contains[C] %@", [objMsg objectForKey:@"unique_id"]];
                
                if([[self.arrMessagesAudioVideo filteredArrayUsingPredicate:predicate] count]==0 && ![strMessage isEqualToString:@"ImpactRatingDone"])
                {
                    [self.arrMessagesAudioVideo addObject:objMsg];
                }
            }
            if(shouldUpdate)
                [self designMessages];
        }
    }
    
    if(timer ==nil)
    {
        [self startTimer];
    }
}

- (void)designMessages
{
    yRefM = 10.0;
    
    for (UIView *view in scrlViewMessage.subviews) {
        if([view superview]!=nil){
            [view removeFromSuperview];
        }
    }

    for (int i=0; i<[self.arrMessages count]; i++)
    {
        NSDictionary *objMsg = [self.arrMessages objectAtIndex:i];
        NSString *strMessage = [objMsg objectForKey:@"message"];
        strMessage = [self getDycryptString:strMessage];

        NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc]init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        NSDictionary *dictDate = [objMsg objectForKey:@"created_at"];
        NSString *strMessageDate = @"";
        
        if([dictDate isKindOfClass:[NSString class]])
        {
            strMessageDate = [objMsg objectForKey:@"created_at"];
        }
        else {
            strMessageDate = [dictDate objectForKey:@"date"];
        }
        NSDate *dateMessage = [self convertGMTtoLocal:strMessageDate];
        
        [dateFormatter setDateFormat:@"hh:mm a"];
        strMessageDate = [dateFormatter stringFromDate:dateMessage];
        
        if([[dictAppointment objectForKey:@"clcnslrun01"] isEqualToString:[objMsg objectForKey:@"sender"]])
        {
            float scrlWidth = scrlViewMessage.frame.size.width;
            
            UIImageView *imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(scrlWidth-10, 10+yRefM, 11, 22)];
            imgArrow.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rightChatArrow" ofType:@"png"]];
            imgArrow.backgroundColor = [UIColor clearColor];
            [scrlViewMessage addSubview:imgArrow];
            
            UIView *viewSender = [[UIView alloc] initWithFrame:CGRectMake(60, yRefM, scrlWidth-60, 50)];
            viewSender.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0];
            viewSender.backgroundColor = [UIColor whiteColor];
            viewSender.layer.cornerRadius = 10.0;
            viewSender.layer.cornerRadius = 10.0;
            [scrlViewMessage addSubview:viewSender];
            
            
            UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 50)];
            lblMessage.numberOfLines = 0;
            lblMessage.text = strMessage;
            lblMessage.backgroundColor = [UIColor clearColor];
            lblMessage.textColor = [UIColor colorWithRed:60.0/255.0 green:166.0/255.0 blue:137.0/255.0 alpha:1.0];
            [viewSender addSubview:lblMessage];
            
            UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 50)];
            lblTime.textAlignment = NSTextAlignmentRight;
            lblTime.text = strMessageDate;
            lblTime.font = [UIFont fontWithName:@"Helvetica" size:12.0];
            lblTime.adjustsFontSizeToFitWidth = YES;
            lblTime.backgroundColor = [UIColor clearColor];
            lblTime.textColor = [UIColor colorWithRed:60.0/255.0 green:166.0/255.0 blue:137.0/255.0 alpha:1.0];
            [viewSender addSubview:lblTime];
            
            CGSize size = [strMessage sizeWithFont:lblMessage.font constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByCharWrapping];

            if ([self validateUrlString:strMessage])
            {
                lblMessage.text = @"";
                size = [@"view mood graph" sizeWithFont:lblMessage.font constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByCharWrapping];

                UIButton *btnLink = [[UIButton alloc] initWithFrame:CGRectMake(00, 0, size.width+10, 50)];
                [btnLink setTitle:strMessage forState:UIControlStateSelected];
                [btnLink setTitle:@"view mood graph" forState:UIControlStateNormal];
                [btnLink setTitle:@"view mood graph" forState:UIControlStateHighlighted];
                [btnLink setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
                [btnLink setTitleColor:[UIColor colorWithRed:60.0/255.0 green:166.0/255.0 blue:137.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [btnLink addTarget:self action:@selector(gotoYouTube:) forControlEvents:UIControlEventTouchUpInside];
                btnLink.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0];
                btnLink.backgroundColor = [UIColor clearColor];
                btnLink.layer.cornerRadius = 10.0;
                btnLink.titleLabel.font = lblMessage.font;
                [viewSender addSubview:btnLink];

                lblMessage.frame = CGRectMake(10, size.height<60?0:10, size.width, size.height<60?60:size.height+20+20);
                viewSender.frame = CGRectMake(scrlWidth-(size.width<60?90:size.width+30), yRefM, size.width<60?80:size.width+20, size.height<60?60:size.height+50+20);

            }
            else
            {
                lblMessage.frame = CGRectMake(10, size.height<60?0:10, size.width, size.height<60?60:size.height+20+20);
                viewSender.frame = CGRectMake(scrlWidth-(size.width<60?90:size.width+30), yRefM, size.width<60?80:size.width+20, size.height<60?60:size.height+50+20);
            }
            
            
            if(size.height<30)
            {
                lblTime.frame = CGRectMake(10, viewSender.frame.size.height-20, viewSender.frame.size.width-20, 20);
            }
            else if(size.height<60)
            {
                viewSender.frame = CGRectMake(viewSender.frame.origin.x, viewSender.frame.origin.y, viewSender.frame.size.width, viewSender.frame.size.height+5);
                lblMessage.frame = CGRectMake(10, lblMessage.frame.origin.y, lblMessage.frame.size.width, lblMessage.frame.size.height-10);
                lblTime.frame = CGRectMake(10, viewSender.frame.size.height-15, viewSender.frame.size.width-20, 20);
            }
            else
            {
                lblTime.frame = CGRectMake(10, viewSender.frame.size.height-20, viewSender.frame.size.width-20, 20);
            }
            yRefM += viewSender.frame.size.height+30;
            
            UIImageView *imgViewTick = [[UIImageView alloc] init];
            imgViewTick.frame = CGRectMake(0, viewSender.frame.size.height-20, 20, 20);
            
            imgViewTick.tag = 5000+i;
            viewSender.tag = i;
            
            NSString *strRead = [objMsg objectForKey:@"read"];
            
            if([strRead isEqualToString:@"true"]){
                imgViewTick.image = [UIImage imageNamed:@"ticked.png"];
            }
            else {
                imgViewTick.image = [UIImage imageNamed:@"tick.png"];
            }
            imgViewTick.backgroundColor = [UIColor clearColor];
            [viewSender addSubview:imgViewTick];
        }
        else
        {
            float scrlWidth = scrlViewMessage.frame.size.width;
            
            UIImageView *imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10+yRefM, 11, 22)];
            imgArrow.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"leftChatArrow" ofType:@"png"]];
            imgArrow.backgroundColor = [UIColor clearColor];
            [scrlViewMessage addSubview:imgArrow];
            
            UIView *viewSender = [[UIView alloc] initWithFrame:CGRectMake(80, yRefM, 280, 50)];
            viewSender.backgroundColor = [UIColor whiteColor];
            viewSender.layer.cornerRadius = 10.0;
            viewSender.layer.cornerRadius = 10.0;
            [scrlViewMessage addSubview:viewSender];
            
            
            UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 50)];
            lblMessage.numberOfLines = 0;
            lblMessage.text = strMessage;
            lblMessage.backgroundColor = [UIColor clearColor];
            lblMessage.textColor = [UIColor colorWithRed:23.0/255.0 green:105.0/255.0 blue:235.0/255.0 alpha:1.0];
            [viewSender addSubview:lblMessage];
            
            UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 50)];
            lblTime.textAlignment = NSTextAlignmentRight;
            lblTime.text = strMessageDate;
            lblTime.font = [UIFont fontWithName:@"Helvetica" size:12.0];
            lblTime.adjustsFontSizeToFitWidth = YES;
            lblTime.backgroundColor = [UIColor clearColor];
            lblTime.textColor = [UIColor colorWithRed:23.0/255.0 green:105.0/255.0 blue:235.0/255.0 alpha:1.0];
            [viewSender addSubview:lblTime];

            CGSize size = [strMessage sizeWithFont:lblMessage.font constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByCharWrapping];

            if ([self validateUrlString:strMessage])
            {
                lblMessage.text = @"";
                size = [@"view mood graph" sizeWithFont:lblMessage.font constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByCharWrapping];

                UIButton *btnLink = [[UIButton alloc] initWithFrame:CGRectMake(00, 0, size.width+10, 50)];
                [btnLink setTitle:strMessage forState:UIControlStateSelected];
                [btnLink setTitle:@"view mood graph" forState:UIControlStateNormal];
                [btnLink setTitle:@"view mood graph" forState:UIControlStateHighlighted];
                [btnLink setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
                [btnLink setTitleColor:[UIColor colorWithRed:23.0/255.0 green:105.0/255.0 blue:235.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [btnLink addTarget:self action:@selector(gotoYouTube:) forControlEvents:UIControlEventTouchUpInside];
                btnLink.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0];
                btnLink.backgroundColor = [UIColor clearColor];
                btnLink.layer.cornerRadius = 10.0;
                btnLink.titleLabel.font = lblMessage.font;
                [viewSender addSubview:btnLink];
                
                lblMessage.frame = CGRectMake(10, size.height<60?0:10, size.width, size.height<60?60:size.height+20+20);
                viewSender.frame = CGRectMake(scrlWidth-(size.width<60?90:size.width+30), yRefM, size.width<60?80:size.width+20, size.height<60?60:size.height+50+20);
            }
            else
            {
                lblMessage.frame = CGRectMake(10, size.height<60?0:10, size.width, size.height<60?60:size.height+20+20);
                viewSender.frame = CGRectMake(10, yRefM, size.width<60?80:size.width+20, size.height<60?60:size.height+50+20);
            }
            
            if(size.height<30)
            {
                lblTime.frame = CGRectMake(10, viewSender.frame.size.height-20, viewSender.frame.size.width-20, 20);
            }
            else if(size.height<60)
            {
                viewSender.frame = CGRectMake(viewSender.frame.origin.x, viewSender.frame.origin.y, viewSender.frame.size.width, viewSender.frame.size.height+5);
                lblMessage.frame = CGRectMake(10, lblMessage.frame.origin.y, lblMessage.frame.size.width, lblMessage.frame.size.height-10);
                lblTime.frame = CGRectMake(10, viewSender.frame.size.height-15, viewSender.frame.size.width-20, 20);
            }
            else
            {
                lblTime.frame = CGRectMake(10, viewSender.frame.size.height-20, viewSender.frame.size.width-20, 20);
            }
            
            yRefM += viewSender.frame.size.height+30;
        }
    }
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        scrlViewMessage.contentSize = CGSizeMake(scrlViewMessage.frame.size.width, yRefM);
        scrlViewMessage.contentOffset = CGPointMake(scrlViewMessage.contentOffset.x, scrlViewMessage.contentSize.height-scrlViewMessage.frame.size.height);
    }
    else
    {
        scrlViewMessage.contentSize = CGSizeMake(scrlViewMessage.frame.size.width, yRefM+50);
        scrlViewMessage.contentOffset = CGPointMake(scrlViewMessage.contentOffset.x, scrlViewMessage.contentSize.height-scrlViewMessage.frame.size.height);
    }

    
}
- (BOOL)validateUrlString:(NSString*)urlString
{
    if (!urlString)
    {
        return NO;
    }
    
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    
    NSRange urlStringRange = NSMakeRange(0, [urlString length]);
    NSMatchingOptions matchingOptions = 0;
    
    if (1 != [linkDetector numberOfMatchesInString:urlString options:matchingOptions range:urlStringRange])
    {
        return NO;
    }
    
    NSTextCheckingResult *checkingResult = [linkDetector firstMatchInString:urlString options:matchingOptions range:urlStringRange];
    
    return checkingResult.resultType == NSTextCheckingTypeLink
    && NSEqualRanges(checkingResult.range, urlStringRange);
}
- (void)gotoYouTube:(UIButton *)btnLink
{
    [txtFieldMessage resignFirstResponder];
    NSString *strLink = [btnLink titleForState:UIControlStateSelected];
    NSLog(@"strLink = %@", strLink);
    
    
    if(viewURL==nil)
    {
        viewURL = [[UIView alloc] initWithFrame:CGRectMake(0, 1000, self.frame.size.width, self.frame.size.height)];
        viewURL.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.9];
        [self addSubview:viewURL];
        
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-20)];
        [viewURL addSubview:self.webView];
        self.webView.scalesPageToFit = YES;
        self.webView.backgroundColor = [UIColor clearColor];
        
        //        [self.webView loadHTMLString:@"<!DOCTYPE html><html><head><style>.loader {  border: 16px solid #f3f3f3;  border-radius: 50%;  border-top: 16px solid #3498db;  width: 50px;  height: 50px; position:absolute; left:50%; margin-left:-25px; top:50%; margin-top:-25px;  -webkit-animation: spin 2s linear infinite;  animation: spin 2s linear infinite;}@-webkit-keyframes spin {  0% { -webkit-transform: rotate(0deg); }  100% { -webkit-transform: rotate(360deg); }}@keyframes spin {  0% { transform: rotate(0deg); }  100% { transform: rotate(360deg); }}</style></head><body><div class=\"loader\"></div></body></html>" baseURL:nil];
        
        UIButton *btnClose = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-70, 5, 60, 30)];
        btnClose.layer.borderColor=[UIColor whiteColor].CGColor;
        btnClose.layer.borderWidth = 1.0;
        btnClose.layer.cornerRadius = 5.0;
        [btnClose setTitle:@"close" forState:UIControlStateNormal];
        [btnClose setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(removeWebView) forControlEvents:UIControlEventTouchUpInside];
        [viewURL addSubview:btnClose];
    }
    else
    {
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strLink]]];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [viewURL setFrame:CGRectMake(0, -10, self.frame.size.width, self.frame.size.height)];
    }];
}
- (void)removeWebView
{
    [self.webView loadHTMLString:@"<!DOCTYPE html><html><head><style>.loader {  border: 16px solid #f3f3f3;  border-radius: 50%;  border-top: 16px solid #3498db;  width: 50px;  height: 50px; position:absolute; left:50%; margin-left:-25px; top:50%; margin-top:-25px;  -webkit-animation: spin 2s linear infinite;  animation: spin 2s linear infinite;}@-webkit-keyframes spin {  0% { -webkit-transform: rotate(0deg); }  100% { -webkit-transform: rotate(360deg); }}@keyframes spin {  0% { transform: rotate(0deg); }  100% { transform: rotate(360deg); }}</style></head><body><div class=\"loader\"></div></body></html>" baseURL:nil];
    
    [UIView animateWithDuration:0.25 animations:^{
        [viewURL setFrame:CGRectMake(0, 1000, self.frame.size.width, self.frame.size.height)];
    }];
}

-(void)shareUrl:(NSString *)url;
{
    
}
- (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshMessage) userInfo:nil repeats:YES];
}

- (void)refreshMessage
{
    if(isParseCalled == NO)
    {
        NSString *strDate=nil;
        if([self.arrMessages count]>0)
        {
            NSDictionary *objMsg = [self.arrMessages lastObject];
            
            NSString *strTempDate = [objMsg objectForKey:@"created_at"];
            
            NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc]init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];//2017-05-05T15:27:51.038Z
            NSDate *dateLastMessage = [dateFormatter dateFromString:strTempDate];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            
//            strDate = [dateFormatter stringFromDate:dateLastMessage];
            if(lastUpdateDate == nil)
            {
                strDate = [dateFormatter stringFromDate:dateLastMessage];
            }
            else if(dateLastMessage > lastUpdateDate)
            {
                strDate = [dateFormatter stringFromDate:dateLastMessage];
            }
            else
            {
                strDate = [dateFormatter stringFromDate:lastUpdateDate];
            }
        }
        
        if(appDelegate.isNetAvailable)
        {
            isFromRefresh = YES;
            if(seconds%2==0)
                [self getMessageWith:strMessageUserID andDate:strDate];
        }
    }

    //[self checkIf45MinsCounsellingCompleted];
    [self performSelectorInBackground:@selector(checkIf45MinsCounsellingCompleted) withObject:nil];
}

- (void)checkIf45MinsCounsellingCompleted
{
    if(seconds<0)
    {
        if(seconds>-5)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
//            [dateFormatter setTimeZone:timeZone];
//            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [dateFormatter setDateFormat:formatServer];
            
            NSString *strAppointmentDate = [dictAppointment objectForKey:@"apntmnt_date"];
            
            NSDate *appointmentDate = [dateFormatter dateFromString:strAppointmentDate];
            

            NSDate *currebntServerTime = appDelegate.dateServer;
            NSTimeInterval distanceBetweenDates = [currebntServerTime timeIntervalSinceDate:appointmentDate];
            
            seconds = lroundf(distanceBetweenDates);
        }
        else
        {
            seconds = seconds+1;
            [self changeTimerText];
            return;
        }
    }
    else
    {
        seconds = seconds+1;
    }
    
    int hours = (seconds / 3600);
    int mins  = (seconds % 3600) / 60;
    int secs  = seconds % 60;
    
    intTimeLeft = (secs+(60*mins));// - (secs%5);
    intTimeLeft = (60*appDelegate.timeDuration)-intTimeLeft;
    
    [self changeTimerText];
    NSDictionary* userInfo = @{@"total": [NSNumber numberWithInt:intTimeLeft]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timerOnCall" object:userInfo];

    // Time Over
    if(mins>=appDelegate.timeDuration && hours==0)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(counsellingTimeOver)])
        {
            if(timer && [timer isValid])
            {
                [timer invalidate];
                timer=nil;
            }
            
//            [self clearMemory];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate counsellingTimeOver];
                self.delegate = nil;
            });
        }
    }
    else if(isQuestionUploaded==NO) //if(mins<appDelegate.timeDuration && mins>=5 && hours==0)
    {
        //if(mins)
        BOOL isCounsellorAvailable = NO;
        BOOL isUserAvailable = NO;
        
        for (int i=0; i<[self.arrMessagesAudioVideo count]; i++)
        {
            NSDictionary *objMsg = [self.arrMessagesAudioVideo objectAtIndex:i];
            NSString *strSender = [objMsg objectForKey:@"sender"];
            
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
        
        if(shouldUploadQuestion==NO)
        {
            for (int i=0; i<[self.arrMessages count]; i++)
            {
                NSDictionary *objMsg = [self.arrMessages objectAtIndex:i];
                NSString *strSender = [objMsg objectForKey:@"sender"];
                
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
        }
        
        if(shouldUploadQuestion==YES && isQuestionUploaded==NO)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(uploadRattingQuestions)])
            {
                isQuestionUploaded=YES;
                //This method will insert questions to the table with appointmentid and counsellorid delegate nwill not call 
                [self.delegate uploadRattingQuestions];
            }
        }
    }
}


#pragma mark- Parser
- (void)getMessageWith:(NSString *)strUserID andDate:(NSString *)strDate
{
    isParseCalled = YES;
    [objChatBL getMessageWith:strUserID andDate:strDate forAppointment:[dictAppointment objectForKey:@"apntmnt_id"]];
}

- (void)getMessageParserFinished:(NSMutableArray *)arrMessages appointmentStatus:(NSString *)strStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        strLiveAppointmentStatus = strStatus;
        [appDelegate removeChargementLoader];
        if([strStatus isEqualToString:@"Accepted"])
        {
            isParseCalled = NO;
            if(arrMessages.count>0)
            {
                for (int i=0; i<[arrMessages count]; i++)
                {
                    NSDictionary *objMsg = [arrMessages objectAtIndex:i];
                    NSString *strSender = [objMsg objectForKey:@"sender"];
                    
                    if([strSender isEqualToString:[dictAppointment objectForKey:@"clcnslrun01"]])
                        lblWaterMark.hidden = YES;
                }
                [self showMessageDetails:arrMessages];
            }
            else
            {
            }
            if(timer==nil)
            {
                [self startTimer];
            }
        }
        else
        {
            if([strStatus isEqualToString:@"Completed"])
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(counsellingTimeOver)])
                {
                    if(timer && [timer isValid])
                    {
                        [timer invalidate];
                        timer=nil;
                    }
                    
                    //                [self clearMemory];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate counsellingTimeOver];
                        self.delegate = nil;
                    });
                }
            }
            else if([strStatus isEqualToString:@"Cancelled"])
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(shouldShowTheCancelOption)])
                {
                    //                [self clearMemory];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate shouldShowTheCancelOption];
                    });
                }
            }
        }
    });
}

- (void)sendMessageParserFinished:(NSDictionary *)objMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{

        lblWaterMark.hidden = YES;
        [appDelegate removeChargementLoader];
        isParseCalled = NO;
    });
    
//    if(objMessage && [objMessage isKindOfClass:[NSDictionary class]])
//    {
//        if(![self.arrMessages containsObject:objMessage])
//        {
//            txtFieldMessage.text = @"";
//        }
//    }
//    else if(objMessage && [objMessage isKindOfClass:[NSArray class]])
//    {
//        for (NSDictionary *dictMSG in objMessage)
//        {
//            if(![self.arrMessages containsObject:dictMSG])
//            {
//                txtFieldMessage.text = @"";
//            }
//        }
//    }
}

- (void)makeReadMessageParserFinished:(NSDictionary *)dictMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate removeChargementLoader];
    });
}

- (void)errorOccured:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate removeChargementLoader];
        isParseCalled = NO;
    });
}

- (void)sendMessageForCallingAction
{
    [objChatBL sendMessage:[dictAppointment objectForKey:@"clcnslrun01"] messageUerID:strMessageUserID andMessage:[dictAppointment objectForKey:@"clcnslrun01"] forAppointment:[dictAppointment objectForKey:@"apntmnt_id"]];
}

-(NSString *)getEncryptedString:(NSString *)strString
{
    
    StringEncryption *objEncrypter = [[StringEncryption alloc] init];
    NSString *key = [objEncrypter sha256:@"newapp17mindcrew" length:32];
    NSString *iv = @"mindcrewnewapp17";
    
    
    NSData * encryptedData = [objEncrypter encrypt:[strString dataUsingEncoding:NSUTF8StringEncoding] key:key iv:iv];
    
    return [encryptedData  base64EncodingWithLineLength:0];
}

- (NSString *)getDycryptString:(NSString *)secret  {
    
    NSString *key = [[[StringEncryption alloc] init] sha256:@"newapp17mindcrew" length:32];
    NSString *iv = @"mindcrewnewapp17";
    
    NSData * encryptedData = [NSData dataWithBase64EncodedString:secret];
    
    encryptedData = [[[StringEncryption alloc] init] decrypt:encryptedData key:key iv:iv];
    
    NSString * decryptedText = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    
    return decryptedText;
    
//    let key = appDelegate.objEncrypter.sha256("newapp17mindcrew", length: 32)
//    let iv = "mindcrewnewapp17"
//    var encryptedData = NSData(base64Encoded: secret, options: [])!
//    encryptedData = appDelegate.objEncrypter.decrypt(encryptedData as Data!, key: key, iv: iv) as NSData
//    let decryptedText = String(data: encryptedData as Data, encoding: String.Encoding.utf8)
//    
//    return decryptedText!
}



@end
