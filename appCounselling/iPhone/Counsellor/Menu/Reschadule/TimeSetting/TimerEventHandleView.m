//
//  TimerEventHandleView.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 09/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import "TimerEventHandleView.h"

#define xSpace 60
#define ySpace 10

#define colorPink [UIColor colorWithRed:232.0/255 green:32.0/255 blue:106.0/255 alpha:1.0]

@implementation TimerEventHandleView

@synthesize delegate;

@synthesize dictBlokedSlots;
@synthesize strKey;

@synthesize intMinimumTimeMins;
@synthesize timeInterval;
@synthesize timeDuration;
@synthesize timeForBreak;

@synthesize intFrom, intTo;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lastMin = 0;
        [self screenDesigning];
    }
    return self;
}
- (void)screenDesigning
{
    timeForBreak = 15;//Mins
    NSArray *arrHour = [[NSArray alloc] initWithObjects:@"12 AM", @"1 AM", @"2 AM", @"3 AM", @"4 AM", @"5 AM", @"6 AM", @"7 AM", @"8 AM", @"9 AM", @"10 AM", @"11 AM", @"Noon", @"1 PM", @"2 PM", @"3 PM", @"4 PM", @"5 PM", @"6 PM", @"7 PM", @"8 PM", @"9 PM", @"10 PM", @"11 PM", @"12 AM",  nil];
    
    viewSlot = [[UILabel alloc] initWithFrame:CGRectMake(xSpace, ySpace+intMinimumTimeMins, self.frame.size.width-xSpace, timeDuration)];
    viewSlot.userInteractionEnabled = NO;
    viewSlot.textColor = [UIColor blackColor];
    viewSlot.text = @"New Counselling";
    viewSlot.font = [UIFont boldSystemFontOfSize:12.0];
    viewSlot.adjustsFontSizeToFitWidth = YES;
    //viewSlot.textAlignment = @"New Counselling";
    viewSlot.backgroundColor = [UIColor colorWithRed:41/255.0 green:178.0/255 blue:138/255.0 alpha:1.0];
    viewSlot.alpha = 0.5;
    [self addSubview:viewSlot];
    
    CGFloat yValue = ySpace;
    for (int i=0; i<arrHour.count; i++)
    {
        UILabel *lblHour = [[UILabel alloc] initWithFrame:CGRectMake(0, yValue-30, xSpace, 60)];
        lblHour.text = [NSString stringWithFormat:@"%@ -", [arrHour objectAtIndex:i]];
        lblHour.textAlignment = NSTextAlignmentRight;
        lblHour.font = [UIFont systemFontOfSize:10.0];
        lblHour.textColor = [UIColor blackColor];
        lblHour.backgroundColor = [UIColor whiteColor];
        [self addSubview:lblHour];
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(xSpace, yValue, self.frame.size.width-xSpace, 1)];
        viewLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:viewLine];
        
        yValue = yValue+60;
    }
    
    lblMinsToSlide = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, xSpace-6, 30)];
    lblMinsToSlide.text = @"";
    lblMinsToSlide.textAlignment = NSTextAlignmentRight;
    lblMinsToSlide.font = [UIFont boldSystemFontOfSize:11.0];
    lblMinsToSlide.textColor = [UIColor blackColor];
    lblMinsToSlide.backgroundColor = [UIColor clearColor];
    [self addSubview:lblMinsToSlide];

}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setStrKey:(NSString *)key
{
    strKey = key;
    [self blokTheBookedTimeSlots];
}

- (void)setIntMinimumTimeMins:(NSInteger)intMins
{
    intMinimumTimeMins = intMins;

    for (UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
            [view removeFromSuperview];
    }
    if(intMins>0)
    {
        //35 Hour Block
        UIButton *btnBlockTheTime = [[UIButton alloc] init];
        btnBlockTheTime.backgroundColor = colorPink;
        btnBlockTheTime.alpha = 0.5;
        btnBlockTheTime.frame = CGRectMake(xSpace, 0, self.frame.size.width-xSpace, ySpace+intMinimumTimeMins);
        [self addSubview:btnBlockTheTime];
    }
    
    viewSlot.frame = CGRectMake(xSpace, ySpace+intMinimumTimeMins, self.frame.size.width-xSpace, timeDuration);
}

- (void)blokTimeFromMin:(int)intF toTime:(int)intT
{
    UIButton *btnBlockTheTime = [[UIButton alloc] init];
    btnBlockTheTime.backgroundColor = colorPink;
    [btnBlockTheTime setTitle:@"No Counsellor available" forState:UIControlStateNormal];
    btnBlockTheTime.titleLabel.font = viewSlot.font = [UIFont boldSystemFontOfSize:14.0];
    btnBlockTheTime.alpha = 0.5;
//    CGFloat hh = intTo-intFrom;
    btnBlockTheTime.frame = CGRectMake(xSpace, ySpace+intFrom, self.frame.size.width-xSpace, intT-intF);
    [self addSubview:btnBlockTheTime];
}

- (void)setDictBlokedSlots:(NSMutableDictionary *)dictSlots
{
    dictBlokedSlots = dictSlots;
    [self blokTheBookedTimeSlots];
}

- (void)blokTheBookedTimeSlots
{
    NSArray *arrBloks = [dictBlokedSlots objectForKey:strKey];
    
    if(intMinimumTimeMins>0)
        viewSlot.frame = CGRectMake(xSpace, ySpace+intMinimumTimeMins, self.frame.size.width-xSpace, timeDuration);
    else if(intMinimumTimeMins==0 && (arrBloks.count == 0 || arrBloks==nil))
        viewSlot.frame = CGRectMake(xSpace, ySpace+intMinimumTimeMins, self.frame.size.width-xSpace, timeDuration);
    else
        viewSlot.frame = CGRectMake(xSpace, -60, self.frame.size.width-xSpace, timeDuration);

    for (int i=0; i<arrBloks.count; i++)
    {
        CGFloat yTimeToBlok = [[arrBloks objectAtIndex:i] integerValue];
        
        UIButton *btnBlockTheTime = [[UIButton alloc] init];
        [btnBlockTheTime setTitle:@"Counsellor Busy" forState:UIControlStateNormal];
        btnBlockTheTime.titleLabel.font = viewSlot.font = [UIFont boldSystemFontOfSize:14.0];
        btnBlockTheTime.backgroundColor = colorPink;
        btnBlockTheTime.alpha = 0.5;
        btnBlockTheTime.frame = CGRectMake(xSpace, yTimeToBlok+ySpace, self.frame.size.width-xSpace, timeDuration+timeForBreak);
        [self addSubview:btnBlockTheTime];
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self];
 
    NSLog(@"touch.timestamp=%f", touch.timestamp);
    
    if(touchPoint.y>=viewSlot.frame.origin.y && touchPoint.y<=viewSlot.frame.origin.y+viewSlot.frame.size.height && touchPoint.x>=viewSlot.frame.origin.x && touchPoint.x<=viewSlot.frame.origin.x+viewSlot.frame.size.width)// && touchPoint.y>=intMinimumTimeMins+ySpace)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(diableScroll)])
        {
            [self.delegate diableScroll];
        }
        if(touchPoint.y>=40 && touchPoint.y<=self.frame.size.height-30 && touchPoint.x>=xSpace)
        {
            viewSlot.center = CGPointMake(viewSlot.center.x, touchPoint.y);
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(enableScroll:)])
        {
            int inty = touchPoint.y-((timeDuration-1)/2)-ySpace;
            int intDiff = (inty%timeInterval);
            int y = inty-intDiff;
            int intmins = y;
            lastMin = intmins;
            
            if(touchPoint.y>=40 && touchPoint.y<=self.frame.size.height-30 && touchPoint.x>=xSpace)
            {
                int minstoshow = intmins%60;
                if(minstoshow>=10 && minstoshow<50)
                    lblMinsToSlide.text = [NSString stringWithFormat:@":%02i", minstoshow];
                else
                    lblMinsToSlide.text = @"";
                
                lblMinsToSlide.frame = CGRectMake(lblMinsToSlide.frame.origin.x, lastMin, lblMinsToSlide.frame.size.width, lblMinsToSlide.frame.size.height);
                viewSlot.frame = CGRectMake(xSpace, ySpace+y, self.frame.size.width-xSpace, timeDuration);
            }
            [self.delegate enableScroll:lastMin];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    
    int inty = touchPoint.y-((timeDuration-1)/2)-ySpace;
    int intDiff = (inty%timeInterval);
    int y = inty-intDiff;
    int intmins = y;
//    lastMin = intmins;
    
    if(touchPoint.y>=ySpace && touchPoint.y<=self.frame.size.height+20 && touchPoint.x>=xSpace)
    {
        int minstoshow = intmins%60;
        if(minstoshow>=10 && minstoshow<50)
            lblMinsToSlide.text = [NSString stringWithFormat:@":%02i", minstoshow];
        else
            lblMinsToSlide.text = @"";
        lblMinsToSlide.frame = CGRectMake(lblMinsToSlide.frame.origin.x, intmins, lblMinsToSlide.frame.size.width, lblMinsToSlide.frame.size.height);
        viewSlot.center = CGPointMake(viewSlot.center.x, touchPoint.y);
    }
//    if(touchPoint.y>=ySpace && touchPoint.y<=self.frame.size.height+20 && touchPoint.x>=xSpace)
//    {
//        viewSlot.center = CGPointMake(viewSlot.center.x, touchPoint.y);
//    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    int inty = viewSlot.center.y-((timeDuration-1)/2)-ySpace;
    int intDiff = (inty%timeInterval);
    
    int y = inty-intDiff;
    
    int intmins = y;

    if(intmins<intMinimumTimeMins)
    {
        intmins = (int)intMinimumTimeMins;
        viewSlot.frame = CGRectMake(xSpace, ySpace+intMinimumTimeMins, self.frame.size.width-xSpace, timeDuration);
    }
    else if(y>(24*60))//-timeDuration)
    {
        intmins = intmins-10;
        y=(24*60)-5;//-timeDuration;
        viewSlot.frame = CGRectMake(xSpace, ySpace+y, self.frame.size.width-xSpace, timeDuration);
    }
    else
    {
        if([self shouldShowLastTime:intmins])
        {
            intmins = lastMin;
            viewSlot.frame = CGRectMake(xSpace, ySpace+intmins, self.frame.size.width-xSpace, timeDuration);
        }
        else
        {
            viewSlot.frame = CGRectMake(xSpace, ySpace+intmins, self.frame.size.width-xSpace, timeDuration);
        }
    }
    lastMin = intmins;
    
    lblMinsToSlide.text = @"";

    if(self.delegate && [self.delegate respondsToSelector:@selector(enableScroll:)])
    {
        [self.delegate enableScroll:intmins];
    }
}

- (BOOL)shouldShowLastTime:(int)intMinsToCheck
{
    BOOL returnValue = NO;
    
    NSArray *arrBloks = [dictBlokedSlots objectForKey:strKey];
    
    for (int i=0; i<arrBloks.count; i++)
    {
        CGFloat yTimeToBlok = [[arrBloks objectAtIndex:i] integerValue];
        
        if(intMinsToCheck>yTimeToBlok-timeDuration-timeForBreak && intMinsToCheck<yTimeToBlok+timeDuration+timeForBreak)
        {
            returnValue = YES;
        }
    }
    // Check Admin Time
    
    if(intFrom<intTo)
    {
        //SameDay
        int intFromMin = intFrom*60;
        int intToMin = intTo*60;
        
        if(intMinsToCheck>intFromMin-timeDuration && intMinsToCheck<intToMin)
            returnValue = YES;
    }
    else if(intFrom>intTo)
    {
        int intFromMin = intFrom*60;
        int intToMin = intTo*60;
        
        if(intMinsToCheck>intFromMin-timeDuration && intMinsToCheck<=1440)//last time
            returnValue = YES;
        if(intMinsToCheck>=0 && intMinsToCheck<intToMin)//first time
            returnValue = YES;
    }

    
    return returnValue;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
