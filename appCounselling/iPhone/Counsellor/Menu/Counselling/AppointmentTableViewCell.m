//
//  AppointmentTableViewCell.m
//  appCounselling
//
//  Created by MindCrew Technologies on 26/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "AppointmentTableViewCell.h"
#import "AppDelegate.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"

#import "appCounsellingLoginParser.h"
#define strKeyWebService @"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R"

@implementation AppointmentTableViewCell

@synthesize btnAccept, btnDeniey, btnReschedule,btnGoAssesmetform;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Initialization code
    self.opaque = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.clipsToBounds = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat screenWidth = appDelegate.screenWidth;
    
    lblFriendRequest = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenWidth-30, 30)];
    lblFriendRequest.backgroundColor = [UIColor clearColor];
    lblFriendRequest.font = [UIFont systemFontOfSize:15.0];
    lblFriendRequest.textColor = [UIColor whiteColor];
    [self addSubview:lblFriendRequest];
    [self bringSubviewToFront:lblFriendRequest];
    
    lblAppointmentOrder = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, screenWidth-30, 20)];
    lblAppointmentOrder.backgroundColor = [UIColor clearColor];
    lblAppointmentOrder.textColor = [UIColor whiteColor];
    lblAppointmentOrder.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:lblAppointmentOrder];
    [self bringSubviewToFront:lblAppointmentOrder];
    
    lblMode = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, screenWidth-30, 20)];
    lblMode.backgroundColor = [UIColor clearColor];
    lblMode.textColor = [UIColor whiteColor];
    lblMode.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:lblMode];
    [self bringSubviewToFront:lblMode];

    lblSuggested = [[UILabel alloc] initWithFrame:CGRectMake(15, 79, screenWidth-30, 20)];
    lblSuggested.backgroundColor = [UIColor clearColor];
    lblSuggested.textColor = [UIColor whiteColor];
    lblSuggested.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:lblSuggested];
    [self bringSubviewToFront:lblSuggested];
    
    
    btnAccept = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-90, 56, 24, 24)];
    [btnAccept setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    btnAccept.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnAccept];
    [self bringSubviewToFront:btnAccept];
    
    btnDeniey = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-50, 56, 24, 24)];
    [btnDeniey setImage:[UIImage imageNamed:@"reject.png"] forState:UIControlStateNormal];
    btnDeniey.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnDeniey];
    [self bringSubviewToFront:btnDeniey];
    
    
    btnGoAssesmetform = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-90, 56, 24, 24)];
    btnGoAssesmetform.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnGoAssesmetform];
    [self bringSubviewToFront:btnGoAssesmetform];
    
    btnReschedule = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-50, 56, 24, 24)];
    btnReschedule.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnReschedule];
    [self bringSubviewToFront:btnReschedule];
   
    
    [btnAccept setImage:[UIImage imageNamed:@"correct.png"] forState:UIControlStateNormal];
    [btnDeniey setImage:[UIImage imageNamed:@"close_red.png"] forState:UIControlStateNormal];
    [btnReschedule setImage:[UIImage imageNamed:@"rescheduling_icon.png"] forState:UIControlStateNormal];
    [btnGoAssesmetform setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];

    return self;
}

/*
 "agnc_unq_id" = "xL+X2NKXjsPiMNrhrT995A==1493628669285";
 "apntmnt_date" = "05/11/2017 11:25";
 "apntmnt_id" = "xDu3LXtDBBo0c41Qz9kZAw==1493638548501";
 "apntmnt_notification" = 0;
 clcnslrun01 = "7Z9lhu4fCsxaPovP0rW64UxKxAMsG45ank1NB0g7rt4=";
 clun01 = "xDu3LXtDBBo0c41Qz9kZAw==";
 "cnslr_come_at" = "";
 "cnslr_ratting_status" = Pending;
 "cnsrl1_assign_time" = "2017-05-01T11:37:01.525Z";
 "counc_unq_id" = "7Z9lhu4fCsxaPovP0rW64UxKxAMsG45ank1NB0g7rt4=1493628743592";
 "created_at" = "2017-05-01T11:36:39.785Z";
 "device_type" = ios;
 "forwarding1_15hours" = 0;
 "forwarding2_10hours" = 0;
 "forwarding3_10hours" = 0;
 "impact_question" = 0;
 lat = "22.7426785128454";
 lng = "75.8913868001264";
 mode = Chat;
 "mood_graph" = 0;
 "noti_1hours" = 0;
 "noti_24hours" = 0;
 "noti_5min" = 0;
 "noti_cunslg_strt" = 0;
 qid = 23873133;
 "ratting_complete_notification" = 0;
 "request_state" = Proceesed;
 "same_cnslr" = 0;
 "session_duration" = 10;
 "session_left" = 6;
 status = Pending;
 "suggested_by" = User;
 "suggestion_noti" = 0;
 "updated_at" = "2017-05-01T11:36:39.785Z";
 "usr_come_at" = "";
 */

- (void)setParameter:(NSDictionary *)dictAppointment
{
    NSString *strStatus = [dictAppointment objectForKey:@"status"];
    NSString *strDate = [dictAppointment objectForKey:@"apntmnt_date"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatServer];
    
    NSDate *dateServer = [formatter dateFromString:strDate];
    
    [formatter setDateFormat:formatToShowWithTime];
    NSString *strDateToShow = [formatter stringFromDate:dateServer];
    
    if([strStatus isEqualToString:@"Pending"])
    {
        btnAccept.hidden = NO;
        btnDeniey.hidden = NO;
        btnReschedule.hidden = NO;
        btnGoAssesmetform.hidden = YES;
        btnAccept.frame = CGRectMake(appDelegate.screenWidth-140, 56, 24, 24);
        btnDeniey.frame = CGRectMake(appDelegate.screenWidth-95, 56, 24, 24);
        btnReschedule.frame = CGRectMake(appDelegate.screenWidth-50, 56, 24, 24);

        NSString *strSuggetedBy = [dictAppointment objectForKey:@"suggested_by"];
        
        lblSuggested.text = @"";
        if(strSuggetedBy != nil && [strSuggetedBy isEqualToString:@"Counsellor"])
        {
            btnAccept.hidden = YES;
            btnDeniey.hidden = YES;
            btnReschedule.hidden = YES;
            btnGoAssesmetform.hidden = YES;
            lblSuggested.text = [NSString stringWithFormat:@"You have suggested a new time to %@", [self getDycryptString:[dictAppointment objectForKey:@"user_firstname"]]];
        }
        
//        NSNumber *numSameCounsellor = [dictAppointment objectForKey:@"same_cnslr"];
//        BOOL isSame = numSameCounsellor.boolValue;
//
//        if(isSame == YES)
//        {
//            btnDeniey.hidden = YES;
//            btnReschedule.hidden = NO;
//        }
//        else
//        {
//            btnDeniey.hidden = NO;
//            btnReschedule.hidden = YES;
//        }
        NSString *strClient = [self getDycryptString:[dictAppointment objectForKey:@"user_firstname"]];
        if(strClient == nil || strClient.length==0)
            strClient = @"Client";
        
        lblFriendRequest.text = [NSString stringWithFormat:@"Counselling Time : %@", strDateToShow];
        
        lblAppointmentOrder.text = [NSString stringWithFormat:@" appointment with %@", strClient];
        lblMode.text = [NSString stringWithFormat:@"Mode : %@", [dictAppointment objectForKey:@"mode"]];
    }
    else
    {
        btnDeniey.hidden = YES;
        btnAccept.hidden = YES;
        
        BOOL isLive = [self checkIfTheAppointmentIsLive:dictAppointment];
        if(isLive == NO){
            btnGoAssesmetform.hidden = NO;
            btnReschedule.hidden = NO;
        }else{
        btnReschedule.hidden = YES;
          btnGoAssesmetform.hidden = NO;
        }
        btnGoAssesmetform.frame = CGRectMake(appDelegate.screenWidth-90, 56, 24, 24);
        btnReschedule.frame = CGRectMake(appDelegate.screenWidth-50, 56, 24, 24);

        NSString *strClient = [self getDycryptString:[dictAppointment objectForKey:@"user_firstname"]];
        if(strClient == nil || strClient.length==0)
            strClient = @"Client";

        lblFriendRequest.text = [NSString stringWithFormat:@"Counselling Time : %@", strDateToShow];
        lblAppointmentOrder.text = [NSString stringWithFormat:@" appointment with %@", strClient];
        lblMode.text = [NSString stringWithFormat:@"Mode : %@", [dictAppointment objectForKey:@"mode"]];

    }
    
    UIColor *textColor = [UIColor blackColor];
    UIColor *bgColor = [UIColor whiteColor];
    
    lblFriendRequest.textColor = textColor;
    lblMode.textColor = textColor;
    lblAppointmentOrder.textColor = textColor;
    lblSuggested.textColor = textColor;
    
    
    self.backgroundView.backgroundColor = bgColor;
    self.contentView.backgroundColor = bgColor;
    self.backgroundColor = bgColor;
    
    strDate = nil;
    strStatus = nil;
    strDateToShow = nil;
    
    formatter = nil;
    dateServer = nil;
    
    [self getAppointmentNumber:dictAppointment];
}

- (void)setParameterForReschedule:(NSDictionary *)dictAppointment
{
    NSString *strStatus = [dictAppointment objectForKey:@"status"];
    NSString *strDate = [dictAppointment objectForKey:@"apntmnt_date"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatServer];
    
    //    //To show acurate time.
    //    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //    [formatter setTimeZone:timeZone];
    
    NSDate *dateServer = [formatter dateFromString:strDate];
    
    [formatter setDateFormat:formatToShowWithTime];
    NSString *strDateToShow = [formatter stringFromDate:dateServer];
    
    if([strStatus isEqualToString:@"Pending"])
    {
        btnAccept.hidden = NO;
        
        //        NSString *strSameCounsellor = [dictAppointment objectForKey:@"same_cnslr"];
        NSNumber *numSameCounsellor = [dictAppointment objectForKey:@"same_cnslr"];
        BOOL isSame = numSameCounsellor.boolValue;
        
        if(isSame == YES)
        {
            btnDeniey.hidden = YES;
            btnReschedule.hidden = NO;
            btnGoAssesmetform.hidden = NO;
        }
        else
        {
            btnDeniey.hidden = NO;
            btnReschedule.hidden = YES;
             btnGoAssesmetform.hidden = YES;
        }
        
        NSString *strClient = [self getDycryptString:[dictAppointment objectForKey:@"user_firstname"]];
        if(strClient == nil || strClient.length==0)
            strClient = @"Client";

        lblFriendRequest.text = [NSString stringWithFormat:@"Counselling Time : %@", strDateToShow];
        lblAppointmentOrder.text = [NSString stringWithFormat:@" appointment with %@", strClient];
        lblMode.text = [NSString stringWithFormat:@"Mode : %@", [dictAppointment objectForKey:@"mode"]];
    }
    else
    {
        btnDeniey.hidden = YES;
        btnAccept.hidden = YES;
        btnReschedule.hidden = YES;
         btnGoAssesmetform.hidden = YES;
        
        NSString *strClient = [self getDycryptString:[dictAppointment objectForKey:@"user_firstname"]];
        if(strClient == nil || strClient.length==0)
            strClient = @"Client";

        lblFriendRequest.text = [NSString stringWithFormat:@"Counselling Time : %@", strDateToShow];
        lblMode.text = [NSString stringWithFormat:@"Mode : %@", [dictAppointment objectForKey:@"mode"]];
        lblAppointmentOrder.text = [NSString stringWithFormat:@" appointment with %@", strClient];
    }
    
    UIColor *textColor = [UIColor blackColor];
    UIColor *bgColor = [UIColor whiteColor];
    
    lblFriendRequest.textColor = textColor;
    lblMode.textColor = textColor;
    lblAppointmentOrder.textColor = textColor;
    lblSuggested.textColor = textColor;

    self.backgroundView.backgroundColor = bgColor;
    self.contentView.backgroundColor = bgColor;
    self.backgroundColor = bgColor;
    
    strDate = nil;
    strStatus = nil;
    strDateToShow = nil;
    
    formatter = nil;
    dateServer = nil;
    
    [self getAppointmentNumber:dictAppointment];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)checkIfTheAppointmentIsLive:(NSDictionary *)dictAppointment
{
    BOOL isAppointmentLive = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatte setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:formatServer];
    
    NSString *strAppointmentDate = [dictAppointment objectForKey:@"apntmnt_date"];
    
    NSDate *appointmentDate = [dateFormatter dateFromString:strAppointmentDate];
    
    NSDate *currDate;
    
    if(appDelegate.dateServer)
        currDate = appDelegate.dateServer;
    else
        currDate = [NSDate date];
    
    NSTimeInterval distanceBetweenDates = [appointmentDate timeIntervalSinceDate:currDate];
    
    long seconds = lroundf(distanceBetweenDates);
    int hours = (seconds / 3600);
    int mins = (seconds % 3600) / 60;
    int secs = seconds % 60;
    
    int intTimeLeft = secs+(60*mins);
    
    NSString *strStatus = [dictAppointment objectForKey:@"status"];
    
    int intTimeDuration = 60*appDelegate.timeDuration;
    
    NSLog(@"intTimeDuration = %i", intTimeDuration);
    
    if(hours == 0 && intTimeLeft<360 && [strStatus isEqualToString:@"Accepted"])
    {
        isAppointmentLive = YES;
    }
    else
    {
        isAppointmentLive = NO;
    }
    
    return isAppointmentLive;
}


- (void)getAppointmentNumber:(NSDictionary *)dictAppointment
{
//    {
//        "requestData":
//        {
//            "apikey":"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R",
//            "requestType":"userCounsellorAppointmnetCount",
//            "data":{
//                "clcnslrun01":"84DB8CmabgxLDBQFQ21Q8NT2hBlXyPQ38exjen3B3h4=",
//                "clun01":"yDRJTqP7fJN72bd7PkIVmQ=="
//            }
//        }
//    }
    
    NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[appDelegate.dictProfile objectForKey:@"username"], [dictAppointment objectForKey:@"clun01"], nil] forKeys:[NSArray arrayWithObjects: @"clcnslrun01", @"clun01", nil]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"userCounsellorAppointmnetCount", data, nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
    
    [dictParameter setObject:parameters forKey:@"requestData"];
    
    [appCounsellingLoginParser sharedManager].strMethod = @"userCounsellorAppointmnetCount";
    [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([responseDict isKindOfClass:[NSNumber class]])
            {
                NSNumber *numCount = (NSNumber *)responseDict;
                NSString *strTH = @"";
                int number = numCount.intValue+1;
                {
                    
                    if (number > 3 && number < 21)
                    {
                        strTH =  @"th";
                    }
                    else{
                        int lastdigit = number % 10;
                        
                        switch (lastdigit)
                        {
                            case 1: strTH=  @"st";
                                break;
                            case 2: strTH=  @"nd";
                                break;
                            case 3: strTH= @"rd";
                                break;
                            default: strTH=  @"th";
                                break;
                        }
                    }
                }

                NSString *strClient = [self getDycryptString:[dictAppointment objectForKey:@"user_firstname"]];
                if(strClient == nil || strClient.length==0)
                    strClient = @"Client";

                lblAppointmentOrder.text = [NSString stringWithFormat:@"%i%@ appointment with %@", number, strTH, strClient];
            }
        });
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(appDelegate.isServerswitched == NO){
                [appDelegate switchServer];
                [self getAppointmentNumber:dictAppointment];
            }
            else {
                [appDelegate removeChargementLoader];
            }
        });
    }];

}

- (NSString *)getDycryptString:(NSString *)secret  {
    
    NSString *key = [[[StringEncryption alloc] init] sha256:@"newapp17mindcrew" length:32];
    NSString *iv = @"mindcrewnewapp17";
    
    NSData * encryptedData = [NSData dataWithBase64EncodedString:secret];
    
    encryptedData = [[[StringEncryption alloc] init] decrypt:encryptedData key:key iv:iv];
    
    NSString * decryptedText = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    
    return decryptedText.capitalizedString;
}

@end
