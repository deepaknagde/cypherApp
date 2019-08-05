//
//  LiveViewController.h
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "BaseViewController.h"

@interface LiveViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString *strType;
    NSString *strFrom7Days;
    NSString *strTo7Days;
    
    
    NSMutableArray *arrAcceptedAppointments;
    NSMutableArray *arrPendingRatting;
    NSMutableArray *arrOldAppointmentPendingRatting;
    UILabel *lblNoAppointment;
    
    BOOL isCommingFromRatting;
    BOOL isCommingFromCounselling;
    
    UIView *viewSetTime;
    UIButton *btnFrom;
    UIButton *btnTo;
    
    int intSelectedOption;
    
    UIDatePicker *pickerFrom;
    UIDatePicker *pickerTo;
    UIButton *btnSubmit;
    
    UITableView *tblOption;
    NSMutableArray *arrOption;
    
    UITableView *tblDays;

    NSMutableArray *arrDays;
    NSMutableArray *arrTimeSlots;
    
    UITextField *txtFieldAgeRange;
    UIPickerView *pickerAgeRange;
    
    NSString *strFromAge;
    NSString *strToAge;
}
@property(nonatomic) BOOL isCommingFromRatting;
@property(nonatomic) BOOL isCommingFromCounselling;

@property(nonatomic) NSString *strTitle;

- (void)refreshlivePage;

@end
