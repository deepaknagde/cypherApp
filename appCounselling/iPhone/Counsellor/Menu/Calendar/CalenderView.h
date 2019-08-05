//
//  CalenderView.h
//  Calender
//
//  Created by VincentIT on 6/22/13.
//  Copyright (c) 2013 VincentIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalenderViewDelegate;
@interface CalenderView : UIView
{
    float width;
    float height;
    
    __unsafe_unretained id <CalenderViewDelegate>delegate;

    UIFont *fontOfCalender;
    NSDate *selectedDate;
    
    NSInteger intCurrYear;
    NSInteger intCurrMonth;
    
    NSInteger intIndexNumber;
    NSInteger intToday;
    NSInteger intCurrentDate;
    NSInteger intDiffOfMonth;
    NSInteger intNumberOfDaysInPrev_Month;
    UIButton *btnMonth_Year;
    UIButton *btnNext;
    UIButton *btnPrev;
    UIImageView *imgViewWeekDays;
    UIImageView *imgViewDateSelecter;
    
    NSInteger totalDaysInMonth;
    NSInteger startingweekday;
}
@property(nonatomic, strong) NSMutableArray *arrAppointmentKey;
@property(nonatomic, retain) UIFont *fontOfCalender;
@property(nonatomic, retain) NSDate *selectedDate;
@property(nonatomic) NSInteger intToday;
@property(nonatomic, assign) __unsafe_unretained id <CalenderViewDelegate>delegate;
@property(nonatomic, retain) UIButton *btnMonth_Year;

- (void)setDateToCalender:(NSDate *)calDate;
- (void)setTodayDateToCalender;

- (void)clearMemory;

@end

@protocol CalenderViewDelegate <NSObject>

@optional
- (void)calenderDateChanged:(NSDate *)calDate;

@optional
- (void)calenderMonthChanged:(NSDate *)calDate;

@end

