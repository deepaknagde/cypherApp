//
//  CounsellorAppointmentCell.h
//  appCounselling
//
//  Created by MindCrew Technologies on 06/12/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXStarRatingView, AppDelegate;
@interface CounsellorAppointmentCell : UITableViewCell
{
    AppDelegate *appDelegate;
    
    NSThread *_thread1;
    UIActivityIndicatorView *indicator1;
    
    UILabel *lblCounsellor;
    UILabel *lblUser;
    UILabel *lblDate;
    UILabel *lblMode;
    UILabel *lblAppointmentStatus;
    UILabel *lblSession;
    
    
    UILabel *lblUserRating;
    UIButton *btnUserRating2;
    UIButton *btnUserRating4;
    UIButton *btnUserRating5;
    
    UILabel *lblCounsellorRating;
    UIButton *btnCounsellorRating1;
    UIButton *btnCounsellorRating3;
    UIButton *btnCounsellorComment1;
    UIButton *btnCounsellorComment3;
    UIButton *btnCommentEdit;
    UIButton *btnCommentEdit2;

    UILabel *lblRatingComment1;
    UILabel *lblRatingComment3;

    
    NSString *strAppointmentID;
    NSMutableArray *arrAppointmentRating;
     NSMutableArray *localpavan_arr;
    
    UIView *viewRatingBG2;
    DXStarRatingView *starRatingView2;
    
    UIView *viewRatingBG4;
    DXStarRatingView *starRatingView4;

    UIView *viewRatingBG5;
    DXStarRatingView *starRatingView5;

    UIView *viewRatingBG7;
    DXStarRatingView *starRatingView7;
    
    UIView *viewRatingBG1;
    DXStarRatingView *starRatingView1;

    UIView *viewRatingBG3;
    DXStarRatingView *starRatingView3;

}

- (void)showAppointments:(NSDictionary *)dictAppointment;
- (void)showRatingOfAppointment:(NSMutableArray *)arrRatings;
- (void)showCounsellorName:(NSString *)strCounsellorId;
@property(nonatomic, strong) UIView *alertView;
@end

