//
//  AppCounsellingRattingViewController.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 03/10/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "RateView.h"
#import "AppCounsellingChatBL.h"

@interface AppCounsellingRattingViewController : BaseViewController <RateViewDelegate, AppCounsellingChatBLDelegate, UITextViewDelegate>
{
    AppCounsellingChatBL *objAppCounsellingBL;
    
    BOOL isRattingPending;
    BOOL isCommentPending;
    BOOL isPopUpShown;
    
      UILabel *Placeholder_LB_TV;
    
    NSMutableDictionary *dictCurrQuestion;
    NSString*  apntmnt_id;
    int intCommentCount;
    
//    UITextView *txtViewFeedback1;
//    UITextView *txtViewFeedback2;
    
    NSString *strClcnslrun01;
    NSString *strClun01;
    NSString *strQid;

}
@property (strong, nonatomic)UIScrollView *overlayFeedback;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIView *alertView;


@property (strong, nonatomic)UIView *overlay1;
@property (strong, nonatomic) NSDictionary *dictAppointment;
@property (strong, nonatomic) RateView *rateView1;

@property (strong, nonatomic) NSMutableArray *arrRattingQuestions;

@property(nonatomic, retain) NSString *strClcnslrun01;
@property(nonatomic, retain) NSString *strClun01;
@property(nonatomic, retain) NSString *strQid;

@end
