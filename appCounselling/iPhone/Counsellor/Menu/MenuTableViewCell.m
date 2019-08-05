//
//  MenuTableViewCell.m
//  HumbleBabies
//
//  Created by MindCrew Technologies on 10/12/16.
//  Copyright © 2016 iLabours. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@synthesize imgMenuTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    // Initialization code
    self.opaque = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.clipsToBounds = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    imgMenuTitle = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 240, 36)];
    imgMenuTitle.alpha = 0.9;
    imgMenuTitle.backgroundColor = [UIColor clearColor];
    imgMenuTitle.layer.masksToBounds = YES;
    imgMenuTitle.clipsToBounds = YES;
    imgMenuTitle.userInteractionEnabled = NO;
    imgMenuTitle.image = [UIImage imageNamed:@"menuCellBG.png"];
    [self addSubview:imgMenuTitle];
    [self bringSubviewToFront:imgMenuTitle];
 
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
