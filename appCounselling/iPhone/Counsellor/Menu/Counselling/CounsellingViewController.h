//
//  CounsellingViewController.h
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "BaseViewController.h"

@interface CounsellingViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arrPendings;
    NSMutableArray *arrAccepted;
    
    UIButton *btnAccepted;
    UIButton *btnPending;
    UIView *viewSelectedIndicator;
    
    UITableView *tblAppointments;
    UILabel *lblNoAppointment;
}
@property(nonatomic) NSString *strTitle;
@property(nonatomic) UIButton *btnAccepted;
@property(nonatomic) UIButton *btnPending;

- (void)btnAcceptedPendingClicked:(UIButton *)sender;
- (void)clearMemory;

@end
