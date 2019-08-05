//
//  TimeSlotView.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 09/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import "TimeSlotView.h"

@implementation TimeSlotView

@synthesize delegate;

@synthesize dictBlokedSlots;
@synthesize strKey;

@synthesize intMinimumTimeMins;
@synthesize timeInterval;
@synthesize timeDuration;

@synthesize intFrom, intTo;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        scrlBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrlBG.backgroundColor = [UIColor clearColor];
        scrlBG.contentSize = CGSizeMake(frame.size.width, (60*24)+60);
        [self addSubview:scrlBG];
        
        viewTouch = [[TimerEventHandleView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, (60*24)+20)];
        viewTouch.intMinimumTimeMins = intMinimumTimeMins;
        viewTouch.delegate = self;
        viewTouch.backgroundColor = [UIColor clearColor];
        [scrlBG addSubview:viewTouch];

    }
    return self;
}
- (void)screenDesigning
{
    NSArray *arrHour = [[NSArray alloc] initWithObjects:@"12", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"Noon", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12",  nil];
    CGFloat xRef = 40;
    CGFloat yRef = 10;
    
    for (int i=0; i<arrHour.count; i++)
    {
        UILabel *lblHour = [[UILabel alloc] initWithFrame:CGRectMake(xRef-20, yRef-10, self.frame.size.width-xRef, 20)];
        lblHour.text = [arrHour objectAtIndex:i];
        lblHour.textColor = [UIColor blackColor];
        lblHour.backgroundColor = [UIColor clearColor];
        [self addSubview:lblHour];
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(xRef, yRef, self.frame.size.width-xRef, 1)];
        viewLine.backgroundColor = [UIColor blackColor];
        [self addSubview:viewLine];
    }
}
- (void)enableScroll:(int)intmins
{
    NSLog(@"intmins = %i", intmins);
    scrlBG.scrollEnabled = YES;

    if(self.delegate && [self.delegate respondsToSelector:@selector(timeSelectedInMins:)])
    {
        [self.delegate timeSelectedInMins:intmins];
    }
}

- (void)diableScroll
{
    scrlBG.scrollEnabled = NO;
}

- (void)setStrKey:(NSString *)key
{
    strKey = key;
    viewTouch.strKey = key;
}

- (void)setDictBlokedSlots:(NSMutableDictionary *)dictSlots
{
    dictBlokedSlots = dictSlots;
    viewTouch.dictBlokedSlots = dictSlots;
}

- (void)setTimeDuration:(NSInteger)timeDur
{
    timeDuration = timeDur;
    viewTouch.timeDuration = timeDur;
}
- (void)setTimeInterval:(NSInteger)timeInter
{
    timeInterval = timeInter;
    viewTouch.timeInterval = timeInter;
}
- (void)setIntMinimumTimeMins:(NSInteger)intMins
{
    intMinimumTimeMins = intMins;
    viewTouch.intMinimumTimeMins = intMins;

    viewTouch.intFrom = self.intFrom;
    viewTouch.intTo = self.intTo;

    [self blokAdminTime];
}

- (void)blokAdminTime
{    
    if(intFrom==0 && intTo==0)
        return;
        
    if(intFrom==00)
        intFrom = 23;
//    else
//        intFrom = intFrom-1;
    
    if(intFrom<intTo)
    {
        //SameDay
        int intFromMin = intFrom*60;
        int intToMin = intTo*60;
        [viewTouch blokTimeFromMin:intFromMin toTime:intToMin];
    }
    else if(intFrom>=intTo)
    {
        int intFromMin = intFrom*60;
        int intToMin = intTo*60;
        
        [viewTouch blokTimeFromMin:intFromMin toTime:1440];
        [viewTouch blokTimeFromMin:0 toTime:intToMin];
    }
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    scrlBG.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    viewTouch.frame = CGRectMake(0, 0, frame.size.width, (60*24)+20);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
