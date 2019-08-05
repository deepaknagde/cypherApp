//
//  RateView.m
//  appCounselling
//
//  Created by MindCrew Technologies on 29/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "RateView.h"

@implementation RateView

@synthesize strQuestionText;
- (instancetype)initWithQuestion:(NSString *)strQuestion
{
    self = [super init];
    if (self) {
        self.strQuestionText = strQuestion;
        [self baseInit];
    }
    return self;
}

- (void)setStrQuestionText:(NSString *)strQuestion
{
    strQuestionText = strQuestion;
    
    lblTitle.frame = CGRectMake(15, 5, self.frame.size.width -30, 30);
    lblTitle.text = strQuestionText;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
        
    }
    return self;
}

-(void)baseInit{
    
    self.rating = [NSNumber numberWithInt:0];
    
    self.backgroundColor = [UIColor colorWithRed:33/255.0f green:52/255.0f blue:70/255.0f alpha:1.0];
    
    lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, self.frame.size.width -10, 30)];
    lblTitle.text = @"How helpful was this support organisation?";
    lblTitle.numberOfLines = 2;
    lblTitle.adjustsFontSizeToFitWidth =YES;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    
    
    [self addSubview:lblTitle];
    
    UIButton *hideBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height-27.5, self.frame.size.width, 27.5)];
    [hideBtn setBackgroundImage:[UIImage imageNamed:@"submitBtn"] forState:UIControlStateNormal];
    [hideBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hideBtn];
    

    self.starRatingView = [[DXStarRatingView alloc]initWithFrame:CGRectMake(5, 45, self.frame.size.width-10, 40)];
    
    [self.starRatingView setStars:0 callbackBlock:^(NSNumber *newRating) {
        _rating = newRating;
    }];
    
    [self addSubview:self.starRatingView];
    
    CGRect frame = self.starRatingView.frame;
    frame.origin.x = self.frame.size.width/2 - frame.size.width/2;
    self.starRatingView.frame = frame;
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
    }
    else
    {
        lblTitle.adjustsFontSizeToFitWidth = NO;
        lblTitle.font = [UIFont systemFontOfSize:12.0];
        lblTitle.frame = CGRectMake(5, 5, self.frame.size.width -10, 40);
        hideBtn.frame = CGRectMake(0, hideBtn.frame.origin.y-10, self.frame.size.width, 37.5);
    }

}
- (void)didChangeRating:(NSNumber*)newRating
{
    self.rating = newRating;
}

-(void)hide{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(submittClickedForRattingView:)])
        [self.delegate submittClickedForRattingView:self];
    else
        [self.delegate hideRateView:self.rating];
}

@end
