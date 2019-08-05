//
//  AppCounselllingLiveTimerViewController.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 27/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class AppDelegate;
@class MoodGraphView;
@interface AppCounselllingLiveTimerViewController : BaseViewController
{    
    UIView *viewTimer;
    UILabel *lblMins;
    UILabel *lblSecs;
    NSTimer *timer5Mins;
    
    int hours;
    int intTimeLeft;
    UIImage *imgMoodGraph;
    
    NSString *strMoodGraphURL;
    MoodGraphView *viewMoodGraph;
    
    UILabel *lblImpactQuestionStatus;
    
    UIButton *btnAssessmentForm;
}

@property (strong, nonatomic) NSDictionary *dictAppointment;

- (void)getLiveAppointment:(NSString *)q_id clun_01:(NSString *)clun_01;

@end
