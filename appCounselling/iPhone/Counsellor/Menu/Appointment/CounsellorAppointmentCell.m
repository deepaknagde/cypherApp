//
//  CounsellorAppointmentCell.m
//  appCounselling
//
//  Created by MindCrew Technologies on 06/12/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import "CounsellorAppointmentCell.h"
#import "appCounsellingLoginParser.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "DXStarRatingView.h"
#import "AppDelegate.h"
#import "CounsellorAppointmentViewController.h"

#define strKeyWebService @"KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R"
#define colorWhiteOrBlack [UIColor blackColor]

@implementation CounsellorAppointmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    arrAppointmentRating = [[NSMutableArray alloc] init];
    localpavan_arr = [[NSMutableArray alloc] init];

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
        
        lblAppointmentStatus = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, screenWidth-30, 20)];
        lblAppointmentStatus.backgroundColor = [UIColor clearColor];
        lblAppointmentStatus.textColor = colorWhiteOrBlack;
        lblAppointmentStatus.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:lblAppointmentStatus];
        [self bringSubviewToFront:lblAppointmentStatus];
        
        lblSession = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, screenWidth-30, 20)];
        lblSession.backgroundColor = [UIColor clearColor];
        lblSession.textColor = colorWhiteOrBlack;
        lblSession.font = [UIFont systemFontOfSize:14.0];
//        [self addSubview:lblSession];
//        [self bringSubviewToFront:lblSession];
        
        lblUserRating = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, screenWidth-30, 20)];
        lblUserRating.backgroundColor = [UIColor clearColor];
        lblUserRating.textColor = colorWhiteOrBlack;
        lblUserRating.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:lblUserRating];
        [self bringSubviewToFront:lblUserRating];
        
        btnUserRating2 = [[UIButton alloc] initWithFrame:CGRectMake(15, 180, screenWidth-30, 30)];
        btnUserRating2.backgroundColor = colorHeader;
        btnUserRating2.layer .cornerRadius = 10;
        [btnUserRating2 setTitle:@"Que-Rating" forState:UIControlStateNormal];
        btnUserRating2.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:btnUserRating2];
        [self bringSubviewToFront:btnUserRating2];

        btnUserRating4 = [[UIButton alloc] initWithFrame:CGRectMake(15, 220, screenWidth-30, 30)];
        btnUserRating4.backgroundColor = colorHeader;
        btnUserRating4.layer .cornerRadius = 10;
        [btnUserRating4 setTitle:@"Que-Rating" forState:UIControlStateNormal];
        btnUserRating4.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:btnUserRating4];
        [self bringSubviewToFront:btnUserRating4];

        btnUserRating5 = [[UIButton alloc] initWithFrame:CGRectMake(15, 260, screenWidth-30, 30)];
        btnUserRating5.backgroundColor = colorHeader;
        btnUserRating5.layer .cornerRadius = 10;
        [btnUserRating5 setTitle:@"Que-Rating" forState:UIControlStateNormal];
        btnUserRating5.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:btnUserRating5];
        [self bringSubviewToFront:btnUserRating5];

        lblCounsellorRating = [[UILabel alloc] initWithFrame:CGRectMake(15, 300, screenWidth-30, 20)];
        lblCounsellorRating.backgroundColor = [UIColor clearColor];
        lblCounsellorRating.textColor = colorWhiteOrBlack;
        lblCounsellorRating.font = [UIFont systemFontOfSize:14.0];
        lblCounsellorRating.adjustsFontSizeToFitWidth = YES;
        [self addSubview:lblCounsellorRating];
        [self bringSubviewToFront:lblCounsellorRating];
        
        btnCounsellorRating1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 330, screenWidth-30, 30)];
        btnCounsellorRating1.backgroundColor = colorHeader;
        btnCounsellorRating1.layer .cornerRadius = 10;
        [btnCounsellorRating1 setTitle:@"Que-Rating" forState:UIControlStateNormal];
        btnCounsellorRating1.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:btnCounsellorRating1];
        [self bringSubviewToFront:btnCounsellorRating1];

        btnCounsellorRating3 = [[UIButton alloc] initWithFrame:CGRectMake(15, 370, screenWidth-30, 30)];
        btnCounsellorRating3.backgroundColor = colorHeader;
        btnCounsellorRating3.layer .cornerRadius = 10;
        [btnCounsellorRating3 setTitle:@"Que-Rating" forState:UIControlStateNormal];
        btnCounsellorRating3.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:btnCounsellorRating3];
        [self bringSubviewToFront:btnCounsellorRating3];

        btnCounsellorComment1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 410, screenWidth-20, 30)];
        btnCounsellorComment1.backgroundColor = colorHeader;
        btnCounsellorComment1.layer .cornerRadius = 10;
        [btnCounsellorComment1 setTitle:@"Comment" forState:UIControlStateNormal];
        btnCounsellorComment1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnCounsellorComment1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -10.0, 0.0, 0.0)];
        UIImage *btnImage = [UIImage imageNamed:@"pencil.png"];
        [btnCounsellorComment1 setImageEdgeInsets:UIEdgeInsetsMake(5, 100, 5, 0)];
        [btnCounsellorComment1 setImage:btnImage forState:UIControlStateNormal];
        btnCounsellorComment1.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:btnCounsellorComment1];
        [self bringSubviewToFront:btnCounsellorComment1];

        btnCounsellorComment3 = [[UIButton alloc] initWithFrame:CGRectMake(15, 450, screenWidth-20, 30)];
        btnCounsellorComment3.backgroundColor = colorHeader;
        btnCounsellorComment3.layer .cornerRadius = 10;
        [btnCounsellorComment3 setTitle:@"Comment" forState:UIControlStateNormal];
        [btnCounsellorComment3 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -10.0, 0.0, 0.0)];
         btnCounsellorComment3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UIImage *btnImage1 = [UIImage imageNamed:@"pencil.png"];
        [btnCounsellorComment3 setImageEdgeInsets:UIEdgeInsetsMake(5, 100, 5, 0)];
        [btnCounsellorComment3 setContentMode:UIViewContentModeLeft];
        
        [btnCounsellorComment3 setImage:btnImage1 forState:UIControlStateNormal];
        btnCounsellorComment3.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:btnCounsellorComment3];
        [self bringSubviewToFront:btnCounsellorComment3];
        

        
        

        lblCounsellor.textAlignment = NSTextAlignmentRight;
        lblUser.textAlignment = NSTextAlignmentRight;
        lblDate.textAlignment = NSTextAlignmentRight;
        lblMode.textAlignment = NSTextAlignmentRight;
        lblAppointmentStatus.textAlignment = NSTextAlignmentRight;
        lblSession.textAlignment = NSTextAlignmentRight;
        lblUserRating.textAlignment = NSTextAlignmentRight;
        lblCounsellorRating.textAlignment = NSTextAlignmentRight;
        
        lblCounsellor.text = @"Counsellor : ";
        lblUser.text = @"User : ";
        lblDate.text = @"Date : ";
        lblMode.text = @"Mode : ";
        lblAppointmentStatus.text = @"Status : ";
        lblSession.text = @"Session Left : ";
        lblUserRating.text = @"User Rating : ";
        lblCounsellorRating.text = @"Counsellor Rating : ";
        
//        lblCounsellor.textColor = [UIColor darkGrayColor];
//        lblUser.textColor = [UIColor darkGrayColor];
//        lblDate.textColor = [UIColor darkGrayColor];
//        lblMode.textColor = [UIColor darkGrayColor];
//        lblStatus.textColor = [UIColor darkGrayColor];
//        lblSession.textColor = [UIColor darkGrayColor];
//        lblUserRating.textColor = [UIColor darkGrayColor];
//        lblCounsellorRating.textColor = [UIColor darkGrayColor];
    }
    
    screenWidth = appDelegate.screenWidth-150;
    float xRef = 140;
    
    lblCounsellor = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 0, screenWidth-30, 30)];
    lblCounsellor.text = @".";
    lblCounsellor.backgroundColor = [UIColor clearColor];
    lblCounsellor.font = [UIFont boldSystemFontOfSize:18.0];
    lblCounsellor.adjustsFontSizeToFitWidth = YES;
    lblCounsellor.textColor = colorWhiteOrBlack;
    [self addSubview:lblCounsellor];
    [self bringSubviewToFront:lblCounsellor];
    
    lblUser = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 30, screenWidth-30, 20)];
    lblUser.backgroundColor = [UIColor clearColor];
    lblUser.textColor = colorWhiteOrBlack;
    lblUser.font = [UIFont boldSystemFontOfSize:18.0];
    lblUser.adjustsFontSizeToFitWidth = YES;
    [self addSubview:lblUser];
    [self bringSubviewToFront:lblUser];
    
    lblDate = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 60, screenWidth-30, 20)];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textColor = colorWhiteOrBlack;
    lblDate.font = [UIFont boldSystemFontOfSize:18.0];
    lblDate.adjustsFontSizeToFitWidth = YES;
    [self addSubview:lblDate];
    [self bringSubviewToFront:lblDate];
    
    lblMode = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 90, screenWidth-30, 20)];
    lblMode.backgroundColor = [UIColor clearColor];
    lblMode.textColor = colorWhiteOrBlack;
    lblMode.font = [UIFont boldSystemFontOfSize:18.0];
    lblDate.adjustsFontSizeToFitWidth = YES;
    [self addSubview:lblMode];
    [self bringSubviewToFront:lblMode];
    
    lblAppointmentStatus = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 120, screenWidth-30, 20)];
    lblAppointmentStatus.backgroundColor = [UIColor clearColor];
    lblAppointmentStatus.textColor = colorWhiteOrBlack;
    lblAppointmentStatus.font = [UIFont boldSystemFontOfSize:18.0];
    [self addSubview:lblAppointmentStatus];
    [self bringSubviewToFront:lblAppointmentStatus];
    
    lblSession = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 150, screenWidth-30, 20)];
    lblSession.backgroundColor = [UIColor clearColor];
    lblSession.textColor = colorWhiteOrBlack;
    lblSession.font = [UIFont boldSystemFontOfSize:18.0];
//    [self addSubview:lblSession];
//    [self bringSubviewToFront:lblSession];
    
    return self;
}

- (void)showAppointments:(NSDictionary *)dictAppointment
{
    strAppointmentID = [dictAppointment objectForKey:@"apntmnt_id"];
    
    NSString *strUsername = [dictAppointment objectForKey:@"clun01"];
    NSString *strCounsellor = [dictAppointment objectForKey:@"clcnslrun01"];
    
    lblCounsellor.text = [self getDycryptString:strCounsellor];
    lblUser.text = [self getDycryptString:strUsername];
    lblDate.text = [dictAppointment objectForKey:@"apntmnt_date"];
    lblMode.text = [dictAppointment objectForKey:@"mode"];
    lblAppointmentStatus.text = [dictAppointment objectForKey:@"status"];

    NSNumber *numSession = [dictAppointment objectForKey:@"session_left"];
    lblSession.text = [NSString stringWithFormat:@"%i", numSession.intValue];
}

- (void)showRatingOfAppointment:(NSMutableArray *)arrRatings
{
    [arrAppointmentRating removeAllObjects];
    NSLog(@"strAppointmentID = %@", strAppointmentID);
    
    for (int i=0; i<arrRatings.count; i++)
    {
        NSDictionary *dictRating = [arrRatings objectAtIndex:i];
        NSString *strAppointmentId = [dictRating objectForKey:@"apntmnt_id"];
        NSLog(@"Id to match = %@", strAppointmentId);
        if([strAppointmentID isEqualToString:strAppointmentId])
        {
            [arrAppointmentRating addObject:dictRating];
            [localpavan_arr addObject:dictRating];
            NSLog(@"pavannew %@", arrAppointmentRating);
        }
    }
    if(arrAppointmentRating.count > 0)
    {
        [self showRatings];
    }
}

- (void)showRatings
{
    CGFloat screenWidth = appDelegate.screenWidth-150;
    float xRef = 145;

    for (int i=0; i<arrAppointmentRating.count; i++)
    {
        NSDictionary *dictRating = [arrAppointmentRating objectAtIndex:i];

        NSString *strStatus = [dictRating objectForKey:@"status"];//Done
        NSString *strQuestionID = [dictRating objectForKey:@"questionid"];
        NSNumber *numRatingCount = [dictRating objectForKey:@"rattingcount"];
        NSString *strComment = [dictRating objectForKey:@"comment"];//Done
        NSString *strQuestion = [dictRating objectForKey:@"questiontext"];//Done
        strQuestion = [self getDycryptString:strQuestion];
        
        UIColor *colorBG = [UIColor clearColor]; //colorHeader;
        
        if([strStatus isEqualToString:@"Done"])
        {
            if([strQuestionID isEqualToString:@"2"])//User
            {
                [btnUserRating2 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnUserRating2 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                if(viewRatingBG2 == nil)
                    viewRatingBG2 = [[UIView alloc] init];
                
                viewRatingBG2.frame = CGRectMake(xRef, 180, screenWidth-30, 30);
                viewRatingBG2.backgroundColor = colorBG;
                [self addSubview:viewRatingBG2];
                
                if(starRatingView2 == nil)
                    starRatingView2 = [[DXStarRatingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-30, 30)];
                
                starRatingView2.isFromCell = YES;
                [starRatingView2 setStars:numRatingCount.intValue callbackBlock:^(NSNumber *newRating) {
                    //_rating = newRating;
                }];
                starRatingView2.userInteractionEnabled = NO;
                [viewRatingBG2 addSubview:starRatingView2];
                
                [btnCounsellorComment1 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment1 addTarget:self action:@selector(editComment:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment1.tag = i;
                
                [btnCounsellorComment3 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment3 addTarget:self action:@selector(editComment2:) forControlEvents:UIControlEventTouchUpInside];
                btnCounsellorComment3.tag = i;
               

            }
            else if([strQuestionID isEqualToString:@"4"])//User
            {
                [btnUserRating4 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnUserRating4 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];

                if(viewRatingBG4 == nil)
                    viewRatingBG4 = [[UIView alloc] init];
                
                viewRatingBG4.frame = CGRectMake(xRef, 220, screenWidth-30, 30);
                viewRatingBG4.backgroundColor = colorBG;
                [self addSubview:viewRatingBG4];
                
                if(starRatingView4 == nil)
                    starRatingView4 = [[DXStarRatingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-30, 30)];
                
                starRatingView4.isFromCell = YES;
                [starRatingView4 setStars:numRatingCount.intValue callbackBlock:^(NSNumber *newRating) {
                    //_rating = newRating;
                }];
                starRatingView4.userInteractionEnabled = NO;
                [viewRatingBG4 addSubview:starRatingView4];
                
                [btnCounsellorComment1 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment1 addTarget:self action:@selector(editComment:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment1.tag = i;
                [btnCounsellorComment3 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment3 addTarget:self action:@selector(editComment2:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment3.tag = i;

            }
            else if([strQuestionID isEqualToString:@"5"])//User
            {
                [btnUserRating5 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnUserRating5 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];

                if(viewRatingBG5 == nil)
                    viewRatingBG5 = [[UIView alloc] init];
                
                viewRatingBG5.frame = CGRectMake(xRef, 260, screenWidth-30, 30);
                viewRatingBG5.backgroundColor = colorBG;
                [self addSubview:viewRatingBG5];
                
                if(starRatingView5 == nil)
                    starRatingView5 = [[DXStarRatingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-30, 30)];
                
                starRatingView5.isFromCell = YES;
                [starRatingView5 setStars:numRatingCount.intValue callbackBlock:^(NSNumber *newRating) {
                    //_rating = newRating;
                }];
                starRatingView5.userInteractionEnabled = NO;
                [viewRatingBG5 addSubview:starRatingView5];
                
                [btnCounsellorComment1 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment1 addTarget:self action:@selector(editComment:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment1.tag = i;
                [btnCounsellorComment3 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment3 addTarget:self action:@selector(editComment2:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment3.tag = i;

            }
            else if([strQuestionID isEqualToString:@"7"])//User Overall
            {
//                [btnUserRating7 setTitle:strQuestion forState:UIControlStateNormal];
//                [btnUserRating7 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];

                if(viewRatingBG7 == nil)
                    viewRatingBG7 = [[UIView alloc] init];
                
                viewRatingBG7.frame = CGRectMake(xRef, 300, screenWidth-30, 30);
                viewRatingBG7.backgroundColor = colorBG;
                [self addSubview:viewRatingBG7];
                
                if(starRatingView7 == nil)
                    starRatingView7 = [[DXStarRatingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-30, 30)];
                
                starRatingView7.isFromCell = YES;
                [starRatingView7 setStars:numRatingCount.intValue callbackBlock:^(NSNumber *newRating) {
                    //_rating = newRating;
                }];
                starRatingView7.userInteractionEnabled = NO;
                [viewRatingBG7 addSubview:starRatingView7];
                
                [btnCounsellorComment1 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment1 addTarget:self action:@selector(editComment:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment1.tag = i;
                [btnCounsellorComment3 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment3 addTarget:self action:@selector(editComment2:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment3.tag = i;

                
            }
            else if([strQuestionID isEqualToString:@"1"])//Counselor
            {
                [btnCounsellorRating1 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnCounsellorRating1 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];

                [btnCounsellorComment1 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment1 addTarget:self action:@selector(editComment:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment1.tag = i;
                
                [btnCounsellorComment3 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment3 addTarget:self action:@selector(editComment2:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment3.tag = i;

                if(viewRatingBG1 == nil)
                    viewRatingBG1 = [[UIView alloc] init];
                
                viewRatingBG1.frame = CGRectMake(xRef, 330, screenWidth-30, 30);
                viewRatingBG1.backgroundColor = colorBG;
                [self addSubview:viewRatingBG1];

                if(lblRatingComment1 == nil)
                    lblRatingComment1 = [[UILabel alloc] init];
                
                lblRatingComment1.frame = CGRectMake(xRef, 330+80, screenWidth-10, 30);
                lblRatingComment1.text = strComment;
                lblRatingComment1.backgroundColor = colorBG;
                [self addSubview:lblRatingComment1];
                
                lblRatingComment1.numberOfLines = 0;
//                strComment = @"I have cancelled all public show for dec n jan due to my ill health and other important commitments.";
                lblRatingComment1.text = strComment;

                float diffHeight = 0;

                CGSize size = [strComment sizeWithFont:lblRatingComment1.font constrainedToSize:CGSizeMake(screenWidth-30, 1000) lineBreakMode:NSLineBreakByCharWrapping];

                if(size.height > 30)
                    diffHeight = diffHeight+(size.height-30);

                lblRatingComment1.frame = CGRectMake(xRef, 330+80, screenWidth-10, size.height+10);
                
                if(starRatingView1 == nil)
                    starRatingView1 = [[DXStarRatingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-30, 30)];
                
                starRatingView1.isFromCell = YES;
                [starRatingView1 setStars:numRatingCount.intValue callbackBlock:^(NSNumber *newRating) {
                    //_rating = newRating;
                }];
                starRatingView1.userInteractionEnabled = NO;
                [viewRatingBG1 addSubview:starRatingView1];
                
                if(lblRatingComment3 != nil && diffHeight != 0)
                {
                    lblRatingComment3.frame = CGRectMake(xRef, 450 + diffHeight, screenWidth-10, lblRatingComment3.frame.size.height);
                    btnCounsellorComment3.frame = CGRectMake(15, 450 + diffHeight, btnCounsellorComment3.frame.size.width, 30);
                }
                else {
                    lblRatingComment3 = [[UILabel alloc] init];
                    lblRatingComment3.frame = CGRectMake(xRef, 450 + diffHeight, screenWidth-10, 30);
                    btnCounsellorComment3.frame = CGRectMake(15, 450 + diffHeight, btnCounsellorComment3.frame.size.width, 30);
                    
                }
            }
            else if([strQuestionID isEqualToString:@"3"])//Counselor
            {
                [btnCounsellorRating3 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnCounsellorRating3 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];
              
                [btnCounsellorComment1 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment1 addTarget:self action:@selector(editComment:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment1.tag = i;
                [btnCounsellorComment3 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnCounsellorComment3 addTarget:self action:@selector(editComment2:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment3.tag = i;

                if(viewRatingBG3==nil)
                    viewRatingBG3 = [[UIView alloc] init];
                
                viewRatingBG3.frame = CGRectMake(xRef, 370, screenWidth-30, 30);
                viewRatingBG3.backgroundColor = colorBG;
                [self addSubview:viewRatingBG3];
                
                if(lblRatingComment3 == nil)
                {
                    lblRatingComment3 = [[UILabel alloc] init];
                    lblRatingComment3.frame = CGRectMake(xRef, 450, screenWidth-10, 30);
                }
                else
                {
                    
                }
                
                lblRatingComment3.backgroundColor = colorBG;
                [self addSubview:lblRatingComment3];

                lblRatingComment3.numberOfLines = 0;
//                strComment = @"As I have already mentioned in my youtube live earlier on 1st dec.";
                lblRatingComment3.text = strComment;

                CGSize size = [strComment sizeWithFont:lblRatingComment3.font constrainedToSize:CGSizeMake(screenWidth-30, 1000) lineBreakMode:NSLineBreakByCharWrapping];
                lblRatingComment3.frame = CGRectMake(xRef, lblRatingComment3.frame.origin.y, lblRatingComment3.frame.size.width, size.height+10);

                if(starRatingView3 == nil)
                    starRatingView3 = [[DXStarRatingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-30, 30)];
                
                starRatingView3.isFromCell = YES;
                [starRatingView3 setStars:numRatingCount.intValue callbackBlock:^(NSNumber *newRating) {
                    //_rating = newRating;
                }];
                starRatingView3.userInteractionEnabled = NO;
                [viewRatingBG3 addSubview:starRatingView3];
            }
        }
        else {
            if([strQuestionID isEqualToString:@"2"])//User
            {
                [btnUserRating2 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnUserRating2 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];

                UILabel *lblStatus = [[UILabel alloc] init];
                lblStatus.frame = CGRectMake(xRef, 180, screenWidth-30, 30);
                lblStatus.backgroundColor = [UIColor clearColor];
                [self addSubview:lblStatus];
                lblStatus.text = @"Pending";
            }
            else if([strQuestionID isEqualToString:@"4"])//User
            {
                [btnUserRating4 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnUserRating4 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];

                UILabel *lblStatus = [[UILabel alloc] init];
                lblStatus.frame = CGRectMake(xRef, 220, screenWidth-30, 30);
                lblStatus.backgroundColor = colorBG;
                [self addSubview:lblStatus];
                lblStatus.text = @"Pending";
            }
            else if([strQuestionID isEqualToString:@"5"])//User
            {
                [btnUserRating5 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnUserRating5 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];

                UILabel *lblStatus = [[UILabel alloc] init];
                lblStatus.frame = CGRectMake(xRef, 260, screenWidth-30, 30);
                lblStatus.backgroundColor = colorBG;
                [self addSubview:lblStatus];
                lblStatus.text = @"Pending";
                
                
            }
            else if([strQuestionID isEqualToString:@"7"])//User Overall
            {
                [btnCounsellorComment1 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment1 addTarget:self action:@selector(editComment:) forControlEvents:UIControlEventTouchUpInside];
              btnCounsellorComment1.tag = i;
                [btnCounsellorComment3 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment3 addTarget:self action:@selector(editComment2:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment3.tag = i;
                
                UILabel *lblStatus = [[UILabel alloc] init];
                lblStatus.frame = CGRectMake(xRef, 300, screenWidth-30, 30);
                lblStatus.backgroundColor = colorBG;
                [self addSubview:lblStatus];
                lblStatus.text = @"Pending";
            }
            else if([strQuestionID isEqualToString:@"1"])//Counselor
            {
                [btnCounsellorRating1 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnCounsellorRating1 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [btnCounsellorComment1 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment1 addTarget:self action:@selector(editComment:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment1.tag = i;
                [btnCounsellorComment3 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment3 addTarget:self action:@selector(editComment2:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment3.tag = i;

                UILabel *lblStatus = [[UILabel alloc] init];
                lblStatus.frame = CGRectMake(xRef, 330, screenWidth-30, 30);
                lblStatus.backgroundColor = colorBG;
                [self addSubview:lblStatus];
                lblStatus.text = @"Pending";

                lblStatus = [[UILabel alloc] init];
                lblStatus.frame = CGRectMake(xRef, 330+80, screenWidth-30, 30);
                lblStatus.backgroundColor = colorBG;
                [self addSubview:lblStatus];
                lblStatus.text = @"Pending";

            }
            else if([strQuestionID isEqualToString:@"3"])//Counselor
            {
                [btnCounsellorRating3 setTitle:strQuestion forState:UIControlStateDisabled];
                [btnCounsellorRating3 addTarget:self action:@selector(questionClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btnCounsellorComment1 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                 btnCounsellorComment1.tag = i;
                [btnCounsellorComment1 addTarget:self action:@selector(editComment:) forControlEvents:UIControlEventTouchUpInside];
               
                [btnCounsellorComment3 setTitle:@"strQuestion" forState:UIControlStateDisabled];
                [btnCounsellorComment3 addTarget:self action:@selector(editComment:) forControlEvents:UIControlEventTouchUpInside];
                 btnCounsellorComment3.tag = i;

                UILabel *lblStatus = [[UILabel alloc] init];
                lblStatus.frame = CGRectMake(xRef, 370, screenWidth-30, 30);
                lblStatus.backgroundColor = colorBG;
                [self addSubview:lblStatus];
                lblStatus.text = @"Pending";

                lblStatus = [[UILabel alloc] init];
                lblStatus.frame = CGRectMake(xRef, 370+80, screenWidth-30, 30);
                lblStatus.backgroundColor = colorBG;
                [self addSubview:lblStatus];
                lblStatus.text = @"Pending";
            }
        }
    }
    
   
}

- (void)questionClicked:(UIButton *)sender
{
      
    
    
    NSString *strMessage = [sender titleForState:UIControlStateDisabled];
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

- (void)editComment:(UIButton *)sender
{
    
    for (int i=0; i<localpavan_arr.count; i++)
    {
        NSDictionary *dictRating = [localpavan_arr objectAtIndex:i];
        NSLog(@"dic%@", dictRating);
        NSString *questionid = [dictRating objectForKey:@"questionid"];
                NSLog(@"diquestionidc%@", questionid);
         NSInteger newmsgid = [questionid integerValue];
        
        if(newmsgid == 1)
        {
            NSString *comment = [dictRating objectForKey:@"comment"];
            NSString *apntmntId_loc = [dictRating objectForKey:@"apntmnt_id"];
            NSString *clun01_loc1 = [dictRating objectForKey:@"clun01"];
            NSString *clun01_loc = [self getDycryptString:clun01_loc1];
            
            NSString *clcnslrun01_loc1 = [dictRating objectForKey:@"clcnslrun01"];
            NSString *clcnslrun01_loc = [self getDycryptString:clcnslrun01_loc1];
            NSString *questionId_loc = [dictRating objectForKey:@"questionid"];
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Update comment"
                                                                                      message: @""
                                                                               preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = comment;
                textField.text = comment;
                textField.textColor = [UIColor blueColor];
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.borderStyle = UITextBorderStyleRoundedRect;
            }];
           
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSArray * textfields = alertController.textFields;
                UITextField * namefield = textfields[0];
                NSLog(@"%@",namefield.text);
                [appDelegate addChargementLoader];
                NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
                NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: namefield.text,apntmntId_loc,clun01_loc,clcnslrun01_loc,questionId_loc, nil] forKeys:[NSArray arrayWithObjects: @"comment",@"apntmntId",@"clun01",@"clcnslrun01",@"questionId",nil]];
                
                NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"updateCommentsbyCounsellor", data,nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
                
                [dictParameter setValue:parameters forKey:@"requestData"];
                
                NSLog(@"bhejne%@", parameters);
                
                
                [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
                    
                    NSLog(@"neck nice%@", responseDict);
                   
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [appDelegate removeChargementLoader];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getallapoiment" object:nil];
                
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
                
                
            }]];
            
            
           
            [alertController addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getallapoiment" object:nil];
            }]];
            
            
            
            [appDelegate.navControl.topViewController presentViewController:alertController animated:YES completion:nil];
        }
        }
}

- (void)editComment2:(UIButton *)sender

{
    
    for (int i=0; i<localpavan_arr.count; i++)
    {
        NSDictionary *dictRating = [localpavan_arr objectAtIndex:i];
        NSString *questionid = [dictRating objectForKey:@"questionid"];
        NSInteger newmsgid = [questionid integerValue];
        
        if(newmsgid == 3)
        {
            
          //  NSDictionary *dictRating = [localpavan_arr objectAtIndex:i];
            NSString *comment = [dictRating objectForKey:@"comment"];
            NSString *apntmntId_loc = [dictRating objectForKey:@"apntmnt_id"];
            NSString *clun01_loc1 = [dictRating objectForKey:@"clun01"];
            NSString *clun01_loc = [self getDycryptString:clun01_loc1];
            
            NSString *clcnslrun01_loc1 = [dictRating objectForKey:@"clcnslrun01"];
            NSString *clcnslrun01_loc = [self getDycryptString:clcnslrun01_loc1];
            NSString *questionId_loc = [dictRating objectForKey:@"questionid"];
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Update comment"
                                                                                      message: @""
                                                                               preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = comment;
                textField.text = comment;
                textField.textColor = [UIColor blueColor];
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.borderStyle = UITextBorderStyleRoundedRect;
            }];
    
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSArray * textfields = alertController.textFields;
                UITextField * namefield = textfields[0];
                NSLog(@"%@",namefield.text);
               [appDelegate addChargementLoader];
        NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
       NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: namefield.text,apntmntId_loc,clun01_loc,clcnslrun01_loc,questionId_loc, nil] forKeys:[NSArray arrayWithObjects: @"comment",@"apntmntId",@"clun01",@"clcnslrun01",@"questionId",nil]];
               
                
                
                NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"updateCommentsbyCounsellor", data,nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data", nil]];
                
                [dictParameter setValue:parameters forKey:@"requestData"];
                
                [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
                   
                    NSLog(@"neck nice%@", responseDict);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [appDelegate removeChargementLoader];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getallapoiment" object:nil];
        
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
                
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"getallapoiment" object:nil];
            }]];
             [appDelegate.navControl.topViewController presentViewController:alertController animated:YES completion:nil];
        }
    }
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
- (void)showCounsellorName:(NSString *)strCounsellorId
{
    
}

    
   

    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Increse time duration" message:@"Do you want to increse 10 minutes our session?" preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //button click event
//
//        NSString *strAppointmentID = [dictAppointment objectForKey:@"apntmnt_id"];
//        [appDelegate addChargementLoader];
//        NSNumber *numDuration = [self.dictAppointment objectForKey:@"session_duration"];
//        NSLog(@"%@", numDuration);
//
//        NSMutableDictionary *dictParameter = [[NSMutableDictionary alloc] init];
//
//        NSDictionary *data = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects: strAppointmentID,numDuration, nil] forKeys:[NSArray arrayWithObjects: @"apntmntId",@"session_duration",nil]];
//
//        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:strKeyWebService, @"updateCousellingDuration", data,  @"true",nil] forKeys:[NSArray arrayWithObjects:@"apikey", @"requestType", @"data",@"updatedcounselling_time", nil]];
//
//        [dictParameter setValue:parameters forKey:@"requestData"];
//
//        NSLog(@"strClcnslrun01=%@", dictParameter);
//
//        [[appCounsellingLoginParser sharedManager] callWebServiceWithData:dictParameter success:^(NSDictionary *responseDict) {
//
//            NSLog(@"neck nice%@", responseDict);
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [appDelegate removeChargementLoader];
//
//                // btnTimeIncreament.hidden = YES;
//                // [[NSNotificationCenter defaultCenter]
//                //  postNotificationName:@"refreshLivepavan" object:nil];
//
//
//                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                [userDefault setObject:@"yes" forKey:@"pavanRef"];
//                NSLog(@"---pavan true ---");
//
//                LiveViewController *objLiveVC = [[LiveViewController alloc] init];
//                objLiveVC.strTitle = @"Live";
//                [appDelegate.navControl pushViewController:objLiveVC animated:YES];
//                //                objLiveVC = nil;
//
//            });
//        } failure:^(NSError *error) {
//            NSLog(@"---pavan false ---");
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(appDelegate.isServerswitched == NO){
//                    [appDelegate switchServer];
//                    //                [self getData];
//                }
//                else {
//                    [appDelegate removeChargementLoader];
//                }
//            });
//        }];
//
//    }];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        //button click event
//
//    }];
//    [alert addAction:cancel];
//    [alert addAction:ok];
//    [self presentViewController:alert animated:YES completion:nil];
    


@end
