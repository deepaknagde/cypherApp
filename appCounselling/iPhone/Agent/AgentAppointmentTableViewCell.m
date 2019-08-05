//
//  AgentAppointmentTableViewCell.m
//  appCounselling
//
//  Created by MindCrew Technologies on 08/03/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import "AgentAppointmentTableViewCell.h"
#import "AppDelegate.h"
#import "appCounsellingLoginParser.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"

#define strKeyWebService @"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R"
#define colorWhiteOrBlack [UIColor blackColor]

@implementation AgentAppointmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    
    CGFloat screenWidth = 150;
    {
        lblCounsellor = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenWidth-30, 30)];
        lblCounsellor.backgroundColor = [UIColor clearColor];
        lblCounsellor.font = [UIFont systemFontOfSize:15.0];
        lblCounsellor.textColor = colorWhiteOrBlack;
        [self addSubview:lblCounsellor];
        [self bringSubviewToFront:lblCounsellor];
        
        lblUser = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, screenWidth-30, 20)];
        lblUser.backgroundColor = [UIColor clearColor];
        lblUser.textColor = colorWhiteOrBlack;
        lblUser.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:lblUser];
        [self bringSubviewToFront:lblUser];
        
        lblDate = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, screenWidth-30, 20)];
        lblDate.backgroundColor = [UIColor clearColor];
        lblDate.textColor = colorWhiteOrBlack;
        lblDate.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:lblDate];
        [self bringSubviewToFront:lblDate];
        
        lblMode = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, screenWidth-30, 20)];
        lblMode.backgroundColor = [UIColor clearColor];
        lblMode.textColor = colorWhiteOrBlack;
        lblMode.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:lblMode];
        [self bringSubviewToFront:lblMode];
        
        lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, screenWidth-30, 20)];
        lblStatus.backgroundColor = [UIColor clearColor];
        lblStatus.textColor = colorWhiteOrBlack;
        lblStatus.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:lblStatus];
        [self bringSubviewToFront:lblStatus];
        
        lblSession = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, screenWidth-30, 20)];
        lblSession.backgroundColor = [UIColor clearColor];
        lblSession.textColor = colorWhiteOrBlack;
        lblSession.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:lblSession];
        [self bringSubviewToFront:lblSession];

        lblCounsellor.textAlignment = NSTextAlignmentRight;
        lblUser.textAlignment = NSTextAlignmentRight;
        lblDate.textAlignment = NSTextAlignmentRight;
        lblMode.textAlignment = NSTextAlignmentRight;
        lblStatus.textAlignment = NSTextAlignmentRight;
        lblSession.textAlignment = NSTextAlignmentRight;

        lblCounsellor.text = @"Counsellor : ";
        lblUser.text = @"User : ";
        lblDate.text = @"Date : ";
        lblMode.text = @"Mode : ";
        lblStatus.text = @"Status : ";
        lblSession.text = @"Session Left : ";

        lblCounsellor.textColor = [UIColor darkGrayColor];
        lblUser.textColor = [UIColor darkGrayColor];
        lblDate.textColor = [UIColor darkGrayColor];
        lblMode.textColor = [UIColor darkGrayColor];
        lblStatus.textColor = [UIColor darkGrayColor];
        lblSession.textColor = [UIColor darkGrayColor];

    }
    
    screenWidth = appDelegate.screenWidth-150;
    float xRef = 140;
    
    lblCounsellor = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 0, screenWidth-30, 30)];
    lblCounsellor.text = @".";
    lblCounsellor.backgroundColor = [UIColor clearColor];
    lblCounsellor.font = [UIFont boldSystemFontOfSize:18.0];
    lblCounsellor.textColor = colorWhiteOrBlack;
    [self addSubview:lblCounsellor];
    [self bringSubviewToFront:lblCounsellor];
    
    lblUser = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 30, screenWidth-30, 20)];
    lblUser.backgroundColor = [UIColor clearColor];
    lblUser.textColor = colorWhiteOrBlack;
    lblUser.font = [UIFont boldSystemFontOfSize:18.0];
    [self addSubview:lblUser];
    [self bringSubviewToFront:lblUser];
    
    lblDate = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 60, screenWidth-30, 20)];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textColor = colorWhiteOrBlack;
    lblDate.font = [UIFont boldSystemFontOfSize:18.0];
    [self addSubview:lblDate];
    [self bringSubviewToFront:lblDate];
    
    lblMode = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 90, screenWidth-30, 20)];
    lblMode.backgroundColor = [UIColor clearColor];
    lblMode.textColor = colorWhiteOrBlack;
    lblMode.font = [UIFont boldSystemFontOfSize:18.0];
    [self addSubview:lblMode];
    [self bringSubviewToFront:lblMode];
    
    lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 120, screenWidth-30, 20)];
    lblStatus.backgroundColor = [UIColor clearColor];
    lblStatus.textColor = colorWhiteOrBlack;
    lblStatus.font = [UIFont boldSystemFontOfSize:18.0];
    [self addSubview:lblStatus];
    [self bringSubviewToFront:lblStatus];
    
    lblSession = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 150, screenWidth-30, 20)];
    lblSession.backgroundColor = [UIColor clearColor];
    lblSession.textColor = colorWhiteOrBlack;
    lblSession.font = [UIFont boldSystemFontOfSize:18.0];
    [self addSubview:lblSession];
    [self bringSubviewToFront:lblSession];
    

    return self;
}

- (void)showAppointments:(NSDictionary *)dictAppointment
{
    NSString *strUsername = [dictAppointment objectForKey:@"clun01"];
    NSString *strCounsellor = [dictAppointment objectForKey:@"clcnslrun01"];
    
    lblCounsellor.text = [self getDycryptString:strCounsellor];
    lblUser.text = [self getDycryptString:strUsername];
    lblDate.text = [dictAppointment objectForKey:@"apntmnt_date"];
    lblMode.text = [dictAppointment objectForKey:@"mode"];
    lblStatus.text = [dictAppointment objectForKey:@"status"];
    
    NSNumber *numSession = [dictAppointment objectForKey:@"session_left"];
    lblSession.text = [NSString stringWithFormat:@"%i", numSession.intValue];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
