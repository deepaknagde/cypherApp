//
//  RateView.h
//  appCounselling
//
//  Created by MindCrew Technologies on 29/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXStarRatingView.h"


@class RateView;

@protocol RateViewDelegate <NSObject>

@optional
-(void)hideRateView:(NSNumber *)rating;

@optional
- (void)submittClickedForRattingView:(RateView *)viewRate;
@end


@interface RateView : UIView
{
    UILabel *lblTitle;
}
@property (strong, nonatomic) DXStarRatingView *starRatingView;

@property (strong, nonatomic)UIButton *doneBtn;
@property (nonatomic, assign) id <RateViewDelegate> delegate;

@property NSNumber *rating;

//COUNSELLOR RATTING
@property (strong, nonatomic)NSString *strQuestionText;
- (instancetype)initWithQuestion:(NSString *)strQuestion;


@end