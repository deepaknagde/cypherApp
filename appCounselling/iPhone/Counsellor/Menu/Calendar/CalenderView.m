
//
//  CalenderView.m
//  Calender
//
//  Created by VincentIT on 6/22/13.
//  Copyright (c) 2013 VincentIT. All rights reserved.
//

#import "CalenderView.h"
#import <QuartzCore/QuartzCore.h>

#define xSpace 0
#define ySpace 0

@implementation CalenderView

@synthesize arrAppointmentKey;
@synthesize fontOfCalender;
@synthesize selectedDate;
@synthesize intToday;
@synthesize btnMonth_Year;
@synthesize delegate;

- (void)clearMemory
{
    btnPrev = nil;
    btnNext = nil;
    
    fontOfCalender = nil;
    selectedDate = nil;
    btnMonth_Year = nil;
    imgViewDateSelecter = nil;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    width = (frame.size.width-60)/7.0;
    width = (frame.size.width)/7.0;

    height = ((frame.size.height-72)/6.0)-ySpace-2;
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        imgViewDateSelecter.frame = CGRectMake(14, 84.5, width, height-1);
    else
        imgViewDateSelecter.frame = CGRectMake(14, 59.5, width, height-1);
    
    btnMonth_Year.frame = CGRectMake(40, 00, frame.size.width-80, 40);
    [btnMonth_Year setBackgroundImage:[UIImage imageNamed:@"calendar_tile_sssmall.png"] forState:UIControlStateNormal];
    
    [self setCalenderParameter:0];
    [self showWeekDays];
}
- (void)setFontOfCalender:(UIFont *)font
{
    fontOfCalender = font;
    [self setCalenderParameter:0];   
    [self showWeekDays];
}
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
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
        width = (frame.size.width)/7.0;
        height = ((frame.size.height-72)/6.0)-ySpace-2;

        // Initialization code
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            fontOfCalender = [UIFont fontWithName:@"Arial" size:15];
        else
            fontOfCalender = [UIFont fontWithName:@"Arial" size:30];

        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CalenderBG" ofType:@"png"]]];
        
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
            imgViewDateSelecter = [[UIImageView alloc] initWithFrame:CGRectMake(14, 84.5, width, 24)];
        else
            imgViewDateSelecter = [[UIImageView alloc] initWithFrame:CGRectMake(14, 60, width, 24)];
        
        [imgViewDateSelecter setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bluetile" ofType:@"png"]]];
        [self addSubview:imgViewDateSelecter];
        
        btnMonth_Year = [[UIButton alloc] initWithFrame:CGRectMake(10, 00, 244, 25)];
        [btnMonth_Year setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnMonth_Year.titleLabel.font = fontOfCalender;
//        lblMonth_Year.textAlignment = NSTextAlignmentCenter;
        btnMonth_Year.backgroundColor = [UIColor clearColor];
        [self addSubview:btnMonth_Year];

        
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
            imgViewDateSelecter.frame = CGRectMake(1, 84.5, width, height-1);
        else
            imgViewDateSelecter.frame = CGRectMake(1, 59.5, width, height-1);
        
        btnMonth_Year.frame = CGRectMake(40, 00, frame.size.width-80, 40);

        [self setCalenderParameter:0];
        [self showWeekDays];
    }
    return self;
}

- (void)showWeekDays
{
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame = CGRectMake(self.frame.size.width-40, 00, 40, 40);
    btnNext.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17.0];
    [btnNext setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cal_right_arrow_off" ofType:@"png"]] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(gotoNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnNext];
    
    btnPrev = [UIButton buttonWithType:UIButtonTypeCustom];
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
        lblWeekDay.text = @"";//[arrWeeks objectAtIndex:i];
        lblWeekDay.font = fontOfCalender;
        lblWeekDay.textAlignment = NSTextAlignmentCenter;
        lblWeekDay.backgroundColor = [UIColor clearColor];
        [self addSubview:lblWeekDay];
        xRef += 5+width;
    }
    
    imgViewWeekDays = [[UIImageView alloc] init];
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        imgViewWeekDays.frame = CGRectMake(0, 40, self.frame.size.width+2, 20);
    else
        imgViewWeekDays.frame = CGRectMake(0, 40, self.frame.size.width+2, 45);

    imgViewWeekDays.image = [UIImage imageNamed:@"calendar_days.png"];
    [self addSubview:imgViewWeekDays];
}

- (void)setCalenderParameter:(NSInteger)intMonth
{    
    if(intMonth==0)
        selectedDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MMMM - yyyy"];
    
    [btnMonth_Year setTitle:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:selectedDate]] forState:UIControlStateNormal];
    btnMonth_Year.titleLabel.font = fontOfCalender;
    
    
    [dateFormatter setDateFormat:@"yyyy"];
    intCurrYear = [[dateFormatter stringFromDate:selectedDate] integerValue];

    [dateFormatter setDateFormat:@"MM"];
    intCurrMonth = [[dateFormatter stringFromDate:selectedDate] integerValue];

    [dateFormatter setDateFormat:@"dd"];
    intCurrentDate = [[dateFormatter stringFromDate:selectedDate] integerValue];
    intToday = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    startingweekday = [self firstWeekDayNumberOfDate:selectedDate];
    
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
    
    xRef = 0;
    yRef = 60;

    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        yRef = 85;
    
    for(UIView *view in self.subviews)
        [view removeFromSuperview];
    
    [self addSubview:imgViewDateSelecter];
    [self addSubview:btnMonth_Year];
    [self addSubview:btnNext];
    [self addSubview:btnPrev];
    [self addSubview:imgViewWeekDays];
    
    for (int i=0; i<6; i++)
    {
        for (int j=1; j<=7; j++)
        {
            UILabel *lblDateInCAl = [[UILabel alloc] initWithFrame:CGRectMake(xRef, yRef, width, height)];
            lblDateInCAl.font = fontOfCalender;
            lblDateInCAl.textAlignment = NSTextAlignmentCenter;
            lblDateInCAl.layer.borderColor = [UIColor grayColor].CGColor;
            lblDateInCAl.layer.borderWidth = 0.5;
            
            //Prev month date showing
            if(i==0 && j<startingweekday)// || (i==0 && startingweekday==1))
            {
                lblDateInCAl.alpha = 0.5;
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", intNumberOfDaysInPrev_Month-(startingweekday-j-1)];
            }
            else if(i==0 && j>=startingweekday)//Curr Month
            {
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", DateToShow++];
            }
            else if(i>0 && DateToShow<=totalDaysInMonth)// curr month
            {
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", DateToShow++];
            }
            else if(DateToShow>=totalDaysInMonth+1)// Next Month
            {
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", DateToShow-totalDaysInMonth];
                DateToShow++;
                lblDateInCAl.alpha = 0.5;
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
            NSString *strCurrMonth_MMM = [dateFormat_first stringFromDate:[NSDate date]];
            
            if(intDiffOfMonth == 0 && [strCurrMonth_MMM integerValue] == DateToShow-1)
            {
                lblDateInCAl.layer.borderColor = [UIColor colorWithRed:204/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
                lblDateInCAl.layer.borderWidth = 2.0;
            }
            else
            {
                if(arrAppointmentKey!=nil)
                {
                    NSString *strTempDate = [NSString stringWithFormat:@"%02i/%02i/%02i", intCurrMonth, DateToShow-1, intCurrYear];
                    if([arrAppointmentKey containsObject:strTempDate])
                    {
                        lblDateInCAl.backgroundColor = [UIColor colorWithRed:130/255.0 green:184/255.0 blue:248/255.0 alpha:1.0];
                    }
                }
            }
        }
        xRef = 15;
        xRef = 0;
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
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        imgViewDateSelecter.center = CGPointMake((width/2.0)+((width)*intPOS_X), 85+(height/2.0)+((height)*intPOS_Y));
    else
        imgViewDateSelecter.center = CGPointMake((width/2.0)+((width)*intPOS_X), 60+(height/2.0)+((height)*intPOS_Y));
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
    
    if(touchPoint.y>=55 && touchPoint.y<self.frame.size.height-24)
    {
        int intPOS_X = (touchPoint.x)/(width);
        int intPOS_Y = (touchPoint.y-60)/(height+ySpace);
        intIndexNumber = (intPOS_Y*7) + intPOS_X+1;
        
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
            imgViewDateSelecter.center = CGPointMake((width/2.0)+((width)*intPOS_X), 85+(height/2.0)+((height)*intPOS_Y));
        else
            imgViewDateSelecter.center = CGPointMake((width/2.0)+((width)*intPOS_X), 60+(height/2.0)+((height)*intPOS_Y));

        [self dateChanged:intIndexNumber andWeekStart:startingweekday];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if(touchPoint.y>=55 && touchPoint.y<self.frame.size.height-24)
    {
        int intPOS_X = (touchPoint.x)/(width);
        int intPOS_Y = (touchPoint.y-60)/(height+ySpace);
        intIndexNumber = (intPOS_Y*7) + intPOS_X+1;
        
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
            imgViewDateSelecter.center = CGPointMake((width/2.0)+((width)*intPOS_X), 85+(height/2.0)+((height)*intPOS_Y));
        else
            imgViewDateSelecter.center = CGPointMake((width/2.0)+((width)*intPOS_X), 60+(height/2.0)+((height)*intPOS_Y));

        [self dateChanged:intIndexNumber andWeekStart:startingweekday];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)dateChanged:(NSInteger)index andWeekStart:(NSInteger)weekStartDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];

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
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:[NSDate date]];
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
    selectedDate = [NSDate date];
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
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    self.userInteractionEnabled =  NO;
    ++intDiffOfMonth;
    [components setMonth:([components month] + intDiffOfMonth)];
    [components setDay:1];
    NSDate *nextMonth = [cal dateFromComponents:components];
    selectedDate = nextMonth;
    [self setCalenderParameter:-1];
    [self showWeekDays];
        
    if(self.delegate!=nil && [(id)[self delegate] respondsToSelector:@selector(calenderMonthChanged:)])
	{
		[(id)[self delegate] calenderMonthChanged:selectedDate];
	}
}
- (void)gotoPrevMonth
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    self.userInteractionEnabled =  NO;
    --intDiffOfMonth;
    [components setMonth:([components month] + intDiffOfMonth)];
    
    [components setDay:1];
    NSDate *lastMonth = [cal dateFromComponents:components];
    selectedDate = lastMonth;
    [self setCalenderParameter:1];
    [self showWeekDays];

    if(self.delegate!=nil && [(id)[self delegate] respondsToSelector:@selector(calenderMonthChanged:)])
    {
        [(id)[self delegate] calenderMonthChanged:selectedDate];
    }
}

- (void)showDateHighlight
{
    int DateToShow = 1;

    float xRef = 15;
    float yRef = 60;
    xRef = 0;
    yRef = 60;

    for (int i=0; i<6; i++)
    {
        for (int j=1; j<=7; j++)
        {
            UILabel *lblDateInCAl = [[UILabel alloc] initWithFrame:CGRectMake(xRef, yRef, width, height)];
            lblDateInCAl.font = fontOfCalender;
            lblDateInCAl.textAlignment = NSTextAlignmentCenter;
            lblDateInCAl.layer.borderColor = [UIColor grayColor].CGColor;
            lblDateInCAl.layer.borderWidth = 0.5;
            
            //Prev month date showing
            if(i==0 && j<startingweekday)// || (i==0 && startingweekday==1))
            {
                lblDateInCAl.alpha = 0.5;
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", intNumberOfDaysInPrev_Month-(startingweekday-j-1)];
            }
            else if(i==0 && j>=startingweekday)//Curr Month
            {
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", DateToShow++];
            }
            else if(i>0 && DateToShow<=totalDaysInMonth)// curr month
            {
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", DateToShow++];
            }
            else if(DateToShow>=totalDaysInMonth+1)// Next Month
            {
                lblDateInCAl.text = [NSString stringWithFormat:@"%i", DateToShow-totalDaysInMonth];
                DateToShow++;
                lblDateInCAl.alpha = 0.5;
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
            NSString *strCurrMonth_MMM = [dateFormat_first stringFromDate:[NSDate date]];
            
            if(intDiffOfMonth == 0 && [strCurrMonth_MMM integerValue] == DateToShow-1)
            {
                lblDateInCAl.layer.borderColor = [UIColor colorWithRed:204/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
                lblDateInCAl.layer.borderWidth = 2.0;
            }
            else
            {
                //                NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
                //                [dateFormat_first setDateFormat:@"dd"];
                //                NSString *strCurrMonth_MMM = [dateFormat_first stringFromDate:[NSDate date]];
                
                //intDiffOfMonth
                //                if(YES)
                //                lblDateInCAl.backgroundColor = [UIColor colorWithRed:130/255.0 green:184/255.0 blue:248/255.0 alpha:1.0];
            }
        }
        xRef = 15;
        xRef = 0;
        yRef += height+ySpace;
    }
}


@end
