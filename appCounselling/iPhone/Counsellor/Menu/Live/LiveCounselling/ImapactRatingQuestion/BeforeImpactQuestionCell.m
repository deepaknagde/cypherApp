//
//  BeforeImpactQuestionCell.m
//  Silent Secret
//
//  Created by MindCrew Technologies on 21/03/17.
//  Copyright © 2017 iDevz. All rights reserved.
//

#import "BeforeImpactQuestionCell.h"
#import "AppDelegate.h"

@implementation BeforeImpactQuestionCell

@synthesize delegate;

@synthesize dictQuestion;

@synthesize lblQuestion;
@synthesize btnRat1;
@synthesize btnRat2;
@synthesize btnRat3;
@synthesize btnRat4;
@synthesize btnRat5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Initialization code
    self.opaque = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.clipsToBounds = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
        if(screenWidth>=768)
            screenWidth = 600;
    
    lblQuestion = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenWidth-110, 44)];
    lblQuestion.userInteractionEnabled = NO;
    lblQuestion.numberOfLines = 2;
    lblQuestion.font = [UIFont systemFontOfSize:14.0];
    lblQuestion.backgroundColor = [UIColor clearColor];
    lblQuestion.textColor = [UIColor blackColor];
    [self addSubview:lblQuestion];
    [self bringSubviewToFront:lblQuestion];
    
    btnRat1 = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-100, 0, 44, 44)];
    [btnRat1 setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    btnRat1.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnRat1];
    [self bringSubviewToFront:btnRat1];

    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(btnRat1.frame.origin.x+34, 0, 12, 44)];
    lbl1.font = [UIFont systemFontOfSize:14.0];
    lbl1.text = @"0";
    lbl1.backgroundColor = [UIColor clearColor];
    lbl1.textColor = [UIColor blackColor];
    [self addSubview:lbl1];
    [self bringSubviewToFront:lbl1];

    btnRat2 = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-50, 0, 44, 44)];
    [btnRat2 setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    btnRat2.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnRat2];
    [self bringSubviewToFront:btnRat2];

    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(btnRat2.frame.origin.x+34, 0, 12, 44)];
    lbl2.font = [UIFont systemFontOfSize:14.0];
    lbl2.text = @"1";
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.textColor = [UIColor blackColor];
    [self addSubview:lbl2];
    [self bringSubviewToFront:lbl2];

    btnRat3 = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth, 0, 44, 44)];
    [btnRat3 setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    btnRat3.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnRat3];
    [self bringSubviewToFront:btnRat3];

    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(btnRat3.frame.origin.x+34, 0, 12, 44)];
    lbl3.font = [UIFont systemFontOfSize:14.0];
    lbl3.text = @"2";
    lbl3.backgroundColor = [UIColor clearColor];
    lbl3.textColor = [UIColor blackColor];
    [self addSubview:lbl3];
    [self bringSubviewToFront:lbl3];

    btnRat4 = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth+50, 0, 44, 44)];
    [btnRat4 setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    btnRat4.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnRat4];
    [self bringSubviewToFront:btnRat4];

    UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(btnRat4.frame.origin.x+34, 0, 12, 44)];
    lbl4.font = [UIFont systemFontOfSize:14.0];
    lbl4.text = @"3";
    lbl4.backgroundColor = [UIColor clearColor];
    lbl4.textColor = [UIColor blackColor];
    [self addSubview:lbl4];
    [self bringSubviewToFront:lbl4];

    btnRat5 = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth+100, 0, 44, 44)];
    [btnRat5 setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    btnRat5.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnRat5];
    [self bringSubviewToFront:btnRat5];

    UILabel *lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(btnRat5.frame.origin.x+34, 0, 12, 44)];
    lbl5.font = [UIFont systemFontOfSize:14.0];
    lbl5.text = @"4";
    lbl5.backgroundColor = [UIColor clearColor];
    lbl5.textColor = [UIColor blackColor];
    [self addSubview:lbl5];
    [self bringSubviewToFront:lbl5];

    lbl1.textAlignment = NSTextAlignmentRight;
    lbl2.textAlignment = NSTextAlignmentRight;
    lbl3.textAlignment = NSTextAlignmentRight;
    lbl4.textAlignment = NSTextAlignmentRight;
    lbl5.textAlignment = NSTextAlignmentRight;
    
    [btnRat1 setTitle:@"0" forState:UIControlStateDisabled];
    [btnRat2 setTitle:@"1" forState:UIControlStateDisabled];
    [btnRat3 setTitle:@"2" forState:UIControlStateDisabled];
    [btnRat4 setTitle:@"3" forState:UIControlStateDisabled];
    [btnRat5 setTitle:@"4" forState:UIControlStateDisabled];
    
    return self;
}

- (void)setRatingOfTheQuestion
{
    btnRat1.userInteractionEnabled = NO;
    btnRat2.userInteractionEnabled = NO;
    btnRat3.userInteractionEnabled = NO;
    btnRat4.userInteractionEnabled = NO;
    btnRat5.userInteractionEnabled = NO;

    
    [btnRat1 setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    [btnRat2 setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    [btnRat3 setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    [btnRat4 setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    [btnRat5 setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    
    NSString *strRating = [self.dictQuestion objectForKey:@"ratting"];
    if(strRating==nil)
        return;
    
//    self.backgroundColor = [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1];

    switch (strRating.integerValue) {
        case 0:
            [btnRat1 setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [btnRat2 setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [btnRat3 setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [btnRat4 setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
            break;
        case 4:
            [btnRat5 setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
