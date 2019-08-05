//
//  SetAvailabilityViewController.h
//  appCounselling
//
//  Created by MindCrew Technologies on 14/06/17.
//  Copyright © 2017 MindcrewTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SetAvailabilityViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    int intSelectedOption;
    
    UIView *viewSetTime;
    UIButton *btnFrom;
    UIButton *btnTo;
    
    UIDatePicker *pickerFrom;
    UIDatePicker *pickerTo;
    
    UITableView *tblDays;
    NSMutableArray *arrDays;
    
    NSMutableArray *arrTimeSlots;
    
    UIButton *btnSave;
    
}

@property(nonatomic) NSMutableArray *arrTimeSlots;
@end
