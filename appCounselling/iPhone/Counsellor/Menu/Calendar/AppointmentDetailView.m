//
//  AppointmentDetailView.m
//  appCounselling
//
//  Created by MindCrew Technologies on 28/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "AppointmentDetailView.h"
#import "AppDelegate.h"

#import "appCounsellingLoginParser.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"

#define strKeyWebService @"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R"

@implementation AppointmentDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [self screenDesigning];
    }
    return self;
}

- (void)screenDesigning
{
    viewDetailPopUp = [[UIView alloc] init];
    viewDetailPopUp.userInteractionEnabled = YES;
    viewDetailPopUp.frame = CGRectMake(20, 120, appDelegate.screenWidth-40, 210);
    viewDetailPopUp.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
    [self addSubview:viewDetailPopUp];
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.screenWidth-40, 40)];
    viewHeader.backgroundColor = [UIColor whiteColor];
    [viewDetailPopUp addSubview:viewHeader];
    
    UILabel *lblSubTitle = [[UILabel alloc] init];
    lblSubTitle.frame = CGRectMake(40, 0, appDelegate.screenWidth-120, 40);
    lblSubTitle.textAlignment = NSTextAlignmentCenter;
    lblSubTitle.textColor = [UIColor blackColor];
    lblSubTitle.text = @"Counselling Details";
    [viewHeader addSubview:lblSubTitle];

    UIButton *btnClose = [[UIButton alloc] init];
    btnClose.frame = CGRectMake(appDelegate.screenWidth-80, 5, 30, 30);
    [btnClose addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTitle:@"x" forState:UIControlStateNormal];
    btnClose.backgroundColor = [UIColor clearColor];
    [btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont systemFontOfSize:20.0];
    btnClose.layer.cornerRadius = 15;
    btnClose.layer.borderWidth = 1;
    btnClose.layer.borderColor = [UIColor blackColor].CGColor;
    [viewDetailPopUp addSubview:btnClose];

    UIImageView *imgViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    //imgViewLogo.contentMode = UIViewContentModeCenter;
    imgViewLogo.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"180" ofType:@"png"]];
    imgViewLogo.backgroundColor = [UIColor clearColor];
    [viewHeader addSubview:imgViewLogo];
    imgViewLogo = nil;
    viewHeader = nil;
    
    float width = appDelegate.screenWidth-80;

    lblSessionLeft = [[UILabel alloc] init];
    lblSessionLeft.frame = CGRectMake(20, 50, width, 20);
    lblSessionLeft.text = @"Session Left :";
    lblSessionLeft.textColor = [UIColor grayColor];
    [viewDetailPopUp addSubview:lblSessionLeft];
    
    lblMode = [[UILabel alloc] init];
    lblMode.frame = CGRectMake(20, 80, width, 20);
    lblMode.text = @"Mode :";
    lblMode.textColor = [UIColor grayColor];
    [viewDetailPopUp addSubview:lblMode];

    lblDate = [[UILabel alloc] init];
    lblDate.frame = CGRectMake(20, 110, width, 20);
    lblDate.text = @"Date :";
    lblDate.textColor = [UIColor grayColor];
    [viewDetailPopUp addSubview:lblDate];
    
    lblTimeInterval = [[UILabel alloc] init];
    lblTimeInterval.frame = CGRectMake(20, 140, width, 20);
    lblTimeInterval.text = @"From ";
    lblTimeInterval.textColor = [UIColor grayColor];
    [viewDetailPopUp addSubview:lblTimeInterval];

    lblAppointmentOrder = [[UILabel alloc] init];
    lblAppointmentOrder.frame = CGRectMake(20, 170, width, 20);
    lblAppointmentOrder.text = @"";
    lblAppointmentOrder.textColor = [UIColor grayColor];
    [viewDetailPopUp addSubview:lblAppointmentOrder];
}

- (void)closeButtonClicked
{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

- (void)setParameter:(NSDictionary *)dictAppointment
{
    intSessionDuration = 55;
    NSNumber *numSD = [dictAppointment objectForKey:@"session_duration"];
    
    if(numSD != nil){
        intSessionDuration = numSD.intValue;
    }

    NSNumber *numSL = [dictAppointment objectForKey:@"session_left"];
    
    lblSessionLeft.text = [NSString stringWithFormat:@"Session Left : %i", numSL.intValue];
    lblMode.text = [NSString stringWithFormat:@"Mode : %@", [dictAppointment objectForKey:@"mode"]];
    
    NSString *strDate = [dictAppointment objectForKey:@"apntmnt_date"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatServer];
    NSDate *dateServer = [formatter dateFromString:strDate];
    
    [formatter setDateFormat:formatToShowWithoutTime];
    NSString *strDateToShow = [formatter stringFromDate:dateServer];
    
    [formatter setDateFormat:@"HH:mm"];
    NSString *strTimeToShow = [formatter stringFromDate:dateServer];
    
    lblDate.text = strDateToShow;
    lblTimeInterval.text = [NSString stringWithFormat:@"From %@ to %@", strTimeToShow, [self getNextTime:strTimeToShow]];
    
    NSString *strClient = [self getDycryptString:[dictAppointment objectForKey:@"user_firstname"]];
    if(strClient == nil || strClient.length==0)
        strClient = @"Client";
    
//    lblAppointmentOrder.text = [NSString stringWithFormat:@"%i%@ appointment with %@", number, strTH, strClient];
    
    [self getAppointmentNumber:dictAppointment];
}

- (NSString *)getNextTime:(NSString *)strFromTime
{
    NSString *strToTime = @"";
    
    NSArray *arrDateTime = [strFromTime componentsSeparatedByString:@":"];
    
    int intHour = 0;
    int intMins = 0;
    
    if(arrDateTime.count>=2)
    {
        NSString *strHour = [arrDateTime objectAtIndex:0];
        NSString *strMins = [arrDateTime objectAtIndex:1];
        
        intHour = strHour.intValue;
        intMins = strMins.intValue;
        
        intMins = intMins+intSessionDuration;
        
        
        if(intMins<60)
        {
            strToTime = [NSString stringWithFormat:@"%02i:%02i", intHour, intMins];
        }
        else if(intMins==60)
        {
            intHour = intHour+1;
            intMins = 0;
            
            if(intHour==24)
            {
                intHour = 0;
            }
            
            strToTime = [NSString stringWithFormat:@"%02i:%02i", intHour, intMins];
        }
        else if(intMins>60)
        {
            intMins = intMins-60;
            intHour = intHour+1;
            if(intHour==24)
            {
                intHour = 0;
            }

            strToTime = [NSString stringWithFormat:@"%02i:%02i", intHour, intMins];
        }
    }
    
    return strToTime;
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
    
    return decryptedText;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
