//
//  CounsellorAppointmentViewController.h
//  appCounselling
//
//  Created by MindCrew Technologies on 06/12/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CounsellorAppointmentViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tblAppointments;
    NSMutableArray *arrAppointment;
    NSMutableArray *arrRating;
}


@property(nonatomic) NSString *strTitle;

@end
