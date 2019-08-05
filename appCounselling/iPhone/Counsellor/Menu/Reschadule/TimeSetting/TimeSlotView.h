//
//  TimeSlotView.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 09/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerEventHandleView.h"

@protocol TimeSlotViewDelegate <NSObject>

@optional
- (void)timeSelectedInMins:(int)intMins;

@end

@interface TimeSlotView : UIView <TimerEventHandleViewDelegate>
{
    UIScrollView *scrlBG;
    TimerEventHandleView *viewTouch;
    NSInteger intMinimumTimeMins;
}

@property(nonatomic, strong) NSMutableDictionary *dictBlokedSlots;
@property(nonatomic, strong) NSString *strKey;

@property(nonatomic) NSInteger timeInterval;
@property(nonatomic) NSInteger timeDuration;

@property(nonatomic) NSInteger intMinimumTimeMins;
@property(nonatomic, assign) __unsafe_unretained id <TimeSlotViewDelegate>delegate;

@property(nonatomic) int intFrom;
@property(nonatomic) int intTo;


@end
