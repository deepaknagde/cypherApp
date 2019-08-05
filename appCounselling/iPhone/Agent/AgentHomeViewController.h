//
//  AgentHomeViewController.h
//  appCounselling
//
//  Created by MindCrew Technologies on 24/12/16.
//  Copyright © 2016 MindcrewTechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "MenuView.h"

@interface AgentHomeViewController : BaseViewController <UITextFieldDelegate, MenuViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>
{
    UITextField *txtFieldAgentPointName;
    UITextField *txtFieldAgentMobileNumber;
    UITextField *txtFieldNameOfYP;
    UITextField *txtFieldMobileNumberYP;
    UITextField *txtFieldNumberOfSession;
    
    UIView *viewPicker;
    UIPickerView *pickerCountryCode;
    NSMutableArray *arrCountryCode;
    BOOL isYoungPerson;
    NSString *strCountryCode;
    NSString *strCountryCodeYP;
    NSString *strCountryCodeAgent;
    
    UITableView *tblAppointments;
    NSMutableArray *arrAppointment;
}

@end
