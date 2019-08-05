//
//  CalenderView.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 15/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import "SettingCalenderView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

#define colorPink [UIColor colorWithRed:232.0/255 green:32.0/255 blue:106.0/255 alpha:1.0]

#define xSpace 5
#define ySpace 4

@implementation SettingCalenderView

@synthesize fontOfCalender;
@synthesize selectedDate;
@synthesize intToday;
@synthesize lblMonth_Year;
@synthesize delegate;
@synthesize lastTimeSuggestedDate;

- (void)clearMemory
{
    fontOfCalender = nil;
    selectedDate = nil;
    lblMonth_Year = nil;
    imgViewDateSelecter = nil;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    after35Hours = 1;
    
    width = (frame.size.width-60)/7.0;
    height = ((frame.size.height-60)/6.0)-ySpace-2;
    
    imgViewDateSelecter.frame = CGRectMake(14, 60, width, height-2);
    lblMonth_Year.frame = CGRectMake(40, 00, frame.size.width-80, 40);
    
    [self setCalenderParameter:0];
    [self showWeekDays];
}
- (void)setFontOfCalender:(UIFont *)font
{
    fontOfCalender = font;
//    [self setCalenderParameter:0];
//    [self showWeekDays];
}
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code

        AppDelegate *appDelegate = (AppDelegate *)[AppDelegate sharedInstance];
        if(appDelegate.dateServer)
            dateServer = appDelegate.dateServer;
        else
            dateServer = [NSDate date];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        width = 29;
        height = 26;
        
        width = (frame.size.width-60)/7.0;
        height = ((frame.size.height-60)/6.0)-ySpace-2;

        // Initialization code
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            fontOfCalender = [UIFont fontWithName:@"Arial" size:15];
        else
            fontOfCalender = [UIFont fontWithName:@"Arial" size:30];

        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CalenderBG" ofType:@"png"]]];
        
        imgViewDateSelecter = [[UIImageView alloc] initWithFrame:CGRectMake(14, 60, width, 24)];
        [imgViewDateSelecter setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bluetile" ofType:@"png"]]];
        [self addSubview:imgViewDateSelecter];
        
        lblMonth_Year = [[UILabel alloc] initWithFrame:CGRectMake(10, 00, 244, 25)];
        lblMonth_Year.textColor = [UIColor blackColor];
        lblMonth_Year.adjustsFontSizeToFitWidth = YES;
        lblMonth_Year.font = fontOfCalender;
        lblMonth_Year.textAlignment = NSTextAlignmentCenter;
        lblMonth_Year.backgroundColor = [UIColor clearColor];
        [self addSubview:lblMonth_Year];
        
        imgViewDateSelecter.frame = CGRectMake(14, 60, width, height-2);
        lblMonth_Year.frame = CGRectMake(40, 00, frame.size.width-80, 40);
        
        [self setCalenderParameter:0];
        [self showWeekDays];
    }
    return self;
}

- (void)showWeekDays
{
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(self.frame.size.width-40, 00, 40, 40);
    btnNext.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17.0];
    [btnNext setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cal_right_arrow_off" ofType:@"png"]] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(gotoNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnNext];
    
    UIButton *btnPrev = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPrev.frame = CGRectMake(0, 00, 40, 40);
    btnPrev.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17.0];
    [btnPrev setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cal_left_arrow_off" ofType:@"png"]] forState:UIControlStateNormal];
    [btnPrev addTarget:self action:@selector(gotoPrevMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnPrev];
    
    float xRef = 15;
    
    NSArray *arrWeeks = [[NSArray alloc] initWithObjects:@"S", @"M", @"T", @"W", @"T", @"F", @"S", nil];
    for (int i=0; i<[arrWeeks count]; i++) {
        
        UILabel *lblWeekDay = [[UILabel alloc] initWithFrame:CGRectMake(xRef, 30, width, height>30?30:height)];
        if(i!=0)
            lblWeekDay.textColor = [UIColor blackColor];
        else
            lblWeekDay.textColor = [UIColor colorWithRed:204/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        lblWeekDay.text = [arrWeeks objectAtIndex:i];
        lblWeekDay.font = fontOfCalender;
        lblWeekDay.textAlignment = NSTextAlignmentCenter;
        lblWeekDay.backgroundColor = [UIColor clearColor];
        [self addSubview:lblWeekDay];
        xRef += 5+width;
    }
}

- (void)setCalenderParameter:(NSInteger)intMonth
{
    if(intMonth==0 && selectedDate==nil)
        selectedDate = dateServer;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MMMM - yyyy"];
    
    lblMonth_Year.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:selectedDate]];
    lblMonth_Year.font = fontOfCalender;
    
    [dateFormatter setDateFormat:@"dd"];
    intCurrentDate = [[dateFormatter stringFromDate:selectedDate] integerValue];
    intToday = [[dateFormatter stringFromDate:dateServer] integerValue];
    startingweekday = [self firstWeekDayNumberOfDate:selectedDate];

    [dateFormatter setDateFormat:@"MM"];
    intCurrentMonth = [[dateFormatter stringFromDate:selectedDate] integerValue];

    [dateFormatter setDateFormat:@"yyyy"];
    intCurrentYear = [[dateFormatter stringFromDate:selectedDate] integerValue];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    [cal setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSRange days = [cal rangeOfUnit:NSDayCalendarUnit
                             inUnit:NSMonthCalendarUnit
                            forDate:selectedDate];
    
    totalDaysInMonth = days.length;
    
    NSInteger flags = (NSHourCalendarUnit|NSMinuteCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSWeekdayOrdinalCalendarUnit);
    NSDateComponents *dateComponents = [cal components:flags fromDate:selectedDate];
    
    [dateComponents setMonth:[dateComponents month]-1];
    
    NSDate *prev_Month = [cal dateFromComponents:dateComponents];
    NSRange days_prv_month = [cal rangeOfUnit:NSDayCalendarUnit
                                       inUnit:NSMonthCalendarUnit
                                      forDate:prev_Month];
    intNumberOfDaysInPrev_Month = days_prv_month.length;
    
    int DateToShow = 1;
    
    float xRef = 15;
    float yRef = 60;
    
    for(UIView *view in self.subviews)
        [view removeFromSuperview];
    
    [self addSubview:imgViewDateSelecter];
    [self addSubview:lblMonth_Year];
    
    for (int i=0; i<6; i++)
    {
        for (int j=1; j<=7; j++)
        {
            UILabel *lblDateInCAl = [[UILabel alloc] initWithFrame:CGRectMake(xRef, yRef, width, height)];
            lblDateInCAl.font = fontOfCalender;
            lblDateInCAl.textAlignment = NSTextAlignmentCenter;
            lblDateInCAl.layer.borderColor = [UIColor lightGrayColor].CGColor;
            lblDateInCAl.layer.borderWidth = 0.5;
            
            //Prev month date showing
            if(i==0 && j<startingweekday)// || (i==0 && startingweekday==1))
            {
                lblDateInCAl.alpha = 0.5;
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", intNumberOfDaysInPrev_Month-(startingweekday-j-1)];
                
                NSString *strDate = [NSString stringWithFormat:@"%@/%2i/%i", lblDateInCAl.text, (intCurrentMonth-1)==0?12:intCurrentMonth-1, (intCurrentMonth-1)==0?intCurrentYear-1:intCurrentYear];
                [self disableTheDate:xRef andY:yRef withDateString:strDate];
            }
            else if(i==0 && j>=startingweekday)//Curr Month
            {
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", DateToShow++];
                NSString *strDate = [NSString stringWithFormat:@"%@/%2i/%i", lblDateInCAl.text, intCurrentMonth, intCurrentYear];
                [self disableTheDate:xRef andY:yRef withDateString:strDate];
            }
            else if(i>0 && DateToShow<=totalDaysInMonth)// curr month
            {
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", DateToShow++];
                NSString *strDate = [NSString stringWithFormat:@"%@/%2i/%i", lblDateInCAl.text, intCurrentMonth, intCurrentYear];
                [self disableTheDate:xRef andY:yRef withDateString:strDate];
            }
            else if(DateToShow>=totalDaysInMonth+1)// Next Month
            {
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", DateToShow-totalDaysInMonth];
                DateToShow++;
                lblDateInCAl.alpha = 0.5;
            
                NSString *strDate = [NSString stringWithFormat:@"%@/%2i/%i", lblDateInCAl.text, intCurrentMonth==12?1:intCurrentMonth+1, intCurrentMonth==12?intCurrentYear+1:intCurrentYear];
                [self disableTheDate:xRef andY:yRef withDateString:strDate];
            }
            
            if(j==1)
            {
                lblDateInCAl.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:10/255.0 alpha:0.20];
                lblDateInCAl.textColor = [UIColor colorWithRed:204/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
            }
            else
            {
                lblDateInCAl.backgroundColor = [UIColor clearColor];
                lblDateInCAl.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            }
            
            [self addSubview:lblDateInCAl];
            
            xRef += width+xSpace;
            
            // Set Current date highlited as
            NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
            [dateFormat_first setDateFormat:@"dd"];
            NSString *strCurrMonth_MMM = [dateFormat_first stringFromDate:dateServer];
            
            if(intDiffOfMonth == 0 && [strCurrMonth_MMM integerValue] == DateToShow-1) {
                lblDateInCAl.layer.borderColor = [UIColor colorWithRed:204/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
                lblDateInCAl.layer.borderWidth = 2.0;
            }
        }
        xRef = 15;
        yRef += height+ySpace;
    }
    
    if(intMonth!=2)
    {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        [animation  setDuration:0.4];
        if(intMonth==-1)
        {
            animation.type=@"push";
            animation.subtype=kCATransitionFromRight;
        }
        else if(intMonth==1)
        {
            animation.type=@"push";
            animation.subtype=kCATransitionFromLeft;
        }
        
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [[self layer] addAnimation:animation forKey:@"cube"];
    }
    
    int intPOS_X = (intCurrentDate + startingweekday-2)%7;
    int intPOS_Y = (intCurrentDate + startingweekday-2)/7;
    
    imgViewDateSelecter.center = CGPointMake((width/2.0)+15+((width+5)*intPOS_X), 60+(height/2.0)+((height+4)*intPOS_Y));
}

// Date in DD/MM/YYYY
- (void)disableTheDate:(CGFloat)xRef andY:(CGFloat)yRef withDateString:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];

    NSDate *datePassed = [dateFormatter dateFromString:strDate];

    if([self isEndDateIsSmallerThan35Hours:datePassed] || [self dateIsBooked:datePassed] || [self isEndDateIsAfter365:datePassed])
    {
//        NSLog(@"datePassed = %@", datePassed);
        UIButton *viewBlocked = [[UIButton alloc] initWithFrame:CGRectMake(xRef-6, yRef-2, width+12, height+4)];
        viewBlocked.userInteractionEnabled = YES;
        viewBlocked.backgroundColor = colorPink;
        viewBlocked.alpha = 0.2;
        [self addSubview:viewBlocked];
    }
}
//- (BOOL)isBeforeLastTimeSuggested:(NSDate *)checkEndDate
//{
//    if(lastTimeSuggestedDate)
//    {
//        NSDate *enddate = checkEndDate;
//        NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:lastTimeSuggestedDate];
//        double secondsInMinute = 60;
//        NSInteger minsBetweenDates = distanceBetweenDates / secondsInMinute;
//        NSInteger hoursBetweenDates = minsBetweenDates / 60;
//        if (hoursBetweenDates < -23)
//        {
//            return YES;
//        }
//        else if (hoursBetweenDates == 0)
//        {
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
//    }
//    else
//    {
//        return NO;
//    }
//}

- (BOOL)isEndDateIsSmallerThan35Hours:(NSDate *)checkEndDate
{
    NSDate *add35Hours;
    if(lastTimeSuggestedDate)
        add35Hours = lastTimeSuggestedDate;
    else
        add35Hours = [dateServer dateByAddingTimeInterval:(after35Hours*60*60)];
    
    NSDate *enddate = checkEndDate;
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:add35Hours];
    double secondsInMinute = 60;
    NSInteger minsBetweenDates = distanceBetweenDates / secondsInMinute;
    NSInteger hoursBetweenDates = minsBetweenDates / 60;
    if (hoursBetweenDates < -23)
    {
        return YES;
    }
    else if (hoursBetweenDates == 0)
    {
        return NO;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isEndDateIsAfter365:(NSDate *)checkEndDate
{
    NSTimeInterval distanceBetweenDates = [checkEndDate timeIntervalSinceDate:dateServer];
    
    long seconds = lroundf(distanceBetweenDates);
    int days = (seconds / 3600)/24;
    
    if(days>363)
    {
        return YES;
    }

    return NO;
}

- (NSInteger)hoursBetween:(NSDate *)firstDate and:(NSDate *)secondDate {
    firstDate = [dateServer dateByAddingTimeInterval:(after35Hours*60*60)];
    NSUInteger unitFlags = NSCalendarUnitHour;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:firstDate toDate:secondDate options:0];
    return [components hour]+1;
}

- (BOOL)dateIsBooked:(NSDate *)dateToCheck
{
    return NO;
}

- (NSInteger)firstWeekDayNumberOfDate:(NSDate *)arbitraryDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:arbitraryDate];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    
    NSDateComponents* compWeek = [gregorian components:NSWeekdayCalendarUnit fromDate:firstDayOfMonthDate];
    
    return [compWeek weekday]; // 1 = Sunday, 2 = Monday, etc.
}

- (void)animationDidStart:(CAAnimation *)anim
{
    self.userInteractionEnabled =  NO;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.userInteractionEnabled = YES;
}
#pragma mark - touch delegates methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if((touchPoint.y>=55 && touchPoint.y<self.frame.size.height-15) && (touchPoint.x>=9 && touchPoint.x<self.frame.size.width-15))
    {
        int intPOS_X = (touchPoint.x-14)/(width+5);
        int intPOS_Y = (touchPoint.y-60)/(height+ySpace);
        intIndexNumber = (intPOS_Y*7) + intPOS_X+1;
        imgViewDateSelecter.center = CGPointMake((width/2.0)+15+((width+5)*intPOS_X), 60+(height/2.0)+((height+4)*intPOS_Y));
        [self dateChanged:intIndexNumber andWeekStart:startingweekday];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint touchPoint = [touch locationInView:self];
//    
//    if((touchPoint.y>=55 && touchPoint.y<235) && (touchPoint.x>=9 && touchPoint.x<self.frame.size.width-15))
//    {
//        int intPOS_X = (touchPoint.x-14)/(width+5);
//        int intPOS_Y = (touchPoint.y-60)/(height+ySpace);
//        intIndexNumber = (intPOS_Y*7) + intPOS_X+1;
//        imgViewDateSelecter.center = CGPointMake((width/2.0)+15+((width+5)*intPOS_X), 60+(height/2.0)+((height+4)*intPOS_Y));
//        [self dateChanged:intIndexNumber andWeekStart:startingweekday];
//    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)dateChanged:(NSInteger)index andWeekStart:(NSInteger)weekStartDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:dateServer];
    
    NSDateComponents *components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    //Previous
    if(index-weekStartDay<0)
    {
        self.userInteractionEnabled =  NO;
        --intDiffOfMonth;
        [components setMonth:([components month] + intDiffOfMonth)];
        
        [components setDay:1+intNumberOfDaysInPrev_Month-weekStartDay+index];
        NSDate *lastMonth = [cal dateFromComponents:components];
        selectedDate = lastMonth;
        [self setCalenderParameter:1];
        [self showWeekDays];
    }//Next
    else if(index-weekStartDay>=totalDaysInMonth)
    {
        self.userInteractionEnabled =  NO;
        ++intDiffOfMonth;
        [components setMonth:([components month] + intDiffOfMonth)];
        [components setDay:1+index-weekStartDay-totalDaysInMonth];
        NSDate *nextMonth = [cal dateFromComponents:components];
        selectedDate = nextMonth;
        [self setCalenderParameter:-1];
        [self showWeekDays];
    }
    else
    {
        [components setMonth:([components month] + intDiffOfMonth)];
        [components setDay:index - weekStartDay+1];
        NSDate *currDate = [cal dateFromComponents:components];
        selectedDate = currDate;
    }
    
    if(self.delegate!=nil && [(id)[self delegate] respondsToSelector:@selector(calenderDateChanged:)])
    {
        [(id)[self delegate] calenderDateChanged:selectedDate];
    }
}

// this Method is calling from Bottom Slider
- (void)setDateToCalender:(NSDate *)calDate
{
    // Checking if date is of current month then set intDiffOfMonth = 0;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:dateServer];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:calDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        //do stuff
        intDiffOfMonth = 0;
    }
    
    selectedDate = calDate;
    [self setCalenderParameter:2];
    
    
    if(self.delegate!=nil && [(id)[self delegate] respondsToSelector:@selector(calenderDateChanged:)])
    {
        [(id)[self delegate] calenderDateChanged:selectedDate];
    }
    
}

- (void)setTodayDateToCalender
{
    intDiffOfMonth = 0;
    selectedDate = dateServer;
    [self setCalenderParameter:0];
    
    if(self.delegate!=nil && [(id)[self delegate] respondsToSelector:@selector(calenderDateChanged:)])
    {
        [(id)[self delegate] calenderDateChanged:selectedDate];
    }
}

#pragma mark - Actions
- (void)gotoNextMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:dateServer];
    
    NSDateComponents *components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    self.userInteractionEnabled =  NO;
    ++intDiffOfMonth;
    [components setMonth:([components month] + intDiffOfMonth)];
    [components setDay:1];
    NSDate *nextMonth = [cal dateFromComponents:components];
    selectedDate = nextMonth;
    [self setCalenderParameter:-1];
    [self showWeekDays];
    
    //    if(self.delegate!=nil && [(id)[self delegate] respondsToSelector:@selector(calenderDateChanged:)])
    //	{
    //		[(id)[self delegate] calenderDateChanged:selectedDate];
    //	}
}
- (void)gotoPrevMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:dateServer];
    
    NSDateComponents *components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    self.userInteractionEnabled =  NO;
    --intDiffOfMonth;
    [components setMonth:([components month] + intDiffOfMonth)];
    
    [components setDay:1];
    NSDate *lastMonth = [cal dateFromComponents:components];
    selectedDate = lastMonth;
    [self setCalenderParameter:1];
    [self showWeekDays];
    
    //    if(self.delegate!=nil && [(id)[self delegate] respondsToSelector:@selector(calenderDateChanged:)])
    //	{
    //		[(id)[self delegate] calenderDateChanged:selectedDate];
    //	}
}
@end
