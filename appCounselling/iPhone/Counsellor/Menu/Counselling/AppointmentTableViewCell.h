//
//  AppointmentTableViewCell.h
//  appCounselling
//
//  Created by MindCrew Technologies on 26/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@protocol AppointmentTableViewCellDelegate;
@interface AppointmentTableViewCell : UITableViewCell
{
    AppDelegate *appDelegate;
    UILabel *lblFriendRequest;
    UILabel *lblMode;
    
    UILabel *lblAppointmentOrder;
    UILabel *lblSuggested;

    UIButton *btnAccept;
    UIButton *btnDeniey;
    UIButton *btnReschedule;
    UIButton *btnGoAssesmetform;
}

@property(nonatomic, strong) UIButton *btnAccept;
@property(nonatomic, strong) UIButton *btnDeniey;
@property(nonatomic, strong) UIButton *btnReschedule;
@property(nonatomic, strong) UIButton *btnGoAssesmetform;

@property(nonatomic,assign)__unsafe_unretained id <AppointmentTableViewCellDelegate>delegate;

- (void)setParameter:(NSDictionary *)dictAppointment;
- (void)setParameterForReschedule:(NSDictionary *)dictAppointment;

@end


@protocol AppointmentTableViewCellDelegate <NSObject>

@optional
- (void)btnAcceptClicked:(UIButton *)sender;
@optional
- (void)btnDenieyClicked:(UIButton *)sender;
@optional
- (void)btnRescheduleClicked:(UIButton *)sender;
@optional
- (void)btnGoAssesmetformClicked:(UIButton *)sender;

@end
