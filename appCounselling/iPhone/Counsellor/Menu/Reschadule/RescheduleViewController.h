//
//  RescheduleViewController.h
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "BaseViewController.h"

@interface RescheduleViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tblAppointments;
    NSMutableArray *arrPending;
    
    UILabel *lblNoAppointment;
}

@property(nonatomic) NSString *strTitle;

@end
