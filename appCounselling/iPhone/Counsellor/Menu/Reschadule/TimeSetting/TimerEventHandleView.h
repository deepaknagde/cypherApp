//
//  TimerEventHandleView.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 09/09/16.
//  Copyright © 2016 iDevz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimerEventHandleViewDelegate <NSObject>

@optional
- (void)enableScroll:(int)intmins;
@optional
- (void)diableScroll;

@end

@interface TimerEventHandleView : UIView
{
    UILabel *viewSlot;
    CGFloat lastMin;
    UILabel *lblMinsToSlide;
}
@property(nonatomic, strong) NSMutableDictionary *dictBlokedSlots;
@property(nonatomic, strong) NSString *strKey;

@property(nonatomic) NSInteger timeInterval;
@property(nonatomic) NSInteger timeDuration;
@property(nonatomic) NSInteger timeForBreak;

@property(nonatomic) NSInteger intMinimumTimeMins;

@property(nonatomic) int intFrom;
@property(nonatomic) int intTo;

@property(nonatomic, assign) __unsafe_unretained id <TimerEventHandleViewDelegate>delegate;

- (void)blokTimeFromMin:(int)intFrom toTime:(int)intTo;

@end
