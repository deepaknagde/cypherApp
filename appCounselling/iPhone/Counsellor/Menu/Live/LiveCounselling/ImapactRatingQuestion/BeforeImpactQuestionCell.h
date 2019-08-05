//
//  BeforeImpactQuestionCell.h
//  Silent Secret
//
//  Created by MindCrew Technologies on 21/03/17.
//  Copyright © 2017 iDevz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@protocol BeforeImpactQuestionCellDelegate;
@interface BeforeImpactQuestionCell : UITableViewCell
{
    AppDelegate *appDelegate;
    
    UILabel *lblQuestion;
    
    UIButton *btnRat1;
    UIButton *btnRat2;
    UIButton *btnRat3;
    UIButton *btnRat4;
    UIButton *btnRat5;
    
    
}

@property(nonatomic, assign) __unsafe_unretained id <BeforeImpactQuestionCellDelegate>delegate;

@property(nonatomic, strong) NSMutableDictionary *dictQuestion;

@property(nonatomic, strong) UILabel *lblQuestion;
@property(nonatomic, strong) UILabel *lblQuestionNo;
@property(nonatomic, strong) UIButton *btnRat1;
@property(nonatomic, strong) UIButton *btnRat2;
@property(nonatomic, strong) UIButton *btnRat3;
@property(nonatomic, strong) UIButton *btnRat4;
@property(nonatomic, strong) UIButton *btnRat5;

- (void)setRatingOfTheQuestion;

@end

@protocol BeforeImpactQuestionCellDelegate <NSObject>

@optional
- (void)answerForQuestion:(NSMutableDictionary *)dictAnswer;

@end
