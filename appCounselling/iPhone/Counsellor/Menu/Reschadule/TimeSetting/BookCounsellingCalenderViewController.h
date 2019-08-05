//
//  BookCounsellingCalenderViewController.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 15/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SettingCalenderView.h"
#import "TimeSlotView.h"

@class AppDelegate;
@interface BookCounsellingCalenderViewController : BaseViewController<SettingCalenderViewDelegate, TimeSlotViewDelegate>
{
    int after35Hours;
    
    SettingCalenderView *viewCalender;
    NSString *strSelectedDate;
    NSDate *selectedDate;
    NSDate *calenderDate;
    UIButton *btnSameCounsellor;
    UIButton *btnChat;
    UIButton *btnAudeo;
    UIButton *btnVideo;
    UIView *viewSelectedIndicator;
    
    UIView *viewTimeSlotBG;
    UILabel *lblDate;    
    
    UIButton *btnClose;
    
    NSMutableArray *arrCounsellorAppointment;
    BOOL isTimeSlotSelected;
    
    TimeSlotView *viewTimeSlot;
    
    int intFrom;
    int intTo;

}

@property(nonatomic) BOOL isNewTimeSuggestion;
@property(strong, nonatomic) NSMutableDictionary *dictAppointment;
@property(strong, nonatomic) NSString *strCounsellorID;

@end
