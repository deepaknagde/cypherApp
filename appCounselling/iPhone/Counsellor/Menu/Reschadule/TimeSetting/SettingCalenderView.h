//
//  CalenderView.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 15/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingCalenderViewDelegate;
@interface SettingCalenderView : UIView
{
    NSDate *dateAfter35;
    float width;
    float height;
    
    __unsafe_unretained id <SettingCalenderViewDelegate>delegate;
    
    UIFont *fontOfCalender;
    NSDate *selectedDate;
    
    NSInteger intIndexNumber;
    NSInteger intToday;
    NSInteger intCurrentDate;
    NSInteger intCurrentMonth;
    NSInteger intCurrentYear;
    NSInteger intDiffOfMonth;
    NSInteger intNumberOfDaysInPrev_Month;
    UILabel *lblMonth_Year;
    UIImageView *imgViewDateSelecter;
    
    NSInteger totalDaysInMonth;
    NSInteger startingweekday;
    
    int after35Hours;
    NSDate *dateServer;
    //NSThread _thread1;
}
@property(nonatomic, retain) UIFont *fontOfCalender;
@property(nonatomic, retain) UIColor *fontColor;
@property(nonatomic, retain) NSDate *selectedDate;
@property(nonatomic) NSInteger intToday;
@property(nonatomic, assign) __unsafe_unretained id <SettingCalenderViewDelegate>delegate;
@property(nonatomic, retain) UILabel *lblMonth_Year;

@property(nonatomic, retain) NSDate *lastTimeSuggestedDate;

- (void)setDateToCalender:(NSDate *)calDate;
- (void)setTodayDateToCalender;

- (void)clearMemory;

@end

@protocol SettingCalenderViewDelegate <NSObject>

@optional
- (void)calenderDateChanged:(NSDate *)calDate;
@end

